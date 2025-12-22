OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/utility/date', 'target/utility/hooks', 'target/utility/name', 'target/utility/pack', 'target/utility/tagitem', 'target/utility/utility'
MODULE 'target/aros/libcall', 'target/exec/types', 'target/exec/ports', 'target/utility/tagitem', 'target/utility/date', 'target/utility/hooks', 'target/utility/name'
MODULE 'target/exec/types', 'target/aros/system', 'target/defines/utility', 'target/exec/libraries'
{
#include <proto/utility.h>
}
{
struct UtilityBase* UtilityBase = NULL;
}
NATIVE {CLIB_UTILITY_PROTOS_H} CONST
NATIVE {PROTO_UTILITY_H} CONST

NATIVE {UtilityBase} DEF utilitybase:NATIVE {struct UtilityBase*} PTR TO lib		->AmigaE does not automatically initialise this

/* Prototypes for stubs in amiga.lib */
->#ifndef AllocNamedObject
->NATIVE {AllocNamedObject} PROC
->PROC AllocNamedObject(name:/*STRPTR*/ ARRAY OF CHAR, tag1:/*STACKULONG*/ ULONG, tag12=0:ULONG, ...) IS NATIVE {AllocNamedObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO namedobject
->#endif

NATIVE {FindTagItem} PROC
PROC FindTagItem(tagValue:TAG, tagList:ARRAY OF tagitem) IS NATIVE {FindTagItem(} tagValue {,} tagList {)} ENDNATIVE !!PTR TO tagitem
NATIVE {GetTagData} PROC
PROC GetTagData(tagValue:TAG, defaultVal:IPTR, tagList:ARRAY OF tagitem) IS NATIVE {GetTagData(} tagValue {,} defaultVal {,} tagList {)} ENDNATIVE !!IPTR
NATIVE {PackBoolTags} PROC
PROC PackBoolTags(initialFlags:ULONG, tagList:ARRAY OF tagitem, boolMap:ARRAY OF tagitem) IS NATIVE {PackBoolTags(} initialFlags {,} tagList {,} boolMap {)} ENDNATIVE !!ULONG
NATIVE {NextTagItem} PROC
PROC NextTagItem(tagListPtr:ARRAY OF ARRAY OF tagitem) IS NATIVE {NextTagItem( (struct TagItem**) } tagListPtr {)} ENDNATIVE !!PTR TO tagitem
NATIVE {FilterTagChanges} PROC
PROC FilterTagChanges(changeList:ARRAY OF tagitem, originalList:ARRAY OF tagitem, apply:INT) IS NATIVE {FilterTagChanges(} changeList {,} originalList {, -} apply {)} ENDNATIVE
NATIVE {MapTags} PROC
PROC MapTags(tagList:ARRAY OF tagitem, mapList:ARRAY OF tagitem, mapType:ULONG) IS NATIVE {MapTags(} tagList {,} mapList {,} mapType {)} ENDNATIVE
NATIVE {AllocateTagItems} PROC
PROC AllocateTagItems(numTags:ULONG) IS NATIVE {AllocateTagItems(} numTags {)} ENDNATIVE !!ARRAY OF tagitem
NATIVE {CloneTagItems} PROC
PROC CloneTagItems(tagList:ARRAY OF tagitem) IS NATIVE {CloneTagItems(} tagList {)} ENDNATIVE !!ARRAY OF tagitem
NATIVE {FreeTagItems} PROC
PROC FreeTagItems(tagList:ARRAY OF tagitem) IS NATIVE {FreeTagItems(} tagList {)} ENDNATIVE
NATIVE {RefreshTagItemClones} PROC
PROC RefreshTagItemClones(clone:ARRAY OF tagitem, original:ARRAY OF tagitem) IS NATIVE {RefreshTagItemClones(} clone {,} original {)} ENDNATIVE
NATIVE {TagInArray} PROC
PROC TagInArray(tagValue:TAG, tagArray:PTR TO TAG) IS NATIVE {-TagInArray(} tagValue {,} tagArray {)} ENDNATIVE !!INT
NATIVE {FilterTagItems} PROC
PROC FilterTagItems(tagList:ARRAY OF tagitem, filterArray:PTR TO TAG, logic:ULONG) IS NATIVE {FilterTagItems(} tagList {,} filterArray {,} logic {)} ENDNATIVE !!ULONG
NATIVE {CallHookPkt} PROC
PROC CallHookPkt(hook:PTR TO hook, object:APTR, paramPacket:APTR) IS NATIVE {CallHookPkt(} hook {,} object {,} paramPacket {)} ENDNATIVE !!IPTR
NATIVE {Amiga2Date} PROC
PROC Amiga2Date(seconds:ULONG, result:PTR TO clockdata) IS NATIVE {Amiga2Date(} seconds {,} result {)} ENDNATIVE
NATIVE {Date2Amiga} PROC
PROC Date2Amiga(date:PTR TO clockdata) IS NATIVE {Date2Amiga(} date {)} ENDNATIVE !!ULONG
NATIVE {CheckDate} PROC
PROC CheckDate(date:PTR TO clockdata) IS NATIVE {CheckDate(} date {)} ENDNATIVE !!ULONG
NATIVE {SMult32} PROC
PROC Smult32(arg1:VALUE, arg2:VALUE) IS NATIVE {SMult32(} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
NATIVE {UMult32} PROC
PROC Umult32(arg1:ULONG, arg2:ULONG) IS NATIVE {UMult32(} arg1 {,} arg2 {)} ENDNATIVE !!ULONG
NATIVE {SDivMod32} PROC
->PROC SdivMod32(dividend:VALUE, divisor:VALUE) IS NATIVE {SDivMod32(} dividend {,} divisor {)} ENDNATIVE !!BIGVALUE
NATIVE {UDivMod32} PROC
->PROC UdivMod32(dividend:ULONG, divisor:ULONG) IS NATIVE {UDivMod32(} dividend {,} divisor {)} ENDNATIVE !!ULONG
NATIVE {Stricmp} PROC
PROC Stricmp(string1:/*STRPTR*/ ARRAY OF CHAR, string2:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {Stricmp(} string1 {,} string2 {)} ENDNATIVE !!VALUE
NATIVE {Strnicmp} PROC
PROC Strnicmp(string1:/*STRPTR*/ ARRAY OF CHAR, string2:/*STRPTR*/ ARRAY OF CHAR, length:VALUE) IS NATIVE {Strnicmp(} string1 {,} string2 {,} length {)} ENDNATIVE !!VALUE
NATIVE {ToUpper} PROC
PROC ToUpper(character:ULONG) IS NATIVE {ToUpper(} character {)} ENDNATIVE !!UBYTE
NATIVE {ToLower} PROC
PROC ToLower(character:ULONG) IS NATIVE {ToLower(} character {)} ENDNATIVE !!UBYTE
NATIVE {ApplyTagChanges} PROC
PROC ApplyTagChanges(list:ARRAY OF tagitem, changelist:ARRAY OF tagitem) IS NATIVE {ApplyTagChanges(} list {,} changelist {)} ENDNATIVE
NATIVE {SMult64} PROC
->PROC Smult64(arg1:VALUE, arg2:VALUE) IS NATIVE {SMult64(} arg1 {,} arg2 {)} ENDNATIVE !!BIGVALUE
NATIVE {UMult64} PROC
->PROC Umult64(arg1:ULONG, arg2:ULONG) IS NATIVE {UMult64(} arg1 {,} arg2 {)} ENDNATIVE !!UBIGVALUE
NATIVE {PackStructureTags} PROC
PROC PackStructureTags(pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem) IS NATIVE {PackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {UnpackStructureTags} PROC
PROC UnpackStructureTags(pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem) IS NATIVE {UnpackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {AddNamedObject} PROC
PROC AddNamedObject(nameSpace:PTR TO namedobject, object:PTR TO namedobject) IS NATIVE {-AddNamedObject(} nameSpace {,} object {)} ENDNATIVE !!INT
NATIVE {AllocNamedObjectA} PROC
PROC AllocNamedObjectA(name:/*STRPTR*/ ARRAY OF CHAR, tagList:ARRAY OF tagitem) IS NATIVE {AllocNamedObjectA(} name {,} tagList {)} ENDNATIVE !!PTR TO namedobject
NATIVE {AttemptRemNamedObject} PROC
PROC AttemptRemNamedObject(object:PTR TO namedobject) IS NATIVE {AttemptRemNamedObject(} object {)} ENDNATIVE !!VALUE
NATIVE {FindNamedObject} PROC
PROC FindNamedObject(nameSpace:PTR TO namedobject, name:/*STRPTR*/ ARRAY OF CHAR, lastObject:PTR TO namedobject) IS NATIVE {FindNamedObject(} nameSpace {,} name {,} lastObject {)} ENDNATIVE !!PTR TO namedobject
NATIVE {FreeNamedObject} PROC
PROC FreeNamedObject(object:PTR TO namedobject) IS NATIVE {FreeNamedObject(} object {)} ENDNATIVE
NATIVE {NamedObjectName} PROC
PROC NamedObjectName(object:PTR TO namedobject) IS NATIVE {NamedObjectName(} object {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {ReleaseNamedObject} PROC
PROC ReleaseNamedObject(object:PTR TO namedobject) IS NATIVE {ReleaseNamedObject(} object {)} ENDNATIVE
NATIVE {RemNamedObject} PROC
PROC RemNamedObject(object:PTR TO namedobject, message:PTR TO mn) IS NATIVE {RemNamedObject(} object {,} message {)} ENDNATIVE
NATIVE {GetUniqueID} PROC
PROC GetUniqueID() IS NATIVE {GetUniqueID()} ENDNATIVE !!ULONG
