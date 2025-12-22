#ifndef  CLIB_ICON_PROTOS_H
#define  CLIB_ICON_PROTOS_H

/*
**	$VER: icon_protos.h 38.2 (16.6.93)
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
#ifndef  WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

void FreeFreeList( struct FreeList *freelist );
BOOL AddFreeList( struct FreeList *freelist, APTR mem, unsigned long size );
struct DiskObject *GetDiskObject( UBYTE *name );
BOOL PutDiskObject( UBYTE *name, struct DiskObject *diskobj );
void FreeDiskObject( struct DiskObject *diskobj );
UBYTE *FindToolType( UBYTE **toolTypeArray, UBYTE *typeName );
BOOL MatchToolValue( UBYTE *typeString, UBYTE *value );
UBYTE *BumpRevision( UBYTE *newname, UBYTE *oldname );
/*--- functions in V36 or higher (Release 2.0) ---*/
struct DiskObject *GetDefDiskObject( long type );
BOOL PutDefDiskObject( struct DiskObject *diskObject );
struct DiskObject *GetDiskObjectNew( UBYTE *name );
/*--- functions in V37 or higher (Release 2.04) ---*/
BOOL DeleteDiskObject( UBYTE *name );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_ICON_LIB_H
#include <pragma/icon_lib.h>
#endif
#endif

#endif	 /* CLIB_ICON_PROTOS_H */
