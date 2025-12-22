@DATABASE "gg:doc/NDK/Guide/Include/intuition/pointerclass.h"
@MASTER   "gg:os-include/intuition/pointerclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:15
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/pointerclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/pointerclass.h" LINK File}


@{b}#defines@{ub}

@{"POINTERA_BitMap" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 41}               @{"POINTERA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 39}           @{"POINTERA_WordWidth" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 44}
@{"POINTERA_XOffset" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 42}              @{"POINTERA_XResolution" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 45}     @{"POINTERA_YOffset" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 43}
@{"POINTERA_YResolution" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 46}          @{"POINTERXRESN_140NS" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 74}       @{"POINTERXRESN_35NS" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 76}
@{"POINTERXRESN_70NS" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 75}             @{"POINTERXRESN_DEFAULT" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 73}     @{"POINTERXRESN_HIRES" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 80}
@{"POINTERXRESN_LORES" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 79}            @{"POINTERXRESN_SCREENRES" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 78}   @{"POINTERYRESN_DEFAULT" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 110}
@{"POINTERYRESN_HIGH" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 111}             @{"POINTERYRESN_HIGHASPECT" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 112}  @{"POINTERYRESN_SCREENRES" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 113}
@{"POINTERYRESN_SCREENRESASPECT" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File" 114}  

@ENDNODE
@NODE File "intuition/pointerclass.h"
#ifndef INTUITION_POINTERCLASS_H
#define INTUITION_POINTERCLASS_H
/*
**  $VER: pointerclass.h 39.6 (15.2.1993)
**  Includes Release 45.1
**
**  'boopsi' pointer class interface
**
**  (C) Copyright 1992-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/* The following tags are recognized at @{"NewObject()" LINK "gg:doc/NDK/Guide/intuition/NewObject"} time by
 * pointerclass:
 *
 * @{"POINTERA_BitMap" LINK File 41} (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *) - Pointer to bitmap to
 *      get pointer imagery from.  Bitplane data need not be
 *      in chip RAM.
 * @{"POINTERA_XOffset" LINK File 42} (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) - X-offset of the pointer hotspot.
 * @{"POINTERA_YOffset" LINK File 43} (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) - Y-offset of the pointer hotspot.
 * @{"POINTERA_WordWidth" LINK File 44} (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) - designed width of the pointer in words
 * @{"POINTERA_XResolution" LINK File 45} (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) - one of the POINTERXRESN_ flags below
 * @{"POINTERA_YResolution" LINK File 46} (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) - one of the POINTERYRESN_ flags below
 *
 */

#define POINTERA_Dummy  (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x39000)

#define POINTERA_BitMap         (@{"POINTERA_Dummy" LINK File 39} + 0x01)
#define POINTERA_XOffset        (@{"POINTERA_Dummy" LINK File 39} + 0x02)
#define POINTERA_YOffset        (@{"POINTERA_Dummy" LINK File 39} + 0x03)
#define POINTERA_WordWidth      (@{"POINTERA_Dummy" LINK File 39} + 0x04)
#define POINTERA_XResolution    (@{"POINTERA_Dummy" LINK File 39} + 0x05)
#define POINTERA_YResolution    (@{"POINTERA_Dummy" LINK File 39} + 0x06)

/* These are the choices for the @{"POINTERA_XResolution" LINK File 45} attribute which
 * will determine what resolution pixels are used for this pointer.
 *
 * @{"POINTERXRESN_DEFAULT" LINK File 73} (ECS-compatible pointer width)
 *      = 70 ns if @{"SUPERHIRES" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 125}-type mode, 140 ns if not
 *
 * @{"POINTERXRESN_SCREENRES" LINK File 78}
 *      = Same as pixel speed of screen
 *
 * @{"POINTERXRESN_LORES" LINK File 79} (pointer always in lores-like pixels)
 *      = 140 ns in 15kHz modes, 70 ns in 31kHz modes
 *
 * @{"POINTERXRESN_HIRES" LINK File 80} (pointer always in hires-like pixels)
 *      = 70 ns in 15kHz modes, 35 ns in 31kHz modes
 *
 * @{"POINTERXRESN_140NS" LINK File 74} (pointer always in 140 ns pixels)
 *      = 140 ns always
 *
 * @{"POINTERXRESN_70NS" LINK File 75} (pointer always in 70 ns pixels)
 *      = 70 ns always
 *
 * @{"POINTERXRESN_35NS" LINK File 76} (pointer always in 35 ns pixels)
 *      = 35 ns always
 */

#define POINTERXRESN_DEFAULT    0
#define POINTERXRESN_140NS      1
#define POINTERXRESN_70NS       2
#define POINTERXRESN_35NS       3

#define POINTERXRESN_SCREENRES  4
#define POINTERXRESN_LORES      5
#define POINTERXRESN_HIRES      6

/* These are the choices for the @{"POINTERA_YResolution" LINK File 46} attribute which
 * will determine what vertical resolution is used for this pointer.
 *
 * @{"POINTERYRESN_DEFAULT" LINK File 110}
 *      = In 15 kHz modes, the pointer resolution will be the same
 *        as a non-interlaced screen.  In 31 kHz modes, the pointer
 *        will be doubled vertically.  This means there will be about
 *        200-256 pointer lines per screen.
 *
 * @{"POINTERYRESN_HIGH" LINK File 111}
 * @{"POINTERYRESN_HIGHASPECT" LINK File 112}
 *      = Where the hardware/software supports it, the pointer resolution
 *        will be high.  This means there will be about 400-480 pointer
 *        lines per screen.  @{"POINTERYRESN_HIGHASPECT" LINK File 112} also means that
 *        when the pointer comes out double-height due to hardware/software
 *        restrictions, its width would be doubled as well, if possible
 *        (to preserve aspect).
 *
 * @{"POINTERYRESN_SCREENRES" LINK File 113}
 * @{"POINTERYRESN_SCREENRESASPECT" LINK File 114}
 *      = Will attempt to match the vertical resolution of the pointer
 *        to the screen's vertical resolution.  POINTERYRESN_SCREENASPECT also
 *        means that when the pointer comes out double-height due to
 *        hardware/software restrictions, its width would be doubled as well,
 *        if possible (to preserve aspect).
 *
 */

#define POINTERYRESN_DEFAULT            0
#define POINTERYRESN_HIGH               2
#define POINTERYRESN_HIGHASPECT         3
#define POINTERYRESN_SCREENRES          4
#define POINTERYRESN_SCREENRESASPECT    5

/* Compatibility note:
 *
 * The AA chipset supports variable sprite width and resolution, but
 * the setting of width and resolution is global for all sprites.
 * When no other sprites are in use, Intuition controls the sprite
 * width and sprite resolution for correctness based on pointerclass
 * attributes specified by the creator of the pointer.  Intuition
 * controls sprite resolution with the @{"VTAG_DEFSPRITERESN_SET" LINK "gg:doc/NDK/Guide/Include/graphics/videocontrol.h/File" 83} tag
 * to @{"VideoControl()" LINK "gg:doc/NDK/Guide/graphics/VideoControl"}.  Applications can override this on a per-viewport
 * basis with the @{"VTAG_SPRITERESN_SET" LINK "gg:doc/NDK/Guide/Include/graphics/videocontrol.h/File" 73} tag to @{"VideoControl()" LINK "gg:doc/NDK/Guide/graphics/VideoControl"}.
 *
 * If an application uses a sprite other than the pointer sprite,
 * Intuition will automatically regenerate the pointer sprite's image in
 * a compatible width.  This might involve BitMap scaling of the imagery
 * you supply.
 *
 * If any sprites other than the pointer sprite were obtained with the
 * old @{"GetSprite()" LINK "gg:doc/NDK/Guide/graphics/GetSprite"} call, Intuition assumes that the owner of those
 * sprites is unaware of sprite resolution, hence Intuition will set the
 * default sprite resolution (@{"VTAG_DEFSPRITERESN_SET" LINK "gg:doc/NDK/Guide/Include/graphics/videocontrol.h/File" 83}) to ECS-compatible,
 * instead of as requested by the various pointerclass attributes.
 *
 * No resolution fallback occurs when applications use ExtSprites.
 * Such applications are expected to use @{"VTAG_SPRITERESN_SET" LINK "gg:doc/NDK/Guide/Include/graphics/videocontrol.h/File" 73} tag if
 * necessary.
 *
 * NB:  Under release V39, only sprite width compatibility is implemented.
 * Sprite resolution compatibility was added for V40.
 */

#endif
@ENDNODE
