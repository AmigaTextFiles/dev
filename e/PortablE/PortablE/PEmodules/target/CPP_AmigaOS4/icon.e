/* $Id: icon_protos.h,v 1.11 2006/01/11 11:02:09 dwuerkner Exp $ */
OPT NATIVE
MODULE 'target/workbench/workbench', 'target/datatypes/pictureclass'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem', 'target/graphics/rastport', 'target/graphics/gfx', 'target/intuition/screens'
{
#include <proto/icon.h>
}
{
struct Library* IconBase = NULL;
struct IconIFace* IIcon = NULL;
}
NATIVE {CLIB_ICON_PROTOS_H} CONST
NATIVE {PROTO_ICON_H} CONST
NATIVE {PRAGMA_ICON_H} CONST
NATIVE {INLINE4_ICON_H} CONST
NATIVE {ICON_INTERFACE_DEF_H} CONST

NATIVE {IconBase} DEF iconbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IIcon}    DEF

PROC new()
	InitLibrary('icon.library', NATIVE {(struct Interface **) &IIcon} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {FreeFreeList} PROC
PROC FreeFreeList( freelist:PTR TO freelist ) IS NATIVE {IIcon->FreeFreeList(} freelist {)} ENDNATIVE
->NATIVE {AddFreeList} PROC
PROC AddFreeList( freelist:PTR TO freelist, mem:APTR, size:ULONG ) IS NATIVE {-(BOOLEAN)(0!=IIcon->AddFreeList(} freelist {,} mem {,} size {))} ENDNATIVE !!BOOL
->NATIVE {GetDiskObject} PROC
PROC GetDiskObject( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIcon->GetDiskObject(} name {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {PutDiskObject} PROC
PROC PutDiskObject( name:/*STRPTR*/ ARRAY OF CHAR, diskobj:PTR TO diskobject ) IS NATIVE {-(BOOLEAN)(0!=IIcon->PutDiskObject(} name {,} diskobj {))} ENDNATIVE !!BOOL
->NATIVE {FreeDiskObject} PROC
PROC FreeDiskObject( diskobj:PTR TO diskobject ) IS NATIVE {IIcon->FreeDiskObject(} diskobj {)} ENDNATIVE
->NATIVE {FindToolType} PROC
PROC FindToolType( toolTypeArray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR, typeName:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIcon->FindToolType(} toolTypeArray {,} typeName {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {MatchToolValue} PROC
PROC MatchToolValue( typeString:/*STRPTR*/ ARRAY OF CHAR, value:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=IIcon->MatchToolValue(} typeString {,} value {))} ENDNATIVE !!BOOL
->NATIVE {BumpRevision} PROC
PROC BumpRevision( newname:/*STRPTR*/ ARRAY OF CHAR, oldname:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIcon->BumpRevision(} newname {,} oldname {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {GetDefDiskObject} PROC
PROC GetDefDiskObject( type:VALUE ) IS NATIVE {IIcon->GetDefDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {PutDefDiskObject} PROC
PROC PutDefDiskObject( diskObject:PTR TO diskobject ) IS NATIVE {-(BOOLEAN)(0!=IIcon->PutDefDiskObject(} diskObject {))} ENDNATIVE !!BOOL
->NATIVE {GetDiskObjectNew} PROC
PROC GetDiskObjectNew( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIcon->GetDiskObjectNew(} name {)} ENDNATIVE !!PTR TO diskobject
/*--- functions in V37 or higher (Release 2.04) ---*/
->NATIVE {DeleteDiskObject} PROC
PROC DeleteDiskObject( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=IIcon->DeleteDiskObject(} name {))} ENDNATIVE !!BOOL
/*--- functions in V44 or higher (Release 3.5) ---*/
->NATIVE {DupDiskObjectA} PROC
PROC DupDiskObjectA( diskObject:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {IIcon->DupDiskObjectA(} diskObject {,} tags {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {DupDiskObject} PROC
PROC DupDiskObject( diskObject:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIcon->DupDiskObject(} diskObject {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {IconControlA} PROC
PROC IconControlA( icon:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {IIcon->IconControlA(} icon {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {IconControl} PROC
PROC IconControl( icon:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIcon->IconControl(} icon {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {DrawIconStateA} PROC
PROC DrawIconStateA( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, leftOffset:VALUE, topOffset:VALUE, state:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {IIcon->DrawIconStateA(} rp {,} icon {,} label {,} leftOffset {,} topOffset {,} state {,} tags {)} ENDNATIVE
->NATIVE {DrawIconState} PROC
PROC DrawIconState( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, leftOffset:VALUE, topOffset:VALUE, state:ULONG, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIcon->DrawIconState(} rp {,} icon {,} label {,} leftOffset {,} topOffset {,} state {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
->NATIVE {GetIconRectangleA} PROC
PROC GetIconRectangleA( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, rect:PTR TO rectangle, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=IIcon->GetIconRectangleA(} rp {,} icon {,} label {,} rect {,} tags {))} ENDNATIVE !!BOOL
->NATIVE {GetIconRectangle} PROC
PROC GetIconRectangle( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, rect:PTR TO rectangle, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=IIcon->GetIconRectangle(} rp {,} icon {,} label {,} rect {,} tag1 {,} tag12 {,} ... {))} ENDNATIVE !!BOOL
->NATIVE {NewDiskObject} PROC
PROC NewDiskObject( type:VALUE ) IS NATIVE {IIcon->NewDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {GetIconTagList} PROC
PROC GetIconTagList( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {IIcon->GetIconTagList(} name {,} tags {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {GetIconTags} PROC
->PROC GetIconTags( name:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IIcon->GetIconTags(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO diskobject
->NATIVE {PutIconTagList} PROC
PROC PutIconTagList( name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=IIcon->PutIconTagList(} name {,} icon {,} tags {))} ENDNATIVE !!BOOL
->NATIVE {PutIconTags} PROC
->PROC PutIconTags( name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=IIcon->PutIconTags(} name {,} icon {,} tag1 {,} tag12 {,} ... {))} ENDNATIVE !!BOOL
->NATIVE {LayoutIconA} PROC
PROC LayoutIconA( icon:PTR TO diskobject, screen:PTR TO screen, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=IIcon->LayoutIconA(} icon {,} screen {,} tags {))} ENDNATIVE !!BOOL
->NATIVE {LayoutIcon} PROC
PROC LayoutIcon( icon:PTR TO diskobject, screen:PTR TO screen, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=IIcon->LayoutIcon(} icon {,} screen {,} tag1 {,} tag12 {,} ... {))} ENDNATIVE !!BOOL
->NATIVE {ChangeToSelectedIconColor} PROC
PROC ChangeToSelectedIconColor( cr:PTR TO colorregister ) IS NATIVE {IIcon->ChangeToSelectedIconColor(} cr {)} ENDNATIVE
/*--- functions in V51 or higher (Release 4.0) ---*/
->NATIVE {BumpRevisionLength} PROC
PROC BumpRevisionLength( newname:/*STRPTR*/ ARRAY OF CHAR, oldname:/*STRPTR*/ ARRAY OF CHAR, maxlength:ULONG ) IS NATIVE {IIcon->BumpRevisionLength(} newname {,} oldname {,} maxlength {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
