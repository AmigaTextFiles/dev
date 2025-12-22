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
 * This example adds a few mouse movements to the input chain...
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <devices/input.h>
#include <devices/inputevent.h>

#include <proto/all.h>

VOID main(VOID)
{
struct IOStdReq   *inputReqBlk;
struct MsgPort    *inputPort;
struct InputEvent *FakeEvent;
       short      loop;
       short      num;
       short      numloop;

    if (inputPort=CreatePort(NULL,NULL))
    {
        if (FakeEvent=AllocMem(sizeof(struct InputEvent),MEMF_PUBLIC))
        {
            if (inputReqBlk=(struct IOStdReq *)CreateExtIO(inputPort,
                                                     sizeof(struct IOStdReq)))
            {
                if (!OpenDevice("input.device",NULL,
                                 (struct IORequest *)inputReqBlk,NULL))
                {
                    for (numloop=0;numloop<4;numloop++)
                     for (loop=0;loop<8;loop++)
                      for (num=0;num<20;num++)
                    {
                        FakeEvent->ie_NextEvent=NULL;
                        FakeEvent->ie_Class=IECLASS_RAWMOUSE;
                        FakeEvent->ie_Code=IECODE_NOBUTTON;
                        FakeEvent->ie_Qualifier=IEQUALIFIER_RELATIVEMOUSE;
                        FakeEvent->ie_X=0;
                        FakeEvent->ie_Y=0;

                        switch (loop)
                        {
                        case 0: FakeEvent->ie_X=1;
                        case 1: FakeEvent->ie_Y=1;  break;
                        case 2: FakeEvent->ie_Y=1;
                        case 3: FakeEvent->ie_X=-1; break;
                        case 4: FakeEvent->ie_X=-1;
                        case 5: FakeEvent->ie_Y=-1; break;
                        case 6: FakeEvent->ie_Y=-1;
                        case 7: FakeEvent->ie_X=1;  break;
                        }

                        inputReqBlk->io_Data=(APTR)FakeEvent;
                        inputReqBlk->io_Command=IND_WRITEEVENT;
                        inputReqBlk->io_Flags=0;
                        inputReqBlk->io_Length=sizeof(struct InputEvent);
                        DoIO((struct IORequest *)inputReqBlk);
                    }
                    CloseDevice((struct IORequest *)inputReqBlk);
                }
                DeleteExtIO((struct IORequest *)inputReqBlk);
            }
            FreeMem(FakeEvent,sizeof(struct InputEvent));
        }
        DeletePort(inputPort);
    }
}
