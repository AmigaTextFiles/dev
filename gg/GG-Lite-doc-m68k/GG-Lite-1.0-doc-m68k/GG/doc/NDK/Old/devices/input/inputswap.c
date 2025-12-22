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

/*
 * InputDevice example
 *
 * This example swaps the function of the left and right mouse buttons
 * The C code is just the wrapper that installs and removes the
 * input.device handler that does the work.
 *
 * The handler is written in assembly code since it is important that
 * handlers be as fast as possible while processing the input events.
 *
 * Compile and link as follows:
 *
 * LC -cfirst -v -w InputSwap.c
 *
 * Cape assemble:
 *
 * Casm -a InputHandler.a -i INCLUDE: -o InputHandler.o
 *
 * BLink:
 *
 * BLink from LIB:c.o+InputSwap.o+inputhandler.o LIB LIB:lcs.lib LIB:amiga.lib TO InputSwap
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <devices/input.h>
#include <intuition/intuition.h>

#include <proto/all.h>

UBYTE NameString[]="Button Swap";

struct NewWindow mywin={0,0,124,10,0,1,CLOSEWINDOW,
                        WINDOWDRAG|WINDOWCLOSE|SIMPLE_REFRESH|NOCAREREFRESH,
                        NULL,NULL,NameString,NULL,NULL,0,0,0,0,WBENCHSCREEN};

extern VOID ButtonSwap();

extern struct IntuitionBase *IntuitionBase;

/*
 * This routine opens a window and waits for the one event that
 * can happen (CLOSEWINDOW)  This is just to let the user play with
 * the swapped buttons and then close the program...
 */
VOID WaitForUser(VOID)
{
struct Window  *win;

    if (IntuitionBase=(struct IntuitionBase *)
                                    OpenLibrary("intuition.library",0L))
    {
        if (win=OpenWindow(&mywin))
        {
            WaitPort(win->UserPort);
            ReplyMsg(GetMsg(win->UserPort));

            CloseWindow(win);
        }
        CloseLibrary((struct Library *)IntuitionBase);
    }
}

VOID main(VOID)
{
struct IOStdReq  *inputReqBlk;
struct MsgPort   *inputPort;
struct Interrupt *inputHandler;

    if (inputPort=CreatePort(NULL,NULL))
    {
        if (inputHandler=AllocMem(sizeof(struct Interrupt),
                                   MEMF_PUBLIC|MEMF_CLEAR))
        {
            if (inputReqBlk=(struct IOStdReq *)CreateExtIO(inputPort,
                                                     sizeof(struct IOStdReq)))
            {
                if (!OpenDevice("input.device",NULL,
                                 (struct IORequest *)inputReqBlk,NULL))
                {
                    inputHandler->is_Code=ButtonSwap;
                    inputHandler->is_Data=NULL;
                    inputHandler->is_Node.ln_Pri=100;
                    inputHandler->is_Node.ln_Name=NameString;
                    inputReqBlk->io_Data=(APTR)inputHandler;
                    inputReqBlk->io_Command=IND_ADDHANDLER;
                    DoIO((struct IORequest *)inputReqBlk);

                    WaitForUser();

                    inputReqBlk->io_Data=(APTR)inputHandler;
                    inputReqBlk->io_Command=IND_REMHANDLER;
                    DoIO((struct IORequest *)inputReqBlk);

                    CloseDevice((struct IORequest *)inputReqBlk);
                }
                DeleteExtIO((struct IORequest *)inputReqBlk);
            }
            FreeMem(inputHandler,sizeof(struct Interrupt));
        }
        DeletePort(inputPort);
    }
}
