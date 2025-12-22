
#ifndef _FUELGAUGELIBRARY_H
#define _FUELGAUGELIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class FuelGaugeLibrary
{
public:
	FuelGaugeLibrary();
	~FuelGaugeLibrary();

	static class FuelGaugeLibrary Default;

	Class * FUELGAUGE_GetClass();

private:
	struct Library *Base;
};

FuelGaugeLibrary FuelGaugeLibrary::Default;

#endif

