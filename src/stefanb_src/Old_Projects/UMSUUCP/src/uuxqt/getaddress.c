/*
 * getaddress.c  V0.7.01
 *
 * get and convert a RFC address
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "uuxqt.h"

static const char SpaceRep[]="_.";

struct DomainData {
 char  *dd_Name;   /* Pointer to domain name */
 ULONG  dd_Length; /* Length of domain name  */
};

struct DomainList {
 char              *dl_UMSVar;  /* Pointer to UMS config var */
 ULONG              dl_Length;  /* Buffer length             */
 ULONG              dl_Entries; /* Entries in this list      */
 struct DomainData  dl_Data;    /* Begin of array            */
};

/* Configuration data */
static const struct DomainList FIDODefault = {NULL,0,1,{".fidonet.org",12}};
static const struct DomainList MausDefault = {NULL,0,1,{".maus.de",8}};
static const struct DomainList ZerDefault  = {NULL,0,1,{".zer.sub.org",12}};
static UMSUserAccount ConfAccount;
static struct DomainList *FIDODomainList = &FIDODefault;
static struct DomainList *MausDomainList = &MausDefault;
static struct DomainList *ZerDomainList  = &ZerDefault;

/* Debugging */
static void PrintList(char *name, struct DomainList *dl)
{
 char *cp=MainBuffer;
 struct DomainData *dd;
 ULONG i;

 /* Intro */
 cp+=sprintf(cp,"Domain name list (%s):",name);

 /* Domain list valid? */
 if (dl)
  /* Yes, print list */
  for (i=dl->dl_Entries, dd=&dl->dl_Data; i; i--, dd++)
   cp+=sprintf(cp," %s (%d)",dd->dd_Name,dd->dd_Length);

  /* List empty */
 else
  strcpy(cp," <none>");

 /* Print buffer */
 ulog(1,MainBuffer);
}

/* Get one domain list */
static void GetDomainList(struct DomainList **dlp)
{
 char *vp;

 /* Get UMS config var */
 if (vp=ReadUMSConfigTags(ConfAccount,UMSTAG_CfgName,MainBuffer,
                                      TAG_DONE)) {
  ULONG domains=0;
  struct DomainList *dl=NULL;

  /* Count domains */
  {
   char *cp=vp;
   if (*cp) domains++;
   while (cp=strchr(cp,',')) {
    domains++;
    cp++;
   }
  }

  /* Got any domains? */
  if (domains>0) {
   ULONG len;

   /* Yes, calculate buffer length */
   len=sizeof(struct DomainList) + (domains-1) * sizeof(struct DomainData);

   /* Allocate buffer */
   if (dl=AllocMem(len,MEMF_PUBLIC)) {
    struct DomainData *dd=&dl->dl_Data;
    char *ep=vp;

    /* Initialize structure */
    dl->dl_UMSVar =vp;
    dl->dl_Length =len;
    dl->dl_Entries=domains;

    /* Initialize list */
    do {
     char *nextentry;

     /* Search next entry */
     if (nextentry=strchr(ep,','))
      *nextentry++='\0'; /* Set string terminator */

     /* Initialize entry */
     dd->dd_Name  =ep;
     dd->dd_Length=strlen(ep);

     /* Get next entry */
     ep=nextentry;
     dd++;
    } while (ep);
   }
  }

  /* Set new domain list */
  *dlp=dl;
 }
}

/* Get conversion data from UMS config */
void GetConversionData(UMSUserAccount acc)
{
 /* Save UMS account */
 ConfAccount=acc;

 /* Get domain lists */
 {
  char *bp=MainBuffer+sizeof(UMSUUCP_IMPORT)-1;

  /* Copy prefix */
  strcpy(MainBuffer,UMSUUCP_IMPORT);

  /* Build UMS variable names and get list */
  strcpy(bp,"fido");
  GetDomainList(&FIDODomainList);
  strcpy(bp,"maus");
  GetDomainList(&MausDomainList);
  strcpy(bp,"zer");
  GetDomainList(&ZerDomainList);
 }

 /* Debugging */
 if (LogLevel>=1) {
  PrintList("FIDO",FIDODomainList);
  PrintList("Maus",MausDomainList);
  PrintList("Z-Netz",ZerDomainList);
 }
}

/* Free one domain list */
static void FreeDomainList(struct DomainList *dl)
{
 /* Domain list valid? */
 if (dl) {
  char *vp;

  /* UMS var pointer valid? */
  if (vp=dl->dl_UMSVar) {

   /* Yes, free UMS var */
   FreeUMSConfig(ConfAccount,vp);

   /* Free domain list */
   FreeMem(dl,dl->dl_Length);
  }
 }
}

/* Free conversion data */
void FreeConversionData(void)
{
 FreeDomainList(FIDODomainList);
 FreeDomainList(MausDomainList);
 FreeDomainList(ZerDomainList);
}

/* Does the address match one of the domains in the list? */
static BOOL AddrInDomainList(char *addrend, ULONG len, struct DomainList *dl)
{
 BOOL rc=FALSE;

 /* Domain list valid? */
 if (dl) {
  ULONG i;
  struct DomainData *dd;

  /* Scan entries */
  for (i=dl->dl_Entries, dd=&dl->dl_Data; i; i--, dd++) {
   ULONG domlen=dd->dd_Length;

   /* Address long enough and does the domain part match? */
   if ((len>domlen) && (stricmp(addrend-domlen,dd->dd_Name)==0)) {

    /* Domain found, leave loop */
    rc=TRUE;
    break;
   }
  }
 }

 return(rc);
}

/*
 * GetAddress() - get and convert an address
 *
 * buf should point to a scratch place with 1024 bytes free
 *
 */
void GetAddress(char *input, char *name, char *address, char *buf)
{
 char *ap;
 ULONG len;

 /* Call SplitAddress() first */
 SplitAddress(input,name,address,buf);

 /* Find end of address string */
 len=strlen(address);
 ap=address+len;

 /* Address conversion */
 if (AddrInDomainList(ap,len,FIDODomainList)) {
  /* Fidonet                                                    */
  /* RFC: Real_Name@p<point>.f<node>.n<hub>.z<zone><fidodomain> */
  /* UMS: <zone>:<hub>/<node>[.<point>]@fidonet                 */
  LONG zone=0,hub=0,node=0,point=0;
  char c,*np;

  /* Copy name */
  ap=address;
  np=name;
  while ((c=*ap++)!='@') *np++=(strchr(SpaceRep,c)) ? ' ' : c;
  *np='\0';

  /* Extract address */
  {
   char *endp=ap;

   if (*endp=='p') {
    point=strtol(endp+1,&endp,10);
    endp++;
   }
   if (*endp=='f') {
    node=strtol(endp+1,&endp,10);
    endp++;
   }
   if (*endp=='n') {
    hub=strtol(endp+1,&endp,10);
    endp++;
   }
   if (*endp=='z') {
    zone=strtol(endp+1,&endp,10);
    endp++;
   }
  }

  /* Create address */
  if (point)
   sprintf(address,"%d:%d/%d.%d@fidonet",zone,hub,node,point);
  else
   sprintf(address,"%d:%d/%d@fidonet",zone,hub,node);

 } else if (AddrInDomainList(ap,len,MausDomainList)) {
  /* Maus-Netz (German network)           */
  /* RFC: Real_Name@<boxname><mausdomain> */
  /* UMS: <boxname>.maus                  */
  char c,*np;

  /* Copy name */
  ap=address;
  np=name;
  while ((c=*ap++) && (c!='@')) *np++=(strchr(SpaceRep,c)) ? ' ' : c;
  *np='\0';

  /* Build address */
  np=address;
  while ((c=*ap++) && (c!='.')) *np++=c; /* Copy box name */
  strcpy(np,".maus");

 } else if (AddrInDomainList(ap,len,ZerDomainList)) {
  /* Z-Netz (German network)                */
  /* RFC: <login name>@<boxname><zerdomain> */
  /* UMS: <login name>@<boxname>.zer        */

  /* Search domain part and end of box name */
  if ((ap=strchr(address,'@')) && (ap=strchr(ap+1,'.')))
   strcpy(ap+1,"zer"); /* Add Z-Netz identifier */
 }
}
