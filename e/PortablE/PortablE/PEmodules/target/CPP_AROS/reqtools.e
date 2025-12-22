OPT NATIVE, FORCENATIVE
PUBLIC MODULE 'target/libraries/reqtools'
MODULE 'target/aros/libcall' /*, 'target/libraries/reqtools'*/
MODULE 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem', 'target/intuition/intuition'
{
#include <proto/reqtools.h>
}
{
struct ReqToolsBase* ReqToolsBase = NULL;
}
NATIVE {CLIB_REQTOOLS_PROTOS_H} CONST
NATIVE {PROTO_REQTOOLS_H} CONST

NATIVE {ReqToolsBase} DEF reqtoolsbase:NATIVE {struct ReqToolsBase*} PTR TO lib		->AmigaE does not automatically initialise this


NATIVE {PWCallBackArgs} OBJECT pwcallbackargs
ENDOBJECT
NATIVE {PWCALLBACKFUNPTR} CONST
TYPE PWCALLBACKFUNPTR IS NATIVE {PWCALLBACKFUNPTR} PTR

/* Prototypes for stubs in reqtoolsstubs.lib */

NATIVE {rtAllocRequest} PROC
PROC rtAllocRequest(type:ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtAllocRequest(} type {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {rtChangeReqAttr} PROC
PROC rtChangeReqAttr(req:APTR2, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtChangeReqAttr(} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {rtFileRequest} PROC
PROC rtFileRequest(filereq:PTR TO rtfilerequester, file:ARRAY OF CHAR, title:ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtFileRequest(} filereq {,} file {,} title {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {rtEZRequest} PROC
PROC rtEZRequest(bodyfmt:ARRAY OF CHAR, gadfmt:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem, taglist2=0:ULONG, ...) IS NATIVE {rtEZRequest(} bodyfmt {,} gadfmt {,} reqinfo {,} taglist {,} taglist2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtEZRequestTags} PROC
->#Not supported for some reason: PROC rtEZRequestTags(bodyfmt:ARRAY OF CHAR, gadfmt:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, argarray:APTR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtEZRequestTags(} bodyfmt {,} gadfmt {,} reqinfo {,} argarray {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtGetString} PROC
PROC rtGetString(buffer:PTR TO UBYTE, maxchars:ULONG, title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtGetString(} buffer {,} maxchars {,} title {,} reqinfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtGetLong} PROC
PROC rtGetLong(longptr:PTR TO ULONG, title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtGetLong(} longptr {,} title {,} reqinfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtFontRequest} PROC
PROC rtFontRequest(fontreq:PTR TO rtfontrequester, title:ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtFontRequest(} fontreq {,} title {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtPaletteRequest} PROC
PROC rtPaletteRequest(title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtPaletteRequest(} title {,} reqinfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {rtReqHandler} PROC
PROC rtReqHandler(handlerinfo:PTR TO rthandlerinfo, sigs:ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtReqHandler(} handlerinfo {,} sigs {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {rtScreenModeRequest} PROC
PROC rtScreenModeRequest(screenmodereq:PTR TO rtscreenmoderequester, title:ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {rtScreenModeRequest(} screenmodereq {,} title {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG

NATIVE {rtAllocRequestA} PROC
PROC RtAllocRequestA(type:ULONG, taglist:ARRAY OF tagitem) IS NATIVE {rtAllocRequestA(} type {,} taglist {)} ENDNATIVE !!APTR2
NATIVE {rtFreeRequest} PROC
PROC RtFreeRequest(req:APTR2) IS NATIVE {rtFreeRequest(} req {)} ENDNATIVE
NATIVE {rtFreeReqBuffer} PROC
PROC RtFreeReqBuffer(req:APTR2) IS NATIVE {rtFreeReqBuffer(} req {)} ENDNATIVE
NATIVE {rtChangeReqAttrA} PROC
PROC RtChangeReqAttrA(req:APTR2, taglist:ARRAY OF tagitem) IS NATIVE {rtChangeReqAttrA(} req {,} taglist {)} ENDNATIVE !!VALUE
NATIVE {rtFileRequestA} PROC
PROC RtFileRequestA(filereq:PTR TO rtfilerequester, file:ARRAY OF CHAR, title:ARRAY OF CHAR, taglist:ARRAY OF tagitem) IS NATIVE {rtFileRequestA(} filereq {,} file {,} title {,} taglist {)} ENDNATIVE !!APTR2
NATIVE {rtFreeFileList} PROC
PROC RtFreeFileList(selfile:PTR TO rtfilelist) IS NATIVE {rtFreeFileList(} selfile {)} ENDNATIVE
NATIVE {rtEZRequestA} PROC
PROC RtEZRequestA(bodyfmt:ARRAY OF CHAR, gadfmt:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, argarray:APTR, taglist:ARRAY OF tagitem) IS NATIVE {rtEZRequestA(} bodyfmt {,} gadfmt {,} reqinfo {,} argarray {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtGetStringA} PROC
PROC RtGetStringA(buffer:PTR TO UBYTE, maxchars:ULONG, title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem) IS NATIVE {rtGetStringA(} buffer {,} maxchars {,} title {,} reqinfo {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtGetLongA} PROC
PROC RtGetLongA(longptr:PTR TO ULONG, title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem) IS NATIVE {rtGetLongA(} longptr {,} title {,} reqinfo {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtInternalGetPasswordA} PROC
PROC rtInternalGetPasswordA(buffer:PTR TO UBYTE, checksum:ULONG, pwcallback:PWCALLBACKFUNPTR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem) IS NATIVE {-rtInternalGetPasswordA(} buffer {,} checksum {,} pwcallback {,} reqinfo {,} taglist {)} ENDNATIVE !!INT
NATIVE {rtInternalEnterPasswordA} PROC
PROC rtInternalEnterPasswordA(buffer:PTR TO UBYTE, pwcallback:PWCALLBACKFUNPTR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem) IS NATIVE {-rtInternalEnterPasswordA(} buffer {,} pwcallback {,} reqinfo {,} taglist {)} ENDNATIVE !!INT
NATIVE {rtFontRequestA} PROC
PROC RtFontRequestA(fontreq:PTR TO rtfontrequester, title:ARRAY OF CHAR, taglist:ARRAY OF tagitem) IS NATIVE {rtFontRequestA(} fontreq {,} title {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtPaletteRequestA} PROC
PROC RtPaletteRequestA(title:ARRAY OF CHAR, reqinfo:PTR TO rtreqinfo, taglist:ARRAY OF tagitem) IS NATIVE {rtPaletteRequestA(} title {,} reqinfo {,} taglist {)} ENDNATIVE !!VALUE
NATIVE {rtReqHandlerA} PROC
PROC RtReqHandlerA(handlerinfo:PTR TO rthandlerinfo, sigs:ULONG, taglist:ARRAY OF tagitem) IS NATIVE {rtReqHandlerA(} handlerinfo {,} sigs {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtSetWaitPointer} PROC
PROC RtSetWaitPointer(window:PTR TO window) IS NATIVE {rtSetWaitPointer(} window {)} ENDNATIVE
NATIVE {rtGetVScreenSize} PROC
PROC RtGetVScreenSize(screen:PTR TO screen, widthptr:PTR TO ULONG, heightptr:PTR TO ULONG) IS NATIVE {rtGetVScreenSize(} screen {,} widthptr {,} heightptr {)} ENDNATIVE !!ULONG
NATIVE {rtSetReqPosition} PROC
PROC RtSetReqPosition(reqpos:ULONG, nw:PTR TO nw, scr:PTR TO screen, win:PTR TO window) IS NATIVE {rtSetReqPosition(} reqpos {,} nw {,} scr {,} win {)} ENDNATIVE
NATIVE {rtSpread} PROC
PROC RtSpread(posarray:PTR TO ULONG, sizearray:PTR TO ULONG, totalsize:ULONG, min:ULONG, max:ULONG, num:ULONG) IS NATIVE {rtSpread(} posarray {,} sizearray {,} totalsize {,} min {,} max {,} num {)} ENDNATIVE
NATIVE {rtScreenToFrontSafely} PROC
PROC RtScreenToFrontSafely(screen:PTR TO screen) IS NATIVE {rtScreenToFrontSafely(} screen {)} ENDNATIVE
NATIVE {rtScreenModeRequestA} PROC
PROC RtScreenModeRequestA(screenmodereq:PTR TO rtscreenmoderequester, title:ARRAY OF CHAR, taglist:ARRAY OF tagitem) IS NATIVE {rtScreenModeRequestA(} screenmodereq {,} title {,} taglist {)} ENDNATIVE !!ULONG
NATIVE {rtCloseWindowSafely} PROC
PROC RtCloseWindowSafely(window:PTR TO window) IS NATIVE {rtCloseWindowSafely(} window {)} ENDNATIVE
NATIVE {rtLockWindow} PROC
PROC RtLockWindow(window:PTR TO window) IS NATIVE {rtLockWindow(} window {)} ENDNATIVE !!APTR2
NATIVE {rtUnlockWindow} PROC
PROC RtUnlockWindow(window:PTR TO window, windowlock:APTR2) IS NATIVE {rtUnlockWindow(} window {,} windowlock {)} ENDNATIVE
NATIVE {rtLockPrefs} PROC
PROC RtLockPrefs() IS NATIVE {rtLockPrefs()} ENDNATIVE !!PTR TO reqtoolsprefs
NATIVE {rtUnlockPrefs} PROC
PROC RtUnlockPrefs() IS NATIVE {rtUnlockPrefs()} ENDNATIVE
