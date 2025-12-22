/*
 * umssmtpd.c V1.0.00
 *
 * UMS SMTP (server) main entry point
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Constant strings */
static const char Version[]  = "$VER: umssmtpd "
                               INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                               INTTOSTR(UMSRFC_REVISION)
                               " (" __COMMODORE_DATE__ ")";
static const char Template[] = "NAME,PASSWD,SERVER";

/* Local data */
static struct {
               char *name;
               char *passwd;
               char *server;
              } args = {"SMTPD", "", NULL};
static struct UMSRFCBases urb;

/* Global data */
struct Library *SocketBase, *UMSBase, *UMSRFCBase;
LONG  SMTPDSocket;
LONG  ErrNo;
ULONG MaxMsgSize = 0;

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
       ((SMTPDSocket = ObtainSocket(dm->dm_Id, dm->dm_Family, dm->dm_Type, 0))) >= 0) {
    struct RDArgs *rda;

    DEBUGLOG(kprintf("SMTPD socket: %ld\n", SMTPDSocket);)

    /* Socket obtained, change default return code */
    rc = RETURN_FAIL;

    /* Parse command line parameters */
    if (rda = ReadArgs(Template, (LONG *) &args, NULL)) {

     /* Open UMS library */
     if (UMSBase = OpenLibrary("ums.library", 11)) {

      /* Open UMSRFC library */
      if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME,
                                   UMSRFC_LIBRARY_VERSION)) {
       struct UMSRFCData *urd;

       /* Initialize bases for UMS RFC login */
       urb.urb_UMSBase     = UMSBase;
       urb.urb_DOSBase     = DOSBase;
       urb.urb_UtilityBase = UtilityBase;

       /* Allocate UMS RFC data */
       if (urd = UMSRFCAllocData(&urb, args.name, args.passwd, args.server)) {

        /* Get maximum message size */
        {
         char *var;

         /* Get UMS variable */
         if (var = UMSReadConfigTags(urd->urd_Account,
                                      UMSTAG_CfgName, "MaxMsgSize",
                                      TAG_DONE)) {
          /* Get number */
          MaxMsgSize = strtol(var, NULL, 10);

          /* Free UMS variable */
          UMSFreeConfig(urd->urd_Account, var);
         }
        }

        /* Handle greeting and start SMTP command processing */
        rc = HandleGreeting(urd);

        UMSRFCFreeData(urd);
       } else
        fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n",
                         args.name, args.server ? args.server : "<default>");

       CloseLibrary(UMSRFCBase);
      } else
       fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

      CloseLibrary(UMSBase);
     } else
      fprintf(stderr, "Couldn't open ums.library!\n");

     FreeArgs(rda);
    } else
     fprintf(stderr, "Error in command line!\n");

    /* Any queued responses left? */
    FlushResponseBuffer();

    /* Send Goodbye message to client */
    if (rc == RETURN_OK)
     Send(SMTPDSocket, INTTOSTR(SMTP_CLOSING_CONNECTION)
                        " closing connection - goodbye!\r\n", 35, 0);
    else
     Send(SMTPDSocket, INTTOSTR(SMTP_SERVICE_NOT_AVAILABLE)
                        " service not available, closing connection\r\n", 47,
                        0);

    /* Close socket */
    Shutdown(SMTPDSocket, 2);
    CloseSocket(SMTPDSocket);
   } else
    fprintf(stderr, "Couldn't obtain socket!\n");

   CloseLibrary(SocketBase);
  } else
   fprintf(stderr, "Couldn't open bsdsocket.library!\n");

 } else
  fprintf(stderr, "This version of umssmtpd needs Kickstart V37 or better!\n");

 return(rc);
}
