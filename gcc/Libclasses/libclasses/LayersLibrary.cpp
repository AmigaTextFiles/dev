
#ifndef _LAYERSLIBRARY_CPP
#define _LAYERSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/LayersLibrary.h>

LayersLibrary::LayersLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("layers.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open layers.library") );
	}
}

LayersLibrary::~LayersLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID LayersLibrary::InitLayers(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-30)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct Layer * LayersLibrary::CreateUpfrontLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap * bm2)
{
	register struct Layer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register void * a1 __asm("a1") = bm;
	register int d0 __asm("d0") = x0;
	register int d1 __asm("d1") = y0;
	register int d2 __asm("d2") = x1;
	register int d3 __asm("d3") = y1;
	register int d4 __asm("d4") = flags;
	register void * a2 __asm("a2") = bm2;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "d3", "d4", "a2");
	return (struct Layer *) _res;
}

struct Layer * LayersLibrary::CreateBehindLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct BitMap * bm2)
{
	register struct Layer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register void * a1 __asm("a1") = bm;
	register int d0 __asm("d0") = x0;
	register int d1 __asm("d1") = y0;
	register int d2 __asm("d2") = x1;
	register int d3 __asm("d3") = y1;
	register int d4 __asm("d4") = flags;
	register void * a2 __asm("a2") = bm2;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "d3", "d4", "a2");
	return (struct Layer *) _res;
}

LONG LayersLibrary::UpfrontLayer(LONG dummy, struct Layer * layer)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

LONG LayersLibrary::BehindLayer(LONG dummy, struct Layer * layer)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

LONG LayersLibrary::MoveLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (LONG) _res;
}

LONG LayersLibrary::SizeLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (LONG) _res;
}

VOID LayersLibrary::ScrollLayer(LONG dummy, struct Layer * layer, LONG dx, LONG dy)
{
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

LONG LayersLibrary::BeginUpdate(struct Layer * l)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = l;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

VOID LayersLibrary::EndUpdate(struct Layer * layer, ULONG flag)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;
	register unsigned int d0 __asm("d0") = flag;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

LONG LayersLibrary::DeleteLayer(LONG dummy, struct Layer * layer)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

VOID LayersLibrary::LockLayer(LONG dummy, struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = dummy;
	register void * a1 __asm("a1") = layer;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID LayersLibrary::UnlockLayer(struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;

	__asm volatile ("jsr a6@(-102)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID LayersLibrary::LockLayers(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID LayersLibrary::UnlockLayers(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID LayersLibrary::LockLayerInfo(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID LayersLibrary::SwapBitsRastPortClipRect(struct RastPort * rp, struct ClipRect * cr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register void * a1 __asm("a1") = cr;

	__asm volatile ("jsr a6@(-126)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Layer * LayersLibrary::WhichLayer(struct Layer_Info * li, LONG x, LONG y)
{
	register struct Layer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (struct Layer *) _res;
}

VOID LayersLibrary::UnlockLayerInfo(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-138)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct Layer_Info * LayersLibrary::NewLayerInfo()
{
	register struct Layer_Info * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct Layer_Info *) _res;
}

VOID LayersLibrary::DisposeLayerInfo(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-150)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG LayersLibrary::FattenLayerInfo(struct Layer_Info * li)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

VOID LayersLibrary::ThinLayerInfo(struct Layer_Info * li)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;

	__asm volatile ("jsr a6@(-162)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG LayersLibrary::MoveLayerInFrontOf(struct Layer * layer_to_move, struct Layer * other_layer)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer_to_move;
	register void * a1 __asm("a1") = other_layer;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

struct Region * LayersLibrary::InstallClipRegion(struct Layer * layer, CONST struct Region * region)
{
	register struct Region * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;
	register const void * a1 __asm("a1") = region;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Region *) _res;
}

LONG LayersLibrary::MoveSizeLayer(struct Layer * layer, LONG dx, LONG dy, LONG dw, LONG dh)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;
	register int d2 __asm("d2") = dw;
	register int d3 __asm("d3") = dh;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
	return (LONG) _res;
}

struct Layer * LayersLibrary::CreateUpfrontHookLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook * hook, struct BitMap * bm2)
{
	register struct Layer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register void * a1 __asm("a1") = bm;
	register int d0 __asm("d0") = x0;
	register int d1 __asm("d1") = y0;
	register int d2 __asm("d2") = x1;
	register int d3 __asm("d3") = y1;
	register int d4 __asm("d4") = flags;
	register void * a3 __asm("a3") = hook;
	register void * a2 __asm("a2") = bm2;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a3), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "d3", "d4", "a3", "a2");
	return (struct Layer *) _res;
}

struct Layer * LayersLibrary::CreateBehindHookLayer(struct Layer_Info * li, struct BitMap * bm, LONG x0, LONG y0, LONG x1, LONG y1, LONG flags, struct Hook * hook, struct BitMap * bm2)
{
	register struct Layer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register void * a1 __asm("a1") = bm;
	register int d0 __asm("d0") = x0;
	register int d1 __asm("d1") = y0;
	register int d2 __asm("d2") = x1;
	register int d3 __asm("d3") = y1;
	register int d4 __asm("d4") = flags;
	register void * a3 __asm("a3") = hook;
	register void * a2 __asm("a2") = bm2;

	__asm volatile ("jsr a6@(-192)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a3), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "d3", "d4", "a3", "a2");
	return (struct Layer *) _res;
}

struct Hook * LayersLibrary::InstallLayerHook(struct Layer * layer, struct Hook * hook)
{
	register struct Hook * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;
	register void * a1 __asm("a1") = hook;

	__asm volatile ("jsr a6@(-198)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Hook *) _res;
}

struct Hook * LayersLibrary::InstallLayerInfoHook(struct Layer_Info * li, CONST struct Hook * hook)
{
	register struct Hook * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = li;
	register const void * a1 __asm("a1") = hook;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Hook *) _res;
}

VOID LayersLibrary::SortLayerCR(struct Layer * layer, LONG dx, LONG dy)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-210)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

VOID LayersLibrary::DoHookClipRects(struct Hook * hook, struct RastPort * rport, CONST struct Rectangle * rect)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = hook;
	register void * a1 __asm("a1") = rport;
	register const void * a2 __asm("a2") = rect;

	__asm volatile ("jsr a6@(-216)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}


#endif

