
#ifndef _DISKLIBRARY_H
#define _DISKLIBRARY_H

#include <resources/disk.h>

class DiskLibrary
{
public:
	DiskLibrary();
	~DiskLibrary();

	static class DiskLibrary Default;

	BOOL AllocUnit(LONG unitNum);
	VOID FreeUnit(LONG unitNum);
	struct DiskResourceUnit * GetUnit(struct DiskResourceUnit * unitPointer);
	VOID GiveUnit();
	LONG GetUnitID(LONG unitNum);
	LONG ReadUnitID(LONG unitNum);

private:
	struct Library *Base;
};

DiskLibrary DiskLibrary::Default;

#endif

