/*
 * umsnntpd.c V1.0.00
 *
 * UMS NNTP (server) main entry point
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsnntpd.h"

/* Constant strings */
static const char Version[] = "$VER: umsnntpd "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";
static const char Template[]   = "NAME,PASSWD,SERVER";

/* Local data */
static struct {
               char *name;
               char *passwd;
               char *server;
              } args          = {"NNTPD", "", NULL};
static struct UMSRFCBases urb;
static struct sockaddr_in PeerAddress;

/* Global data */
struct Library    *SocketBase, *UMSBase, *UMSRFCBase;
LONG               NNTPDSocket;
LONG               ErrNo;
LONG               GMTOffset;
struct AccessData *AccessData;
struct OutputData  OutputData;
struct InputData   InputData;
char               TempBuffer[BUFLEN];
char               OutBuffer[BUFLEN];

/* Get access rights from UMS config */
static struct AccessData *CheckNNTPAccess(UMSAccount account)
{
 LONG AddressLength    = sizeof(struct sockaddr_in);
 struct AccessData *rc = NULL;

 /* Get peer address */
 if (GetPeerName(NNTPDSocket, (struct sockaddr *) &PeerAddress, &AddressLength) == 0) {
  struct hostent *he;

  DEBUGLOG(kprintf("Got peer address!\n");)

  /* Get host name by addr */
  if (he = GetHostByAddr((const char *) &PeerAddress.sin_addr,
                         sizeof(struct in_addr), AF_INET)) {
   char *AccessVar;

   DEBUGLOG(kprintf("Service requested by '%s'\n", he->h_name);)

   /* Get UMS variable */
   if (AccessVar = UMSReadConfigTags(account, UMSTAG_CfgName, "nntpd.access",
                                              TAG_DONE)) {

    /* Variable valid? */
    if (*AccessVar) {
     char *cp = AccessVar;

     /* Parse variable */
     while (cp && *cp) {
      char *next;
      /* Scan for line end and set line terminator */
      if (next = strchr(cp, '\n')) *next++ = '\0';

      DEBUGLOG(kprintf("Access line: %s\n", cp);)

      /* Non-empty line? */
      if (*cp) {
       char *pat = cp;
       char c;

       /* Find end of pattern */
       while ((c = *cp) && (c != ' ') && (c != '\t')) cp++;

       /* Set string terminator */
       *cp++ = '\0';

       DEBUGLOG(kprintf("Pattern: %s\n", pat);)

       /* Parse pattern and match host name */
       if ((ParsePatternNoCase(pat, TempBuffer, BUFLEN) >= 0) &&
           MatchPatternNoCase(TempBuffer, he->h_name)) {
        static struct AccessData ad;

        /* Skip white space */
        while ((c = *cp) && ((c == ' ') || (c == '\t'))) cp++;

        /* Argument valid? */
        if (c) {
         char *name = cp;

         /* Reset flags */
         ad.ad_Flags = 0;

         /* Look out for other parameters */
         while ((c = *++cp) && (c != ','));

         /* Set string terminator */
         *cp = '\0';

         DEBUGLOG(kprintf("User: %s\n", name);)

         /* Copy user name */
         strncpy(ad.ad_User, name, USERNAMELEN);
         ad.ad_User[USERNAMELEN] = '\0';

         /* 2nd argument valid? */
         if (c) {

          /* Check posting flag */
          if (((c = *++cp) == 'y') || (c == 'Y')) ad.ad_Flags = NNTPDF_POSTING;

          DEBUGLOG(kprintf("Posting: %lc\n", c);)

          /* Look out for other parameters */
          while ((c = *cp) && (c != ',')) cp++;

          /* 3rd argument valid? */
          if (c) {

           /* Check server flag */
           if (((c = *++cp) == 'y') || (c == 'Y'))
            ad.ad_Flags |= NNTPDF_SERVER;

           DEBUGLOG(kprintf("Server: %lc\n", c);)

           /* Skip to line end */
           while (*cp++);
          }
         }

         /* This host may access our server */
         rc = &ad;

         /* Leave loop */
         break;
        }
       }
      }

      /* Next line */
      cp = next;
     }
    }

    /* Free UMS variable */
    UMSFreeConfig(account, AccessVar);
   }
  }
 }

 return(rc);
}

/* Main entry point */
int main(int argc, char **argv)
{
 LONG rc = DERR_OBTAIN; /* Special return code for AmiTCPs inetd */

 /* Check Exec version */
 if (SysBase->lib_Version >= 37) {

  /* Open socket library */
  if (SocketBase = OpenLibrary("bsdsocket.library", 0)) {
   struct DaemonMessage *dm = (struct DaemonMessage *)
                              ((struct Process *) FindTask(NULL))->pr_ExitData;

   /* Set ErrNo pointer */
   SetErrnoPtr(&ErrNo, sizeof(long));

   /* Check daemon message and obtain socket */
   if (dm &&
       ((NNTPDSocket = ObtainSocket(dm->dm_Id, dm->dm_Family, dm->dm_Type, 0))) >= 0) {
    struct RDArgs *rda;

    /* Socket obtained, change default return code */
    rc = RETURN_FAIL;

    /* Parse command line parameters */
    if (rda = ReadArgs(Template, (LONG *) &args, NULL)) {

     /* Open UMS library */
     if (UMSBase = OpenLibrary("ums.library", 11)) {
      UMSAccount account;

      /* Login to UMS */
      if (account = UMSRLogin(args.server, args.name, args.passwd)) {

       /* Check access rights... */
       if (AccessData = CheckNNTPAccess(account)) {

        /* Open UMSRFC library */
        if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME,
                                     UMSRFC_LIBRARY_VERSION)) {
         struct UMSRFCData *urd;

         /* Initialize bases for UMS RFC login */
         urb.urb_UMSBase     = UMSBase;
         urb.urb_DOSBase     = DOSBase;
         urb.urb_UtilityBase = UtilityBase;

         /* Allocate UMS RFC data */
         if (urd = UMSRFCAllocData(&urb, args.name, args.passwd,
                                   args.server)) {

          /* Get GMT offset from locale library */
          {
           struct Library *LocaleBase;

           /* Open locale library */
           if (LocaleBase = OpenLibrary("locale.library", 38)) {
            struct Locale *loc;

            /* Open default Locale */
            if (loc = OpenLocale(NULL)) {

             /* Locale open, get offset in seconds _FROM_ GMT               */
             /* This has to be added to a normal Amiga time to get GMT time */
             GMTOffset = -loc->loc_GMTOffset * 60;

             CloseLocale(loc);
            }

            /* Close library */
            CloseLibrary(LocaleBase);
           }
          }

          /* Create & send Hello message */
          {
           ULONG len;
           BOOL  post = (AccessData->ad_Flags & NNTPDF_POSTING) != 0;

           len = sprintf(TempBuffer,
                          "%d %s UMS NNTP server V"
                          INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                          INTTOSTR(UMSRFC_REVISION)
                          " ready - posting %sallowed\r\n",
                          post ? NNTP_READY_POST_ALLOWED :
                                 NNTP_READY_POST_NOT_ALLOWED,
                          urd->urd_DomainName,
                          post ? "" : "not ");
           Send(NNTPDSocket, TempBuffer, len, 0);
          }

          /* Initialize output & input data */
          OutputData.od_DOSBase   = DOSBase;
          OutputData.od_Length    = BUFLEN;
          OutputData.od_Buffer    = OutBuffer;
          InputData.id_OutputData = &OutputData;
          InputData.id_FileName   = TempBuffer;
          InputData.id_Buffer     = LineBuffer;
          InputData.id_Length     = BUFLEN;
          InputData.id_SocketBase = SocketBase;
          InputData.id_Socket     = NNTPDSocket;
          InputData.id_SysBase    = SysBase;

          /* Start NNTP command processing */
          rc = CommandLoop(urd);

          /* Free message buffer */
          FreeMsgBuffer();

          UMSRFCFreeData(urd);
         } else
          fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n",
                           AccessData->ad_User,
                           args.server ? args.server : "<default>");

         CloseLibrary(UMSRFCBase);
        } else
         fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

       } else
        fprintf(stderr, "Access not allowed!\n");

       UMSLogout(account);
      } else
       fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n",
                        args.name, args.server ? args.server : "<default>");

      CloseLibrary(UMSBase);
     } else
      fprintf(stderr, "Couldn't open ums.library!\n");

     FreeArgs(rda);
    } else
     fprintf(stderr, "Error in command line!\n");

    /* Send last response */
    if (rc == RETURN_OK)
     Send(NNTPDSocket, INTTOSTR(NNTP_CLOSING_CONNECTION)
                        " closing connection - goodbye!\r\n", 35, 0);
    else
     Send(NNTPDSocket, INTTOSTR(NNTP_PERMISSION_DENIED)
                        " can't talk to you\r\n", 23, 0);

    /* Close socket */
    Shutdown(NNTPDSocket, 2);
    CloseSocket(NNTPDSocket);
   } else
    fprintf(stderr, "Couldn't obtain socket!\n");

   CloseLibrary(SocketBase);
  } else
   fprintf(stderr, "Couldn't open bsdsocket.library!\n");

 } else
  fprintf(stderr, "This version of umsnntpd needs Kickstart V37 or better!\n");

 return(rc);
}
