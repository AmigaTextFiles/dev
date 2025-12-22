/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_BATTCLOCK_H
#define _PPCINLINE_BATTCLOCK_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef BATTCLOCK_BASE_NAME
#define BATTCLOCK_BASE_NAME BattClockBase
#endif /* !BATTCLOCK_BASE_NAME */

#define ReadBattClock() \
	LP0(0xc, ULONG, ReadBattClock, \
	, BATTCLOCK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ResetBattClock() \
	LP0NR(0x6, ResetBattClock, \
	, BATTCLOCK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteBattClock(time) \
	LP1NR(0x12, WriteBattClock, ULONG, time, d0, \
	, BATTCLOCK_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_BATTCLOCK_H */
