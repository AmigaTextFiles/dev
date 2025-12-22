
#ifndef _BATTMEMLIBRARY_H
#define _BATTMEMLIBRARY_H

#include <exec/types.h>

class BattMemLibrary
{
public:
	BattMemLibrary();
	~BattMemLibrary();

	static class BattMemLibrary Default;

	VOID ObtainBattSemaphore();
	VOID ReleaseBattSemaphore();
	ULONG ReadBattMem(APTR buffer, ULONG offset, ULONG length);
	ULONG WriteBattMem(CONST APTR buffer, ULONG offset, ULONG length);

private:
	struct Library *Base;
};

BattMemLibrary BattMemLibrary::Default;

#endif

