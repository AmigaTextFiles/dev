
#ifndef _POTGOLIBRARY_CPP
#define _POTGOLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/PotgoLibrary.h>

PotgoLibrary::PotgoLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("potgo.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open potgo.library") );
	}
}

PotgoLibrary::~PotgoLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

UWORD PotgoLibrary::AllocPotBits(ULONG bits)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = bits;

	__asm volatile ("jsr a6@(-6)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (UWORD) _res;
}

VOID PotgoLibrary::FreePotBits(ULONG bits)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = bits;

	__asm volatile ("jsr a6@(-12)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID PotgoLibrary::WritePotgo(ULONG word, ULONG mask)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = word;
	register unsigned int d1 __asm("d1") = mask;

	__asm volatile ("jsr a6@(-18)"
	: 
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
}


#endif

