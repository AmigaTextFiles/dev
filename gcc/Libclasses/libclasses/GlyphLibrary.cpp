
#ifndef _GLYPHLIBRARY_CPP
#define _GLYPHLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GlyphLibrary.h>

GlyphLibrary::GlyphLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("glyph.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open glyph.library") );
	}
}

GlyphLibrary::~GlyphLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * GlyphLibrary::GLYPH_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}


#endif

