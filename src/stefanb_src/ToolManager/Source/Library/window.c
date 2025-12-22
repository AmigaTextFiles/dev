/*
 * window.c  V3.1
 *
 * ToolManager window IDCMP handling routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Local data */
static struct MsgPort *IDCMPPort;

/* Activate IDCMP */
#define DEBUGFUNCTION StartIDCMP
LONG StartIDCMP(void)
{
 LONG rc = -1;

 IDCMP_LOG(LOG0(Entry))

 /* Allocate message port */
 if (IDCMPPort = CreateMsgPort()) rc = IDCMPPort->mp_SigBit;

 IDCMP_LOG(LOG2(Result, "Port 0x%08lx Signal %ld", IDCMPPort, rc))

 return(rc);
}

/* Stop IDCMP */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopIDCMP
void StopIDCMP(void)
{
 IDCMP_LOG(LOG1(Port, "0x%08lx", IDCMPPort))

 DeleteMsgPort(IDCMPPort);
}

/* Handle IDCMP event */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleIDCMP
void HandleIDCMP(void)
{
 struct IntuiMessage *msg;

 IDCMP_LOG(LOG0(Entry))

 /* Empty message queue */
 while (msg = (struct IntuiMessage *) GetMsg(IDCMPPort)) {

  IDCMP_LOG(LOG3(Msg, "Class 0x%08lx Code 0x%08lx Object 0x%08lx",
                 msg->Class, msg->Code, msg->IDCMPWindow->UserData))

  /* Forward message to object (it will reply it) */
  DoMethod((Object *) msg->IDCMPWindow->UserData, TMM_IDCMPEvent, msg);
 }
}

/* Attach IDCMP port to a window */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AttachIDCMP
BOOL AttachIDCMP(Object *obj, struct Window *w, ULONG flags)
{
 /* Attach IDCMP to window */
 w->UserPort = IDCMPPort;

 /* Initialize windows user data */
 w->UserData = (APTR) obj;

 /* Activate IDCMP */
 return(ModifyIDCMP(w, flags));
}

/* Close a window safely */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SafeCloseWindow
void SafeCloseWindow(struct Window *w)
{
 IDCMP_LOG(LOG1(Window, "0x%08lx",w))

 /* Disable multitasking to avoid race conditions with Intuition */
 Forbid();

 /* Remove all messsages for this window */
 {
  struct IntuiMessage *msg;
  struct IntuiMessage *nextmsg = (struct IntuiMessage *)
                                  GetHead((struct MinList *)
                                          &w->UserPort->mp_MsgList);

  /* Scan messages on the message port */
  while (msg = nextmsg) {

   /* Get next message */
   nextmsg = (struct IntuiMessage *) GetSucc((struct MinNode *) msg);

   /* Does this message point to the window? */
   if (msg->IDCMPWindow == w) {

    /* Yes. Remove it from port */
    Remove((struct Node *) msg);

    /* Reply it */
    ReplyMsg((struct Message *) msg);
   }
  }
 }

 /* Clear UserPort so Intuition will not free it */
 w->UserPort = NULL;

 /* Tell Intuition to stop sending more messages to this window */
 ModifyIDCMP(w, 0);

 /* Enable multitasking */
 Permit();

 IDCMP_LOG(LOG0(IDCMP port cleaned up))

 /* and really close the window */
 CloseWindow(w);

 IDCMP_LOG(LOG0(Window closed))
}
