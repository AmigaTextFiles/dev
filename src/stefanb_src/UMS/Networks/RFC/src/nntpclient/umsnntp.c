/*
 * umsnntp.c V1.0.02
 *
 * UMS NNTP (client) NNTP sender main entry point
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsnntp.h"

/* Constant strings */
static const char Version[] = "$VER: umsnntp "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";

/* Global data */
struct Library *SocketBase, *UMSRFCBase;
struct NNTPCommandData CmdData;
LONG ErrNo;

/* Local data */
static struct UMSRFCBases urb;

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
    char *NNTPHostName        = NULL;          /* NNTP server name          */
    char *NNTPServiceName     = "nntp";        /* NNTP service name         */
    char *UMSUser             = "NNTP";        /* UMS user for NNTP         */
    char *UMSPassword         = "";            /* UMS password for NNTP     */
    char *UMSServer           = NULL;          /* UMS server for NNTP       */
    ULONG SelectMask          = 0;             /* No filter flag            */
    ULONG RescanPeriod        = RESCAN_PERIOD; /* Rescan period             */
    ULONG WaitPeriod          = WAIT_PERIOD;   /* Delay between two exports */
    BOOL ContinousMode        = FALSE;         /* No continous mode         */
    BOOL ReaderMode           = TRUE;          /* We are a news reader      */

    /* Set default authentication user and password */
    CmdData.ncd_User     = "jduser";
    CmdData.ncd_Password = "secret";

    /* Parse command line arguments */
    while (--argc) {
     char *arg = *++argv;

     if (*arg == '-')
      switch (arg[1]) {
       case 'I': /* Use IHAVE instead of MODE READER & POST */
        ReaderMode = FALSE;
        break;

       case 'S': /* NNTP service name */
        {
         char *ap        = *(argv + 1);
         NNTPServiceName = (ap && (*ap != '-')) ? ap : arg + 2;
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

       case 'h': /* NNTP host name */
        {
         char *ap     = *(argv + 1);
         NNTPHostName = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'i': /* NNTP authentication password */
        {
         char *ap             = *(argv + 1);
         CmdData.ncd_Password = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'n': /* NNTP authentication name */
        {
         char *ap         = *(argv + 1);
         CmdData.ncd_User = (ap && (*ap != '-')) ? ap : arg + 2;
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

    /* Host name set? */
    if (NNTPHostName) {

     /* Set ErrNo pointer */
     SetErrnoPtr(&ErrNo, sizeof(LONG));

     /* Initialize connect data */
     CmdData.ncd_ConnectData.cd_SocketBase = SocketBase;

     /* Get connection data */
     if (GetConnectData(&CmdData.ncd_ConnectData, NNTPServiceName)) {
      struct UMSRFCData *URData;

      /* Set library bases for umsrfc.library */
      urb.urb_UMSBase     = UMSBase;
      urb.urb_DOSBase     = DOSBase;
      urb.urb_UtilityBase = UtilityBase;

      /* Login into UMS */
      if (URData = UMSRFCAllocData(&urb, UMSUser, UMSPassword, UMSServer)) {
       UMSAccount account  = URData->urd_Account;
       UMSMsgNum lastmsg   = 0; /* Number of last read UMS message */
       ULONG RescanCounter = 0;

       /* Continous mode loop */
       do {

        /* Reset error flag */
        rc = RETURN_OK;

        /* Select all new messages */
        if (UMSSelectTags(account,

                          /* Read user flags. Select all msgs with read   */
                          /* & view access (and an additional select bit) */
                          /* which have not been read.                    */
                          UMSTAG_SelMask,       UMSUSTATF_ReadAccess |
                                                UMSUSTATF_ViewAccess |
                                                UMSUSTATF_Old        |
                                                SelectMask,
                          UMSTAG_SelMatch,      UMSUSTATF_ReadAccess |
                                                UMSUSTATF_ViewAccess |
                                                SelectMask,

                          /* Start with this message */
                          UMSTAG_SelStart,      lastmsg,

                          /* Set local select bit on each message */
                          UMSTAG_SelWriteLocal, TRUE,
                          UMSTAG_SelSet,        SELBIT,

                          TAG_DONE)) {

         /* All new messages are selected now */
         /* Connect to host */
         if (ConnectToHost(&CmdData.ncd_ConnectData, NNTPHostName)
              == CONNECT_OK) {

          /* Posting allowed? */
          if (GetReturnCode(&CmdData) == NNTP_READY_POST_ALLOWED) {
           UMSMsgNum newmsg;

           /* Init message sending */
           InitSendArticle();

           /* MODE READER? */
           if (ReaderMode)

            /* Yes, send MODE READER command to server, ignore return code */
            SendNNTPCommand(&CmdData, "MODE READER\r\n", 13);

           /* Unselect all mail messages */
           UMSSelectTags(account,

                         /* Select all mail messages (Group = NULL) */
                         UMSTAG_WGroup,        NULL,
                         UMSTAG_SelQuick,      TRUE,

                         /* Start with this message */
                         UMSTAG_SelStart,      lastmsg,

                         /* Clear local select bit on each message */
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelUnset,      SELBIT,

                         TAG_DONE);

           /* Unselect "parked" messages */
           UMSSelectTags(account,

                         /* Read global flags. Select all */
                         /* messages with parked bit set  */
                         UMSTAG_SelReadGlobal, TRUE,
                         UMSTAG_SelMask,       UMSGSTATF_Parked,
                         UMSTAG_SelMatch,      UMSGSTATF_Parked,

                         /* Start with this message */
                         UMSTAG_SelStart,      lastmsg,

                         /* Clear local select bit on each message */
                         UMSTAG_SelWriteLocal, TRUE,
                         UMSTAG_SelUnset,      SELBIT,

                         TAG_DONE);

           /* Scan all selected messages */
           while ((rc == RETURN_OK) &&
                  (newmsg = UMSSearchTags(account,

                                          /* Start with this message */
                                          UMSTAG_SearchLast, lastmsg,

                                          /* Search from low to high numbers */
                                          UMSTAG_SearchDirection, 1,

                                          /* Search for messages which have */
                                          /* local select bit set           */
                                          UMSTAG_SearchLocal, TRUE,
                                          UMSTAG_SearchMask,  SELBIT,
                                          UMSTAG_SearchMatch, SELBIT,

                                          TAG_DONE)))

            /* Read new message */
            if (UMSRFCGetMessage(URData, newmsg)) {

             /* Write note */
             printf("Sending article <%s>...",
                    URData->urd_MsgFields[UMSCODE_MsgID]);
             fflush(stdout);

             /* Send message */
             rc = SendArticle(URData, ReaderMode);

             /* Message processed, free it */
             UMSRFCFreeMessage(URData);

             /* Finish note depending on return code */
             switch (rc) {
              case RETURN_FAIL:               /* Real error */
               puts(" ERROR");
               ContinousMode = FALSE;
               break;

              case RETURN_OK:                 /* Article accepted */
               puts(" done");
               break;

              case NNTP_SERVICE_DISCONTINUED: /* Connection lost, leave loop */
                                              /* and try again later.        */
               puts(" Connection lost");
               break;

              default:                        /* Article not accepted, but */
                                              /* we may continue...        */
               printf(" Response: %s\n", CmdData.ncd_Buffer);
               rc = RETURN_OK;
             }

             /* Update last message counter */
             lastmsg = newmsg;

            } else {
             /* Couldn't read message???? */
             fprintf(stderr,
                    "Couldn't read message %d, aborting! UMS-Error: %d - %s\n",
                    newmsg, UMSErrNum(account), UMSErrTxt(account));

             /* Leave loops */
             rc            = RETURN_FAIL;
             ContinousMode = FALSE;
            }

          } else {
           fprintf(stderr, "Posting not allowed!\n");
           ContinousMode = FALSE;
          }

          /* Close connection */
          CloseConnection(&CmdData.ncd_ConnectData);

         } else {
          fprintf(stderr, "Couldn't create connection to '%s'!\n",
                  NNTPHostName);
          ContinousMode = FALSE;
         }

        /* No new messages found */
        } else
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

      FreeConnectData(&CmdData.ncd_ConnectData);
     } else
      fprintf(stderr, "Couldn't get connection data!\n");

    } else
     fprintf(stderr, "You have to specify the hostname of the NNTP server!\n");

    CloseLibrary(SocketBase);
   } else
    fprintf(stderr, "Couldn't open bsdsocket.library!\n");

   CloseLibrary(UMSRFCBase);
  } else
   fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

 } else
  fprintf(stderr, "This version of umsnntp needs Kickstart V37 or better!\n");

 return(rc);
}
