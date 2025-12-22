
#ifndef _GETFONTLIBRARY_CPP
#define _GETFONTLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GetFontLibrary.h>

GetFontLibrary::GetFontLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("getfont.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open getfont.library") );
	}
}

GetFontLibrary::~GetFontLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * GetFontLibrary::GETFONT_GetClass()
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

