
#ifndef _BATTCLOCKLIBRARY_H
#define _BATTCLOCKLIBRARY_H

#include <exec/types.h>

class BattClockLibrary
{
public:
	BattClockLibrary();
	~BattClockLibrary();

	static class BattClockLibrary Default;

	VOID ResetBattClock();
	ULONG ReadBattClock();
	VOID WriteBattClock(ULONG time);

private:
	struct Library *Base;
};

BattClockLibrary BattClockLibrary::Default;

#endif

