/** CloseWindowSafely.c **/
/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/ports.h>
#include <intuition/intuition.h>

/* this function closes an intuition window that shares a port with
 * other intuition windows.
 *
 * It is careful to set the UserPort to null before closing, and to
 * free any messages that might have been sent.
 */

CloseWindowSafely(win)
struct Window *win;
   {
   Forbid();

   /* Send back any unprocessed messages for this window */
   StripIntuiMessages(win->UserPort,win);

   /* Null UserPort so Intuition won't free it */
   win->UserPort = NULL;

   /* Tell Intuition to stop sending more messages */
   ModifyIDCMP(win,0);

   /* Turn tasking back on */
   Permit();

   /* And really close the window */
   CloseWindow(win);
   }

StripIntuiMessages(mp,win)
struct MsgPort *mp;
struct Window *win;
   {
   struct IntuiMessage *msg, *succ;

   msg = mp->mp_MsgList.lh_Head;

   while(succ = msg->ExecMessage.mn_Node.ln_Succ)
      {
      if(msg->IDCMPWindow == win)
         {
         /* Intuition is about to rudely free this message.
          * Make sure that we have politely sent it back.
          */
         Remove(msg);
         ReplyMsg(msg);
         }
      msg = succ;
      }
   }
