/* $VER: intuition_protos.h 40.1 (17.5.1996) */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/intuition/cghooks', 'target/intuition/classes', 'target/intuition/classusr', 'target/intuition/gadgetclass', 'target/intuition/icclass', 'target/intuition/imageclass', 'target/intuition/intuition', 'target/intuition/intuitionbase', 'target/intuition/iobsolete', 'target/intuition/pointerclass', 'target/intuition/preferences', 'target/intuition/screens', 'target/intuition/sghooks'
MODULE 'target/intuition/intuition', 'target/intuition/classes', 'target/intuition/cghooks', 'target/intuition/classusr'
MODULE 'target/devices/inputevent', 'target/graphics/rastport', 'target/graphics/gfx', 'target/utility/hooks', 'target/utility/tagitem', 'target/graphics/view', 'target/exec/lists', 'target/exec', 'target/dos/dos'
{
#include <proto/intuition.h>
}
{
struct IntuitionBase* IntuitionBase = NULL;
}
NATIVE {CLIB_INTUITION_PROTOS_H} CONST
NATIVE {_PROTO_INTUITION_H} CONST
NATIVE {PRAGMA_INTUITION_H} CONST
NATIVE {PRAGMAS_INTUITION_PRAGMAS_H} CONST

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

/* Public functions OpenIntuition() and Intuition() are intentionally */
/* not documented. */
NATIVE {OpenIntuition} PROC
PROC OpenIntuition( ) IS NATIVE {OpenIntuition()} ENDNATIVE
NATIVE {Intuition} PROC
PROC Intuition( iEvent:PTR TO inputevent ) IS NATIVE {Intuition(} iEvent {)} ENDNATIVE
NATIVE {AddGadget} PROC
PROC AddGadget( window:PTR TO window, gadget:PTR TO gadget, position:ULONG ) IS NATIVE {AddGadget(} window {,} gadget {,} position {)} ENDNATIVE !!UINT
NATIVE {ClearDMRequest} PROC
PROC ClearDMRequest( window:PTR TO window ) IS NATIVE {-ClearDMRequest(} window {)} ENDNATIVE !!INT
NATIVE {ClearMenuStrip} PROC
PROC ClearMenuStrip( window:PTR TO window ) IS NATIVE {ClearMenuStrip(} window {)} ENDNATIVE
NATIVE {ClearPointer} PROC
PROC ClearPointer( window:PTR TO window ) IS NATIVE {ClearPointer(} window {)} ENDNATIVE
NATIVE {CloseScreen} PROC
PROC CloseScreen( screen:PTR TO screen ) IS NATIVE {-CloseScreen(} screen {)} ENDNATIVE !!INT
NATIVE {CloseWindow} PROC
PROC CloseWindow( window:PTR TO window ) IS NATIVE {CloseWindow(} window {)} ENDNATIVE
NATIVE {CloseWorkBench} PROC
PROC CloseWorkBench( ) IS NATIVE {CloseWorkBench()} ENDNATIVE !!VALUE
NATIVE {CurrentTime} PROC
PROC CurrentTime( seconds:ARRAY OF ULONG, micros:ARRAY OF ULONG ) IS NATIVE {CurrentTime(} seconds {,} micros {)} ENDNATIVE
NATIVE {DisplayAlert} PROC
PROC DisplayAlert( alertNumber:ULONG, string:/*STRPTR*/ ARRAY OF CHAR, height:ULONG ) IS NATIVE {-DisplayAlert(} alertNumber {,} string {,} height {)} ENDNATIVE !!INT
NATIVE {DisplayBeep} PROC
PROC DisplayBeep( screen:PTR TO screen ) IS NATIVE {DisplayBeep(} screen {)} ENDNATIVE
NATIVE {DoubleClick} PROC
PROC DoubleClick( sSeconds:ULONG, sMicros:ULONG, cSeconds:ULONG, cMicros:ULONG ) IS NATIVE {-DoubleClick(} sSeconds {,} sMicros {,} cSeconds {,} cMicros {)} ENDNATIVE !!INT
NATIVE {DrawBorder} PROC
PROC DrawBorder( rp:PTR TO rastport, border:PTR TO border, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {DrawBorder(} rp {,} border {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {DrawImage} PROC
PROC DrawImage( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {DrawImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE
NATIVE {EndRequest} PROC
PROC EndRequest( requester:PTR TO requester, window:PTR TO window ) IS NATIVE {EndRequest(} requester {,} window {)} ENDNATIVE
NATIVE {GetDefPrefs} PROC
PROC GetDefPrefs( preferences:PTR TO preferences, size:VALUE ) IS NATIVE {GetDefPrefs(} preferences {,} size {)} ENDNATIVE !!PTR TO preferences
NATIVE {GetPrefs} PROC
PROC GetPrefs( preferences:PTR TO preferences, size:VALUE ) IS NATIVE {GetPrefs(} preferences {,} size {)} ENDNATIVE !!PTR TO preferences
NATIVE {InitRequester} PROC
PROC InitRequester( requester:PTR TO requester ) IS NATIVE {InitRequester(} requester {)} ENDNATIVE
NATIVE {ItemAddress} PROC
PROC ItemAddress( menuStrip:PTR TO menu, menuNumber:ULONG ) IS NATIVE {ItemAddress(} menuStrip {,} menuNumber {)} ENDNATIVE !!PTR TO menuitem
NATIVE {ModifyIDCMP} PROC
PROC ModifyIDCMP( window:PTR TO window, flags:ULONG ) IS NATIVE {-ModifyIDCMP(} window {,} flags {)} ENDNATIVE !!INT
NATIVE {ModifyProp} PROC
PROC ModifyProp( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG ) IS NATIVE {ModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {)} ENDNATIVE
NATIVE {MoveScreen} PROC
PROC MoveScreen( screen:PTR TO screen, dx:VALUE, dy:VALUE ) IS NATIVE {MoveScreen(} screen {,} dx {,} dy {)} ENDNATIVE
NATIVE {MoveWindow} PROC
PROC MoveWindow( window:PTR TO window, dx:VALUE, dy:VALUE ) IS NATIVE {MoveWindow(} window {,} dx {,} dy {)} ENDNATIVE
NATIVE {OffGadget} PROC
PROC OffGadget( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {OffGadget(} gadget {,} window {,} requester {)} ENDNATIVE
NATIVE {OffMenu} PROC
PROC OffMenu( window:PTR TO window, menuNumber:ULONG ) IS NATIVE {OffMenu(} window {,} menuNumber {)} ENDNATIVE
NATIVE {OnGadget} PROC
PROC OnGadget( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {OnGadget(} gadget {,} window {,} requester {)} ENDNATIVE
NATIVE {OnMenu} PROC
PROC OnMenu( window:PTR TO window, menuNumber:ULONG ) IS NATIVE {OnMenu(} window {,} menuNumber {)} ENDNATIVE
NATIVE {OpenScreen} PROC
PROC OpenScreen( newScreen:PTR TO ns ) IS NATIVE {OpenScreen(} newScreen {)} ENDNATIVE !!PTR TO screen
NATIVE {OpenWindow} PROC
PROC OpenWindow( newWindow:PTR TO nw ) IS NATIVE {OpenWindow(} newWindow {)} ENDNATIVE !!PTR TO window
NATIVE {OpenWorkBench} PROC
PROC OpenWorkBench( ) IS NATIVE {OpenWorkBench()} ENDNATIVE !!ULONG
NATIVE {PrintIText} PROC
PROC PrintIText( rp:PTR TO rastport, iText:PTR TO intuitext, left:VALUE, top:VALUE ) IS NATIVE {PrintIText(} rp {,} iText {,} left {,} top {)} ENDNATIVE
NATIVE {RefreshGadgets} PROC
PROC RefreshGadgets( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {RefreshGadgets(} gadgets {,} window {,} requester {)} ENDNATIVE
NATIVE {RemoveGadget} PROC
PROC RemoveGadget( window:PTR TO window, gadget:PTR TO gadget ) IS NATIVE {RemoveGadget(} window {,} gadget {)} ENDNATIVE !!UINT
/* The official calling sequence for ReportMouse is given below. */
/* Note the register order.  For the complete story, read the ReportMouse */
/* autodoc. */
NATIVE {ReportMouse} PROC
PROC ReportMouse( flag:VALUE, window:PTR TO window ) IS NATIVE {ReportMouse(} flag {,} window {)} ENDNATIVE
NATIVE {ReportMouse1} PROC
->Wrong param order: PROC ReportMouse1( window:PTR TO window, flag:VALUE ) IS NATIVE {ReportMouse1(} window {,} flag {)} ENDNATIVE
NATIVE {Request} PROC
PROC Request( requester:PTR TO requester, window:PTR TO window ) IS NATIVE {-Request(} requester {,} window {)} ENDNATIVE !!INT
NATIVE {ScreenToBack} PROC
PROC ScreenToBack( screen:PTR TO screen ) IS NATIVE {ScreenToBack(} screen {)} ENDNATIVE
NATIVE {ScreenToFront} PROC
PROC ScreenToFront( screen:PTR TO screen ) IS NATIVE {ScreenToFront(} screen {)} ENDNATIVE
NATIVE {SetDMRequest} PROC
PROC SetDMRequest( window:PTR TO window, requester:PTR TO requester ) IS NATIVE {-SetDMRequest(} window {,} requester {)} ENDNATIVE !!INT
NATIVE {SetMenuStrip} PROC
PROC SetMenuStrip( window:PTR TO window, menu:PTR TO menu ) IS NATIVE {-SetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
NATIVE {SetPointer} PROC
PROC SetPointer( window:PTR TO window, pointer:ARRAY OF UINT, height:VALUE, width:VALUE, xOffset:VALUE, yOffset:VALUE ) IS NATIVE {SetPointer(} window {,} pointer {,} height {,} width {,} xOffset {,} yOffset {)} ENDNATIVE
NATIVE {SetWindowTitles} PROC
PROC SetWindowTitles( window:PTR TO window, windowTitle:/*STRPTR*/ ARRAY OF CHAR, screenTitle:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {SetWindowTitles(} window {,} windowTitle {,} screenTitle {)} ENDNATIVE
NATIVE {ShowTitle} PROC
PROC ShowTitle( screen:PTR TO screen, showIt:VALUE ) IS NATIVE {ShowTitle(} screen {,} showIt {)} ENDNATIVE
NATIVE {SizeWindow} PROC
PROC SizeWindow( window:PTR TO window, dx:VALUE, dy:VALUE ) IS NATIVE {SizeWindow(} window {,} dx {,} dy {)} ENDNATIVE
NATIVE {ViewAddress} PROC
PROC ViewAddress( ) IS NATIVE {ViewAddress()} ENDNATIVE !!PTR TO view
NATIVE {ViewPortAddress} PROC
PROC ViewPortAddress( window:PTR TO window ) IS NATIVE {ViewPortAddress(} window {)} ENDNATIVE !!PTR TO viewport
NATIVE {WindowToBack} PROC
PROC WindowToBack( window:PTR TO window ) IS NATIVE {WindowToBack(} window {)} ENDNATIVE
NATIVE {WindowToFront} PROC
PROC WindowToFront( window:PTR TO window ) IS NATIVE {WindowToFront(} window {)} ENDNATIVE
NATIVE {WindowLimits} PROC
PROC WindowLimits( window:PTR TO window, widthMin:VALUE, heightMin:VALUE, widthMax:ULONG, heightMax:ULONG ) IS NATIVE {-WindowLimits(} window {,} widthMin {,} heightMin {,} widthMax {,} heightMax {)} ENDNATIVE !!INT
/*--- start of next generation of names -------------------------------------*/
NATIVE {SetPrefs} PROC
PROC SetPrefs( preferences:PTR TO preferences, size:VALUE, inform:VALUE ) IS NATIVE {SetPrefs(} preferences {,} size {,} inform {)} ENDNATIVE !!PTR TO preferences
/*--- start of next next generation of names --------------------------------*/
NATIVE {IntuiTextLength} PROC
PROC IntuiTextLength( iText:PTR TO intuitext ) IS NATIVE {IntuiTextLength(} iText {)} ENDNATIVE !!VALUE
NATIVE {WBenchToBack} PROC
PROC WbenchToBack( ) IS NATIVE {-WBenchToBack()} ENDNATIVE !!INT
NATIVE {WBenchToFront} PROC
PROC WbenchToFront( ) IS NATIVE {-WBenchToFront()} ENDNATIVE !!INT
/*--- start of next next next generation of names ---------------------------*/
NATIVE {AutoRequest} PROC
PROC AutoRequest( window:PTR TO window, body:PTR TO intuitext, posText:PTR TO intuitext, negText:PTR TO intuitext, pFlag:ULONG, nFlag:ULONG, width:ULONG, height:ULONG ) IS NATIVE {-AutoRequest(} window {,} body {,} posText {,} negText {,} pFlag {,} nFlag {,} width {,} height {)} ENDNATIVE !!INT
NATIVE {BeginRefresh} PROC
PROC BeginRefresh( window:PTR TO window ) IS NATIVE {BeginRefresh(} window {)} ENDNATIVE
NATIVE {BuildSysRequest} PROC
PROC BuildSysRequest( window:PTR TO window, body:PTR TO intuitext, posText:PTR TO intuitext, negText:PTR TO intuitext, flags:ULONG, width:ULONG, height:ULONG ) IS NATIVE {BuildSysRequest(} window {,} body {,} posText {,} negText {,} flags {,} width {,} height {)} ENDNATIVE !!PTR TO window
NATIVE {EndRefresh} PROC
PROC EndRefresh( window:PTR TO window, complete:VALUE ) IS NATIVE {EndRefresh(} window {,} complete {)} ENDNATIVE
NATIVE {FreeSysRequest} PROC
PROC FreeSysRequest( window:PTR TO window ) IS NATIVE {FreeSysRequest(} window {)} ENDNATIVE
/* The return codes for MakeScreen(), RemakeDisplay(), and RethinkDisplay() */
/* are only valid under V39 and greater.  Do not examine them when running */
/* on pre-V39 systems! */
NATIVE {MakeScreen} PROC
PROC MakeScreen( screen:PTR TO screen ) IS NATIVE {MakeScreen(} screen {)} ENDNATIVE !!VALUE
NATIVE {RemakeDisplay} PROC
PROC RemakeDisplay( ) IS NATIVE {RemakeDisplay()} ENDNATIVE !!VALUE
NATIVE {RethinkDisplay} PROC
PROC RethinkDisplay( ) IS NATIVE {RethinkDisplay()} ENDNATIVE !!VALUE
/*--- start of next next next next generation of names ----------------------*/
NATIVE {AllocRemember} PROC
PROC AllocRemember( rememberKey:ARRAY OF PTR TO remember, size:ULONG, flags:ULONG ) IS NATIVE {AllocRemember(} rememberKey {,} size {,} flags {)} ENDNATIVE !!APTR
NATIVE {FreeRemember} PROC
PROC FreeRemember( rememberKey:ARRAY OF PTR TO remember, reallyForget:VALUE ) IS NATIVE {FreeRemember(} rememberKey {,} reallyForget {)} ENDNATIVE
/*--- start of 15 Nov 85 names ------------------------*/
NATIVE {LockIBase} PROC
PROC LockIBase( dontknow:ULONG ) IS NATIVE {LockIBase(} dontknow {)} ENDNATIVE !!ULONG
NATIVE {UnlockIBase} PROC
PROC UnlockIBase( ibLock:ULONG ) IS NATIVE {UnlockIBase(} ibLock {)} ENDNATIVE
/*--- functions in V33 or higher (Release 1.2) ---*/
NATIVE {GetScreenData} PROC
PROC GetScreenData( buffer:APTR, size:ULONG, type:ULONG, screen:PTR TO screen ) IS NATIVE {GetScreenData(} buffer {,} size {,} type {,} screen {)} ENDNATIVE !!VALUE
NATIVE {RefreshGList} PROC
PROC RefreshGList( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, numGad:VALUE ) IS NATIVE {RefreshGList(} gadgets {,} window {,} requester {,} numGad {)} ENDNATIVE
NATIVE {AddGList} PROC
PROC AddGList( window:PTR TO window, gadget:PTR TO gadget, position:ULONG, numGad:VALUE, requester:PTR TO requester ) IS NATIVE {AddGList(} window {,} gadget {,} position {,} numGad {,} requester {)} ENDNATIVE !!UINT
NATIVE {RemoveGList} PROC
PROC RemoveGList( remPtr:PTR TO window, gadget:PTR TO gadget, numGad:VALUE ) IS NATIVE {RemoveGList(} remPtr {,} gadget {,} numGad {)} ENDNATIVE !!UINT
NATIVE {ActivateWindow} PROC
PROC ActivateWindow( window:PTR TO window ) IS NATIVE {ActivateWindow(} window {)} ENDNATIVE
NATIVE {RefreshWindowFrame} PROC
PROC RefreshWindowFrame( window:PTR TO window ) IS NATIVE {RefreshWindowFrame(} window {)} ENDNATIVE
NATIVE {ActivateGadget} PROC
PROC ActivateGadget( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {-ActivateGadget(} gadgets {,} window {,} requester {)} ENDNATIVE !!INT
NATIVE {NewModifyProp} PROC
PROC NewModifyProp( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG, numGad:VALUE ) IS NATIVE {NewModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {,} numGad {)} ENDNATIVE
/*--- functions in V36 or higher (Release 2.0) ---*/
NATIVE {QueryOverscan} PROC
PROC QueryOverscan( displayID:ULONG, rect:PTR TO rectangle, oScanType:VALUE ) IS NATIVE {QueryOverscan(} displayID {,} rect {,} oScanType {)} ENDNATIVE !!VALUE
NATIVE {MoveWindowInFrontOf} PROC
PROC MoveWindowInFrontOf( window:PTR TO window, behindWindow:PTR TO window ) IS NATIVE {MoveWindowInFrontOf(} window {,} behindWindow {)} ENDNATIVE
NATIVE {ChangeWindowBox} PROC
PROC ChangeWindowBox( window:PTR TO window, left:VALUE, top:VALUE, width:VALUE, height:VALUE ) IS NATIVE {ChangeWindowBox(} window {,} left {,} top {,} width {,} height {)} ENDNATIVE
NATIVE {SetEditHook} PROC
PROC SetEditHook( hook:PTR TO hook ) IS NATIVE {SetEditHook(} hook {)} ENDNATIVE !!PTR TO hook
NATIVE {SetMouseQueue} PROC
PROC SetMouseQueue( window:PTR TO window, queueLength:ULONG ) IS NATIVE {SetMouseQueue(} window {,} queueLength {)} ENDNATIVE !!VALUE
NATIVE {ZipWindow} PROC
PROC ZipWindow( window:PTR TO window ) IS NATIVE {ZipWindow(} window {)} ENDNATIVE
/*--- public screens ---*/
NATIVE {LockPubScreen} PROC
PROC LockPubScreen( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {LockPubScreen(} name {)} ENDNATIVE !!PTR TO screen
NATIVE {UnlockPubScreen} PROC
PROC UnlockPubScreen( name:/*STRPTR*/ ARRAY OF CHAR, screen:PTR TO screen ) IS NATIVE {UnlockPubScreen(} name {,} screen {)} ENDNATIVE
NATIVE {LockPubScreenList} PROC
PROC LockPubScreenList( ) IS NATIVE {LockPubScreenList()} ENDNATIVE !!PTR TO lh
NATIVE {UnlockPubScreenList} PROC
PROC UnlockPubScreenList( ) IS NATIVE {UnlockPubScreenList()} ENDNATIVE
NATIVE {NextPubScreen} PROC
PROC NextPubScreen( screen:PTR TO screen, namebuf:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {NextPubScreen(} screen {,} namebuf {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {SetDefaultPubScreen} PROC
PROC SetDefaultPubScreen( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {SetDefaultPubScreen(} name {)} ENDNATIVE
NATIVE {SetPubScreenModes} PROC
PROC SetPubScreenModes( modes:ULONG ) IS NATIVE {SetPubScreenModes(} modes {)} ENDNATIVE !!UINT
NATIVE {PubScreenStatus} PROC
PROC PubScreenStatus( screen:PTR TO screen, statusFlags:ULONG ) IS NATIVE {PubScreenStatus(} screen {,} statusFlags {)} ENDNATIVE !!UINT

NATIVE {ObtainGIRPort} PROC
PROC ObtainGIRPort( gInfo:PTR TO gadgetinfo ) IS NATIVE {ObtainGIRPort(} gInfo {)} ENDNATIVE !!PTR TO rastport
NATIVE {ReleaseGIRPort} PROC
PROC ReleaseGIRPort( rp:PTR TO rastport ) IS NATIVE {ReleaseGIRPort(} rp {)} ENDNATIVE
NATIVE {GadgetMouse} PROC
PROC GadgetMouse( gadget:PTR TO gadget, gInfo:PTR TO gadgetinfo, mousePoint:PTR TO INT ) IS NATIVE {GadgetMouse(} gadget {,} gInfo {,} mousePoint {)} ENDNATIVE
NATIVE {GetDefaultPubScreen} PROC
PROC GetDefaultPubScreen( nameBuffer:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {GetDefaultPubScreen(} nameBuffer {)} ENDNATIVE
NATIVE {EasyRequestArgs} PROC
PROC EasyRequestArgs( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmpPtr:ARRAY OF ULONG, args:APTR ) IS NATIVE {EasyRequestArgs(} window {,} easyStruct {,} idcmpPtr {,} args {)} ENDNATIVE !!VALUE
NATIVE {EasyRequest} PROC
PROC EasyRequest( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmpPtr:ARRAY OF ULONG, idcmpPtr2=0:ULONG, ... ) IS NATIVE {EasyRequest(} window {,} easyStruct {,} idcmpPtr {,} idcmpPtr2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {BuildEasyRequestArgs} PROC
PROC BuildEasyRequestArgs( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp:ULONG, args:APTR ) IS NATIVE {BuildEasyRequestArgs(} window {,} easyStruct {,} idcmp {,} args {)} ENDNATIVE !!PTR TO window
NATIVE {BuildEasyRequest} PROC
PROC BuildEasyRequest( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp:ULONG, idcmp2=0:ULONG, ... ) IS NATIVE {BuildEasyRequest(} window {,} easyStruct {,} idcmp {,} idcmp2 {,} ... {)} ENDNATIVE !!PTR TO window
NATIVE {SysReqHandler} PROC
PROC SysReqHandler( window:PTR TO window, idcmpPtr:ARRAY OF ULONG, waitInput:VALUE ) IS NATIVE {SysReqHandler(} window {,} idcmpPtr {,} waitInput {)} ENDNATIVE !!VALUE
NATIVE {OpenWindowTagList} PROC
PROC OpenWindowTagList( newWindow:PTR TO nw, tagList:ARRAY OF tagitem ) IS NATIVE {OpenWindowTagList(} newWindow {,} tagList {)} ENDNATIVE !!PTR TO window
NATIVE {OpenWindowTags} PROC
PROC OpenWindowTags( newWindow:PTR TO nw, tag1Type:ULONG, tag1Type2=0:ULONG, ... ) IS NATIVE {OpenWindowTags(} newWindow {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!PTR TO window
NATIVE {OpenScreenTagList} PROC
PROC OpenScreenTagList( newScreen:PTR TO ns, tagList:ARRAY OF tagitem ) IS NATIVE {OpenScreenTagList(} newScreen {,} tagList {)} ENDNATIVE !!PTR TO screen
NATIVE {OpenScreenTags} PROC
PROC OpenScreenTags( newScreen:PTR TO ns, tag1Type:ULONG, tag1Type2=0:ULONG, ... ) IS NATIVE {OpenScreenTags(} newScreen {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!PTR TO screen

/*	new Image functions */
NATIVE {DrawImageState} PROC
PROC DrawImageState( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE, state:ULONG, drawInfo:PTR TO drawinfo ) IS NATIVE {DrawImageState(} rp {,} image {,} leftOffset {,} topOffset {,} state {,} drawInfo {)} ENDNATIVE
NATIVE {PointInImage} PROC
PROC PointInImage( point:ULONG, image:PTR TO image ) IS NATIVE {-PointInImage(} point {,} image {)} ENDNATIVE !!INT
NATIVE {EraseImage} PROC
PROC EraseImage( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {EraseImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE

NATIVE {NewObjectA} PROC
PROC NewObjectA( classPtr:PTR TO iclass, classID:/*STRPTR*/ ARRAY OF CHAR, tagList:ARRAY OF tagitem ) IS NATIVE {NewObjectA(} classPtr {,} classID {,} tagList {)} ENDNATIVE !!APTR
NATIVE {NewObject} PROC
PROC NewObject( classPtr:PTR TO iclass, classID:/*STRPTR*/ ARRAY OF CHAR, tag1:ULONG, tag2=0:ULONG, ...) IS NATIVE {NewObject(} classPtr {,} classID {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!APTR

NATIVE {DisposeObject} PROC
PROC DisposeObject( object:APTR ) IS NATIVE {DisposeObject(} object {)} ENDNATIVE
NATIVE {SetAttrsA} PROC
PROC SetAttrsA( object:APTR, tagList:ARRAY OF tagitem ) IS NATIVE {SetAttrsA(} object {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {SetAttrs} PROC
PROC SetAttrs( object:APTR, tag1:ULONG, tag2=0:ULONG, ...) IS NATIVE {SetAttrs(} object {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!ULONG

NATIVE {GetAttr} PROC
PROC GetAttr( attrID:ULONG, object:APTR, storagePtr:ARRAY) IS NATIVE {GetAttr(} attrID {,} object {, (ULONG *)} storagePtr {)} ENDNATIVE !!ULONG

/* 	special set attribute call for gadgets */
NATIVE {SetGadgetAttrsA} PROC
PROC SetGadgetAttrsA( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, tagList:ARRAY OF tagitem ) IS NATIVE {SetGadgetAttrsA(} gadget {,} window {,} requester {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {SetGadgetAttrs} PROC
PROC SetGadgetAttrs( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, tag1:ULONG, tag12=0:ULONG, ... ) IS NATIVE {SetGadgetAttrs(} gadget {,} window {,} requester {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG

/*	for class implementors only */
NATIVE {NextObject} PROC
PROC NextObject( objectPtrPtr:APTR ) IS NATIVE {NextObject(} objectPtrPtr {)} ENDNATIVE !!APTR
NATIVE {MakeClass} PROC
PROC MakeClass( classID:/*STRPTR*/ ARRAY OF CHAR, superClassID:/*STRPTR*/ ARRAY OF CHAR, superClassPtr:PTR TO iclass, instanceSize:ULONG, flags:ULONG ) IS NATIVE {MakeClass(} classID {,} superClassID {,} superClassPtr {,} instanceSize {,} flags {)} ENDNATIVE !!PTR TO iclass
NATIVE {AddClass} PROC
PROC AddClass( classPtr:PTR TO iclass ) IS NATIVE {AddClass(} classPtr {)} ENDNATIVE


NATIVE {GetScreenDrawInfo} PROC
PROC GetScreenDrawInfo( screen:PTR TO screen ) IS NATIVE {GetScreenDrawInfo(} screen {)} ENDNATIVE !!PTR TO drawinfo
NATIVE {FreeScreenDrawInfo} PROC
PROC FreeScreenDrawInfo( screen:PTR TO screen, drawInfo:PTR TO drawinfo ) IS NATIVE {FreeScreenDrawInfo(} screen {,} drawInfo {)} ENDNATIVE

NATIVE {ResetMenuStrip} PROC
PROC ResetMenuStrip( window:PTR TO window, menu:PTR TO menu ) IS NATIVE {-ResetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
NATIVE {RemoveClass} PROC
PROC RemoveClass( classPtr:PTR TO iclass ) IS NATIVE {RemoveClass(} classPtr {)} ENDNATIVE
NATIVE {FreeClass} PROC
PROC FreeClass( classPtr:PTR TO iclass ) IS NATIVE {-FreeClass(} classPtr {)} ENDNATIVE !!INT
/*--- functions in V39 or higher (Release 3) ---*/
NATIVE {AllocScreenBuffer} PROC
PROC AllocScreenBuffer( sc:PTR TO screen, bm:PTR TO bitmap, flags:ULONG ) IS NATIVE {AllocScreenBuffer(} sc {,} bm {,} flags {)} ENDNATIVE !!PTR TO screenbuffer
NATIVE {FreeScreenBuffer} PROC
PROC FreeScreenBuffer( sc:PTR TO screen, sb:PTR TO screenbuffer ) IS NATIVE {FreeScreenBuffer(} sc {,} sb {)} ENDNATIVE
NATIVE {ChangeScreenBuffer} PROC
PROC ChangeScreenBuffer( sc:PTR TO screen, sb:PTR TO screenbuffer ) IS NATIVE {ChangeScreenBuffer(} sc {,} sb {)} ENDNATIVE !!ULONG
NATIVE {ScreenDepth} PROC
PROC ScreenDepth( screen:PTR TO screen, flags:ULONG, reserved:APTR ) IS NATIVE {ScreenDepth(} screen {,} flags {,} reserved {)} ENDNATIVE
NATIVE {ScreenPosition} PROC
PROC ScreenPosition( screen:PTR TO screen, flags:ULONG, x1:VALUE, y1:VALUE, x2:VALUE, y2:VALUE ) IS NATIVE {ScreenPosition(} screen {,} flags {,} x1 {,} y1 {,} x2 {,} y2 {)} ENDNATIVE
NATIVE {ScrollWindowRaster} PROC
PROC ScrollWindowRaster( win:PTR TO window, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {ScrollWindowRaster(} win {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
NATIVE {LendMenus} PROC
PROC LendMenus( fromwindow:PTR TO window, towindow:PTR TO window ) IS NATIVE {LendMenus(} fromwindow {,} towindow {)} ENDNATIVE
NATIVE {DoGadgetMethodA} PROC
->Could not get to compile: PROC DoGadgetMethodA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, message:PTR TO msg ) IS NATIVE {DoGadgetMethodA(} gad {,} win {,} req {,} message {)} ENDNATIVE !!ULONG
NATIVE {DoGadgetMethod} PROC
PROC DoGadgetMethod( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, methodID:ULONG, methodID2=0:ULONG, ... ) IS NATIVE {DoGadgetMethod(} gad {,} win {,} req {,} methodID {,} methodID2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {SetWindowPointerA} PROC
PROC SetWindowPointerA( win:PTR TO window, taglist:ARRAY OF tagitem ) IS NATIVE {SetWindowPointerA(} win {,} taglist {)} ENDNATIVE
NATIVE {SetWindowPointer} PROC
PROC SetWindowPointer( win:PTR TO window, tag1:ULONG, tag12=0:ULONG, ... ) IS NATIVE {SetWindowPointer(} win {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
NATIVE {TimedDisplayAlert} PROC
PROC TimedDisplayAlert( alertNumber:ULONG, string:/*STRPTR*/ ARRAY OF CHAR, height:ULONG, time:ULONG ) IS NATIVE {-TimedDisplayAlert(} alertNumber {,} string {,} height {,} time {)} ENDNATIVE !!INT
NATIVE {HelpControl} PROC
PROC HelpControl( win:PTR TO window, flags:ULONG ) IS NATIVE {HelpControl(} win {,} flags {)} ENDNATIVE
