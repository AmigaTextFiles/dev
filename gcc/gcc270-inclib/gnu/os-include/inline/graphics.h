#ifndef _INLINE_GRAPHICS_H
#define _INLINE_GRAPHICS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct GfxBase * GfxBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME GfxBase
#endif

BASE_EXT_DECL0

extern __inline void 
AddAnimOb (BASE_PAR_DECL struct AnimOb *anOb,struct AnimOb **anKey,struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AnimOb *a0 __asm("a0") = anOb;
  register struct AnimOb **a1 __asm("a1") = anKey;
  register struct RastPort *a2 __asm("a2") = rp;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
AddBob (BASE_PAR_DECL struct Bob *bob,struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Bob *a0 __asm("a0") = bob;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddFont (BASE_PAR_DECL struct TextFont *textFont)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a1 __asm("a1") = textFont;
  __asm __volatile ("jsr a6@(-0x1e0)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddVSprite (BASE_PAR_DECL struct VSprite *vSprite,struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct VSprite *a0 __asm("a0") = vSprite;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct BitMap *
AllocBitMap (BASE_PAR_DECL unsigned long sizex,unsigned long sizey,unsigned long depth,unsigned long flags,struct BitMap *friend_bitmap)
{
  BASE_EXT_DECL
  register struct BitMap * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = sizex;
  register unsigned long d1 __asm("d1") = sizey;
  register unsigned long d2 __asm("d2") = depth;
  register unsigned long d3 __asm("d3") = flags;
  register struct BitMap *a0 __asm("a0") = friend_bitmap;
  __asm __volatile ("jsr a6@(-0x396)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a0)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline struct DBufInfo *
AllocDBufInfo (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct DBufInfo * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x3c6)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline PLANEPTR 
AllocRaster (BASE_PAR_DECL unsigned long width,unsigned long height)
{
  BASE_EXT_DECL
  register PLANEPTR  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = width;
  register unsigned long d1 __asm("d1") = height;
  __asm __volatile ("jsr a6@(-0x1ec)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct ExtSprite *
AllocSpriteDataA (BASE_PAR_DECL struct BitMap *bm,struct TagItem *tags)
{
  BASE_EXT_DECL
  register struct ExtSprite * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a2 __asm("a2") = bm;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x3fc)"
  : "=r" (_res)
  : "r" (a6), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AllocSpriteData(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; AllocSpriteDataA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
AndRectRegion (BASE_PAR_DECL struct Region *region,struct Rectangle *rectangle)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  register struct Rectangle *a1 __asm("a1") = rectangle;
  __asm __volatile ("jsr a6@(-0x1f8)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
AndRegionRegion (BASE_PAR_DECL struct Region *srcRegion,struct Region *destRegion)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = srcRegion;
  register struct Region *a1 __asm("a1") = destRegion;
  __asm __volatile ("jsr a6@(-0x270)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Animate (BASE_PAR_DECL struct AnimOb **anKey,struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AnimOb **a0 __asm("a0") = anKey;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0xa2)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
AreaDraw (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
AreaEllipse (BASE_PAR_DECL struct RastPort *rp,long xCenter,long yCenter,long a,long b)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = xCenter;
  register long d1 __asm("d1") = yCenter;
  register long d2 __asm("d2") = a;
  register long d3 __asm("d3") = b;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline LONG 
AreaEnd (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x108)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
AreaMove (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0xfc)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
AskFont (BASE_PAR_DECL struct RastPort *rp,struct TextAttr *textAttr)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register struct TextAttr *a0 __asm("a0") = textAttr;
  __asm __volatile ("jsr a6@(-0x1da)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
AskSoftStyle (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
AttachPalExtra (BASE_PAR_DECL struct ColorMap *cm,struct ViewPort *vp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register struct ViewPort *a1 __asm("a1") = vp;
  __asm __volatile ("jsr a6@(-0x342)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
AttemptLockLayerRom (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Layer *a2 __asm("a2") = layer;
  __asm __volatile ("exg a2,a5\n\tjsr a6@(-0x28e)\n\texg a2,a5"
  : "=r" (_res)
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
BestModeIDA (BASE_PAR_DECL struct TagItem *tags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tags;
  __asm __volatile ("jsr a6@(-0x41a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define BestModeID(tags...) \
  ({ struct TagItem _tags[] = { tags }; BestModeIDA (_tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
BitMapScale (BASE_PAR_DECL struct BitScaleArgs *bitScaleArgs)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitScaleArgs *a0 __asm("a0") = bitScaleArgs;
  __asm __volatile ("jsr a6@(-0x2a6)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
BltBitMap (BASE_PAR_DECL struct BitMap *srcBitMap,long xSrc,long ySrc,struct BitMap *destBitMap,long xDest,long yDest,long xSize,long ySize,unsigned long minterm,unsigned long mask,PLANEPTR tempA)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = srcBitMap;
  register long d0 __asm("d0") = xSrc;
  register long d1 __asm("d1") = ySrc;
  register struct BitMap *a1 __asm("a1") = destBitMap;
  register long d2 __asm("d2") = xDest;
  register long d3 __asm("d3") = yDest;
  register long d4 __asm("d4") = xSize;
  register long d5 __asm("d5") = ySize;
  register unsigned long d6 __asm("d6") = minterm;
  register unsigned long d7 __asm("d7") = mask;
  register PLANEPTR a2 __asm("a2") = tempA;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (d7), "r" (a2)
  : "a0","a1","a2","d0","d1","d2","d3","d4","d5","d6","d7", "memory");
  return _res;
}
extern __inline void 
BltBitMapRastPort (BASE_PAR_DECL struct BitMap *srcBitMap,long xSrc,long ySrc,struct RastPort *destRP,long xDest,long yDest,long xSize,long ySize,unsigned long minterm)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = srcBitMap;
  register long d0 __asm("d0") = xSrc;
  register long d1 __asm("d1") = ySrc;
  register struct RastPort *a1 __asm("a1") = destRP;
  register long d2 __asm("d2") = xDest;
  register long d3 __asm("d3") = yDest;
  register long d4 __asm("d4") = xSize;
  register long d5 __asm("d5") = ySize;
  register unsigned long d6 __asm("d6") = minterm;
  __asm __volatile ("jsr a6@(-0x25e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6)
  : "a0","a1","d0","d1","d2","d3","d4","d5","d6", "memory");
}
extern __inline void 
BltClear (BASE_PAR_DECL PLANEPTR memBlock,unsigned long byteCount,unsigned long flags)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register PLANEPTR a1 __asm("a1") = memBlock;
  register unsigned long d0 __asm("d0") = byteCount;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x12c)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
BltMaskBitMapRastPort (BASE_PAR_DECL struct BitMap *srcBitMap,long xSrc,long ySrc,struct RastPort *destRP,long xDest,long yDest,long xSize,long ySize,unsigned long minterm,PLANEPTR bltMask)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = srcBitMap;
  register long d0 __asm("d0") = xSrc;
  register long d1 __asm("d1") = ySrc;
  register struct RastPort *a1 __asm("a1") = destRP;
  register long d2 __asm("d2") = xDest;
  register long d3 __asm("d3") = yDest;
  register long d4 __asm("d4") = xSize;
  register long d5 __asm("d5") = ySize;
  register unsigned long d6 __asm("d6") = minterm;
  register PLANEPTR a2 __asm("a2") = bltMask;
  __asm __volatile ("jsr a6@(-0x27c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (a2)
  : "a0","a1","a2","d0","d1","d2","d3","d4","d5","d6", "memory");
}
extern __inline void 
BltPattern (BASE_PAR_DECL struct RastPort *rp,PLANEPTR mask,long xMin,long yMin,long xMax,long yMax,unsigned long maskBPR)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register PLANEPTR a0 __asm("a0") = mask;
  register long d0 __asm("d0") = xMin;
  register long d1 __asm("d1") = yMin;
  register long d2 __asm("d2") = xMax;
  register long d3 __asm("d3") = yMax;
  register unsigned long d4 __asm("d4") = maskBPR;
  __asm __volatile ("jsr a6@(-0x138)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4", "memory");
}
extern __inline void 
BltTemplate (BASE_PAR_DECL PLANEPTR source,long xSrc,long srcMod,struct RastPort *destRP,long xDest,long yDest,long xSize,long ySize)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register PLANEPTR a0 __asm("a0") = source;
  register long d0 __asm("d0") = xSrc;
  register long d1 __asm("d1") = srcMod;
  register struct RastPort *a1 __asm("a1") = destRP;
  register long d2 __asm("d2") = xDest;
  register long d3 __asm("d3") = yDest;
  register long d4 __asm("d4") = xSize;
  register long d5 __asm("d5") = ySize;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5", "memory");
}
extern __inline void 
CBump (BASE_PAR_DECL struct UCopList *copList)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct UCopList *a1 __asm("a1") = copList;
  __asm __volatile ("jsr a6@(-0x16e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CMove (BASE_PAR_DECL struct UCopList *copList,APTR destination,long data)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct UCopList *a1 __asm("a1") = copList;
  register APTR d0 __asm("d0") = destination;
  register long d1 __asm("d1") = data;
  __asm __volatile ("jsr a6@(-0x174)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CWait (BASE_PAR_DECL struct UCopList *copList,long v,long h)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct UCopList *a1 __asm("a1") = copList;
  register long d0 __asm("d0") = v;
  register long d1 __asm("d1") = h;
  __asm __volatile ("jsr a6@(-0x17a)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UWORD 
CalcIVG (BASE_PAR_DECL struct View *v,struct ViewPort *vp)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct View *a0 __asm("a0") = v;
  register struct ViewPort *a1 __asm("a1") = vp;
  __asm __volatile ("jsr a6@(-0x33c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
ChangeExtSpriteA (BASE_PAR_DECL struct ViewPort *vp,struct ExtSprite *oldsprite,struct ExtSprite *newsprite,struct TagItem *tags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register struct ExtSprite *a1 __asm("a1") = oldsprite;
  register struct ExtSprite *a2 __asm("a2") = newsprite;
  register struct TagItem *a3 __asm("a3") = tags;
  __asm __volatile ("jsr a6@(-0x402)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ChangeExtSprite(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; ChangeExtSpriteA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
ChangeSprite (BASE_PAR_DECL struct ViewPort *vp,struct SimpleSprite *sprite,PLANEPTR newData)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register struct SimpleSprite *a1 __asm("a1") = sprite;
  register PLANEPTR a2 __asm("a2") = newData;
  __asm __volatile ("jsr a6@(-0x1a4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
ChangeVPBitMap (BASE_PAR_DECL struct ViewPort *vp,struct BitMap *bm,struct DBufInfo *db)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register struct BitMap *a1 __asm("a1") = bm;
  register struct DBufInfo *a2 __asm("a2") = db;
  __asm __volatile ("jsr a6@(-0x3ae)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
ClearEOL (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
ClearRectRegion (BASE_PAR_DECL struct Region *region,struct Rectangle *rectangle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  register struct Rectangle *a1 __asm("a1") = rectangle;
  __asm __volatile ("jsr a6@(-0x20a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ClearRegion (BASE_PAR_DECL struct Region *region)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  __asm __volatile ("jsr a6@(-0x210)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ClearScreen (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ClipBlit (BASE_PAR_DECL struct RastPort *srcRP,long xSrc,long ySrc,struct RastPort *destRP,long xDest,long yDest,long xSize,long ySize,unsigned long minterm)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = srcRP;
  register long d0 __asm("d0") = xSrc;
  register long d1 __asm("d1") = ySrc;
  register struct RastPort *a1 __asm("a1") = destRP;
  register long d2 __asm("d2") = xDest;
  register long d3 __asm("d3") = yDest;
  register long d4 __asm("d4") = xSize;
  register long d5 __asm("d5") = ySize;
  register unsigned long d6 __asm("d6") = minterm;
  __asm __volatile ("jsr a6@(-0x228)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6)
  : "a0","a1","d0","d1","d2","d3","d4","d5","d6", "memory");
}
extern __inline void 
CloseFont (BASE_PAR_DECL struct TextFont *textFont)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a1 __asm("a1") = textFont;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
CloseMonitor (BASE_PAR_DECL struct MonitorSpec *monitorSpec)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct MonitorSpec *a0 __asm("a0") = monitorSpec;
  __asm __volatile ("jsr a6@(-0x2d0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CoerceMode (BASE_PAR_DECL struct ViewPort *vp,unsigned long monitorid,unsigned long flags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register unsigned long d0 __asm("d0") = monitorid;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x3a8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CopySBitMap (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  __asm __volatile ("jsr a6@(-0x1c2)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DisownBlitter (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1ce)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DisposeRegion (BASE_PAR_DECL struct Region *region)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  __asm __volatile ("jsr a6@(-0x216)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DoCollision (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Draw (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DrawEllipse (BASE_PAR_DECL struct RastPort *rp,long xCenter,long yCenter,long a,long b)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = xCenter;
  register long d1 __asm("d1") = yCenter;
  register long d2 __asm("d2") = a;
  register long d3 __asm("d3") = b;
  __asm __volatile ("jsr a6@(-0xb4)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
DrawGList (BASE_PAR_DECL struct RastPort *rp,struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
EraseRect (BASE_PAR_DECL struct RastPort *rp,long xMin,long yMin,long xMax,long yMax)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = xMin;
  register long d1 __asm("d1") = yMin;
  register long d2 __asm("d2") = xMax;
  register long d3 __asm("d3") = yMax;
  __asm __volatile ("jsr a6@(-0x32a)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline ULONG 
ExtendFont (BASE_PAR_DECL struct TextFont *font,struct TagItem *fontTags)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a0 __asm("a0") = font;
  register struct TagItem *a1 __asm("a1") = fontTags;
  __asm __volatile ("jsr a6@(-0x330)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ExtendFontTags(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; ExtendFont ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline LONG 
FindColor (BASE_PAR_DECL struct ColorMap *cm,unsigned long r,unsigned long g,unsigned long b,long maxcolor)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a3 __asm("a3") = cm;
  register unsigned long d1 __asm("d1") = r;
  register unsigned long d2 __asm("d2") = g;
  register unsigned long d3 __asm("d3") = b;
  register long d4 __asm("d4") = maxcolor;
  __asm __volatile ("jsr a6@(-0x3f0)"
  : "=r" (_res)
  : "r" (a6), "r" (a3), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","a3","d0","d1","d2","d3","d4", "memory");
  return _res;
}
extern __inline DisplayInfoHandle 
FindDisplayInfo (BASE_PAR_DECL unsigned long displayID)
{
  BASE_EXT_DECL
  register DisplayInfoHandle  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = displayID;
  __asm __volatile ("jsr a6@(-0x2d6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
Flood (BASE_PAR_DECL struct RastPort *rp,unsigned long mode,long x,long y)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d2 __asm("d2") = mode;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x14a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d2), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline void 
FontExtent (BASE_PAR_DECL struct TextFont *font,struct TextExtent *fontExtent)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a0 __asm("a0") = font;
  register struct TextExtent *a1 __asm("a1") = fontExtent;
  __asm __volatile ("jsr a6@(-0x2fa)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeBitMap (BASE_PAR_DECL struct BitMap *bm)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = bm;
  __asm __volatile ("jsr a6@(-0x39c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeColorMap (BASE_PAR_DECL struct ColorMap *colorMap)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = colorMap;
  __asm __volatile ("jsr a6@(-0x240)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeCopList (BASE_PAR_DECL struct CopList *copList)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct CopList *a0 __asm("a0") = copList;
  __asm __volatile ("jsr a6@(-0x222)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeCprList (BASE_PAR_DECL struct cprlist *cprList)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct cprlist *a0 __asm("a0") = cprList;
  __asm __volatile ("jsr a6@(-0x234)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeDBufInfo (BASE_PAR_DECL struct DBufInfo *dbi)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct DBufInfo *a1 __asm("a1") = dbi;
  __asm __volatile ("jsr a6@(-0x3cc)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeGBuffers (BASE_PAR_DECL struct AnimOb *anOb,struct RastPort *rp,long flag)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AnimOb *a0 __asm("a0") = anOb;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = flag;
  __asm __volatile ("jsr a6@(-0x258)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeRaster (BASE_PAR_DECL PLANEPTR p,unsigned long width,unsigned long height)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register PLANEPTR a0 __asm("a0") = p;
  register unsigned long d0 __asm("d0") = width;
  register unsigned long d1 __asm("d1") = height;
  __asm __volatile ("jsr a6@(-0x1f2)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeSprite (BASE_PAR_DECL long num)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = num;
  __asm __volatile ("jsr a6@(-0x19e)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeSpriteData (BASE_PAR_DECL struct ExtSprite *sp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ExtSprite *a2 __asm("a2") = sp;
  __asm __volatile ("jsr a6@(-0x408)"
  : /* no output */
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
FreeVPortCopLists (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x21c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GetAPen (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  __asm __volatile ("jsr a6@(-0x35a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetBPen (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  __asm __volatile ("jsr a6@(-0x360)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetBitMapAttr (BASE_PAR_DECL struct BitMap *bm,unsigned long attrnum)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = bm;
  register unsigned long d1 __asm("d1") = attrnum;
  __asm __volatile ("jsr a6@(-0x3c0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct ColorMap *
GetColorMap (BASE_PAR_DECL long entries)
{
  BASE_EXT_DECL
  register struct ColorMap * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = entries;
  __asm __volatile ("jsr a6@(-0x23a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetDisplayInfoData (BASE_PAR_DECL DisplayInfoHandle handle,UBYTE *buf,unsigned long size,unsigned long tagID,unsigned long displayID)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register DisplayInfoHandle a0 __asm("a0") = handle;
  register UBYTE *a1 __asm("a1") = buf;
  register unsigned long d0 __asm("d0") = size;
  register unsigned long d1 __asm("d1") = tagID;
  register unsigned long d2 __asm("d2") = displayID;
  __asm __volatile ("jsr a6@(-0x2f4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline ULONG 
GetDrMd (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  __asm __volatile ("jsr a6@(-0x366)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
GetExtSpriteA (BASE_PAR_DECL struct ExtSprite *ss,struct TagItem *tags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ExtSprite *a2 __asm("a2") = ss;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x3a2)"
  : "=r" (_res)
  : "r" (a6), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GetExtSprite(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GetExtSpriteA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline BOOL 
GetGBuffers (BASE_PAR_DECL struct AnimOb *anOb,struct RastPort *rp,long flag)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AnimOb *a0 __asm("a0") = anOb;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = flag;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetOutlinePen (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  __asm __volatile ("jsr a6@(-0x36c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GetRGB32 (BASE_PAR_DECL struct ColorMap *cm,unsigned long firstcolor,unsigned long ncolors,ULONG *table)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register unsigned long d0 __asm("d0") = firstcolor;
  register unsigned long d1 __asm("d1") = ncolors;
  register ULONG *a1 __asm("a1") = table;
  __asm __volatile ("jsr a6@(-0x384)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GetRGB4 (BASE_PAR_DECL struct ColorMap *colorMap,long entry)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = colorMap;
  register long d0 __asm("d0") = entry;
  __asm __volatile ("jsr a6@(-0x246)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GetRPAttrsA (BASE_PAR_DECL struct RastPort *rp,struct TagItem *tags)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x414)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
#ifndef NO_INLINE_STDARG
#define GetRPAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GetRPAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline WORD 
GetSprite (BASE_PAR_DECL struct SimpleSprite *sprite,long num)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct SimpleSprite *a0 __asm("a0") = sprite;
  register long d0 __asm("d0") = num;
  __asm __volatile ("jsr a6@(-0x198)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
GetVPModeID (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x318)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
GfxAssociate (BASE_PAR_DECL APTR associateNode,APTR gfxNodePtr)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = associateNode;
  register APTR a1 __asm("a1") = gfxNodePtr;
  __asm __volatile ("jsr a6@(-0x2a0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
GfxFree (BASE_PAR_DECL APTR gfxNodePtr)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = gfxNodePtr;
  __asm __volatile ("jsr a6@(-0x29a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
GfxLookUp (BASE_PAR_DECL APTR associateNode)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = associateNode;
  __asm __volatile ("jsr a6@(-0x2be)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
GfxNew (BASE_PAR_DECL unsigned long gfxNodeType)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = gfxNodeType;
  __asm __volatile ("jsr a6@(-0x294)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
InitArea (BASE_PAR_DECL struct AreaInfo *areaInfo,APTR vectorBuffer,long maxVectors)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AreaInfo *a0 __asm("a0") = areaInfo;
  register APTR a1 __asm("a1") = vectorBuffer;
  register long d0 __asm("d0") = maxVectors;
  __asm __volatile ("jsr a6@(-0x11a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitBitMap (BASE_PAR_DECL struct BitMap *bitMap,long depth,long width,long height)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct BitMap *a0 __asm("a0") = bitMap;
  register long d0 __asm("d0") = depth;
  register long d1 __asm("d1") = width;
  register long d2 __asm("d2") = height;
  __asm __volatile ("jsr a6@(-0x186)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
}
extern __inline void 
InitGMasks (BASE_PAR_DECL struct AnimOb *anOb)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct AnimOb *a0 __asm("a0") = anOb;
  __asm __volatile ("jsr a6@(-0xae)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitGels (BASE_PAR_DECL struct VSprite *head,struct VSprite *tail,struct GelsInfo *gelsInfo)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct VSprite *a0 __asm("a0") = head;
  register struct VSprite *a1 __asm("a1") = tail;
  register struct GelsInfo *a2 __asm("a2") = gelsInfo;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
InitMasks (BASE_PAR_DECL struct VSprite *vSprite)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct VSprite *a0 __asm("a0") = vSprite;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitRastPort (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0xc6)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct TmpRas *
InitTmpRas (BASE_PAR_DECL struct TmpRas *tmpRas,PLANEPTR buffer,long size)
{
  BASE_EXT_DECL
  register struct TmpRas * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TmpRas *a0 __asm("a0") = tmpRas;
  register PLANEPTR a1 __asm("a1") = buffer;
  register long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x1d4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
InitVPort (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0xcc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitView (BASE_PAR_DECL struct View *view)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct View *a1 __asm("a1") = view;
  __asm __volatile ("jsr a6@(-0x168)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
LoadRGB32 (BASE_PAR_DECL struct ViewPort *vp,ULONG *table)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register ULONG *a1 __asm("a1") = table;
  __asm __volatile ("jsr a6@(-0x372)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
LoadRGB4 (BASE_PAR_DECL struct ViewPort *vp,UWORD *colors,long count)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register UWORD *a1 __asm("a1") = colors;
  register long d0 __asm("d0") = count;
  __asm __volatile ("jsr a6@(-0xc0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
LoadView (BASE_PAR_DECL struct View *view)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct View *a1 __asm("a1") = view;
  __asm __volatile ("jsr a6@(-0xde)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
LockLayerRom (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Layer *a2 __asm("a2") = layer;
  __asm __volatile ("exg a2,a5\n\tjsr a6@(-0x1b0)\n\texg a2,a5"
  : /* no output */
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline ULONG 
MakeVPort (BASE_PAR_DECL struct View *view,struct ViewPort *vp)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct View *a0 __asm("a0") = view;
  register struct ViewPort *a1 __asm("a1") = vp;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
ModeNotAvailable (BASE_PAR_DECL unsigned long modeID)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = modeID;
  __asm __volatile ("jsr a6@(-0x31e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Move (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0xf0)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
MoveSprite (BASE_PAR_DECL struct ViewPort *vp,struct SimpleSprite *sprite,long x,long y)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register struct SimpleSprite *a1 __asm("a1") = sprite;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x1aa)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
MrgCop (BASE_PAR_DECL struct View *view)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct View *a1 __asm("a1") = view;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Region *
NewRegion (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct Region * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x204)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
NextDisplayInfo (BASE_PAR_DECL unsigned long displayID)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = displayID;
  __asm __volatile ("jsr a6@(-0x2dc)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
ObtainBestPenA (BASE_PAR_DECL struct ColorMap *cm,unsigned long r,unsigned long g,unsigned long b,struct TagItem *tags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register unsigned long d1 __asm("d1") = r;
  register unsigned long d2 __asm("d2") = g;
  register unsigned long d3 __asm("d3") = b;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x348)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d1), "r" (d2), "r" (d3), "r" (a1)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ObtainBestPen(a0, a1, a2, a3, tags...) \
  ({ struct TagItem _tags[] = { tags }; ObtainBestPenA ((a0), (a1), (a2), (a3), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
ObtainPen (BASE_PAR_DECL struct ColorMap *cm,unsigned long n,unsigned long r,unsigned long g,unsigned long b,long f)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register unsigned long d0 __asm("d0") = n;
  register unsigned long d1 __asm("d1") = r;
  register unsigned long d2 __asm("d2") = g;
  register unsigned long d3 __asm("d3") = b;
  register long d4 __asm("d4") = f;
  __asm __volatile ("jsr a6@(-0x3ba)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
  : "a0","a1","d0","d1","d2","d3","d4", "memory");
  return _res;
}
extern __inline struct TextFont *
OpenFont (BASE_PAR_DECL struct TextAttr *textAttr)
{
  BASE_EXT_DECL
  register struct TextFont * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextAttr *a0 __asm("a0") = textAttr;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct MonitorSpec *
OpenMonitor (BASE_PAR_DECL STRPTR monitorName,unsigned long displayID)
{
  BASE_EXT_DECL
  register struct MonitorSpec * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a1 __asm("a1") = monitorName;
  register unsigned long d0 __asm("d0") = displayID;
  __asm __volatile ("jsr a6@(-0x2ca)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
OrRectRegion (BASE_PAR_DECL struct Region *region,struct Rectangle *rectangle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  register struct Rectangle *a1 __asm("a1") = rectangle;
  __asm __volatile ("jsr a6@(-0x1fe)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
OrRegionRegion (BASE_PAR_DECL struct Region *srcRegion,struct Region *destRegion)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = srcRegion;
  register struct Region *a1 __asm("a1") = destRegion;
  __asm __volatile ("jsr a6@(-0x264)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
OwnBlitter (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1c8)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
PolyDraw (BASE_PAR_DECL struct RastPort *rp,long count,WORD *polyTable)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = count;
  register WORD *a0 __asm("a0") = polyTable;
  __asm __volatile ("jsr a6@(-0x150)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
QBSBlit (BASE_PAR_DECL struct bltnode *blit)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct bltnode *a1 __asm("a1") = blit;
  __asm __volatile ("jsr a6@(-0x126)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
QBlit (BASE_PAR_DECL struct bltnode *blit)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct bltnode *a1 __asm("a1") = blit;
  __asm __volatile ("jsr a6@(-0x114)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
ReadPixel (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x13e)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
ReadPixelArray8 (BASE_PAR_DECL struct RastPort *rp,unsigned long xstart,unsigned long ystart,unsigned long xstop,unsigned long ystop,UBYTE *array,struct RastPort *temprp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = xstart;
  register unsigned long d1 __asm("d1") = ystart;
  register unsigned long d2 __asm("d2") = xstop;
  register unsigned long d3 __asm("d3") = ystop;
  register UBYTE *a2 __asm("a2") = array;
  register struct RastPort *a1 __asm("a1") = temprp;
  __asm __volatile ("jsr a6@(-0x30c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline LONG 
ReadPixelLine8 (BASE_PAR_DECL struct RastPort *rp,unsigned long xstart,unsigned long ystart,unsigned long width,UBYTE *array,struct RastPort *tempRP)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = xstart;
  register unsigned long d1 __asm("d1") = ystart;
  register unsigned long d2 __asm("d2") = width;
  register UBYTE *a2 __asm("a2") = array;
  register struct RastPort *a1 __asm("a1") = tempRP;
  __asm __volatile ("jsr a6@(-0x300)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1","d2", "memory");
  return _res;
}
extern __inline void 
RectFill (BASE_PAR_DECL struct RastPort *rp,long xMin,long yMin,long xMax,long yMax)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = xMin;
  register long d1 __asm("d1") = yMin;
  register long d2 __asm("d2") = xMax;
  register long d3 __asm("d3") = yMax;
  __asm __volatile ("jsr a6@(-0x132)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
ReleasePen (BASE_PAR_DECL struct ColorMap *cm,unsigned long n)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register unsigned long d0 __asm("d0") = n;
  __asm __volatile ("jsr a6@(-0x3b4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemFont (BASE_PAR_DECL struct TextFont *textFont)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a1 __asm("a1") = textFont;
  __asm __volatile ("jsr a6@(-0x1e6)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemIBob (BASE_PAR_DECL struct Bob *bob,struct RastPort *rp,struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Bob *a0 __asm("a0") = bob;
  register struct RastPort *a1 __asm("a1") = rp;
  register struct ViewPort *a2 __asm("a2") = vp;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
RemVSprite (BASE_PAR_DECL struct VSprite *vSprite)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct VSprite *a0 __asm("a0") = vSprite;
  __asm __volatile ("jsr a6@(-0x8a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UWORD 
ScalerDiv (BASE_PAR_DECL unsigned long factor,unsigned long numerator,unsigned long denominator)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = factor;
  register unsigned long d1 __asm("d1") = numerator;
  register unsigned long d2 __asm("d2") = denominator;
  __asm __volatile ("jsr a6@(-0x2ac)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline void 
ScrollRaster (BASE_PAR_DECL struct RastPort *rp,long dx,long dy,long xMin,long yMin,long xMax,long yMax)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  register long d2 __asm("d2") = xMin;
  register long d3 __asm("d3") = yMin;
  register long d4 __asm("d4") = xMax;
  register long d5 __asm("d5") = yMax;
  __asm __volatile ("jsr a6@(-0x18c)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5", "memory");
}
extern __inline void 
ScrollRasterBF (BASE_PAR_DECL struct RastPort *rp,long dx,long dy,long xMin,long yMin,long xMax,long yMax)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = dx;
  register long d1 __asm("d1") = dy;
  register long d2 __asm("d2") = xMin;
  register long d3 __asm("d3") = yMin;
  register long d4 __asm("d4") = xMax;
  register long d5 __asm("d5") = yMax;
  __asm __volatile ("jsr a6@(-0x3ea)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
  : "a0","a1","d0","d1","d2","d3","d4","d5", "memory");
}
extern __inline void 
ScrollVPort (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x24c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetABPenDrMd (BASE_PAR_DECL struct RastPort *rp,unsigned long apen,unsigned long bpen,unsigned long drawmode)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = apen;
  register unsigned long d1 __asm("d1") = bpen;
  register unsigned long d2 __asm("d2") = drawmode;
  __asm __volatile ("jsr a6@(-0x37e)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
}
extern __inline void 
SetAPen (BASE_PAR_DECL struct RastPort *rp,unsigned long pen)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = pen;
  __asm __volatile ("jsr a6@(-0x156)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetBPen (BASE_PAR_DECL struct RastPort *rp,unsigned long pen)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = pen;
  __asm __volatile ("jsr a6@(-0x15c)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SetChipRev (BASE_PAR_DECL unsigned long want)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = want;
  __asm __volatile ("jsr a6@(-0x378)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetCollision (BASE_PAR_DECL unsigned long num,void (*routine)(struct VSprite *vSprite, APTR),struct GelsInfo *gelsInfo)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = num;
  register void (*a0)(struct VSprite *, APTR) __asm("a0") = routine;
  register struct GelsInfo *a1 __asm("a1") = gelsInfo;
  __asm __volatile ("jsr a6@(-0x90)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetDrMd (BASE_PAR_DECL struct RastPort *rp,unsigned long drawMode)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = drawMode;
  __asm __volatile ("jsr a6@(-0x162)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
SetFont (BASE_PAR_DECL struct RastPort *rp,struct TextFont *textFont)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register struct TextFont *a0 __asm("a0") = textFont;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetMaxPen (BASE_PAR_DECL struct RastPort *rp,unsigned long maxpen)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = maxpen;
  __asm __volatile ("jsr a6@(-0x3de)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SetOutlinePen (BASE_PAR_DECL struct RastPort *rp,unsigned long pen)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = pen;
  __asm __volatile ("jsr a6@(-0x3d2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetRGB32 (BASE_PAR_DECL struct ViewPort *vp,unsigned long n,unsigned long r,unsigned long g,unsigned long b)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register unsigned long d0 __asm("d0") = n;
  register unsigned long d1 __asm("d1") = r;
  register unsigned long d2 __asm("d2") = g;
  register unsigned long d3 __asm("d3") = b;
  __asm __volatile ("jsr a6@(-0x354)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
SetRGB32CM (BASE_PAR_DECL struct ColorMap *cm,unsigned long n,unsigned long r,unsigned long g,unsigned long b)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = cm;
  register unsigned long d0 __asm("d0") = n;
  register unsigned long d1 __asm("d1") = r;
  register unsigned long d2 __asm("d2") = g;
  register unsigned long d3 __asm("d3") = b;
  __asm __volatile ("jsr a6@(-0x3e4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
SetRGB4 (BASE_PAR_DECL struct ViewPort *vp,long index,unsigned long red,unsigned long green,unsigned long blue)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  register long d0 __asm("d0") = index;
  register unsigned long d1 __asm("d1") = red;
  register unsigned long d2 __asm("d2") = green;
  register unsigned long d3 __asm("d3") = blue;
  __asm __volatile ("jsr a6@(-0x120)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
SetRGB4CM (BASE_PAR_DECL struct ColorMap *colorMap,long index,unsigned long red,unsigned long green,unsigned long blue)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = colorMap;
  register long d0 __asm("d0") = index;
  register unsigned long d1 __asm("d1") = red;
  register unsigned long d2 __asm("d2") = green;
  register unsigned long d3 __asm("d3") = blue;
  __asm __volatile ("jsr a6@(-0x276)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3", "memory");
}
extern __inline void 
SetRPAttrsA (BASE_PAR_DECL struct RastPort *rp,struct TagItem *tags)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x40e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
#ifndef NO_INLINE_STDARG
#define SetRPAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetRPAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
SetRast (BASE_PAR_DECL struct RastPort *rp,unsigned long pen)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = pen;
  __asm __volatile ("jsr a6@(-0xea)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SetSoftStyle (BASE_PAR_DECL struct RastPort *rp,unsigned long style,unsigned long enable)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register unsigned long d0 __asm("d0") = style;
  register unsigned long d1 __asm("d1") = enable;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
SetWriteMask (BASE_PAR_DECL struct RastPort *rp,unsigned long msk)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = msk;
  __asm __volatile ("jsr a6@(-0x3d8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SortGList (BASE_PAR_DECL struct RastPort *rp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  __asm __volatile ("jsr a6@(-0x96)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
StripFont (BASE_PAR_DECL struct TextFont *font)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a0 __asm("a0") = font;
  __asm __volatile ("jsr a6@(-0x336)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SyncSBitMap (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Layer *a0 __asm("a0") = layer;
  __asm __volatile ("jsr a6@(-0x1bc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
Text (BASE_PAR_DECL struct RastPort *rp,STRPTR string,unsigned long count)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register STRPTR a0 __asm("a0") = string;
  register unsigned long d0 __asm("d0") = count;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline WORD 
TextExtent (BASE_PAR_DECL struct RastPort *rp,STRPTR string,long count,struct TextExtent *textExtent)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register STRPTR a0 __asm("a0") = string;
  register long d0 __asm("d0") = count;
  register struct TextExtent *a2 __asm("a2") = textExtent;
  __asm __volatile ("jsr a6@(-0x2b2)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
TextFit (BASE_PAR_DECL struct RastPort *rp,STRPTR string,unsigned long strLen,struct TextExtent *textExtent,struct TextExtent *constrainingExtent,long strDirection,unsigned long constrainingBitWidth,unsigned long constrainingBitHeight)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register STRPTR a0 __asm("a0") = string;
  register unsigned long d0 __asm("d0") = strLen;
  register struct TextExtent *a2 __asm("a2") = textExtent;
  register struct TextExtent *a3 __asm("a3") = constrainingExtent;
  register long d1 __asm("d1") = strDirection;
  register unsigned long d2 __asm("d2") = constrainingBitWidth;
  register unsigned long d3 __asm("d3") = constrainingBitHeight;
  __asm __volatile ("jsr a6@(-0x2b8)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (a2), "r" (a3), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","a2","a3","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline WORD 
TextLength (BASE_PAR_DECL struct RastPort *rp,STRPTR string,unsigned long count)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register STRPTR a0 __asm("a0") = string;
  register unsigned long d0 __asm("d0") = count;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct CopList *
UCopperListInit (BASE_PAR_DECL struct UCopList *uCopList,long n)
{
  BASE_EXT_DECL
  register struct CopList * _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct UCopList *a0 __asm("a0") = uCopList;
  register long d0 __asm("d0") = n;
  __asm __volatile ("jsr a6@(-0x252)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
UnlockLayerRom (BASE_PAR_DECL struct Layer *layer)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Layer *a2 __asm("a2") = layer;
  __asm __volatile ("exg a2,a5\n\tjsr a6@(-0x1b6)\n\texg a2,a5"
  : /* no output */
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline LONG 
VBeamPos (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x180)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
VideoControl (BASE_PAR_DECL struct ColorMap *colorMap,struct TagItem *tagarray)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ColorMap *a0 __asm("a0") = colorMap;
  register struct TagItem *a1 __asm("a1") = tagarray;
  __asm __volatile ("jsr a6@(-0x2c4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define VideoControlTags(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; VideoControl ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
WaitBOVP (BASE_PAR_DECL struct ViewPort *vp)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct ViewPort *a0 __asm("a0") = vp;
  __asm __volatile ("jsr a6@(-0x192)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
WaitBlit (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xe4)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
WaitTOF (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x10e)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline WORD 
WeighTAMatch (BASE_PAR_DECL struct TextAttr *reqTextAttr,struct TextAttr *targetTextAttr,struct TagItem *targetTags)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct TextAttr *a0 __asm("a0") = reqTextAttr;
  register struct TextAttr *a1 __asm("a1") = targetTextAttr;
  register struct TagItem *a2 __asm("a2") = targetTags;
  __asm __volatile ("jsr a6@(-0x324)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define WeighTAMatchTags(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; WeighTAMatch ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
WriteChunkyPixels (BASE_PAR_DECL struct RastPort *rp,unsigned long xstart,unsigned long ystart,unsigned long xstop,unsigned long ystop,UBYTE *array,long bytesperrow)
{
  BASE_EXT_DECL
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = xstart;
  register unsigned long d1 __asm("d1") = ystart;
  register unsigned long d2 __asm("d2") = xstop;
  register unsigned long d3 __asm("d3") = ystop;
  register UBYTE *a2 __asm("a2") = array;
  register long d4 __asm("d4") = bytesperrow;
  __asm __volatile ("jsr a6@(-0x420)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (d4)
  : "a0","a1","a2","d0","d1","d2","d3","d4", "memory");
}
extern __inline LONG 
WritePixel (BASE_PAR_DECL struct RastPort *rp,long x,long y)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a1 __asm("a1") = rp;
  register long d0 __asm("d0") = x;
  register long d1 __asm("d1") = y;
  __asm __volatile ("jsr a6@(-0x144)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
WritePixelArray8 (BASE_PAR_DECL struct RastPort *rp,unsigned long xstart,unsigned long ystart,unsigned long xstop,unsigned long ystop,UBYTE *array,struct RastPort *temprp)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = xstart;
  register unsigned long d1 __asm("d1") = ystart;
  register unsigned long d2 __asm("d2") = xstop;
  register unsigned long d3 __asm("d3") = ystop;
  register UBYTE *a2 __asm("a2") = array;
  register struct RastPort *a1 __asm("a1") = temprp;
  __asm __volatile ("jsr a6@(-0x312)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline LONG 
WritePixelLine8 (BASE_PAR_DECL struct RastPort *rp,unsigned long xstart,unsigned long ystart,unsigned long width,UBYTE *array,struct RastPort *tempRP)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct RastPort *a0 __asm("a0") = rp;
  register unsigned long d0 __asm("d0") = xstart;
  register unsigned long d1 __asm("d1") = ystart;
  register unsigned long d2 __asm("d2") = width;
  register UBYTE *a2 __asm("a2") = array;
  register struct RastPort *a1 __asm("a1") = tempRP;
  __asm __volatile ("jsr a6@(-0x306)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1","d2", "memory");
  return _res;
}
extern __inline BOOL 
XorRectRegion (BASE_PAR_DECL struct Region *region,struct Rectangle *rectangle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = region;
  register struct Rectangle *a1 __asm("a1") = rectangle;
  __asm __volatile ("jsr a6@(-0x22e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
XorRegionRegion (BASE_PAR_DECL struct Region *srcRegion,struct Region *destRegion)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct GfxBase *a6 __asm("a6") = BASE_NAME;
  register struct Region *a0 __asm("a0") = srcRegion;
  register struct Region *a1 __asm("a1") = destRegion;
  __asm __volatile ("jsr a6@(-0x26a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_GRAPHICS_H */
