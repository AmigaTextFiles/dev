
#ifndef _FUELGAUGELIBRARY_CPP
#define _FUELGAUGELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/FuelGaugeLibrary.h>

FuelGaugeLibrary::FuelGaugeLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("fuelgauge.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open fuelgauge.library") );
	}
}

FuelGaugeLibrary::~FuelGaugeLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * FuelGaugeLibrary::FUELGAUGE_GetClass()
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

