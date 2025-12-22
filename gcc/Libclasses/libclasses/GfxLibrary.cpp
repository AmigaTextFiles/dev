
#ifndef _GFXLIBRARY_CPP
#define _GFXLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GfxLibrary.h>

GfxLibrary::GfxLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("graphics.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open graphics.library") );
	}
}

GfxLibrary::~GfxLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG GfxLibrary::BltBitMap(CONST struct BitMap * srcBitMap, LONG xSrc, LONG ySrc, struct BitMap * destBitMap, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm, ULONG mask, PLANEPTR tempA)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcBitMap;
	register int d0 __asm("d0") = xSrc;
	register int d1 __asm("d1") = ySrc;
	register void * a1 __asm("a1") = destBitMap;
	register int d2 __asm("d2") = xDest;
	register int d3 __asm("d3") = yDest;
	register int d4 __asm("d4") = xSize;
	register int d5 __asm("d5") = ySize;
	register unsigned int d6 __asm("d6") = minterm;
	register unsigned int d7 __asm("d7") = mask;
	register PLANEPTR a2 __asm("a2") = tempA;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (d7), "r" (a2)
	: "a0", "d0", "d1", "a1", "d2", "d3", "d4", "d5", "d6", "d7", "a2");
	return (LONG) _res;
}

VOID GfxLibrary::BltTemplate(CONST PLANEPTR source, LONG xSrc, LONG srcMod, struct RastPort * destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize)
{
	register void * a6 __asm("a6") = Base;
	register CONST PLANEPTR a0 __asm("a0") = source;
	register int d0 __asm("d0") = xSrc;
	register int d1 __asm("d1") = srcMod;
	register void * a1 __asm("a1") = destRP;
	register int d2 __asm("d2") = xDest;
	register int d3 __asm("d3") = yDest;
	register int d4 __asm("d4") = xSize;
	register int d5 __asm("d5") = ySize;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "a0", "d0", "d1", "a1", "d2", "d3", "d4", "d5");
}

VOID GfxLibrary::ClearEOL(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::ClearScreen(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

WORD GfxLibrary::TextLength(struct RastPort * rp, CONST_STRPTR string, ULONG count)
{
	register WORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register const char * a0 __asm("a0") = string;
	register unsigned int d0 __asm("d0") = count;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0)
	: "a1", "a0", "d0");
	return (WORD) _res;
}

LONG GfxLibrary::Text(struct RastPort * rp, CONST_STRPTR string, ULONG count)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register const char * a0 __asm("a0") = string;
	register unsigned int d0 __asm("d0") = count;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0)
	: "a1", "a0", "d0");
	return (LONG) _res;
}

LONG GfxLibrary::SetFont(struct RastPort * rp, CONST struct TextFont * textFont)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register const void * a0 __asm("a0") = textFont;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0)
	: "a1", "a0");
	return (LONG) _res;
}

struct TextFont * GfxLibrary::OpenFont(struct TextAttr * textAttr)
{
	register struct TextFont * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = textAttr;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct TextFont *) _res;
}

VOID GfxLibrary::CloseFont(struct TextFont * textFont)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = textFont;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

ULONG GfxLibrary::AskSoftStyle(struct RastPort * rp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (ULONG) _res;
}

ULONG GfxLibrary::SetSoftStyle(struct RastPort * rp, ULONG style, ULONG enable)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = style;
	register unsigned int d1 __asm("d1") = enable;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
	return (ULONG) _res;
}

VOID GfxLibrary::AddBob(struct Bob * bob, struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bob;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID GfxLibrary::AddVSprite(struct VSprite * vSprite, struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vSprite;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-102)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID GfxLibrary::DoCollision(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::DrawGList(struct RastPort * rp, struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a1), "r" (a0)
	: "a1", "a0");
}

VOID GfxLibrary::InitGels(struct VSprite * head, struct VSprite * tail, struct GelsInfo * gelsInfo)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = head;
	register void * a1 __asm("a1") = tail;
	register void * a2 __asm("a2") = gelsInfo;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID GfxLibrary::InitMasks(struct VSprite * vSprite)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vSprite;

	__asm volatile ("jsr a6@(-126)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::RemIBob(struct Bob * bob, struct RastPort * rp, struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bob;
	register void * a1 __asm("a1") = rp;
	register void * a2 __asm("a2") = vp;

	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID GfxLibrary::RemVSprite(struct VSprite * vSprite)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vSprite;

	__asm volatile ("jsr a6@(-138)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::SetCollision(ULONG num, VOID (*routine)(struct VSprite *gelA,struct VSprite *gelB), struct GelsInfo * gelsInfo)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = num;
	register void * a0 __asm("a0") = routine;
	register void * a1 __asm("a1") = gelsInfo;

	__asm volatile ("jsr a6@(-144)"
	: 
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
}

VOID GfxLibrary::SortGList(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-150)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::AddAnimOb(struct AnimOb * anOb, struct AnimOb ** anKey, struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = anOb;
	register void * a1 __asm("a1") = anKey;
	register void * a2 __asm("a2") = rp;

	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID GfxLibrary::Animate(struct AnimOb ** anKey, struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = anKey;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-162)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL GfxLibrary::GetGBuffers(struct AnimOb * anOb, struct RastPort * rp, LONG flag)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = anOb;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = flag;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (BOOL) _res;
}

VOID GfxLibrary::InitGMasks(struct AnimOb * anOb)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = anOb;

	__asm volatile ("jsr a6@(-174)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::DrawEllipse(struct RastPort * rp, LONG xCenter, LONG yCenter, LONG a, LONG b)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = xCenter;
	register int d1 __asm("d1") = yCenter;
	register int d2 __asm("d2") = a;
	register int d3 __asm("d3") = b;

	__asm volatile ("jsr a6@(-180)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a1", "d0", "d1", "d2", "d3");
}

LONG GfxLibrary::AreaEllipse(struct RastPort * rp, LONG xCenter, LONG yCenter, LONG a, LONG b)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = xCenter;
	register int d1 __asm("d1") = yCenter;
	register int d2 __asm("d2") = a;
	register int d3 __asm("d3") = b;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a1", "d0", "d1", "d2", "d3");
	return (LONG) _res;
}

VOID GfxLibrary::LoadRGB4(struct ViewPort * vp, CONST UWORD * colors, LONG count)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register const void * a1 __asm("a1") = colors;
	register int d0 __asm("d0") = count;

	__asm volatile ("jsr a6@(-192)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID GfxLibrary::InitRastPort(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-198)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::InitVPort(struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-204)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG GfxLibrary::MrgCop(struct View * view)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = view;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (ULONG) _res;
}

ULONG GfxLibrary::MakeVPort(struct View * view, struct ViewPort * vp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = view;
	register void * a1 __asm("a1") = vp;

	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

VOID GfxLibrary::LoadView(struct View * view)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = view;

	__asm volatile ("jsr a6@(-222)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::WaitBlit()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-228)"
	: 
	: "r" (a6)
	: "d0");
}

VOID GfxLibrary::SetRast(struct RastPort * rp, ULONG pen)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = pen;

	__asm volatile ("jsr a6@(-234)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

VOID GfxLibrary::Move(struct RastPort * rp, LONG x, LONG y)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-240)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

VOID GfxLibrary::Draw(struct RastPort * rp, LONG x, LONG y)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-246)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

LONG GfxLibrary::AreaMove(struct RastPort * rp, LONG x, LONG y)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-252)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
	return (LONG) _res;
}

LONG GfxLibrary::AreaDraw(struct RastPort * rp, LONG x, LONG y)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-258)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
	return (LONG) _res;
}

LONG GfxLibrary::AreaEnd(struct RastPort * rp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;

	__asm volatile ("jsr a6@(-264)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (LONG) _res;
}

VOID GfxLibrary::WaitTOF()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-270)"
	: 
	: "r" (a6)
	: "d0");
}

VOID GfxLibrary::QBlit(struct bltnode * blit)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = blit;

	__asm volatile ("jsr a6@(-276)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::InitArea(struct AreaInfo * areaInfo, APTR vectorBuffer, LONG maxVectors)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = areaInfo;
	register void * a1 __asm("a1") = vectorBuffer;
	register int d0 __asm("d0") = maxVectors;

	__asm volatile ("jsr a6@(-282)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID GfxLibrary::SetRGB4(struct ViewPort * vp, LONG index, ULONG red, ULONG green, ULONG blue)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register int d0 __asm("d0") = index;
	register unsigned int d1 __asm("d1") = red;
	register unsigned int d2 __asm("d2") = green;
	register unsigned int d3 __asm("d3") = blue;

	__asm volatile ("jsr a6@(-288)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
}

VOID GfxLibrary::QBSBlit(struct bltnode * blit)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = blit;

	__asm volatile ("jsr a6@(-294)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::BltClear(PLANEPTR memBlock, ULONG byteCount, ULONG flags)
{
	register void * a6 __asm("a6") = Base;
	register PLANEPTR a1 __asm("a1") = memBlock;
	register unsigned int d0 __asm("d0") = byteCount;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-300)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

VOID GfxLibrary::RectFill(struct RastPort * rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = xMin;
	register int d1 __asm("d1") = yMin;
	register int d2 __asm("d2") = xMax;
	register int d3 __asm("d3") = yMax;

	__asm volatile ("jsr a6@(-306)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a1", "d0", "d1", "d2", "d3");
}

VOID GfxLibrary::BltPattern(struct RastPort * rp, CONST PLANEPTR mask, LONG xMin, LONG yMin, LONG xMax, LONG yMax, ULONG maskBPR)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register CONST PLANEPTR a0 __asm("a0") = mask;
	register int d0 __asm("d0") = xMin;
	register int d1 __asm("d1") = yMin;
	register int d2 __asm("d2") = xMax;
	register int d3 __asm("d3") = yMax;
	register unsigned int d4 __asm("d4") = maskBPR;

	__asm volatile ("jsr a6@(-312)"
	: 
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "a1", "a0", "d0", "d1", "d2", "d3", "d4");
}

ULONG GfxLibrary::ReadPixel(struct RastPort * rp, LONG x, LONG y)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-318)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
	return (ULONG) _res;
}

LONG GfxLibrary::WritePixel(struct RastPort * rp, LONG x, LONG y)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-324)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
	return (LONG) _res;
}

BOOL GfxLibrary::Flood(struct RastPort * rp, ULONG mode, LONG x, LONG y)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d2 __asm("d2") = mode;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-330)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d2), "r" (d0), "r" (d1)
	: "a1", "d2", "d0", "d1");
	return (BOOL) _res;
}

VOID GfxLibrary::PolyDraw(struct RastPort * rp, LONG count, CONST WORD * polyTable)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = count;
	register const void * a0 __asm("a0") = polyTable;

	__asm volatile ("jsr a6@(-336)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (a0)
	: "a1", "d0", "a0");
}

VOID GfxLibrary::SetAPen(struct RastPort * rp, ULONG pen)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = pen;

	__asm volatile ("jsr a6@(-342)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

VOID GfxLibrary::SetBPen(struct RastPort * rp, ULONG pen)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = pen;

	__asm volatile ("jsr a6@(-348)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

VOID GfxLibrary::SetDrMd(struct RastPort * rp, ULONG drawMode)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = drawMode;

	__asm volatile ("jsr a6@(-354)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

VOID GfxLibrary::InitView(struct View * view)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = view;

	__asm volatile ("jsr a6@(-360)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::CBump(struct UCopList * copList)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = copList;

	__asm volatile ("jsr a6@(-366)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::CMove(struct UCopList * copList, APTR destination, LONG data)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = copList;
	register void * d0 __asm("d0") = destination;
	register int d1 __asm("d1") = data;

	__asm volatile ("jsr a6@(-372)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

VOID GfxLibrary::CWait(struct UCopList * copList, LONG v, LONG h)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = copList;
	register int d0 __asm("d0") = v;
	register int d1 __asm("d1") = h;

	__asm volatile ("jsr a6@(-378)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

LONG GfxLibrary::VBeamPos()
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-384)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (LONG) _res;
}

VOID GfxLibrary::InitBitMap(struct BitMap * bitMap, LONG depth, LONG width, LONG height)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bitMap;
	register int d0 __asm("d0") = depth;
	register int d1 __asm("d1") = width;
	register int d2 __asm("d2") = height;

	__asm volatile ("jsr a6@(-390)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
	: "a0", "d0", "d1", "d2");
}

VOID GfxLibrary::ScrollRaster(struct RastPort * rp, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;
	register int d2 __asm("d2") = xMin;
	register int d3 __asm("d3") = yMin;
	register int d4 __asm("d4") = xMax;
	register int d5 __asm("d5") = yMax;

	__asm volatile ("jsr a6@(-396)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "a1", "d0", "d1", "d2", "d3", "d4", "d5");
}

VOID GfxLibrary::WaitBOVP(struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-402)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

WORD GfxLibrary::GetSprite(struct SimpleSprite * sprite, LONG num)
{
	register WORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = sprite;
	register int d0 __asm("d0") = num;

	__asm volatile ("jsr a6@(-408)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (WORD) _res;
}

VOID GfxLibrary::FreeSprite(LONG num)
{
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = num;

	__asm volatile ("jsr a6@(-414)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID GfxLibrary::ChangeSprite(struct ViewPort * vp, struct SimpleSprite * sprite, UWORD * newData)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register void * a1 __asm("a1") = sprite;
	register void * a2 __asm("a2") = newData;

	__asm volatile ("jsr a6@(-420)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID GfxLibrary::MoveSprite(struct ViewPort * vp, struct SimpleSprite * sprite, LONG x, LONG y)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register void * a1 __asm("a1") = sprite;
	register int d0 __asm("d0") = x;
	register int d1 __asm("d1") = y;

	__asm volatile ("jsr a6@(-426)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

VOID GfxLibrary::LockLayerRom(struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register void * a5 __asm("a5") = layer;

	__asm volatile ("jsr a6@(-432)"
	: 
	: "r" (a6), "r" (a5)
	: "a5");
}

VOID GfxLibrary::UnlockLayerRom(struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register void * a5 __asm("a5") = layer;

	__asm volatile ("jsr a6@(-438)"
	: 
	: "r" (a6), "r" (a5)
	: "a5");
}

VOID GfxLibrary::SyncSBitMap(struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;

	__asm volatile ("jsr a6@(-444)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::CopySBitMap(struct Layer * layer)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = layer;

	__asm volatile ("jsr a6@(-450)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::OwnBlitter()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-456)"
	: 
	: "r" (a6)
	: "d0");
}

VOID GfxLibrary::DisownBlitter()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-462)"
	: 
	: "r" (a6)
	: "d0");
}

struct TmpRas * GfxLibrary::InitTmpRas(struct TmpRas * tmpRas, PLANEPTR buffer, LONG size)
{
	register struct TmpRas * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tmpRas;
	register PLANEPTR a1 __asm("a1") = buffer;
	register int d0 __asm("d0") = size;

	__asm volatile ("jsr a6@(-468)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (struct TmpRas *) _res;
}

VOID GfxLibrary::AskFont(struct RastPort * rp, struct TextAttr * textAttr)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register void * a0 __asm("a0") = textAttr;

	__asm volatile ("jsr a6@(-474)"
	: 
	: "r" (a6), "r" (a1), "r" (a0)
	: "a1", "a0");
}

VOID GfxLibrary::AddFont(struct TextFont * textFont)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = textFont;

	__asm volatile ("jsr a6@(-480)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GfxLibrary::RemFont(struct TextFont * textFont)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = textFont;

	__asm volatile ("jsr a6@(-486)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

PLANEPTR GfxLibrary::AllocRaster(ULONG width, ULONG height)
{
	register PLANEPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = width;
	register unsigned int d1 __asm("d1") = height;

	__asm volatile ("jsr a6@(-492)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (PLANEPTR) _res;
}

VOID GfxLibrary::FreeRaster(PLANEPTR p, ULONG width, ULONG height)
{
	register void * a6 __asm("a6") = Base;
	register PLANEPTR a0 __asm("a0") = p;
	register unsigned int d0 __asm("d0") = width;
	register unsigned int d1 __asm("d1") = height;

	__asm volatile ("jsr a6@(-498)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

VOID GfxLibrary::AndRectRegion(struct Region * region, CONST struct Rectangle * rectangle)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;
	register const void * a1 __asm("a1") = rectangle;

	__asm volatile ("jsr a6@(-504)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL GfxLibrary::OrRectRegion(struct Region * region, CONST struct Rectangle * rectangle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;
	register const void * a1 __asm("a1") = rectangle;

	__asm volatile ("jsr a6@(-510)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

struct Region * GfxLibrary::NewRegion()
{
	register struct Region * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-516)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct Region *) _res;
}

BOOL GfxLibrary::ClearRectRegion(struct Region * region, CONST struct Rectangle * rectangle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;
	register const void * a1 __asm("a1") = rectangle;

	__asm volatile ("jsr a6@(-522)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID GfxLibrary::ClearRegion(struct Region * region)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;

	__asm volatile ("jsr a6@(-528)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::DisposeRegion(struct Region * region)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;

	__asm volatile ("jsr a6@(-534)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::FreeVPortCopLists(struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-540)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::FreeCopList(struct CopList * copList)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = copList;

	__asm volatile ("jsr a6@(-546)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::ClipBlit(struct RastPort * srcRP, LONG xSrc, LONG ySrc, struct RastPort * destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = srcRP;
	register int d0 __asm("d0") = xSrc;
	register int d1 __asm("d1") = ySrc;
	register void * a1 __asm("a1") = destRP;
	register int d2 __asm("d2") = xDest;
	register int d3 __asm("d3") = yDest;
	register int d4 __asm("d4") = xSize;
	register int d5 __asm("d5") = ySize;
	register unsigned int d6 __asm("d6") = minterm;

	__asm volatile ("jsr a6@(-552)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6)
	: "a0", "d0", "d1", "a1", "d2", "d3", "d4", "d5", "d6");
}

BOOL GfxLibrary::XorRectRegion(struct Region * region, CONST struct Rectangle * rectangle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = region;
	register const void * a1 __asm("a1") = rectangle;

	__asm volatile ("jsr a6@(-558)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID GfxLibrary::FreeCprList(struct cprlist * cprList)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cprList;

	__asm volatile ("jsr a6@(-564)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct ColorMap * GfxLibrary::GetColorMap(LONG entries)
{
	register struct ColorMap * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = entries;

	__asm volatile ("jsr a6@(-570)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (struct ColorMap *) _res;
}

VOID GfxLibrary::FreeColorMap(struct ColorMap * colorMap)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = colorMap;

	__asm volatile ("jsr a6@(-576)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG GfxLibrary::GetRGB4(struct ColorMap * colorMap, LONG entry)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = colorMap;
	register int d0 __asm("d0") = entry;

	__asm volatile ("jsr a6@(-582)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

VOID GfxLibrary::ScrollVPort(struct ViewPort * vp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-588)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct CopList * GfxLibrary::UCopperListInit(struct UCopList * uCopList, LONG n)
{
	register struct CopList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = uCopList;
	register int d0 __asm("d0") = n;

	__asm volatile ("jsr a6@(-594)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (struct CopList *) _res;
}

VOID GfxLibrary::FreeGBuffers(struct AnimOb * anOb, struct RastPort * rp, LONG flag)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = anOb;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = flag;

	__asm volatile ("jsr a6@(-600)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
}

VOID GfxLibrary::BltBitMapRastPort(CONST struct BitMap * srcBitMap, LONG xSrc, LONG ySrc, struct RastPort * destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcBitMap;
	register int d0 __asm("d0") = xSrc;
	register int d1 __asm("d1") = ySrc;
	register void * a1 __asm("a1") = destRP;
	register int d2 __asm("d2") = xDest;
	register int d3 __asm("d3") = yDest;
	register int d4 __asm("d4") = xSize;
	register int d5 __asm("d5") = ySize;
	register unsigned int d6 __asm("d6") = minterm;

	__asm volatile ("jsr a6@(-606)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6)
	: "a0", "d0", "d1", "a1", "d2", "d3", "d4", "d5", "d6");
}

BOOL GfxLibrary::OrRegionRegion(CONST struct Region * srcRegion, struct Region * destRegion)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcRegion;
	register void * a1 __asm("a1") = destRegion;

	__asm volatile ("jsr a6@(-612)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL GfxLibrary::XorRegionRegion(CONST struct Region * srcRegion, struct Region * destRegion)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcRegion;
	register void * a1 __asm("a1") = destRegion;

	__asm volatile ("jsr a6@(-618)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL GfxLibrary::AndRegionRegion(CONST struct Region * srcRegion, struct Region * destRegion)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcRegion;
	register void * a1 __asm("a1") = destRegion;

	__asm volatile ("jsr a6@(-624)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID GfxLibrary::SetRGB4CM(struct ColorMap * colorMap, LONG index, ULONG red, ULONG green, ULONG blue)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = colorMap;
	register int d0 __asm("d0") = index;
	register unsigned int d1 __asm("d1") = red;
	register unsigned int d2 __asm("d2") = green;
	register unsigned int d3 __asm("d3") = blue;

	__asm volatile ("jsr a6@(-630)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
}

VOID GfxLibrary::BltMaskBitMapRastPort(CONST struct BitMap * srcBitMap, LONG xSrc, LONG ySrc, struct RastPort * destRP, LONG xDest, LONG yDest, LONG xSize, LONG ySize, ULONG minterm, CONST PLANEPTR bltMask)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = srcBitMap;
	register int d0 __asm("d0") = xSrc;
	register int d1 __asm("d1") = ySrc;
	register void * a1 __asm("a1") = destRP;
	register int d2 __asm("d2") = xDest;
	register int d3 __asm("d3") = yDest;
	register int d4 __asm("d4") = xSize;
	register int d5 __asm("d5") = ySize;
	register unsigned int d6 __asm("d6") = minterm;
	register CONST PLANEPTR a2 __asm("a2") = bltMask;

	__asm volatile ("jsr a6@(-636)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1), "r" (d2), "r" (d3), "r" (d4), "r" (d5), "r" (d6), "r" (a2)
	: "a0", "d0", "d1", "a1", "d2", "d3", "d4", "d5", "d6", "a2");
}

BOOL GfxLibrary::AttemptLockLayerRom(struct Layer * layer)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a5 __asm("a5") = layer;

	__asm volatile ("jsr a6@(-654)"
	: "=r" (_res)
	: "r" (a6), "r" (a5)
	: "a5");
	return (BOOL) _res;
}

APTR GfxLibrary::GfxNew(ULONG gfxNodeType)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = gfxNodeType;

	__asm volatile ("jsr a6@(-660)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (APTR) _res;
}

VOID GfxLibrary::GfxFree(APTR gfxNodePtr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gfxNodePtr;

	__asm volatile ("jsr a6@(-666)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GfxLibrary::GfxAssociate(CONST APTR associateNode, APTR gfxNodePtr)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = associateNode;
	register void * a1 __asm("a1") = gfxNodePtr;

	__asm volatile ("jsr a6@(-672)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID GfxLibrary::BitMapScale(struct BitScaleArgs * bitScaleArgs)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bitScaleArgs;

	__asm volatile ("jsr a6@(-678)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UWORD GfxLibrary::ScalerDiv(ULONG factor, ULONG numerator, ULONG denominator)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = factor;
	register unsigned int d1 __asm("d1") = numerator;
	register unsigned int d2 __asm("d2") = denominator;

	__asm volatile ("jsr a6@(-684)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2)
	: "d0", "d1", "d2");
	return (UWORD) _res;
}

WORD GfxLibrary::TextExtent(struct RastPort * rp, CONST_STRPTR string, LONG count, struct TextExtent * textExtent)
{
	register WORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register const char * a0 __asm("a0") = string;
	register int d0 __asm("d0") = count;
	register void * a2 __asm("a2") = textExtent;

	__asm volatile ("jsr a6@(-690)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (a2)
	: "a1", "a0", "d0", "a2");
	return (WORD) _res;
}

ULONG GfxLibrary::TextFit(struct RastPort * rp, CONST_STRPTR string, ULONG strLen, CONST struct TextExtent * textExtent, CONST struct TextExtent * constrainingExtent, LONG strDirection, ULONG constrainingBitWidth, ULONG constrainingBitHeight)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register const char * a0 __asm("a0") = string;
	register unsigned int d0 __asm("d0") = strLen;
	register const void * a2 __asm("a2") = textExtent;
	register const void * a3 __asm("a3") = constrainingExtent;
	register int d1 __asm("d1") = strDirection;
	register unsigned int d2 __asm("d2") = constrainingBitWidth;
	register unsigned int d3 __asm("d3") = constrainingBitHeight;

	__asm volatile ("jsr a6@(-696)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d0), "r" (a2), "r" (a3), "r" (d1), "r" (d2), "r" (d3)
	: "a1", "a0", "d0", "a2", "a3", "d1", "d2", "d3");
	return (ULONG) _res;
}

APTR GfxLibrary::GfxLookUp(CONST APTR associateNode)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = associateNode;

	__asm volatile ("jsr a6@(-702)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

BOOL GfxLibrary::VideoControl(struct ColorMap * colorMap, struct TagItem * tagarray)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = colorMap;
	register void * a1 __asm("a1") = tagarray;

	__asm volatile ("jsr a6@(-708)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

struct MonitorSpec * GfxLibrary::OpenMonitor(CONST_STRPTR monitorName, ULONG displayID)
{
	register struct MonitorSpec * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a1 __asm("a1") = monitorName;
	register unsigned int d0 __asm("d0") = displayID;

	__asm volatile ("jsr a6@(-714)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (struct MonitorSpec *) _res;
}

BOOL GfxLibrary::CloseMonitor(struct MonitorSpec * monitorSpec)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = monitorSpec;

	__asm volatile ("jsr a6@(-720)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

DisplayInfoHandle GfxLibrary::FindDisplayInfo(ULONG displayID)
{
	register DisplayInfoHandle _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = displayID;

	__asm volatile ("jsr a6@(-726)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (DisplayInfoHandle) _res;
}

ULONG GfxLibrary::NextDisplayInfo(ULONG displayID)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = displayID;

	__asm volatile ("jsr a6@(-732)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (ULONG) _res;
}

ULONG GfxLibrary::GetDisplayInfoData(CONST DisplayInfoHandle handle, APTR buf, ULONG size, ULONG tagID, ULONG displayID)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register CONST DisplayInfoHandle a0 __asm("a0") = handle;
	register void * a1 __asm("a1") = buf;
	register unsigned int d0 __asm("d0") = size;
	register unsigned int d1 __asm("d1") = tagID;
	register unsigned int d2 __asm("d2") = displayID;

	__asm volatile ("jsr a6@(-756)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2)
	: "a0", "a1", "d0", "d1", "d2");
	return (ULONG) _res;
}

VOID GfxLibrary::FontExtent(CONST struct TextFont * font, struct TextExtent * fontExtent)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = font;
	register void * a1 __asm("a1") = fontExtent;

	__asm volatile ("jsr a6@(-762)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

LONG GfxLibrary::ReadPixelLine8(struct RastPort * rp, ULONG xstart, ULONG ystart, ULONG width, UBYTE * array, struct RastPort * tempRP)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = xstart;
	register unsigned int d1 __asm("d1") = ystart;
	register unsigned int d2 __asm("d2") = width;
	register void * a2 __asm("a2") = array;
	register void * a1 __asm("a1") = tempRP;

	__asm volatile ("jsr a6@(-768)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a2), "r" (a1)
	: "a0", "d0", "d1", "d2", "a2", "a1");
	return (LONG) _res;
}

LONG GfxLibrary::WritePixelLine8(struct RastPort * rp, ULONG xstart, ULONG ystart, ULONG width, UBYTE * array, struct RastPort * tempRP)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = xstart;
	register unsigned int d1 __asm("d1") = ystart;
	register unsigned int d2 __asm("d2") = width;
	register void * a2 __asm("a2") = array;
	register void * a1 __asm("a1") = tempRP;

	__asm volatile ("jsr a6@(-774)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a2), "r" (a1)
	: "a0", "d0", "d1", "d2", "a2", "a1");
	return (LONG) _res;
}

LONG GfxLibrary::ReadPixelArray8(struct RastPort * rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, UBYTE * array, struct RastPort * temprp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = xstart;
	register unsigned int d1 __asm("d1") = ystart;
	register unsigned int d2 __asm("d2") = xstop;
	register unsigned int d3 __asm("d3") = ystop;
	register void * a2 __asm("a2") = array;
	register void * a1 __asm("a1") = temprp;

	__asm volatile ("jsr a6@(-780)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (a1)
	: "a0", "d0", "d1", "d2", "d3", "a2", "a1");
	return (LONG) _res;
}

LONG GfxLibrary::WritePixelArray8(struct RastPort * rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, UBYTE * array, struct RastPort * temprp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = xstart;
	register unsigned int d1 __asm("d1") = ystart;
	register unsigned int d2 __asm("d2") = xstop;
	register unsigned int d3 __asm("d3") = ystop;
	register void * a2 __asm("a2") = array;
	register void * a1 __asm("a1") = temprp;

	__asm volatile ("jsr a6@(-786)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (a1)
	: "a0", "d0", "d1", "d2", "d3", "a2", "a1");
	return (LONG) _res;
}

LONG GfxLibrary::GetVPModeID(CONST struct ViewPort * vp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-792)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

LONG GfxLibrary::ModeNotAvailable(ULONG modeID)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = modeID;

	__asm volatile ("jsr a6@(-798)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

VOID GfxLibrary::EraseRect(struct RastPort * rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = xMin;
	register int d1 __asm("d1") = yMin;
	register int d2 __asm("d2") = xMax;
	register int d3 __asm("d3") = yMax;

	__asm volatile ("jsr a6@(-810)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a1", "d0", "d1", "d2", "d3");
}

ULONG GfxLibrary::ExtendFont(struct TextFont * font, CONST struct TagItem * fontTags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = font;
	register const void * a1 __asm("a1") = fontTags;

	__asm volatile ("jsr a6@(-816)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

VOID GfxLibrary::StripFont(struct TextFont * font)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = font;

	__asm volatile ("jsr a6@(-822)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UWORD GfxLibrary::CalcIVG(struct View * v, struct ViewPort * vp)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = v;
	register void * a1 __asm("a1") = vp;

	__asm volatile ("jsr a6@(-828)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (UWORD) _res;
}

LONG GfxLibrary::AttachPalExtra(struct ColorMap * cm, struct ViewPort * vp)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cm;
	register void * a1 __asm("a1") = vp;

	__asm volatile ("jsr a6@(-834)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

LONG GfxLibrary::ObtainBestPenA(struct ColorMap * cm, ULONG r, ULONG g, ULONG b, CONST struct TagItem * tags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cm;
	register unsigned int d1 __asm("d1") = r;
	register unsigned int d2 __asm("d2") = g;
	register unsigned int d3 __asm("d3") = b;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-840)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d1), "r" (d2), "r" (d3), "r" (a1)
	: "a0", "d1", "d2", "d3", "a1");
	return (LONG) _res;
}

VOID GfxLibrary::SetRGB32(struct ViewPort * vp, ULONG n, ULONG r, ULONG g, ULONG b)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register unsigned int d0 __asm("d0") = n;
	register unsigned int d1 __asm("d1") = r;
	register unsigned int d2 __asm("d2") = g;
	register unsigned int d3 __asm("d3") = b;

	__asm volatile ("jsr a6@(-852)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
}

ULONG GfxLibrary::GetAPen(struct RastPort * rp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;

	__asm volatile ("jsr a6@(-858)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG GfxLibrary::GetBPen(struct RastPort * rp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;

	__asm volatile ("jsr a6@(-864)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG GfxLibrary::GetDrMd(struct RastPort * rp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;

	__asm volatile ("jsr a6@(-870)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG GfxLibrary::GetOutlinePen(struct RastPort * rp)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;

	__asm volatile ("jsr a6@(-876)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

VOID GfxLibrary::LoadRGB32(struct ViewPort * vp, CONST ULONG * table)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register const void * a1 __asm("a1") = table;

	__asm volatile ("jsr a6@(-882)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG GfxLibrary::SetChipRev(ULONG want)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = want;

	__asm volatile ("jsr a6@(-888)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (ULONG) _res;
}

VOID GfxLibrary::SetABPenDrMd(struct RastPort * rp, ULONG apen, ULONG bpen, ULONG drawmode)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register unsigned int d0 __asm("d0") = apen;
	register unsigned int d1 __asm("d1") = bpen;
	register unsigned int d2 __asm("d2") = drawmode;

	__asm volatile ("jsr a6@(-894)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2)
	: "a1", "d0", "d1", "d2");
}

VOID GfxLibrary::GetRGB32(CONST struct ColorMap * cm, ULONG firstcolor, ULONG ncolors, ULONG * table)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = cm;
	register unsigned int d0 __asm("d0") = firstcolor;
	register unsigned int d1 __asm("d1") = ncolors;
	register void * a1 __asm("a1") = table;

	__asm volatile ("jsr a6@(-900)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1)
	: "a0", "d0", "d1", "a1");
}

struct BitMap * GfxLibrary::AllocBitMap(ULONG sizex, ULONG sizey, ULONG depth, ULONG flags, CONST struct BitMap * friend_bitmap)
{
	register struct BitMap * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = sizex;
	register unsigned int d1 __asm("d1") = sizey;
	register unsigned int d2 __asm("d2") = depth;
	register unsigned int d3 __asm("d3") = flags;
	register const void * a0 __asm("a0") = friend_bitmap;

	__asm volatile ("jsr a6@(-918)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a0)
	: "d0", "d1", "d2", "d3", "a0");
	return (struct BitMap *) _res;
}

VOID GfxLibrary::FreeBitMap(struct BitMap * bm)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bm;

	__asm volatile ("jsr a6@(-924)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG GfxLibrary::GetExtSpriteA(struct ExtSprite * ss, CONST struct TagItem * tags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a2 __asm("a2") = ss;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-930)"
	: "=r" (_res)
	: "r" (a6), "r" (a2), "r" (a1)
	: "a2", "a1");
	return (LONG) _res;
}

ULONG GfxLibrary::CoerceMode(struct ViewPort * vp, ULONG monitorid, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register unsigned int d0 __asm("d0") = monitorid;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-936)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (ULONG) _res;
}

VOID GfxLibrary::ChangeVPBitMap(struct ViewPort * vp, struct BitMap * bm, struct DBufInfo * db)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register void * a1 __asm("a1") = bm;
	register void * a2 __asm("a2") = db;

	__asm volatile ("jsr a6@(-942)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID GfxLibrary::ReleasePen(struct ColorMap * cm, ULONG n)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cm;
	register unsigned int d0 __asm("d0") = n;

	__asm volatile ("jsr a6@(-948)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

ULONG GfxLibrary::ObtainPen(struct ColorMap * cm, ULONG n, ULONG r, ULONG g, ULONG b, LONG f)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cm;
	register unsigned int d0 __asm("d0") = n;
	register unsigned int d1 __asm("d1") = r;
	register unsigned int d2 __asm("d2") = g;
	register unsigned int d3 __asm("d3") = b;
	register int d4 __asm("d4") = f;

	__asm volatile ("jsr a6@(-954)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "a0", "d0", "d1", "d2", "d3", "d4");
	return (ULONG) _res;
}

ULONG GfxLibrary::GetBitMapAttr(CONST struct BitMap * bm, ULONG attrnum)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = bm;
	register unsigned int d1 __asm("d1") = attrnum;

	__asm volatile ("jsr a6@(-960)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d1)
	: "a0", "d1");
	return (ULONG) _res;
}

struct DBufInfo * GfxLibrary::AllocDBufInfo(struct ViewPort * vp)
{
	register struct DBufInfo * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;

	__asm volatile ("jsr a6@(-966)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DBufInfo *) _res;
}

VOID GfxLibrary::FreeDBufInfo(struct DBufInfo * dbi)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = dbi;

	__asm volatile ("jsr a6@(-972)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

ULONG GfxLibrary::SetOutlinePen(struct RastPort * rp, ULONG pen)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = pen;

	__asm volatile ("jsr a6@(-978)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

ULONG GfxLibrary::SetWriteMask(struct RastPort * rp, ULONG msk)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = msk;

	__asm volatile ("jsr a6@(-984)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

VOID GfxLibrary::SetMaxPen(struct RastPort * rp, ULONG maxpen)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = maxpen;

	__asm volatile ("jsr a6@(-990)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

VOID GfxLibrary::SetRGB32CM(struct ColorMap * cm, ULONG n, ULONG r, ULONG g, ULONG b)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cm;
	register unsigned int d0 __asm("d0") = n;
	register unsigned int d1 __asm("d1") = r;
	register unsigned int d2 __asm("d2") = g;
	register unsigned int d3 __asm("d3") = b;

	__asm volatile ("jsr a6@(-996)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
}

VOID GfxLibrary::ScrollRasterBF(struct RastPort * rp, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = rp;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;
	register int d2 __asm("d2") = xMin;
	register int d3 __asm("d3") = yMin;
	register int d4 __asm("d4") = xMax;
	register int d5 __asm("d5") = yMax;

	__asm volatile ("jsr a6@(-1002)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "a1", "d0", "d1", "d2", "d3", "d4", "d5");
}

LONG GfxLibrary::FindColor(struct ColorMap * cm, ULONG r, ULONG g, ULONG b, LONG maxcolor)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a3 __asm("a3") = cm;
	register unsigned int d1 __asm("d1") = r;
	register unsigned int d2 __asm("d2") = g;
	register unsigned int d3 __asm("d3") = b;
	register int d4 __asm("d4") = maxcolor;

	__asm volatile ("jsr a6@(-1008)"
	: "=r" (_res)
	: "r" (a6), "r" (a3), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "a3", "d1", "d2", "d3", "d4");
	return (LONG) _res;
}

struct ExtSprite * GfxLibrary::AllocSpriteDataA(CONST struct BitMap * bm, CONST struct TagItem * tags)
{
	register struct ExtSprite * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a2 __asm("a2") = bm;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-1020)"
	: "=r" (_res)
	: "r" (a6), "r" (a2), "r" (a1)
	: "a2", "a1");
	return (struct ExtSprite *) _res;
}

LONG GfxLibrary::ChangeExtSpriteA(struct ViewPort * vp, struct ExtSprite * oldsprite, struct ExtSprite * newsprite, CONST struct TagItem * tags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vp;
	register void * a1 __asm("a1") = oldsprite;
	register void * a2 __asm("a2") = newsprite;
	register const void * a3 __asm("a3") = tags;

	__asm volatile ("jsr a6@(-1026)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (LONG) _res;
}

VOID GfxLibrary::FreeSpriteData(struct ExtSprite * sp)
{
	register void * a6 __asm("a6") = Base;
	register void * a2 __asm("a2") = sp;

	__asm volatile ("jsr a6@(-1032)"
	: 
	: "r" (a6), "r" (a2)
	: "a2");
}

VOID GfxLibrary::SetRPAttrsA(struct RastPort * rp, CONST struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-1038)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID GfxLibrary::GetRPAttrsA(CONST struct RastPort * rp, CONST struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-1044)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG GfxLibrary::BestModeIDA(CONST struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-1050)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

VOID GfxLibrary::WriteChunkyPixels(struct RastPort * rp, ULONG xstart, ULONG ystart, ULONG xstop, ULONG ystop, CONST UBYTE * array, LONG bytesperrow)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register unsigned int d0 __asm("d0") = xstart;
	register unsigned int d1 __asm("d1") = ystart;
	register unsigned int d2 __asm("d2") = xstop;
	register unsigned int d3 __asm("d3") = ystop;
	register const void * a2 __asm("a2") = array;
	register int d4 __asm("d4") = bytesperrow;

	__asm volatile ("jsr a6@(-1056)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a2), "r" (d4)
	: "a0", "d0", "d1", "d2", "d3", "a2", "d4");
}


#endif

