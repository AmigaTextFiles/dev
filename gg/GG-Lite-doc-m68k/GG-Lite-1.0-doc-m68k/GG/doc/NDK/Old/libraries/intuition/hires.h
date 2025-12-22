
/* hires.h --  Declare and initialize a NewScreen structure */
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

struct NewScreen fullHires =
    {
    0,                /* the LeftEdge must be zero */
    0,                /* TopEdge */
    640,              /* Width (high-resolution) */
    STDSCREENHEIGHT,  /* Height (non-interlace)  */
    2,                /* Depth (4 colors will be available) */
    0, 1,             /* DetailPen and BlockPen specifications */
    HIRES,            /* the high-resolution display mode */
    CUSTOMSCREEN,     /* the screen type */
    NULL,             /* no special font */
    "Our Own Screen", /* the screen title */
    NULL,             /* no special screen gadgets */
    NULL              /* no CustomBitMap */
    };

/* End of hires.h */
