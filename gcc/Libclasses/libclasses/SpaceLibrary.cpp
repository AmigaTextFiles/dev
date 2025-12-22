
#ifndef _SPACELIBRARY_CPP
#define _SPACELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/SpaceLibrary.h>

SpaceLibrary::SpaceLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("space.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open space.library") );
	}
}

SpaceLibrary::~SpaceLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * SpaceLibrary::SPACE_GetClass()
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

