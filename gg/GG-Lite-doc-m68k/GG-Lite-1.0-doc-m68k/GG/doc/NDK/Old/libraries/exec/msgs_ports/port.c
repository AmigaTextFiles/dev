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

/* port.c 10/89/EW
 * LC -b1 -cfist -v -y 
 * LINK with lc.lib amiga.lib
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <libraries/dos.h>

#ifdef LATTICE
#include <stdio.h>
#include <stdlib.h>
#include <proto/all.h>
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
#endif

VOID main(VOID);

BOOL SafePutToPort(struct Message *, STRPTR);

struct XYMessage {
    struct Message xy_Msg;
    UWORD          xy_X;
    UWORD          xy_Y;
};

VOID main(VOID)
{
    struct MsgPort *xymp, *xyreplymp;
    struct XYMessage *xymsg, *msg;
    ULONG portsig, usersig, signal;
    BOOL foundport, ABORT = FALSE;

    xymsg = (struct XYMessage *)AllocMem(sizeof(struct XYMessage), MEMF_PUBLIC);
    if (xymsg == 0) {
        printf("Not enough memory for message structure\n");
        exit(30);
    }

   /* In this example we set up the public XY port ourselves */

   xymp = CreatePort("xyport", 0);
   if (xymp == 0) {
       printf("Couldn't create xyport\n");   /* so much for the example */
       FreeMem(xymsg, sizeof(struct XYMessage));
       exit(30);
   }

    /* The replyport we'll use to get response */

    xyreplymp = CreatePort("xyreplyport", 0);
    if (xyreplymp == 0) {
        printf("Couldn't create xyreplyport\n");
        DeletePort((struct MsgPort *)xymp);
        FreeMem(xymsg, sizeof(struct XYMessage));
    }

    xymsg->xy_Msg.mn_Node.ln_Type = NT_MESSAGE;
    xymsg->xy_Msg.mn_Length = sizeof(struct XYMessage);
    xymsg->xy_Msg.mn_ReplyPort = xyreplymp;
    xymsg->xy_X = 10;
    xymsg->xy_Y = 20;

    foundport = SafePutToPort((struct Message *)xymsg, "xyport");
    if (!foundport) {             /* couldn't find port */
        DeletePort((struct MsgPort *)xyreplymp);
        DeletePort((struct MsgPort *)xymp);
        FreeMem(xymsg, sizeof(struct XYMessage));
    }

    /* we just found the port we created ourselves and put a message to it! WOW*/
    /* let's pretend we're the other guy now */

    printf("Exit with CTRL-F\n");   /* User can abort with CTRL-F */

    msg = (struct XYMessage *)WaitPort((struct MsgPort *)xymp);
                    /* doesn't wait since there HAS to be a message */
    
    while (msg = (struct XYMessage *)GetMsg((struct MsgPort *)xymp)) {
        printf("x = %d y = %d\n", msg->xy_X, msg->xy_Y);
        msg->xy_X += 50;
        msg->xy_Y += 50;
        ReplyMsg((struct Message *)msg);     /* reply to the sender */
    }

    /* We put on the other hat again & wait for the reply to our message sent */
    /* We'll use Wait() for this one */    

    portsig = 1 << xyreplymp->mp_SigBit;
    usersig = SIGBREAKF_CTRL_F;          /* User can break with CTRL-F */
    
    FOREVER {
        signal = Wait(portsig | usersig);     /* sleep 'till someone signals */
  
        if (signal & portsig) {               /* got a signal at the msgport */
            while (msg = (struct XYMessage *)GetMsg((struct MsgPort *)xyreplymp)) {
                printf("X = %d Y = %d\n", msg->xy_X, msg->xy_Y);
                /* no need to reply. WE have sent the message */
            }
	}
        if (signal & usersig) {
            while (msg = (struct XYMessage *)GetMsg((struct MsgPort *)xyreplymp));  /* just in case */
            ABORT = TRUE;
        }
        
        if (ABORT) {
            /* this about sums it up. let's clean up */
            DeletePort((struct MsgPort *)xyreplymp);
            DeletePort((struct MsgPort *)xymp);      /* the `other guy's' port */
            FreeMem(xymsg, sizeof(struct XYMessage));
            exit(0);
        }
    }
}

BOOL SafePutToPort(message, portname)
struct Message *message;
STRPTR          portname;
{
struct MsgPort *port;

    Forbid();
	port = FindPort(portname);
	if (port)
	    PutMsg(port,message);
    Permit();
    return((BOOL)port); /* If zero, the port has gone away */

    /* Once we do a Permit(), the port might go away and leave us with
     * an invalid port pointer. So we return just a BOOL to indicate whether
     * the message has been sent or not. 
     */
}
