/* $VER: layers_protos.h 53.13 (31.1.2010) */
OPT NATIVE
MODULE 'target/exec/types', 'target/graphics/layers', 'target/graphics/clip', 'target/graphics/rastport', 'target/graphics/regions'
MODULE 'target/utility/hooks', 'target/utility/tagitem'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types'
{
#include <proto/layers.h>
}
{
struct Library* LayersBase = NULL;
struct LayersIFace* ILayers = NULL;
}
NATIVE {CLIB_LAYERS_PROTOS_H} CONST
NATIVE {PROTO_LAYERS_H} CONST
NATIVE {LAYERS_INTERFACE_DEF_H} CONST


NATIVE {LayersBase} DEF layersbase:PTR TO lib
NATIVE {ILayers} DEF

PROC new()
	InitLibrary('layers.library', NATIVE {(struct Interface **) &ILayers} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {InitLayers} PROC
PROC InitLayers(li:PTR TO layer_info) IS NATIVE {ILayers->InitLayers(} li {)} ENDNATIVE
->NATIVE {CreateUpfrontLayer} PROC
PROC CreateUpfrontLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE,
    x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap) IS NATIVE {ILayers->CreateUpfrontLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
->NATIVE {CreateBehindLayer} PROC
PROC CreateBehindLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE,
    x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap) IS NATIVE {ILayers->CreateBehindLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
->NATIVE {UpfrontLayer} PROC
PROC UpfrontLayer(dummy:VALUE, layer:PTR TO layer) IS NATIVE {ILayers->UpfrontLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
->NATIVE {BehindLayer} PROC
PROC BehindLayer(dummy:VALUE, layer:PTR TO layer) IS NATIVE {ILayers->BehindLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
->NATIVE {MoveLayer} PROC
PROC MoveLayer(dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {ILayers->MoveLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE !!VALUE
->NATIVE {SizeLayer} PROC
PROC SizeLayer(dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {ILayers->SizeLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE !!VALUE
->NATIVE {ScrollLayer} PROC
PROC ScrollLayer(dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {ILayers->ScrollLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE
->NATIVE {BeginUpdate} PROC
PROC BeginUpdate(l:PTR TO layer) IS NATIVE {ILayers->BeginUpdate(} l {)} ENDNATIVE !!VALUE
->NATIVE {EndUpdate} PROC
PROC EndUpdate(layer:PTR TO layer, flag:ULONG) IS NATIVE {ILayers->EndUpdate(} layer {,} flag {)} ENDNATIVE
->NATIVE {DeleteLayer} PROC
PROC DeleteLayer(dummy:VALUE, layer:PTR TO layer) IS NATIVE {ILayers->DeleteLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
->NATIVE {LockLayer} PROC
PROC LockLayer(dummy:VALUE, layer:PTR TO layer) IS NATIVE {ILayers->LockLayer(} dummy {,} layer {)} ENDNATIVE
->NATIVE {UnlockLayer} PROC
PROC UnlockLayer(layer:PTR TO layer) IS NATIVE {ILayers->UnlockLayer(} layer {)} ENDNATIVE
->NATIVE {LockLayers} PROC
PROC LockLayers(li:PTR TO layer_info) IS NATIVE {ILayers->LockLayers(} li {)} ENDNATIVE
->NATIVE {UnlockLayers} PROC
PROC UnlockLayers(li:PTR TO layer_info) IS NATIVE {ILayers->UnlockLayers(} li {)} ENDNATIVE
->NATIVE {LockLayerInfo} PROC
PROC LockLayerInfo(li:PTR TO layer_info) IS NATIVE {ILayers->LockLayerInfo(} li {)} ENDNATIVE
->NATIVE {SwapBitsRastPortClipRect} PROC
PROC SwapBitsRastPortClipRect(rp:PTR TO rastport, cr:PTR TO cliprect) IS NATIVE {ILayers->SwapBitsRastPortClipRect(} rp {,} cr {)} ENDNATIVE
->NATIVE {WhichLayer} PROC
PROC WhichLayer(li:PTR TO layer_info, x:VALUE, y:VALUE) IS NATIVE {ILayers->WhichLayer(} li {,} x {,} y {)} ENDNATIVE !!PTR TO layer
->NATIVE {UnlockLayerInfo} PROC
PROC UnlockLayerInfo(li:PTR TO layer_info) IS NATIVE {ILayers->UnlockLayerInfo(} li {)} ENDNATIVE
->NATIVE {NewLayerInfo} PROC
PROC NewLayerInfo() IS NATIVE {ILayers->NewLayerInfo()} ENDNATIVE !!PTR TO layer_info
->NATIVE {DisposeLayerInfo} PROC
PROC DisposeLayerInfo(li:PTR TO layer_info) IS NATIVE {ILayers->DisposeLayerInfo(} li {)} ENDNATIVE
->NATIVE {FattenLayerInfo} PROC
PROC FattenLayerInfo(li:PTR TO layer_info) IS NATIVE {ILayers->FattenLayerInfo(} li {)} ENDNATIVE !!VALUE
->NATIVE {ThinLayerInfo} PROC
PROC ThinLayerInfo(li:PTR TO layer_info) IS NATIVE {ILayers->ThinLayerInfo(} li {)} ENDNATIVE
->NATIVE {MoveLayerInFrontOf} PROC
PROC MoveLayerInFrontOf(layer_to_move:PTR TO layer, other_layer:PTR TO layer) IS NATIVE {ILayers->MoveLayerInFrontOf(} layer_to_move {,} other_layer {)} ENDNATIVE !!VALUE
->NATIVE {InstallClipRegion} PROC
PROC InstallClipRegion(layer:PTR TO layer, region:PTR TO region) IS NATIVE {ILayers->InstallClipRegion(} layer {,} region {)} ENDNATIVE !!PTR TO region
->NATIVE {MoveSizeLayer} PROC
PROC MoveSizeLayer(layer:PTR TO layer, dx:VALUE, dy:VALUE, dw:VALUE, dh:VALUE) IS NATIVE {ILayers->MoveSizeLayer(} layer {,} dx {,} dy {,} dw {,} dh {)} ENDNATIVE !!VALUE
->NATIVE {CreateUpfrontHookLayer} PROC
PROC CreateUpfrontHookLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE,
    x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook,
    bm2:PTR TO bitmap) IS NATIVE {ILayers->CreateUpfrontHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
->NATIVE {CreateBehindHookLayer} PROC
PROC CreateBehindHookLayer(li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE,
    x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook,
    bm2:PTR TO bitmap) IS NATIVE {ILayers->CreateBehindHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
->NATIVE {InstallLayerHook} PROC
PROC InstallLayerHook(layer:PTR TO layer, hook:PTR TO hook) IS NATIVE {ILayers->InstallLayerHook(} layer {,} hook {)} ENDNATIVE !!PTR TO hook
->NATIVE {InstallLayerInfoHook} PROC
PROC InstallLayerInfoHook(li:PTR TO layer_info, hook:PTR TO hook) IS NATIVE {ILayers->InstallLayerInfoHook(} li {,} hook {)} ENDNATIVE !!PTR TO hook
->NATIVE {SortLayerCR} PROC
PROC SortLayerCR(layer:PTR TO layer, dx:VALUE, dy:VALUE) IS NATIVE {ILayers->SortLayerCR(} layer {,} dx {,} dy {)} ENDNATIVE
->NATIVE {DoHookClipRects} PROC
PROC DoHookClipRects(hook:PTR TO hook, rport:PTR TO rastport,
    rect:PTR TO rectangle) IS NATIVE {ILayers->DoHookClipRects(} hook {,} rport {,} rect {)} ENDNATIVE
->NATIVE {LayerOccluded} PROC
PROC LayerOccluded(layer:PTR TO layer) IS NATIVE {ILayers->LayerOccluded(} layer {)} ENDNATIVE !!VALUE
->NATIVE {HideLayer} PROC
PROC HideLayer(layer:PTR TO layer) IS NATIVE {ILayers->HideLayer(} layer {)} ENDNATIVE !!VALUE
->NATIVE {ShowLayer} PROC
PROC ShowLayer(layer:PTR TO layer, infront_of:PTR TO layer) IS NATIVE {ILayers->ShowLayer(} layer {,} infront_of {)} ENDNATIVE !!VALUE
->NATIVE {SetLayerInfoBounds} PROC
PROC SetLayerInfoBounds(li:PTR TO layer_info, bounds:PTR TO rectangle) IS NATIVE {ILayers->SetLayerInfoBounds(} li {,} bounds {)} ENDNATIVE !!VALUE
->NATIVE {CreateBackFillHookA} PROC
PROC CreateBackFillHookA(tags:PTR TO tagitem) IS NATIVE {ILayers->CreateBackFillHookA(} tags {)} ENDNATIVE !!PTR TO hook
->NATIVE {CreateBackFillHook} PROC
PROC CreateBackFillHook(tags:ULONG, tags2=0:ULONG, ...) IS NATIVE {ILayers->CreateBackFillHook(} tags {,} tags2 {,} ... {)} ENDNATIVE !!PTR TO hook
->NATIVE {DeleteBackFillHook} PROC
PROC DeleteBackFillHook(hook:PTR TO hook) IS NATIVE {ILayers->DeleteBackFillHook(} hook {)} ENDNATIVE
->NATIVE {SetBackFillHookAttrsA} PROC
PROC SetBackFillHookAttrsA(hook:PTR TO hook, tags:PTR TO tagitem) IS NATIVE {ILayers->SetBackFillHookAttrsA(} hook {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {SetBackFillHookAttrs} PROC
PROC SetBackFillHookAttrs(hook:PTR TO hook, tags:ULONG, tags2=0:ULONG, ...) IS NATIVE {ILayers->SetBackFillHookAttrs(} hook {,} tags {,} tags2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {GetBackFillHookAttrsA} PROC
PROC GetBackFillHookAttrsA(hook:PTR TO hook, tags:PTR TO tagitem) IS NATIVE {ILayers->GetBackFillHookAttrsA(} hook {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {GetBackFillHookAttrs} PROC
PROC GetBackFillHookAttrs(hook:PTR TO hook, tags:ULONG, tags2=0:ULONG, ...) IS NATIVE {ILayers->GetBackFillHookAttrs(} hook {,} tags {,} tags2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {CreateLayerA} PROC
PROC CreateLayerA(li:PTR TO layer_info, tags:PTR TO tagitem) IS NATIVE {ILayers->CreateLayerA(} li {,} tags {)} ENDNATIVE !!PTR TO layer
->NATIVE {CreateLayer} PROC
PROC CreateLayer(li:PTR TO layer_info, tags:ULONG, tags2=0:ULONG, ...) IS NATIVE {ILayers->CreateLayer(} li {,} tags {,} tags2 {,} ... {)} ENDNATIVE !!PTR TO layer
->NATIVE {ChangeLayerShape} PROC
PROC ChangeLayerShape(layer:PTR TO layer, region:PTR TO region, hook:PTR TO hook) IS NATIVE {ILayers->ChangeLayerShape(} layer {,} region {,} hook {)} ENDNATIVE !!PTR TO region
