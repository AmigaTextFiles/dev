
#ifndef _RAMDRIVEDEVICE_H
#define _RAMDRIVEDEVICE_H

#include <exec/types.h>

class RamdriveDevice
{
public:
	RamdriveDevice();
	~RamdriveDevice();

	static class RamdriveDevice Default;

	STRPTR KillRAD0();
	STRPTR KillRAD(ULONG unit);

private:
	struct Library *Base;
};

RamdriveDevice RamdriveDevice::Default;

#endif

