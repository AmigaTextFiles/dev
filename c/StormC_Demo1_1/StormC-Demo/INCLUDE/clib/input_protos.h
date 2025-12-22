#ifndef  CLIB_INPUT_PROTOS_H
#define  CLIB_INPUT_PROTOS_H

/*
**	$VER: input_protos.h 36.2 (7.11.90)
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

/*--- functions in V36 or higher (Release 2.0) ---*/
UWORD PeekQualifier( void );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_INPUT_LIB_H
#include <pragma/input_lib.h>
#endif
#endif

#endif	 /* CLIB_INPUT_PROTOS_H */
