/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_TIMER_H
#define _PPCINLINE_TIMER_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef TIMER_BASE_NAME
#define TIMER_BASE_NAME TimerBase
#endif /* !TIMER_BASE_NAME */

#define AddTime(dest, src) \
	LP2NR(0x2a, AddTime, struct timeval *, dest, a0, CONST struct timeval *, src, a1, \
	, TIMER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CmpTime(dest, src) \
	LP2(0x36, LONG, CmpTime, CONST struct timeval *, dest, a0, CONST struct timeval *, src, a1, \
	, TIMER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetSysTime(dest) \
	LP1NR(0x42, GetSysTime, struct timeval *, dest, a0, \
	, TIMER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadEClock(dest) \
	LP1(0x3c, ULONG, ReadEClock, struct EClockVal *, dest, a0, \
	, TIMER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SubTime(dest, src) \
	LP2NR(0x30, SubTime, struct timeval *, dest, a0, CONST struct timeval *, src, a1, \
	, TIMER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_TIMER_H */
