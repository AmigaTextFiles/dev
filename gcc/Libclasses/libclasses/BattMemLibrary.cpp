
#ifndef _BATTMEMLIBRARY_CPP
#define _BATTMEMLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/BattMemLibrary.h>

BattMemLibrary::BattMemLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("battmem.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open battmem.library") );
	}
}

BattMemLibrary::~BattMemLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID BattMemLibrary::ObtainBattSemaphore()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-6)"
	: 
	: "r" (a6)
	: "d0");
}

VOID BattMemLibrary::ReleaseBattSemaphore()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-12)"
	: 
	: "r" (a6)
	: "d0");
}

ULONG BattMemLibrary::ReadBattMem(APTR buffer, ULONG offset, ULONG length)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = buffer;
	register unsigned int d0 __asm("d0") = offset;
	register unsigned int d1 __asm("d1") = length;

	__asm volatile ("jsr a6@(-18)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (ULONG) _res;
}

ULONG BattMemLibrary::WriteBattMem(CONST APTR buffer, ULONG offset, ULONG length)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = buffer;
	register unsigned int d0 __asm("d0") = offset;
	register unsigned int d1 __asm("d1") = length;

	__asm volatile ("jsr a6@(-24)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (ULONG) _res;
}


#endif

