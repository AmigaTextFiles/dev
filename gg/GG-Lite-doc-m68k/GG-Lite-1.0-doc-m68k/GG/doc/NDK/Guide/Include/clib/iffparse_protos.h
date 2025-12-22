@DATABASE "gg:doc/NDK/Guide/Include/clib/iffparse_protos.h"
@MASTER   "gg:os-include/clib/iffparse_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:48
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/iffparse_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/iffparse_protos.h" LINK File}

@ENDNODE
@NODE File "clib/iffparse_protos.h"
#ifndef  CLIB_IFFPARSE_PROTOS_H
#define  CLIB_IFFPARSE_PROTOS_H

/*
**      $VER: iffparse_protos.h 40.2 (6.6.1998)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
/*--- functions in V36 or higher (Release 2.0) ---*/

/* Basic functions */

@{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *AllocIFF( VOID );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"OpenIFF" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 30}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG rwMode );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ParseIFF" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 34}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG control );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseIFF" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 38}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeIFF" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 42}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff );

/* Read/Write functions */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadChunkBytes" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 46}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, APTR buf, LONG numBytes );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WriteChunkBytes" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 50}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, CONST APTR buf, LONG numBytes );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadChunkRecords" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 54}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, APTR buf, LONG bytesPerRecord, LONG numRecords );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WriteChunkRecords" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 58}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, CONST APTR buf, LONG bytesPerRecord, LONG numRecords );

/* Context entry/exit */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PushChunk" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 62}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id, LONG size );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PopChunk" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 66}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff );

/* Low-level handler installation */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"EntryHandler" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 70}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id, LONG position, struct Hook *handler, APTR object );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ExitHandler" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 74}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id, LONG position, struct Hook *handler, APTR object );

/* Built-in chunk/property handlers */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PropChunk" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 78}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PropChunks" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 82}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, CONST LONG *propArray, LONG numPairs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StopChunk" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 86}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StopChunks" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 90}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, CONST LONG *propArray, LONG numPairs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CollectionChunk" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 94}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CollectionChunks" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 98}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, CONST LONG *propArray, LONG numPairs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StopOnExit" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 102}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG type, LONG id );

/* Context utilities */

@{"struct StoredProperty" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 119} *FindProp( CONST struct IFFHandle *iff, LONG type, LONG id );
@{"struct CollectionItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 133} *FindCollection( CONST struct IFFHandle *iff, LONG type, LONG id );
@{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *FindPropContext( CONST struct IFFHandle *iff );
@{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *CurrentChunk( CONST struct IFFHandle *iff );
@{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *ParentChunk( CONST struct ContextNode *contextNode );

/* LocalContextItem support functions */

@{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *AllocLocalItem( LONG type, LONG id, LONG ident, LONG dataSize );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"LocalItemData" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 130}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *localItem );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetLocalItemPurge" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 134}( @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *localItem, CONST struct Hook *purgeHook );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeLocalItem" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 138}( @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *localItem );
@{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *FindLocalItem( CONST struct IFFHandle *iff, LONG type, LONG id, LONG ident );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StoreLocalItem" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 146}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, struct LocalContextItem *localItem, LONG position );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"StoreItemInContext" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 150}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, struct LocalContextItem *localItem, struct ContextNode *contextNode );

/* IFFHandle initialization */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitIFF" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 154}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff, LONG flags, CONST struct Hook *streamHook );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitIFFasDOS" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 158}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InitIFFasClip" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 162}( @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *iff );

/* Internal clipboard support */

@{"struct ClipboardHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 148} *OpenClipboard( LONG unitNumber );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseClipboard" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 170}( @{"struct ClipboardHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 148} *clipHandle );

/* Miscellaneous */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GoodID" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 174}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GoodType" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 178}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} type );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"IDtoStr" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 182}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_IFFPARSE_PROTOS_H */
@ENDNODE
