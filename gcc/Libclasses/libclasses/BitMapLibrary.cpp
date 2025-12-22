
#ifndef _BITMAPLIBRARY_CPP
#define _BITMAPLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/BitMapLibrary.h>

BitMapLibrary::BitMapLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("bitmap.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open bitmap.library") );
	}
}

BitMapLibrary::~BitMapLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * BitMapLibrary::BITMAP_GetClass()
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

