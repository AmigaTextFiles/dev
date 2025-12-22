#ifndef  CLIB_RAMDRIVE_PROTOS_H
#define  CLIB_RAMDRIVE_PROTOS_H

/*
**	$VER: ramdrive_protos.h 36.3 (7.11.90)
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

/*--- functions in V34 or higher (Release 1.3) ---*/
STRPTR KillRAD0( void );
/*--- functions in V36 or higher (Release 2.0) ---*/
STRPTR KillRAD( unsigned long unit );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_RAMDRIVE_LIB_H
#include <pragma/ramdrive_lib.h>
#endif
#endif

#endif	 /* CLIB_RAMDRIVE_PROTOS_H */
