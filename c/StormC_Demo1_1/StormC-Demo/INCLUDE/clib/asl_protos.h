#ifndef  CLIB_ASL_PROTOS_H
#define  CLIB_ASL_PROTOS_H

/*
**	$VER: asl_protos.h 38.3 (19.3.92)
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
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  LIBRARIES_ASL_H
#include <libraries/asl.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*--- functions in V36 or higher (Release 2.0) ---*/

/* OBSOLETE -- Please use the generic requester functions instead */

struct FileRequester *AllocFileRequest( void );
void FreeFileRequest( struct FileRequester *fileReq );
BOOL RequestFile( struct FileRequester *fileReq );
APTR AllocAslRequest( unsigned long reqType, struct TagItem *tagList );
APTR AllocAslRequestTags( unsigned long reqType, Tag Tag1, ... );
void FreeAslRequest( APTR requester );
BOOL AslRequest( APTR requester, struct TagItem *tagList );
BOOL AslRequestTags( APTR requester, Tag Tag1, ... );

#ifdef __cplusplus
}
#endif

#ifdef STORMPRAGMAS
#ifndef _INCLUDE_PRAGMA_ASL_LIB_H
#include <pragma/asl_lib.h>
#endif
#endif

#endif	 /* CLIB_ASL_PROTOS_H */
