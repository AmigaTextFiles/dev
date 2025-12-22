
#ifndef _PALETTELIBRARY_CPP
#define _PALETTELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/PaletteLibrary.h>

PaletteLibrary::PaletteLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("palette.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open palette.library") );
	}
}

PaletteLibrary::~PaletteLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * PaletteLibrary::PALETTE_GetClass()
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

