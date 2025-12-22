OPT NATIVE
PUBLIC MODULE 'target/libraries/asl'
MODULE 'target/aros/libcall', 'target/exec/types', 'target/utility/tagitem' /*, 'target/libraries/asl'*/
MODULE 'target/exec/libraries'
{
#include <proto/asl.h>
}
{
struct Library* AslBase = NULL;
}
NATIVE {CLIB_ASL_PROTOS_H} CONST
NATIVE {PROTO_ASL_H} CONST

NATIVE {AslBase} DEF aslbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {AllocAslRequestTags} PROC
PROC AllocAslRequestTags(reqType:ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {AllocAslRequestTags(} reqType {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {AslRequestTags} PROC
PROC AslRequestTags(requester:APTR2, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {-AslRequestTags(} requester {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {AllocFileRequest} PROC
PROC AllocFileRequest() IS NATIVE {AllocFileRequest()} ENDNATIVE !!PTR TO filerequester
NATIVE {FreeFileRequest} PROC
PROC FreeFileRequest(fileReq:PTR TO filerequester) IS NATIVE {FreeFileRequest(} fileReq {)} ENDNATIVE
NATIVE {RequestFile} PROC
PROC RequestFile(fileReq:PTR TO filerequester) IS NATIVE {-RequestFile(} fileReq {)} ENDNATIVE !!INT
NATIVE {AllocAslRequest} PROC
PROC AllocAslRequest(reqType:ULONG, tagList:ARRAY OF tagitem) IS NATIVE {AllocAslRequest(} reqType {,} tagList {)} ENDNATIVE !!APTR2
NATIVE {FreeAslRequest} PROC
PROC FreeAslRequest(requester:APTR2) IS NATIVE {FreeAslRequest(} requester {)} ENDNATIVE
NATIVE {AslRequest} PROC
PROC AslRequest(requester:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-AslRequest(} requester {,} tagList {)} ENDNATIVE !!INT
NATIVE {AbortAslRequest} PROC
PROC AbortAslRequest(requester:APTR2) IS NATIVE {AbortAslRequest(} requester {)} ENDNATIVE
NATIVE {ActivateAslRequest} PROC
PROC ActivateAslRequest(requester:APTR2) IS NATIVE {ActivateAslRequest(} requester {)} ENDNATIVE
