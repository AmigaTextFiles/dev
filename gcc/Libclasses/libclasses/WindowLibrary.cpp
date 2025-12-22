
#ifndef _WINDOWLIBRARY_CPP
#define _WINDOWLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/WindowLibrary.h>

WindowLibrary::WindowLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("window.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open window.library") );
	}
}

WindowLibrary::~WindowLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * WindowLibrary::WINDOW_GetClass()
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

