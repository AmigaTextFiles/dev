/*
 * uuxqt.c  V0.8.01
 *
 * uuxqt main part
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

static const char VersionID[]="\0$VER: UMS-UUXQT" UMSUUCP_IDSTRING;
static const char progname[]="UUXQT";
extern struct Library *SysBase;
struct Library *OwnDevUnitBase;
#define LOCKNAMELEN 20
static char LockName[LOCKNAMELEN];
#define UMSMBNAMELEN 20
char UMSMBName[UMSMBNAMELEN]="";
char *UMSDebugProgram="uuxqt";
char *UMSDebugFile=NULL;
long UMSDebugLevel;
BOOL FilterCR;
BOOL KeepDupes;
UBYTE *MainBuffer;
UBYTE *Tmp1Buffer;
UBYTE *Tmp2Buffer;
UBYTE *Tmp3Buffer;
UBYTE *Tmp4Buffer;
UBYTE *Tmp5Buffer;
UBYTE *Tmp6Buffer;
UBYTE *Tmp7Buffer;

/* Dummy routine for CTRL-C */
int brk(void)
{
 return(0);
}

int main(int argc, char **argv)
{
 ULONG rc=RETURN_FAIL;
 char *systemname=NULL;

 /* Check Exec version */
 if (SysBase->lib_Version<37) {
  fprintf(stderr,"This version of uuxqt needs 2.04!\n");
  exit(RETURN_FAIL);
 }

 /* Set program name for ulog() */
 LogProgram=progname;

 /* Parse command line */
 while (--argc) {
  char *arg=*++argv;

  if (*arg == '-')
   /* Command line option */
   switch (arg[1]) {
    case 'd': /* Log level */
              {
               char *tp;

               LogLevel=strtol(arg+2,&tp,10);
              }
              break;
    default:  /* Ignore */
              break;
   }
  else
   /* Save system name */
   systemname=arg;
 }

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Open OwnDevUnit.library for file locking */
 if (OwnDevUnitBase=OpenLibrary(ODU_NAME,0)) {
  BPTR spooldir;

  /* Lock spool dir */
  if (spooldir=Lock(GetConfigDir(UUSPOOL),ACCESS_READ)) {
   BPTR olddir=CurrentDir(spooldir);

   /* Build lock name */
   strcpy(LockName,progname);

   /* If a system name is given, go into the directory with the same name */
   if (systemname) {
    BPTR systemdir;

    /* Does the directory exist? */
    if (systemdir=Lock(systemname,ACCESS_READ)) {
     /* Yes, change to the new directory (free old lock) */
     UnLock(CurrentDir(systemdir));
     spooldir=systemdir;

     /* Append system name to lock name */
     strncat(LockName,systemname,LOCKNAMELEN-1-strlen(LockName));
     LockName[LOCKNAMELEN-1]='\0';
    }
   }

   /* UUXQT already running? */
   if (!FileIsLocked(LockName)) {

    /* Create lock */
    LockFile(LockName);

    /* Get name of UMS message base from environment variable */
    GetVar(UMSUUCP_MBASE,UMSMBName,UMSMBNAMELEN,0);

    /* Login as UUCP default */
    if (Login(UMSUUCP_DEFAULT)) {

     /* Get memory for buffers */
     if (MainBuffer=AllocMem(BUFFERSIZE,MEMF_PUBLIC|MEMF_CLEAR)) {

      /* Set buffer pointers */
      Tmp1Buffer=MainBuffer + MAINBUFSIZE;
      Tmp2Buffer=Tmp1Buffer + TMP1BUFSIZE;
      Tmp3Buffer=Tmp2Buffer + TMP2BUFSIZE;
      Tmp4Buffer=Tmp3Buffer + TMP3BUFSIZE;
      Tmp5Buffer=Tmp4Buffer + TMP4BUFSIZE;
      Tmp6Buffer=Tmp5Buffer + TMP5BUFSIZE;
      Tmp7Buffer=Tmp6Buffer + TMP6BUFSIZE;

      /* Get UUCP variables from UMS config */
      {
       char *cp;

       /* UMS errors log file name */
       if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_DEBUGFILE,
                                        TAG_DONE)) {
        UMSDebugFile=strdup(cp);
        FreeUMSConfig(Account,cp);
       }
       if (!UMSDebugFile) UMSDebugFile=UMSUUCP_DEFDEBUG;

       /* UMS errors log level */
       if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_DEBUGLEVEL,
                                        TAG_DONE)) {
        char *tp;

        UMSDebugLevel=strtol(cp,&tp,10);
        FreeUMSConfig(Account,cp);
       } else
        UMSDebugLevel=0;

       /* Filter CRs? */
       if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_FILTERCR,
                                        TAG_DONE)) {
        FilterCR=((*cp=='y') || (*cp=='Y'));
        FreeUMSConfig(Account,cp);
       } else
        FilterCR=FALSE;

       /* Keep dupes? */
       if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_KEEPDUPES,
                                        TAG_DONE)) {
        KeepDupes=((*cp=='y') || (*cp=='Y'));
        FreeUMSConfig(Account,cp);
       } else
        KeepDupes=TRUE;
      }

      /* Get conversion data from UMS config */
      GetConversionData(Account);

      /* Process files */
      rc=ScanInDir(spooldir);

      /* Free conversion data */
      FreeConversionData();

      /* Free buffers */
      FreeMem(MainBuffer,BUFFERSIZE);
     } else
      ulog(-1,"can't allocate buffers!");

     /* Free all logins */
     FreeLogins();
    } else
     ulog(-1,"can't login as '" UMSUUCP_PRE UMSUUCP_DEFAULT
             "'. Please check your config!");

    /* Release lock */
    UnLockFile(LockName);
   } else
    ulog(-1,"UUXQT already running!");

   CurrentDir(olddir);
   UnLock(spooldir);
  } else
   ulog(-1,"can't lock spool dir!");

  CloseLibrary(OwnDevUnitBase);
 } else
  fprintf(stderr,"Unable to open '" ODU_NAME "'!\n");

 return(rc);
}
