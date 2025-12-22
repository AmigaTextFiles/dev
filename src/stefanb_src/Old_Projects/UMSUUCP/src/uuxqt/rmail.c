/*
 * rmail.c  V0.8.02
 *
 * process incoming mail files
 *
 * (c) 1992-1994 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Tag array for mail message */
struct TagItem MailTags[]={                            /* Index */
                           UMSTAG_WSubject,      NULL, /*  0 */
                           UMSTAG_WFromName,     NULL, /*  1 */
                           UMSTAG_WFromAddr,     NULL, /*  2 */
                           UMSTAG_WReplyName,    NULL, /*  3 */
                           UMSTAG_WReplyAddr,    NULL, /*  4 */
                           UMSTAG_WCreationDate, NULL, /*  5 */
                           UMSTAG_WMsgCDate,     NULL, /*  6 */
                           UMSTAG_WMsgID,        NULL, /*  7 */
                           UMSTAG_WReferID,      NULL, /*  8 */
                           UMSTAG_WOrganization, NULL, /*  9 */
                           UMSTAG_WNewsreader,   NULL, /* 10 */
                           UMSTAG_WMsgText,      NULL, /* 11 */
                           UMSTAG_WAttributes,   NULL, /* 12 */
                           UMSTAG_WComments,     NULL, /* 13 */
                           UMSTAG_WSoftLink,     NULL, /* 14 */
                           UMSTAG_WToName,       NULL, /* 15 */
                           UMSTAG_WToAddr,       NULL, /* 16 */
                           TAG_DONE
                          };

/* Process one RFC Mail */
BOOL ProcessRFCMail(char *recipient)
{
 BOOL rc=FALSE;

 /* Try without soft-link first */
 MailTags[MSGTAGS_LINK].ti_Tag=TAG_IGNORE;

 /* Mail for local or remote user? */
 if (strpbrk(recipient,"!@%:")) {
  /* Remote user. Parse recipient address */
  GetAddress(recipient,Tmp5Buffer,Tmp6Buffer,Tmp7Buffer);

  /* Set name and path */
  MailTags[MSGTAGS_TONAME].ti_Data=(ULONG) Tmp5Buffer;
  MailTags[MSGTAGS_TOADDR].ti_Data=(ULONG) Tmp6Buffer;
 } else {
  /* Local user. Set name and empty address */
  MailTags[MSGTAGS_TONAME].ti_Data=(ULONG) recipient;
  MailTags[MSGTAGS_TOADDR].ti_Data=NULL;
 }

 /* Put message into UMS system */
 if (WriteUMSMsg(Account,MailTags))
  /* All OK */
  rc=TRUE;

 else {
  /* Something has gone wrong... */
  UMSMsgNum orignum;

  /* Dupe? If yes, then search the original message */
  if ((UMSErrNum(Account)==UMSERR_Dupe) &&
      (orignum=UMSSearchTags(Account,
                             UMSTAG_WMsgID, MailTags[MSGTAGS_MSGID].ti_Data,
                             TAG_DONE))) {
   /* Found original message */
   char *toaddr=(char *) MailTags[MSGTAGS_TOADDR].ti_Data;
   char *toname=(char *) MailTags[MSGTAGS_TONAME].ti_Data;
   UMSMsgNum msgnum=orignum;
   BOOL nodupe=TRUE;

   /* Check for real dupe */
   do {
    char *origtoname,*origtoaddr;
    UMSMsgNum nextnum;

    /* Read next original message */
    if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,   msgnum,
                                UMSTAG_RSoftLink, &nextnum,
                                UMSTAG_RToName,   &origtoname,
                                UMSTAG_RToAddr,   &origtoaddr,
                                TAG_DONE)) {
     /* Couldn't read message, must be a severe error, leave loop */
     nodupe=FALSE; /* ERROR! */
     break;
    }

    /* Check for different recipient */
    if (toaddr) {
     if (origtoaddr) nodupe=(strcmp(toaddr,origtoaddr) != 0);
    } else
     if (!origtoaddr) nodupe=(strcmp(toname,origtoname) != 0);

    /* Free message */
    FreeUMSMsg(Account, msgnum);

    /* Next message */
    msgnum=nextnum;

    /* Continue loop until original message is reached again */
   } while (nodupe && msgnum && (msgnum!=orignum));

   /* Real dupe? */
   if (nodupe) {
    /* No, add as softlink */
    MailTags[MSGTAGS_LINK].ti_Tag=UMSTAG_WSoftLink;
    MailTags[MSGTAGS_LINK].ti_Data=orignum;

    /* Write message */
    if (WriteUMSMsg(Account,MailTags)) rc=TRUE;
   }
  }
 }

 return(rc);
}

int ReceiveMailFile(char *mailfile, char *mailbuf, char *recipient)
{
 int rc=RETURN_WARN;

 /* Filter CRs? */
 if (FilterCR) {
  char *rp=mailbuf,*wp=mailbuf;
  char c;

  /* Scan buffer */
  while (c=*rp++)
   /* CR found? */
   if (c!='\r') *wp++=c; /* No, copy character */

  /* Add string terminator */
  *wp='\0';
 }

 /* Process RFC Header */
 if (ScanRFCMessage(mailbuf,MailTags,TRUE)) {
  char *nextaddress;

  /* Process message */
  rc=RETURN_OK;

  /* Loop through all recipients */
  do {
   /* Scan for next address */
   if (nextaddress=strchr(recipient,' '))
    /* Another address found -> remove ' ' and add string terminator */
    *nextaddress='\0';

   /* Skip empty recipients */
   if (*recipient=='\0') continue;

   /* Process mail */
   if (ProcessRFCMail(recipient))
    /* All OK */
    MailGood();

   else {
    /* Error */
    int tmprc;

    /* Log error */
    if ((tmprc=LogUMSError("Mail",mailfile,"msg id",
                           (char *) MailTags[MSGTAGS_MSGID].ti_Data,
                           0))==RETURN_FAIL)
     nextaddress=NULL; /* Real error, break loop */

    /* Set error level */
    if (tmprc>rc) rc=tmprc;

    /* Count bad mail */
    MailBad();
   }

   /* Set pointer to next address */
   recipient=nextaddress+1;

   /* Loop until last recipient has been processed */
  } while (nextaddress);
 }
 return(rc);
}
