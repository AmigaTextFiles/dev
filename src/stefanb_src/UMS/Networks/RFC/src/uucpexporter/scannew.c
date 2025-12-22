/*
 * scannew.c  V1.0.00
 *
 * scan message base for new messages
 *
 * (c) 1992-97 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Local data */
static ULONG MailOut = 0;
static ULONG NewsOut = 0;

/* Scan new messages */
BOOL ScanNew(ULONG mask)
{
 BOOL rc = FALSE;

 /* Init Mail export */
 if (InitMailExport()) {

  /* Init News export */
  if (InitNewsExport()) {

   /* Reset error flag */
   rc = TRUE;

   /* Select all new articles */
   if (UMSSelectTags(Account,

                     /* Read user flags. Select all messages with read & */
                     /* view access (and an additional select bit) which */
                     /* have not been read.                              */
                     UMSTAG_SelMask,  UMSUSTATF_ReadAccess |
                                      UMSUSTATF_ViewAccess |
                                      UMSUSTATF_Old | mask,
                     UMSTAG_SelMatch, UMSUSTATF_ReadAccess |
                                      UMSUSTATF_ViewAccess |
                                      mask,

                     /* Set local select bit on each new message */
                     UMSTAG_SelWriteLocal, TRUE,
                     UMSTAG_SelSet,        SELBIT,

                     TAG_DONE)) {

    /* all new messages are selected now */
    UMSMsgNum msgnum = 0;

    /* Unselect "parked" messages */
    UMSSelectTags(Account,

                  /* Read global flags. Select all msgs with parked bit set */
                  UMSTAG_SelReadGlobal, TRUE,
                  UMSTAG_SelMask,       UMSGSTATF_Parked,
                  UMSTAG_SelMatch,      UMSGSTATF_Parked,

                  /* Clear local select bit on each message */
                  UMSTAG_SelWriteLocal, TRUE,
                  UMSTAG_SelUnset,      SELBIT,

                  TAG_DONE);

    /* Get configuration data */
    GetRouteData();

    /* Scan all selected messages */
    while (rc && (msgnum = UMSSearchTags(Account,

                                         /* Start with this message */
                                         UMSTAG_SearchLast,      msgnum,

                                         /* Search from low to high numbers */
                                         UMSTAG_SearchDirection, 1,

                                         /* Search for messages which have */
                                         /* the local select bit set       */
                                         UMSTAG_SearchLocal,     TRUE,
                                         UMSTAG_SearchMask,      SELBIT,
                                         UMSTAG_SearchMatch,     SELBIT,

                                         TAG_DONE)))

     /* Read new message */
     if (UMSRFCGetMessage(URData, msgnum)) {

      /* Message read, export it */
      BOOL mail = (URData->urd_MsgFields[UMSCODE_Group] == NULL);

      /* Mail or news message? */
      if (mail) {
       if (rc = ExportMail(msgnum)) MailOut++;
      } else
       if (rc = ExportNews(msgnum)) NewsOut++;

      /* Message processed, free it */
      UMSRFCFreeMessage(URData);

     } else {
      /* Couldn't read message?????? Log error */
      UMSLog(Account, 1,
              "Couldn't read message %ld, aborting! "
              "UMS-Error: %ld - %sOutputData.",
              msgnum, UMSErrNum(Account), UMSErrTxt(Account));

      /* Quit loop */
      rc = FALSE;
     }

    /* Free configuration data */
    FreeRouteData();

    /* Log end message */
    ulog(-1, "exported %d mails and %d news articles", MailOut, NewsOut);

   } else
    /* Nothing to export... */
    ulog(-1, "nothing to export!");

    /* Finish News export */
   if (!FinishNewsExport()) rc = FALSE;

  } else
   /* Error in news export initialization */
   ulog(-1, "error in news export init");

  /* Finish Mail export */
  if (!FinishMailExport()) rc = FALSE;

 } else
  /* Error in mail export initialization */
  ulog(-1, "error in mail export init");

 return(rc);
}
