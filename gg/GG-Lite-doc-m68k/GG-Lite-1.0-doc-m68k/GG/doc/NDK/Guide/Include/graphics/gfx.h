@DATABASE "gg:doc/NDK/Guide/Include/graphics/gfx.h"
@MASTER   "gg:os-include/graphics/gfx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/gfx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/gfx.h" LINK File}


@{b}Structures@{ub}

@{"BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46}  @{"Rect32" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 33}  @{"Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}  @{"tPoint" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}


@{b}Typedefs@{ub}

@{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44}  @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}


@{b}#defines@{ub}

@{"AGNUS" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 20}            @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}           @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}           @{"BMA_DEPTH" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 77}
@{"BMA_FLAGS" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 79}        @{"BMA_HEIGHT" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 76}       @{"BMA_WIDTH" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 78}        @{"BMB_CLEAR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 63}
@{"BMB_DISPLAYABLE" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 64}  @{"BMB_INTERLEAVED" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 65}  @{"BMB_MINPLANES" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 67}    @{"BMB_STANDARD" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 66}
@{"BMF_CLEAR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 69}        @{"BMF_DISPLAYABLE" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 70}  @{"BMF_INTERLEAVED" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 71}  @{"BMF_MINPLANES" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 73}
@{"BMF_STANDARD" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 72}     @{"RASSIZE()" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 60}        @{"TOBB()" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 22}           

@ENDNODE
@NODE File "graphics/gfx.h"
#ifndef GRAPHICS_GFX_H
#define GRAPHICS_GFX_H
/*
**      $VER: gfx.h 39.5 (19.3.1992)
**      Includes Release 45.1
**
**      general include file for application programs
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#define BITSET  0x8000
#define BITCLR  0

#define AGNUS
#ifdef AGNUS
#define @{"TOBB" LINK "File" 24}(a)      ((long)(a))
#else
#define @{"TOBB" LINK "File" 22}(a)      ((long)(a)>>1)  /* convert Chip adr to Bread Board Adr */
#endif

struct Rectangle
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   MinX,MinY;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   MaxX,MaxY;
};

struct Rect32
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    MinX,MinY;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    MaxX,MaxY;
};

typedef struct tPoint
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} x,y;
} Point;

typedef @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *PLANEPTR;

struct BitMap
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   BytesPerRow;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Rows;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Depth;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pad;
    @{"PLANEPTR" LINK File 44} Planes[8];
};

/* This macro is obsolete as of V39. @{"AllocBitMap()" LINK "gg:doc/NDK/Guide/graphics/AllocBitMap"} should be used for allocating
   bitmap data, since it knows about the machine's particular alignment
   restrictions.
*/
#define RASSIZE(w,h)    ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})(h)*( ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})(w)+15)>>3&0xFFFE))

/* flags for @{"AllocBitMap" LINK "gg:doc/NDK/Guide/graphics/AllocBitMap"}, etc. */
#define BMB_CLEAR 0
#define BMB_DISPLAYABLE 1
#define BMB_INTERLEAVED 2
#define BMB_STANDARD 3
#define BMB_MINPLANES 4

#define BMF_CLEAR (1l<<@{"BMB_CLEAR" LINK File 63})
#define BMF_DISPLAYABLE (1l<<@{"BMB_DISPLAYABLE" LINK File 64})
#define BMF_INTERLEAVED (1l<<@{"BMB_INTERLEAVED" LINK File 65})
#define BMF_STANDARD (1l<<@{"BMB_STANDARD" LINK File 66})
#define BMF_MINPLANES (1l<<@{"BMB_MINPLANES" LINK File 67})

/* the following are for @{"GetBitMapAttr()" LINK "gg:doc/NDK/Guide/graphics/GetBitMapAttr"} */
#define BMA_HEIGHT 0
#define BMA_DEPTH 4
#define BMA_WIDTH 8
#define BMA_FLAGS 12

#endif  /* GRAPHICS_GFX_H */
@ENDNODE
