@DATABASE "gg:doc/NDK/Guide/Include/graphics/regions.h"
@MASTER   "gg:os-include/graphics/regions.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/regions.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/regions.h" LINK File}


@{b}Structures@{ub}

@{"Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25}  @{"RegionRectangle" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 19}

@ENDNODE
@NODE File "graphics/regions.h"
#ifndef GRAPHICS_REGIONS_H
#define GRAPHICS_REGIONS_H
/*
**      $VER: regions.h 39.0 (21.8.1991)
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

struct RegionRectangle
{
    struct RegionRectangle *Next,*Prev;
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} bounds;
};

struct Region
{
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} bounds;
    @{"struct RegionRectangle" LINK File 19} *RegionRectangle;
};

#endif  /* GRAPHICS_REGIONS_H */
@ENDNODE
