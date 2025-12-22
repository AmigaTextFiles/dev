@DATABASE "gg:doc/NDK/Guide/Include/graphics/scale.h"
@MASTER   "gg:os-include/graphics/scale.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/scale.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/scale.h" LINK File}


@{b}Structures@{ub}

@{"BitScaleArgs" LINK "gg:doc/NDK/Guide/Include/graphics/scale.h/File" 17}

@ENDNODE
@NODE File "graphics/scale.h"
#ifndef GRAPHICS_SCALE_H
#define GRAPHICS_SCALE_H
/*
**      $VER: scale.h 39.0 (21.8.1991)
**      Includes Release 45.1
**
**      structure argument to @{"BitMapScale()" LINK "gg:doc/NDK/Guide/graphics/BitMapScale"}
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

struct BitScaleArgs {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_SrcX, bsa_SrcY;                 /* source origin */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_SrcWidth, bsa_SrcHeight;        /* source size */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_XSrcFactor, bsa_YSrcFactor;     /* scale factor denominators */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_DestX, bsa_DestY;               /* destination origin */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_DestWidth, bsa_DestHeight;      /* destination size result */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_XDestFactor, bsa_YDestFactor;   /* scale factor numerators */
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *bsa_SrcBitMap;               /* source BitMap */
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *bsa_DestBitMap;              /* destination BitMap */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bsa_Flags;                          /* reserved.  Must be zero! */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bsa_XDDA, bsa_YDDA;                 /* reserved */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    bsa_Reserved1;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    bsa_Reserved2;
};
#endif  /* GRAPHICS_SCALE_H */
@ENDNODE
