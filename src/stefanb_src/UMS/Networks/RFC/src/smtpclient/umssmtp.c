/*
 * umssmtp.c V1.0.00
 *
 * UMS SMTP (client) main entry point
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtp.h"

/* Constant strings */
static const char Version[] = "$VER: umssmtp "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";

/* Global data */
struct Library *SocketBase, *UMSRFCBase;
UMSAccount Account;
LONG ErrNo;
LONG SMTPSocket = -1;

/* Local data */
static struct UMSRFCBases urb;
static struct ConnectData cd;

/* Local defines */
#define WAIT_PERIOD   (60 * 50) /* seconds */
#define RESCAN_PERIOD 360       /* WAIT_PERIOD's */

/* Dummy routine for CTRL-C */
static int brk(void)
{
 return(0);
}

/* Main entry point */
int main(int argc, char **argv)
{
 LONG rc = RETURN_FAIL;

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Check Exec version */
 if (SysBase->lib_Version >= 37) {

  /* Open UMS <-> RFC conversion library */
  if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME, UMSRFC_LIBRARY_VERSION)) {

   /* Open socket library */
   if (SocketBase = OpenLibrary("bsdsocket.library", 0)) {
    char *SMTPHostName        = NULL;          /* Multiple host mode        */
    char *SMTPServiceName     = "smtp";        /* SMTP service name         */
    char *UMSUser             = "SMTP";        /* UMS user for SMTP         */
    char *UMSPassword         = "";            /* UMS password for SMTP     */
    char *UMSServer           = NULL;          /* UMS server for SMTP       */
    ULONG SelectMask          = 0;             /* No filter flag            */
    ULONG RescanPeriod        = RESCAN_PERIOD; /* Rescan period             */
    ULONG WaitPeriod          = WAIT_PERIOD;   /* Delay between two exports */
    BOOL ContinousMode        = FALSE;         /* No continous mode         */

    /* Parse command line arguments */
    while (--argc) {
     char *arg = *++argv;

     if (*arg == '-')
      switch (arg[1]) {
       case 'S': /* SMTP service name */
        {
         char *ap        = *(argv + 1);
         SMTPServiceName = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'b': /* Select bit */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;
         long bit = strtol(cp, &cp, 10);

         /* Convert bit number to bit mask */
         if ((bit >= 0 ) && (bit < 32)) SelectMask = 1L << bit;
        }
        break;

       case 'c': /* Continous mode */
        ContinousMode = TRUE;
        break;

       case 'd': /* Log level */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Convert string to number */
         /* LogLevel = strtol(cp, &cp, 10); */
        }
        break;

       case 'h': /* SMTP host name */
        {
         char *ap     = *(argv + 1);
         SMTPHostName = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'p': /* UMS password */
        {
         char *ap    = *(argv + 1);
         UMSPassword = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'r': /* Rescan period */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Convert string to number */
         RescanPeriod = strtol(cp, &cp, 10);
         if (RescanPeriod <= 0) RescanPeriod = RESCAN_PERIOD;
        }
        break;

       case 's': /* UMS server name */
        {
         char *ap  = *(argv + 1);
         UMSServer = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'u': /* UMS user name */
        {
         char *ap = *(argv + 1);
         UMSUser  = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'w': /* Wait period */
        {
         char *ap = *(argv + 1);
         char *cp = (ap && (*ap != '-')) ? ap : arg + 2;

         /* Convert string to number */
         WaitPeriod = 50 * strtol(cp, &cp, 10);
         if (WaitPeriod <= 0) WaitPeriod = WAIT_PERIOD;
        }
        break;

       default:  /* Unknown option -> ignore */
        fprintf(stderr, "Unknown option '%c'!\n", arg[1]);
        break;
      }
    }

    /* Set ErrNo pointer */
    SetErrnoPtr(&ErrNo, sizeof(long));

    /* Initialize connect data */
    cd.cd_SocketBase = SocketBase;

    /* Get connection data */
    if (GetConnectData(&cd, SMTPServiceName)) {
     struct UMSRFCData *URData;

     /* Set library bases for umsrfc.library */
     urb.urb_UMSBase     = UMSBase;
     urb.urb_DOSBase     = DOSBase;
     urb.urb_UtilityBase = UtilityBase;

     /* Login into UMS */
     if (URData = UMSRFCAllocData(&urb, UMSUser, UMSPassword, UMSServer)) {
      UMSMsgNum lastmsg   = 0; /* Number of last read UMS message */
      ULONG RescanCounter = 0;

      /* Set global UMS account */
      Account  = URData->urd_Account;

      /* Reset error flag */
      rc = RETURN_OK;

      /* Continous mode loop */
      do {

       /* Select all new mail messages */
       if (UMSSelectTags(Account,

                         /* Read user flags. Select all messages with read */
                         /* & view access (and an additional select bit)   */
                         /* which have not been read.                      */
                         UMSTAG_SelMask,  UMSUSTATF_ReadAccess |
                                          UMSUSTATF_ViewAccess |
                                          UMSUSTATF_Old        |
                                          SelectMask,
                         UMSTAG_SelMatch, UMSUSTATF_ReadAccess |
                                          UMSUSTATF_ViewAccess |
                                          SelectMask,

                         /* Start with this message */
                         UMSTAG_SelStart, lastmsg,

                         /* Set local select bit 1 on each message */
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelSet,        SELBIT1,

                         TAG_DONE) &&

           UMSSelectTags(Account,

                         /* Select all mail messages (Group = NULL) */
                         UMSTAG_WGroup,   NULL,
                         UMSTAG_SelQuick, TRUE,

                         /* Start with this message */
                         UMSTAG_SelStart, lastmsg,

                         /* Set local select bit 2 on each message */
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelSet,        SELBIT2,

                         TAG_DONE))

        /* All new messages are selected now */
        /* Single host mode? If yes, connect to this host */
        if (!SMTPHostName ||
            (InitConnection(URData, &cd, SMTPHostName)
              == SMTP_ACTION_OK)) {
         UMSMsgNum newmsg;
         struct ConnectData *newcd = (SMTPHostName == NULL) ? &cd : NULL;

         /* Init message sending */
         InitSendMessage();

         /* Unselect "parked" messages */
         UMSSelectTags(Account,

                       /* Read global flags. Select all */
                       /* messages with parked bit set  */
                       UMSTAG_SelReadGlobal, TRUE,
                       UMSTAG_SelMask,       UMSGSTATF_Parked,
                       UMSTAG_SelMatch,      UMSGSTATF_Parked,

                       /* Start with this message */
                       UMSTAG_SelStart, lastmsg,

                       /* Clear local select bit 1 on each message */
                       UMSTAG_SelWriteLocal, TRUE,
                       UMSTAG_SelUnset,      SELBIT1,

                       TAG_DONE);

         /* Scan all selected messages */
         while ((rc == RETURN_OK) &&
                (newmsg = UMSSearchTags(Account,

                                        /* Start with this message */
                                        UMSTAG_SearchLast, lastmsg,

                                        /* Search from low to high numbers */
                                        UMSTAG_SearchDirection, 1,

                                        /* Search for messages which have */
                                        /* both local select bits set     */
                                        UMSTAG_SearchLocal, TRUE,
                                        UMSTAG_SearchMask,  SELBIT1 | SELBIT2,
                                        UMSTAG_SearchMatch, SELBIT1 | SELBIT2,

                                        TAG_DONE)))

          /* Read new message */
          if (UMSRFCGetMessage(URData, newmsg)) {

           /* Write note */
           printf("Sending message <%s>...",
                    URData->urd_MsgFields[UMSCODE_MsgID]);
           fflush(stdout);

           /* Send message */
           rc = SendMessage(URData, newcd);

           /* Message processed, free it */
           UMSRFCFreeMessage(URData);

           /* Finish note depending on return code */
           switch (rc) {
            case RETURN_FAIL:                /* Real error */
             puts(" ERROR");
             ContinousMode = FALSE;
             break;

            case RETURN_OK:                  /* Message accepted */
             puts(" done");
             break;

            case SMTP_SERVICE_NOT_AVAILABLE: /* Connection lost, leave loop */
                                             /* and try again later.        */
             puts(" Connection lost");
             break;

            default:                         /* Message not accepted, but */
                                             /* we may continue...        */
             printf(" Response: %s\n", LineBuffer);
             rc = RETURN_OK;
           }

           /* Update last message counter */
           lastmsg = newmsg;

          } else {
           /* Couldn't read message???? */
           fprintf(stderr,
                   "Couldn't read message %d, aborting! UMS-Error: %d - %s\n",
                   newmsg, UMSErrNum(Account), UMSErrTxt(Account));

           /* Leave loops */
           rc            = RETURN_FAIL;
           ContinousMode = FALSE;
          }

         /* Close connection if in single host mode */
         if (SMTPHostName) {
          EmptyQueue();
          CloseConnection(&cd);
         }

        } else {
         fprintf(stderr, "Couldn't create connection to '%s'!\n",
                         SMTPHostName);
         ContinousMode = FALSE;
        }

       /* No new messages found */
       else
        if (!ContinousMode) fprintf(stderr, "Nothing to export!\n");

       /* Continous mode? */
       if (ContinousMode) {

        /* Yes, increment rescan counter and check for timeout */
        if (++RescanCounter >= RescanPeriod) {

         /* Timeout, reset counter and last msg pointer */
         RescanCounter = 0;
         lastmsg       = 0;
        }

        /* Check CTRL-C */
        if (SetSignal(0, 0) & SIGBREAKF_CTRL_C)
         ContinousMode = FALSE; /* Leave loop */
        else {
         /* Wait */
         Delay(WaitPeriod);

         /* Check CTRL-C again */
         ContinousMode = (SetSignal(0, 0) & SIGBREAKF_CTRL_C) == 0;
        }
       }

      /* If in continous mode then scan again for new messages */
      } while (ContinousMode);

      UMSRFCFreeData(URData);
     } else
      fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n", UMSUser,
                      UMSServer ? UMSServer : "default");

     FreeConnectData(&cd);
    } else
     fprintf(stderr, "Couldn't get connection data!\n");

    CloseLibrary(SocketBase);
   } else
    fprintf(stderr, "Couldn't open bsdsocket.library!\n");

   CloseLibrary(UMSRFCBase);
  } else
   fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

 } else
  fprintf(stderr, "This version of umssmtp needs Kickstart V37 or better!\n");

 return(rc);
}
