/*
 * uuxqt.c  V1.0.01
 *
 * uuxqt main part
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Constant strings */
static const char Version[]  = "$VER: UMS-UUXQT "
                               INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                               INTTOSTR(UMSRFC_REVISION)
                               " (" __COMMODORE_DATE__ ")";
static const char progname[] = "UUXQT";

/* Global data */
struct Library *UMSRFCBase;
struct Library *OwnDevUnitBase;

/* Name buffers */
#define LOCKNAMELEN 20
static char LockName[LOCKNAMELEN];
#define UMSMBNAMELEN 20
char  UMSMBName[UMSMBNAMELEN] = "";
char *UMSPassword = "";

/* Debugging */
struct UMSRFCData *DefaultLog = NULL;

/* Flags */
BOOL KeepDupes;
BOOL LogDupes;

/* Buffers */
UBYTE *TempBuffer1;

/* Dummy routine for CTRL-C */
static int brk(void)
{
 return(0);
}

int main(int argc, char **argv)
{
 ULONG rc = RETURN_FAIL;

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Check Exec version */
 if (SysBase->lib_Version >= 37) {

  /* Open UMS <-> RFC conversion library */
  if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME, UMSRFC_LIBRARY_VERSION)) {

   /* Open OwnDevUnit.library for file locking */
   if (OwnDevUnitBase = OpenLibrary(ODU_NAME, 0)) {
    char *systemname = NULL;
    BPTR  spooldir;

    /* Set program name for ulog() */
    LogProgram = progname;

    /* Parse command line */
    while (--argc) {
     char *arg = *++argv;

     if (*arg == '-')
      /* Command line option */
      switch (arg[1]) {
       case 'd': /* Log level */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Convert string to number */
         LogLevel = strtol(cp, NULL, 10);
        }
        break;

       case 'p': /* UMS password */
        {
         char *ap    = *(argv + 1);
         UMSPassword = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       default:  /* Unknown option -> ignore */
        fprintf(stderr, "Unknown option '%c'!\n", arg[1]);
        break;
      }
     else
      /* Save system name */
      systemname = arg;
    }

    /* Lock spool dir */
    if (spooldir = Lock(GetConfigDir(UUSPOOL), ACCESS_READ)) {
     BPTR olddir  = CurrentDir(spooldir);
     BPTR datadir = spooldir; /* Default: data files in same directory */

     /* Build lock name */
     strcpy(LockName, progname);

     /* If a system name is given, go into the directory with the same name */
     if (systemname) {
      BPTR systemdir;

      /* Does the directory exist? */
      if (systemdir = Lock(systemname, ACCESS_READ)) {
       /* Yes, change to the new directory (free old lock) */
       UnLock(CurrentDir(systemdir));
       spooldir = systemdir;
       datadir  = systemdir; /* Default: data files in same directory */

       /* Append system name to lock name */
       strncat(LockName, systemname, LOCKNAMELEN - 1 - strlen(LockName));
       LockName[LOCKNAMELEN - 1] = '\0';

       /* Check for TaylorUUCP-style spool directory layout */
       if (systemdir = Lock("X.", ACCESS_READ)) {
        BPTR tmplock;

        /* Exec file directory found, check also for data file directory */
        if (tmplock = Lock("D.", ACCESS_READ)) {

         /* TaylorUUCP layout, Change to the new directory (free old lock) */
         UnLock(CurrentDir(systemdir));
         spooldir = systemdir;
         datadir  = tmplock;

        } else
         /* No data file directory */
         UnLock(systemdir);
       }
      }
     }

     /* UUXQT already running? */
     if (!FileIsLocked(LockName)) {

      /* Create lock */
      LockFile(LockName);

      /* Get name of UMS message base from environment variable */
      GetVar(UMSUUCP_MBASE, UMSMBName, UMSMBNAMELEN, 0);

      /* Login as UUCP default */
      if (Login(UMSUUCP_DEFAULT)) {

       /* Get UMSRFCData for default error log */
       DefaultLog = URData;

       /* Get memory for buffers */
       if (TempBuffer1 = AllocMem(BUFFERSIZE, MEMF_PUBLIC)) {

        /* Get UUCP variables from UMS config */
        {
         char *cp;

         /* Keep dupes? */
         if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, UMSUUCP_KEEPDUPES,
                                             TAG_DONE)) {
          KeepDupes = ((*cp == 'y') || (*cp == 'Y'));
          UMSFreeConfig(Account, cp);
         } else
          KeepDupes = TRUE;

         /* Log dupes? */
         if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, UMSUUCP_LOGDUPES,
                                             TAG_DONE)) {
          LogDupes = ((*cp == 'y') || (*cp == 'Y'));
          UMSFreeConfig(Account, cp);
         } else
          LogDupes = TRUE;
        }

        /* Process files */
        rc = ScanInDir(spooldir, datadir);

        /* Free buffers */
        FreeMem(TempBuffer1, BUFFERSIZE);

       } else
        ulog(-1, "can't allocate buffers!");

       /* Free all logins */
       FreeLogins();
      } else
       ulog(-1, "can't login as '" UMSUUCP_PRE UMSUUCP_DEFAULT
                "'. Please check your config!");

      /* Release lock */
      UnLockFile(LockName);
     } else
      ulog(-1, "UUXQT already running!");

     CurrentDir(olddir);
     if (datadir != spooldir) UnLock(datadir);
     UnLock(spooldir);
    } else
     ulog(-1, "can't lock spool dir!");

    CloseLibrary(OwnDevUnitBase);
   } else
    fprintf(stderr, "Unable to open '" ODU_NAME "'!\n");

   CloseLibrary(UMSRFCBase);
  } else
   fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

 } else
  fprintf(stderr, "This version of uuxqt needs Kickstart V37 or better!\n");

 return(rc);
}
