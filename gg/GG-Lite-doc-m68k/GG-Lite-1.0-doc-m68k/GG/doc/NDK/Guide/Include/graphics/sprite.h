@DATABASE "gg:doc/NDK/Guide/Include/graphics/sprite.h"
@MASTER   "gg:os-include/graphics/sprite.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/sprite.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/sprite.h" LINK File}


@{b}Structures@{ub}

@{"ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25}  @{"SimpleSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 17}


@{b}#defines@{ub}

@{"GSTAG_ATTACHED" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 44}         @{"GSTAG_SCANDOUBLED" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 48}     @{"GSTAG_SOFTSPRITE" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 45}
@{"GSTAG_SPRITE_NUM" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 43}       @{"SPRITE_ATTACHED" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 15}       @{"SPRITEA_Attached" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 39}
@{"SPRITEA_OldDataFormat" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 40}  @{"SPRITEA_OutputHeight" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 38}  @{"SPRITEA_Width" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 35}
@{"SPRITEA_XReplication" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 36}   @{"SPRITEA_YReplication" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 37}  

@ENDNODE
@NODE File "graphics/sprite.h"
#ifndef GRAPHICS_SPRITE_H
#define GRAPHICS_SPRITE_H
/*
**      $VER: sprite.h 39.6 (16.6.1992)
**      Includes Release 45.1
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#define SPRITE_ATTACHED 0x80

struct SimpleSprite
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *posctldata;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} height;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   x,y;    /* current position */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   num;
};

struct ExtSprite
{
        @{"struct SimpleSprite" LINK File 17} es_SimpleSprite;    /* conventional simple sprite structure */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   es_wordwidth;                   /* graphics use only, subject to change */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   es_flags;                       /* graphics use only, subject to change */
};



/* tags for @{"AllocSpriteData()" LINK "gg:doc/NDK/Guide/graphics/AllocSpriteDataA"} */
#define SPRITEA_Width           0x81000000
#define SPRITEA_XReplication    0x81000002
#define SPRITEA_YReplication    0x81000004
#define SPRITEA_OutputHeight    0x81000006
#define SPRITEA_Attached        0x81000008
#define SPRITEA_OldDataFormat   0x8100000a      /* MUST pass in outputheight if using this tag */

/* tags for @{"GetExtSprite()" LINK "gg:doc/NDK/Guide/graphics/GetExtSpriteA"} */
#define GSTAG_SPRITE_NUM 0x82000020
#define GSTAG_ATTACHED   0x82000022
#define GSTAG_SOFTSPRITE 0x82000024

/* tags valid for either @{"GetExtSprite" LINK "gg:doc/NDK/Guide/graphics/GetExtSpriteA"} or @{"ChangeExtSprite" LINK "gg:doc/NDK/Guide/graphics/ChangeExtSpriteA"} */
#define GSTAG_SCANDOUBLED       0x83000000      /* request "@{"NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 138}-Like" height if possible. */

#endif  /* GRAPHICS_SPRITE_H */
@ENDNODE
