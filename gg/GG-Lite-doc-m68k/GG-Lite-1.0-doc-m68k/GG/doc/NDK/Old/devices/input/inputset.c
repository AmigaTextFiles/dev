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
 * This example changes the threshold and period of the key repeat...
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <devices/input.h>
#include <devices/timer.h>

#include <proto/all.h>

VOID main(VOID)
{
struct timerequest *inputReqBlk;
struct MsgPort     *inputPort;

    if (inputPort=CreatePort(NULL,NULL))
    {
        if (inputReqBlk=(struct timerequest *)CreateExtIO(inputPort,
                                                  sizeof(struct timerequest)))
        {
            if (!OpenDevice("input.device",NULL,
                             (struct IORequest *)inputReqBlk,NULL))
            {
                inputReqBlk->tr_node.io_Command=IND_SETTHRESH;
                inputReqBlk->tr_time.tv_secs=1;
                inputReqBlk->tr_time.tv_micro=500000;  /* 1.5 seconds */

                DoIO((struct IORequest *)inputReqBlk);

                inputReqBlk->tr_node.io_Command=IND_SETPERIOD;
                inputReqBlk->tr_time.tv_secs=0;
                inputReqBlk->tr_time.tv_micro=12000;  /* .012 seconds */

                DoIO((struct IORequest *)inputReqBlk);

                CloseDevice((struct IORequest *)inputReqBlk);
            }
            DeleteExtIO((struct IORequest *)inputReqBlk);
        }
        DeletePort(inputPort);
    }
}
