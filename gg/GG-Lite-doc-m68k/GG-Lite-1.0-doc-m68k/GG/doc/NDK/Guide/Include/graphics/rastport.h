@DATABASE "gg:doc/NDK/Guide/Include/graphics/rastport.h"
@MASTER   "gg:os-include/graphics/rastport.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/rastport.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/rastport.h" LINK File}


@{b}Structures@{ub}

@{"AreaInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 19}  @{"GelsInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 37}  @{"RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}  @{"TmpRas" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 30}


@{b}#defines@{ub}

@{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103}  @{"COMPLEMENT" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 92}  @{"DBUFFER" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 98}  @{"FRST_DOT" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 96}  @{"INVERSVID" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 93}  @{"JAM1" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 90}  @{"JAM2" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 91}
@{"NOCROSSFILL" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 104}  @{"ONE_DOT" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 97}     

@ENDNODE
@NODE File "graphics/rastport.h"
#ifndef GRAPHICS_RASTPORT_H
#define GRAPHICS_RASTPORT_H
/*
**      $VER: rastport.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif

struct AreaInfo
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   *VctrTbl;         /* ptr to start of vector table */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   *VctrPtr;         /* ptr to current vertex */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    *FlagTbl;         /* ptr to start of vector flag table */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    *FlagPtr;         /* ptrs to areafill flags */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   Count;            /* number of vertices in list */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   MaxCount;         /* @{"AreaMove" LINK "gg:doc/NDK/Guide/graphics/AreaMove"}/Draw will not allow Count>MaxCount*/
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   FirstX,FirstY;    /* first point for this polygon */
};

struct TmpRas
{
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *RasPtr;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} Size;
};

/* unoptimized for 32bit alignment of pointers */
struct GelsInfo
{
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} sprRsrvd;            /* flag of which sprites to reserve from
                                 vsprite system */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} Flags;              /* system use */
    @{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *gelHead, *gelTail; /* dummy vSprites for list management*/
    /* pointer to array of 8 WORDS for sprite available lines */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} *nextLine;
    /* pointer to array of 8 pointers for color-last-assigned to vSprites */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} **lastColor;
    @{"struct collTable" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 265} *collHandler;     /* addresses of collision routines */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} leftmost, rightmost, topmost, bottommost;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} firstBlissObj,lastBlissObj;    /* system use only */
};

struct RastPort
{
    @{"struct  Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *Layer;
    @{"struct  BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46}   *BitMap;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  *AreaPtrn;        /* ptr to areafill pattern */
    @{"struct  TmpRas" LINK File 30} *TmpRas;
    @{"struct  AreaInfo" LINK File 19} *AreaInfo;
    @{"struct  GelsInfo" LINK File 37} *GelsInfo;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Mask;             /* write mask for this raster */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    FgPen;            /* foreground pen for this raster */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    BgPen;            /* background pen  */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    AOlPen;           /* areafill outline pen */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    DrawMode;         /* drawing mode for fill, lines, and text */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    AreaPtSz;         /* 2^n words for areafill pattern */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    linpatcnt;        /* current line drawing pattern preshift */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    dummy;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  Flags;            /* miscellaneous control bits */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  LinePtrn;         /* 16 bits for textured lines */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   cp_x, cp_y;       /* current pen position */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   minterms[8];
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   PenWidth;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   PenHeight;
    @{"struct  TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *Font;   /* current font address */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   AlgoStyle;        /* the algorithmically generated style */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TxFlags;          /* text specific flags */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TxHeight;         /* text height */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TxWidth;          /* text nominal width */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TxBaseline;       /* text baseline */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    TxSpacing;        /* text spacing (per character) */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    *RP_User;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   longreserved[2];
#ifndef GFX_RASTPORT_1_2
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   wordreserved[7];  /* used to be a node */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   reserved[8];      /* for future use */
#endif
};

/* drawing modes */
#define JAM1        0         /* jam 1 color into raster */
#define JAM2        1         /* jam 2 colors into raster */
#define COMPLEMENT  2         /* XOR bits into raster */
#define INVERSVID   4         /* inverse video for drawing modes */

/* these are the flag bits for RastPort flags */
#define FRST_DOT    0x01      /* draw the first dot of this line ? */
#define ONE_DOT     0x02      /* use one dot mode for drawing lines */
#define DBUFFER     0x04      /* flag set when RastPorts
                                 are double-buffered */

             /* only used for bobs */

#define AREAOUTLINE 0x08      /* used by areafiller */
#define NOCROSSFILL 0x20      /* areafills have no crossovers */

/* there is only one style of clipping: raster clipping */
/* this preserves the continuity of jaggies regardless of clip window */
/* When drawing into a RastPort, if the ptr to ClipRect is nil then there */
/* is no clipping done, this is dangerous but useful for speed */

#endif  /* GRAPHICS_RASTPORT_H */
@ENDNODE
