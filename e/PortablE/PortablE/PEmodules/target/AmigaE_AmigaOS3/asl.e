/* $VER: asl_protos.h 38.3 (19.3.1992) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/asl'
MODULE 'target/exec/types', 'target/utility/tagitem' /*, 'target/libraries/asl'*/
MODULE 'target/exec/libraries'
{MODULE 'asl'}

NATIVE {aslbase} DEF aslbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V36 or higher (Release 2.0) ---*/

/* OBSOLETE -- Please use the generic requester functions instead */

NATIVE {AllocFileRequest} PROC
PROC AllocFileRequest( ) IS NATIVE {AllocFileRequest()} ENDNATIVE !!PTR TO filerequester
NATIVE {FreeFileRequest} PROC
PROC FreeFileRequest( fileReq:PTR TO filerequester ) IS NATIVE {FreeFileRequest(} fileReq {)} ENDNATIVE
NATIVE {RequestFile} PROC
PROC RequestFile( fileReq:PTR TO filerequester ) IS NATIVE {RequestFile(} fileReq {)} ENDNATIVE !!INT
NATIVE {AllocAslRequest} PROC
PROC AllocAslRequest( reqType:ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
NATIVE {FreeAslRequest} PROC
PROC FreeAslRequest( requester:APTR2 ) IS NATIVE {FreeAslRequest(} requester {)} ENDNATIVE
NATIVE {AslRequest} PROC
PROC AslRequest( requester:APTR2, tagList:ARRAY OF tagitem ) IS NATIVE {AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
