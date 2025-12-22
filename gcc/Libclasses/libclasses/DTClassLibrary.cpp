
#ifndef _DTCLASSLIBRARY_CPP
#define _DTCLASSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DTClassLibrary.h>

DTClassLibrary::DTClassLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("dtclass.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open dtclass.library") );
	}
}

DTClassLibrary::~DTClassLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * DTClassLibrary::ObtainEngine()
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

