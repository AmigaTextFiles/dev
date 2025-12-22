/* $VER: icon_protos.h 44.17 (15.7.1999) */
OPT NATIVE
MODULE 'target/workbench/workbench', 'target/datatypes/pictureclass'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem', 'target/graphics/rastport', 'target/graphics/gfx', 'target/intuition/screens'
{
#include <proto/icon.h>
}
{
struct Library* IconBase = NULL;
}
NATIVE {CLIB_ICON_PROTOS_H} CONST
NATIVE {_PROTO_ICON_H} CONST
NATIVE {PRAGMA_ICON_H} CONST
NATIVE {PRAGMAS_ICON_PRAGMAS_H} CONST

NATIVE {IconBase} DEF iconbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {FreeFreeList} PROC
PROC FreeFreeList( freelist:PTR TO freelist ) IS NATIVE {FreeFreeList(} freelist {)} ENDNATIVE
NATIVE {AddFreeList} PROC
PROC AddFreeList( freelist:PTR TO freelist, mem:APTR, size:ULONG ) IS NATIVE {-(BOOLEAN)(0!=AddFreeList(} freelist {,} mem {,} size {))} ENDNATIVE !!BOOL
NATIVE {GetDiskObject} PROC
PROC GetDiskObject( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {GetDiskObject(} name {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutDiskObject} PROC
PROC PutDiskObject( name:/*STRPTR*/ ARRAY OF CHAR, diskobj:PTR TO diskobject ) IS NATIVE {-(BOOLEAN)(0!=PutDiskObject(} name {,} diskobj {))} ENDNATIVE !!BOOL
NATIVE {FreeDiskObject} PROC
PROC FreeDiskObject( diskobj:PTR TO diskobject ) IS NATIVE {FreeDiskObject(} diskobj {)} ENDNATIVE
NATIVE {FindToolType} PROC
PROC FindToolType( toolTypeArray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR, typeName:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {FindToolType(} toolTypeArray {,} typeName {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {MatchToolValue} PROC
PROC MatchToolValue( typeString:/*STRPTR*/ ARRAY OF CHAR, value:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=MatchToolValue(} typeString {,} value {))} ENDNATIVE !!BOOL
NATIVE {BumpRevision} PROC
PROC BumpRevision( newname:/*STRPTR*/ ARRAY OF CHAR, oldname:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {BumpRevision(} newname {,} oldname {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
/*--- functions in V36 or higher (Release 2.0) ---*/
NATIVE {GetDefDiskObject} PROC
PROC GetDefDiskObject( type:VALUE ) IS NATIVE {GetDefDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutDefDiskObject} PROC
PROC PutDefDiskObject( diskObject:PTR TO diskobject ) IS NATIVE {-(BOOLEAN)(0!=PutDefDiskObject(} diskObject {))} ENDNATIVE !!BOOL
NATIVE {GetDiskObjectNew} PROC
PROC GetDiskObjectNew( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {GetDiskObjectNew(} name {)} ENDNATIVE !!PTR TO diskobject
/*--- functions in V37 or higher (Release 2.04) ---*/
NATIVE {DeleteDiskObject} PROC
PROC DeleteDiskObject( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {-(BOOLEAN)(0!=DeleteDiskObject(} name {))} ENDNATIVE !!BOOL
/*--- functions in V44 or higher (Release 3.5) ---*/
NATIVE {DupDiskObjectA} PROC
PROC DupDiskObjectA( diskObject:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {DupDiskObjectA(} diskObject {,} tags {)} ENDNATIVE !!PTR TO diskobject
NATIVE {DupDiskObject} PROC
PROC DupDiskObject( diskObject:PTR TO diskobject, diskObject2=0:ULONG, ... ) IS NATIVE {DupDiskObject(} diskObject {,} diskObject2 {,} ... {)} ENDNATIVE !!PTR TO diskobject
NATIVE {IconControlA} PROC
PROC IconControlA( icon:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {IconControlA(} icon {,} tags {)} ENDNATIVE !!ULONG
NATIVE {IconControl} PROC
PROC IconControl( icon:PTR TO diskobject, icon2=0:ULONG, ... ) IS NATIVE {IconControl(} icon {,} icon2 {,} ... {)} ENDNATIVE !!ULONG
NATIVE {DrawIconStateA} PROC
PROC DrawIconStateA( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, leftOffset:VALUE, topOffset:VALUE, state:ULONG, tags:ARRAY OF tagitem ) IS NATIVE {DrawIconStateA(} rp {,} icon {,} label {,} leftOffset {,} topOffset {,} state {,} tags {)} ENDNATIVE
NATIVE {DrawIconState} PROC
PROC DrawIconState( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, leftOffset:VALUE, topOffset:VALUE, state:ULONG, state2=0:ULONG, ... ) IS NATIVE {DrawIconState(} rp {,} icon {,} label {,} leftOffset {,} topOffset {,} state {,} state2 {,} ... {)} ENDNATIVE
NATIVE {GetIconRectangleA} PROC
PROC GetIconRectangleA( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, rect:PTR TO rectangle, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=GetIconRectangleA(} rp {,} icon {,} label {,} rect {,} tags {))} ENDNATIVE !!BOOL
NATIVE {GetIconRectangle} PROC
PROC GetIconRectangle( rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, rect:PTR TO rectangle, rect2=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=GetIconRectangle(} rp {,} icon {,} label {,} rect {,} rect2 {,} ... {))} ENDNATIVE !!BOOL
NATIVE {NewDiskObject} PROC
PROC NewDiskObject( type:VALUE ) IS NATIVE {NewDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
NATIVE {GetIconTagList} PROC
PROC GetIconTagList( name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem ) IS NATIVE {GetIconTagList(} name {,} tags {)} ENDNATIVE !!PTR TO diskobject
NATIVE {GetIconTags} PROC
->PROC GetIconTags( name:/*STRPTR*/ ARRAY OF CHAR, name2=0:ULONG, ... ) IS NATIVE {GetIconTags(} name {,} name2 {,} ... {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutIconTagList} PROC
PROC PutIconTagList( name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=PutIconTagList(} name {,} icon {,} tags {))} ENDNATIVE !!BOOL
NATIVE {PutIconTags} PROC
->PROC PutIconTags( name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject, icon2=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=PutIconTags(} name {,} icon {,} icon2 {,} ... {))} ENDNATIVE !!BOOL
NATIVE {LayoutIconA} PROC
PROC LayoutIconA( icon:PTR TO diskobject, screen:PTR TO screen, tags:ARRAY OF tagitem ) IS NATIVE {-(BOOLEAN)(0!=LayoutIconA(} icon {,} screen {,} tags {))} ENDNATIVE !!BOOL
NATIVE {LayoutIcon} PROC
PROC LayoutIcon( icon:PTR TO diskobject, screen:PTR TO screen, screen2=0:ULONG, ... ) IS NATIVE {-(BOOLEAN)(0!=LayoutIcon(} icon {,} screen {,} screen2 {,} ... {))} ENDNATIVE !!BOOL
NATIVE {ChangeToSelectedIconColor} PROC
PROC ChangeToSelectedIconColor( cr:PTR TO colorregister ) IS NATIVE {ChangeToSelectedIconColor(} cr {)} ENDNATIVE
