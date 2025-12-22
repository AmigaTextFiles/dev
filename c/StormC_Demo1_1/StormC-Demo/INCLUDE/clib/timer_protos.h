#ifndef  CLIB_TIMER_PROTOS_H
#define  CLIB_TIMER_PROTOS_H

/*
**	$VER: timer_protos.h 1.6 (25.1.91)
**	Includes Release 40.15
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1990-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
*/

#ifndef  DEVICES_TIMER_H
#include <devices/timer.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

void AddTime( struct timeval *dest, struct timeval *src );
void SubTime( struct timeval *dest, struct timeval *src );
LONG CmpTime( struct timeval *dest, struct timeval *src );
ULONG ReadEClock( struct EClockVal *dest );
void GetSysTime( struct timeval *dest );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_TIMER_LIB_H
#include <pragma/timer_lib.h>
#endif
#endif

#endif	 /* CLIB_TIMER_PROTOS_H */
