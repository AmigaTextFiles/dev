/*
 * ums2uucp.c  V1.0.02
 *
 * ums2uucp main program
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Constant strings */
static const char Version[] = "$VER: ums2uucp "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";

/* Local data */
static struct UMSRFCBases urb;

/* Global data */
struct Library *UMSRFCBase;
struct Library *OwnDevUnitBase;

/* UMS/UMSRFC data */
struct UMSRFCData *URData;
UMSAccount Account = NULL;

/* Buffers */
UBYTE *TempBuffer1;
UBYTE *TempBuffer2;
UBYTE *TempBuffer3;

/* Node names */
char  *NodeName;
char   CutNodeName[8];
char   CutRemoteName[8];

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
    char  *UUCPNodeName = NULL;
    char  *UMSUser      = "UUCP";
    char  *UMSPassword  = "";
    char  *UMSServer    = NULL;
    ULONG  mask         = 0;
    BPTR   spooldir;

    /* Parse command line arguments */
    while (--argc) {
     char *arg = *++argv;

     if (*arg == '-')
      switch (arg[1]) {
       case 'b': /* Select bit */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;
         long bit = strtol(cp, &cp, 10);

         /* Convert bit number to bit mask */
         if ((bit >= 0 ) && (bit < 32)) mask = 1L << bit;
        }
        break;

       case 'd': /* Log level */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Convert string to number */
         LogLevel = strtol(cp, NULL, 10);
        }
        break;

       case 'h': /* UUCP host name */
        {
         char *ap     = *(argv + 1);
         UUCPNodeName = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Cut name to 7 characters */
         strncpy(CutRemoteName, UUCPNodeName, 7);
         CutRemoteName[7] = '\0';
        }
        break;

       case 'p': /* UMS password */
        {
         char *ap    = *(argv + 1);
         UMSPassword = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 's': /* UMS server name */
        {
         char *ap  = *(argv + 1);
         UMSServer = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 't': /* Taylor UUCP mode */
        EnableTaylorUUCPMode();
        break;

       case 'u': /* UMS user name */
        {
         char *ap = *(argv + 1);
         UMSUser  = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       default:  /* Unknown option -> ignore */
        fprintf(stderr, "Unknown option '%c'!\n", arg[1]);
        break;
      }
    }

    /* Did the user specify a system name */
    if (UUCPNodeName) {

     /* Lock spool dir */
     if (spooldir = Lock(GetConfigDir(UUSPOOL), ACCESS_READ)) {
      BPTR olddir = CurrentDir(spooldir);

      /* Try to go into the directory with the system name */
      {
       BPTR systemdir;

       /* Does the directory exist? */
       if (systemdir = Lock(UUCPNodeName,ACCESS_READ)) {

        /* Yes, change to the new directory (free old lock) */
        UnLock(CurrentDir(systemdir));
        spooldir = systemdir;
       }
      }

      /* Is a ums2uucp for this system already running? */
      if (!FileIsLocked(UMSUser)) {

       /* Create lock */
       LockFile(UMSUser);

       /* Set library bases for umsrfc.library */
       urb.urb_UMSBase     = UMSBase;
       urb.urb_DOSBase     = DOSBase;
       urb.urb_UtilityBase = UtilityBase;

       /* Login into UUCP account */
       if (URData = UMSRFCAllocData(&urb, UMSUser, UMSPassword, UMSServer)) {

        /* Get UMS account */
        Account = URData->urd_Account;

        /* Read node name */
        if (NodeName = UMSReadConfigTags(Account,
                                         UMSTAG_CfgName, UMSUUCP_NODENAME,
                                         TAG_DONE)) {

         /* Create scratch buffers */
         if (TempBuffer1 = AllocMem(BUFFERSIZE, MEMF_PUBLIC)) {

          /* Init buffer pointers */
          TempBuffer2   = TempBuffer1   + TMPBUF1SIZE;
          TempBuffer3   = TempBuffer2   + TMPBUF2SIZE;
          MailOutBuffer = TempBuffer3   + TMPBUF3SIZE;
          NewsOutBuffer = MailOutBuffer + OUTBUFSIZE;

          /* Cut node name to 7 characters */
          strncpy(CutNodeName, NodeName, 7);
          CutNodeName[7] = '\0';

          /* Log startup */
          ulog(-1, "start export for system '%s'", UUCPNodeName);

          /* Export new messages */
          if (ScanNew(mask)) rc = RETURN_OK;

          /* Free scratch buffers */
          FreeMem(TempBuffer1, BUFFERSIZE);
         }

         /* Free node name */
         UMSFreeConfig(Account, NodeName);
        } else
         ulog(-1, "missing config variable '" UMSUUCP_NODENAME "'!");

        /* Logout */
        UMSRFCFreeData(URData);
       } else
        ulog(-1, "couldn't login as '%s' on server '%s'!", UMSUser,
                 UMSServer ? UMSServer : "default");

       /* Release lock */
       UnLockFile(UMSUser);
      } else
       ulog(-1, "export for system '%s' already running!", UUCPNodeName);

      CurrentDir(olddir);
      UnLock(spooldir);
     } else
      ulog(-1, "can't lock spool dir!");

    } else
     fprintf(stderr,
             "You have to specify the node name of your UUCP server!\n");

    CloseLibrary(OwnDevUnitBase);
   } else
    fprintf(stderr, "Unable to open '" ODU_NAME "'!\n");

   CloseLibrary(UMSRFCBase);
  } else
   fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

 } else
  fprintf(stderr, "This version of ums2uucp needs Kickstart V37 or better!\n");

 return(rc);
}
