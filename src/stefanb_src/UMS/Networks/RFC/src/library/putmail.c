/*
 * putmail.c V0.8.01
 *
 * umsrfc.library/UMSRFCPutMailMessage()
 *
 * (c) 1994-95 Stefan Becker
 */

#include "umsrfc.h"

/* Use improved UMS server dupe checking */
#define USE_UMSSERVER_DUPE_CHECK

__LIB_PREFIX UMSMsgNum UMSRFCPutMailMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *recipient
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 const UMSAccount account      = purd->purd_Public.urd_Account;
 struct TagItem *tags          = purd->purd_Public.urd_MailTags;
 UMSMsgNum rc                  = 0;

 /* Try without soft-link first */
 tags[UMSRFC_TAGS_SOFTLINK].ti_Tag = TAG_IGNORE;

 /* Mail for local or remote user? */
 if (strpbrk(recipient, "!@%:")) {
  /* Remote user. Parse recipient address */
  UMSRFCConvertRFCAddress(urd, recipient, purd->purd_Buffer1,
                                          purd->purd_Buffer2);

  /* Set name and path */
  tags[UMSRFC_TAGS_TONAME].ti_Data = (ULONG) purd->purd_Buffer2;
  tags[UMSRFC_TAGS_TOADDR].ti_Data = (ULONG) purd->purd_Buffer1;
 } else {
  /* Local user. Set name and empty address */
  tags[UMSRFC_TAGS_TONAME].ti_Data = (ULONG) recipient;
  tags[UMSRFC_TAGS_TOADDR].ti_Data = (ULONG) NULL;
 }

#ifdef USE_UMSSERVER_DUPE_CHECK
 /* Put message into UMS system, check for receipt request */
 rc = UMSWriteMsg(account, tags);

#else
 /* Put message into UMS system */
 if ((rc = UMSWriteMsg(account, tags)) == 0) {

  /* Something has gone wrong... */
  UMSMsgNum orignum;

  /* Dupe? If yes, then search the original message */
  if ((UMSErrNum(account) == UMSERR_Dupe) &&
      (orignum = TAGCALL(UMSSearchTags)(UMSBASE account,
                                        UMSTAG_WMsgID,
                                             tags[UMSRFC_TAGS_MSGID].ti_Data,
                                        TAG_DONE))) {
   /* Found original message */
   char *toaddr     = (char *) tags[UMSRFC_TAGS_TOADDR].ti_Data;
   char *toname     = (char *) tags[UMSRFC_TAGS_TONAME].ti_Data;
   UMSMsgNum msgnum = orignum;
   BOOL nodupe      = TRUE;

   /* Check for real dupe */
   do {
    char *origtoname, *origtoaddr;
    UMSMsgNum nextnum;

    /* Read next original message */
    if (!TAGCALL(UMSReadMsgTags)(UMSBASE account,
                                 UMSTAG_RMsgNum,   msgnum,
                                 UMSTAG_RSoftLink, &nextnum,
                                 UMSTAG_RToName,   &origtoname,
                                 UMSTAG_RToAddr,   &origtoaddr,
                                 TAG_DONE)) {
     /* Couldn't read message, must be a severe error, leave loop */
     nodupe = FALSE; /* ERROR! */
     break;
    }

    /* Check for different recipient */
    if (toaddr) {
     if (origtoaddr) nodupe = (strcmp(toaddr, origtoaddr) != 0);
    } else
     if (!origtoaddr) nodupe = (strcmp(toname, origtoname) != 0);

    /* Free message */
    UMSFreeMsg(account, msgnum);

    /* Next message */
    msgnum = nextnum;

    /* Continue loop until original message is reached again */
   } while (nodupe && msgnum && (msgnum != orignum));

   /* Real dupe? */
   if (nodupe) {
    /* No, add as softlink */
    tags[UMSRFC_TAGS_SOFTLINK].ti_Tag  = UMSTAG_WSoftLink;
    tags[UMSRFC_TAGS_SOFTLINK].ti_Data = orignum;

    /* Write message */
    rc = UMSWriteMsg(account, tags);
   }
  }
 }
#endif

 return(rc);
}
