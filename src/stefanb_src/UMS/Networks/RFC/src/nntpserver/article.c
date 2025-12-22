/*
 * article.c V1.0.03
 *
 * UMS NNTP (server) article & group handling
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsnntpd.h"

/* Constant strings */
       const char NoGroupSelected[] = INTTOSTR(NNTP_NO_GROUP_SELECTED)
                                       " no newsgroup has been selected\r\n";
static const char NoSuchArticle[]   = INTTOSTR(NNTP_NO_SUCH_ARTICLE_FOUND)
                                       " no such article found\r\n";
static const char CantReadArticle[] = INTTOSTR(NNTP_PROGRAM_FAULT)
                                       " couldn't retrieve article\r\n";

static const struct TagItem ResetGroupBit[] = {
 UMSTAG_SelMask,       0,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelUnset,      SELECTF_GROUP,
 TAG_DONE
};

/* Local data */
static char  *MsgBuffer = NULL;
static char  *EndOfHeader;
static ULONG  MsgLength;
static char   IDBuffer[BUFLEN];

/* Global data */
ULONG CurrentArticle;
ULONG MaxArticles;

/* Free message buffer */
void FreeMsgBuffer(void)
{
 /* Message buffer valid? */
 if (MsgBuffer) {

  DEBUGLOG(kprintf("Freeing message buffer 0x%08lx, length %ld\n", MsgBuffer,
                                                                   MsgLength);)

  /* Yes, free buffer */
  FreeMem(MsgBuffer, MsgLength + 1);

  /* Reset pointers */
  MsgBuffer   = NULL;
  MsgLength   = 0;
  EndOfHeader = NULL;
 }
}

/* Get end of RFC header in message buffer */
static void GetEndOfHeader(void)
{
 /* End of header pointer == NULL? */
 if (EndOfHeader == NULL)

  /* Yes, look out for "\r\n\r\n" */
  EndOfHeader = strstr(MsgBuffer, "\r\n\r\n");
}

/* Get message ID from argument */
static char *GetMsgID(char *args)
{
 char *ep;

 /* Check for valid message id */
 if ((*args++ == '<') && (ep = strchr(args, '>'))) {
  /* Set string terminator */
  *ep = '\0';
  return(args);
 }

 /* No message ID found */
 return(NULL);
}

/* Read Article from UMS message base to message buffer */
static BOOL GetArticle(struct UMSRFCData *urd, UMSMsgNum msgnum)
{
 BOOL rc = FALSE;

 /* Get message from UMS message base */
 if (UMSRFCGetMessage(urd, msgnum)) {

  /* Check if group field is valid (we don't want to send mail via NNTP :-) */
  if (urd->urd_MsgFields[UMSCODE_Group]) {
   BPTR outfile;

   /* Create temporary file name */
   sprintf(TempBuffer, "T:UMSNNTPD_%d", FindTask(NULL));

   /* Open temporary output file */
   if (outfile = Open(TempBuffer, MODE_NEWFILE)) {
    ULONG len;
    char *buf;

    /* Before reading the new message, free old message first */
    FreeMsgBuffer();

    /* Reset output data */
    OutputData.od_Handle  = outfile;
    OutputData.od_Counter = 0;

    /* Write UMS message as RFC message into temporary file */
    UMSRFCWriteMessage(urd, OutputFunction, &OutputData, TRUE);

    /* Flush buffer */
    Write(outfile, OutBuffer, OutputData.od_Counter);

    /* Move to beginning of file */
    len = Seek(outfile, 0, OFFSET_BEGINNING);

    /* Allocate memory for article */
    if ((len > 2) && (buf = AllocMem(len + 1, MEMF_PUBLIC))) {

     DEBUGLOG(kprintf("Allocating message buffer 0x%08lx, length %ld\n",
                      buf, len);)

     /* Read file into buffer */
     if (Read(outfile, buf, len) == len) {

      /* Add string terminator */
      buf[len] = '\0';

      /* New article is now in buffer, set pointers */
      MsgBuffer = buf;
      MsgLength = len;

      /* Copy message ID */
      strcpy(IDBuffer, urd->urd_MsgFields[UMSCODE_MsgID]);

      /* Set return code */
      rc = TRUE;

     } else
      /* Couldn't read file, free buffer */
      FreeMem(buf, len + 1);
    }

    /* Close & delete output file */
    Close(outfile);
    DeleteFile(TempBuffer);
   }
  }

  /* Free UMS message */
  UMSRFCFreeMessage(urd);
 }
 return(rc);
}

/* Handle GROUP command */
void HandleGROUPCommand(struct UMSRFCData *urd, char *args)
{
 UMSAccount Account = urd->urd_Account;
 UMSMsgNum msgnum;
 BOOL error         = TRUE;

 /* Group valid? Search group */
 if (*args &&
     (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      0,
                                      UMSTAG_SearchDirection, 1,
                                      UMSTAG_SearchMask,      UMSUSTATF_ViewAccess,
                                      UMSTAG_SearchMatch,     UMSUSTATF_ViewAccess,
                                      UMSTAG_WGroup,          args,
                                      UMSTAG_SearchQuick,     TRUE,
                                      TAG_DONE))) {
  /* Group found */
  ULONG count;

  /* Reset Local Bit 15 */
  UMSSelect(Account, ResetGroupBit);

  /* Set Local Bit 15 on all messages in Group */
  UMSSelectTags(Account, UMSTAG_WGroup,        args,
                         UMSTAG_SelQuick,      TRUE,
                         UMSTAG_SelStart,      msgnum,
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelSet,        SELECTF_GROUP,
                         TAG_DONE);

  /* Reset Local Bit 15 on all messages without ViewAccess */
  UMSSelectTags(Account, UMSTAG_SelMask,       UMSUSTATF_ViewAccess,
                         UMSTAG_SelMatch,      0,
                         UMSTAG_SelStart,      msgnum,
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelUnset,      SELECTF_GROUP,
                         TAG_DONE);

  /* Count messages in group */
  count = UMSSelectTags(Account, UMSTAG_SelReadLocal,  TRUE,
                                 UMSTAG_SelMask,       SELECTF_GROUP,
                                 UMSTAG_SelMatch,      SELECTF_GROUP,
                                 UMSTAG_SelStart,      msgnum,
                                 UMSTAG_SelWriteLocal, TRUE,
                                 TAG_DONE);

  DEBUGLOG(kprintf("Selected group '%s' (%ld msgs)\n", args, count);)

  /* Read article into buffer */
  if (GetArticle(urd, msgnum)) {
   ULONG len;

   /* Set pointers */
   CurrentArticle = 1;
   MaxArticles    = count;

   /* Create & send response */
   len = sprintf(TempBuffer, INTTOSTR(NNTP_GROUP_SELECTED)
                              " %d 1 %d %s group selected\r\n",
                              count, count, args);
   Send(NNTPDSocket, TempBuffer, len, 0);

   /* Reset error flag */
   error = FALSE;
  }
 }

 /* No group found */
 if (error) Send(NNTPDSocket, INTTOSTR(NNTP_NO_SUCH_GROUP)
                               " no such news group\r\n", 24, 0);
}

/* Retrieve next/previous article from group */
void MoveCurrentPointer(struct UMSRFCData *urd, LONG direction)
{
 /* Group selected? */
 if (CurrentArticle) {
  UMSMsgNum msgnum;

  /* Search next/previous article */
  if (msgnum = UMSSearchTags(urd->urd_Account,
                              UMSTAG_SearchLast,      urd->urd_MsgData.urmd_MsgNum,
                              UMSTAG_SearchDirection, direction,
                              UMSTAG_SearchLocal,     TRUE,
                              UMSTAG_SearchMask,      SELECTF_GROUP,
                              UMSTAG_SearchMatch,     SELECTF_GROUP,
                              TAG_DONE)) {

   /* Read article */
   if (GetArticle(urd, msgnum)) {
    ULONG len;

    /* Create & send status response */
    len = sprintf(TempBuffer, INTTOSTR(NNTP_ARTICLE_RETRIEVED_STAT)
                               " %d <%s> article retrieved -"
                               " request text seperately\r\n",
                               CurrentArticle += direction, IDBuffer);
    Send(NNTPDSocket, TempBuffer, len, 0);

   } else
    Send(NNTPDSocket, CantReadArticle, sizeof(CantReadArticle) - 1, 0);

  } else
   if (direction > 0)
    Send(NNTPDSocket, INTTOSTR(NNTP_NO_NEXT_ARTICLE)
                       " no next article in this group\r\n", 35, 0);
   else
    Send(NNTPDSocket, INTTOSTR(NNTP_NO_PREVIOUS_ARTICLE)
                       " no previous article in this group\r\n", 39, 0);

 } else
  Send(NNTPDSocket, NoGroupSelected, sizeof(NoGroupSelected) - 1, 0);
}

/* Retrieve on article and send it to remote client */
void RetrieveArticle(struct UMSRFCData *urd, UBYTE action, char *args)
{
 char *response;
 ULONG responselen;

 /* Article selected by message ID? */
 if (response = GetMsgID(args)) {
  /* Yes, article was selected by message ID */
  UMSAccount Account = urd->urd_Account;
  UMSMsgNum msgnum;

  /* Search article */
  if (msgnum = UMSSearchTags(Account, UMSTAG_WMsgID,      response,
                                      UMSTAG_SearchQuick, TRUE,
                                      TAG_DONE)) {
   /* Article found, retrieve it */
   if (GetArticle(urd, msgnum)) {
    /* Article retrieved */
    response = NULL;

   } else {
    /* Couldn't read article */
    response    = CantReadArticle;
    responselen = sizeof(CantReadArticle) - 1;
   }

  } else {
   /* Article not found */
   response    = NoSuchArticle;
   responselen = sizeof(NoSuchArticle) - 1;
  }

 } else {
  /* No, article was selected by number */

  /* Argument specified? */
  if (*args) {

   /* Yes, retrieve article by article number. Group selected? */
   if (CurrentArticle) {
    ULONG number;

    /* Get article number */
    if ((number = strtol(args, NULL, 10)) && (number <= MaxArticles)) {
     UMSAccount Account = urd->urd_Account;
     UMSMsgNum msgnum;

     /* Search article */
     {
      ULONG count;
      LONG direction;

      /* Select direction & start number */
      if (number >= CurrentArticle) {

       /* Start from current article */
       msgnum    = urd->urd_MsgData.urmd_MsgNum;
       count     = number - CurrentArticle;
       direction = 1; /* Forward search */

      } else {
       ULONG diff;

       /* Nearer to 0 or current article? */
       if ((diff = CurrentArticle - number) > number) {

        /* Nearer to 0 */
        msgnum    = 0;
        count     = number;
        direction = 1; /* Forward search */

       } else {
        /* Nearer to current article */
        msgnum    = urd->urd_MsgData.urmd_MsgNum;
        count     = diff;
        direction = -1; /* Backward search */
       }
      }

      DEBUGLOG(kprintf(
           "Current: %ld, Number: %ld, Count: %ld, Direction: %ld from: %ld\n",
           CurrentArticle, number, count, direction, msgnum);)

      /* Scan group */
      while (count--)

       /* Search next article in group */
       if (!(msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                             UMSTAG_SearchDirection, direction,
                                             UMSTAG_SearchLocal,     TRUE,
                                             UMSTAG_SearchMask,      SELECTF_GROUP,
                                             UMSTAG_SearchMatch,     SELECTF_GROUP,
                                             TAG_DONE)))
        break; /* Error */
     }

     /* Article found? */
     if (msgnum) {

      /* Article found, retrieve it */
      if (GetArticle(urd, msgnum)) {
       /* Article retrieved */
       CurrentArticle = number;
       response       = NULL;

      } else {
       /* Couldn't read article */
       response    = CantReadArticle;
       responselen = sizeof(CantReadArticle) - 1;
      }

     } else {
      /* Article not found */
      response    = NoSuchArticle;
      responselen = sizeof(NoSuchArticle) - 1;
     }

    } else {
     /* Article not found */
     response    = NoSuchArticle;
     responselen = sizeof(NoSuchArticle) - 1;
    }

   } else {
    /* No group selected */
    response    = NoGroupSelected;
    responselen = sizeof(NoGroupSelected) - 1;
   }

   /* No argument specified, current article valid? */
  } else if (MsgBuffer) {

   /* Yes, article retrieved */
   response = NULL;

  } else {
   /* No current article selected */
   response    = INTTOSTR(NNTP_NO_CURRENT_ARTICLE)
                  " no current article has been selected\r\n";
   responselen = 42;
  }
 }

 /* Article retrieved? */
 if (response) {
  /* No, send response */
  Send(NNTPDSocket, response, responselen, 0);

 } else {
  /* Yes, send response based on supplied action code */
  ULONG status;

  /* Which status response is needed? */
  switch (action) {
   case ACTION_STAT:    status   = NNTP_ARTICLE_RETRIEVED_STAT;
                        response = "request text seperately";
                        break;

   case ACTION_HEAD:    status   = NNTP_ARTICLE_RETRIEVED_HEAD;
                        response = "head follows";
                        break;

   case ACTION_BODY:    status   = NNTP_ARTICLE_RETRIEVED_BODY;
                        response = "body follows";
                        break;

   case ACTION_ARTICLE: status   = NNTP_ARTICLE_RETRIEVED;
                        response = "head and body follow";
                        break;
  }

  /* Create & send status response */
  responselen = sprintf(TempBuffer, "%d %d <%s> article retrieved - %s\r\n",
                                    status, CurrentArticle, IDBuffer, response);
  Send(NNTPDSocket, TempBuffer, responselen, 0);

  /* Send text response (if any) */
  switch (action) {
   case ACTION_STAT:    /* No text response */
                        break;

   case ACTION_HEAD:    /* Send article header, followed by "\r\n.\r\n" */
                        GetEndOfHeader();
                        Send(NNTPDSocket, MsgBuffer, EndOfHeader - MsgBuffer,
                                          0);
                        Send(NNTPDSocket, "\r\n.\r\n", 5, 0);
                        break;

   case ACTION_BODY:    /* Send article body, followed by "\r\n.\r\n" */
                        GetEndOfHeader();
                        Send(NNTPDSocket, EndOfHeader + 4,
                                          MsgLength - 4 -
                                           (EndOfHeader - MsgBuffer),
                                          0);
                        Send(NNTPDSocket, "\r\n.\r\n", 5, 0);
                        break;

   case ACTION_ARTICLE: /* Send complete article, followed by "\r\n.\r\n" */
                        Send(NNTPDSocket, MsgBuffer, MsgLength, 0);
                        Send(NNTPDSocket, "\r\n.\r\n", 5, 0);
                        break;
  }
 }
}
