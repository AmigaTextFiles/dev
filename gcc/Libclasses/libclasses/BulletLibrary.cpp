
#ifndef _BULLETLIBRARY_CPP
#define _BULLETLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/BulletLibrary.h>

BulletLibrary::BulletLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("bullet.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open bullet.library") );
	}
}

BulletLibrary::~BulletLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct GlyphEngine * BulletLibrary::OpenEngine()
{
	register struct GlyphEngine * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct GlyphEngine *) _res;
}

VOID BulletLibrary::CloseEngine(struct GlyphEngine * glyphEngine)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = glyphEngine;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG BulletLibrary::SetInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = glyphEngine;
	register void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG BulletLibrary::ObtainInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = glyphEngine;
	register void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG BulletLibrary::ReleaseInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = glyphEngine;
	register void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}


#endif

