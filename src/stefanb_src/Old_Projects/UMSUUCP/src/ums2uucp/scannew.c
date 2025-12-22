/*
 * scannew.c  V0.7.04
 *
 * scan message base for new messages
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "ums2uucp.h"

static ULONG MailOut=0;
static ULONG NewsOut=0;
UMSMsgTextFields MsgFields;
struct MessageData MessageData;

/* Scan new messages */
BOOL ScanNew(ULONG mask)
{
 BOOL rc=FALSE;

 /* Init Mail export */
 if (InitMailExport()) {

  /* Init News export */
  if (InitNewsExport()) {

   /* Reset error flag */
   rc=TRUE;

   /* Select all new articles */
   if (UMSSelectTags(Account,/* Read user flags. Select all messages with    */
                             /* read & view access (and an additional select */
                             /* bit) which have not been read.               */
                             UMSTAG_SelMask,  UMSUSTATF_ReadAccess |
                                              UMSUSTATF_ViewAccess |
                                              UMSUSTATF_Read | mask,
                             UMSTAG_SelMatch, UMSUSTATF_ReadAccess |
                                              UMSUSTATF_ViewAccess |
                                              mask,

                             /* Set local select bit on each new message */
                             UMSTAG_SelWriteLocal, TRUE,
                             UMSTAG_SelSet,        SELBIT,

                             TAG_DONE)) {
    /* all new messages are selected now */
    UMSMsgNum msgnum=0;

    /* Get configuration data */
    GetConversionData();
    GetRouteData();
    GetRFCData();

    /* Scan all selected messages (from low to high) */
    while (rc && (msgnum=UMSSearchTags(Account,UMSTAG_SearchLast,      msgnum,
                                               UMSTAG_SearchDirection, 1,
                                               UMSTAG_SearchLocal,     TRUE,
                                               UMSTAG_SearchMask,      SELBIT,
                                               UMSTAG_SearchMatch,     SELBIT,
                                               TAG_DONE)))
     /* Read message */
     if (ReadUMSMsgTags(Account,UMSTAG_RMsgNum,       msgnum,
                                UMSTAG_RTextFields,   MsgFields,
                                UMSTAG_RReadAll,      TRUE,
                                UMSTAG_RChainUp,      &MessageData.md_ChainUp,
                                UMSTAG_RHardLink,     &MessageData.md_HardLink,
                                UMSTAG_RSoftLink,     &MessageData.md_SoftLink,
                                UMSTAG_RMsgDate,      &MessageData.md_MsgDate,
                                UMSTAG_RHeaderLength, &MessageData.md_HeaderLen,
                                UMSTAG_RTextLength,   &MessageData.md_TextLen,
                                TAG_DONE)) {
      /* Message read, export it */
      BOOL mail=(MsgFields[UMSCODE_Group] == NULL);

      /* Mail or news message? */
      if (mail) {
       if (rc=ExportMail(msgnum)) MailOut++;
      } else
       if (rc=ExportNews(msgnum)) NewsOut++;

      /* Message processed, free it */
      FreeUMSMsg(Account,msgnum);

     } else {
      /* Couldn't read message?????? Log error */
      UMSDebugLog(0,"Couldn't read message %d, aborting! UMS-Error: %d - %s\n",
                    msgnum,UMSErrNum(Account),UMSErrTxt(Account));

      /* Quit loop */
      rc=FALSE;
     }

    /* Free configuration data */
    FreeRFCData();
    FreeRouteData();
    FreeConversionData();

    /* Log end message */
    ulog(-1,"exported %d mails and %d news articles",MailOut,NewsOut);

   } else
    /* Nothing to export... */
    ulog(-1,"nothing to export!");

    /* Finish News export */
   if (!FinishNewsExport()) rc=FALSE;

  } else
   /* Error in news export initialization */
   ulog(-1,"error in news export init");

  /* Finish Mail export */
  if (!FinishMailExport()) rc=FALSE;

 } else
  /* Error in mail export initialization */
  ulog(-1,"error in mail export init");

 return(rc);
}
