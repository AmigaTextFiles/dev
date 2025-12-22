#ifndef _INCLUDE_PRAGMA_LAYERS_LIB_H
#define _INCLUDE_PRAGMA_LAYERS_LIB_H

/*
**  $VER: layers_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_LAYERS_PROTOS_H
#include <clib/layers_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(LayersBase, 0x1e, InitLayers(a0))
#pragma amicall(LayersBase, 0x24, CreateUpfrontLayer(a0,a1,d0,d1,d2,d3,d4,a2))
#pragma amicall(LayersBase, 0x2a, CreateBehindLayer(a0,a1,d0,d1,d2,d3,d4,a2))
#pragma amicall(LayersBase, 0x30, UpfrontLayer(a0,a1))
#pragma amicall(LayersBase, 0x36, BehindLayer(a0,a1))
#pragma amicall(LayersBase, 0x3c, MoveLayer(a0,a1,d0,d1))
#pragma amicall(LayersBase, 0x42, SizeLayer(a0,a1,d0,d1))
#pragma amicall(LayersBase, 0x48, ScrollLayer(a0,a1,d0,d1))
#pragma amicall(LayersBase, 0x4e, BeginUpdate(a0))
#pragma amicall(LayersBase, 0x54, EndUpdate(a0,d0))
#pragma amicall(LayersBase, 0x5a, DeleteLayer(a0,a1))
#pragma amicall(LayersBase, 0x60, LockLayer(a0,a1))
#pragma amicall(LayersBase, 0x66, UnlockLayer(a0))
#pragma amicall(LayersBase, 0x6c, LockLayers(a0))
#pragma amicall(LayersBase, 0x72, UnlockLayers(a0))
#pragma amicall(LayersBase, 0x78, LockLayerInfo(a0))
#pragma amicall(LayersBase, 0x7e, SwapBitsRastPortClipRect(a0,a1))
#pragma amicall(LayersBase, 0x84, WhichLayer(a0,d0,d1))
#pragma amicall(LayersBase, 0x8a, UnlockLayerInfo(a0))
#pragma amicall(LayersBase, 0x90, NewLayerInfo())
#pragma amicall(LayersBase, 0x96, DisposeLayerInfo(a0))
#pragma amicall(LayersBase, 0x9c, FattenLayerInfo(a0))
#pragma amicall(LayersBase, 0xa2, ThinLayerInfo(a0))
#pragma amicall(LayersBase, 0xa8, MoveLayerInFrontOf(a0,a1))
#pragma amicall(LayersBase, 0xae, InstallClipRegion(a0,a1))
#pragma amicall(LayersBase, 0xb4, MoveSizeLayer(a0,d0,d1,d2,d3))
#pragma amicall(LayersBase, 0xba, CreateUpfrontHookLayer(a0,a1,d0,d1,d2,d3,d4,a3,a2))
#pragma amicall(LayersBase, 0xc0, CreateBehindHookLayer(a0,a1,d0,d1,d2,d3,d4,a3,a2))
#pragma amicall(LayersBase, 0xc6, InstallLayerHook(a0,a1))
#pragma amicall(LayersBase, 0xcc, InstallLayerInfoHook(a0,a1))
#pragma amicall(LayersBase, 0xd2, SortLayerCR(a0,d0,d1))
#pragma amicall(LayersBase, 0xd8, DoHookClipRects(a0,a1,a2))

#ifdef __cplusplus
}
#endif

#endif
