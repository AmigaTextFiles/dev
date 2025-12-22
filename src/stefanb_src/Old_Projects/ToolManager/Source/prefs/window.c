/*
 * window.c  V2.1
 *
 * safe window close function
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Wait pointer image data */
__chip static const UWORD WaitPointer[]={
                                         0x0000, 0x0000,

                                         0x0400, 0x07c0,
                                         0x0000, 0x07c0,
                                         0x0100, 0x0380,
                                         0x0000, 0x07e0,
                                         0x07c0, 0x1ff8,
                                         0x1ff0, 0x3fec,
                                         0x3ff8, 0x7fde,
                                         0x3ff8, 0x7fbe,
                                         0x7ffc, 0xff7f,
                                         0x7efc, 0xffff,
                                         0x7ffc, 0xffff,
                                         0x3ff8, 0x7ffe,
                                         0x3ff8, 0x7ffe,
                                         0x1ff0, 0x3ffc,
                                         0x07c0, 0x1ff8,
                                         0x0000, 0x07e0,

                                         0x0000, 0x0000
                                        };

/* Close a window safely */
void CloseWindowSafely(struct Window *w)
{
 struct IntuiMessage *msg;

 DEBUG_PRINTF("CloseWindowSafely: 0x%08lx\n",w);

 /* we forbid here to keep out of race conditions with Intuition */
 Forbid();

 /* Remove all messsages for this window */
 msg=GetHead(&w->UserPort->mp_MsgList);
 while (msg)
  /* Does this message point to the window? */
  if (msg->IDCMPWindow==w) {
   struct IntuiMessage *nextmsg=GetSucc(msg);

   /* Yes. Remove it from port */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);

   /* Get pointer to next message */
   msg=nextmsg;
  }
   /* No. Get pointer to next message */
  else msg=GetSucc(msg);

 /* clear UserPort so Intuition will not free it */
 w->UserPort=NULL;

 /* tell Intuition to stop sending more messages */
 ModifyIDCMP(w,0);

 /* turn multitasking back on */
 Permit();

 DEBUG_PRINTF("Closing window\n");

 /* and really close the window */
 CloseWindow(w);

 DEBUG_PRINTF("Window closed\n");
}

/* Disable a window */
void DisableWindow(struct Window *w, struct Requester *req)
{
 /* Disable IDCMP */
 ModifyIDCMP(w,IDCMP_REFRESHWINDOW);

 /* Block window input */
 Request(req,w);

 /* Set wait pointer */
 if (OSV39)
  SetWindowPointer(w,WA_BusyPointer,TRUE,TAG_DONE);
 else
  SetPointer(w,WaitPointer,16,16,-6,0);
}

/* Enable a window */
void EnableWindow(struct Window *w, struct Requester *req, ULONG idcmp)
{
 /* Clear wait pointer */
 if (OSV39)
  SetWindowPointer(w,TAG_DONE);
 else
  ClearPointer(w);

 /* Enable window input */
 EndRequest(req,w);

 /* Enable IDCMP */
 ModifyIDCMP(w,idcmp);
}
