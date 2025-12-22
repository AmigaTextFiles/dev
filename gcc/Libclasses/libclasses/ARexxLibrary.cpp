
#ifndef _AREXXLIBRARY_CPP
#define _AREXXLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ARexxLibrary.h>

ARexxLibrary::ARexxLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("arexx.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open arexx.library") );
	}
}

ARexxLibrary::~ARexxLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ARexxLibrary::AREXX_GetClass()
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

