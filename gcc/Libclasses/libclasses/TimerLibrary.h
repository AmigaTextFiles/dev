
#ifndef _TIMERLIBRARY_H
#define _TIMERLIBRARY_H

#include <devices/timer.h>

class TimerLibrary
{
public:
	TimerLibrary();
	~TimerLibrary();

	static class TimerLibrary Default;

	VOID AddTime(struct timeval * dest, CONST struct timeval * src);
	VOID SubTime(struct timeval * dest, CONST struct timeval * src);
	LONG CmpTime(CONST struct timeval * dest, CONST struct timeval * src);
	ULONG ReadEClock(struct EClockVal * dest);
	VOID GetSysTime(struct timeval * dest);

private:
	struct Library *Base;
};

TimerLibrary TimerLibrary::Default;

#endif

