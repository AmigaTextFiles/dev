
#ifndef _INTEGERLIBRARY_CPP
#define _INTEGERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/IntegerLibrary.h>

IntegerLibrary::IntegerLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("integer.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open integer.library") );
	}
}

IntegerLibrary::~IntegerLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * IntegerLibrary::INTEGER_GetClass()
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

