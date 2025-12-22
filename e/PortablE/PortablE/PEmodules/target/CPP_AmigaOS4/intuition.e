/* $Id: intuition_protos.h,v 1.21 2005/12/12 10:31:50 dwuerkner Exp $ */
OPT NATIVE, FORCENATIVE
PUBLIC MODULE 'target/intuition/bitmapshare', 'target/intuition/cghooks', 'target/intuition/classes', 'target/intuition/classusr', 'target/intuition/gadgetclass', 'target/intuition/gui', 'target/intuition/icclass', 'target/intuition/imageclass', 'target/intuition/intuition', 'target/intuition/intuitionbase', 'target/intuition/iobsolete', 'target/intuition/menuclass', 'target/intuition/notify', 'target/intuition/plugins', 'target/intuition/pointerclass', 'target/intuition/preferences', 'target/intuition/screens', 'target/intuition/sghooks', 'target/intuition/sysiclass'
MODULE 'target/intuition/intuition', 'target/intuition/classes', 'target/intuition/cghooks', 'target/intuition/classusr', 'target/intuition/notify', 'target/intuition/sghooks'
MODULE 'target/devices/inputevent', 'target/graphics/rastport', 'target/graphics/gfx', 'target/utility/hooks', 'target/utility/tagitem', 'target/graphics/view', 'target/exec/lists', 'target/graphics/text', 'target/exec', 'target/dos/dos'
{
#include <proto/intuition.h>
}
{
struct Library* IntuitionBase = NULL;
struct IntuitionIFace* IIntuition = NULL;
}
NATIVE {CLIB_INTUITION_PROTOS_H} CONST
NATIVE {PROTO_INTUITION_H} CONST
NATIVE {PRAGMA_INTUITION_H} CONST
NATIVE {INLINE4_INTUITION_H} CONST
NATIVE {INTUITION_INTERFACE_DEF_H} CONST

NATIVE {IntuitionBase} DEF intuitionbase:PTR TO lib
NATIVE {IIntuition} CONST

->automatic opening of intuition library
PROC new()
	intuitionbase := OpenLibrary('intuition.library', 0)
	IF intuitionbase=NIL THEN CleanUp(RETURN_ERROR)
	
	NATIVE {IIntuition = (struct IntuitionIFace *) IExec->GetInterface((struct Library *)} intuitionbase{, "main", 1, NULL)} ENDNATIVE
ENDPROC

->automatic closing of intuition library
PROC end()
	{IExec->DropInterface((struct Interface *) IIntuition)}
	CloseLibrary(intuitionbase)
ENDPROC

/* Public functions OpenIntuition() and Intuition() are intentionally */
/* not documented. */
->NATIVE {OpenIntuition} PROC
PROC OpenIntuition( ) IS NATIVE {IIntuition->OpenIntuition()} ENDNATIVE
->NATIVE {Intuition} PROC
PROC Intuition( iEvent:PTR TO inputevent ) IS NATIVE {IIntuition->Intuition(} iEvent {)} ENDNATIVE
->NATIVE {AddGadget} PROC
PROC AddGadget( window:PTR TO window, gadget:PTR TO gadget, position:ULONG ) IS NATIVE {IIntuition->AddGadget(} window {,} gadget {,} position {)} ENDNATIVE !!UINT
->NATIVE {ClearDMRequest} PROC
PROC ClearDMRequest( window:PTR TO window ) IS NATIVE {-IIntuition->ClearDMRequest(} window {)} ENDNATIVE !!INT
->NATIVE {ClearMenuStrip} PROC
PROC ClearMenuStrip( window:PTR TO window ) IS NATIVE {IIntuition->ClearMenuStrip(} window {)} ENDNATIVE
->NATIVE {ClearPointer} PROC
PROC ClearPointer( window:PTR TO window ) IS NATIVE {IIntuition->ClearPointer(} window {)} ENDNATIVE
->NATIVE {CloseScreen} PROC
PROC CloseScreen( screen:PTR TO screen ) IS NATIVE {-IIntuition->CloseScreen(} screen {)} ENDNATIVE !!INT
->NATIVE {CloseWindow} PROC
PROC CloseWindow( window:PTR TO window ) IS NATIVE {IIntuition->CloseWindow(} window {)} ENDNATIVE
->NATIVE {CloseWorkBench} PROC
PROC CloseWorkBench( ) IS NATIVE {IIntuition->CloseWorkBench()} ENDNATIVE !!VALUE
->NATIVE {CurrentTime} PROC
PROC CurrentTime( seconds:ARRAY OF ULONG, micros:ARRAY OF ULONG ) IS NATIVE {IIntuition->CurrentTime(} seconds {,} micros {)} ENDNATIVE
->NATIVE {DisplayAlert} PROC
PROC DisplayAlert( alertNumber:ULONG, string:/*STRPTR*/ ARRAY OF CHAR, height:ULONG ) IS NATIVE {-IIntuition->DisplayAlert(} alertNumber {,} string {,} height {)} ENDNATIVE !!INT
->NATIVE {DisplayBeep} PROC
PROC DisplayBeep( screen:PTR TO screen ) IS NATIVE {IIntuition->DisplayBeep(} screen {)} ENDNATIVE
->NATIVE {DoubleClick} PROC
PROC DoubleClick( sSeconds:ULONG, sMicros:ULONG, cSeconds:ULONG, cMicros:ULONG ) IS NATIVE {-IIntuition->DoubleClick(} sSeconds {,} sMicros {,} cSeconds {,} cMicros {)} ENDNATIVE !!INT
->NATIVE {DrawBorder} PROC
PROC DrawBorder( rp:PTR TO rastport, border:PTR TO border, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {IIntuition->DrawBorder(} rp {,} border {,} leftOffset {,} topOffset {)} ENDNATIVE
->NATIVE {DrawImage} PROC
PROC DrawImage( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {IIntuition->DrawImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE
->NATIVE {EndRequest} PROC
PROC EndRequest( requester:PTR TO requester, window:PTR TO window ) IS NATIVE {IIntuition->EndRequest(} requester {,} window {)} ENDNATIVE
->NATIVE {GetDefPrefs} PROC
PROC GetDefPrefs( preferences:PTR TO preferences, size:VALUE ) IS NATIVE {IIntuition->GetDefPrefs(} preferences {,} size {)} ENDNATIVE !!PTR TO preferences
->NATIVE {GetPrefs} PROC
PROC GetPrefs( preferences:PTR TO preferences, size:VALUE ) IS NATIVE {IIntuition->GetPrefs(} preferences {,} size {)} ENDNATIVE !!PTR TO preferences
->NATIVE {InitRequester} PROC
PROC InitRequester( requester:PTR TO requester ) IS NATIVE {IIntuition->InitRequester(} requester {)} ENDNATIVE
->NATIVE {ItemAddress} PROC
PROC ItemAddress( menuStrip:PTR TO menu, menuNumber:ULONG ) IS NATIVE {IIntuition->ItemAddress(} menuStrip {,} menuNumber {)} ENDNATIVE !!PTR TO menuitem
->NATIVE {ModifyIDCMP} PROC
PROC ModifyIDCMP( window:PTR TO window, flags:ULONG ) IS NATIVE {-IIntuition->ModifyIDCMP(} window {,} flags {)} ENDNATIVE !!INT
->NATIVE {ModifyProp} PROC
PROC ModifyProp( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG ) IS NATIVE {IIntuition->ModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {)} ENDNATIVE
->NATIVE {MoveScreen} PROC
PROC MoveScreen( screen:PTR TO screen, dx:VALUE, dy:VALUE ) IS NATIVE {IIntuition->MoveScreen(} screen {,} dx {,} dy {)} ENDNATIVE
->NATIVE {MoveWindow} PROC
PROC MoveWindow( window:PTR TO window, dx:VALUE, dy:VALUE ) IS NATIVE {IIntuition->MoveWindow(} window {,} dx {,} dy {)} ENDNATIVE
->NATIVE {OffGadget} PROC
PROC OffGadget( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {IIntuition->OffGadget(} gadget {,} window {,} requester {)} ENDNATIVE
->NATIVE {OffMenu} PROC
PROC OffMenu( window:PTR TO window, menuNumber:ULONG ) IS NATIVE {IIntuition->OffMenu(} window {,} menuNumber {)} ENDNATIVE
->NATIVE {OnGadget} PROC
PROC OnGadget( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {IIntuition->OnGadget(} gadget {,} window {,} requester {)} ENDNATIVE
->NATIVE {OnMenu} PROC
PROC OnMenu( window:PTR TO window, menuNumber:ULONG ) IS NATIVE {IIntuition->OnMenu(} window {,} menuNumber {)} ENDNATIVE
->NATIVE {OpenScreen} PROC
PROC OpenScreen( newScreen:PTR TO ns ) IS NATIVE {IIntuition->OpenScreen(} newScreen {)} ENDNATIVE !!PTR TO screen
->NATIVE {OpenWindow} PROC
PROC OpenWindow( newWindow:PTR TO nw ) IS NATIVE {IIntuition->OpenWindow(} newWindow {)} ENDNATIVE !!PTR TO window
->NATIVE {OpenWorkBench} PROC
PROC OpenWorkBench( ) IS NATIVE {IIntuition->OpenWorkBench()} ENDNATIVE !!ULONG
->NATIVE {PrintIText} PROC
PROC PrintIText( rp:PTR TO rastport, iText:PTR TO intuitext, left:VALUE, top:VALUE ) IS NATIVE {IIntuition->PrintIText(} rp {,} iText {,} left {,} top {)} ENDNATIVE
->NATIVE {RefreshGadgets} PROC
PROC RefreshGadgets( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {IIntuition->RefreshGadgets(} gadgets {,} window {,} requester {)} ENDNATIVE
->NATIVE {RemoveGadget} PROC
PROC RemoveGadget( window:PTR TO window, gadget:PTR TO gadget ) IS NATIVE {IIntuition->RemoveGadget(} window {,} gadget {)} ENDNATIVE !!UINT
/* The official calling sequence for ReportMouse is given below. */
/* Note the register order.  For the complete story, read the ReportMouse */
/* autodoc. */
->NATIVE {ReportMouse} PROC
PROC ReportMouse( flag:VALUE, window:PTR TO window ) IS NATIVE {IIntuition->ReportMouse(} flag {,} window {)} ENDNATIVE
->NATIVE {ReportMouse1} PROC
PROC ReportMouse1( window:PTR TO window, flag:VALUE ) IS NATIVE {IIntuition->ReportMouse1(} window {,} flag {)} ENDNATIVE
->NATIVE {Request} PROC
PROC Request( requester:PTR TO requester, window:PTR TO window ) IS NATIVE {-IIntuition->Request(} requester {,} window {)} ENDNATIVE !!INT
->NATIVE {ScreenToBack} PROC
PROC ScreenToBack( screen:PTR TO screen ) IS NATIVE {IIntuition->ScreenToBack(} screen {)} ENDNATIVE
->NATIVE {ScreenToFront} PROC
PROC ScreenToFront( screen:PTR TO screen ) IS NATIVE {IIntuition->ScreenToFront(} screen {)} ENDNATIVE
->NATIVE {SetDMRequest} PROC
PROC SetDMRequest( window:PTR TO window, requester:PTR TO requester ) IS NATIVE {-IIntuition->SetDMRequest(} window {,} requester {)} ENDNATIVE !!INT
->NATIVE {SetMenuStrip} PROC
PROC SetMenuStrip( window:PTR TO window, menu:PTR TO menu ) IS NATIVE {-IIntuition->SetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
->NATIVE {SetPointer} PROC
PROC SetPointer( window:PTR TO window, pointer:ARRAY OF UINT, height:VALUE, width:VALUE, xOffset:VALUE, yOffset:VALUE ) IS NATIVE {IIntuition->SetPointer(} window {,} pointer {,} height {,} width {,} xOffset {,} yOffset {)} ENDNATIVE
->NATIVE {SetWindowTitles} PROC
PROC SetWindowTitles( window:PTR TO window, windowTitle:/*STRPTR*/ ARRAY OF CHAR, screenTitle:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIntuition->SetWindowTitles(} window {,} windowTitle {,} screenTitle {)} ENDNATIVE
->NATIVE {ShowTitle} PROC
PROC ShowTitle( screen:PTR TO screen, showIt:VALUE ) IS NATIVE {IIntuition->ShowTitle(} screen {,} showIt {)} ENDNATIVE
->NATIVE {SizeWindow} PROC
PROC SizeWindow( window:PTR TO window, dx:VALUE, dy:VALUE ) IS NATIVE {IIntuition->SizeWindow(} window {,} dx {,} dy {)} ENDNATIVE
->NATIVE {ViewAddress} PROC
PROC ViewAddress( ) IS NATIVE {IIntuition->ViewAddress()} ENDNATIVE !!PTR TO view
->NATIVE {ViewPortAddress} PROC
PROC ViewPortAddress( window:PTR TO window ) IS NATIVE {IIntuition->ViewPortAddress(} window {)} ENDNATIVE !!PTR TO viewport
->NATIVE {WindowToBack} PROC
PROC WindowToBack( window:PTR TO window ) IS NATIVE {IIntuition->WindowToBack(} window {)} ENDNATIVE
->NATIVE {WindowToFront} PROC
PROC WindowToFront( window:PTR TO window ) IS NATIVE {IIntuition->WindowToFront(} window {)} ENDNATIVE
->NATIVE {WindowLimits} PROC
PROC WindowLimits( window:PTR TO window, widthMin:VALUE, heightMin:VALUE, widthMax:ULONG, heightMax:ULONG ) IS NATIVE {-IIntuition->WindowLimits(} window {,} widthMin {,} heightMin {,} widthMax {,} heightMax {)} ENDNATIVE !!INT
/*--- start of next generation of names -------------------------------------*/
->NATIVE {SetPrefs} PROC
PROC SetPrefs( preferences:PTR TO preferences, size:VALUE, inform:VALUE ) IS NATIVE {IIntuition->SetPrefs(} preferences {,} size {,} inform {)} ENDNATIVE !!PTR TO preferences
/*--- start of next next generation of names --------------------------------*/
->NATIVE {IntuiTextLength} PROC
PROC IntuiTextLength( iText:PTR TO intuitext ) IS NATIVE {IIntuition->IntuiTextLength(} iText {)} ENDNATIVE !!VALUE
->NATIVE {WBenchToBack} PROC
PROC WbenchToBack( ) IS NATIVE {-IIntuition->WBenchToBack()} ENDNATIVE !!INT
->NATIVE {WBenchToFront} PROC
PROC WbenchToFront( ) IS NATIVE {-IIntuition->WBenchToFront()} ENDNATIVE !!INT
/*--- start of next next next generation of names ---------------------------*/
->NATIVE {AutoRequest} PROC
PROC AutoRequest( window:PTR TO window, body:PTR TO intuitext, posText:PTR TO intuitext, negText:PTR TO intuitext, pFlag:ULONG, nFlag:ULONG, width:ULONG, height:ULONG ) IS NATIVE {-IIntuition->AutoRequest(} window {,} body {,} posText {,} negText {,} pFlag {,} nFlag {,} width {,} height {)} ENDNATIVE !!INT
->NATIVE {BeginRefresh} PROC
PROC BeginRefresh( window:PTR TO window ) IS NATIVE {IIntuition->BeginRefresh(} window {)} ENDNATIVE
->NATIVE {BuildSysRequest} PROC
PROC BuildSysRequest( window:PTR TO window, body:PTR TO intuitext, posText:PTR TO intuitext, negText:PTR TO intuitext, flags:ULONG, width:ULONG, height:ULONG ) IS NATIVE {IIntuition->BuildSysRequest(} window {,} body {,} posText {,} negText {,} flags {,} width {,} height {)} ENDNATIVE !!PTR TO window
->NATIVE {EndRefresh} PROC
PROC EndRefresh( window:PTR TO window, complete:VALUE ) IS NATIVE {IIntuition->EndRefresh(} window {,} complete {)} ENDNATIVE
->NATIVE {FreeSysRequest} PROC
PROC FreeSysRequest( window:PTR TO window ) IS NATIVE {IIntuition->FreeSysRequest(} window {)} ENDNATIVE
/* The return codes for MakeScreen(), RemakeDisplay(), and RethinkDisplay() */
/* are only valid under V39 and greater.  Do not examine them when running */
/* on pre-V39 systems! */
->NATIVE {MakeScreen} PROC
PROC MakeScreen( screen:PTR TO screen ) IS NATIVE {IIntuition->MakeScreen(} screen {)} ENDNATIVE !!VALUE
->NATIVE {RemakeDisplay} PROC
PROC RemakeDisplay( ) IS NATIVE {IIntuition->RemakeDisplay()} ENDNATIVE !!VALUE
->NATIVE {RethinkDisplay} PROC
PROC RethinkDisplay( ) IS NATIVE {IIntuition->RethinkDisplay()} ENDNATIVE !!VALUE
/*--- start of next next next next generation of names ----------------------*/
->NATIVE {AllocRemember} PROC
PROC AllocRemember( rememberKey:ARRAY OF PTR TO remember, size:ULONG, flags:ULONG ) IS NATIVE {IIntuition->AllocRemember(} rememberKey {,} size {,} flags {)} ENDNATIVE !!APTR
->NATIVE {FreeRemember} PROC
PROC FreeRemember( rememberKey:ARRAY OF PTR TO remember, reallyForget:VALUE ) IS NATIVE {IIntuition->FreeRemember(} rememberKey {,} reallyForget {)} ENDNATIVE
/*--- start of 15 Nov 85 names ------------------------*/
->NATIVE {LockIBase} PROC
PROC LockIBase( dontknow:ULONG ) IS NATIVE {IIntuition->LockIBase(} dontknow {)} ENDNATIVE !!ULONG
->NATIVE {UnlockIBase} PROC
PROC UnlockIBase( ibLock:ULONG ) IS NATIVE {IIntuition->UnlockIBase(} ibLock {)} ENDNATIVE
/*--- functions in V33 or higher (Release 1.2) ---*/
->NATIVE {GetScreenData} PROC
PROC GetScreenData( buffer:APTR, size:ULONG, type:ULONG, screen:PTR TO screen ) IS NATIVE {IIntuition->GetScreenData(} buffer {,} size {,} type {,} screen {)} ENDNATIVE !!VALUE
->NATIVE {RefreshGList} PROC
PROC RefreshGList( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, numGad:VALUE ) IS NATIVE {IIntuition->RefreshGList(} gadgets {,} window {,} requester {,} numGad {)} ENDNATIVE
->NATIVE {AddGList} PROC
PROC AddGList( window:PTR TO window, gadget:PTR TO gadget, position:ULONG, numGad:VALUE, requester:PTR TO requester ) IS NATIVE {IIntuition->AddGList(} window {,} gadget {,} position {,} numGad {,} requester {)} ENDNATIVE !!UINT
->NATIVE {RemoveGList} PROC
PROC RemoveGList( remPtr:PTR TO window, gadget:PTR TO gadget, numGad:VALUE ) IS NATIVE {IIntuition->RemoveGList(} remPtr {,} gadget {,} numGad {)} ENDNATIVE !!UINT
->NATIVE {ActivateWindow} PROC
PROC ActivateWindow( window:PTR TO window ) IS NATIVE {IIntuition->ActivateWindow(} window {)} ENDNATIVE
->NATIVE {RefreshWindowFrame} PROC
PROC RefreshWindowFrame( window:PTR TO window ) IS NATIVE {IIntuition->RefreshWindowFrame(} window {)} ENDNATIVE
->NATIVE {ActivateGadget} PROC
PROC ActivateGadget( gadgets:PTR TO gadget, window:PTR TO window, requester:PTR TO requester ) IS NATIVE {-IIntuition->ActivateGadget(} gadgets {,} window {,} requester {)} ENDNATIVE !!INT
->NATIVE {NewModifyProp} PROC
PROC NewModifyProp( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, flags:ULONG, horizPot:ULONG, vertPot:ULONG, horizBody:ULONG, vertBody:ULONG, numGad:VALUE ) IS NATIVE {IIntuition->NewModifyProp(} gadget {,} window {,} requester {,} flags {,} horizPot {,} vertPot {,} horizBody {,} vertBody {,} numGad {)} ENDNATIVE
/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {QueryOverscan} PROC
PROC QueryOverscan( displayID:ULONG, rect:PTR TO rectangle, oScanType:VALUE ) IS NATIVE {IIntuition->QueryOverscan(} displayID {,} rect {,} oScanType {)} ENDNATIVE !!VALUE
->NATIVE {MoveWindowInFrontOf} PROC
PROC MoveWindowInFrontOf( window:PTR TO window, behindWindow:PTR TO window ) IS NATIVE {IIntuition->MoveWindowInFrontOf(} window {,} behindWindow {)} ENDNATIVE
->NATIVE {ChangeWindowBox} PROC
PROC ChangeWindowBox( window:PTR TO window, left:VALUE, top:VALUE, width:VALUE, height:VALUE ) IS NATIVE {IIntuition->ChangeWindowBox(} window {,} left {,} top {,} width {,} height {)} ENDNATIVE
->NATIVE {SetEditHook} PROC
PROC SetEditHook( hook:PTR TO hook ) IS NATIVE {IIntuition->SetEditHook(} hook {)} ENDNATIVE !!PTR TO hook
->NATIVE {SetMouseQueue} PROC
PROC SetMouseQueue( window:PTR TO window, queueLength:ULONG ) IS NATIVE {IIntuition->SetMouseQueue(} window {,} queueLength {)} ENDNATIVE !!VALUE
->NATIVE {ZipWindow} PROC
PROC ZipWindow( window:PTR TO window ) IS NATIVE {IIntuition->ZipWindow(} window {)} ENDNATIVE
/*--- public screens ---*/
->NATIVE {LockPubScreen} PROC
PROC LockPubScreen( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIntuition->LockPubScreen(} name {)} ENDNATIVE !!PTR TO screen
->NATIVE {UnlockPubScreen} PROC
PROC UnlockPubScreen( name:/*STRPTR*/ ARRAY OF CHAR, screen:PTR TO screen ) IS NATIVE {IIntuition->UnlockPubScreen(} name {,} screen {)} ENDNATIVE
->NATIVE {LockPubScreenList} PROC
PROC LockPubScreenList( ) IS NATIVE {IIntuition->LockPubScreenList()} ENDNATIVE !!PTR TO lh
->NATIVE {UnlockPubScreenList} PROC
PROC UnlockPubScreenList( ) IS NATIVE {IIntuition->UnlockPubScreenList()} ENDNATIVE
->NATIVE {NextPubScreen} PROC
PROC NextPubScreen( screen:PTR TO screen, namebuf:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIntuition->NextPubScreen(} screen {,} namebuf {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {SetDefaultPubScreen} PROC
PROC SetDefaultPubScreen( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIntuition->SetDefaultPubScreen(} name {)} ENDNATIVE
->NATIVE {SetPubScreenModes} PROC
PROC SetPubScreenModes( modes:ULONG ) IS NATIVE {IIntuition->SetPubScreenModes(} modes {)} ENDNATIVE !!UINT
->NATIVE {PubScreenStatus} PROC
PROC PubScreenStatus( screen:PTR TO screen, statusFlags:ULONG ) IS NATIVE {IIntuition->PubScreenStatus(} screen {,} statusFlags {)} ENDNATIVE !!UINT

->NATIVE {ObtainGIRPort} PROC
PROC ObtainGIRPort( gInfo:PTR TO gadgetinfo ) IS NATIVE {IIntuition->ObtainGIRPort(} gInfo {)} ENDNATIVE !!PTR TO rastport
->NATIVE {ReleaseGIRPort} PROC
PROC ReleaseGIRPort( rp:PTR TO rastport ) IS NATIVE {IIntuition->ReleaseGIRPort(} rp {)} ENDNATIVE
->NATIVE {GadgetMouse} PROC
PROC GadgetMouse( gadget:PTR TO gadget, gInfo:PTR TO gadgetinfo, mousePoint:PTR TO INT ) IS NATIVE {IIntuition->GadgetMouse(} gadget {,} gInfo {,} mousePoint {)} ENDNATIVE
->NATIVE {GetDefaultPubScreen} PROC
PROC GetDefaultPubScreen( nameBuffer:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIntuition->GetDefaultPubScreen(} nameBuffer {)} ENDNATIVE
->NATIVE {EasyRequestArgs} PROC
PROC EasyRequestArgs( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmpPtr:ARRAY OF ULONG, args:APTR ) IS NATIVE {IIntuition->EasyRequestArgs(} window {,} easyStruct {,} idcmpPtr {,} args {)} ENDNATIVE !!VALUE
->NATIVE {EasyRequest} PROC
PROC EasyRequest( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmpPtr:ARRAY OF ULONG, idcmpPtr2=0:ULONG, ... ) IS NATIVE {IIntuition->EasyRequest(} window {,} easyStruct {,} idcmpPtr {,} idcmpPtr2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {BuildEasyRequestArgs} PROC
PROC BuildEasyRequestArgs( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp:ULONG, args:APTR ) IS NATIVE {IIntuition->BuildEasyRequestArgs(} window {,} easyStruct {,} idcmp {,} args {)} ENDNATIVE !!PTR TO window
->NATIVE {BuildEasyRequest} PROC
PROC BuildEasyRequest( window:PTR TO window, easyStruct:ARRAY OF easystruct, idcmp:ULONG, idcmp2=0:ULONG, ... ) IS NATIVE {IIntuition->BuildEasyRequest(} window {,} easyStruct {,} idcmp {,} idcmp2 {,} ... {)} ENDNATIVE !!PTR TO window
->NATIVE {SysReqHandler} PROC
PROC SysReqHandler( window:PTR TO window, idcmpPtr:ARRAY OF ULONG, waitInput:VALUE ) IS NATIVE {IIntuition->SysReqHandler(} window {,} idcmpPtr {,} waitInput {)} ENDNATIVE !!VALUE
->NATIVE {OpenWindowTagList} PROC
PROC OpenWindowTagList( newWindow:PTR TO nw, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->OpenWindowTagList(} newWindow {,} tagList {)} ENDNATIVE !!PTR TO window
->NATIVE {OpenWindowTags} PROC
PROC OpenWindowTags( newWindow:PTR TO nw, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IIntuition->OpenWindowTags(} newWindow {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!PTR TO window
->NATIVE {OpenScreenTagList} PROC
PROC OpenScreenTagList( newScreen:PTR TO ns, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->OpenScreenTagList(} newScreen {,} tagList {)} ENDNATIVE !!PTR TO screen
->NATIVE {OpenScreenTags} PROC
PROC OpenScreenTags( newScreen:PTR TO ns, tag1Type:TAG, tag1Type2=0:ULONG, ... ) IS NATIVE {IIntuition->OpenScreenTags(} newScreen {,} tag1Type {,} tag1Type2 {,} ... {)} ENDNATIVE !!PTR TO screen

/*    new Image functions */
->NATIVE {DrawImageState} PROC
PROC DrawImageState( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE, state:ULONG, drawInfo:PTR TO drawinfo ) IS NATIVE {IIntuition->DrawImageState(} rp {,} image {,} leftOffset {,} topOffset {,} state {,} drawInfo {)} ENDNATIVE
->NATIVE {PointInImage} PROC
PROC PointInImage( point:ULONG, image:PTR TO image ) IS NATIVE {-IIntuition->PointInImage(} point {,} image {)} ENDNATIVE !!INT
->NATIVE {EraseImage} PROC
PROC EraseImage( rp:PTR TO rastport, image:PTR TO image, leftOffset:VALUE, topOffset:VALUE ) IS NATIVE {IIntuition->EraseImage(} rp {,} image {,} leftOffset {,} topOffset {)} ENDNATIVE

->NATIVE {NewObjectA} PROC
PROC NewObjectA( classPtr:PTR TO iclass, classID:/*STRPTR*/ ARRAY OF CHAR, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->NewObjectA(} classPtr {,} classID {,} tagList {)} ENDNATIVE !!PTR TO INTUIOBJECT
->NATIVE {NewObject} PROC
PROC NewObject( classPtr:PTR TO iclass, classID:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag2=0:ULONG, ...) IS NATIVE {IIntuition->NewObject(} classPtr {,} classID {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!PTR TO INTUIOBJECT

->NATIVE {DisposeObject} PROC
PROC DisposeObject( object:PTR TO INTUIOBJECT ) IS NATIVE {IIntuition->DisposeObject(} object {)} ENDNATIVE
->NATIVE {SetAttrsA} PROC
PROC SetAttrsA( object:PTR TO INTUIOBJECT, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetAttrsA(} object {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {SetAttrs} PROC
PROC SetAttrs( object:APTR, tag1:TAG, tag2=0:ULONG, ...) IS NATIVE {IIntuition->SetAttrs(} object {,} tag1 {,} tag2 {,} ... {)} ENDNATIVE !!ULONG

->NATIVE {GetAttr} PROC
PROC GetAttr( attrID:ULONG, object:PTR TO INTUIOBJECT, storagePtr:ARRAY) IS NATIVE {IIntuition->GetAttr(} attrID {,} object {, (uint32 *)} storagePtr {)} ENDNATIVE !!ULONG

/*     special set attribute call for gadgets */
->NATIVE {SetGadgetAttrsA} PROC
PROC SetGadgetAttrsA( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetGadgetAttrsA(} gadget {,} window {,} requester {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {SetGadgetAttrs} PROC
PROC SetGadgetAttrs( gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->SetGadgetAttrs(} gadget {,} window {,} requester {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG

/*    for class implementors only */
->NATIVE {NextObject} PROC
PROC NextObject( objectPtrPtr:ARRAY OF PTR TO INTUIOBJECT ) IS NATIVE {IIntuition->NextObject(} objectPtrPtr {)} ENDNATIVE !!APTR
->NATIVE {MakeClass} PROC
PROC MakeClass( classID:/*STRPTR*/ ARRAY OF CHAR, superClassID:/*STRPTR*/ ARRAY OF CHAR, superClassPtr:PTR TO iclass, instanceSize:ULONG, flags:ULONG ) IS NATIVE {IIntuition->MakeClass(} classID {,} superClassID {,} superClassPtr {,} instanceSize {,} flags {)} ENDNATIVE !!PTR TO iclass
->NATIVE {AddClass} PROC
PROC AddClass( classPtr:PTR TO iclass ) IS NATIVE {IIntuition->AddClass(} classPtr {)} ENDNATIVE


->NATIVE {GetScreenDrawInfo} PROC
PROC GetScreenDrawInfo( screen:PTR TO screen ) IS NATIVE {IIntuition->GetScreenDrawInfo(} screen {)} ENDNATIVE !!PTR TO drawinfo
->NATIVE {FreeScreenDrawInfo} PROC
PROC FreeScreenDrawInfo( screen:PTR TO screen, drawInfo:PTR TO drawinfo ) IS NATIVE {IIntuition->FreeScreenDrawInfo(} screen {,} drawInfo {)} ENDNATIVE

->NATIVE {ResetMenuStrip} PROC
PROC ResetMenuStrip( window:PTR TO window, menu:PTR TO menu ) IS NATIVE {-IIntuition->ResetMenuStrip(} window {,} menu {)} ENDNATIVE !!INT
->NATIVE {RemoveClass} PROC
PROC RemoveClass( classPtr:PTR TO iclass ) IS NATIVE {IIntuition->RemoveClass(} classPtr {)} ENDNATIVE
->NATIVE {FreeClass} PROC
PROC FreeClass( classPtr:PTR TO iclass ) IS NATIVE {-IIntuition->FreeClass(} classPtr {)} ENDNATIVE !!INT
/*--- functions in V39 or higher (Release 3) ---*/
->NATIVE {AllocScreenBuffer} PROC
PROC AllocScreenBuffer( sc:PTR TO screen, bm:PTR TO bitmap, flags:ULONG ) IS NATIVE {IIntuition->AllocScreenBuffer(} sc {,} bm {,} flags {)} ENDNATIVE !!PTR TO screenbuffer
->NATIVE {FreeScreenBuffer} PROC
PROC FreeScreenBuffer( sc:PTR TO screen, sb:PTR TO screenbuffer ) IS NATIVE {IIntuition->FreeScreenBuffer(} sc {,} sb {)} ENDNATIVE
->NATIVE {ChangeScreenBuffer} PROC
PROC ChangeScreenBuffer( sc:PTR TO screen, sb:PTR TO screenbuffer ) IS NATIVE {IIntuition->ChangeScreenBuffer(} sc {,} sb {)} ENDNATIVE !!ULONG
->NATIVE {ScreenDepth} PROC
PROC ScreenDepth( screen:PTR TO screen, flags:ULONG, reserved:APTR ) IS NATIVE {IIntuition->ScreenDepth(} screen {,} flags {,} reserved {)} ENDNATIVE
->NATIVE {ScreenPosition} PROC
PROC ScreenPosition( screen:PTR TO screen, flags:ULONG, x1:VALUE, y1:VALUE, x2:VALUE, y2:VALUE ) IS NATIVE {IIntuition->ScreenPosition(} screen {,} flags {,} x1 {,} y1 {,} x2 {,} y2 {)} ENDNATIVE
->NATIVE {ScrollWindowRaster} PROC
PROC ScrollWindowRaster( win:PTR TO window, dx:VALUE, dy:VALUE, xMin:VALUE, yMin:VALUE, xMax:VALUE, yMax:VALUE ) IS NATIVE {IIntuition->ScrollWindowRaster(} win {,} dx {,} dy {,} xMin {,} yMin {,} xMax {,} yMax {)} ENDNATIVE
->NATIVE {LendMenus} PROC
PROC LendMenus( fromwindow:PTR TO window, towindow:PTR TO window ) IS NATIVE {IIntuition->LendMenus(} fromwindow {,} towindow {)} ENDNATIVE
->NATIVE {DoGadgetMethodA} PROC
PROC DoGadgetMethodA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, message:PTR TO msg ) IS NATIVE {IIntuition->DoGadgetMethodA(} gad {,} win {,} req {,} message {)} ENDNATIVE !!ULONG
->NATIVE {DoGadgetMethod} PROC
PROC DoGadgetMethod( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, methodID:ULONG, methodID2=0:ULONG, ... ) IS NATIVE {IIntuition->DoGadgetMethod(} gad {,} win {,} req {,} methodID {,} methodID2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {SetWindowPointerA} PROC
PROC SetWindowPointerA( win:PTR TO window, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetWindowPointerA(} win {,} taglist {)} ENDNATIVE
->NATIVE {SetWindowPointer} PROC
PROC SetWindowPointer( win:PTR TO window, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->SetWindowPointer(} win {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {TimedDisplayAlert} PROC
PROC TimedDisplayAlert( alertNumber:ULONG, string:/*STRPTR*/ ARRAY OF CHAR, height:ULONG, Time:ULONG ) IS NATIVE {-IIntuition->TimedDisplayAlert(} alertNumber {,} string {,} height {,} Time {)} ENDNATIVE !!INT
->NATIVE {HelpControl} PROC
PROC HelpControl( win:PTR TO window, flags:ULONG ) IS NATIVE {IIntuition->HelpControl(} win {,} flags {)} ENDNATIVE
/*--- functions in V50 or higher (Release 4) ---*/
->NATIVE {ShowWindow} PROC
PROC ShowWindow( window:PTR TO window, other:PTR TO window ) IS NATIVE {-IIntuition->ShowWindow(} window {,} other {)} ENDNATIVE !!INT
->NATIVE {HideWindow} PROC
PROC HideWindow( window:PTR TO window ) IS NATIVE {-IIntuition->HideWindow(} window {)} ENDNATIVE !!INT
->NATIVE {GetAttrsA} PROC
PROC GetAttrsA( object:PTR TO INTUIOBJECT, tagList:ARRAY OF tagitem ) IS NATIVE {IIntuition->GetAttrsA(} object {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {GetAttrs} PROC
PROC GetAttrs( object:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->GetAttrs(} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {LockGUIPrefs} PROC
PROC LockGUIPrefs( reserved:ULONG ) IS NATIVE {IIntuition->LockGUIPrefs(} reserved {)} ENDNATIVE !!APTR
->NATIVE {UnlockGUIPrefs} PROC
PROC UnlockGUIPrefs( lock:APTR ) IS NATIVE {IIntuition->UnlockGUIPrefs(} lock {)} ENDNATIVE
->NATIVE {SetGUIAttrsA} PROC
PROC SetGUIAttrsA( reserved:APTR, drawinfo:PTR TO drawinfo, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetGUIAttrsA(} reserved {,} drawinfo {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {SetGUIAttrs} PROC
PROC SetGUIAttrs( reserved:APTR, drawinfo:PTR TO drawinfo, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->SetGUIAttrs(} reserved {,} drawinfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {GetGUIAttrsA} PROC
PROC GetGUIAttrsA( reserved:APTR, drawinfo:PTR TO drawinfo, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->GetGUIAttrsA(} reserved {,} drawinfo {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {GetGUIAttrs} PROC
PROC GetGUIAttrs( reserved:APTR, drawinfo:PTR TO drawinfo, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->GetGUIAttrs(} reserved {,} drawinfo {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {GetHalfPens} PROC
PROC GetHalfPens( drawinfo:PTR TO drawinfo, basepen:ULONG, halfshineptr:PTR TO UINT, halfshadowptr:PTR TO UINT ) IS NATIVE {IIntuition->GetHalfPens(} drawinfo {,} basepen {,} halfshineptr {,} halfshadowptr {)} ENDNATIVE !!ULONG
->NATIVE {GadgetBox} PROC
PROC GadgetBox( gadget:PTR TO gadget, domain:APTR, domaintype:ULONG, flags:ULONG, box:APTR ) IS NATIVE {IIntuition->GadgetBox(} gadget {,} domain {,} domaintype {,} flags {,} box {)} ENDNATIVE !!ULONG
->NATIVE {LockScreen} PROC
PROC LockScreen( screen:PTR TO screen, micros:ULONG ) IS NATIVE {-IIntuition->LockScreen(} screen {,} micros {)} ENDNATIVE !!INT
->NATIVE {UnlockScreen} PROC
PROC UnlockScreen( screen:PTR TO screen ) IS NATIVE {IIntuition->UnlockScreen(} screen {)} ENDNATIVE
->NATIVE {LockScreenGI} PROC
PROC LockScreenGI( gi:PTR TO gadgetinfo, micros:ULONG ) IS NATIVE {IIntuition->LockScreenGI(} gi {,} micros {)} ENDNATIVE !!PTR TO rastport
->NATIVE {UnlockScreenGI} PROC
PROC UnlockScreenGI( gi:PTR TO gadgetinfo, rp:PTR TO rastport ) IS NATIVE {IIntuition->UnlockScreenGI(} gi {,} rp {)} ENDNATIVE
->NATIVE {IDoMethodA} PROC
PROC IdoMethodA( object:PTR TO /*Object*/ ULONG, msg:PTR TO msg ) IS NATIVE {IIntuition->IDoMethodA(} object {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {IDoMethod} PROC
PROC IdoMethod( object:PTR TO /*Object*/ ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->IDoMethod(} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {IDoSuperMethodA} PROC
PROC IdoSuperMethodA( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, msg:PTR TO msg ) IS NATIVE {IIntuition->IDoSuperMethodA(} cl {,} object {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {IDoSuperMethod} PROC
PROC IdoSuperMethod( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->IDoSuperMethod(} cl {,} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ISetSuperAttrsA} PROC
PROC IsetSuperAttrsA( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->ISetSuperAttrsA(} cl {,} object {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {ISetSuperAttrs} PROC
PROC IsetSuperAttrs( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->ISetSuperAttrs(} cl {,} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ICoerceMethodA} PROC
PROC IcoerceMethodA( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, msg:PTR TO msg ) IS NATIVE {IIntuition->ICoerceMethodA(} cl {,} object {,} msg {)} ENDNATIVE !!ULONG
->NATIVE {ICoerceMethod} PROC
PROC IcoerceMethod( cl:PTR TO iclass, object:PTR TO /*Object*/ ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->ICoerceMethod(} cl {,} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {RefreshSetGadgetAttrsA} PROC
PROC RefreshSetGadgetAttrsA( gadget:PTR TO gadget, window:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->RefreshSetGadgetAttrsA(} gadget {,} window {,} req {,} taglist {)} ENDNATIVE
->NATIVE {RefreshSetGadgetAttrs} PROC
PROC RefreshSetGadgetAttrs( gadget:PTR TO gadget, window:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->RefreshSetGadgetAttrs(} gadget {,} window {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {OpenClass} PROC
PROC OpenClass( name:/*STRPTR*/ ARRAY OF CHAR, version:ULONG, cl_ptr:ARRAY OF PTR TO iclass ) IS NATIVE {IIntuition->OpenClass(} name {,} version {,} cl_ptr {)} ENDNATIVE !!PTR TO classlibrary
->NATIVE {CloseClass} PROC
PROC CloseClass( cl:PTR TO classlibrary ) IS NATIVE {IIntuition->CloseClass(} cl {)} ENDNATIVE
->NATIVE {SetWindowAttr} PROC
PROC SetWindowAttr( win:PTR TO window, attr:ULONG, data:APTR, size:ULONG ) IS NATIVE {IIntuition->SetWindowAttr(} win {,} attr {,} data {,} size {)} ENDNATIVE !!VALUE
->NATIVE {GetWindowAttr} PROC
PROC GetWindowAttr( win:PTR TO window, attr:ULONG, data:APTR, size:ULONG ) IS NATIVE {IIntuition->GetWindowAttr(} win {,} attr {,} data {,} size {)} ENDNATIVE !!VALUE
->NATIVE {SetWindowAttrsA} PROC
PROC SetWindowAttrsA( win:PTR TO window, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetWindowAttrsA(} win {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {SetWindowAttrs} PROC
PROC SetWindowAttrs( win:PTR TO window, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->SetWindowAttrs(} win {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetWindowAttrsA} PROC
PROC GetWindowAttrsA( win:PTR TO window, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->GetWindowAttrsA(} win {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {GetWindowAttrs} PROC
PROC GetWindowAttrs( win:PTR TO window, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->GetWindowAttrs(} win {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {StripIntuiMessages} PROC
PROC StripIntuiMessages( port:PTR TO mp, win:PTR TO window ) IS NATIVE {IIntuition->StripIntuiMessages(} port {,} win {)} ENDNATIVE
->NATIVE {StartScreenNotifyTagList} PROC
PROC StartScreenNotifyTagList( taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->StartScreenNotifyTagList(} taglist {)} ENDNATIVE !!APTR
->NATIVE {StartScreenNotifyTags} PROC
PROC StartScreenNotifyTags( tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->StartScreenNotifyTags(} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {EndScreenNotify} PROC
PROC EndScreenNotify( request:APTR ) IS NATIVE {-IIntuition->EndScreenNotify(} request {)} ENDNATIVE !!INT
->NATIVE {SetScreenAttr} PROC
PROC SetScreenAttr( scr:PTR TO screen, attr:ULONG, data:APTR, size:ULONG ) IS NATIVE {IIntuition->SetScreenAttr(} scr {,} attr {,} data {,} size {)} ENDNATIVE !!VALUE
->NATIVE {GetScreenAttr} PROC
PROC GetScreenAttr( scr:PTR TO screen, attr:ULONG, data:APTR, size:ULONG ) IS NATIVE {IIntuition->GetScreenAttr(} scr {,} attr {,} data {,} size {)} ENDNATIVE !!VALUE
->NATIVE {SetScreenAttrsA} PROC
PROC SetScreenAttrsA( scr:PTR TO screen, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->SetScreenAttrsA(} scr {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {SetScreenAttrs} PROC
PROC SetScreenAttrs( scr:PTR TO screen, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->SetScreenAttrs(} scr {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetScreenAttrsA} PROC
PROC GetScreenAttrsA( scr:PTR TO screen, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->GetScreenAttrsA(} scr {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {GetScreenAttrs} PROC
PROC GetScreenAttrs( scr:PTR TO screen, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->GetScreenAttrs(} scr {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {LockScreenList} PROC
PROC LockScreenList( ) IS NATIVE {IIntuition->LockScreenList()} ENDNATIVE !!PTR TO screen
->NATIVE {UnlockScreenList} PROC
PROC UnlockScreenList( ) IS NATIVE {IIntuition->UnlockScreenList()} ENDNATIVE
->NATIVE {GetMarkedBlock} PROC
PROC GetMarkedBlock( sgw:PTR TO sgwork ) IS NATIVE {IIntuition->GetMarkedBlock(} sgw {)} ENDNATIVE !!ULONG
->NATIVE {SetMarkedBlock} PROC
PROC SetMarkedBlock( sgw:PTR TO sgwork, block:ULONG ) IS NATIVE {IIntuition->SetMarkedBlock(} sgw {,} block {)} ENDNATIVE
->NATIVE {ObtainBitMapSourceA} PROC
PROC ObtainBitMapSourceA( name:/*STRPTR*/ ARRAY OF CHAR, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->ObtainBitMapSourceA(} name {,} taglist {)} ENDNATIVE !!APTR
->NATIVE {ObtainBitMapSource} PROC
PROC ObtainBitMapSource( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->ObtainBitMapSource(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {ReleaseBitMapSource} PROC
PROC ReleaseBitMapSource( bitmapsource:APTR ) IS NATIVE {IIntuition->ReleaseBitMapSource(} bitmapsource {)} ENDNATIVE
->NATIVE {ObtainBitMapInstanceA} PROC
PROC ObtainBitMapInstanceA( bitmapsource:APTR, screen:PTR TO screen, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->ObtainBitMapInstanceA(} bitmapsource {,} screen {,} taglist {)} ENDNATIVE !!APTR
->NATIVE {ObtainBitMapInstance} PROC
PROC ObtainBitMapInstance( bitmapsource:APTR, screen:PTR TO screen, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->ObtainBitMapInstance(} bitmapsource {,} screen {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {ReleaseBitMapInstance} PROC
PROC ReleaseBitMapInstance( bitmapinstance:APTR ) IS NATIVE {IIntuition->ReleaseBitMapInstance(} bitmapinstance {)} ENDNATIVE
->NATIVE {EmbossDisableRect} PROC
PROC EmbossDisableRect( rp:PTR TO rastport, minx:VALUE, miny:VALUE, maxx:VALUE, maxy:VALUE, backtype:ULONG, contrast:ULONG, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->EmbossDisableRect(} rp {,} minx {,} miny {,} maxx {,} maxy {,} backtype {,} contrast {,} dri {)} ENDNATIVE
->NATIVE {EmbossDisableText} PROC
PROC EmbossDisableText( rp:PTR TO rastport, text:/*STRPTR*/ ARRAY OF CHAR, len:ULONG, backtype:ULONG, contrast:ULONG, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->EmbossDisableText(} rp {,} text {,} len {,} backtype {,} contrast {,} dri {)} ENDNATIVE
->NATIVE {PrintEmbossedDisabledIText} PROC
PROC PrintEmbossedDisabledIText( rp:PTR TO rastport, itext:PTR TO intuitext, left:VALUE, top:VALUE, backtype:ULONG, contrast:ULONG, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->PrintEmbossedDisabledIText(} rp {,} itext {,} left {,} top {,} backtype {,} contrast {,} dri {)} ENDNATIVE
->NATIVE {IntuiTextExtent} PROC
PROC IntuiTextExtent( rp:PTR TO rastport, itext:PTR TO intuitext, textent:PTR TO textextent ) IS NATIVE {IIntuition->IntuiTextExtent(} rp {,} itext {,} textent {)} ENDNATIVE !!ULONG
->NATIVE {ShadeRectOld} PROC
PROC ShadeRectOld( rp:PTR TO rastport, minx:VALUE, miny:VALUE, maxx:VALUE, maxy:VALUE, shadelevel:ULONG, backtype:ULONG, state:ULONG, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->ShadeRectOld(} rp {,} minx {,} miny {,} maxx {,} maxy {,} shadelevel {,} backtype {,} state {,} dri {)} ENDNATIVE !!ULONG
->NATIVE {FindMenuKey} PROC
PROC FindMenuKey( menu:PTR TO menu, code:VALUE ) IS NATIVE {IIntuition->FindMenuKey(} menu {,} code {)} ENDNATIVE !!UINT
->NATIVE {BitMapInstanceControlA} PROC
PROC BitMapInstanceControlA( bitmapinstance:APTR, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->BitMapInstanceControlA(} bitmapinstance {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {BitMapInstanceControl} PROC
PROC BitMapInstanceControl( bitmapinstance:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->BitMapInstanceControl(} bitmapinstance {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ObtainIPluginList} PROC
PROC ObtainIPluginList( type:ULONG, attrmask:ULONG, applymask:ULONG ) IS NATIVE {IIntuition->ObtainIPluginList(} type {,} attrmask {,} applymask {)} ENDNATIVE !!PTR TO lh
->NATIVE {ReleaseIPluginList} PROC
PROC ReleaseIPluginList( list:PTR TO lh ) IS NATIVE {IIntuition->ReleaseIPluginList(} list {)} ENDNATIVE
->NATIVE {OpenGUIPlugin} PROC
PROC OpenGUIPlugin( name:/*STRPTR*/ ARRAY OF CHAR, version:ULONG, type:ULONG, attrmask:ULONG, applymask:ULONG ) IS NATIVE {IIntuition->OpenGUIPlugin(} name {,} version {,} type {,} attrmask {,} applymask {)} ENDNATIVE !!PTR TO guiplugin
->NATIVE {CloseGUIPlugin} PROC
PROC CloseGUIPlugin( plugin:PTR TO guiplugin ) IS NATIVE {IIntuition->CloseGUIPlugin(} plugin {)} ENDNATIVE
->NATIVE {DrawSysImageA} PROC
PROC DrawSysImageA( rp:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, which:ULONG, backtype:ULONG, state:ULONG, dri:PTR TO drawinfo, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->DrawSysImageA(} rp {,} left {,} top {,} width {,} height {,} which {,} backtype {,} state {,} dri {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {DrawSysImage} PROC
PROC DrawSysImage( rp:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, which:ULONG, backtype:ULONG, state:ULONG, dri:PTR TO drawinfo, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->DrawSysImage(} rp {,} left {,} top {,} width {,} height {,} which {,} backtype {,} state {,} dri {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {DoRender} PROC
PROC DoRender( o:PTR TO /*Object*/ ULONG, gi:PTR TO gadgetinfo, flags:ULONG ) IS NATIVE {IIntuition->DoRender(} o {,} gi {,} flags {)} ENDNATIVE !!ULONG
->NATIVE {SetRenderDomain} PROC
PROC SetRenderDomain( rp:PTR TO rastport, domain:PTR TO rectangle ) IS NATIVE {IIntuition->SetRenderDomain(} rp {,} domain {)} ENDNATIVE !!ULONG
->NATIVE {GetRenderDomain} PROC
PROC GetRenderDomain( rp:PTR TO rastport, domain:PTR TO rectangle ) IS NATIVE {IIntuition->GetRenderDomain(} rp {,} domain {)} ENDNATIVE !!ULONG
->NATIVE {DrawGradient} PROC
PROC DrawGradient( rp:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, domain:PTR TO ibox, reserved:ULONG, gs:PTR TO gradientspec, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->DrawGradient(} rp {,} left {,} top {,} width {,} height {,} domain {,} reserved {,} gs {,} dri {)} ENDNATIVE !!ULONG
->NATIVE {DirectionVector} PROC
PROC DirectionVector( degrees:ULONG ) IS NATIVE {IIntuition->DirectionVector(} degrees {)} ENDNATIVE !!ULONG
->NATIVE {ShadeRectA} PROC
PROC ShadeRectA( rp:PTR TO rastport, minx:VALUE, miny:VALUE, maxx:VALUE, maxy:VALUE, shadelevel:ULONG, backtype:ULONG, state:ULONG, dri:PTR TO drawinfo, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->ShadeRectA(} rp {,} minx {,} miny {,} maxx {,} maxy {,} shadelevel {,} backtype {,} state {,} dri {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {ShadeRect} PROC
PROC ShadeRect( rp:PTR TO rastport, minx:VALUE, miny:VALUE, maxx:VALUE, maxy:VALUE, shadelevel:ULONG, backtype:ULONG, state:ULONG, dri:PTR TO drawinfo, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->ShadeRect(} rp {,} minx {,} miny {,} maxx {,} maxy {,} shadelevel {,} backtype {,} state {,} dri {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {SetDisplayBeepHook} PROC
->Would not compile: PROC SetDisplayBeepHook( hook:PTR TO hook ) IS NATIVE {IIntuition->SetDisplayBeepHook(} hook {)} ENDNATIVE !!PTR TO hook
->NATIVE {DoScrollHook} PROC
PROC DoScrollHook( scrollhook:PTR TO scrollhook, mode:VALUE ) IS NATIVE {IIntuition->DoScrollHook(} scrollhook {,} mode {)} ENDNATIVE
->NATIVE {ObtainIBackFill} PROC
PROC ObtainIBackFill( dri:PTR TO drawinfo, element:ULONG, state:ULONG, flags:ULONG ) IS NATIVE {IIntuition->ObtainIBackFill(} dri {,} element {,} state {,} flags {)} ENDNATIVE !!PTR TO hook
->NATIVE {ReleaseIBackFill} PROC
PROC ReleaseIBackFill( hook:PTR TO hook ) IS NATIVE {IIntuition->ReleaseIBackFill(} hook {)} ENDNATIVE
->NATIVE {IntuitionControlA} PROC
PROC IntuitionControlA( object:APTR, taglist:ARRAY OF tagitem ) IS NATIVE {IIntuition->IntuitionControlA(} object {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {IntuitionControl} PROC
PROC IntuitionControl( object:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIntuition->IntuitionControl(} object {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {DisableTemplate} PROC
PROC DisableTemplate( rp:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, template_ptr:APTR, offx:VALUE, template_type:ULONG, bytesperrow:ULONG, backtype:ULONG, dri:PTR TO drawinfo ) IS NATIVE {IIntuition->DisableTemplate(} rp {,} left {,} top {,} width {,} height {,} template_ptr {,} offx {,} template_type {,} bytesperrow {,} backtype {,} dri {)} ENDNATIVE
