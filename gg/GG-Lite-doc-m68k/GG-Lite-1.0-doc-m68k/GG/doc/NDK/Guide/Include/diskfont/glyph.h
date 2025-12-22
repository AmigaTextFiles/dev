@DATABASE "gg:doc/NDK/Guide/Include/diskfont/glyph.h"
@MASTER   "gg:os-include/diskfont/glyph.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "diskfont/glyph.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"diskfont/glyph.h" LINK File}


@{b}Structures@{ub}

@{"GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26}  @{"GlyphMap" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 34}  @{"GlyphWidthEntry" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 51}


@{b}Typedefs@{ub}

@{"FIXED" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 32}

@ENDNODE
@NODE File "diskfont/glyph.h"
#ifndef  DISKFONT_GLYPH_H
#define  DISKFONT_GLYPH_H
/*
**      $VER: glyph.h 9.1 (19.6.1992)
**      Includes Release 45.1
**
**      glyph.h -- structures for glyph libraries
**
**      (C) Copyright 1991-1992 Robert R. Burns
**          All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#ifndef  EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

/* A GlyphEngine must be acquired via @{"OpenEngine" LINK "gg:doc/NDK/Guide/bullet/OpenEngine"} and is read-only */
struct GlyphEngine {
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *gle_Library; /* engine library */
    char *gle_Name;             /* library basename: e.g. "bullet" */
    /* private library data follows... */
};

typedef @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} FIXED;             /* 32 bit signed w/ 16 bits of fraction */

struct GlyphMap {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BMModulo;       /* # of bytes in row: always multiple of 4 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BMRows;         /* # of rows in bitmap */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BlackLeft;      /* # of blank pixel columns at left */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BlackTop;       /* # of blank rows at top */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BlackWidth;     /* span of contiguous non-blank columns */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   glm_BlackHeight;    /* span of contiguous non-blank rows */
    @{"FIXED" LINK File 32}   glm_XOrigin;        /* distance from upper left corner of bitmap */
    @{"FIXED" LINK File 32}   glm_YOrigin;        /*   to initial CP, in fractional pixels */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    glm_X0;             /* approximation of XOrigin in whole pixels */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    glm_Y0;             /* approximation of YOrigin in whole pixels */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    glm_X1;             /* approximation of XOrigin + Width */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    glm_Y1;             /* approximation of YOrigin + Width */
    @{"FIXED" LINK File 32}   glm_Width;          /* character advance, as fraction of em width */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}  *glm_BitMap;         /* actual glyph bitmap */
};

struct GlyphWidthEntry {
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} gwe_Node;    /* on list returned by @{"OT_WidthList" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfonttag.h/File" 143} inquiry */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   gwe_Code;           /* entry's character code value */
    @{"FIXED" LINK File 32}   gwe_Width;          /* character advance, as fraction of em width */
};
#endif   /* DISKFONT_GLYPH_H */
@ENDNODE
