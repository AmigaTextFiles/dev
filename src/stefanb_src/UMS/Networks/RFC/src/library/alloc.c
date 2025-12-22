/*
 * alloc.c V1.2.00
 *
 * umsrfc.library/UMSRFCAllocData()
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsrfc.h"

/* Constant strings */
static const char DomainName[] = "rfc.domainname";
static const char ExportAddr[] = "UMSRFC: Domain name for %s: %s";
static const char MissingVar[] = "UMSRFC: Missing configuration variable '%s'";

/* Constant tag items for initialization */
static struct TagItem MsgTags[]={
                                 /* Tags for mail messages   Index */
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
                                 TAG_DONE,             NULL, /* 17 */

                                 /* Tags for news articles   Index */
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
                                 UMSTAG_WHardLink,     NULL, /* 14 */
                                 UMSTAG_WGroup,        NULL, /* 15 */
                                 UMSTAG_WReplyGroup,   NULL, /* 16 */
                                 UMSTAG_WDistribution, NULL, /* 17 */
                                 UMSTAG_WHide,         NULL, /* 18 */
                                 TAG_DONE,             NULL  /* 19 */
                                };

/* Defaults for import addresses */
static const struct DomainList FIDODefault = {NULL,0,1,{".fidonet.org",12}};
static const struct DomainList MausDefault = {NULL,0,1,{".maus.de",8}};

/* Get one domain list */
static struct DomainList *GetDomainList(char *var)
{
 ULONG domains         = 0;
 struct DomainList *dl = NULL;

 /* Count domains */
 {
  char *cp = var;

  if (*cp) domains++;
  while (cp = strchr(cp, ',')) {
   domains++;
   cp++;
  }
 }

 /* Got any domains? */
 if (domains > 0) {
  ULONG len;

  /* Yes, calculate buffer length */
  len = sizeof(struct DomainList) + (domains - 1) * sizeof(struct DomainData);

  /* Allocate buffer */
  if (dl = AllocMem(len, MEMF_PUBLIC)) {
   struct DomainData *dd = &dl->dl_Data;
   char *ep              = var;

   /* Initialize structure */
   dl->dl_UMSVar  = var;
   dl->dl_Length  = len;
   dl->dl_Entries = domains;

   /* Initialize list */
   do {
    char *nextentry;

    /* Search next entry */
    if (nextentry = strchr(ep, ','))
     *nextentry++='\0'; /* Set string terminator */

    /* Initialize entry */
    dd->dd_Name   = ep;
    dd->dd_Length = strlen(ep);

    /* Get next entry */
    ep = nextentry;
    dd++;
   } while (ep);
  }
 }

 /* Return new domain list */
 return(dl);
}

/* Get import addresses */
static void GetImportAddresses(struct PrivateURD *purd)
{
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;
 char *cp;

 /* Get domain list for FIDO addresses */
 if (cp = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                     UMSTAG_CfgName, "rfc.import.fido",
                                     TAG_DONE)) {
  if (!(purd->purd_ImportFIDODomainList = GetDomainList(cp)))
   UMSFreeConfig(account, cp);
 } else
  purd->purd_ImportFIDODomainList = &FIDODefault; /* Set default value */

 /* Get domain list for Maus addresses */
 if (cp = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                     UMSTAG_CfgName, "rfc.import.maus",
                                     TAG_DONE)) {
  if (!(purd->purd_ImportMausDomainList = GetDomainList(cp)))
   UMSFreeConfig(account, cp);
 } else
  purd->purd_ImportMausDomainList = &MausDefault; /* Set default value */
}

/* Free import addresses */
void FreeImportAddresses(struct PrivateURD *purd)
{
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;
 struct DomainList *dl;

 /* Maus domain list valid? */
 if (dl = purd->purd_ImportMausDomainList) {
  char *vp;

  /* UMS var pointer valid? */
  if (vp = dl->dl_UMSVar) {
   UMSFreeConfig(account, vp);
   FreeMem(dl, dl->dl_Length);
  }
 }

 /* FIDO domain list valid? */
 if (dl = purd->purd_ImportFIDODomainList) {
  char *vp;

  /* UMS var pointer valid? */
  if (vp = dl->dl_UMSVar) {
   UMSFreeConfig(account, vp);
   FreeMem(dl, dl->dl_Length);
  }
 }
}

/* Get all export addresses */
static void GetExportAddresses(struct PrivateURD *purd)
{
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;

 /* Read UMS config var for FIDO domain */
 if (purd->purd_ExportFIDODomain = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                    UMSTAG_CfgName, "rfc.export.fido",
                                    TAG_DONE))
  purd->purd_Flags |= PURDF_FIDO;
 else
  purd->purd_ExportFIDODomain = ".fidonet.org"; /* Set default value */
 TAGCALL(UMSLog)(UMSBASE account, 9, ExportAddr,
                                     "FIDO", purd->purd_ExportFIDODomain);

 /* Read UMS config var for Maus domain */
 if (purd->purd_ExportMausDomain = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                    UMSTAG_CfgName, "rfc.export.maus",
                                    TAG_DONE))
  purd->purd_Flags |= PURDF_MAUS;
 else
  purd->purd_ExportMausDomain = ".maus.de"; /* Set default value */
 TAGCALL(UMSLog)(UMSBASE account, 9, ExportAddr,
                                     "Maus", purd->purd_ExportMausDomain);
}

/* Free export addresses */
void FreeExportAddresses(struct PrivateURD *purd)
{
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;
 ULONG flags                   = purd->purd_Flags;

 if (flags & PURDF_MAUS) UMSFreeConfig(account, purd->purd_ExportMausDomain);
 if (flags & PURDF_FIDO) UMSFreeConfig(account, purd->purd_ExportFIDODomain);
}

/* Read encoding type from UMS variable */
static ULONG GetEncodingType(struct PrivateURD *purd, const char *var)
{
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;
 ULONG rc                      = ENCODE_NONE;
 char *cp;

 if (cp = TAGCALL(UMSReadConfigTags)(UMSBASE account, UMSTAG_CfgName, var,
                                                      TAG_DONE)) {
  /* Read number & sanity check */
  if ((rc = strtol(cp, NULL, 10)) > ENCODE_BASE64) rc = ENCODE_NONE;

  /* Free UMS var */
  UMSFreeConfig(account, cp);
 }

 /* Return encodint type */
 return(rc);
}

/* umsrfc.library/AllocUMSRFCData() */
__LIB_PREFIX struct UMSRFCData *UMSRFCAllocData(
             __LIB_ARG(A0) const struct UMSRFCBases *urb,
             __LIB_ARG(A1) const char *user,
             __LIB_ARG(A2) const char *password,
             __LIB_ARG(A3) const char *server
             /* __LIB_BASE */)
{
 const struct Library *UMSBase = urb->urb_UMSBase;
 UMSAccount account;

 DEBUGLOG(kprintf("Alloc: User '%s' Password '%s' Server '%s'\n",
                  user, password, server);)

 /* Login into UMS */
 if (account = UMSRLogin(server, user, password)) {
  /* We now have access to UMS */
  struct PrivateURD *purd;

  DEBUGLOG(kprintf("Alloc: Account 0x%08lx\n", account);)

  /* Allocate UMSRFCData */
  if (purd = AllocMem(sizeof(struct PrivateURD), MEMF_PUBLIC)) {
   const struct Library *DOSBase = urb->urb_DOSBase;
   struct RDArgs *rda;

   DEBUGLOG(kprintf("Alloc: PrivateURD 0x%08lx\n", purd);)

   /* Allocate RDArgs for Attributes */
   if (rda = AllocDosObject(DOS_RDARGS, NULL)) {

    /* Initialize data for ReadArgs() */
    purd->purd_AttrRDArgs = rda;
    rda->RDA_Buffer       = NULL;
    rda->RDA_ExtHelp      = NULL;
    rda->RDA_Flags        = RDAF_NOPROMPT;

    DEBUGLOG(kprintf("Alloc: AttrRDArgs 0x%08lx\n", rda);)

    /* Allocate RDArgs for Attributes */
    if (rda = AllocDosObject(DOS_RDARGS, NULL)) {

     /* Initialize data for ReadArgs() */
     purd->purd_RFCAttrRDArgs = rda;
     rda->RDA_Buffer          = NULL;
     rda->RDA_ExtHelp         = NULL;
     rda->RDA_Flags           = RDAF_NOPROMPT;

     DEBUGLOG(kprintf("Alloc: RFCAttrRDArgs 0x%08lx\n", rda);)

     /* Get domain name of the system */
     if (purd->purd_Public.urd_DomainName = TAGCALL(UMSReadConfigTags)(
                                             UMSBASE account,
                                             UMSTAG_CfgName, DomainName,
                                             TAG_DONE)) {

      /* Initialize data structure */
      purd->purd_Bases                            = *urb;
      purd->purd_Flags                            = 0;
      purd->purd_LogFile                          = NULL;
      purd->purd_Public.urd_Account               = account;
      purd->purd_Public.urd_Flags                 = UMSRFC_FLAGS_8BITALLOWED;
      purd->purd_Public.urd_MsgData.urmd_MsgCDate = 0;      /* For UMS V10 */

      /* Initialize tag item arrays */
      memcpy(purd->purd_Public.urd_MailTags, MsgTags, sizeof(MsgTags));

      /* Get domain addresses for import and export */
      GetImportAddresses(purd);
      GetExportAddresses(purd);

      /* Read UMS config vars for encoding types */
      purd->purd_MailEncodingType = GetEncodingType(purd, "rfc.mailencoding");
      purd->purd_NewsEncodingType = GetEncodingType(purd, "rfc.newsencoding");

      /* Does the system have a special path name? */
      if (purd->purd_Public.urd_PathName = TAGCALL(UMSReadConfigTags)(
                                            UMSBASE account,
                                            UMSTAG_CfgName, "rfc.pathname",
                                            TAG_DONE))

       /* Set flag to to release var on UMSRFCFreeData */
       purd->purd_Flags |= PURDF_PATHNAME;

      else
       /* No special path name, use domain name */
       purd->purd_Public.urd_PathName = purd->purd_Public.urd_DomainName;

      /* Does the system have no domain name (FQDN)? */
      {
       char *var;

       /* Read UMS config var */
       if (var = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                            UMSTAG_CfgName, "rfc.noownfqdn",
                                            TAG_DONE)) {
        /* Set flag */
        if ((*var == 'y') || (*var == 'Y'))
         purd->purd_Public.urd_Flags |= UMSRFC_FLAGS_NOOWNFQDN;

        /* Free UMS config war */
        UMSFreeConfig(account, var);
       }
      }

      /* Set time zone from Locale */
      {
       struct Library *LocaleBase;
       char *gmtbuf               = purd->purd_GMTOffsetString;

       /* Set default GMT offset */
       strcpy(gmtbuf, "-0000");

       /* Open locale library */
       if (LocaleBase = OpenLibrary("locale.library", 38)) {
        struct Locale *loc;

        /* Open default Locale */
        if (loc = OpenLocale(NULL)) {
         LONG gmtoff = 0;
         char *cp;

         /* Read Daylight Saving Time variable */
         if (cp = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                              UMSTAG_CfgName, "rfc.dstime",
                                              TAG_DONE)) {
          /* Set DST flag */
          if ((*cp == 'y') || (*cp == 'Y')) gmtoff = -60;

          /* Free UMS var */
          UMSFreeConfig(account, cp);
         }

         /* Locale open, get offset in minutes _FROM_ GMT */
         /* Translate to RFC822 GMT +/- HHMM format       */
         gmtoff += loc->loc_GMTOffset;

         /* Store GMT offset (in seconds) for RFC-822 time corrections */
         purd->purd_GMTOffset = gmtoff * 60;

         /* Negative offset? */
         if (gmtoff < 0) {
          /* Yes, that means "GMT +HHMM" */
          gmtbuf[0] = '+';
          gmtoff    = -gmtoff;
         }

         /* Print offset to GMT into date string */
         gmtbuf[4]  = gmtoff % 10 + '0';
         gmtoff    /= 10;
         gmtbuf[3]  = gmtoff %  6 + '0';
         gmtoff    /=  6;
         gmtbuf[2]  = gmtoff % 10 + '0';
         gmtoff    /= 10;
         gmtbuf[1]  = gmtoff %  6 + '0';

         /* Close Locale */
         CloseLocale(loc);
        }

        /* Close library */
        CloseLibrary(LocaleBase);
       }

      }

      /* All OK, return pointer to new data structure */
      return(purd);

      /*** NOT REACHED! ********
      if (purd->purd_Flags & PURDF_PATHNAME)
       UMSFreeConfig(account, purd->purd_Public.urd_PathName);
      FreeExportAddresses(purd);
      FreeImportAddresses(purd);
      *************************/

      UMSFreeConfig(account, purd->purd_Public.urd_DomainName);
     } else
      TAGCALL(UMSLog)(UMSBASE account, 1, MissingVar, DomainName);

     FreeDosObject(DOS_RDARGS, purd->purd_RFCAttrRDArgs);
    } else
     TAGCALL(UMSLog)(UMSBASE account, 1, "Couldn't allocate RFCAttrRDArg!");

    FreeDosObject(DOS_RDARGS, purd->purd_AttrRDArgs);
   } else
    TAGCALL(UMSLog)(UMSBASE account, 1, "Couldn't allocate AttrRDArg!");

   FreeMem(purd, sizeof(struct PrivateURD));
  } else
   TAGCALL(UMSLog)(UMSBASE account, 1,
                   "Couldn't allocate memory for UMSRFCData!");

  UMSLogout(account);
 }

 return(NULL);
}
