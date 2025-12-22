
/* graniteWindow.h -- This file implements a fairly ordinary window. */
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

#define GRAN_LEFTEDGE 20
#define GRAN_TOPEDGE  20
#define GRAN_WIDTH  400
#define GRAN_HEIGHT 150

struct NewWindow graniteWindow =
    {
        GRAN_LEFTEDGE,
        GRAN_TOPEDGE,
        GRAN_WIDTH,
        GRAN_HEIGHT,
        0,1,         /* Plain vanilla DetailPen and BlockPen.       */
        CLOSEWINDOW, /* Tell program when close gadget has been hit */
        WINDOWCLOSE | SMART_REFRESH | ACTIVATE | WINDOWDRAG |
        WINDOWDEPTH | WINDOWSIZING | NOCAREREFRESH,
        NULL,             /* Pointer to the first gadget -- */
                          /*   may be initialized later.    */
        NULL,             /* No checkmark.   */
        "graniteWindow",  /* Window title.   */
        NULL,             /* Attach a screen later.  */
        NULL,             /* No bitmap.          */
        SYSGADSWIDTH,     /* Minimum width.      */
        SYSGADSHEIGHT,    /* Minimum height.     */
        0xFFFF,           /* Maximum width.      */
        0xFFFF,           /* Maximum height.     */
        CUSTOMSCREEN      /* A screen of our own. */
    };
