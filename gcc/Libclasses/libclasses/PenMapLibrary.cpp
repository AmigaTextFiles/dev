
#ifndef _PENMAPLIBRARY_CPP
#define _PENMAPLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/PenMapLibrary.h>

PenMapLibrary::PenMapLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("penmap.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open penmap.library") );
	}
}

PenMapLibrary::~PenMapLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * PenMapLibrary::PENMAP_GetClass()
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

