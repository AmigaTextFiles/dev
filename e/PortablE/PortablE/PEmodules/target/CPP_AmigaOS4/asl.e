/* $Id: asl_protos.h,v 1.8 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/asl'
MODULE 'target/exec/libraries', 'target/utility/tagitem' /*, 'target/libraries/asl'*/
MODULE 'target/PEalias/exec', 'target/exec/types'
{
#include <proto/asl.h>
}
{
struct Library* AslBase = NULL;
struct AslIFace* IAsl = NULL;
}
NATIVE {CLIB_ASL_PROTOS_H} CONST
NATIVE {PROTO_ASL_H} CONST
NATIVE {PRAGMA_ASL_H} CONST
NATIVE {INLINE4_ASL_H} CONST
NATIVE {ASL_INTERFACE_DEF_H} CONST

NATIVE {AslBase} DEF aslbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IAsl} DEF

PROC new()
	InitLibrary('asl.library', NATIVE {(struct Interface **) &IAsl} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/

/* OBSOLETE -- Please use the generic requester functions instead */

->NATIVE {AllocFileRequest} PROC
->Not supported for some reason: PROC AllocFileRequest( ) IS NATIVE {IAsl->AllocFileRequest()} ENDNATIVE !!PTR TO filerequester
->NATIVE {FreeFileRequest} PROC
->Not supported for some reason: PROC FreeFileRequest( fileReq:PTR TO filerequester ) IS NATIVE {IAsl->FreeFileRequest(} fileReq {)} ENDNATIVE
->NATIVE {RequestFile} PROC
->Not supported for some reason: PROC RequestFile( fileReq:PTR TO filerequester ) IS NATIVE {-IAsl->RequestFile(} fileReq {)} ENDNATIVE !!INT
->NATIVE {AllocAslRequest} PROC
PROC AllocAslRequest( reqType:ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {IAsl->AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
->NATIVE {AllocAslRequestTags} PROC
PROC AllocAslRequestTags( reqType:ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IAsl->AllocAslRequestTags(} reqType {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {FreeAslRequest} PROC
PROC FreeAslRequest( requester:APTR2 ) IS NATIVE {IAsl->FreeAslRequest(} requester {)} ENDNATIVE
->NATIVE {AslRequest} PROC
PROC AslRequest( requester:APTR2, tagList:ARRAY OF tagitem ) IS NATIVE {-IAsl->AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
->NATIVE {AslRequestTags} PROC
PROC AslRequestTags( requester:APTR2, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IAsl->AslRequestTags(} requester {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {AbortAslRequest} PROC
PROC AbortAslRequest( requester:APTR2 ) IS NATIVE {IAsl->AbortAslRequest(} requester {)} ENDNATIVE
->NATIVE {ActivateAslRequest} PROC
PROC ActivateAslRequest( requester:APTR2 ) IS NATIVE {IAsl->ActivateAslRequest(} requester {)} ENDNATIVE
