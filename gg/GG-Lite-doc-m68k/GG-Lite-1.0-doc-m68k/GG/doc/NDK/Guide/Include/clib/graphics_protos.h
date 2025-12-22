@DATABASE "gg:doc/NDK/Guide/Include/clib/graphics_protos.h"
@MASTER   "gg:os-include/clib/graphics_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:44
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/graphics_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/graphics_protos.h" LINK File}

@ENDNODE
@NODE File "clib/graphics_protos.h"
#ifndef  CLIB_GRAPHICS_PROTOS_H
#define  CLIB_GRAPHICS_PROTOS_H

/*
**      $VER: graphics_protos.h 40.2 (6.6.1998)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif
#ifndef  GRAPHICS_DISPLAYINFO_H
#include <@{"graphics/displayinfo.h" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File"}>
#endif
#ifndef  GRAPHICS_GELS_H
#include <@{"graphics/gels.h" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File"}>
#endif
#ifndef  GRAPHICS_RASTPORT_H
#include <@{"graphics/rastport.h" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File"}>
#endif
#ifndef  GRAPHICS_VIEW_H
#include <@{"graphics/view.h" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File"}>
#endif
#ifndef  GRAPHICS_COPPER_H
#include <@{"graphics/copper.h" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File"}>
#endif
#ifndef  GRAPHICS_CLIP_H
#include <@{"graphics/clip.h" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File"}>
#endif
#ifndef  GRAPHICS_REGIONS_H
#include <@{"graphics/regions.h" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File"}>
#endif
#ifndef  GRAPHICS_SPRITE_H
#include <@{"graphics/sprite.h" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File"}>
#endif
#ifndef  GRAPHICS_TEXT_H
#include <@{"graphics/text.h" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File"}>
#endif
#ifndef  GRAPHICS_SCALE_H
#include <@{"graphics/scale.h" LINK "gg:doc/NDK/Guide/Include/graphics/scale.h/File"}>
#endif
#ifndef  HARDWARE_BLIT_H
#include <@{"hardware/blit.h" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File"}>
#endif
/*------ BitMap primitives ------*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"BltBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 53}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *srcBitMap, LONG xSrc, LONG ySrc, struct BitMap *destBitMap, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm, ULONG mask, PLANEPTR tempA );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BltTemplate" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 57}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44} source, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} xSrc, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} srcMod, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize );
/*------ Text routines ------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearEOL" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 61}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearScreen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 65}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"TextLength" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 69}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST_STRPTR string, ULONG count );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Text" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 73}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST_STRPTR string, ULONG count );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 77}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct TextFont *textFont );
@{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *OpenFont( struct TextAttr *textAttr );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 85}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *textFont );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"AskSoftStyle" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 89}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetSoftStyle" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 93}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG style, ULONG enable );
/*------        Gels routines ------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddBob" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 97}( @{"struct Bob" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 139} *bob, struct RastPort *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddVSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 101}( @{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *vSprite, struct RastPort *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DoCollision" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 105}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawGList" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 109}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ViewPort *vp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitGels" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 113}( @{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *head, struct VSprite *tail, struct GelsInfo *gelsInfo );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitMasks" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 117}( @{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *vSprite );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemIBob" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 121}( @{"struct Bob" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 139} *bob, struct RastPort *rp, struct ViewPort *vp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemVSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 125}( @{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *vSprite );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetCollision" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 129}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} num, @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*routine)(@{"struct VSprite" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 72} *gelA, struct VSprite *gelB), @{"struct GelsInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 37} *gelsInfo );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SortGList" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 133}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddAnimOb" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 137}( @{"struct AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204} *anOb, struct AnimOb **anKey, struct RastPort *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Animate" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 141}( @{"struct AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204} **anKey, struct RastPort *rp );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetGBuffers" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 145}( @{"struct AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204} *anOb, struct RastPort *rp, LONG flag );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitGMasks" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 149}( @{"struct AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204} *anOb );
/*------        General graphics routines ------*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DrawEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 153}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG xCenter, LONG yCenter, LONG a, LONG b );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AreaEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 157}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG xCenter, LONG yCenter, LONG a, LONG b );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LoadRGB4" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 161}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, CONST UWORD *colors, LONG count );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitRastPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 165}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitVPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 169}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"MrgCop" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 173}( @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *view );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"MakeVPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 177}( @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *view, struct ViewPort *vp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LoadView" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 181}( @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *view );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WaitBlit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 185}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRast" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 189}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG pen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Move" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 193}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Draw" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 197}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AreaMove" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 201}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AreaDraw" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 205}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AreaEnd" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 209}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WaitTOF" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 213}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"QBlit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 217}( @{"struct bltnode" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File" 88} *blit );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitArea" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 221}( @{"struct AreaInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 19} *areaInfo, APTR vectorBuffer, LONG maxVectors );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRGB4" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 225}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, LONG index, ULONG red, ULONG green, ULONG blue );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"QBSBlit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 229}( @{"struct bltnode" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File" 88} *blit );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BltClear" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 233}( @{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44} memBlock, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byteCount, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RectFill" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 237}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BltPattern" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 241}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST PLANEPTR mask, LONG xMin, LONG yMin, LONG xMax, LONG yMax, ULONG maskBPR );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadPixel" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 245}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WritePixel" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 249}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG x, LONG y );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"Flood" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 253}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG mode, LONG x, LONG y );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"PolyDraw" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 257}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG count, CONST WORD *polyTable );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetAPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 261}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG pen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetBPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 265}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG pen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetDrMd" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 269}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG drawMode );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitView" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 273}( @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *view );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CBump" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 277}( @{"struct UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89} *copList );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CMove" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 281}( @{"struct UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89} *copList, APTR destination, LONG data );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CWait" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 285}( @{"struct UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89} *copList, LONG v, LONG h );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"VBeamPos" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 289}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 293}( @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *bitMap, LONG depth, LONG width, LONG height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScrollRaster" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 297}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WaitBOVP" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 301}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"GetSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 305}( @{"struct SimpleSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 17} *sprite, LONG num );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 309}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} num );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ChangeSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 313}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, struct SimpleSprite *sprite, UWORD *newData );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MoveSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 317}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, struct SimpleSprite *sprite, LONG x, LONG y );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LockLayerRom" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 321}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockLayerRom" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 325}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SyncSBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 329}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CopySBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 333}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"OwnBlitter" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 337}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisownBlitter" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 341}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"struct TmpRas" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 30} *InitTmpRas( struct TmpRas *tmpRas, PLANEPTR buffer, LONG size );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AskFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 349}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct TextAttr *textAttr );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 353}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *textFont );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 357}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *textFont );
@{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44} @{"AllocRaster" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 361}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} width, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeRaster" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 365}( @{"PLANEPTR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 44} p, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} width, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} height );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AndRectRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 369}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region, CONST struct Rectangle *rectangle );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"OrRectRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 373}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region, CONST struct Rectangle *rectangle );
@{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *NewRegion( VOID );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ClearRectRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 381}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region, CONST struct Rectangle *rectangle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 385}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 389}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeVPortCopLists" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 393}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeCopList" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 397}( @{"struct CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62} *copList );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClipBlit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 401}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *srcRP, LONG xSrc, LONG ySrc, struct RastPort *destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"XorRectRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 405}( @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *region, CONST struct Rectangle *rectangle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeCprList" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 409}( @{"struct cprlist" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 55} *cprList );
@{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *GetColorMap( LONG entries );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeColorMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 417}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *colorMap );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetRGB4" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 421}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *colorMap, LONG entry );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScrollVPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 425}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp );
@{"struct CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62} *UCopperListInit( struct UCopList *uCopList, LONG n );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeGBuffers" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 433}( @{"struct AnimOb" LINK "gg:doc/NDK/Guide/Include/graphics/gels.h/File" 204} *anOb, struct RastPort *rp, LONG flag );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BltBitMapRastPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 437}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *srcBitMap, LONG xSrc, LONG ySrc, struct RastPort *destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"OrRegionRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 441}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *srcRegion, struct Region *destRegion );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"XorRegionRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 445}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *srcRegion, struct Region *destRegion );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AndRegionRegion" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 449}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *srcRegion, struct Region *destRegion );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRGB4CM" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 453}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *colorMap, LONG index, ULONG red, ULONG green, ULONG blue );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BltMaskBitMapRastPort" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 457}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *srcBitMap, LONG xSrc, LONG ySrc, struct RastPort *destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm, CONST PLANEPTR bltMask );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AttemptLockLayerRom" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 461}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GfxNew" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 465}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} gfxNodeType );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GfxFree" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 469}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} gfxNodePtr );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GfxAssociate" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 473}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} associateNode, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} gfxNodePtr );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BitMapScale" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 477}( @{"struct BitScaleArgs" LINK "gg:doc/NDK/Guide/Include/graphics/scale.h/File" 17} *bitScaleArgs );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"ScalerDiv" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 481}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} factor, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} numerator, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} denominator );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"TextExtent" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 485}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST_STRPTR string, LONG count, struct TextExtent *textExtent );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"TextFit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 489}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST_STRPTR string, ULONG strLen, CONST struct TextExtent *textExtent, CONST struct TextExtent *constrainingExtent, LONG strDirection, ULONG constrainingBitWidth, ULONG constrainingBitHeight );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GfxLookUp" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 493}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} associateNode );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"VideoControl" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 497}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *colorMap, struct TagItem *tagarray );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"VideoControlTags" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 502}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *colorMap, ULONG tag1Type, ... );
@{"struct MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *OpenMonitor( CONST_STRPTR monitorName, ULONG displayID );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CloseMonitor" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 510}( @{"struct MonitorSpec" LINK "gg:doc/NDK/Guide/Include/graphics/monitor.h/File" 25} *monitorSpec );
@{"DisplayInfoHandle" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 35} @{"FindDisplayInfo" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 514}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} displayID );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"NextDisplayInfo" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 518}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} displayID );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDisplayInfoData" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 522}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"DisplayInfoHandle" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 35} handle, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buf, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tagID, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} displayID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FontExtent" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 526}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *font, struct TextExtent *fontExtent );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadPixelLine8" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 530}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG xstart, ULONG ystart, ULONG width, UBYTE *array, struct RastPort *tempRP );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WritePixelLine8" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 534}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG xstart, ULONG ystart, ULONG width, UBYTE *array, struct RastPort *tempRP );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadPixelArray8" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 538}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, UBYTE *array, struct RastPort *temprp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WritePixelArray8" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 542}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, UBYTE *array, struct RastPort *temprp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetVPModeID" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 546}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ModeNotAvailable" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 550}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} modeID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EraseRect" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 554}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ExtendFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 558}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *font, CONST struct TagItem *fontTags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ExtendFontTags" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 563}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *font, ULONG tag1Type, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"StripFont" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 567}( @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *font );
/*--- functions in V39 or higher (Release 3) ---*/
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"CalcIVG" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 571}( @{"struct View" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 64} *v, struct ViewPort *vp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AttachPalExtra" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 575}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, struct ViewPort *vp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ObtainBestPenA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 579}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG r, ULONG g, ULONG b, CONST struct TagItem *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ObtainBestPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 584}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG r, ULONG g, ULONG b, ULONG tag1Type, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRGB32" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 588}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, ULONG n, ULONG r, ULONG g, ULONG b );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetAPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 592}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetBPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 596}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDrMd" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 600}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetOutlinePen" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 59}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LoadRGB32" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 608}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, CONST ULONG *table );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetChipRev" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 612}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} want );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetABPenDrMd" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 616}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG apen, ULONG bpen, ULONG drawmode );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetRGB32" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 620}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG firstcolor, ULONG ncolors, ULONG *table );
@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *AllocBitMap( ULONG sizex, ULONG sizey, ULONG depth, ULONG flags, CONST struct BitMap *friend_bitmap );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 628}( @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *bm );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetExtSpriteA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 632}( @{"struct ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25} *ss, CONST struct TagItem *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetExtSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 637}( @{"struct ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25} *ss, ULONG tag1Type, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CoerceMode" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 641}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, ULONG monitorid, ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ChangeVPBitMap" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 645}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, struct BitMap *bm, struct DBufInfo *db );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleasePen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 649}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG n );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ObtainPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 653}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG n, ULONG r, ULONG g, ULONG b, LONG f );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetBitMapAttr" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 657}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *bm, ULONG attrnum );
@{"struct DBufInfo" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 279} *AllocDBufInfo( struct ViewPort *vp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeDBufInfo" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 665}( @{"struct DBufInfo" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 279} *dbi );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetOutlinePen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 669}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG pen );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetWriteMask" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 673}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG msk );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetMaxPen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 677}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG maxpen );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRGB32CM" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 681}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG n, ULONG r, ULONG g, ULONG b );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScrollRasterBF" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 685}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FindColor" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 689}( @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *cm, ULONG r, ULONG g, ULONG b, LONG maxcolor );
@{"struct ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25} *AllocSpriteDataA( CONST struct BitMap *bm, CONST struct TagItem *tags );
@{"struct ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25} *AllocSpriteData( CONST struct BitMap *bm, ULONG tag1Type, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ChangeExtSpriteA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 702}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, struct ExtSprite *oldsprite, struct ExtSprite *newsprite, CONST struct TagItem *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ChangeExtSprite" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 707}( @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *vp, struct ExtSprite *oldsprite, struct ExtSprite *newsprite, ULONG tag1Type, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeSpriteData" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 711}( @{"struct ExtSprite" LINK "gg:doc/NDK/Guide/Include/graphics/sprite.h/File" 25} *sp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRPAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 715}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetRPAttrs" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 720}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG tag1Type, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetRPAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 724}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, CONST struct TagItem *tags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GetRPAttrs" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 729}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG tag1Type, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"BestModeIDA" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 733}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"BestModeID" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 738}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tag1Type, ... );
/*--- functions in V40 or higher (Release 3.1) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WriteChunkyPixels" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 742}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, CONST UBYTE *array, LONG bytesperrow );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_GRAPHICS_PROTOS_H */
@ENDNODE
