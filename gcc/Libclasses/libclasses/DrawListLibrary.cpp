
#ifndef _DRAWLISTLIBRARY_CPP
#define _DRAWLISTLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DrawListLibrary.h>

DrawListLibrary::DrawListLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("drawlist.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open drawlist.library") );
	}
}

DrawListLibrary::~DrawListLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * DrawListLibrary::DRAWLIST_GetClass()
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

