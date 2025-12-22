#ifndef _INLINE_TIMER_H
#define _INLINE_TIMER_H

#ifndef CLIB_TIMER_PROTOS_H
#define CLIB_TIMER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  DEVICES_TIMER_H
#include <devices/timer.h>
#endif

#ifndef TIMER_BASE_NAME
#define TIMER_BASE_NAME TimerBase
#endif

#define AddTime(dest, src) \
	LP2NR(0x2a, AddTime, struct timeval *, dest, a0, const struct timeval *, src, a1, \
	, TIMER_BASE_NAME)

#define SubTime(dest, src) \
	LP2NR(0x30, SubTime, struct timeval *, dest, a0, const struct timeval *, src, a1, \
	, TIMER_BASE_NAME)

#define CmpTime(dest, src) \
	LP2(0x36, LONG, CmpTime, const struct timeval *, dest, a0, const struct timeval *, src, a1, \
	, TIMER_BASE_NAME)

#define ReadEClock(dest) \
	LP1(0x3c, ULONG, ReadEClock, struct EClockVal *, dest, a0, \
	, TIMER_BASE_NAME)

#define GetSysTime(dest) \
	LP1NR(0x42, GetSysTime, struct timeval *, dest, a0, \
	, TIMER_BASE_NAME)

#endif /*  _INLINE_TIMER_H  */
