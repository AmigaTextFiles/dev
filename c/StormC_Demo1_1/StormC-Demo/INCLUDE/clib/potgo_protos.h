#ifndef  CLIB_POTGO_PROTOS_H
#define  CLIB_POTGO_PROTOS_H

/*
**	$VER: potgo_protos.h 36.3 (7.11.90)
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

UWORD AllocPotBits( unsigned long bits );
void FreePotBits( unsigned long bits );
void WritePotgo( unsigned long word, unsigned long mask );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_POTGO_LIB_H
#include <pragma/potgo_lib.h>
#endif
#endif

#endif	 /* CLIB_POTGO_PROTOS_H */
