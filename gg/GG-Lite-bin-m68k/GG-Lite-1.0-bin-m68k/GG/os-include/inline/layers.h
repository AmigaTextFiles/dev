#ifndef _INLINE_LAYERS_H
#define _INLINE_LAYERS_H

#ifndef CLIB_LAYERS_PROTOS_H
#define CLIB_LAYERS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  GRAPHICS_LAYERS_H
#include <graphics/layers.h>
#endif
#ifndef  GRAPHICS_CLIP_H
#include <graphics/clip.h>
#endif
#ifndef  GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif
#ifndef  GRAPHICS_REGIONS_H
#include <graphics/regions.h>
#endif

#ifndef LAYERS_BASE_NAME
#define LAYERS_BASE_NAME LayersBase
#endif

#define InitLayers(li) \
	LP1NR(0x1e, InitLayers, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define CreateUpfrontLayer(li, bm, x0, y0, x1, y1, flags, bm2) \
	LP8(0x24, struct Layer *, CreateUpfrontLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct BitMap *, bm2, a2, \
	, LAYERS_BASE_NAME)

#define CreateBehindLayer(li, bm, x0, y0, x1, y1, flags, bm2) \
	LP8(0x2a, struct Layer *, CreateBehindLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct BitMap *, bm2, a2, \
	, LAYERS_BASE_NAME)

#define UpfrontLayer(dummy, layer) \
	LP2(0x30, LONG, UpfrontLayer, LONG, dummy, a0, struct Layer *, layer, a1, \
	, LAYERS_BASE_NAME)

#define BehindLayer(dummy, layer) \
	LP2(0x36, LONG, BehindLayer, LONG, dummy, a0, struct Layer *, layer, a1, \
	, LAYERS_BASE_NAME)

#define MoveLayer(dummy, layer, dx, dy) \
	LP4(0x3c, LONG, MoveLayer, LONG, dummy, a0, struct Layer *, layer, a1, LONG, dx, d0, LONG, dy, d1, \
	, LAYERS_BASE_NAME)

#define SizeLayer(dummy, layer, dx, dy) \
	LP4(0x42, LONG, SizeLayer, LONG, dummy, a0, struct Layer *, layer, a1, LONG, dx, d0, LONG, dy, d1, \
	, LAYERS_BASE_NAME)

#define ScrollLayer(dummy, layer, dx, dy) \
	LP4NR(0x48, ScrollLayer, LONG, dummy, a0, struct Layer *, layer, a1, LONG, dx, d0, LONG, dy, d1, \
	, LAYERS_BASE_NAME)

#define BeginUpdate(l) \
	LP1(0x4e, LONG, BeginUpdate, struct Layer *, l, a0, \
	, LAYERS_BASE_NAME)

#define EndUpdate(layer, flag) \
	LP2NR(0x54, EndUpdate, struct Layer *, layer, a0, ULONG, flag, d0, \
	, LAYERS_BASE_NAME)

#define DeleteLayer(dummy, layer) \
	LP2(0x5a, LONG, DeleteLayer, LONG, dummy, a0, struct Layer *, layer, a1, \
	, LAYERS_BASE_NAME)

#define LockLayer(dummy, layer) \
	LP2NR(0x60, LockLayer, LONG, dummy, a0, struct Layer *, layer, a1, \
	, LAYERS_BASE_NAME)

#define UnlockLayer(layer) \
	LP1NR(0x66, UnlockLayer, struct Layer *, layer, a0, \
	, LAYERS_BASE_NAME)

#define LockLayers(li) \
	LP1NR(0x6c, LockLayers, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define UnlockLayers(li) \
	LP1NR(0x72, UnlockLayers, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define LockLayerInfo(li) \
	LP1NR(0x78, LockLayerInfo, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define SwapBitsRastPortClipRect(rp, cr) \
	LP2NR(0x7e, SwapBitsRastPortClipRect, struct RastPort *, rp, a0, struct ClipRect *, cr, a1, \
	, LAYERS_BASE_NAME)

#define WhichLayer(li, x, y) \
	LP3(0x84, struct Layer *, WhichLayer, struct Layer_Info *, li, a0, LONG, x, d0, LONG, y, d1, \
	, LAYERS_BASE_NAME)

#define UnlockLayerInfo(li) \
	LP1NR(0x8a, UnlockLayerInfo, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define NewLayerInfo() \
	LP0(0x90, struct Layer_Info *, NewLayerInfo, \
	, LAYERS_BASE_NAME)

#define DisposeLayerInfo(li) \
	LP1NR(0x96, DisposeLayerInfo, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define FattenLayerInfo(li) \
	LP1(0x9c, LONG, FattenLayerInfo, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define ThinLayerInfo(li) \
	LP1NR(0xa2, ThinLayerInfo, struct Layer_Info *, li, a0, \
	, LAYERS_BASE_NAME)

#define MoveLayerInFrontOf(layer_to_move, other_layer) \
	LP2(0xa8, LONG, MoveLayerInFrontOf, struct Layer *, layer_to_move, a0, struct Layer *, other_layer, a1, \
	, LAYERS_BASE_NAME)

#define InstallClipRegion(layer, region) \
	LP2(0xae, struct Region *, InstallClipRegion, struct Layer *, layer, a0, const struct Region *, region, a1, \
	, LAYERS_BASE_NAME)

#define MoveSizeLayer(layer, dx, dy, dw, dh) \
	LP5(0xb4, LONG, MoveSizeLayer, struct Layer *, layer, a0, LONG, dx, d0, LONG, dy, d1, LONG, dw, d2, LONG, dh, d3, \
	, LAYERS_BASE_NAME)

#define CreateUpfrontHookLayer(li, bm, x0, y0, x1, y1, flags, hook, bm2) \
	LP9(0xba, struct Layer *, CreateUpfrontHookLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct Hook *, hook, a3, struct BitMap *, bm2, a2, \
	, LAYERS_BASE_NAME)

#define CreateBehindHookLayer(li, bm, x0, y0, x1, y1, flags, hook, bm2) \
	LP9(0xc0, struct Layer *, CreateBehindHookLayer, struct Layer_Info *, li, a0, struct BitMap *, bm, a1, LONG, x0, d0, LONG, y0, d1, LONG, x1, d2, LONG, y1, d3, LONG, flags, d4, struct Hook *, hook, a3, struct BitMap *, bm2, a2, \
	, LAYERS_BASE_NAME)

#define InstallLayerHook(layer, hook) \
	LP2(0xc6, struct Hook *, InstallLayerHook, struct Layer *, layer, a0, struct Hook *, hook, a1, \
	, LAYERS_BASE_NAME)

#define InstallLayerInfoHook(li, hook) \
	LP2(0xcc, struct Hook *, InstallLayerInfoHook, struct Layer_Info *, li, a0, const struct Hook *, hook, a1, \
	, LAYERS_BASE_NAME)

#define SortLayerCR(layer, dx, dy) \
	LP3NR(0xd2, SortLayerCR, struct Layer *, layer, a0, LONG, dx, d0, LONG, dy, d1, \
	, LAYERS_BASE_NAME)

#define DoHookClipRects(hook, rport, rect) \
	LP3NR(0xd8, DoHookClipRects, struct Hook *, hook, a0, struct RastPort *, rport, a1, const struct Rectangle *, rect, a2, \
	, LAYERS_BASE_NAME)

#endif /*  _INLINE_LAYERS_H  */
