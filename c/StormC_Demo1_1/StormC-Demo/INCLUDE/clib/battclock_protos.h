#ifndef  CLIB_BATTCLOCK_PROTOS_H
#define  CLIB_BATTCLOCK_PROTOS_H

/*
**	$VER: battclock_protos.h 1.3 (3.5.90)
**	Includes Release 40.15
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1990-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

void ResetBattClock( void );
ULONG ReadBattClock( void );
void WriteBattClock( unsigned long time );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_BATTCLOCK_LIB_H
#include <pragma/battclock_lib.h>
#endif
#endif

#endif	 /* CLIB_BATTCLOCK_PROTOS_H */
