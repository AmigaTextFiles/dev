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
 * Keyboard device matrix example...
 */

#include <exec/types.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <devices/inputevent.h>
#include <devices/keyboard.h>

#include <proto/exec.h>

#include <stdio.h>

int CXBRK(VOID) { return(0); }

VOID Display_Event(struct InputEvent *keyEvent)
{
    printf("Got key event: KeyCode: %2x  Quailifiers: %4x\n",
               keyEvent->ie_Code,
               keyEvent->ie_Qualifier);
}

VOID main(int argc, char *argv[])
{
struct IOStdReq   *keyRequest;
struct MsgPort    *keyPort;
struct InputEvent *keyEvent;
       SHORT      loop;

    if (keyPort=CreatePort(NULL,NULL))
    {
        if (keyRequest=(struct IOStdReq *)CreateExtIO(keyPort,
                                                  sizeof(struct IOStdReq)))
        {
            if (!OpenDevice("keyboard.device",NULL,
                             (struct IORequest *)keyRequest,NULL))
            {
                if (keyEvent=AllocMem(sizeof(struct InputEvent),MEMF_PUBLIC))
                {
                    for (loop=0;loop<4;loop++)
                    {
                        keyRequest->io_Command=KBD_READEVENT;
                        keyRequest->io_Data=(APTR)keyEvent;

                        /*
                         * We want 1 event, so we just set the
                         * length field to the size, in bytes
                         * of the event.  For multiple events,
                         * set this to a multiple of that size.
                         * The keyboard device NEVER fills partial
                         * events...
                         */
                        keyRequest->io_Length=sizeof(struct InputEvent);
                        DoIO((struct IORequest *)keyRequest);

                            /* Check for CLI startup... */
                        if (argc) Display_Event(keyEvent);
                    }
                    FreeMem(keyEvent,sizeof(struct InputEvent));
                }
                CloseDevice((struct IORequest *)keyRequest);
            }
            DeleteExtIO((struct IORequest *)keyRequest);
        }
        DeletePort(keyPort);
    }
}
