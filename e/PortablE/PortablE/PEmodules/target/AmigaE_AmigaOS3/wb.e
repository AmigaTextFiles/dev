/* $VER: wb_protos.h 44.5 (21.6.1999) */
OPT NATIVE
PUBLIC MODULE 'target/workbench/startup', 'target/workbench/workbench'
MODULE 'target/exec/types', 'target/dos/dos', 'target/workbench/workbench', 'target/intuition/intuition', 'target/utility/tagitem'
MODULE 'target/exec/ports', 'target/utility/hooks', 'target/exec/libraries'
{MODULE 'wb'}

NATIVE {workbenchbase} DEF workbenchbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V36 or higher (Release 2.0) ---*/

NATIVE {AddAppWindowA} PROC
PROC AddAppWindowA( id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, taglist:ARRAY OF tagitem ) IS NATIVE {AddAppWindowA(} id {,} userdata {,} window {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appwindow
->NATIVE {AddAppWindow} PROC
->PROC AddAppWindow( id:ULONG, userdata:ULONG, window:PTR TO window, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {AddAppWindow(} id {,} userdata {,} window {,} msgport {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO appwindow

NATIVE {RemoveAppWindow} PROC
PROC RemoveAppWindow( appWindow:PTR TO appwindow ) IS NATIVE {RemoveAppWindow(} appWindow {)} ENDNATIVE !!INT

NATIVE {AddAppIconA} PROC
PROC AddAppIconA( id:ULONG, userdata:ULONG, text:ARRAY OF UBYTE, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, taglist:ARRAY OF tagitem ) IS NATIVE {AddAppIconA(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} taglist {)} ENDNATIVE !!PTR TO appicon
->NATIVE {AddAppIcon} PROC
->PROC AddAppIcon( id:ULONG, userdata:ULONG, text:ARRAY OF UBYTE, msgport:PTR TO mp, lock:BPTR, diskobj:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {AddAppIcon(} id {,} userdata {,} text {,} msgport {,} lock {,} diskobj {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO appicon

NATIVE {RemoveAppIcon} PROC
PROC RemoveAppIcon( appIcon:PTR TO appicon ) IS NATIVE {RemoveAppIcon(} appIcon {)} ENDNATIVE !!INT

NATIVE {AddAppMenuItemA} PROC
PROC AddAppMenuItemA( id:ULONG, userdata:ULONG, text:ARRAY OF UBYTE, msgport:PTR TO mp, taglist:ARRAY OF tagitem ) IS NATIVE {AddAppMenuItemA(} id {,} userdata {,} text {,} msgport {,} taglist {)} ENDNATIVE !!PTR TO appmenuitem
->NATIVE {AddAppMenuItem} PROC
->PROC AddAppMenuItem( id:ULONG, userdata:ULONG, text:ARRAY OF UBYTE, msgport:PTR TO mp, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {AddAppMenuItem(} id {,} userdata {,} text {,} msgport {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO appmenuitem

NATIVE {RemoveAppMenuItem} PROC
PROC RemoveAppMenuItem( appMenuItem:PTR TO appmenuitem ) IS NATIVE {RemoveAppMenuItem(} appMenuItem {)} ENDNATIVE !!INT

/*--- functions in V39 or higher (Release 3) ---*/


NATIVE {WBInfo} PROC
PROC WbInfo( lock:BPTR, name:/*STRPTR*/ ARRAY OF CHAR, screen:PTR TO screen ) IS NATIVE {WbInfo(} lock {,} name {,} screen {)} ENDNATIVE

/*--- functions in V44 or higher (Release 3.5) ---*/
->NATIVE {OpenWorkbenchObjectA} PROC
->PROC OpenWorkbenchObjectA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {OpenWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {OpenWorkbenchObject} PROC
->PROC OpenWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, name3=0:ULONG, name4=0:ULONG, name5=0:ULONG, name6=0:ULONG, name7=0:ULONG, name8=0:ULONG ) IS NATIVE {OpenWorkbenchObject(} name {,} name2 {,} name3 {,} name4 {,} name5 {,} name6 {,} name7 {,} name8 {)} ENDNATIVE !!INT
->NATIVE {CloseWorkbenchObjectA} PROC
->PROC CloseWorkbenchObjectA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {CloseWorkbenchObjectA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {CloseWorkbenchObject} PROC
->PROC CloseWorkbenchObject( name:/*STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, name3=0:ULONG, name4=0:ULONG, name5=0:ULONG, name6=0:ULONG, name7=0:ULONG, name8=0:ULONG ) IS NATIVE {CloseWorkbenchObject(} name {,} name2 {,} name3 {,} name4 {,} name5 {,} name6 {,} name7 {,} name8 {)} ENDNATIVE !!INT
->NATIVE {WorkbenchControlA} PROC
->PROC WorkbenchControlA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {WorkbenchControlA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {WorkbenchControl} PROC
->PROC WorkbenchControl( name:/*STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, name3=0:ULONG, name4=0:ULONG, name5=0:ULONG, name6=0:ULONG, name7=0:ULONG, name8=0:ULONG ) IS NATIVE {WorkbenchControl(} name {,} name2 {,} name3 {,} name4 {,} name5 {,} name6 {,} name7 {,} name8 {)} ENDNATIVE !!INT
->NATIVE {AddAppWindowDropZoneA} PROC
->PROC AddAppWindowDropZoneA( aw:PTR TO appwindow, id:ULONG, userdata:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {AddAppWindowDropZoneA(} aw {,} id {,} userdata {,} tags {)} ENDNATIVE !!PTR TO appwindowdropzone
->NATIVE {AddAppWindowDropZone} PROC
->PROC AddAppWindowDropZone( aw:PTR TO appwindow, id:ULONG, userdata:ULONG, userdata2=0:ULONG, userdata3=0:ULONG, userdata4=0:ULONG, userdata5=0:ULONG, userdata6=0:ULONG, userdata7=0:ULONG, userdata8=0:ULONG ) IS NATIVE {AddAppWindowDropZone(} aw {,} id {,} userdata {,} userdata2 {,} userdata3 {,} userdata4 {,} userdata5 {,} userdata6 {,} userdata7 {,} userdata8 {)} ENDNATIVE !!PTR TO appwindowdropzone
->NATIVE {RemoveAppWindowDropZone} PROC
->PROC RemoveAppWindowDropZone( aw:PTR TO appwindow, dropZone:PTR TO appwindowdropzone ) IS NATIVE {RemoveAppWindowDropZone(} aw {,} dropZone {)} ENDNATIVE !!INT
->NATIVE {ChangeWorkbenchSelectionA} PROC
->PROC ChangeWorkbenchSelectionA( name:/*STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, tags:ARRAY OF tagitem ) IS NATIVE {ChangeWorkbenchSelectionA(} name {,} hook {,} tags {)} ENDNATIVE !!INT
->NATIVE {ChangeWorkbenchSelection} PROC
->PROC ChangeWorkbenchSelection( name:/*STRPTR*/ ARRAY OF CHAR, hook:PTR TO hook, hook2=0:ULONG, hook3=0:ULONG, hook4=0:ULONG, hook5=0:ULONG, hook6=0:ULONG, hook7=0:ULONG, hook8=0:ULONG ) IS NATIVE {ChangeWorkbenchSelection(} name {,} hook {,} hook2 {,} hook3 {,} hook4 {,} hook5 {,} hook6 {,} hook7 {,} hook8 {)} ENDNATIVE !!INT
->NATIVE {MakeWorkbenchObjectVisibleA} PROC
->PROC MakeWorkbenchObjectVisibleA( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {MakeWorkbenchObjectVisibleA(} name {,} tags {)} ENDNATIVE !!INT
->NATIVE {MakeWorkbenchObjectVisible} PROC
->PROC MakeWorkbenchObjectVisible( name:/*STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, name3=0:ULONG, name4=0:ULONG, name5=0:ULONG, name6=0:ULONG, name7=0:ULONG, name8=0:ULONG ) IS NATIVE {MakeWorkbenchObjectVisible(} name {,} name2 {,} name3 {,} name4 {,} name5 {,} name6 {,} name7 {,} name8 {)} ENDNATIVE !!INT
