/* $Filename: clib/reqtools_protos.h $Release: 2.5 $Revision: 38.11 $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/reqtools'
MODULE 'target/utility/tagitem'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/intuition/intuition'
{MODULE 'reqtools'}

NATIVE {reqtoolsbase} DEF reqtoolsbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {RtAllocRequestA} PROC
PROC RtAllocRequestA(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {RtAllocRequestA(} param1 {,} param2 {)} ENDNATIVE !!APTR2
NATIVE {RtFreeRequest} PROC
PROC RtFreeRequest(param1:APTR2) IS NATIVE {RtFreeRequest(} param1 {)} ENDNATIVE
NATIVE {RtFreeReqBuffer} PROC
PROC RtFreeReqBuffer(param1:APTR2) IS NATIVE {RtFreeReqBuffer(} param1 {)} ENDNATIVE
NATIVE {RtChangeReqAttrA} PROC
PROC RtChangeReqAttrA(param1:APTR2, param2:ARRAY OF tagitem) IS NATIVE {RtChangeReqAttrA(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {RtFileRequestA} PROC
PROC RtFileRequestA(param1:PTR TO rtfilerequester,param2:ARRAY OF CHAR,param3:ARRAY OF CHAR,param4:ARRAY OF tagitem) IS NATIVE {RtFileRequestA(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!APTR2
NATIVE {RtFreeFileList} PROC
PROC RtFreeFileList(param1:PTR TO rtfilelist) IS NATIVE {RtFreeFileList(} param1 {)} ENDNATIVE
NATIVE {RtEZRequestA} PROC
PROC RtEZRequestA(param1:ARRAY OF CHAR,param2:ARRAY OF CHAR,param3:PTR TO rtreqinfo,param4:APTR,param5:ARRAY OF tagitem) IS NATIVE {RtEZRequestA(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {)} ENDNATIVE !!ULONG
NATIVE {RtGetStringA} PROC
PROC RtGetStringA(param1:PTR TO UBYTE,param2:ULONG,param3:ARRAY OF CHAR,param4:PTR TO rtreqinfo,param5:ARRAY OF tagitem) IS NATIVE {RtGetStringA(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {)} ENDNATIVE !!ULONG
NATIVE {RtGetLongA} PROC
PROC RtGetLongA(param1:PTR TO ULONG, param2:ARRAY OF CHAR, param3:PTR TO rtreqinfo, param4:ARRAY OF tagitem) IS NATIVE {RtGetLongA(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
NATIVE {RtFontRequestA} PROC
PROC RtFontRequestA(param1:PTR TO rtfontrequester, param2:ARRAY OF CHAR, param3:ARRAY OF tagitem) IS NATIVE {RtFontRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
NATIVE {RtPaletteRequestA} PROC
PROC RtPaletteRequestA(param1:ARRAY OF CHAR, param2:PTR TO rtreqinfo, param3:ARRAY OF tagitem) IS NATIVE {RtPaletteRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
NATIVE {RtReqHandlerA} PROC
PROC RtReqHandlerA(param1:PTR TO rthandlerinfo, param2:ULONG, param3:ARRAY OF tagitem) IS NATIVE {RtReqHandlerA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
NATIVE {RtSetWaitPointer} PROC
PROC RtSetWaitPointer(param1:PTR TO window) IS NATIVE {RtSetWaitPointer(} param1 {)} ENDNATIVE
NATIVE {RtGetVScreenSize} PROC
PROC RtGetVScreenSize(param1:PTR TO screen, param2:PTR TO ULONG, param3:PTR TO ULONG) IS NATIVE {RtGetVScreenSize(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
NATIVE {RtSetReqPosition} PROC
PROC RtSetReqPosition(param1:ULONG, param2:PTR TO nw, param3:PTR TO screen, param4:PTR TO window) IS NATIVE {RtSetReqPosition(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE
NATIVE {RtSpread} PROC
PROC RtSpread(param1:PTR TO ULONG, param2:PTR TO ULONG, param3:ULONG, param4:ULONG, param5:ULONG, param6:ULONG) IS NATIVE {RtSpread(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {)} ENDNATIVE
NATIVE {RtScreenToFrontSafely} PROC
PROC RtScreenToFrontSafely(param1:PTR TO screen) IS NATIVE {RtScreenToFrontSafely(} param1 {)} ENDNATIVE
NATIVE {RtScreenModeRequestA} PROC
PROC RtScreenModeRequestA(param1:PTR TO rtscreenmoderequester, param2:ARRAY OF CHAR, param3:ARRAY OF tagitem) IS NATIVE {RtScreenModeRequestA(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!ULONG
NATIVE {RtCloseWindowSafely} PROC
PROC RtCloseWindowSafely(param1:PTR TO window) IS NATIVE {RtCloseWindowSafely(} param1 {)} ENDNATIVE
NATIVE {RtLockWindow} PROC
PROC RtLockWindow(param1:PTR TO window) IS NATIVE {RtLockWindow(} param1 {)} ENDNATIVE !!APTR2
NATIVE {RtUnlockWindow} PROC
PROC RtUnlockWindow(param1:PTR TO window, param2:APTR2) IS NATIVE {RtUnlockWindow(} param1 {,} param2 {)} ENDNATIVE

/* private functions */

NATIVE {RtLockPrefs} PROC
PROC RtLockPrefs() IS NATIVE {RtLockPrefs()} ENDNATIVE !!PTR TO reqtoolsprefs
NATIVE {RtUnlockPrefs} PROC
PROC RtUnlockPrefs() IS NATIVE {RtUnlockPrefs()} ENDNATIVE
