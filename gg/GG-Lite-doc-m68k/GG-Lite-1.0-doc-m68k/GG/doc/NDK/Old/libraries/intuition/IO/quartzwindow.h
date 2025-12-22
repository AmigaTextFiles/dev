
/* quartzWindow.h -- This file implements a rather small window that */
/*                    appears in the right half of the screen.       */
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

#include "sysgads.h"

#define QUAR_LEFTEDGE 300
#define QUAR_TOPEDGE  50
#define QUAR_WIDTH    200
#define QUAR_HEIGHT   75

struct NewWindow quartzWindow =
    {
        QUAR_LEFTEDGE,
        QUAR_TOPEDGE,
        QUAR_WIDTH,
        QUAR_HEIGHT,
        -1,-1,       /* Plain vanilla DetailPen and BlockPen.       */
        CLOSEWINDOW, /* Tell program when close gadget has been hit */
        WINDOWCLOSE | SMART_REFRESH | ACTIVATE | WINDOWDRAG |
        WINDOWDEPTH | WINDOWSIZING | NOCAREREFRESH,
        NULL,          /* Pointer to the first gadget -- */
                       /*   may be initialized later.    */
        NULL,          /* No checkmark.          */
        "quartzWindow",   /* A silly title.      */
        NULL,          /* Attach a screen later. */
        NULL,          /* No bitmap.             */
        SYSGADSWIDTH,  /* Minimum width.         */
        SYSGADSHEIGHT, /* Minimum height.        */
        0xFFFF,        /* Maximum width.         */
        0xFFFF,        /* Maximum height.        */
        CUSTOMSCREEN   /* A screen of our own.   */
    };

