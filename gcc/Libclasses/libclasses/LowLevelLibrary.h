
#ifndef _LOWLEVELLIBRARY_H
#define _LOWLEVELLIBRARY_H

#include <exec/types.h>
#include <exec/interrupts.h>
#include <utility/tagitem.h>
#include <devices/timer.h>
#include <libraries/lowlevel.h>

class LowLevelLibrary
{
public:
	LowLevelLibrary();
	~LowLevelLibrary();

	static class LowLevelLibrary Default;

	ULONG ReadJoyPort(ULONG port);
	UBYTE GetLanguageSelection();
	ULONG GetKey();
	VOID QueryKeys(struct KeyQuery * queryArray, ULONG arraySize);
	APTR AddKBInt(CONST APTR intRoutine, CONST APTR intData);
	VOID RemKBInt(APTR intHandle);
	ULONG SystemControlA(CONST struct TagItem * tagList);
	APTR AddTimerInt(CONST APTR intRoutine, CONST APTR intData);
	VOID RemTimerInt(APTR intHandle);
	VOID StopTimerInt(APTR intHandle);
	VOID StartTimerInt(APTR intHandle, ULONG timeInterval, LONG continuous);
	ULONG ElapsedTime(struct EClockVal * context);
	APTR AddVBlankInt(CONST APTR intRoutine, CONST APTR intData);
	VOID RemVBlankInt(APTR intHandle);
	BOOL SetJoyPortAttrsA(ULONG portNumber, CONST struct TagItem * tagList);

private:
	struct Library *Base;
};

LowLevelLibrary LowLevelLibrary::Default;

#endif

