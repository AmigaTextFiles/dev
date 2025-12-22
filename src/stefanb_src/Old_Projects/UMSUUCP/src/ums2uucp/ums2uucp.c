/*
 * ums2uucp.c  V0.7.04
 *
 * ums2uucp main program
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "ums2uucp.h"

static const char VersionID[]="\0$VER: ums2uucp" UMSUUCP_IDSTRING;
extern struct Library *SysBase;
struct Library *OwnDevUnitBase;
#define UMSMBNAMELEN 20
static char UMSMBName[UMSMBNAMELEN]="";
#define UMSACCNAMELEN 20
static char UMSAccountName[UMSACCNAMELEN]=UMSUUCP_PRE UMSUUCP_DEFAULT;
char *UMSDebugProgram="ums2uucp";
char *UMSDebugFile=NULL;
long UMSDebugLevel;
UMSUserAccount Account=NULL;
char *NodeName;
char *PathName;
char *DomainName;
UBYTE *FromAddrBuffer;
UBYTE *Tmp1Buffer;
UBYTE *Tmp2Buffer;
char CutNodeName[8];
char CutRemoteName[8];

/* Dummy routine for CTRL-C */
int brk(void)
{
 return(0);
}

int main(int argc, char **argv)
{
 ULONG rc=RETURN_FAIL;
 ULONG mask=0;
 char *systemname=NULL;

 /* Check Exec version */
 if (SysBase->lib_Version<37) {
  fprintf(stderr,"This version of ums2uucp needs 2.04!\n");
  exit(rc);
 }

 /* Set program name for ulog() */
 LogProgram=UMSDebugProgram;

 /* Parse command line */
 while (--argc) {
  char *arg=*++argv;

  if (*arg == '-')
   switch (arg[1]) {
    case 'b': /* Select bit */
              {
               char *tp;
               long selectbit;

               selectbit=strtol(arg+2,&tp,10);

               /* Sanity checks */
               if ((selectbit>=0) && (selectbit<32)) mask=(1L << selectbit);
              }
              break;

    case 'd': /* Log level */
              {
               char *tp;

               LogLevel=strtol(arg+2,&tp,10);
              }
              break;

    case 's': /* Name of system to export to */
              systemname=arg+2;
              strncpy(UMSAccountName+sizeof(UMSUUCP_PRE)-1,systemname,
                      UMSACCNAMELEN-sizeof(UMSUUCP_PRE));
              strncpy(CutRemoteName,systemname,7);
              CutRemoteName[7]='\0';
              break;

    default:  /* Ignore */
              break;
   }
 }

 /* Did the user specify a system name */
 if (!systemname) {
  fprintf(stderr,"Usage: ums2uucp -s<system> [-d<level>]\n");
  exit(rc);
 }

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Open OwnDevUnit.library for file locking */
 if (OwnDevUnitBase=OpenLibrary(ODU_NAME,0)) {
  BPTR spooldir;

  /* Lock spool dir */
  if (spooldir=Lock(GetConfigDir(UUSPOOL),ACCESS_READ)) {
   BPTR olddir=CurrentDir(spooldir);

   /* Try to go into the directory with the system name */
   {
    BPTR systemdir;

    /* Does the directory exist? */
    if (systemdir=Lock(systemname,ACCESS_READ)) {
     /* Yes, change to the new directory (free old lock) */
     UnLock(CurrentDir(systemdir));
     spooldir=systemdir;
    }
   }

   /* Is a ums2uucp for this system already running? */
   if (!FileIsLocked(UMSAccountName)) {

    /* Create lock */
    LockFile(UMSAccountName);

    /* Get name of UMS message base from environment variable */
    GetVar(UMSUUCP_MBASE,UMSMBName,UMSMBNAMELEN,0);

    /* Login into UUCP account */
    if (Account=UMSRLogin(UMSMBName,UMSAccountName,"")) {

     /* Read node name */
     if (NodeName=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_NODENAME,
                                            TAG_DONE)) {

      /* Read path name */
      if (PathName=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_PATHNAME,
                                             TAG_DONE)) {

       /* Read domain name */
       if (DomainName=ReadUMSConfigTags(Account,
                                        UMSTAG_CfgName,UMSUUCP_DOMAINNAME,
                                        TAG_DONE)) {

        /* Create scratch buffers */
        if (FromAddrBuffer=AllocMem(BUFFERSIZE,MEMF_PUBLIC|MEMF_CLEAR)) {

         /* Init buffer pointers */
         Tmp1Buffer=FromAddrBuffer + FROMBUFSIZE;
         Tmp2Buffer=Tmp1Buffer + TMP1BUFSIZE;

         /* Cut node name to 7 characters */
         strncpy(CutNodeName,NodeName,7);
         CutNodeName[7]='\0';

         /* Log startup */
         ulog(-1,"start export for system '%s'",
                 UMSAccountName+sizeof(UMSUUCP_PRE)-1);

         /* Export new messages */
         if (ScanNew(mask)) rc=RETURN_OK;

         /* Free scratch buffers */
         FreeMem(FromAddrBuffer,BUFFERSIZE);
        } else
         ulog(-1,"can't allocate buffer!");

        /* Free domain name */
        FreeUMSConfig(Account,DomainName);
       } else
        ulog(-1,"missing config variable '" UMSUUCP_DOMAINNAME "'!");

       /* Free path name */
       FreeUMSConfig(Account,PathName);
      } else
       ulog(-1,"missing config variable '" UMSUUCP_PATHNAME "'!");

      /* Free node name */
      FreeUMSConfig(Account,NodeName);
     } else
      ulog(-1,"missing config variable '" UMSUUCP_NODENAME "'!");

     /* Logout */
     UMSLogout(Account);
    } else
     ulog(-1,"can't login as '%s'. Please check your config!",UMSAccountName);

    /* Release lock */
    UnLockFile(UMSAccountName);
   } else
    ulog(-1,"export for system '%s' already running!",
            UMSAccountName+sizeof(UMSUUCP_PRE)-1);

   CurrentDir(olddir);
   UnLock(spooldir);
  } else
   ulog(-1,"can't lock spool dir!");

  CloseLibrary(OwnDevUnitBase);
 } else
  fprintf(stderr,"Unable to open '" ODU_NAME "'!\n");

 return(rc);
}
