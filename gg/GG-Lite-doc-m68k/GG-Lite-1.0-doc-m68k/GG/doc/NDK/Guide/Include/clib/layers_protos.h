@DATABASE "gg:doc/NDK/Guide/Include/clib/layers_protos.h"
@MASTER   "gg:os-include/clib/layers_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/layers_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/layers_protos.h" LINK File}

@ENDNODE
@NODE File "clib/layers_protos.h"
#ifndef  CLIB_LAYERS_PROTOS_H
#define  CLIB_LAYERS_PROTOS_H

/*
**      $VER: layers_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  GRAPHICS_LAYERS_H
#include <@{"graphics/layers.h" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File"}>
#endif
#ifndef  GRAPHICS_CLIP_H
#include <@{"graphics/clip.h" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File"}>
#endif
#ifndef  GRAPHICS_RASTPORT_H
#include <@{"graphics/rastport.h" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File"}>
#endif
#ifndef  GRAPHICS_REGIONS_H
#include <@{"graphics/regions.h" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File"}>
#endif
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitLayers" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 32}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *CreateUpfrontLayer( struct Layer_Info *li, struct BitMap *bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap *bm2 );
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *CreateBehindLayer( struct Layer_Info *li, struct BitMap *bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap *bm2 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"UpfrontLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 44}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"BehindLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 48}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MoveLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 52}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, LONG dx, LONG dy );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SizeLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 56}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, LONG dx, LONG dy );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ScrollLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 60}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, LONG dx, LONG dy );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"BeginUpdate" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 64}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *l );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EndUpdate" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 68}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, ULONG flag );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DeleteLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 72}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LockLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 76}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dummy, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 80}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LockLayers" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 84}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockLayers" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 88}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LockLayerInfo" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 92}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SwapBitsRastPortClipRect" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 96}( @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *rp, struct ClipRect *cr );
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *WhichLayer( struct Layer_Info *li, LONG x, LONG y );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockLayerInfo" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 104}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *NewLayerInfo( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeLayerInfo" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 112}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FattenLayerInfo" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 116}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ThinLayerInfo" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 120}( @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *li );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MoveLayerInFrontOf" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 124}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer_to_move, struct Layer *other_layer );
@{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *InstallClipRegion( struct Layer *layer, CONST struct Region *region );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MoveSizeLayer" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 132}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, LONG dx, LONG dy, LONG dw, LONG dh );
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *CreateUpfrontHookLayer( struct Layer_Info *li, struct BitMap *bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook *hook, struct BitMap *bm2 );
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *CreateBehindHookLayer( struct Layer_Info *li, struct BitMap *bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook *hook, struct BitMap *bm2 );
@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *InstallLayerHook( struct Layer *layer, struct Hook *hook );
/*--- functions in V39 or higher (Release 3) ---*/
@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *InstallLayerInfoHook( struct Layer_Info *li, CONST struct Hook *hook );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SortLayerCR" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 152}( @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *layer, LONG dx, LONG dy );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DoHookClipRects" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 156}( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, struct RastPort *rport, CONST struct Rectangle *rect );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_LAYERS_PROTOS_H */
@ENDNODE
