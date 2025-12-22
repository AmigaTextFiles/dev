/*
 * receive.c V1.0.00
 *
 * UMS NNTP (server) receive article
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsnntpd.h"

/* Receive article from remote client */
BOOL ReceiveArticle(struct UMSRFCData *urd, const char *greeting, ULONG length)
{
 BOOL rc = FALSE;

 /* Create temporary file name */
 sprintf(TempBuffer, "T:UMSNNTPD_%d", FindTask(NULL));

 /* Open temporary output file */
 if (OutputData.od_Handle = Open(TempBuffer, MODE_NEWFILE)) {
  char *buf;

  /* Send response to remote client */
  Send(NNTPDSocket, greeting, length, 0);

  /* Get article from client */
  if (buf = ReadMessageFromSocket(&InputData)) {

   DEBUGLOG(kprintf("Article length: %ld\n", InputData.id_MsgLength - 1);)

   /* Process message */
   if (UMSRFCReadMessage(urd, buf, FALSE, TRUE)) {
    char *nextgroup = (char *) urd->urd_NewsTags[UMSRFC_TAGS_GROUP].ti_Data;

    /* Group field valid? */
    if (nextgroup) {
     UMSAccount Account = urd->urd_Account;
     UMSMsgNum oldnum   = 0;    /* linked (crossposted) messages */
     BOOL hidden        = TRUE; /* detect 'hidden' messages */

     /* Reset error flag */
     rc = TRUE;

     do {
      char *group      = nextgroup;
      UMSMsgNum newnum;

      /* Scan newsgroup line for ',' */
      if (nextgroup = strchr(nextgroup, ',')) {
       char c;

       /* another group -> remove ',' and set string terminator */
       *nextgroup = '\0';

       /* Skip white space */
       while ((c = *++nextgroup) && ((c == ' ') || (c == '\t')));
      }

      /* Group name valid? */
      if (*group != '\0')

       /* Yes, write message, save message number */
       if (newnum = UMSRFCPutNewsMessage(urd, group, oldnum)) {

        /* Save message number */
        oldnum = newnum;

        /* Message written */
        hidden = FALSE;

       } else if (UMSErrNum(Account) != UMSERR_NoWriteAccess) {
        char *id = (char *) urd->urd_NewsTags[UMSRFC_TAGS_MSGID].ti_Data;

        /* No dupe, real error! */
        UMSRFCLog(urd, "UMS error: %d - %s, msg-id <%s>\n",
                  UMSErrNum(Account), UMSErrTxt(Account),
                  id ? id : "none");
        rc = FALSE;
       }

      /* Repeat as long as news groups specified */
     } while (rc && nextgroup);

     /* Hidden message? */
     if (hidden) {
      UMSRFCLog(urd, "Can't write article!\n");
      rc = FALSE;
     }

    } else
     /* No news article */
     UMSRFCLog(urd, "No news article!\n");

   } else
    /* Couldn't parse RFC message */
    UMSRFCLog(urd, "Couldn't parse RFC message!\n");

   /* Free message buffer */
   FreeMem(buf, InputData.id_MsgLength);
  }
 }

 return(rc);
}
