OPT NATIVE
MODULE 'target/aros/libcall', 'target/intuition/intuition', 'target/workbench/workbench', 'target/workbench/icon', 'target/utility/tagitem'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/graphics/rastport', 'target/graphics/gfx', 'target/intuition/screens', 'target/datatypes/pictureclass'
{
#include <proto/icon.h>
}
{
struct Library* IconBase = NULL;
}
NATIVE {CLIB_ICON_PROTOS_H} CONST
NATIVE {PROTO_ICON_H} CONST

NATIVE {IconBase} DEF iconbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {FreeFreeList} PROC
PROC FreeFreeList(freelist:PTR TO freelist) IS NATIVE {FreeFreeList(} freelist {)} ENDNATIVE
NATIVE {AddFreeList} PROC
PROC AddFreeList(freelist:PTR TO freelist, mem:APTR, size:ULONG) IS NATIVE {-(BOOLEAN)(0!=AddFreeList(} freelist {,} mem {,} size {))} ENDNATIVE !!BOOL
NATIVE {GetDiskObject} PROC
PROC GetDiskObject(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {GetDiskObject(} name {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutDiskObject} PROC
PROC PutDiskObject(name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject) IS NATIVE {-(BOOLEAN)(0!=PutDiskObject(} name {,} icon {))} ENDNATIVE !!BOOL
NATIVE {FreeDiskObject} PROC
PROC FreeDiskObject(diskobj:PTR TO diskobject) IS NATIVE {FreeDiskObject(} diskobj {)} ENDNATIVE
NATIVE {FindToolType} PROC
PROC FindToolType(toolTypeArray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR, typeName:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {FindToolType(} toolTypeArray {,} typeName {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {MatchToolValue} PROC
PROC MatchToolValue(typeString:ARRAY OF UBYTE, value:PTR TO UBYTE) IS NATIVE {-(BOOLEAN)(0!=MatchToolValue(} typeString {,} value {))} ENDNATIVE !!BOOL
NATIVE {BumpRevision} PROC
PROC BumpRevision(newname:ARRAY OF UBYTE, oldname:ARRAY OF UBYTE) IS NATIVE {BumpRevision(} newname {,} oldname {)} ENDNATIVE !!ARRAY OF UBYTE
NATIVE {GetDefDiskObject} PROC
PROC GetDefDiskObject(type:VALUE) IS NATIVE {GetDefDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutDefDiskObject} PROC
PROC PutDefDiskObject(icon:PTR TO diskobject) IS NATIVE {-(BOOLEAN)(0!=PutDefDiskObject(} icon {))} ENDNATIVE !!BOOL
NATIVE {GetDiskObjectNew} PROC
PROC GetDiskObjectNew(name:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {GetDiskObjectNew(} name {)} ENDNATIVE !!PTR TO diskobject
NATIVE {DeleteDiskObject} PROC
PROC DeleteDiskObject(name:ARRAY OF UBYTE) IS NATIVE {-(BOOLEAN)(0!=DeleteDiskObject(} name {))} ENDNATIVE !!BOOL
NATIVE {DupDiskObjectA} PROC
PROC DupDiskObjectA(icon:PTR TO diskobject, tags:ARRAY OF tagitem) IS NATIVE {DupDiskObjectA(} icon {,} tags {)} ENDNATIVE !!PTR TO diskobject
NATIVE {IconControlA} PROC
PROC IconControlA(icon:PTR TO diskobject, tags:ARRAY OF tagitem) IS NATIVE {IconControlA(} icon {,} tags {)} ENDNATIVE !!ULONG
NATIVE {DrawIconStateA} PROC
PROC DrawIconStateA(rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, leftEdge:VALUE, topEdge:VALUE, state:ULONG, tags:ARRAY OF tagitem) IS NATIVE {DrawIconStateA(} rp {,} icon {,} label {,} leftEdge {,} topEdge {,} state {,} tags {)} ENDNATIVE
NATIVE {GetIconRectangleA} PROC
PROC GetIconRectangleA(rp:PTR TO rastport, icon:PTR TO diskobject, label:/*STRPTR*/ ARRAY OF CHAR, rectangle:PTR TO rectangle, tags:ARRAY OF tagitem) IS NATIVE {-(BOOLEAN)(0!=GetIconRectangleA(} rp {,} icon {,} label {,} rectangle {,} tags {))} ENDNATIVE !!BOOL
NATIVE {NewDiskObject} PROC
PROC NewDiskObject(type:ULONG) IS NATIVE {NewDiskObject(} type {)} ENDNATIVE !!PTR TO diskobject
NATIVE {GetIconTagList} PROC
PROC GetIconTagList(name:/*STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {GetIconTagList(} name {,} tags {)} ENDNATIVE !!PTR TO diskobject
NATIVE {PutIconTagList} PROC
PROC PutIconTagList(name:/*STRPTR*/ ARRAY OF CHAR, icon:PTR TO diskobject, tags:ARRAY OF tagitem) IS NATIVE {-(BOOLEAN)(0!=PutIconTagList(} name {,} icon {,} tags {))} ENDNATIVE !!BOOL
NATIVE {LayoutIconA} PROC
PROC LayoutIconA(icon:PTR TO diskobject, screen:PTR TO screen, tags:ARRAY OF tagitem) IS NATIVE {-(BOOLEAN)(0!=LayoutIconA(} icon {,} screen {,} tags {))} ENDNATIVE !!BOOL
NATIVE {ChangeToSelectedIconColor} PROC
PROC ChangeToSelectedIconColor(cr:PTR TO colorregister) IS NATIVE {ChangeToSelectedIconColor(} cr {)} ENDNATIVE
