#ifndef  CLIB_MISC_PROTOS_H
#define  CLIB_MISC_PROTOS_H

/*
**	$VER: misc_protos.h 36.2 (7.11.90)
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

UBYTE *AllocMiscResource( unsigned long unitNum, UBYTE *name );
void FreeMiscResource( unsigned long unitNum );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_MISC_LIB_H
#include <pragma/misc_lib.h>
#endif
#endif

#endif	 /* CLIB_MISC_PROTOS_H */
