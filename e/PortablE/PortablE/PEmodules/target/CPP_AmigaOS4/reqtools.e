/* $Filename: clib/reqtools_protos.h $Release: 2.5 $Revision: 38.11 $ */
OPT NATIVE, FORCENATIVE
PUBLIC MODULE 'target/libraries/reqtools'
MODULE 'target/utility/tagitem'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types', 'target/intuition/intuition'
{
#include <proto/reqtools.h>
}
{
struct Library* ReqToolsBase = NULL;
struct ReqtoolsIFace* IReqtools = NULL;
}
NATIVE {CLIB_REQTOOLS_PROTOS_H} CONST
NATIVE {PROTO_REQTOOLS_H} CONST
NATIVE {INLINE4_REQTOOLS_H} CONST
NATIVE {REQTOOLS_INTERFACE_DEF_H} CONST

NATIVE {ReqToolsBase} DEF reqtoolsbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IReqtools} DEF

PROC new()
	InitLibrary('reqtools.library', NATIVE {(struct Interface **) &IReqtools} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {rtAllocRequestA} PROC
PROC RtAllocRequestA(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IReqtools->rtAllocRequestA(} param1 {,} param2 {)} ENDNATIVE !!APTR2
->NATIVE {rtFreeRequest} PROC
PROC RtFreeRequest(param1:APTR2) IS NATIVE {IReqtools->rtFreeRequest(} param1 {)} ENDNATIVE
->NATIVE {rtFreeReqBuffer} PROC
PROC RtFreeReqBuffer(param1:APTR2) IS NATIVE {IReqtools->rtFreeReqBuffer(} param1 {)} ENDNATIVE
->NATIVE {rtChangeReqAttrA} PROC
PROC RtChangeReqAttrA(param1:APTR2, param2:ARRAY OF tagitem) IS NATIVE {IReqtools->rtChangeReqAttrA(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->NATIVE {rtFileRequestA} PROC
PROC RtFileRequestA(param1:PTR TO rtfilerequester,param2:ARRAY OF CHAR,param3:ARRAY OF CHAR,param4:ARRAY OF tagitem) IS NATIVE {IReqtools->rtFileRequestA(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!APTR2
->NATIVE {rtFreeFileList} PROC
PROC RtFreeFileList(param1:PTR TO rtfilelist) IS NATIVE {IReqtools->rtFreeFileList(} param1 {)} ENDNATIVE
->NATIVE {rtEZRequestA} PROC
PROC RtEZRequestA(param1:ARRAY OF CHAR,param2:ARRAY OF CHAR,param3:PTR TO rtreqinfo,param4:APTR,param5:ARRAY OF tagitem) IS NATIVE {IReqtools->rtEZRequestA(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {)} ENDNATIVE !!ULONG
->NATIVE {rtGetStringA} PROC
PROC RtGetStringA(param1:PTR TO UBYTE,param2:ULONG,param3:ARRAY OF CHAR,param4:PTR TO rtreqinfo,param5:ARRAY OF tagitem) IS NATIVE {IReqtools->rtGetStringA(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {)} ENDNATIVE !!ULONG
->NATIVE {rtGetLongA} PROC
PROC RtGetLongA(param1:PTR TO ULONG, param2:ARRAY OF CHAR, param3:PTR TO rtreqinfo, param4:ARRAY OF tagitem) IS NATIVE {IReqtools->rtGetLongA(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
->NATIVE {rtFontRequestA} PROC
PROC RtFontRequestA(param1:PTR TO rtfontrequester, param2:ARRAY OF CHAR, param3:ARRAY OF tagitem) IS NATIVE {IReqtools->rtFontRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
->NATIVE {rtPaletteRequestA} PROC
PROC RtPaletteRequestA(param1:ARRAY OF CHAR, param2:PTR TO rtreqinfo, param3:ARRAY OF tagitem) IS NATIVE {IReqtools->rtPaletteRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
->NATIVE {rtReqHandlerA} PROC
PROC RtReqHandlerA(param1:PTR TO rthandlerinfo, param2:ULONG, param3:ARRAY OF tagitem) IS NATIVE {IReqtools->rtReqHandlerA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
->NATIVE {rtSetWaitPointer} PROC
PROC RtSetWaitPointer(param1:PTR TO window) IS NATIVE {IReqtools->rtSetWaitPointer(} param1 {)} ENDNATIVE
->NATIVE {rtGetVScreenSize} PROC
PROC RtGetVScreenSize(param1:PTR TO screen, param2:PTR TO ULONG, param3:PTR TO ULONG) IS NATIVE {IReqtools->rtGetVScreenSize(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
->NATIVE {rtSetReqPosition} PROC
PROC RtSetReqPosition(param1:ULONG, param2:PTR TO nw, param3:PTR TO screen, param4:PTR TO window) IS NATIVE {IReqtools->rtSetReqPosition(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE
->NATIVE {rtSpread} PROC
PROC RtSpread(param1:PTR TO ULONG, param2:PTR TO ULONG, param3:ULONG, param4:ULONG, param5:ULONG, param6:ULONG) IS NATIVE {IReqtools->rtSpread(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {)} ENDNATIVE
->NATIVE {rtScreenToFrontSafely} PROC
PROC RtScreenToFrontSafely(param1:PTR TO screen) IS NATIVE {IReqtools->rtScreenToFrontSafely(} param1 {)} ENDNATIVE
->NATIVE {rtScreenModeRequestA} PROC
PROC RtScreenModeRequestA(param1:PTR TO rtscreenmoderequester, param2:ARRAY OF CHAR, param3:ARRAY OF tagitem) IS NATIVE {IReqtools->rtScreenModeRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
->NATIVE {rtCloseWindowSafely} PROC
PROC RtCloseWindowSafely(param1:PTR TO window) IS NATIVE {IReqtools->rtCloseWindowSafely(} param1 {)} ENDNATIVE
->NATIVE {rtLockWindow} PROC
PROC RtLockWindow(param1:PTR TO window) IS NATIVE {IReqtools->rtLockWindow(} param1 {)} ENDNATIVE !!APTR2
->NATIVE {rtUnlockWindow} PROC
PROC RtUnlockWindow(param1:PTR TO window, param2:APTR2) IS NATIVE {IReqtools->rtUnlockWindow(} param1 {,} param2 {)} ENDNATIVE

/* private functions */

->NATIVE {rtLockPrefs} PROC
->PROC RtLockPrefs() IS NATIVE {IReqtools->rtLockPrefs()} ENDNATIVE !!PTR TO reqtoolsprefs
->NATIVE {rtUnlockPrefs} PROC
->PROC RtUnlockPrefs() IS NATIVE {IReqtools->rtUnlockPrefs()} ENDNATIVE

/* functions with varargs in reqtools.lib and reqtoolsnb.lib */

->NATIVE {rtAllocRequest} PROC
PROC rtAllocRequest(param1:ULONG, param2:TAG,param22=0:ULONG, ...) IS NATIVE {IReqtools->rtAllocRequest(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {rtChangeReqAttr} PROC
PROC rtChangeReqAttr(param1:APTR2, param2:TAG,param22=0:ULONG, ...) IS NATIVE {IReqtools->rtChangeReqAttr(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {rtFileRequest} PROC
PROC rtFileRequest(param1:PTR TO rtfilerequester, param2:ARRAY OF CHAR, param3:ARRAY OF CHAR, param4:TAG,param42=0:ULONG, ...) IS NATIVE {IReqtools->rtFileRequest(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {rtEZRequest} PROC
PROC rtEZRequest(param1:ARRAY OF CHAR, param2:ARRAY OF CHAR, param3:PTR TO rtreqinfo, param4:ARRAY OF tagitem,param42=0:ULONG, ...) IS NATIVE {IReqtools->rtEZRequest(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtEZRequestTags} PROC
->#Not supported for some reason: PROC rtEZRequestTags(param1:ARRAY OF CHAR, param2:ARRAY OF CHAR, param3:PTR TO rtreqinfo, param4:APTR, param5:TAG,param52=0:ULONG, ...) IS NATIVE {IReqtools->rtEZRequestTags(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param52 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtGetString} PROC
PROC rtGetString(param1:PTR TO UBYTE, param2:ULONG, param3:ARRAY OF CHAR, param4:PTR TO rtreqinfo, param5:TAG,param52=0:ULONG, ...) IS NATIVE {IReqtools->rtGetString(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param52 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtGetLong} PROC
PROC rtGetLong(param1:PTR TO ULONG, param2:ARRAY OF CHAR, param3:PTR TO rtreqinfo, param4:TAG,param42=0:ULONG, ...) IS NATIVE {IReqtools->rtGetLong(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtFontRequest} PROC
PROC rtFontRequest(param1:PTR TO rtfontrequester, param2:ARRAY OF CHAR, param3:TAG,param32=0:ULONG, ...) IS NATIVE {IReqtools->rtFontRequest(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtPaletteRequest} PROC
PROC rtPaletteRequest(param1:ARRAY OF CHAR, param2:PTR TO rtreqinfo, param3:TAG,param32=0:ULONG, ...) IS NATIVE {IReqtools->rtPaletteRequest(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {rtReqHandler} PROC
PROC rtReqHandler(param1:PTR TO rthandlerinfo, param2:ULONG, param3:TAG,param32=0:ULONG, ...) IS NATIVE {IReqtools->rtReqHandler(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {rtScreenModeRequest} PROC
PROC rtScreenModeRequest(param1:PTR TO rtscreenmoderequester, param2:ARRAY OF CHAR, param3:TAG,param32=0:ULONG, ...) IS NATIVE {IReqtools->rtScreenModeRequest(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!ULONG
