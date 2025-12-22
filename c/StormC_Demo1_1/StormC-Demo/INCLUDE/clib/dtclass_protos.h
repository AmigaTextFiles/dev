#ifndef  CLIB_DTCLASS_PROTOS_H
#define  CLIB_DTCLASS_PROTOS_H
/*
**	$VER: dtclass_protos.h 39.0 (1.6.92)
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
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*--- functions in V39 or higher (distributed as Release 3.0) ---*/

Class *ObtainEngine( void );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_DTCLASS_LIB_H
#include <pragma/dtclass_lib.h>
#endif
#endif

#endif	 /* CLIB_DTCLASS_PROTOS_H */
