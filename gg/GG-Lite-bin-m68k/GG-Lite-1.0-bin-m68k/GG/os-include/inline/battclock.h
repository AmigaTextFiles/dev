#ifndef _INLINE_BATTCLOCK_H
#define _INLINE_BATTCLOCK_H

#ifndef CLIB_BATTCLOCK_PROTOS_H
#define CLIB_BATTCLOCK_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef BATTCLOCK_BASE_NAME
#define BATTCLOCK_BASE_NAME BattClockBase
#endif

#define ResetBattClock() \
	LP0NR(0x6, ResetBattClock, \
	, BATTCLOCK_BASE_NAME)

#define ReadBattClock() \
	LP0(0xc, ULONG, ReadBattClock, \
	, BATTCLOCK_BASE_NAME)

#define WriteBattClock(time) \
	LP1NR(0x12, WriteBattClock, ULONG, time, d0, \
	, BATTCLOCK_BASE_NAME)

#endif /*  _INLINE_BATTCLOCK_H  */
