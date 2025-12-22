
/* agateWindow.h -- This file implements a borderless backdrop */
/*                   window.                                   */

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

#define AGAT_LEFTEDGE 0
#define AGAT_TOPEDGE  0
#define AGAT_WIDTH    0
#define AGAT_HEIGHT   0

struct NewWindow agateWindow =
    {
        AGAT_LEFTEDGE,
        AGAT_TOPEDGE,
        640,
        200,
        -1,-1,       /* Plain vanilla DetailPen and BlockPen */
                     /* Use the defaults.                    */
        NULL,        /* IDCMP Flags can be added later. */
        SMART_REFRESH | ACTIVATE | NOCAREREFRESH | BORDERLESS
                | BACKDROP,
        NULL,        /* Pointer to the first gadget -- */
                     /*  may be initialized later.     */
        NULL,        /* No checkmark.   */
        NULL,        /* No title.       */
        NULL,        /* Attach a screen later. */
        NULL,        /* No BitMap.      */
        AGAT_WIDTH,  /* Minimum width.  */
        AGAT_HEIGHT, /* Minimum height. */
        AGAT_WIDTH,  /* Maximum width.  */
        AGAT_HEIGHT, /* Maximum height. */
        CUSTOMSCREEN /* A screen of our own. */
    };

/* End of agateWindow.h */
