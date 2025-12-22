@DATABASE "gg:doc/NDK/Guide/Include/images/drawlist.h"
@MASTER   "gg:os-include/images/drawlist.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:21
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/drawlist.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/drawlist.h" LINK File}


@{b}Structures@{ub}

@{"DrawList" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 68}


@{b}#defines@{ub}

@{"DLST_ADRAW" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 54}      @{"DLST_AFILL" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 55}           @{"DLST_AMOVE" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 53}
@{"DLST_ARC" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 57}        @{"DLST_BEVELBOX" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 56}        @{"DLST_BOUNDS" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 59}
@{"DLST_CIRCLE" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 50}     @{"DLST_ELLIPSE" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 49}         @{"DLST_END" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 44}
@{"DLST_FILL" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 48}       @{"DLST_FILLPAT" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 52}         @{"DLST_LINE" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 46}
@{"DLST_LINEPAT" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 51}    @{"DLST_LINESIZE" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 60}        @{"DLST_RECT" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 47}
@{"DLST_START" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 58}      @{"DRAWLIST_Directives" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 27}  @{"DRAWLIST_DrawInfo" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 36}
@{"DRAWLIST_Dummy" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 25}  @{"DRAWLIST_RefHeight" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 30}   @{"DRAWLIST_RefWidth" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 33}

@ENDNODE
@NODE File "images/drawlist.h"
#ifndef IMAGES_DRAWLIST_H
#define IMAGES_DRAWLIST_H
/*
**      $VER: drawlist.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the drawlist.image BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTRION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_IMAGECLASS_H
#include <@{"intuition/imageclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File"}>
#endif

/*****************************************************************************/

#define DRAWLIST_Dummy          (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x17000)

#define DRAWLIST_Directives     (@{"DRAWLIST_Dummy" LINK File 25}+1)
        /* (@{"struct DrawList" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File" 68} *) Pointer to drawlist directive array. */

#define DRAWLIST_RefHeight      (@{"DRAWLIST_Dummy" LINK File 25}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Reference height of drawlist. */

#define DRAWLIST_RefWidth       (@{"DRAWLIST_Dummy" LINK File 25}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Reference width of drawlist. */

#define DRAWLIST_DrawInfo       (@{"DRAWLIST_Dummy" LINK File 25}+4)
        /* Obsolete!! Do not use. */

/*****************************************************************************/

/* DrawList Primitive Directives
 */

#define DLST_END                0

#define DLST_LINE               1
#define DLST_RECT               2
#define DLST_FILL               3
#define DLST_ELLIPSE    4
#define DLST_CIRCLE             5
#define DLST_LINEPAT    6
#define DLST_FILLPAT    7
#define DLST_AMOVE              8
#define DLST_ADRAW              9
#define DLST_AFILL              10
#define DLST_BEVELBOX   11
#define DLST_ARC                12
#define DLST_START              13
#define DLST_BOUNDS             13
#define DLST_LINESIZE   14

/*****************************************************************************/

/* Pass an array of these via @{"DRAWLIST_Directives" LINK File 27}.
 * Last entry must be @{"DLST_END" LINK File 44}!
 */

struct DrawList
{
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} dl_Directive;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dl_X1, dl_Y1;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dl_X2, dl_Y2;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} dl_Pen;
};

#endif /* IMAGES_DRAWLIST_H */
@ENDNODE
