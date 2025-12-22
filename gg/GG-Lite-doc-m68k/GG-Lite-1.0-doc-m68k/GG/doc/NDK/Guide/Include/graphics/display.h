@DATABASE "gg:doc/NDK/Guide/Include/graphics/display.h"
@MASTER   "gg:os-include/graphics/display.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/display.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/display.h" LINK File}


@{b}#defines@{ub}

@{"COLORON" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 19}                @{"DBLPF" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 20}                @{"DFTCH_MASK" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 35}
@{"DIW_HORIZ_POS" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 30}          @{"DIW_VRTCL_POS" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 31}        @{"DIW_VRTCL_POS_SHIFT" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 32}
@{"HOLDNMODIFY" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 21}            @{"INTERLACE" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 22}            @{"MODE_640" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 14}
@{"PF2PRI" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 18}                 @{"PF_FINE_SCROLL_MASK" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 27}  @{"PFA_FINE_SCROLL" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 25}
@{"PFB_FINE_SCROLL_SHIFT" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 26}  @{"PLNCNTMSK" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 15}            @{"PLNCNTSHFT" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 17}
@{"VPOSRLOF" LINK "gg:doc/NDK/Guide/Include/graphics/display.h/File" 38}               

@ENDNODE
@NODE File "graphics/display.h"
#ifndef GRAPHICS_DISPLAY_H
#define GRAPHICS_DISPLAY_H
/*
**      $VER: display.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      include define file for display control registers
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

/* bplcon0 defines */
#define MODE_640    0x8000
#define PLNCNTMSK   0x7     /* how many bit planes? */
                                    /* 0 = none, 1->6 = 1->6, 7 = reserved */
#define PLNCNTSHFT  12              /* bits to shift for bplcon0 */
#define PF2PRI      0x40            /* bplcon2 bit */
#define COLORON     0x0200          /* disable color burst */
#define DBLPF       0x400
#define HOLDNMODIFY 0x800
#define INTERLACE   4               /* interlace mode for 400 */

/* bplcon1 defines */
#define PFA_FINE_SCROLL       0xF
#define PFB_FINE_SCROLL_SHIFT 4
#define PF_FINE_SCROLL_MASK   0xF

/* display window start and stop defines */
#define DIW_HORIZ_POS   0x7F       /* horizontal start/stop */
#define DIW_VRTCL_POS   0x1FF      /* vertical start/stop */
#define DIW_VRTCL_POS_SHIFT 7

/* Data fetch start/stop horizontal position */
#define DFTCH_MASK      0xFF

/* vposr bits */
#define VPOSRLOF        0x8000

#endif  /* GRAPHICS_DISPLAY_H */
@ENDNODE
