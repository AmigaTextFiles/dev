
#ifndef _LAYERSLIBRARY_H
#define _LAYERSLIBRARY_H

#include <exec/types.h>
#include <graphics/layers.h>
#include <graphics/clip.h>
#include <graphics/rastport.h>
#include <graphics/regions.h>

class LayersLibrary
{
public:
	LayersLibrary();
	~LayersLibrary();

	static class LayersLibrary Default;

	VOID InitLayers(struct Layer_Info * li);
	struct Layer * CreateUpfrontLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap * bm2);
	struct Layer * CreateBehindLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap * bm2);
	LONG UpfrontLayer(LONG dummy, struct Layer * layer);
	LONG BehindLayer(LONG dummy, struct Layer * layer);
	LONG MoveLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy);
	LONG SizeLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy);
	VOID ScrollLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy);
	LONG BeginUpdate(struct Layer * l);
	VOID EndUpdate(struct Layer * layer, ULONG flag);
	LONG DeleteLayer(LONG dummy, struct Layer * layer);
	VOID LockLayer(LONG dummy, struct Layer * layer);
	VOID UnlockLayer(struct Layer * layer);
	VOID LockLayers(struct Layer_Info * li);
	VOID UnlockLayers(struct Layer_Info * li);
	VOID LockLayerInfo(struct Layer_Info * li);
	VOID SwapBitsRastPortClipRect(struct RastPort * rp, struct ClipRect * cr);
	struct Layer * WhichLayer(struct Layer_Info * li, LONG x, LONG y);
	VOID UnlockLayerInfo(struct Layer_Info * li);
	struct Layer_Info * NewLayerInfo();
	VOID DisposeLayerInfo(struct Layer_Info * li);
	LONG FattenLayerInfo(struct Layer_Info * li);
	VOID ThinLayerInfo(struct Layer_Info * li);
	LONG MoveLayerInFrontOf(struct Layer * layer_to_move, struct Layer * other_layer);
	struct Region * InstallClipRegion(struct Layer * layer, CONST struct Region * region);
	LONG MoveSizeLayer(struct Layer * layer, LONG dx, LONG dy, LONG dw, LONG dh);
	struct Layer * CreateUpfrontHookLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook * hook, struct BitMap * bm2);
	struct Layer * CreateBehindHookLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook * hook, struct BitMap * bm2);
	struct Hook * InstallLayerHook(struct Layer * layer, struct Hook * hook);
	struct Hook * InstallLayerInfoHook(struct Layer_Info * li, CONST struct Hook * hook);
	VOID SortLayerCR(struct Layer * layer, LONG dx, LONG dy);
	VOID DoHookClipRects(struct Hook * hook, struct RastPort * rport, CONST struct Rectangle * rect);

private:
	struct Library *Base;
};

LayersLibrary LayersLibrary::Default;

#endif

