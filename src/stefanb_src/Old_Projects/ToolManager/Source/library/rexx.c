/*
 * rexx.c  V2.1
 *
 * ARexx support routines
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* ARexx library base */
struct Library *RexxSysBase;

/* Send an ARexx command */
BOOL SendARexxCommand(char *command, ULONG len)
{
 BOOL rc=FALSE;

 DEBUG_PRINTF("Send ARexx '%s'\n",command);

 /* Open ARexx system library */
 if (RexxSysBase=OpenLibrary(RXSNAME,0)) {
  struct RexxMsg *rxmsg;

  if (rxmsg=CreateRexxMsg(DummyPort,NULL,NULL)) {
   if (rxmsg->rm_Args[0]=CreateArgstring(command,len)) {
    struct MsgPort *ap; /* Port of ARexx resident process */

    /* Init Rexx message */
    rxmsg->rm_Action=RXCOMM|RXFF_NOIO;

    /* Find port and send message */
    Forbid();
    ap=FindPort("AREXX");
    if (ap) PutMsg(ap,(struct Message *) rxmsg);
    Permit();

    /* Success? */
    if (ap) {
     /* Yes, wait on reply and remove it */
     WaitPort(DummyPort);
     GetMsg(DummyPort);

     /* Check return code */
     rc=rxmsg->rm_Result1==RC_OK;
    }

    ClearRexxMsg(rxmsg,1);
   }
   DeleteRexxMsg(rxmsg);
  }
  CloseLibrary(RexxSysBase);
 }
 return(rc);
}
