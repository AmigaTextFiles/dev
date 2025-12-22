
#ifndef _BATTCLOCKLIBRARY_CPP
#define _BATTCLOCKLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/BattClockLibrary.h>

BattClockLibrary::BattClockLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("battclock.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open battclock.library") );
	}
}

BattClockLibrary::~BattClockLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID BattClockLibrary::ResetBattClock()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-6)"
	: 
	: "r" (a6)
	: "d0");
}

ULONG BattClockLibrary::ReadBattClock()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-12)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

VOID BattClockLibrary::WriteBattClock(ULONG time)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = time;

	__asm volatile ("jsr a6@(-18)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}


#endif

