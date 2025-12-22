/*
 * umspop3.c V1.0.00
 *
 * UMS POP3 (client) main entry point
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umspop3.h"

/* Constant strings */
static const char Version[] = "$VER: umspop3 "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";

/* Global data */
struct Library   *SocketBase, *UMSRFCBase;
struct InputData  InputData;
LONG ErrNo;
LONG POP3Socket = -1;
char Buffer[BUFLEN];
char OutBuffer[BUFLEN];

/* Local data */
static struct OutputData  OutputData;
static struct UMSRFCBases urb;
static struct ConnectData cd;

/* Local defines */
#define WAIT_PERIOD (60 * 50) /* seconds */

/* Read answer from server */
ULONG GetReturnCode(void)
{
 /* Read line from server */
 if (ReadLine(SocketBase, POP3Socket, Buffer, BUFLEN)) {

  DEBUGLOG(kprintf("%s\n", Buffer);)

  /* Convert number */
  return((*Buffer == '+') ? POP3_OK : POP3_ERROR);

 } else
  /* Error */
  return(POP3_ABORT);
}

/* Dummy routine for CTRL-C */
static int brk(void)
{
 return(0);
}

/* Main entry point */
int main(int argc, char **argv)
{
 int rc = RETURN_FAIL;

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Check Exec version */
 if (SysBase->lib_Version >= 37) {

  /* Open UMS <-> RFC conversion library */
  if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME, UMSRFC_LIBRARY_VERSION)) {

   /* Open socket library */
   if (SocketBase = OpenLibrary("bsdsocket.library", 0)) {
    char *POP3HostName        = NULL;      /* POP3 server name              */
    char *POP3ServiceName     = "pop3";    /* POP3 service name             */
    char *UMSUser             = "POP3";    /* UMS user for POP3             */
    char *UMSPassword         = "";        /* UMS password for POP3         */
    char *UMSServer           = NULL;      /* UMS server for POP3           */
    char *POP3User            = NULL;      /* POP3 user name                */
    char *POP3Password        = NULL;      /* POP3 password                 */
    ULONG WaitPeriod          = WAIT_PERIOD; /* Delay between two imports   */
    BOOL ContinousMode        = FALSE;     /* No continous mode             */
    BOOL DeleteMessages       = TRUE;      /* Delete messages from mail box */

    /* Parse command line arguments */
    while (--argc) {
     char *arg = *++argv;

     if (*arg == '-')
      switch (arg[1]) {
       case 'S': /* POP3 service name */
        {
         char *ap        = *(argv + 1);
         POP3ServiceName = (ap && (*ap != '-')) ? ap : arg + 2;
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

       case 'h': /* POP3 host name */
        {
         char *ap     = *(argv + 1);
         POP3HostName = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'i': /* POP3 user password */
        {
         char *ap     = *(argv + 1);
         POP3Password = (ap && (*ap != '-')) ? ap : arg + 2;
        }
        break;

       case 'k': /* Keep mails in mail box */
        DeleteMessages = FALSE;
        break;

       case 'n': /* POP3 user name */
        {
         char *ap = *(argv + 1);
         POP3User = (ap && (*ap != '-')) ? ap : arg + 2;
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

    /* Host name, POP3 user and POP3 password set? */
    if (POP3HostName && POP3User && POP3Password) {

     /* Set ErrNo pointer */
     SetErrnoPtr(&ErrNo, sizeof(LONG));

     /* Initialize connect data */
     cd.cd_SocketBase = SocketBase;

     /* Get connection data */
     if (GetConnectData(&cd, POP3ServiceName)) {
      struct UMSRFCData *URData;

      /* Set library bases for umsrfc.library */
      urb.urb_UMSBase     = UMSBase;
      urb.urb_DOSBase     = DOSBase;
      urb.urb_UtilityBase = UtilityBase;

      /* Login into UMS */
      if (URData = UMSRFCAllocData(&urb, UMSUser, UMSPassword, UMSServer)) {
       UMSAccount account  = URData->urd_Account;

       /* Initialize output & input data */
       OutputData.od_DOSBase   = DOSBase;
       OutputData.od_Length    = BUFLEN;
       OutputData.od_Buffer    = OutBuffer;
       InputData.id_OutputData = &OutputData;
       InputData.id_FileName   = tmpnam(NULL);
       InputData.id_Buffer     = Buffer;
       InputData.id_Length     = BUFLEN;
       InputData.id_SocketBase = SocketBase;
       InputData.id_SysBase    = SysBase;

       /* Continous mode loop */
       do {

        /* Connect to host */
        if (ConnectToHost(&cd, POP3HostName) == CONNECT_OK) {

         /* Set Socket */
         POP3Socket = cd.cd_Socket;

         /* Read server greeting */
         if (GetReturnCode() == POP3_OK) {
          ULONG len;

          /* POP3 State: AUTHORIZATION */

          /* Send user name to server */
          len = sprintf(Buffer, "USER %s\r\n", POP3User);
          Send(POP3Socket, Buffer, len, 0);

          /* Read response from server */
          if (GetReturnCode() == POP3_OK) {

           /* Send password to server */
           len = sprintf(Buffer, "PASS %s\r\n", POP3Password);
           Send(POP3Socket, Buffer, len, 0);

           /* Read response from server */
           if (GetReturnCode() == POP3_OK) {
            char *cp;

            /* POP3 State: TRANSACTION */

            /* Request status of mail box */
            Send(POP3Socket, "STAT\r\n", 6, 0);

            /* Read response from server and get first parameter */
            if ((GetReturnCode() == POP3_OK) &&
                (cp = strchr(Buffer, ' '))) {
             ULONG maxmsgs;

             /* Return WARN if there are no messages in the mail box */
             rc = RETURN_WARN;

             /* Get number of messages in mail box */
             {
              char c;

              while ((c = *cp) && (c == ' ')) cp++;
             }
             if (maxmsgs = strtol(cp, NULL, 10)) {

              DEBUGLOG(kprintf("pop3: %ld messages\n", maxmsgs);)

              /* Set socket for input data */
              InputData.id_Socket = POP3Socket;

              /* Retrieve messages from mail box */
              if ((rc = GetMessages(URData, maxmsgs, POP3User, DeleteMessages))
                   != RETURN_OK)
               ContinousMode = FALSE;
             }

            } else {
             fprintf(stderr, "Broken mail box?\n");
             ContinousMode = FALSE;
            }

           } else {
            fprintf(stderr, "Couldn't lock mail box! Maybe wrong password?\n");
            ContinousMode = FALSE;
           }

          } else {
           fprintf(stderr, "User unknown!\n");
           ContinousMode = FALSE;
          }

         } else {
          fprintf(stderr, "POP3 server not ready!\n");
          ContinousMode = FALSE;
         }

         /* Close connection */
         CloseConnection(&cd);

         /* POP3 State: UPDATE */

        } else {
         fprintf(stderr, "Couldn't create connection to '%s'!\n",
                         POP3HostName);
         ContinousMode = FALSE;
        }

        /* Continous mode? */
        if (ContinousMode)

         /* Check CTRL-C */
         if (SetSignal(0, 0) & SIGBREAKF_CTRL_C)
          ContinousMode = FALSE; /* Leave loop */
         else {
          /* Wait */
          Delay(WaitPeriod);

          /* Check CTRL-C again */
          ContinousMode = (SetSignal(0, 0) & SIGBREAKF_CTRL_C) == 0;
         }

       /* If in continous mode then ask again for new messages */
       } while (ContinousMode);

       UMSRFCFreeData(URData);
      } else
       fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n", UMSUser,
                       UMSServer ? UMSServer : "default");

      FreeConnectData(&cd);
     } else
      fprintf(stderr, "Couldn't get connection data!\n");

    } else
     fprintf(stderr, "You have to specify the hostname of the POP3 server,\n"
                     "the POP3 user name and the POP3 password!\n");

    CloseLibrary(SocketBase);
   } else
    fprintf(stderr, "Couldn't open bsdsocket.library!\n");

   CloseLibrary(UMSRFCBase);
  } else
   fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

 } else
  fprintf(stderr,
          "This version of umspop3 needs Kickstart V37 or better!\n");

 return(rc);
}
