
#ifndef _INPUTLIBRARY_CPP
#define _INPUTLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/InputLibrary.h>

InputLibrary::InputLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("input.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open input.library") );
	}
}

InputLibrary::~InputLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

UWORD InputLibrary::PeekQualifier()
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (UWORD) _res;
}


#endif

