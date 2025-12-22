#ifndef _INCLUDE_PRAGMA_TIMER_LIB_H
#define _INCLUDE_PRAGMA_TIMER_LIB_H

/*
**  $VER: timer_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_TIMER_PROTOS_H
#include <clib/timer_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(TimerBase, 0x2a, AddTime(a0,a1))
#pragma amicall(TimerBase, 0x30, SubTime(a0,a1))
#pragma amicall(TimerBase, 0x36, CmpTime(a0,a1))
#pragma amicall(TimerBase, 0x3c, ReadEClock(a0))
#pragma amicall(TimerBase, 0x42, GetSysTime(a0))

#ifdef __cplusplus
}
#endif

#endif
