/* Automatically generated from '/home/aros/ABIv0/Build/20110803/AROS/rom/hyperlayers/layers.conf' */
OPT NATIVE
MODULE 'target/aros/libcall', 'target/graphics/layers', 'target/graphics/gfx', 'target/graphics/clip'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/utility/hooks', 'target/utility/tagitem'
{
#include <proto/layers.h>
}
{
struct Library* LayersBase = NULL;
}
NATIVE {CLIB_LAYERS_PROTOS_H} CONST
NATIVE {PROTO_LAYERS_H} CONST
NATIVE {DEFINES_LAYERS_H} CONST

NATIVE {LayersBase} DEF layersbase:PTR TO lib		->AmigaE does not automatically initialise this


NATIVE {InitLayers} PROC
PROC InitLayers(li:PTR TO layer_info) IS NATIVE {InitLayers(} li {)} ENDNATIVE
NATIVE {CreateUpfrontLayer} PROC
PROC CreateUpfrontLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap) IS NATIVE {CreateUpfrontLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {CreateBehindLayer} PROC
PROC CreateBehindLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap) IS NATIVE {CreateBehindLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {UpfrontLayer} PROC
PROC UpfrontLayer(dummy:VALUE, l:PTR TO layer) IS NATIVE {UpfrontLayer(} dummy {,} l {)} ENDNATIVE !!VALUE
NATIVE {BehindLayer} PROC
PROC BehindLayer(dummy:VALUE, l:PTR TO layer) IS NATIVE {BehindLayer(} dummy {,} l {)} ENDNATIVE !!VALUE
NATIVE {MoveLayer} PROC
PROC MoveLayer(dummy:VALUE, l:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {MoveLayer(} dummy {,} l {,} dx {,} dy {)} ENDNATIVE !!VALUE
NATIVE {SizeLayer} PROC
PROC SizeLayer(dummy:VALUE, l:PTR TO layer, dw:VALUE, dh:VALUE) IS NATIVE {SizeLayer(} dummy {,} l {,} dw {,} dh {)} ENDNATIVE !!VALUE
NATIVE {ScrollLayer} PROC
PROC ScrollLayer(dummy:VALUE, l:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {ScrollLayer(} dummy {,} l {,} dx {,} dy {)} ENDNATIVE
NATIVE {BeginUpdate} PROC
PROC BeginUpdate(l:PTR TO layer) IS NATIVE {BeginUpdate(} l {)} ENDNATIVE !!VALUE
NATIVE {EndUpdate} PROC
PROC EndUpdate(l:PTR TO layer, flag:UINT) IS NATIVE {EndUpdate(} l {,} flag {)} ENDNATIVE
NATIVE {DeleteLayer} PROC
PROC DeleteLayer(dummy:VALUE, l:PTR TO layer) IS NATIVE {DeleteLayer(} dummy {,} l {)} ENDNATIVE !!VALUE
NATIVE {LockLayer} PROC
PROC LockLayer(dummy:VALUE, layer:PTR TO layer) IS NATIVE {LockLayer(} dummy {,} layer {)} ENDNATIVE
NATIVE {UnlockLayer} PROC
PROC UnlockLayer(layer:PTR TO layer) IS NATIVE {UnlockLayer(} layer {)} ENDNATIVE
NATIVE {LockLayers} PROC
PROC LockLayers(li:PTR TO layer_info) IS NATIVE {LockLayers(} li {)} ENDNATIVE
NATIVE {UnlockLayers} PROC
PROC UnlockLayers(li:PTR TO layer_info) IS NATIVE {UnlockLayers(} li {)} ENDNATIVE
NATIVE {LockLayerInfo} PROC
PROC LockLayerInfo(li:PTR TO layer_info) IS NATIVE {LockLayerInfo(} li {)} ENDNATIVE
NATIVE {SwapBitsRastPortClipRect} PROC
PROC SwapBitsRastPortClipRect(rp:PTR TO rastport, cr:PTR TO cliprect) IS NATIVE {SwapBitsRastPortClipRect(} rp {,} cr {)} ENDNATIVE
NATIVE {WhichLayer} PROC
PROC WhichLayer(li:PTR TO layer_info, x:VALUE, y:VALUE) IS NATIVE {WhichLayer(} li {,} x {,} y {)} ENDNATIVE !!PTR TO layer
NATIVE {UnlockLayerInfo} PROC
PROC UnlockLayerInfo(li:PTR TO layer_info) IS NATIVE {UnlockLayerInfo(} li {)} ENDNATIVE
NATIVE {NewLayerInfo} PROC
PROC NewLayerInfo() IS NATIVE {NewLayerInfo()} ENDNATIVE !!PTR TO layer_info
NATIVE {DisposeLayerInfo} PROC
PROC DisposeLayerInfo(li:PTR TO layer_info) IS NATIVE {DisposeLayerInfo(} li {)} ENDNATIVE
NATIVE {FattenLayerInfo} PROC
PROC FattenLayerInfo(li:PTR TO layer_info) IS NATIVE {FattenLayerInfo(} li {)} ENDNATIVE !!VALUE
NATIVE {ThinLayerInfo} PROC
PROC ThinLayerInfo(li:PTR TO layer_info) IS NATIVE {ThinLayerInfo(} li {)} ENDNATIVE
NATIVE {MoveLayerInFrontOf} PROC
PROC MoveLayerInFrontOf(layer_to_move:PTR TO layer, other_layer:PTR TO layer) IS NATIVE {MoveLayerInFrontOf(} layer_to_move {,} other_layer {)} ENDNATIVE !!VALUE
NATIVE {InstallClipRegion} PROC
PROC InstallClipRegion(l:PTR TO layer, region:PTR TO region) IS NATIVE {InstallClipRegion(} l {,} region {)} ENDNATIVE !!PTR TO region
NATIVE {MoveSizeLayer} PROC
PROC MoveSizeLayer(l:PTR TO layer, dx:VALUE, dy:VALUE, dw:VALUE, dh:VALUE) IS NATIVE {MoveSizeLayer(} l {,} dx {,} dy {,} dw {,} dh {)} ENDNATIVE !!VALUE
NATIVE {CreateUpfrontHookLayer} PROC
PROC CreateUpfrontHookLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook, bm2:PTR TO bitmap) IS NATIVE {CreateUpfrontHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {CreateBehindHookLayer} PROC
PROC CreateBehindHookLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook, bm2:PTR TO bitmap) IS NATIVE {CreateBehindHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {InstallLayerHook} PROC
PROC InstallLayerHook(layer:PTR TO layer, hook:PTR TO hook) IS NATIVE {InstallLayerHook(} layer {,} hook {)} ENDNATIVE !!PTR TO hook
NATIVE {InstallLayerInfoHook} PROC
PROC InstallLayerInfoHook(li:PTR TO layer_info, hook:PTR TO hook) IS NATIVE {InstallLayerInfoHook(} li {,} hook {)} ENDNATIVE !!PTR TO hook
NATIVE {SortLayerCR} PROC
PROC SortLayerCR(layer:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {SortLayerCR(} layer {,} dx {,} dy {)} ENDNATIVE
NATIVE {DoHookClipRects} PROC
PROC DoHookClipRects(hook:PTR TO hook, rport:PTR TO rastport, rect:PTR TO rectangle) IS NATIVE {DoHookClipRects(} hook {,} rport {,} rect {)} ENDNATIVE
->NATIVE {CreateLayerTagList} PROC
->PROC CreateLayerTagList(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, tagList:PTR TO tagitem) IS NATIVE {CreateLayerTagList(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} tagList {)} ENDNATIVE !!PTR TO layer
->NATIVE {GetFirstFamilyMember} PROC
->PROC GetFirstFamilyMember(l:PTR TO layer) IS NATIVE {GetFirstFamilyMember(} l {)} ENDNATIVE !!PTR TO layer
->NATIVE {ChangeLayerVisibility} PROC
->PROC ChangeLayerVisibility(l:PTR TO layer, visible:VALUE) IS NATIVE {ChangeLayerVisibility(} l {, (int) } visible {)} ENDNATIVE !!VALUE
NATIVE {IsLayerVisible} PROC
PROC IsLayerVisible(l:PTR TO layer) IS NATIVE {IsLayerVisible(} l {)} ENDNATIVE !!VALUE
NATIVE {ChangeLayerShape} PROC
PROC ChangeLayerShape(l:PTR TO layer, newshape:PTR TO region, callback:PTR TO hook) IS NATIVE {ChangeLayerShape(} l {,} newshape {,} callback {)} ENDNATIVE !!PTR TO region
NATIVE {ScaleLayer} PROC
PROC ScaleLayer(l:PTR TO layer, taglist:PTR TO tagitem) IS NATIVE {ScaleLayer(} l {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {IsFrontmostLayer} PROC
->PROC IsFrontmostLayer(l:PTR TO layer, check_invisible:BOOL) IS NATIVE {-IsFrontmostLayer(} l {, -} check_invisible {)} ENDNATIVE !!BOOL
NATIVE {IsLayerHiddenBySibling} PROC
PROC IsLayerHiddenBySibling(l:PTR TO layer, check_invisible:BOOL) IS NATIVE {-IsLayerHiddenBySibling(} l {, -} check_invisible {)} ENDNATIVE !!BOOL
NATIVE {CollectPixelsLayer} PROC
PROC CollectPixelsLayer(l:PTR TO layer, r:PTR TO region, callback:PTR TO hook) IS NATIVE {CollectPixelsLayer(} l {,} r {,} callback {)} ENDNATIVE
