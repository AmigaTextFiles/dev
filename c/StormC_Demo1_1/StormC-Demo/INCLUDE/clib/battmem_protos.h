#ifndef  CLIB_BATTMEM_PROTOS_H
#define  CLIB_BATTMEM_PROTOS_H

/*
**	$VER: battmem_protos.h 1.5 (4.3.91)
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

void ObtainBattSemaphore( void );
void ReleaseBattSemaphore( void );
ULONG ReadBattMem( APTR buffer, unsigned long offset, unsigned long length );
ULONG WriteBattMem( APTR buffer, unsigned long offset, unsigned long length );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_BATTMEM_LIB_H
#include <pragma/battmem_lib.h>
#endif
#endif

#endif	 /* CLIB_BATTMEM_PROTOS_H */
