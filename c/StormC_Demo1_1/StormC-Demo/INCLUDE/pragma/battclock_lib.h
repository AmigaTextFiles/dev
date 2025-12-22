#ifndef _INCLUDE_PRAGMA_BATTCLOCK_LIB_H
#define _INCLUDE_PRAGMA_BATTCLOCK_LIB_H

/*
**  $VER: battclock_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_BATTCLOCK_PROTOS_H
#include <clib/battclock_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(BattClockBase, 0x6, ResetBattClock())
#pragma amicall(BattClockBase, 0xc, ReadBattClock())
#pragma amicall(BattClockBase, 0x12, WriteBattClock(d0))

#ifdef __cplusplus
}
#endif

#endif
