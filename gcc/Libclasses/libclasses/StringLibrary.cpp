
#ifndef _STRINGLIBRARY_CPP
#define _STRINGLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/StringLibrary.h>

StringLibrary::StringLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("string.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open string.library") );
	}
}

StringLibrary::~StringLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * StringLibrary::STRING_GetClass()
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

