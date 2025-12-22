#ifndef _INLINE_LAYERS_H
#define _INLINE_LAYERS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct LayersBase*  LayersBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME LayersBase
#endif

static __inline LONG 
BeginUpdate (BASE_PAR_DECL struct Layer *l)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = l;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
BehindLayer (BASE_PAR_DECL long dummy,struct Layer *layer)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct Layer *
CreateBehindHookLayer (BASE_PAR_DECL struct Layer_Info *li,struct BitMap *bm,long x0,long y0,long x1,long y1,long flags,struct Hook *hook,struct BitMap *bm2)
{
  BASE_EXT_DECL
  register struct Layer * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  register struct BitMap *a1 __asm("a1") = bm;
  register long d0 __asm("d0") = x0;
  register long d1 __asm("d1") = y0;
  register long d2 __asm("d2") = x1;
  register long d3 __asm("d3") = y1;
  register long d4 __asm("d4") = flags;
  register struct Hook *a3 __asm("a3") = hook;
  register struct BitMap *a2 __asm("a2") = bm2;
  __asm __volatile ("jsr a6@(-0xc0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a3), "r" (a2)
  : "a0","a1","a2","a3","d0","d1","d2","d3","d4");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a3 = *(char *)a3;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct Layer *
CreateBehindLayer (BASE_PAR_DECL struct Layer_Info *li,struct BitMap *bm,long x0,long y0,long x1,long y1,long flags,struct BitMap *bm2)
{
  BASE_EXT_DECL
  register struct Layer * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  register struct BitMap *a1 __asm("a1") = bm;
  register long d0 __asm("d0") = x0;
  register long d1 __asm("d1") = y0;
  register long d2 __asm("d2") = x1;
  register long d3 __asm("d3") = y1;
  register long d4 __asm("d4") = flags;
  register struct BitMap *a2 __asm("a2") = bm2;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a2)
  : "a0","a1","a2","d0","d1","d2","d3","d4");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct Layer *
CreateUpfrontHookLayer (BASE_PAR_DECL struct Layer_Info *li,struct BitMap *bm,long x0,long y0,long x1,long y1,long flags,struct Hook *hook,struct BitMap *bm2)
{
  BASE_EXT_DECL
  register struct Layer * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  register struct BitMap *a1 __asm("a1") = bm;
  register long d0 __asm("d0") = x0;
  register long d1 __asm("d1") = y0;
  register long d2 __asm("d2") = x1;
  register long d3 __asm("d3") = y1;
  register long d4 __asm("d4") = flags;
  register struct Hook *a3 __asm("a3") = hook;
  register struct BitMap *a2 __asm("a2") = bm2;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a3), "r" (a2)
  : "a0","a1","a2","a3","d0","d1","d2","d3","d4");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a3 = *(char *)a3;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct Layer *
CreateUpfrontLayer (BASE_PAR_DECL struct Layer_Info *li,struct BitMap *bm,long x0,long y0,long x1,long y1,long flags,struct BitMap *bm2)
{
  BASE_EXT_DECL
  register struct Layer * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  register struct BitMap *a1 __asm("a1") = bm;
  register long d0 __asm("d0") = x0;
  register long d1 __asm("d1") = y0;
  register long d2 __asm("d2") = x1;
  register long d3 __asm("d3") = y1;
  register long d4 __asm("d4") = flags;
  register struct BitMap *a2 __asm("a2") = bm2;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (a2)
  : "a0","a1","a2","d0","d1","d2","d3","d4");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline LONG 
DeleteLayer (BASE_PAR_DECL long dummy,struct Layer *layer)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
DisposeLayerInfo (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x96)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
EndUpdate (BASE_PAR_DECL struct Layer *layer,unsigned long flag)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  register unsigned long d0 __asm("d0") = flag;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline LONG 
FattenLayerInfo (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
InitLayers (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline struct Region *
InstallClipRegion (BASE_PAR_DECL struct Layer *layer,struct Region *region)
{
  BASE_EXT_DECL
  register struct Region * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  register struct Region *a1 __asm("a1") = region;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct Hook *
InstallLayerHook (BASE_PAR_DECL struct Layer *layer,struct Hook *hook)
{
  BASE_EXT_DECL
  register struct Hook * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  register struct Hook *a1 __asm("a1") = hook;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
LockLayer (BASE_PAR_DECL long dummy,struct Layer *layer)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline void 
LockLayerInfo (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
LockLayers (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline LONG 
MoveLayer (BASE_PAR_DECL long dummy,struct Layer *layer,long dx,long dy)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
MoveLayerInFrontOf (BASE_PAR_DECL struct Layer *layer_to_move,struct Layer *other_layer)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer_to_move;
  register struct Layer *a1 __asm("a1") = other_layer;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
MoveSizeLayer (BASE_PAR_DECL struct Layer *layer,long dx,long dy,long dw,long dh)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  register long d2 __asm("d2") = dw;
  register long d3 __asm("d3") = dh;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct Layer_Info *
NewLayerInfo (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct Layer_Info * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
ScrollLayer (BASE_PAR_DECL long dummy,struct Layer *layer,long dx,long dy)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline LONG 
SizeLayer (BASE_PAR_DECL long dummy,struct Layer *layer,long dx,long dy)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
SwapBitsRastPortClipRect (BASE_PAR_DECL struct RastPort *rp,struct ClipRect *cr)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct ClipRect *a1 __asm("a1") = cr;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline void 
ThinLayerInfo (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0xa2)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
UnlockLayer (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
UnlockLayerInfo (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x8a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
UnlockLayers (BASE_PAR_DECL struct Layer_Info *li)
{
  BASE_EXT_DECL
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline LONG 
UpfrontLayer (BASE_PAR_DECL long dummy,struct Layer *layer)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register long a0 __asm("a0") = dummy;
  register struct Layer *a1 __asm("a1") = layer;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct Layer *
WhichLayer (BASE_PAR_DECL struct Layer_Info *li,long x,long y)
{
  BASE_EXT_DECL
  register struct Layer * _res  __asm("d0");
  register struct LayersBase* a6 __asm("a6") = BASE_NAME;
  register struct Layer_Info *a0 __asm("a0") = li;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_LAYERS_H */
