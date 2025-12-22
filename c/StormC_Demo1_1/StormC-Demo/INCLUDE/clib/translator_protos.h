#ifndef  CLIB_TRANSLATOR_PROTOS_H
#define  CLIB_TRANSLATOR_PROTOS_H

/*
**	$VER: translator_protos.h 36.1 (7.11.90)
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

LONG Translate( STRPTR inputString, long inputLength, STRPTR outputBuffer,
	long bufferSize );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_TRANSLATOR_LIB_H
#include <pragma/translator_lib.h>
#endif
#endif

#endif	 /* CLIB_TRANSLATOR_PROTOS_H */
