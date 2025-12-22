#ifndef  CLIB_DISK_PROTOS_H
#define  CLIB_DISK_PROTOS_H

/*
**	$VER: disk_protos.h 36.1 (19.2.91)
**	Includes Release 40.15
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1990-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
*/

#ifndef  RESOURCES_DISK_H
#include <resources/disk.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

BOOL AllocUnit( long unitNum );
void FreeUnit( long unitNum );
struct DiskResourceUnit *GetUnit( struct DiskResourceUnit *unitPointer );
void GiveUnit( void );
LONG GetUnitID( long unitNum );
/*------ new for V37 ------*/
LONG ReadUnitID( long unitNum );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_DISK_LIB_H
#include <pragma/disk_lib.h>
#endif
#endif

#endif	 /* CLIB_DISK_PROTOS_H */
