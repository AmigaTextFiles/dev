/*
 * getarticle.c V1.0.01
 *
 * UMS NNTP (client) get news article and write it as UMS message
 *
 * (c) 1994-98 by Stefan Becker
 */

#include "umsnntp.h"

/* Request & retrieve article */
void GetArticle(struct HandlerData *hd, const char *cmd, ULONG len)
{
 /* Request article from server */
 if (SendNNTPCommand(&hd->hd_CommandData, cmd, len)
      == NNTP_ARTICLE_RETRIEVED) {
  struct Library *DOSBase = hd->hd_Bases.urb_DOSBase;

  DEBUGLOG(kprintf("(%08lx) Retrieving article\n", FindTask(NULL));)

  /* Open temporary file */
  if (hd->hd_OutputData.od_Handle = Open(hd->hd_FileName, MODE_NEWFILE)) {
   char *buf;

   /* Get article from server */
   if (buf = ReadMessageFromSocket(&hd->hd_InputData)) {
    struct Library *UMSBase    = hd->hd_Bases.urb_UMSBase;
    struct Library *UMSRFCBase = hd->hd_UMSRFCBase;
    struct UMSRFCData *urd     = hd->hd_URData;

    /* Process message */
    if (UMSRFCReadMessage(urd, buf, FALSE, TRUE)) {
     char *nextgroup = (char *)
                        urd->urd_NewsTags[UMSRFC_TAGS_GROUP].ti_Data;

     /* Group field valid? */
     if (nextgroup) {
      UMSAccount account = urd->urd_Account;
      UMSMsgNum oldnum   = 0;    /* linked (crossposted) messages */

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
       if (*group)

        /* Yes, write message, save message number */
        if (newnum = UMSRFCPutNewsMessage(urd, group, oldnum))

         /* Save message number */
         oldnum = newnum;

        /* Real error? */
        else if (UMSErrNum(account) != UMSERR_NoWriteAccess)

         /* Leave loop */
         break;

       /* Repeat as long as news groups specified */
      } while (nextgroup);
     }
    }

    /* Free message buffer */
    {
     struct Library *SysBase = hd->hd_SysBase;
     FreeMem(buf, hd->hd_InputData.id_MsgLength);
    }
   }
  }

  DEBUGLOG(kprintf("(%08lx) Article retrieved\n", FindTask(NULL));)
 }
}
