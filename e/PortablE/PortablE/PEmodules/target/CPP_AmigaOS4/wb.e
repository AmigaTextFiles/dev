/* $Id: wb_protos.h,v 1.11 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/workbench/icon', 'target/workbench/startup', 'target/workbench/workbench'
MODULE 'target/exec/types', 'target/dos/dos', 'target/workbench/workbench', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/exec/ports', 'target/utility/hooks'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/wb.h>
}
{
struct Library* WorkbenchBase = NULL;
struct WorkbenchIFace* IWorkbench = NULL;
}
NATIVE {CLIB_WB_PROTOS_H} CONST
NATIVE {PROTO_WB_H} CONST
NATIVE {PRAGMA_WB_H} CONST
NATIVE {INLINE4_WB_H} CONST
NATIVE {WB_INTERFACE_DEF_H} CONST

NATIVE {WorkbenchBase} DEF workbenchbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IWorkbench}    DEF

PROC new()
	InitLibrary('workbench.library', NATIVE {(struct Interface **) &IWorkbench} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {UpdateWorkbench} PROC
PROC UpdateWorkbench( name:/*STRPTR*/ ARRAY OF CHAR, lock:ULONG, action:VALUE ) IS NATIVE {IWorkbench->UpdateWorkbench(} name {,} lock {,} action {)} ENDNATIVE

->NATIVE {AddAppWindowA} PROC
PROC AddAppWindowA( id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, taglist:ARRAY OF tagitem ) IS NATIVE {IWorkbench->AddAppWindowA(} id {,} userdata {,} window {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appwindow
->NATIVE {AddAppWindow} PROC
PROC AddAppWindow( id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IWorkbench->AddAppWindow(} id {,} userdata {,} window {,} msgport {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appwindow

->NATIVE {RemoveAppWindow} PROC
PROC RemoveAppWindow( appWindow:PTR TO appwindow ) IS NATIVE {-IWorkbench->RemoveAppWindow(} appWindow {)} ENDNATIVE !!INT

->NATIVE {AddAppIconA} PROC
PROC AddAppIconA( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, taglist:ARRAY OF tagitem ) IS NATIVE {IWorkbench->AddAppIconA(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} taglist {)} ENDNATIVE !!PTR TO appicon
->NATIVE {AddAppIcon} PROC
PROC AddAppIcon( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IWorkbench->AddAppIcon(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appicon

->NATIVE {RemoveAppIcon} PROC
PROC RemoveAppIcon( appIcon:PTR TO appicon ) IS NATIVE {-IWorkbench->RemoveAppIcon(} appIcon {)} ENDNATIVE !!INT

->NATIVE {AddAppMenuItemA} PROC
PROC AddAppMenuItemA( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, taglist:ARRAY OF tagitem ) IS NATIVE {IWorkbench->AddAppMenuItemA(} id {,} userdata {,} text {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appmenuitem
->NATIVE {AddAppMenuItem} PROC
PROC AddAppMenuItem( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IWorkbench->AddAppMenuItem(} id {,} userdata {,} text {,} msgport {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appmenuitem

->NATIVE {RemoveAppMenuItem} PROC
PROC RemoveAppMenuItem( appMenuItem:PTR TO appmenuitem ) IS NATIVE {-IWorkbench->RemoveAppMenuItem(} appMenuItem {)} ENDNATIVE !!INT

/*--- functions in V39 or higher (Release 3) ---*/

->NATIVE {WBInfo} PROC
PROC WbInfo( lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR, screen:PTR TO screen ) IS NATIVE {IWorkbench->WBInfo(} lock {,} name {,} screen {)} ENDNATIVE !!ULONG

/*--- functions in V44 or higher (Release 3.5) ---*/

->NATIVE {OpenWorkbenchObjectA} PROC
PROC OpenWorkbenchObjectA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {-IWorkbench->OpenWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {OpenWorkbenchObject} PROC
PROC OpenWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IWorkbench->OpenWorkbenchObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {CloseWorkbenchObjectA} PROC
PROC CloseWorkbenchObjectA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {-IWorkbench->CloseWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {CloseWorkbenchObject} PROC
PROC CloseWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IWorkbench->CloseWorkbenchObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {WorkbenchControlA} PROC
PROC WorkbenchControlA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {-IWorkbench->WorkbenchControlA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {WorkbenchControl} PROC
PROC WorkbenchControl( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IWorkbench->WorkbenchControl(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {AddAppWindowDropZoneA} PROC
PROC AddAppWindowDropZoneA( aw:PTR TO appwindow, id:ULONG, userdata:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {IWorkbench->AddAppWindowDropZoneA(} aw {,} id {,} userdata {,} tags {)} ENDNATIVE !!PTR TO appwindowdropzone
->NATIVE {AddAppWindowDropZone} PROC
PROC AddAppWindowDropZone( aw:PTR TO appwindow, id:ULONG, userdata:ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IWorkbench->AddAppWindowDropZone(} aw {,} id {,} userdata {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appwindowdropzone
->NATIVE {RemoveAppWindowDropZone} PROC
PROC RemoveAppWindowDropZone( aw:PTR TO appwindow, dropZone:PTR TO appwindowdropzone ) IS NATIVE {-IWorkbench->RemoveAppWindowDropZone(} aw {,} dropZone {)} ENDNATIVE !!INT
->NATIVE {ChangeWorkbenchSelectionA} PROC
PROC ChangeWorkbenchSelectionA( name:/*STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, tags:ARRAY OF tagitem ) IS NATIVE {-IWorkbench->ChangeWorkbenchSelectionA(} name {,} hook {,} tags {)} ENDNATIVE !!INT
->NATIVE {ChangeWorkbenchSelection} PROC
PROC ChangeWorkbenchSelection( name:/*STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IWorkbench->ChangeWorkbenchSelection(} name {,} hook {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {MakeWorkbenchObjectVisibleA} PROC
PROC MakeWorkbenchObjectVisibleA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {-IWorkbench->MakeWorkbenchObjectVisibleA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {MakeWorkbenchObjectVisible} PROC
PROC MakeWorkbenchObjectVisible( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IWorkbench->MakeWorkbenchObjectVisible(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT

/*--- functions in V50 or higher (Release 4) ---*/

->NATIVE {WhichWorkbenchObjectA} PROC
PROC WhichWorkbenchObjectA( window:PTR TO window, x:VALUE, y:VALUE, tags:ARRAY OF tagitem ) IS NATIVE {IWorkbench->WhichWorkbenchObjectA(} window {,} x {,} y {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {WhichWorkbenchObject} PROC
PROC WhichWorkbenchObject( window:PTR TO window, x:VALUE, y:VALUE, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IWorkbench->WhichWorkbenchObject(} window {,} x {,} y {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
