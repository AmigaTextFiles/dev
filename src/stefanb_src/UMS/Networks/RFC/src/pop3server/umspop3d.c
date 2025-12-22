/*
 * umspop3d.c V1.0.00
 *
 * UMS POP3 (server) main entry point
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umspop3d.h"

/* Constant strings */
static const char Version[]  = "$VER: umspop3d "
                               INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                               INTTOSTR(UMSRFC_REVISION)
                               " (" __COMMODORE_DATE__ ")";
static const char Template[] = "NAME,PASSWD,SERVER";

/* Local data */
static struct {
               char *name;
               char *passwd;
               char *server;
              } args = {"POP3D", "", NULL};

/* Global data */
struct Library *SocketBase, *UMSBase, *UMSRFCBase;
struct UMSRFCBases urb;
LONG POP3DSocket;
LONG ErrNo;

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
       ((POP3DSocket = ObtainSocket(dm->dm_Id, dm->dm_Family, dm->dm_Type, 0))) >= 0) {
    struct RDArgs *rda;

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

        /* Enter POP3 AUTHORIZATION state */
        rc = AuthorizationState(urd, args.server);

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

    /* Send Goodbye message to client */
    if (rc == RETURN_OK)
     Send(POP3DSocket, "+OK closing connection - goodbye!\r\n", 35, 0);
    else
     Send(POP3DSocket, "-ERR service not available, closing connection\r\n",
                       48, 0);

    /* Close socket */
    Shutdown(POP3DSocket, 2);
    CloseSocket(POP3DSocket);
   } else
    fprintf(stderr, "Couldn't obtain socket!\n");

   CloseLibrary(SocketBase);
  } else
   fprintf(stderr, "Couldn't open bsdsocket.library!\n");

 } else
  fprintf(stderr, "This version of umspop3d needs Kickstart V37 or better!\n");

 return(rc);
}
