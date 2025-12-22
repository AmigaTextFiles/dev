OPT NATIVE
PUBLIC MODULE 'target/workbench/handler', 'target/workbench/icon', 'target/workbench/startup', 'target/workbench/workbench'
MODULE 'target/aros/libcall', 'target/workbench/workbench', 'target/dos/bptr'
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dos', 'target/utility/tagitem', 'target/intuition/intuition', 'target/utility/hooks', 'target/exec/libraries'
{
#include <proto/wb.h>
}
{
struct Library* WorkbenchBase = NULL;
}
NATIVE {CLIB_WORKBENCH_PROTOS_H} CONST
NATIVE {CLIB_WB_PROTOS_H} CONST

NATIVE {WorkbenchBase} DEF workbenchbase:PTR TO lib		->AmigaE does not automatically initialise this

/* Prototypes for stubs in amiga.lib */
NATIVE {AddAppIcon} PROC
PROC AddAppIcon( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {AddAppIcon(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appicon
NATIVE {AddAppMenuItem} PROC
PROC AddAppMenuItem( id:ULONG, userdata:ULONG, text:/*STRPTR*/ ARRAY OF CHAR, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {AddAppMenuItem(} id {,} userdata {,} text {,} msgport {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appmenuitem
NATIVE {AddAppWindow} PROC
PROC AddAppWindow( id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {AddAppWindow(} id {,} userdata {,} window {,} msgport {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appwindow
NATIVE {AddAppWindowDropZone} PROC
PROC AddAppWindowDropZone( aw:PTR TO appwindow, id:ULONG, userdata:ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {AddAppWindowDropZone(} aw {,} id {,} userdata {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO appwindowdropzone
NATIVE {CloseWorkbenchObject} PROC
PROC CloseWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-CloseWorkbenchObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {MakeWorkbenchObjectVisible} PROC
PROC MakeWorkbenchObjectVisible( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-MakeWorkbenchObjectVisible(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {OpenWorkbenchObject} PROC
PROC OpenWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-OpenWorkbenchObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
NATIVE {WorkbenchControl} PROC
PROC WorkbenchControl( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-WorkbenchControl(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT

NATIVE {AddAppWindowA} PROC
PROC AddAppWindowA(id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, taglist:ARRAY OF tagitem) IS NATIVE {AddAppWindowA(} id {,} userdata {,} window {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appwindow
NATIVE {RemoveAppWindow} PROC
PROC RemoveAppWindow(appWindow:PTR TO appwindow) IS NATIVE {-RemoveAppWindow(} appWindow {)} ENDNATIVE !!INT
NATIVE {AddAppIconA} PROC
PROC AddAppIconA(id:ULONG, userdata:ULONG, text:ARRAY OF CHAR, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, taglist:ARRAY OF tagitem) IS NATIVE {AddAppIconA(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} taglist {)} ENDNATIVE !!PTR TO appicon
NATIVE {RemoveAppIcon} PROC
PROC RemoveAppIcon(appIcon:PTR TO appicon) IS NATIVE {-RemoveAppIcon(} appIcon {)} ENDNATIVE !!INT
NATIVE {AddAppMenuItemA} PROC
PROC AddAppMenuItemA(id:ULONG, userdata:ULONG, text:APTR, msgport:PTR TO mp, taglist:ARRAY OF tagitem) IS NATIVE {AddAppMenuItemA(} id {,} userdata {,} text {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appmenuitem
NATIVE {RemoveAppMenuItem} PROC
PROC RemoveAppMenuItem(appMenuItem:PTR TO appmenuitem) IS NATIVE {-RemoveAppMenuItem(} appMenuItem {)} ENDNATIVE !!INT
NATIVE {WBInfo} PROC
PROC WbInfo(lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR, screen:PTR TO screen) IS NATIVE {-WBInfo(} lock {,} name {,} screen {)} ENDNATIVE !!INT
NATIVE {OpenWorkbenchObjectA} PROC
PROC OpenWorkbenchObjectA(name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {-OpenWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
NATIVE {CloseWorkbenchObjectA} PROC
PROC CloseWorkbenchObjectA(name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {-CloseWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
NATIVE {WorkbenchControlA} PROC
PROC WorkbenchControlA(name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {-WorkbenchControlA(} name {,} tags {)} ENDNATIVE !!INT
NATIVE {AddAppWindowDropZoneA} PROC
PROC AddAppWindowDropZoneA(aw:PTR TO appwindow, id:ULONG, userdata:ULONG, tags:ARRAY OF tagitem) IS NATIVE {AddAppWindowDropZoneA(} aw {,} id {,} userdata {,} tags {)} ENDNATIVE !!PTR TO appwindowdropzone
NATIVE {RemoveAppWindowDropZone} PROC
PROC RemoveAppWindowDropZone(aw:PTR TO appwindow, dropZone:PTR TO appwindowdropzone) IS NATIVE {-RemoveAppWindowDropZone(} aw {,} dropZone {)} ENDNATIVE !!INT
NATIVE {ChangeWorkbenchSelectionA} PROC
PROC ChangeWorkbenchSelectionA(name:/*STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, tags:ARRAY OF tagitem) IS NATIVE {-ChangeWorkbenchSelectionA(} name {,} hook {,} tags {)} ENDNATIVE !!INT
NATIVE {MakeWorkbenchObjectVisibleA} PROC
PROC MakeWorkbenchObjectVisibleA(name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {-MakeWorkbenchObjectVisibleA(} name {,} tags {)} ENDNATIVE !!INT
NATIVE {RegisterWorkbench} PROC
PROC RegisterWorkbench(messageport:PTR TO mp) IS NATIVE {-RegisterWorkbench(} messageport {)} ENDNATIVE !!INT
NATIVE {UnregisterWorkbench} PROC
PROC UnregisterWorkbench(messageport:PTR TO mp) IS NATIVE {-UnregisterWorkbench(} messageport {)} ENDNATIVE !!INT
NATIVE {UpdateWorkbenchObjectA} PROC
PROC UpdateWorkbenchObjectA(name:/*STRPTR*/ ARRAY OF CHAR, type:VALUE, tags:ARRAY OF tagitem) IS NATIVE {-UpdateWorkbenchObjectA(} name {,} type {,} tags {)} ENDNATIVE !!INT
NATIVE {SendAppWindowMessage} PROC
PROC SendAppWindowMessage(win:PTR TO window, numfiles:ULONG, files:ARRAY OF ARRAY OF CHAR, class:UINT, mousex:INT, mousey:INT, seconds:ULONG, micros:ULONG) IS NATIVE {-SendAppWindowMessage(} win {,} numfiles {,} files {,} class {,} mousex {,} mousey {,} seconds {,} micros {)} ENDNATIVE !!INT
NATIVE {GetNextAppIcon} PROC
PROC GetNextAppIcon(lastdiskobj:PTR TO diskobject, text:ARRAY OF CHAR) IS NATIVE {GetNextAppIcon(} lastdiskobj {,} text {)} ENDNATIVE !!PTR TO diskobject
