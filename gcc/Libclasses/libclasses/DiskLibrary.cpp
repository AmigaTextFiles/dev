
#ifndef _DISKLIBRARY_CPP
#define _DISKLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DiskLibrary.h>

DiskLibrary::DiskLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("disk.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open disk.library") );
	}
}

DiskLibrary::~DiskLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

BOOL DiskLibrary::AllocUnit(LONG unitNum)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = unitNum;

	__asm volatile ("jsr a6@(-6)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (BOOL) _res;
}

VOID DiskLibrary::FreeUnit(LONG unitNum)
{
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = unitNum;

	__asm volatile ("jsr a6@(-12)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

struct DiskResourceUnit * DiskLibrary::GetUnit(struct DiskResourceUnit * unitPointer)
{
	register struct DiskResourceUnit * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = unitPointer;

	__asm volatile ("jsr a6@(-18)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct DiskResourceUnit *) _res;
}

VOID DiskLibrary::GiveUnit()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-24)"
	: 
	: "r" (a6)
	: "d0");
}

LONG DiskLibrary::GetUnitID(LONG unitNum)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = unitNum;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

LONG DiskLibrary::ReadUnitID(LONG unitNum)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = unitNum;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}


#endif

