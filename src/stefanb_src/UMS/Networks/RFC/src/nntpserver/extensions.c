/*
 * extensions.c V1.0.02
 *
 * UMS NNTP (server) handle non-RFC 977 commands
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsnntpd.h"

/* Local defines */
#define XHDR_NONE       0
#define XHDR_SUBJECT    1
#define XHDR_FROM       2
#define XHDR_MSGID      3
#define XHDR_REFERENCES 4

/* Constant strings */
static const char LowerBoundError[] = INTTOSTR(NNTP_SYNTAX_ERROR)
                                       " incorrect lower bound\r\n";
static const char UpperBoundError[] = INTTOSTR(NNTP_SYNTAX_ERROR)
                                       " incorrect upper bound\r\n";

/* Print references recursively */
static ULONG RecurseReferences(UMSAccount account, UMSMsgNum msgnum, char *buf)
{
 ULONG      rc       = 0;
 char      *msgid;
 UMSMsgNum  refernum;

 /* Valid chain-up and can we read the data of the parent message? */
 if ((msgnum != 0) && UMSReadMsgTags(account, UMSTAG_RMsgNum,  msgnum,
                                              UMSTAG_RMsgID,   &msgid,
                                              UMSTAG_RChainUp, &refernum,
                                              TAG_DONE)) {
  /* Recurse into referid tree */
  rc  = RecurseReferences(account, refernum, buf);

  /* Append this referid */
  rc += sprintf(buf + rc, "<%s> ", msgid);

  UMSFreeMsg(account, msgnum);
 }

 /* Return new line length */
 return(rc);
}

/* Print header */
static ULONG PrintHeader(struct UMSRFCData *urd, char *buf, UMSMsgNum msgnum,
                         ULONG action)
{
 UMSAccount Account = urd->urd_Account;
 ULONG rc           = 0;

 /* Print header based on action */
 switch(action) {
  case XHDR_SUBJECT: {
    char *subject;

    if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,   msgnum,
                                UMSTAG_RSubject, &subject,
                                TAG_DONE))
     rc = sprintf(buf, "%s", subject);
   }
   break;

  case XHDR_FROM: {
    char *name;
    char *addr;

    if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,    msgnum,
                                UMSTAG_RFromName, &name,
                                UMSTAG_RFromAddr, &addr,
                                TAG_DONE)) {

     if (UMSRFCConvertUMSAddress(urd, addr, name, OutBuffer))
      rc = sprintf(buf, "\"%s\" <%s>", name, OutBuffer);
    }
   }
   break;

  case XHDR_MSGID: {
    char *msgid;

    if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,  msgnum,
                                UMSTAG_RMsgID,  &msgid,
                                TAG_DONE))
     rc = sprintf(buf, "<%s>", msgid);
   }
   break;

  case XHDR_REFERENCES: {
    UMSMsgNum refernum;

    if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,  msgnum,
                                UMSTAG_RChainUp, &refernum,
                                TAG_DONE))
     rc = RecurseReferences(Account, refernum, buf);
   }
   break;
 }

 /* Return additional length */
 return(rc);
}

/* Handle XHDR command */
BOOL HandleXHDRCommand(struct UMSRFCData *urd, char *args)
{
 char *range = NULL;
 BOOL rc     = TRUE;

 {
  char *ap = args;
  char  c;

  /* Skip first argument */
  while ((c = *++ap) && (c != ' ') && (c != '\t'));

  /* End of string reached? */
  if (c) {

   /* No, set string terminator */
   *ap = '\0';

   /* Skip white spave */
   while ((c = *++ap) && ((c == ' ') || (c == '\t')));

   /* Got second argument? */
   if (c) range = ap;
  }
 }

 /* Check arguments */
 if (range) {
  char *buf = TempBuffer;
  ULONG len;
  ULONG action;

  DEBUGLOG(kprintf("Header: '%s', Range: '%s'\n", args, range);)

  /* Set header tag */
  if (stricmp(args, "subject") == 0)
   /* Subject: */
   action = XHDR_SUBJECT;

  else if (stricmp(args, "from") == 0)
   /* From: */
   action = XHDR_FROM;

  else if (stricmp(args, "message-id") == 0)
   /* Message-ID: */
   action = XHDR_MSGID;

  else if (stricmp(args, "references") == 0)
   /* References: */
   action = XHDR_REFERENCES;

  else
   /* Header not supported, return dummy line */
   action = XHDR_NONE;

  /* Create status response */
  len = sprintf(buf, INTTOSTR(NNTP_ARTICLE_RETRIEVED_HEAD)
                      " %s header list follows\r\n", args);

  /* Message-ID or Range? */
  if (*range == '<') {
   /* Message-ID */
   char *ep;

   /* Message-ID correct? */
   if (ep = strrchr(++range, '>')) {
    UMSAccount Account = urd->urd_Account;
    UMSMsgNum msgnum;

    /* Set string terminator */
    *ep = '\0';

    /* Search article */
    if (msgnum = UMSSearchTags(Account, UMSTAG_WMsgID,      range,
                                        UMSTAG_SearchQuick, TRUE,
                                        TAG_DONE)) {
     char *group;

     /* Read article */
     if (UMSReadMsgTags(Account, UMSTAG_RMsgNum, msgnum,
                                 UMSTAG_RGroup,  &group,
                                 TAG_DONE)) {

      /* Check for mail messages */
      if (group) {
       ULONG hdrlen;

       /* Send status response */
       Send(NNTPDSocket, buf, len, 0);

       /* Create and send text response */
       len = sprintf(buf, "<%s> ", range);

       /* Header not valid? */
       if ((hdrlen = PrintHeader(urd, buf + len, msgnum, action)) == 0) {

        /* Yes, print dummy header */
        strcpy(buf + len, "(none)");
        len += 6;

       } else
        len += hdrlen;

       /* Append line terminator and send response */
       len += sprintf(buf + len, "\r\n");
       Send(NNTPDSocket, buf, len, 0);

       /* Send text response terminator */
       Send(NNTPDSocket, ".\r\n", 3, 0);

      } else
       /* Couldn't read article */
       Send(NNTPDSocket, INTTOSTR(NNTP_PROGRAM_FAULT)
                          " no news article\r\n", 21, 0);

      /* Free UMS message */
      UMSFreeMsg(Account, msgnum);

     } else
      /* Couldn't read article */
      Send(NNTPDSocket, INTTOSTR(NNTP_PROGRAM_FAULT)
                         " couldn't read article\r\n", 27, 0);

    } else
     /* Article not found */
     Send(NNTPDSocket, INTTOSTR(NNTP_NO_SUCH_ARTICLE)
                        " no such article\r\n", 21, 0);

   } else
    /* Message-ID incorrect */
    Send(NNTPDSocket, INTTOSTR(NNTP_SYNTAX_ERROR)
                       " incorrect message id\r\n", 26, 0);

  } else {
   /* Range */
   ULONG min;
   char *header;

   /* Get lower bound */
   if (min = strtol(range, &header, 10)) {
    ULONG max = 0;

    /* Limit to maximal article number */
    if (min > MaxArticles) min = MaxArticles;

    /* Get upper bound */
    if (*header == '\0')
     /* Upper == lower */
     max = min;

     /* Delimiter valid? */
    else if (*header == '-')

     /* Yes, upper limit specified? */
     if (*++header == '\0')

      /* No, set maximum */
      max = MaxArticles;

     else {
      /* Read upper limit */
      max = strtol(header, &header, 10);

      /* Limit to maximal article number */
      if (max > MaxArticles) max = MaxArticles;
     }

    /* Upper bound valid? */
    if (max) {
     /* Yes, start search */
     UMSAccount Account = urd->urd_Account;
     UMSMsgNum msgnum   = 0;
     ULONG current      = 1;

     DEBUGLOG(kprintf("Range: %ld - %ld\n", min, max);)

     /* Send status response */
     Send(NNTPDSocket, buf, len, 0);

     /* Scan group until upper limit of range is reached */
     while (TRUE)

      /* Search next message */
      if (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                          UMSTAG_SearchDirection, 1,
                                          UMSTAG_SearchLocal,     TRUE,
                                          UMSTAG_SearchMask,      SELECTF_GROUP,
                                          UMSTAG_SearchMatch,     SELECTF_GROUP,
                                          TAG_DONE)) {

       /* Counter in range? */
       if (current < min)
        /* Range not yet reached, do nothing */
        ;

       else if (current <= max) {
        ULONG hdrlen;

        /* In range, create text response */
        len  = sprintf(buf, "%d ", current);

        /* Header not valid? */
        if ((hdrlen = PrintHeader(urd, buf + len, msgnum, action)) == 0) {

         /* Yes, print dummy header */
         strcpy(buf + len, "(none)");
         len += 6;

        } else
         len += hdrlen;

        /* Append line terminator */
        len += sprintf(buf + len, "\r\n");

        /* Free UMS message */
        UMSFreeMsg(Account, msgnum);

        /* Send text response (Check for write errors) */
        if (Send(NNTPDSocket, buf, len, 0) < 0) {
         /* Set return code and leave loop */
         rc = FALSE;
         break;
        }

       } else
        /* End of range reached, leave loop */
        break;

       /* Increment counter */
       current++;

      } else
       /* Couldn't find next article */
       break;

     /* Send text response terminator */
     Send(NNTPDSocket, ".\r\n", 3, 0);

    } else
     /* Can't read upper bound */
     Send(NNTPDSocket, UpperBoundError, sizeof(UpperBoundError) - 1, 0);

   } else
    /* Can't read lower bound */
    Send(NNTPDSocket, LowerBoundError, sizeof(LowerBoundError) - 1, 0);
  }

 } else
  /* Syntax error, no second parameter */
  Send(NNTPDSocket, INTTOSTR(NNTP_SYNTAX_ERROR)
                     " second parameter missing\r\n", 30, 0);

 return(rc);
}

/* Handle XOVER command */
BOOL HandleXOVERCommand(struct UMSRFCData *urd, char *args)
{
 BOOL rc = TRUE;

 /* Group selected? */
 if (CurrentArticle) {
  ULONG min;
  ULONG max = 0;

  /* Parameter specified? */
  if (*args) {
   char *cp;

   /* Yes, get lower bound */
   if (min = strtol(args, &cp, 10)) {

    /* Limit to maximal article number */
    if (min > MaxArticles) min = MaxArticles;

    /* Get upper bound */
    if (*cp == '\0')
     /* Upper == lower */
     max = min;

     /* Delimiter valid? */
    else if (*cp == '-')

     /* Yes, upper limit specified? */
     if (*++cp == '\0')

      /* No, set maximum */
      max = MaxArticles;

     else {
      /* Read upper limit */
      max = strtol(cp, &cp, 10);

      /* Limit to maximal article number */
      if (max > MaxArticles) max = MaxArticles;
     }
   }
  } else {
   /* No parameters specified, use current article */
   min = CurrentArticle;
   max = CurrentArticle;
  }

  /* Lower bound valid? */
  if (min) {

   /* Upper bound valid? */
   if (max) {
    /* Yes, start search */
    UMSAccount Account = urd->urd_Account;
    UMSMsgNum msgnum   = 0;
    ULONG current      = 1;
    char *buf          = TempBuffer;

    DEBUGLOG(kprintf("Range: %ld - %ld\n", min, max);)

    /* Send status response */
    Send(NNTPDSocket, INTTOSTR(NNTP_OVERVIEW_FOLLOWS)
                       " overview information follows\r\n", 34, 0);

    /* Scan group until upper limit of range is reached */
    while (TRUE)

     /* Search next message */
     if (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                         UMSTAG_SearchDirection, 1,
                                         UMSTAG_SearchLocal,     TRUE,
                                         UMSTAG_SearchMask,      SELECTF_GROUP,
                                         UMSTAG_SearchMatch,     SELECTF_GROUP,
                                         TAG_DONE)) {

      /* Counter in range? */
      if (current < min)
       /* Range not yet reached, do nothing */
       ;

      else if (current <= max) {
       char      *subject, *name, *addr, *msgid;
       ULONG      cdate, date;
       UMSMsgNum  refernum;

       /* In range, read message */
       if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,   msgnum,
                                   UMSTAG_RSubject,  &subject,
                                   UMSTAG_RFromName, &name,
                                   UMSTAG_RFromAddr, &addr,
                                   UMSTAG_RMsgID,    &msgid,
                                   UMSTAG_RMsgDate,  &date,
                                   UMSTAG_RMsgCDate, &cdate,
                                   UMSTAG_RChainUp,  &refernum,
                                   TAG_DONE)) {
        ULONG len;

        /* Create text response, start with article number and subject */
        len = sprintf(buf, "%d\t%s\t", current, subject);

        /* Add address */
        if (UMSRFCConvertUMSAddress(urd, addr, name, OutBuffer))
         len += sprintf(buf + len, "\"%s\" <%s>", name, OutBuffer);

        /* Convert creation date, use receive date if cdate not valid */
        UMSRFCPrintTime(urd, cdate ? cdate : date, OutBuffer);

        /* Add date and message id */
        len += sprintf(buf + len, "\t%s\t<%s>\t", OutBuffer, msgid);

        /* Add references */
        len += RecurseReferences(Account, refernum, buf + len);

        /* Free UMS message */
        UMSFreeMsg(Account, msgnum);

        /* Finish response, byte count and line count are empty */
        len += sprintf(buf + len, "\t\t\r\n");

        /* Send text response (Check for write errors) */
        if (Send(NNTPDSocket, buf, len, 0) < 0) {
         /* Set return code and leave loop */
         rc = FALSE;
         break;
        }
       }

      } else
       /* End of range reached, leave loop */
       break;

      /* Increment counter */
      current++;

     } else
      /* Couldn't find next article */
      break;

    /* Send text response terminator */
    Send(NNTPDSocket, ".\r\n", 3, 0);

   } else
    /* Can't read upper bound */
    Send(NNTPDSocket, UpperBoundError, sizeof(UpperBoundError) - 1, 0);

  } else
   /* Can't read lower bound */
   Send(NNTPDSocket, LowerBoundError, sizeof(LowerBoundError) - 1, 0);

 } else
  /* No group selected */
  Send(NNTPDSocket, NoGroupSelected, 36, 0);

 return(rc);
}
