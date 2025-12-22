/* $VER: layers_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types', 'target/graphics/layers', 'target/graphics/clip', 'target/graphics/rastport', 'target/graphics/regions'
MODULE 'target/exec/libraries', 'target/utility/hooks', 'target/utility/tagitem'
{
#include <proto/layers.h>
}
{
struct Library* LayersBase = NULL;
}
NATIVE {CLIB_LAYERS_PROTOS_H} CONST
NATIVE {_PROTO_LAYERS_H} CONST
NATIVE {PRAGMA_LAYERS_H} CONST
NATIVE {_INLINE_LAYERS_H} CONST

NATIVE {LayersBase} DEF layersbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {InitLayers} PROC
PROC InitLayers( li:PTR TO layer_info ) IS NATIVE {InitLayers(} li {)} ENDNATIVE
NATIVE {CreateUpfrontLayer} PROC
PROC CreateUpfrontLayer( li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap ) IS NATIVE {CreateUpfrontLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {CreateBehindLayer} PROC
PROC CreateBehindLayer( li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, bm2:PTR TO bitmap ) IS NATIVE {CreateBehindLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {UpfrontLayer} PROC
PROC UpfrontLayer( dummy:VALUE, layer:PTR TO layer ) IS NATIVE {UpfrontLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
NATIVE {BehindLayer} PROC
PROC BehindLayer( dummy:VALUE, layer:PTR TO layer ) IS NATIVE {BehindLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
NATIVE {MoveLayer} PROC
PROC MoveLayer( dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE ) IS NATIVE {MoveLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE !!VALUE
NATIVE {SizeLayer} PROC
PROC SizeLayer( dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE ) IS NATIVE {SizeLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE !!VALUE
NATIVE {ScrollLayer} PROC
PROC ScrollLayer( dummy:VALUE, layer:PTR TO layer, dx:VALUE, dy:VALUE ) IS NATIVE {ScrollLayer(} dummy {,} layer {,} dx {,} dy {)} ENDNATIVE
NATIVE {BeginUpdate} PROC
PROC BeginUpdate( l:PTR TO layer ) IS NATIVE {BeginUpdate(} l {)} ENDNATIVE !!VALUE
NATIVE {EndUpdate} PROC
PROC EndUpdate( layer:PTR TO layer, flag:ULONG ) IS NATIVE {EndUpdate(} layer {,} flag {)} ENDNATIVE
NATIVE {DeleteLayer} PROC
PROC DeleteLayer( dummy:VALUE, layer:PTR TO layer ) IS NATIVE {DeleteLayer(} dummy {,} layer {)} ENDNATIVE !!VALUE
NATIVE {LockLayer} PROC
PROC LockLayer( dummy:VALUE, layer:PTR TO layer ) IS NATIVE {LockLayer(} dummy {,} layer {)} ENDNATIVE
NATIVE {UnlockLayer} PROC
PROC UnlockLayer( layer:PTR TO layer ) IS NATIVE {UnlockLayer(} layer {)} ENDNATIVE
NATIVE {LockLayers} PROC
PROC LockLayers( li:PTR TO layer_info ) IS NATIVE {LockLayers(} li {)} ENDNATIVE
NATIVE {UnlockLayers} PROC
PROC UnlockLayers( li:PTR TO layer_info ) IS NATIVE {UnlockLayers(} li {)} ENDNATIVE
NATIVE {LockLayerInfo} PROC
PROC LockLayerInfo( li:PTR TO layer_info ) IS NATIVE {LockLayerInfo(} li {)} ENDNATIVE
NATIVE {SwapBitsRastPortClipRect} PROC
PROC SwapBitsRastPortClipRect( rp:PTR TO rastport, cr:PTR TO cliprect ) IS NATIVE {SwapBitsRastPortClipRect(} rp {,} cr {)} ENDNATIVE
NATIVE {WhichLayer} PROC
PROC WhichLayer( li:PTR TO layer_info, x:VALUE, y:VALUE ) IS NATIVE {WhichLayer(} li {,} x {,} y {)} ENDNATIVE !!PTR TO layer
NATIVE {UnlockLayerInfo} PROC
PROC UnlockLayerInfo( li:PTR TO layer_info ) IS NATIVE {UnlockLayerInfo(} li {)} ENDNATIVE
NATIVE {NewLayerInfo} PROC
PROC NewLayerInfo( ) IS NATIVE {NewLayerInfo()} ENDNATIVE !!PTR TO layer_info
NATIVE {DisposeLayerInfo} PROC
PROC DisposeLayerInfo( li:PTR TO layer_info ) IS NATIVE {DisposeLayerInfo(} li {)} ENDNATIVE
NATIVE {FattenLayerInfo} PROC
PROC FattenLayerInfo( li:PTR TO layer_info ) IS NATIVE {FattenLayerInfo(} li {)} ENDNATIVE !!VALUE
NATIVE {ThinLayerInfo} PROC
PROC ThinLayerInfo( li:PTR TO layer_info ) IS NATIVE {ThinLayerInfo(} li {)} ENDNATIVE
NATIVE {MoveLayerInFrontOf} PROC
PROC MoveLayerInFrontOf( layer_to_move:PTR TO layer, other_layer:PTR TO layer ) IS NATIVE {MoveLayerInFrontOf(} layer_to_move {,} other_layer {)} ENDNATIVE !!VALUE
NATIVE {InstallClipRegion} PROC
PROC InstallClipRegion( layer:PTR TO layer, region:PTR TO region ) IS NATIVE {InstallClipRegion(} layer {,} region {)} ENDNATIVE !!PTR TO region
NATIVE {MoveSizeLayer} PROC
PROC MoveSizeLayer( layer:PTR TO layer, dx:VALUE, dy:VALUE, dw:VALUE, dh:VALUE ) IS NATIVE {MoveSizeLayer(} layer {,} dx {,} dy {,} dw {,} dh {)} ENDNATIVE !!VALUE
NATIVE {CreateUpfrontHookLayer} PROC
PROC CreateUpfrontHookLayer( li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook, bm2:PTR TO bitmap ) IS NATIVE {CreateUpfrontHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {CreateBehindHookLayer} PROC
PROC CreateBehindHookLayer( li:PTR TO layer_info, bm:PTR TO bitmap, x0:VALUE, y0:VALUE, x1:VALUE, y1:VALUE, flags:VALUE, hook:PTR TO hook, bm2:PTR TO bitmap ) IS NATIVE {CreateBehindHookLayer(} li {,} bm {,} x0 {,} y0 {,} x1 {,} y1 {,} flags {,} hook {,} bm2 {)} ENDNATIVE !!PTR TO layer
NATIVE {InstallLayerHook} PROC
PROC InstallLayerHook( layer:PTR TO layer, hook:PTR TO hook ) IS NATIVE {InstallLayerHook(} layer {,} hook {)} ENDNATIVE !!PTR TO hook
/*--- functions in V39 or higher (Release 3) ---*/
NATIVE {InstallLayerInfoHook} PROC
PROC InstallLayerInfoHook( li:PTR TO layer_info, hook:PTR TO hook ) IS NATIVE {InstallLayerInfoHook(} li {,} hook {)} ENDNATIVE !!PTR TO hook
NATIVE {SortLayerCR} PROC
PROC SortLayerCR( layer:PTR TO layer, dx:VALUE, dy:VALUE ) IS NATIVE {SortLayerCR(} layer {,} dx {,} dy {)} ENDNATIVE
NATIVE {DoHookClipRects} PROC
PROC DoHookClipRects( hook:PTR TO hook, rport:PTR TO rastport, rect:PTR TO rectangle ) IS NATIVE {DoHookClipRects(} hook {,} rport {,} rect {)} ENDNATIVE
