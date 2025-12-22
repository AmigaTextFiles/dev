@DATABASE "gg:doc/NDK/Guide/Include/images/glyph.h"
@MASTER   "gg:os-include/images/glyph.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:22
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/glyph.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/glyph.h" LINK File}


@{b}#defines@{ub}

@{"GLYPH_BDOWNARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 52}    @{"GLYPH_BLEFTARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 54}  @{"GLYPH_BRIGHTARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 55}
@{"GLYPH_BUPARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 53}      @{"GLYPH_CHECKMARK" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 44}   @{"GLYPH_CYCLE" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 57}
@{"GLYPH_DOWNARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 38}     @{"GLYPH_DrawInfo" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 30}    @{"GLYPH_DROPDOWN" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 42}
@{"GLYPH_DROPDOWNMENU" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 56}  @{"GLYPH_Dummy" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 25}       @{"GLYPH_Glyph" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 27}
@{"GLYPH_LEFTARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 40}     @{"GLYPH_NONE" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 37}        @{"GLYPH_POPDRAWER" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 47}
@{"GLYPH_POPFILE" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 46}       @{"GLYPH_POPFONT" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 45}     @{"GLYPH_POPSCREENMODE" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 48}
@{"GLYPH_POPTIME" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 49}       @{"GLYPH_POPUP" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 43}       @{"GLYPH_RADIOBUTTON" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 50}
@{"GLYPH_RETURNARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 51}   @{"GLYPH_RIGHTARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 41}  @{"GLYPH_UPARROW" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File" 39}

@ENDNODE
@NODE File "images/glyph.h"
#ifndef IMAGES_GLYPH_H
#define IMAGES_GLYPH_H
/*
**      $VER: glyph.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the glyph.image BOOPSI class
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

#define GLYPH_Dummy                     (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x15000)

#define GLYPH_Glyph                     (@{"GLYPH_Dummy" LINK File 25}+1)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Glyph type to draw, see below.  Defaults to @{"GLYPH_NONE" LINK File 37}. */

#define GLYPH_DrawInfo          (@{"GLYPH_Dummy" LINK File 25}+2)
        /* Obsolete - do not use */

/*****************************************************************************/

/* Defines for @{"GLYPH_Glyph" LINK File 27}
 */
#define GLYPH_NONE                      0
#define GLYPH_DOWNARROW         1
#define GLYPH_UPARROW           2
#define GLYPH_LEFTARROW         3
#define GLYPH_RIGHTARROW        4
#define GLYPH_DROPDOWN          5
#define GLYPH_POPUP                     6
#define GLYPH_CHECKMARK         7
#define GLYPH_POPFONT           8
#define GLYPH_POPFILE           9
#define GLYPH_POPDRAWER     10
#define GLYPH_POPSCREENMODE 11
#define GLYPH_POPTIME       12
#define GLYPH_RADIOBUTTON       18
#define GLYPH_RETURNARROW   20
#define GLYPH_BDOWNARROW        21
#define GLYPH_BUPARROW          22
#define GLYPH_BLEFTARROW        23
#define GLYPH_BRIGHTARROW       24
#define GLYPH_DROPDOWNMENU 25
#define GLYPH_CYCLE        26

#endif /* IMAGES_GLYPH_H */
@ENDNODE
