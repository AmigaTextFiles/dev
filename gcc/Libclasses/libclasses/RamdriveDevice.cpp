
#ifndef _RAMDRIVEDEVICE_CPP
#define _RAMDRIVEDEVICE_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/RamdriveDevice.h>

RamdriveDevice::RamdriveDevice()
{
	Base = ExecLibrary::Default.OpenLibrary("ramdrivedevice.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open ramdrivedevice.library") );
	}
}

RamdriveDevice::~RamdriveDevice()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

STRPTR RamdriveDevice::KillRAD0()
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (STRPTR) _res;
}

STRPTR RamdriveDevice::KillRAD(ULONG unit)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = unit;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (STRPTR) _res;
}


#endif

