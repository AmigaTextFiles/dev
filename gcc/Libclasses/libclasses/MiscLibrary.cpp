
#ifndef _MISCLIBRARY_CPP
#define _MISCLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/MiscLibrary.h>

MiscLibrary::MiscLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("misc.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open misc.library") );
	}
}

MiscLibrary::~MiscLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

UBYTE * MiscLibrary::AllocMiscResource(ULONG unitNum, CONST_STRPTR name)
{
	register UBYTE * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = unitNum;
	register const char * a1 __asm("a1") = name;

	__asm volatile ("jsr a6@(-6)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
	return (UBYTE *) _res;
}

VOID MiscLibrary::FreeMiscResource(ULONG unitNum)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = unitNum;

	__asm volatile ("jsr a6@(-12)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}


#endif

