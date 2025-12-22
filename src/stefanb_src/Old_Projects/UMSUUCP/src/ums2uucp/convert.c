/*
 * convert.c  V0.8.01
 *
 * Convert UMS address to RFC address
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Configuration data */
static ULONG ConfigFlags=0;
#define CONFIGF_FIDO 0x01
#define CONFIGF_MAUS 0x02
#define CONFIGF_ZER  0x04
static char *FIDODomain=".fidonet.org";
static char *MausDomain=".maus.de";
static char *ZerDomain =".zer.sub.org";

/* Get conversion data */
void GetConversionData(void)
{
 char *cp;

 /* Read UMS config var for FIDO domain */
 if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_EXPORT "fido",
                                  TAG_DONE)) {
  /* Set pointer and flag */
  FIDODomain=cp;
  ConfigFlags|=CONFIGF_FIDO;
 }

 /* Read UMS config var for Maus domain */
 if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_EXPORT "maus",
                                  TAG_DONE)) {
  /* Set pointer and flag */
  MausDomain=cp;
  ConfigFlags|=CONFIGF_MAUS;
 }

 /* Read UMS config var for Zerberus domain */
 if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_EXPORT "zer",
                                  TAG_DONE)) {
  /* Set pointer and flag */
  ZerDomain=cp;
  ConfigFlags|=CONFIGF_ZER;
 }

 /* Debugging */
 ulog(1,"Domain names for address conversion:\n"
        " FIDO    : %s\n"
        " Maus    : %s\n"
        " Zerberus: %s",
        FIDODomain,MausDomain,ZerDomain);
}

/* Free conversion data */
void FreeConversionData(void)
{
 if (ConfigFlags & CONFIGF_ZER)  FreeUMSConfig(Account,ZerDomain);
 if (ConfigFlags & CONFIGF_MAUS) FreeUMSConfig(Account,MausDomain);
 if (ConfigFlags & CONFIGF_FIDO) FreeUMSConfig(Account,FIDODomain);
}

/* Replace ' ' with '_' in name */
static char *ConvertName(char *name, char *buf)
{
 /* Name valid? */
 if (name) {
  /* Yes */
  char c;

  /* Copy name and replace ' ' with '_' */
  while (c=*name++) *buf++ = (c == ' ') ? '_' : c;

 } else {
  /* No name, use default */
  strcpy(buf,"Unknown");
  buf+=7;
 }

 /* Return new buffer position */
 return(buf);
}

/* Convert a UMS address into a RFC address */
BOOL ConvertAddress(char *buf, char *name, char *addr)
{
 BOOL rc=FALSE;

 /* Remote user? */
 if (addr) {
  /* Yes, convert address */
  ULONG len=strlen(addr);
  char *cp=addr+len;

  if ((len>4) && (stricmp(cp-4,".zer")==0)) {
   /* Z-Netz (German network)                */
   /* UMS: <login name>@<boxname>.zer        */
   /* RFC: <login name>@<boxname><zerdomain> */

   /* Create address */
   len-=4;
   strncpy(buf,addr,len);     /* Copy login name and box name */
   strcpy(buf+len,ZerDomain); /* Add domain name */
   rc=TRUE;

  } else if ((len>5) && (stricmp(cp-5,".maus")==0)) {
   /* Maus-Netz (German network)           */
   /* UMS: <boxname>.maus                  */
   /* RFC: Real_Name@<boxname><mausdomain> */

   /* Convert name */
   buf=ConvertName(name,buf);

   /* Add box name and domain */
   len-=5;
   *buf++='@';
   strncpy(buf,addr,len);      /* Copy box name   */
   strcpy(buf+len,MausDomain); /* Add domain name */
   rc=TRUE;

  } else if ((len>8) && (stricmp(cp-8,"@fidonet")==0)) {
   /* Fidonet                                                    */
   /* UMS: <zone>:<hub>/<node>[.<point>]@fidonet                 */
   /* RFC: Real_Name@p<point>.f<node>.n<hub>.z<zone><fidodomain> */
   LONG zone,hub,node;

   /* Extract FTN parameters */
   zone=strtol(addr,&addr,10);
   hub=strtol(addr+1,&addr,10);
   node=strtol(addr+1,&addr,10);

   /* Convert name */
   buf=ConvertName(name,buf);

   /* Build RFC address */
   *buf++='@';
   if (*addr=='.') {
    LONG point=strtol(addr+1,&addr,10);
    buf+=sprintf(buf,"p%d.",point);
   }
   sprintf(buf,"f%d.n%d.z%d%s",node,hub,zone,FIDODomain);
   rc=TRUE;

  } else {
   /* RFC address, don't convert, copy only */
   strcpy(buf,addr);
   rc=TRUE;
  }

 } else {
  /* Local user, retrieve uucp.username */
  char *username;

  /* Get user name from UMS config */
  if (username=ReadUMSConfigTags(Account,
                                 UMSTAG_CfgUser, name,
                                 UMSTAG_CfgName, UMSUUCP_USERNAME,
                                 TAG_DONE)) {
   /* Build address */
   sprintf(buf,"%s@%s",username,DomainName);

   /* Free user name */
   FreeUMSConfig(Account,username);

   /* All OK. */
   rc=TRUE;
  } else {
   /* Error */
   fprintf(stderr,"Missing config variable '" UMSUUCP_USERNAME "' for "
                  "user '%s'. Check your config!\n", name);

   /* BUT build a "valid" address */
   sprintf(buf,"UNKNOWN@%s",DomainName);
  }
 }

 return(rc);
}
