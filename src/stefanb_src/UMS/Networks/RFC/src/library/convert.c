/*
 * convert.c V0.7.01
 *
 * umsrfc.library/UMSRFCConvertUMSAddress()
 *
 * (c) 1994-95 Stefan Becker
 */

#include "umsrfc.h"

/* Constant strings */
static const char UserName[] = "rfc.username";

/* Replace ' ' with '_' in name */
static char *ConvertName(const char *name, char *buf)
{
 /* Name valid? */
 if (name) {
  /* Yes */
  char c;

  /* Copy name and replace ' ' with '_' */
  while (c = *name++) *buf++ = (c == ' ') ? '_' : c;

 } else {
  /* No name, use default */
  strcpy(buf, "Unknown");
  buf += 7;
 }

 /* Return new buffer position */
 return(buf);
}

__LIB_PREFIX BOOL UMSRFCConvertUMSAddress(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *addr,
             __LIB_ARG(A2) const char        *name,
             __LIB_ARG(A3) char              *buf
             /* __LIB_BASE */)
{
 struct PrivateURD *purd = (struct PrivateURD *) urd;
 BOOL rc                 = FALSE;

 /* Remote user? */
 if (addr) {
  /* Yes, convert address */
  ULONG len = strlen(addr);
  char *cp  = addr + len;

  if ((len > 5) && (stricmp(cp - 5, ".maus") == 0)) {
   /* Maus-Netz (German network)           */
   /* UMS: <boxname>.maus                  */
   /* RFC: Real_Name@<boxname><mausdomain> */

   /* Convert name */
   buf = ConvertName(name, buf);

   /* Add box name and domain */
   rc      = TRUE;
   len    -= 5;
   *buf++  = '@';
   strncpy(buf, addr, len);                        /* Copy box name   */
   strcpy(buf + len, purd->purd_ExportMausDomain); /* Add domain name */

  } else if ((len > 8) && (stricmp(cp - 8, "@fidonet") == 0)) {
   /* Fidonet                                                    */
   /* UMS: <zone>:<hub>/<node>[.<point>]@fidonet                 */
   /* RFC: Real_Name@p<point>.f<node>.n<hub>.z<zone><fidodomain> */
   LONG zone,hub,node;

   /* Extract FTN parameters */
   zone = strtol(addr    , &addr, 10);
   hub  = strtol(addr + 1, &addr, 10);
   node = strtol(addr + 1, &addr, 10);

   /* Convert name */
   buf = ConvertName(name, buf);

   /* Build RFC address */
   rc     = TRUE;
   *buf++ = '@';
   if (*addr == '.') {
    LONG point = strtol(addr + 1, &addr, 10);
    buf += psprintf(buf, "p%d.", point);
   }
   psprintf(buf, "f%d.n%d.z%d%s", node, hub, zone,
                                  purd->purd_ExportFIDODomain);

  } else {
   /* RFC address, don't convert, copy only */
   strcpy(buf, addr);
   rc = TRUE;
  }

 } else {
  /* Local user, retrieve rfc.username */
  const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
  UMSAccount account            = purd->purd_Public.urd_Account;
  char *cp;

  /* Get user name from UMS config */
  if (cp = TAGCALL(UMSReadConfigTags)(UMSBASE account,
                                      UMSTAG_CfgUser, name,
                                      UMSTAG_CfgName, UserName,
                                      TAG_DONE)) {
   /* Build address */
   psprintf(buf, "%s@%s", cp, purd->purd_Public.urd_DomainName);

   /* Free user name */
   UMSFreeConfig(account, cp);

   /* All OK. */
   rc = TRUE;

  } else {
   /* Error, no name found */
   TAGCALL(UMSLog)(UMSBASE account, 4,
                    "UMSRFC: No 'rfc.username' defined for user '%s'!\n"
                    "        Using default 'UNKNOWN'",
                    name);

   /* BUT build a "valid" address */
   psprintf(buf, "UNKNOWN@%s", purd->purd_Public.urd_DomainName);
  }
 }

 return(rc);
}
