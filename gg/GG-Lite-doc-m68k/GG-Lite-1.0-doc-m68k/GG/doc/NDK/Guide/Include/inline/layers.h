@DATABASE "gg:doc/NDK/Guide/Include/inline/layers.h"
@MASTER   "gg:os-include/inline/layers.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/layers.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/layers.h" LINK File}


@{b}#defines@{ub}

@{"BeginUpdate()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 64}               @{"BehindLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 48}        @{"CLIB_LAYERS_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 5}
@{"CreateBehindHookLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 140}     @{"CreateBehindLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 40}  @{"CreateUpfrontHookLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 136}
@{"CreateUpfrontLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 36}        @{"DeleteLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 72}        @{"DisposeLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 112}
@{"DoHookClipRects()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 156}           @{"EndUpdate()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 68}          @{"FattenLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 116}
@{"InitLayers()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 32}                @{"InstallClipRegion()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 128}  @{"InstallLayerHook()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 144}
@{"InstallLayerInfoHook()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 148}      @{"LAYERS_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 29}     @{"LockLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 76}
@{"LockLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 92}             @{"LockLayers()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 84}         @{"MoveLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 52}
@{"MoveLayerInFrontOf()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 124}        @{"MoveSizeLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 132}      @{"NewLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 108}
@{"ScrollLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 60}               @{"SizeLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 56}          @{"SortLayerCR()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 152}
@{"SwapBitsRastPortClipRect()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 96}  @{"ThinLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 120}      @{"UnlockLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 80}
@{"UnlockLayerInfo()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 104}           @{"UnlockLayers()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 88}       @{"UpfrontLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 44}
@{"WhichLayer()" LINK "gg:doc/NDK/Guide/Include/inline/layers.h/File" 100}                

@ENDNODE
@NODE File "inline/layers.h"
#ifndef _INLINE_LAYERS_H
#define _INLINE_LAYERS_H

#ifndef CLIB_LAYERS_PROTOS_H
#define CLIB_LAYERS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

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

#ifndef LAYERS_BASE_NAME
#define LAYERS_BASE_NAME LayersBase
#endif

#define @{"InitLayers" LINK "gg:doc/NDK/Guide/layers/InitLayers"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1e, @{"InitLayers" LINK File 32}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"CreateUpfrontLayer" LINK "gg:doc/NDK/Guide/layers/CreateUpfrontLayer"}(li, bm, x0, y0, x1, y1, flags, bm2) \\
        @{"LP8" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 690}(0x24, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, CreateUpfrontLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct BitMap *, bm2, a2, \\
        , LAYERS_BASE_NAME)

#define @{"CreateBehindLayer" LINK "gg:doc/NDK/Guide/layers/CreateBehindLayer"}(li, bm, x0, y0, x1, y1, flags, bm2) \\
        @{"LP8" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 690}(0x2a, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, CreateBehindLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct BitMap *, bm2, a2, \\
        , LAYERS_BASE_NAME)

#define @{"UpfrontLayer" LINK "gg:doc/NDK/Guide/layers/UpfrontLayer"}(dummy, layer) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"UpfrontLayer" LINK File 44}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, \\
        , LAYERS_BASE_NAME)

#define @{"BehindLayer" LINK "gg:doc/NDK/Guide/layers/BehindLayer"}(dummy, layer) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"BehindLayer" LINK File 48}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, \\
        , LAYERS_BASE_NAME)

#define @{"MoveLayer" LINK "gg:doc/NDK/Guide/layers/MoveLayer"}(dummy, layer, dx, dy) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x3c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"MoveLayer" LINK File 52}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, LONG, dx, d0, LONG, dy, d1, \\
        , LAYERS_BASE_NAME)

#define @{"SizeLayer" LINK "gg:doc/NDK/Guide/layers/SizeLayer"}(dummy, layer, dx, dy) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x42, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SizeLayer" LINK File 56}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, LONG, dx, d0, LONG, dy, d1, \\
        , LAYERS_BASE_NAME)

#define @{"ScrollLayer" LINK "gg:doc/NDK/Guide/layers/ScrollLayer"}(dummy, layer, dx, dy) \\
        @{"LP4NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}(0x48, @{"ScrollLayer" LINK File 60}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, LONG, dx, d0, LONG, dy, d1, \\
        , LAYERS_BASE_NAME)

#define @{"BeginUpdate" LINK "gg:doc/NDK/Guide/layers/BeginUpdate"}(l) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x4e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"BeginUpdate" LINK File 64}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, l, a0, \\
        , LAYERS_BASE_NAME)

#define @{"EndUpdate" LINK "gg:doc/NDK/Guide/layers/EndUpdate"}(layer, flag) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x54, @{"EndUpdate" LINK File 68}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a0, ULONG, flag, d0, \\
        , LAYERS_BASE_NAME)

#define @{"DeleteLayer" LINK "gg:doc/NDK/Guide/layers/DeleteLayer"}(dummy, layer) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x5a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"DeleteLayer" LINK File 72}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, \\
        , LAYERS_BASE_NAME)

#define @{"LockLayer" LINK "gg:doc/NDK/Guide/layers/LockLayer"}(dummy, layer) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x60, @{"LockLayer" LINK File 76}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dummy, a0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a1, \\
        , LAYERS_BASE_NAME)

#define @{"UnlockLayer" LINK "gg:doc/NDK/Guide/layers/UnlockLayer"}(layer) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x66, @{"UnlockLayer" LINK File 80}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a0, \\
        , LAYERS_BASE_NAME)

#define @{"LockLayers" LINK "gg:doc/NDK/Guide/layers/LockLayers"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x6c, @{"LockLayers" LINK File 84}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"UnlockLayers" LINK "gg:doc/NDK/Guide/layers/UnlockLayers"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x72, @{"UnlockLayers" LINK File 88}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"LockLayerInfo" LINK "gg:doc/NDK/Guide/layers/LockLayerInfo"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x78, @{"LockLayerInfo" LINK File 92}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"SwapBitsRastPortClipRect" LINK "gg:doc/NDK/Guide/layers/SwapBitsRastPortClipRect"}(rp, cr) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x7e, @{"SwapBitsRastPortClipRect" LINK File 96}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, rp, a0, struct ClipRect *, cr, a1, \\
        , LAYERS_BASE_NAME)

#define @{"WhichLayer" LINK "gg:doc/NDK/Guide/layers/WhichLayer"}(li, x, y) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x84, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, WhichLayer, struct Layer_Info *, li, a0, LONG, x, d0, LONG, y, d1, \\
        , LAYERS_BASE_NAME)

#define @{"UnlockLayerInfo" LINK "gg:doc/NDK/Guide/layers/UnlockLayerInfo"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x8a, @{"UnlockLayerInfo" LINK File 104}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"NewLayerInfo()" LINK "gg:doc/NDK/Guide/layers/NewLayerInfo"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x90, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, NewLayerInfo, \\
        , LAYERS_BASE_NAME)

#define @{"DisposeLayerInfo" LINK "gg:doc/NDK/Guide/layers/DisposeLayerInfo"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x96, @{"DisposeLayerInfo" LINK File 112}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"FattenLayerInfo" LINK "gg:doc/NDK/Guide/layers/FattenLayerInfo"}(li) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x9c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"FattenLayerInfo" LINK File 116}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"ThinLayerInfo" LINK "gg:doc/NDK/Guide/layers/ThinLayerInfo"}(li) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xa2, @{"ThinLayerInfo" LINK File 120}, @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} *, li, a0, \\
        , LAYERS_BASE_NAME)

#define @{"MoveLayerInFrontOf" LINK "gg:doc/NDK/Guide/layers/MoveLayerInFrontOf"}(layer_to_move, other_layer) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xa8, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"MoveLayerInFrontOf" LINK File 124}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer_to_move, a0, struct Layer *, other_layer, a1, \\
        , LAYERS_BASE_NAME)

#define @{"InstallClipRegion" LINK "gg:doc/NDK/Guide/layers/InstallClipRegion"}(layer, region) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xae, @{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25} *, InstallClipRegion, struct Layer *, layer, a0, const struct Region *, region, a1, \\
        , LAYERS_BASE_NAME)

#define @{"MoveSizeLayer" LINK "gg:doc/NDK/Guide/layers/MoveSizeLayer"}(layer, dx, dy, dw, dh) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0xb4, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"MoveSizeLayer" LINK File 132}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a0, LONG, dx, d0, LONG, dy, d1, LONG, dw, d2, LONG, dh, d3, \\
        , LAYERS_BASE_NAME)

#define @{"CreateUpfrontHookLayer" LINK "gg:doc/NDK/Guide/layers/CreateUpfrontHookLayer"}(li, bm, x0, y0, x1, y1, flags, hook, bm2) \\
        @{"LP9" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 755}(0xba, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, CreateUpfrontHookLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct Hook *, hook, a3, struct BitMap *, bm2, a2, \\
        , LAYERS_BASE_NAME)

#define @{"CreateBehindHookLayer" LINK "gg:doc/NDK/Guide/layers/CreateBehindHookLayer"}(li, bm, x0, y0, x1, y1, flags, hook, bm2) \\
        @{"LP9" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 755}(0xc0, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, CreateBehindHookLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct Hook *, hook, a3, struct BitMap *, bm2, a2, \\
        , LAYERS_BASE_NAME)

#define @{"InstallLayerHook" LINK "gg:doc/NDK/Guide/layers/InstallLayerHook"}(layer, hook) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xc6, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, InstallLayerHook, struct Layer *, layer, a0, struct Hook *, hook, a1, \\
        , LAYERS_BASE_NAME)

#define @{"InstallLayerInfoHook" LINK "gg:doc/NDK/Guide/layers/InstallLayerInfoHook"}(li, hook) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xcc, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, InstallLayerInfoHook, struct Layer_Info *, li, a0, const struct Hook *, hook, a1, \\
        , LAYERS_BASE_NAME)

#define SortLayerCR(layer, dx, dy) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0xd2, @{"SortLayerCR" LINK File 152}, @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *, layer, a0, LONG, dx, d0, LONG, dy, d1, \\
        , LAYERS_BASE_NAME)

#define @{"DoHookClipRects" LINK "gg:doc/NDK/Guide/layers/DoHookClipRects"}(hook, rport, rect) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0xd8, @{"DoHookClipRects" LINK File 156}, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, hook, a0, struct RastPort *, rport, a1, const struct Rectangle *, rect, a2, \\
        , LAYERS_BASE_NAME)

#endif /*  _INLINE_LAYERS_H  */
@ENDNODE
