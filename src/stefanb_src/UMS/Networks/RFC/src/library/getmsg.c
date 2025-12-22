/*
 * getmsg.c V0.7.00
 *
 * umsrfc.library/UMSRFCGetMessage()
 *
 * (c) 1994 Stefan Becker
 */

#include "umsrfc.h"

/* Clear attributes data */
static void ClearAttributesData(struct AttributesData *ad)
{
 ad->ad_Alias          = NULL;
 ad->ad_MIME           = 0;
 ad->ad_ReceiptRequest = NULL;
 ad->ad_Urgent         = 0;
}

/* Clear RFC attributes data */
static void ClearRFCAttributesData(struct RFCAttributesData *rad)
{
 rad->rad_Misc = NULL;
}

__LIB_PREFIX BOOL UMSRFCGetMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(D0) UMSMsgNum msgnum
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 struct UMSRFCMsgData *urmd    = &purd->purd_Public.urd_MsgData;
 UMSAccount account            = purd->purd_Public.urd_Account;

 /* Set message number */
 urmd->urmd_MsgNum = msgnum;

 /* Read message */
 if (TAGCALL(UMSReadMsgTags)(UMSBASE account,
                              UMSTAG_RMsgNum,       msgnum,
                              UMSTAG_RTextFields,
                                              &purd->purd_Public.urd_MsgFields,
                              UMSTAG_RReadAll,      TRUE,
                              UMSTAG_RNoUpdate,     TRUE,
                              UMSTAG_RChainUp,      &urmd->urmd_ChainUp,
                              UMSTAG_RHardLink,     &urmd->urmd_HardLink,
                              UMSTAG_RSoftLink,     &urmd->urmd_SoftLink,
                              UMSTAG_RMsgDate,      &urmd->urmd_MsgDate,
                              UMSTAG_RMsgCDate,     &urmd->urmd_MsgCDate,
                              UMSTAG_RHeaderLength, &urmd->urmd_HeaderLen,
                              UMSTAG_RTextLength,   &urmd->urmd_TextLen,
                              TAG_DONE)) {

  /* Message read */
  const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;
  struct AttributesData *ad     = &purd->purd_AttributesData;

  /* Parse "Attributes" */
  {
   struct RDArgs *rda = purd->purd_AttrRDArgs;
   char *attr         = purd->purd_Public.urd_MsgFields[UMSCODE_Attributes];

   /* Initialize RDArgs for FreeArgs() */
   rda->RDA_DAList = NULL;

   /* Clear attributes data */
   ClearAttributesData(ad);

   /* "Attributes" specified? */
   if (attr) {

    /* Yes, parse it */
    ULONG len = strlen(attr);

    DEBUGLOG(kprintf("Get: Attributes '%s'\n", attr);)

    /* Append '\n' for ReadArgs() *GRMMMMLLLL* */
    attr[len] = '\n';

    /* Initialize data for ReadArgs() */
    rda->RDA_Source.CS_Buffer = attr;
    rda->RDA_Source.CS_Length = len + 1;
    rda->RDA_Source.CS_CurChr = 0;

    /* Parse "Attributes" field */
    if (!ReadArgs(UMSRFC_ATTRTEMPLATE, (LONG *) ad, rda))

     /* Error while parsing! Clear all attributes */
     ClearAttributesData(ad);

    DEBUGLOG(kprintf("Get: Alias '%s' MIME %ld RecReq '%s' Urgent %ld\n",
                      ad->ad_Alias, ad->ad_MIME, ad->ad_ReceiptRequest,
                      ad->ad_Urgent);)
   }
  }

  /* Parse "RFC Attributes" */
  {
   struct RFCAttributesData *rad = &purd->purd_RFCAttributesData;
   struct RDArgs *rda            = purd->purd_RFCAttrRDArgs;
   char *rfcattr                 =
                              purd->purd_Public.urd_MsgFields[UMSCODE_RfcAttr];

   /* Initialize RDArgs for FreeArgs() */
   rda->RDA_DAList = NULL;

   /* Clear RFC attributes data */
   ClearRFCAttributesData(rad);

   /* "RFC Attributes" specified? */
   if (rfcattr) {

    /* Yes, parse it */
    ULONG len = strlen(rfcattr);

    DEBUGLOG(kprintf("Get: RFC Attributes '%s'\n", rfcattr);)

    /* Append '\n' for ReadArgs() *GRMMMMLLLL* */
    rfcattr[len] = '\n';

    /* Initialize data for ReadArgs() */
    rda->RDA_Source.CS_Buffer = rfcattr;
    rda->RDA_Source.CS_Length = len + 1;
    rda->RDA_Source.CS_CurChr = 0;

    /* Parse "Attributes" field */
    if (!ReadArgs(UMSRFC_RFCATTRTEMPLATE, (LONG *) rad, rda))

     /* Error while parsing! Clear all attributes */
     ClearRFCAttributesData(rad);

    DEBUGLOG(kprintf("Get: Misc 0x08lx\n", rad->rad_Misc);)
   }
  }

  {
   char *fromaddr  = purd->purd_Public.urd_MsgFields[UMSCODE_FromAddr];
   char *alias     = ad->ad_Alias;
   BOOL gotaddress = FALSE;

   /* Local sender and alias specified? */
   if (!fromaddr && alias) {
    char *name;

    /* Check alias */
    if (name = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                           UMSTAG_CfgUserName, alias,
                                           TAG_DONE)) {

     /* Is alias a real alias of the user? */
     if (strcmp(purd->purd_Public.urd_MsgFields[UMSCODE_FromName], name)
          == 0) {

      /* Yes, build address with alias */
      psprintf(purd->purd_Public.urd_FromAddress, "%s@%s", alias,
                purd->purd_Public.urd_DomainName);
      gotaddress = TRUE;
     }

     /* Free UMS config var */
     UMSFreeConfig(account, name);
    }
   }

   /* RFC address created? If not, create RFC address from FromAddr/Name */
   if (gotaddress ||
       UMSRFCConvertUMSAddress((struct UMSRFCData *) purd, fromaddr,
                             purd->purd_Public.urd_MsgFields[UMSCODE_FromName],
                             purd->purd_Public.urd_FromAddress))

    /* Message read */
    return(TRUE);
  }

  FreeArgs(purd->purd_RFCAttrRDArgs);
  FreeArgs(purd->purd_AttrRDArgs);
  UMSFreeMsg(account, msgnum);
 }

 return(FALSE);
}
