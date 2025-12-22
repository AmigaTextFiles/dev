OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/intuition/cghooks', 'target/intuition/classes', 'target/intuition/classusr', 'target/intuition/extensions', 'target/intuition/gadgetclass', 'target/intuition/icclass', 'target/intuition/imageclass', 'target/intuition/intuition', 'target/intuition/intuitionbase', 'target/intuition/iobsolete', 'target/intuition/iprefs', 'target/intuition/menudecorclass', 'target/intuition/pointerclass', 'target/intuition/preferences', 'target/intuition/scrdecorclass', 'target/intuition/screens', 'target/intuition/sghooks', 'target/intuition/windecorclass'
MODULE 'target/aros/libcall', 'target/intuition/intuition', 'target/intuition/intuitionbase', 'target/intuition/screens', 'target/intuition/classes', 'target/intuition/windecorclass', 'target/intuition/scrdecorclass', 'target/intuition/menudecorclass', 'target/utility/hooks', 'target/aros/preprocessor/variadic/cast2iptr'
MODULE 'target/exec/types', 'target/aros/system', 'target/defines/intuition',
       'target/utility/tagitem', 'target/graphics/rastport', 'target/exec/ports', 'target/graphics/gfx', 'target/graphics/view', 'target/exec/lists', 'target/exec', 'target/dos/dos'
{
#include <proto/intuition.h>
}
{
struct IntuitionBase* IntuitionBase = NULL;
}
NATIVE {CLIB_INTUITION_PROTOS_H} CONST
NATIVE {PROTO_INTUITION_H} CONST
NATIVE {INTUITION_CDEF_H} CONST

NATIVE {IntuitionBase} DEF intuitionbase:NATIVE {struct IntuitionBase*} PTR TO lib

->automatic opening of intuition library
PROC new()
	intuitionbase := OpenLibrary('intuition.library', 39)
	IF intuitionbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

->automatic closing of intuition library
PROC end()
	CloseLibrary(intuitionbase)
ENDPROC


/* Prototypes for stubs in amiga.lib */
NATIVE {DoGadgetMethod} PROC
PROC DoGadgetMethod(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, MethodID:ULONG, MethodID2=0:ULONG, ...) IS NATIVE {DoGadgetMethod(} gad {,} win {,} req {,} MethodID {,} MethodID2 {,} ... {)} ENDNATIVE !!IPTR
NATIVE {SetGadgetAttrs} PROC
PROC SetGadgetAttrs(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {SetGadgetAttrs(} gad {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG

NATIVE {SetAttrs} PROC
PROC SetAttrs(obj:APTR, tag1:TAG, tag2=0:ULONG, ...) IS NATIVE {SetAttrs(} obj {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {SetSuperAttrs} PROC
->Not supported for some reason: PROC SetSuperAttrs(cl:PTR TO iclass, obj:PTR TO /*Object*/ ULONG, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {SetSuperAttrs(} cl {,} obj {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {NewObject} PROC
PROC NewObject(classPtr:PTR TO iclass, classID:PTR TO UBYTE, tag1:TAG, tag2=0:ULONG, ...) IS NATIVE {NewObject(} classPtr {,} classID {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!APTR
->#ifndef USE_BOOPSI_STUBS
NATIVE {DoMethodA} PROC
PROC DoMethodA(obj:PTR TO /*Object*/ ULONG, message/*:PTR TO msg*/) IS NATIVE {DoMethodA(} obj {, (Msg)} message {)} ENDNATIVE !!IPTR
NATIVE {DoMethod} PROC
PROC DoMethod(obj:PTR TO /*Object*/ ULONG, MethodID:ULONG, MethodID2=0:ULONG, ...) IS NATIVE {DoMethod(} obj {,} MethodID {,} MethodID2 {,} ... {)} ENDNATIVE !!IPTR
NATIVE {DoSuperMethodA} PROC
PROC DoSuperMethodA(cl:PTR TO iclass, obj:PTR TO /*Object*/ ULONG, message/*:PTR TO msg*/) IS NATIVE {DoSuperMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!IPTR
NATIVE {DoSuperMethod} PROC
PROC DoSuperMethod(cl:PTR TO iclass, obj:PTR TO /*Object*/ ULONG, MethodID:ULONG, MethodID2=0:ULONG, ...) IS NATIVE {DoSuperMethod(} cl {,} obj {,} MethodID {,} MethodID2 {,} ... {)} ENDNATIVE !!IPTR
NATIVE {CoerceMethodA} PROC
PROC CoerceMethodA(cl:PTR TO iclass, obj:PTR TO /*Object*/ ULONG, message/*:PTR TO msg*/) IS NATIVE {CoerceMethodA(} cl {,} obj {, (Msg)} message {)} ENDNATIVE !!IPTR
NATIVE {CoerceMethod} PROC
PROC CoerceMethod(cl:PTR TO iclass, obj:PTR TO /*Object*/ ULONG, MethodID:ULONG, MethodID2=0:ULONG, ...) IS NATIVE {CoerceMethod(} cl {,} obj {,} MethodID {,} MethodID2 {,} ... {)} ENDNATIVE !!IPTR
->#endif /* !USE_BOOPSI_STUBS */

NATIVE {DoSuperNewTagList} PROC
->Not supported for some reason: PROC DoSuperNewTagList(class:PTR TO iclass, object:PTR TO /*Object*/ ULONG, gadgetInfo:PTR TO gadgetinfo, tags:ARRAY OF tagitem) IS NATIVE {DoSuperNewTagList(} class {,} object {,} gadgetInfo {,} tags {)} ENDNATIVE !!IPTR
NATIVE {DoSuperNewTags} PROC
->Not supported for some reason: PROC DoSuperNewTags(class:PTR TO iclass, object:PTR TO /*Object*/ ULONG, gadgetInfo:PTR TO gadgetinfo, tag1:ULONG, tag12=0:ULONG, ...) IS NATIVE {DoSuperNewTags(} class {,} object {,} gadgetInfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!IPTR

->#ifndef CLIB_BOOPSI_PROTOS_H /* Prevent name clashes */
->NATIVE {CallHookA} PROC
->Not supported as in AmigaLib: PROC CallHookA(hook:PTR TO hook, obj:APTR, param:APTR) IS NATIVE {CallHookA(} hook {,} obj {,} param {)} ENDNATIVE !!IPTR
->NATIVE {CallHook} PROC
->Not supported as in AmigaLib: PROC CallHook(hook:PTR TO hook, obj:APTR, obj2=0:ULONG, ...) IS NATIVE {CallHook(} hook {,} obj {,} obj2 {,} ... {)} ENDNATIVE !!IPTR
->#endif

NATIVE {OpenWindowTags} PROC
PROC OpenWindowTags(newWindow:PTR TO nw, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {OpenWindowTags(} newWindow {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO window
NATIVE {OpenScreenTags} PROC
PROC OpenScreenTags(newScreen:PTR TO ns, tag1:TAG, tag12=0:ULONG, ...) IS NATIVE {OpenScreenTags(} newScreen {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO screen

NATIVE {EasyRequest} PROC
PROC EasyRequest(window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmpPtr:ARRAY OF ULONG, idcmpPtr2=0:ULONG, ...) IS NATIVE {EasyRequest(} window {,} easyStruct {,} idcmpPtr {,} idcmpPtr2 {,} ... {)} ENDNATIVE !!VALUE

NATIVE {AddGadget} PROC
PROC AddGadget(window:PTR TO window, gadget:PTR TO gadget, position:ULONG) IS NATIVE {AddGadget(} window {,} gadget {,} position {)} ENDNATIVE !!UINT
NATIVE {ClearDMRequest} PROC
PROC ClearDMRequest(window:PTR TO window) IS NATIVE {-ClearDMRequest(} window {)} ENDNATIVE !!INT
NATIVE {ClearMenuStrip} PROC
PROC ClearMenuStrip(window:PTR TO window) IS NATIVE {ClearMenuStrip(} window {)} ENDNATIVE
NATIVE {ClearPointer} PROC
PROC ClearPointer(window:PTR TO window) IS NATIVE {ClearPointer(} window {)} ENDNATIVE
NATIVE {CloseScreen} PROC
PROC CloseScreen(screen:PTR TO screen) IS NATIVE {-CloseScreen(} screen {)} ENDNATIVE !!INT
NATIVE {CloseWindow} PROC
PROC CloseWindow(window:PTR TO window) IS NATIVE {CloseWindow(} window {)} ENDNATIVE
NATIVE {CloseWorkBench} PROC
PROC CloseWorkBench() IS NATIVE {CloseWorkBench()} ENDNATIVE !!VALUE
NATIVE {CurrentTime} PROC
PROC CurrentTime(seconds:ARRAY OF ULONG, micros:ARRAY OF ULONG) IS NATIVE {CurrentTime(} seconds {,} micros {)} ENDNATIVE
NATIVE {DisplayAlert} PROC
PROC DisplayAlert(alertnumber:ULONG, string:ARRAY OF UBYTE, height:UINT) IS NATIVE {-DisplayAlert(} alertnumber {,} string {,} height {)} ENDNATIVE !!INT
NATIVE {DisplayBeep} PROC
PROC DisplayBeep(screen:PTR TO screen) IS NATIVE {DisplayBeep(} screen {)} ENDNATIVE
NATIVE {DoubleClick} PROC
PROC DoubleClick(sSeconds:ULONG, sMicros:ULONG, cSeconds:ULONG, cMicros:ULONG) IS NATIVE {-DoubleClick(} sSeconds {,} sMicros {,} cSeconds {,} cMicros {)} ENDNATIVE !!INT
NATIVE {DrawBorder} PROC
PROC DrawBorder(rp:PTR TO rastport, border:PTR TO border, leftOffset:VALUE, topOffset:VALUE) IS NATIVE {DrawBorder(} rp {,} border {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {DrawImage} PROC
PROC DrawImage(rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE) IS NATIVE {DrawImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {EndRequest} PROC
PROC EndRequest(requester:PTR TO requester, window:PTR TO window) IS NATIVE {EndRequest(} requester {,} window {)} ENDNATIVE
NATIVE {GetDefPrefs} PROC
PROC GetDefPrefs(prefbuffer:PTR TO preferences, size:INT) IS NATIVE {GetDefPrefs(} prefbuffer {,} size {)} ENDNATIVE !!PTR TO preferences
NATIVE {GetPrefs} PROC
PROC GetPrefs(prefbuffer:PTR TO preferences, size:INT) IS NATIVE {GetPrefs(} prefbuffer {,} size {)} ENDNATIVE !!PTR TO preferences
NATIVE {InitRequester} PROC
PROC InitRequester(requester:PTR TO requester) IS NATIVE {InitRequester(} requester {)} ENDNATIVE
NATIVE {ItemAddress} PROC
PROC ItemAddress(menustrip:PTR TO menu, menunumber:UINT) IS NATIVE {ItemAddress(} menustrip {,} menunumber {)} ENDNATIVE !!PTR TO menuitem
NATIVE {ModifyIDCMP} PROC
PROC ModifyIDCMP(window:PTR TO window, flags:ULONG) IS NATIVE {-ModifyIDCMP(} window {,} flags {)} ENDNATIVE !!INT
NATIVE {ModifyProp} PROC
PROC ModifyProp(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG) IS NATIVE {ModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {)} ENDNATIVE
NATIVE {MoveScreen} PROC
PROC MoveScreen(screen:PTR TO screen, dx:VALUE, dy:VALUE) IS NATIVE {MoveScreen(} screen {,} dx {,} dy {)} ENDNATIVE
NATIVE {MoveWindow} PROC
PROC MoveWindow(window:PTR TO window, dx:VALUE, dy:VALUE) IS NATIVE {MoveWindow(} window {,} dx {,} dy {)} ENDNATIVE
NATIVE {OffGadget} PROC
PROC OffGadget(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester) IS NATIVE {OffGadget(} gadget {,} window {,} requester {)} ENDNATIVE
NATIVE {OffMenu} PROC
PROC OffMenu(window:PTR TO window, menunumber:UINT) IS NATIVE {OffMenu(} window {,} menunumber {)} ENDNATIVE
NATIVE {OnGadget} PROC
PROC OnGadget(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester) IS NATIVE {OnGadget(} gadget {,} window {,} requester {)} ENDNATIVE
NATIVE {OnMenu} PROC
PROC OnMenu(window:PTR TO window, menunumber:UINT) IS NATIVE {OnMenu(} window {,} menunumber {)} ENDNATIVE
NATIVE {OpenScreen} PROC
PROC OpenScreen(newScreen:PTR TO ns) IS NATIVE {OpenScreen(} newScreen {)} ENDNATIVE !!PTR TO screen
NATIVE {OpenWindow} PROC
PROC OpenWindow(newWindow:PTR TO nw) IS NATIVE {OpenWindow(} newWindow {)} ENDNATIVE !!PTR TO window
NATIVE {OpenWorkBench} PROC
PROC OpenWorkBench() IS NATIVE {OpenWorkBench()} ENDNATIVE !!IPTR
NATIVE {PrintIText} PROC
PROC PrintIText(rp:PTR TO rastport, iText:PTR TO intuitext, leftOffset:VALUE, topOffset:VALUE) IS NATIVE {PrintIText(} rp {,} iText {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {RefreshGadgets} PROC
PROC RefreshGadgets(gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester) IS NATIVE {RefreshGadgets(} gadgets {,} window {,} requester {)} ENDNATIVE
NATIVE {RemoveGadget} PROC
PROC RemoveGadget(window:PTR TO window, gadget:PTR TO gadget) IS NATIVE {RemoveGadget(} window {,} gadget {)} ENDNATIVE !!UINT
NATIVE {ReportMouse} PROC
PROC ReportMouse(flag:VALUE, window:PTR TO window) IS NATIVE {ReportMouse(} flag {,} window {)} ENDNATIVE
NATIVE {Request} PROC
PROC Request(requester:PTR TO requester, window:PTR TO window) IS NATIVE {-Request(} requester {,} window {)} ENDNATIVE !!INT
NATIVE {ScreenToBack} PROC
PROC ScreenToBack(screen:PTR TO screen) IS NATIVE {ScreenToBack(} screen {)} ENDNATIVE
NATIVE {ScreenToFront} PROC
PROC ScreenToFront(screen:PTR TO screen) IS NATIVE {ScreenToFront(} screen {)} ENDNATIVE
NATIVE {SetDMRequest} PROC
PROC SetDMRequest(window:PTR TO window, dmrequest:PTR TO requester) IS NATIVE {-SetDMRequest(} window {,} dmrequest {)} ENDNATIVE !!INT
NATIVE {SetMenuStrip} PROC
PROC SetMenuStrip(window:PTR TO window, menu:PTR TO menu) IS NATIVE {-SetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
NATIVE {SetPointer} PROC
PROC SetPointer(window:PTR TO window, pointer:ARRAY OF UINT, height:VALUE, width:VALUE, xOffset:VALUE, yOffset:VALUE) IS NATIVE {SetPointer(} window {,} pointer {,} height {,} width {,} xOffset {,} yOffset {)} ENDNATIVE
NATIVE {SetWindowTitles} PROC
PROC SetWindowTitles(window:PTR TO window, windowTitle:/*STRPTR*/ ARRAY OF CHAR, screenTitle:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {SetWindowTitles(} window {,} windowTitle {,} screenTitle {)} ENDNATIVE
NATIVE {ShowTitle} PROC
PROC ShowTitle(screen:PTR TO screen, ShowIt:INT) IS NATIVE {ShowTitle(} screen {, -} ShowIt {)} ENDNATIVE
NATIVE {SizeWindow} PROC
PROC SizeWindow(window:PTR TO window, dx:VALUE, dy:VALUE) IS NATIVE {SizeWindow(} window {,} dx {,} dy {)} ENDNATIVE
NATIVE {ViewAddress} PROC
PROC ViewAddress() IS NATIVE {ViewAddress()} ENDNATIVE !!PTR TO view
NATIVE {ViewPortAddress} PROC
PROC ViewPortAddress(Window:PTR TO window) IS NATIVE {ViewPortAddress(} Window {)} ENDNATIVE !!PTR TO viewport
NATIVE {WindowToBack} PROC
PROC WindowToBack(window:PTR TO window) IS NATIVE {WindowToBack(} window {)} ENDNATIVE
NATIVE {WindowToFront} PROC
PROC WindowToFront(window:PTR TO window) IS NATIVE {WindowToFront(} window {)} ENDNATIVE
NATIVE {WindowLimits} PROC
PROC WindowLimits(window:PTR TO window, MinWidth:INT, MinHeight:INT, MaxWidth:UINT, MaxHeight:UINT) IS NATIVE {-WindowLimits(} window {,} MinWidth {,} MinHeight {,} MaxWidth {,} MaxHeight {)} ENDNATIVE !!INT
NATIVE {SetPrefs} PROC
PROC SetPrefs(prefbuffer:PTR TO preferences, size:VALUE, inform:INT) IS NATIVE {SetPrefs(} prefbuffer {,} size {, -} inform {)} ENDNATIVE !!PTR TO preferences
NATIVE {IntuiTextLength} PROC
PROC IntuiTextLength(iText:PTR TO intuitext) IS NATIVE {IntuiTextLength(} iText {)} ENDNATIVE !!VALUE
NATIVE {WBenchToBack} PROC
PROC WbenchToBack() IS NATIVE {-WBenchToBack()} ENDNATIVE !!INT
NATIVE {WBenchToFront} PROC
PROC WbenchToFront() IS NATIVE {-WBenchToFront()} ENDNATIVE !!INT
NATIVE {AutoRequest} PROC
PROC AutoRequest(window:PTR TO window, body:PTR TO intuitext, posText:PTR TO intuitext, negText:PTR TO intuitext, pFlag:ULONG, nFlag:ULONG, width:ULONG, height:ULONG) IS NATIVE {-AutoRequest(} window {,} body {,} posText {,} negText {,} pFlag {,} nFlag {,} width {,} height {)} ENDNATIVE !!INT
NATIVE {BeginRefresh} PROC
PROC BeginRefresh(window:PTR TO window) IS NATIVE {BeginRefresh(} window {)} ENDNATIVE
NATIVE {BuildSysRequest} PROC
PROC BuildSysRequest(window:PTR TO window, bodytext:PTR TO intuitext, postext:PTR TO intuitext, negtext:PTR TO intuitext, idcmpflags:ULONG, width:INT, height:INT) IS NATIVE {BuildSysRequest(} window {,} bodytext {,} postext {,} negtext {,} idcmpflags {,} width {,} height {)} ENDNATIVE !!PTR TO window
NATIVE {EndRefresh} PROC
PROC EndRefresh(window:PTR TO window, complete:INT) IS NATIVE {EndRefresh(} window {, -} complete {)} ENDNATIVE
NATIVE {FreeSysRequest} PROC
PROC FreeSysRequest(window:PTR TO window) IS NATIVE {FreeSysRequest(} window {)} ENDNATIVE
NATIVE {MakeScreen} PROC
PROC MakeScreen(screen:PTR TO screen) IS NATIVE {MakeScreen(} screen {)} ENDNATIVE !!VALUE
NATIVE {RemakeDisplay} PROC
PROC RemakeDisplay() IS NATIVE {RemakeDisplay()} ENDNATIVE !!VALUE
NATIVE {RethinkDisplay} PROC
PROC RethinkDisplay() IS NATIVE {RethinkDisplay()} ENDNATIVE !!VALUE
NATIVE {AllocRemember} PROC
PROC AllocRemember(rememberKey:ARRAY OF PTR TO remember, size:ULONG, flags:ULONG) IS NATIVE {AllocRemember(} rememberKey {,} size {,} flags {)} ENDNATIVE !!APTR
NATIVE {AlohaWorkbench} PROC
PROC AlohaWorkbench(wbmsgport:PTR TO mp) IS NATIVE {AlohaWorkbench(} wbmsgport {)} ENDNATIVE
NATIVE {FreeRemember} PROC
PROC FreeRemember(rememberKey:ARRAY OF PTR TO remember, reallyForget:VALUE) IS NATIVE {FreeRemember(} rememberKey {,} reallyForget {)} ENDNATIVE
NATIVE {LockIBase} PROC
PROC LockIBase(What:ULONG) IS NATIVE {LockIBase(} What {)} ENDNATIVE !!ULONG
NATIVE {UnlockIBase} PROC
PROC UnlockIBase(ibLock:ULONG) IS NATIVE {UnlockIBase(} ibLock {)} ENDNATIVE
NATIVE {GetScreenData} PROC
PROC GetScreenData(buffer:APTR, size:ULONG, type:ULONG, screen:PTR TO screen) IS NATIVE {GetScreenData(} buffer {,} size {,} type {,} screen {)} ENDNATIVE !!VALUE
NATIVE {RefreshGList} PROC
PROC RefreshGList(gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, numGad:VALUE) IS NATIVE {RefreshGList(} gadgets {,} window {,} requester {,} numGad {)} ENDNATIVE
NATIVE {AddGList} PROC
PROC AddGList(window:PTR TO window, gadget:PTR TO gadget, position:ULONG, numGad:VALUE, requester:PTR TO requester) IS NATIVE {AddGList(} window {,} gadget {,} position {,} numGad {,} requester {)} ENDNATIVE !!UINT
NATIVE {RemoveGList} PROC
PROC RemoveGList(remPtr:PTR TO window, gadget:PTR TO gadget, numGad:VALUE) IS NATIVE {RemoveGList(} remPtr {,} gadget {,} numGad {)} ENDNATIVE !!UINT
NATIVE {ActivateWindow} PROC
PROC ActivateWindow(window:PTR TO window) IS NATIVE {ActivateWindow(} window {)} ENDNATIVE
NATIVE {RefreshWindowFrame} PROC
PROC RefreshWindowFrame(window:PTR TO window) IS NATIVE {RefreshWindowFrame(} window {)} ENDNATIVE
NATIVE {ActivateGadget} PROC
PROC ActivateGadget(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester) IS NATIVE {-ActivateGadget(} gadget {,} window {,} requester {)} ENDNATIVE !!INT
NATIVE {NewModifyProp} PROC
PROC NewModifyProp(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG, numGad:VALUE) IS NATIVE {NewModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {,} numGad {)} ENDNATIVE
NATIVE {QueryOverscan} PROC
PROC QueryOverscan(displayid:ULONG, rect:PTR TO rectangle, oscantype:INT) IS NATIVE {QueryOverscan(} displayid {,} rect {,} oscantype {)} ENDNATIVE !!VALUE
NATIVE {MoveWindowInFrontOf} PROC
PROC MoveWindowInFrontOf(window:PTR TO window, behindwindow:PTR TO window) IS NATIVE {MoveWindowInFrontOf(} window {,} behindwindow {)} ENDNATIVE
NATIVE {ChangeWindowBox} PROC
PROC ChangeWindowBox(window:PTR TO window, left:VALUE, top:VALUE, width:VALUE, height:VALUE) IS NATIVE {ChangeWindowBox(} window {,} left {,} top {,} width {,} height {)} ENDNATIVE
NATIVE {SetEditHook} PROC
PROC SetEditHook(hook:PTR TO hook) IS NATIVE {SetEditHook(} hook {)} ENDNATIVE !!PTR TO hook
NATIVE {SetMouseQueue} PROC
PROC SetMouseQueue(window:PTR TO window, queuelength:UINT) IS NATIVE {SetMouseQueue(} window {,} queuelength {)} ENDNATIVE !!VALUE
NATIVE {ZipWindow} PROC
PROC ZipWindow(window:PTR TO window) IS NATIVE {ZipWindow(} window {)} ENDNATIVE
NATIVE {LockPubScreen} PROC
PROC LockPubScreen(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {LockPubScreen(} name {)} ENDNATIVE !!PTR TO screen
NATIVE {UnlockPubScreen} PROC
PROC UnlockPubScreen(name:ARRAY OF UBYTE, screen:PTR TO screen) IS NATIVE {UnlockPubScreen(} name {,} screen {)} ENDNATIVE
NATIVE {LockPubScreenList} PROC
PROC LockPubScreenList() IS NATIVE {LockPubScreenList()} ENDNATIVE !!PTR TO lh
NATIVE {UnlockPubScreenList} PROC
PROC UnlockPubScreenList() IS NATIVE {UnlockPubScreenList()} ENDNATIVE
NATIVE {NextPubScreen} PROC
PROC NextPubScreen(screen:PTR TO screen, namebuff:ARRAY OF UBYTE) IS NATIVE {NextPubScreen(} screen {,} namebuff {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {SetDefaultPubScreen} PROC
PROC SetDefaultPubScreen(name:ARRAY OF UBYTE) IS NATIVE {SetDefaultPubScreen(} name {)} ENDNATIVE
NATIVE {SetPubScreenModes} PROC
PROC SetPubScreenModes(modes:UINT) IS NATIVE {SetPubScreenModes(} modes {)} ENDNATIVE !!UINT
NATIVE {PubScreenStatus} PROC
PROC PubScreenStatus(Scr:PTR TO screen, StatusFlags:UINT) IS NATIVE {PubScreenStatus(} Scr {,} StatusFlags {)} ENDNATIVE !!UINT
NATIVE {ObtainGIRPort} PROC
PROC ObtainGIRPort(gInfo:PTR TO gadgetinfo) IS NATIVE {ObtainGIRPort(} gInfo {)} ENDNATIVE !!PTR TO rastport
NATIVE {ReleaseGIRPort} PROC
PROC ReleaseGIRPort(rp:PTR TO rastport) IS NATIVE {ReleaseGIRPort(} rp {)} ENDNATIVE
NATIVE {GadgetMouse} PROC
PROC GadgetMouse(gadget:PTR TO gadget, ginfo:PTR TO gadgetinfo, mousepoint:PTR TO INT) IS NATIVE {GadgetMouse(} gadget {,} ginfo {,} mousepoint {)} ENDNATIVE
NATIVE {SetIPrefs} PROC
PROC SetIPrefs(data:APTR, length:ULONG, type:ULONG) IS NATIVE {SetIPrefs(} data {,} length {,} type {)} ENDNATIVE !!ULONG
NATIVE {GetDefaultPubScreen} PROC
PROC GetDefaultPubScreen(nameBuffer:ARRAY OF UBYTE) IS NATIVE {GetDefaultPubScreen(} nameBuffer {)} ENDNATIVE !!PTR TO screen
NATIVE {EasyRequestArgs} PROC
PROC EasyRequestArgs(window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp_ptr:ARRAY OF ULONG, argList:RAWARG) IS NATIVE {EasyRequestArgs(} window {,} easyStruct {,} idcmp_ptr {,} argList {)} ENDNATIVE !!VALUE
NATIVE {BuildEasyRequestArgs} PROC
PROC BuildEasyRequestArgs(RefWindow:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp:ULONG, Args:RAWARG) IS NATIVE {BuildEasyRequestArgs(} RefWindow {,} easyStruct {,} idcmp {,} Args {)} ENDNATIVE !!PTR TO window
NATIVE {SysReqHandler} PROC
PROC SysReqHandler(window:PTR TO window, idcmpflagsptr:ARRAY OF ULONG, WaitInput:INT) IS NATIVE {SysReqHandler(} window {,} idcmpflagsptr {, -} WaitInput {)} ENDNATIVE !!VALUE
NATIVE {OpenWindowTagList} PROC
PROC OpenWindowTagList(newWindow:PTR TO nw, tagList:ARRAY OF tagitem) IS NATIVE {OpenWindowTagList(} newWindow {,} tagList {)} ENDNATIVE !!PTR TO window
NATIVE {OpenScreenTagList} PROC
PROC OpenScreenTagList(newScreen:PTR TO ns, tagList:ARRAY OF tagitem) IS NATIVE {OpenScreenTagList(} newScreen {,} tagList {)} ENDNATIVE !!PTR TO screen
NATIVE {DrawImageState} PROC
PROC DrawImageState(rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE, state:ULONG, drawInfo:PTR TO drawinfo) IS NATIVE {DrawImageState(} rp {,} image {,} leftOffset {,} topOffset {,} state {,} drawInfo {)} ENDNATIVE
NATIVE {PointInImage} PROC
PROC PointInImage(point:ULONG, image:PTR TO image) IS NATIVE {-PointInImage(} point {,} image {)} ENDNATIVE !!INT
NATIVE {EraseImage} PROC
PROC EraseImage(rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE) IS NATIVE {EraseImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {NewObjectA} PROC
PROC NewObjectA(classPtr:PTR TO iclass, classID:PTR TO UBYTE, tagList:ARRAY OF tagitem) IS NATIVE {NewObjectA(} classPtr {,} classID {,} tagList {)} ENDNATIVE !!APTR
NATIVE {DisposeObject} PROC
PROC DisposeObject(object:APTR) IS NATIVE {DisposeObject(} object {)} ENDNATIVE
NATIVE {SetAttrsA} PROC
PROC SetAttrsA(object:APTR, tagList:ARRAY OF tagitem) IS NATIVE {SetAttrsA(} object {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {GetAttr} PROC
PROC GetAttr(attrID:ULONG, object:PTR TO /*Object*/ ULONG, storagePtr:ARRAY) IS NATIVE {GetAttr(} attrID {,} object {, (IPTR *)} storagePtr {)} ENDNATIVE !!ULONG
NATIVE {SetGadgetAttrsA} PROC
PROC SetGadgetAttrsA(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, tagList:ARRAY OF tagitem) IS NATIVE {SetGadgetAttrsA(} gadget {,} window {,} requester {,} tagList {)} ENDNATIVE !!IPTR
NATIVE {NextObject} PROC
PROC NextObject(objectPtrPtr:APTR) IS NATIVE {NextObject(} objectPtrPtr {)} ENDNATIVE !!APTR
NATIVE {FindClass} PROC
PROC FindClass(classID:/*ClassID*/ PTR TO UBYTE) IS NATIVE {FindClass( (ClassID) } classID {)} ENDNATIVE !!PTR TO iclass
NATIVE {MakeClass} PROC
PROC MakeClass(classID:/*ClassID*/ PTR TO UBYTE, superClassID:/*ClassID*/ PTR TO UBYTE, superClassPtr:PTR TO iclass, instanceSize:ULONG, flags:ULONG) IS NATIVE {MakeClass( (ClassID) } classID {, (ClassID) } superClassID {,} superClassPtr {,} instanceSize {,} flags {)} ENDNATIVE !!PTR TO iclass
NATIVE {AddClass} PROC
PROC AddClass(classPtr:PTR TO iclass) IS NATIVE {AddClass(} classPtr {)} ENDNATIVE
NATIVE {GetScreenDrawInfo} PROC
PROC GetScreenDrawInfo(screen:PTR TO screen) IS NATIVE {GetScreenDrawInfo(} screen {)} ENDNATIVE !!PTR TO drawinfo
NATIVE {FreeScreenDrawInfo} PROC
PROC FreeScreenDrawInfo(screen:PTR TO screen, drawInfo:PTR TO drawinfo) IS NATIVE {FreeScreenDrawInfo(} screen {,} drawInfo {)} ENDNATIVE
NATIVE {ResetMenuStrip} PROC
PROC ResetMenuStrip(window:PTR TO window, menu:PTR TO menu) IS NATIVE {-ResetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
NATIVE {RemoveClass} PROC
PROC RemoveClass(classPtr:PTR TO iclass) IS NATIVE {RemoveClass(} classPtr {)} ENDNATIVE
NATIVE {FreeClass} PROC
PROC FreeClass(iclass:PTR TO iclass) IS NATIVE {-FreeClass(} iclass {)} ENDNATIVE !!INT
NATIVE {AllocScreenBuffer} PROC
PROC AllocScreenBuffer(screen:PTR TO screen, bitmap:PTR TO bitmap, flags:ULONG) IS NATIVE {AllocScreenBuffer(} screen {,} bitmap {,} flags {)} ENDNATIVE !!PTR TO screenbuffer
NATIVE {FreeScreenBuffer} PROC
PROC FreeScreenBuffer(screen:PTR TO screen, screenbuffer:PTR TO screenbuffer) IS NATIVE {FreeScreenBuffer(} screen {,} screenbuffer {)} ENDNATIVE
NATIVE {ChangeScreenBuffer} PROC
PROC ChangeScreenBuffer(screen:PTR TO screen, screenbuffer:PTR TO screenbuffer) IS NATIVE {ChangeScreenBuffer(} screen {,} screenbuffer {)} ENDNATIVE !!ULONG
NATIVE {ScreenDepth} PROC
PROC ScreenDepth(screen:PTR TO screen, flags:ULONG, reserved:APTR) IS NATIVE {ScreenDepth(} screen {,} flags {,} reserved {)} ENDNATIVE
NATIVE {ScreenPosition} PROC
PROC ScreenPosition(screen:PTR TO screen, flags:ULONG, x1:VALUE, y1:VALUE, x2:VALUE, y2:VALUE) IS NATIVE {ScreenPosition(} screen {,} flags {,} x1 {,} y1 {,} x2 {,} y2 {)} ENDNATIVE
NATIVE {ScrollWindowRaster} PROC
PROC ScrollWindowRaster(win:PTR TO window, dx:INT, dy:INT, xmin:INT, ymin:INT, xmax:INT, ymax:INT) IS NATIVE {ScrollWindowRaster(} win {,} dx {,} dy {,} xmin {,} ymin {,} xmax {,} ymax {)} ENDNATIVE
NATIVE {LendMenus} PROC
PROC LendMenus(fromwindow:PTR TO window, towindow:PTR TO window) IS NATIVE {LendMenus(} fromwindow {,} towindow {)} ENDNATIVE
NATIVE {DoGadgetMethodA} PROC
->PROC DoGadgetMethodA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, msg:msg) IS NATIVE {DoGadgetMethodA(} gad {,} win {,} req {,} msg {)} ENDNATIVE !!IPTR
NATIVE {SetWindowPointerA} PROC
PROC SetWindowPointerA(window:PTR TO window, taglist:ARRAY OF tagitem) IS NATIVE {SetWindowPointerA(} window {,} taglist {)} ENDNATIVE
NATIVE {TimedDisplayAlert} PROC
PROC TimedDisplayAlert(alertnumber:ULONG, string:ARRAY OF UBYTE, height:UINT, time:ULONG) IS NATIVE {-TimedDisplayAlert(} alertnumber {,} string {,} height {,} time {)} ENDNATIVE !!INT
NATIVE {HelpControl} PROC
PROC HelpControl(window:PTR TO window, flags:ULONG) IS NATIVE {HelpControl(} window {,} flags {)} ENDNATIVE
NATIVE {IsWindowVisible} PROC
PROC IsWindowVisible(window:PTR TO window) IS NATIVE {IsWindowVisible(} window {)} ENDNATIVE !!VALUE
NATIVE {ShowWindow} PROC
PROC ShowWindow(window:PTR TO window, other:PTR TO window) IS NATIVE {ShowWindow(} window {,} other {)} ENDNATIVE
NATIVE {HideWindow} PROC
PROC HideWindow(window:PTR TO window) IS NATIVE {HideWindow(} window {)} ENDNATIVE
NATIVE {ChangeWindowShape} PROC
PROC ChangeWindowShape(window:PTR TO window, newshape:PTR TO region, callback:PTR TO hook) IS NATIVE {ChangeWindowShape(} window {,} newshape {,} callback {)} ENDNATIVE !!PTR TO region
NATIVE {SetDefaultScreenFont} PROC
PROC SetDefaultScreenFont(textfont:PTR TO textfont) IS NATIVE {SetDefaultScreenFont(} textfont {)} ENDNATIVE
NATIVE {DoNotify} PROC
->type ICData undeclared: PROC DoNotify(cl:PTR TO iclass, o:PTR TO /*Object*/ ULONG, ic:PTR TO #ICData, msg:PTR TO opupdate) IS NATIVE {DoNotify(} cl {,} o {,} ic {,} msg {)} ENDNATIVE !!IPTR
NATIVE {FreeICData} PROC
->type ICData undeclared: PROC FreeICData(icdata:PTR TO #ICData) IS NATIVE {FreeICData(} icdata {)} ENDNATIVE
NATIVE {AllocIntuiMessage} PROC
PROC AllocIntuiMessage(window:PTR TO window) IS NATIVE {AllocIntuiMessage(} window {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {FreeIntuiMessage} PROC
PROC FreeIntuiMessage(imsg:PTR TO intuimessage) IS NATIVE {FreeIntuiMessage(} imsg {)} ENDNATIVE
NATIVE {LateIntuiInit} PROC
->removed from AROS v1.3.x: PROC LateIntuiInit(data:APTR) IS NATIVE {-LateIntuiInit(} data {)} ENDNATIVE !!INT
NATIVE {SendIntuiMessage} PROC
PROC SendIntuiMessage(window:PTR TO window, imsg:PTR TO intuimessage) IS NATIVE {SendIntuiMessage(} window {,} imsg {)} ENDNATIVE
NATIVE {ChangeDecoration} PROC
PROC ChangeDecoration(id:ULONG, decor:PTR TO newdecorator) IS NATIVE {ChangeDecoration(} id {,} decor {)} ENDNATIVE
NATIVE {WindowAction} PROC
PROC WindowAction(window:PTR TO window, action:ULONG, tags:ARRAY OF tagitem) IS NATIVE {WindowAction(} window {,} action {,} tags {)} ENDNATIVE
NATIVE {ScrollWindowRasterNoFill} PROC
PROC ScrollWindowRasterNoFill(win:PTR TO window, dx:INT, dy:INT, xmin:INT, ymin:INT, xmax:INT, ymax:INT) IS NATIVE {ScrollWindowRasterNoFill(} win {,} dx {,} dy {,} xmin {,} ymin {,} xmax {,} ymax {)} ENDNATIVE
NATIVE {SetPointerBounds} PROC
PROC SetPointerBounds(screen:PTR TO screen, rect:PTR TO rectangle, reserved:ULONG, tags:ARRAY OF tagitem) IS NATIVE {SetPointerBounds(} screen {,} rect {,} reserved {,} tags {)} ENDNATIVE !!ULONG
NATIVE {StartScreenNotifyTagList} PROC
PROC StartScreenNotifyTagList(tags:ARRAY OF tagitem) IS NATIVE {StartScreenNotifyTagList(} tags {)} ENDNATIVE !!APTR
NATIVE {EndScreenNotify} PROC
PROC EndScreenNotify(notify:APTR) IS NATIVE {-EndScreenNotify(} notify {)} ENDNATIVE !!INT
