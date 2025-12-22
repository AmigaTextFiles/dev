/* AmigaE module, $VER: utility_protos.h 40.1 (17.5.1996) */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/utility/date', 'target/utility/hooks', 'target/utility/name', 'target/utility/pack', 'target/utility/tagitem', 'target/utility/utility'
MODULE 'target/exec/types', 'target/exec/ports', 'target/utility/tagitem', 'target/utility/date', 'target/utility/hooks', 'target/utility/name'
MODULE 'target/exec/libraries', 'target/exec'
{MODULE 'utility'}

NATIVE {utilitybase} DEF utilitybase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this		->this declaration shouldn't be allowed, because it's name clashes with an object's.  Have to use OPT FORCENATIVE to allow it.

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Tag item functions */

NATIVE {FindTagItem} PROC
PROC FindTagItem( tagVal:TAG, tagList:ARRAY OF tagitem ) IS NATIVE {FindTagItem(} tagVal {,} tagList {)} ENDNATIVE !!PTR TO tagitem
NATIVE {GetTagData} PROC
PROC GetTagData( tagValue:TAG, defaultVal:ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {GetTagData(} tagValue {,} defaultVal {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {PackBoolTags} PROC
PROC PackBoolTags( initialFlags:ULONG, tagList:ARRAY OF tagitem, boolMap:ARRAY OF tagitem ) IS NATIVE {PackBoolTags(} initialFlags {,} tagList {,} boolMap {)} ENDNATIVE !!ULONG
NATIVE {NextTagItem} PROC
PROC NextTagItem( tagListPtr:ARRAY OF ARRAY OF tagitem) IS NATIVE {NextTagItem(} tagListPtr {)} ENDNATIVE !!PTR TO tagitem
NATIVE {FilterTagChanges} PROC
PROC FilterTagChanges( changeList:ARRAY OF tagitem, originalList:ARRAY OF tagitem, apply:ULONG ) IS NATIVE {FilterTagChanges(} changeList {,} originalList {,} apply {)} ENDNATIVE
NATIVE {MapTags} PROC
PROC MapTags( tagList:ARRAY OF tagitem, mapList:ARRAY OF tagitem, mapType:ULONG ) IS NATIVE {MapTags(} tagList {,} mapList {,} mapType {)} ENDNATIVE
NATIVE {AllocateTagItems} PROC
PROC AllocateTagItems( numTags:ULONG ) IS NATIVE {AllocateTagItems(} numTags {)} ENDNATIVE !!ARRAY OF tagitem
NATIVE {CloneTagItems} PROC
PROC CloneTagItems( tagList:ARRAY OF tagitem ) IS NATIVE {CloneTagItems(} tagList {)} ENDNATIVE !!ARRAY OF tagitem
NATIVE {FreeTagItems} PROC
PROC FreeTagItems( tagList:ARRAY OF tagitem ) IS NATIVE {FreeTagItems(} tagList {)} ENDNATIVE
NATIVE {RefreshTagItemClones} PROC
PROC RefreshTagItemClones( clone:ARRAY OF tagitem, original:ARRAY OF tagitem ) IS NATIVE {RefreshTagItemClones(} clone {,} original {)} ENDNATIVE
NATIVE {TagInArray} PROC
PROC TagInArray( tagValue:TAG, tagArray:ARRAY OF TAG ) IS NATIVE {TagInArray(} tagValue {,} tagArray {)} ENDNATIVE !!INT
NATIVE {FilterTagItems} PROC
PROC FilterTagItems( tagList:ARRAY OF tagitem, filterArray:ARRAY OF TAG, logic:ULONG ) IS NATIVE {FilterTagItems(} tagList {,} filterArray {,} logic {)} ENDNATIVE !!ULONG

/* Hook functions */

NATIVE {CallHookPkt} PROC
PROC CallHookPkt( hook:PTR TO hook, object:APTR, paramPacket:APTR ) IS NATIVE {CallHookPkt(} hook {,} object {,} paramPacket {)} ENDNATIVE !!ULONG

/* Date functions */

NATIVE {Amiga2Date} PROC
PROC Amiga2Date( seconds:ULONG, result:PTR TO clockdata ) IS NATIVE {Amiga2Date(} seconds {,} result {)} ENDNATIVE
NATIVE {Date2Amiga} PROC
PROC Date2Amiga( date:PTR TO clockdata ) IS NATIVE {Date2Amiga(} date {)} ENDNATIVE !!ULONG
NATIVE {CheckDate} PROC
PROC CheckDate( date:PTR TO clockdata ) IS NATIVE {CheckDate(} date {)} ENDNATIVE !!ULONG

/* 32 bit integer muliply functions */

NATIVE {Smult32} PROC
PROC Smult32( arg1:VALUE, arg2:VALUE ) IS NATIVE {Smult32(} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
NATIVE {Umult32} PROC
PROC Umult32( arg1:ULONG, arg2:ULONG ) IS NATIVE {Umult32(} arg1 {,} arg2 {)} ENDNATIVE !!ULONG

/* 32 bit integer division funtions. The quotient and the remainder are */
/* returned respectively in d0 and d1 */

NATIVE {SdivMod32} PROC
->PROC SdivMod32( dividend:VALUE, divisor:VALUE ) IS NATIVE {SdivMod32(} dividend {,} divisor {)} ENDNATIVE !!VALUE
NATIVE {UdivMod32} PROC
->PROC UdivMod32( dividend:ULONG, divisor:ULONG ) IS NATIVE {UdivMod32(} dividend {,} divisor {)} ENDNATIVE !!ULONG
/*--- functions in V37 or higher (Release 2.04) ---*/

/* International string routines */

NATIVE {Stricmp} PROC
PROC Stricmp( string1:ARRAY OF CHAR, string2:ARRAY OF CHAR ) IS NATIVE {Stricmp(} string1 {,} string2 {)} ENDNATIVE !!VALUE
NATIVE {Strnicmp} PROC
PROC Strnicmp( string1:ARRAY OF CHAR, string2:ARRAY OF CHAR, length:VALUE ) IS NATIVE {Strnicmp(} string1 {,} string2 {,} length {)} ENDNATIVE !!VALUE
NATIVE {ToUpper} PROC
PROC ToUpper( character:ULONG ) IS NATIVE {ToUpper(} character {)} ENDNATIVE !!UBYTE
NATIVE {ToLower} PROC
PROC ToLower( character:ULONG ) IS NATIVE {ToLower(} character {)} ENDNATIVE !!UBYTE
/*--- functions in V39 or higher (Release 3) ---*/

/* More tag Item functions */

NATIVE {ApplyTagChanges} PROC
PROC ApplyTagChanges( list:ARRAY OF tagitem, changeList:ARRAY OF tagitem ) IS NATIVE {ApplyTagChanges(} list {,} changeList {)} ENDNATIVE

/* 64 bit integer muliply functions. The results are 64 bit quantities */
/* returned in D0 and D1 */

NATIVE {Smult64} PROC
->PROC Smult64( arg1:VALUE, arg2:VALUE ) IS NATIVE {Smult64(} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
NATIVE {Umult64} PROC
->PROC Umult64( arg1:ULONG, arg2:ULONG ) IS NATIVE {Umult64(} arg1 {,} arg2 {)} ENDNATIVE !!ULONG

/* Structure to Tag and Tag to Structure support routines */

NATIVE {PackStructureTags} PROC
PROC PackStructureTags( pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {PackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG
NATIVE {UnpackStructureTags} PROC
PROC UnpackStructureTags( pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {UnpackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG

/* New, object-oriented NameSpaces */

NATIVE {AddNamedObject} PROC
PROC AddNamedObject( nameSpace:PTR TO namedobject, object:PTR TO namedobject ) IS NATIVE {AddNamedObject(} nameSpace {,} object {)} ENDNATIVE !!INT
NATIVE {AllocNamedObjectA} PROC
PROC AllocNamedObjectA( name:ARRAY OF CHAR, tagList:ARRAY OF tagitem ) IS NATIVE {AllocNamedObjectA(} name {,} tagList {)} ENDNATIVE !!PTR TO namedobject
->NATIVE {AllocNamedObject} PROC
->PROC AllocNamedObject( name:ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {AllocNamedObject(} name {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO namedobject
NATIVE {AttemptRemNamedObject} PROC
PROC AttemptRemNamedObject( object:PTR TO namedobject ) IS NATIVE {AttemptRemNamedObject(} object {)} ENDNATIVE !!VALUE
NATIVE {FindNamedObject} PROC
PROC FindNamedObject( nameSpace:PTR TO namedobject, name:ARRAY OF CHAR, lastObject:PTR TO namedobject ) IS NATIVE {FindNamedObject(} nameSpace {,} name {,} lastObject {)} ENDNATIVE !!PTR TO namedobject
NATIVE {FreeNamedObject} PROC
PROC FreeNamedObject( object:PTR TO namedobject ) IS NATIVE {FreeNamedObject(} object {)} ENDNATIVE
NATIVE {NamedObjectName} PROC
PROC NamedObjectName( object:PTR TO namedobject ) IS NATIVE {NamedObjectName(} object {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {ReleaseNamedObject} PROC
PROC ReleaseNamedObject( object:PTR TO namedobject ) IS NATIVE {ReleaseNamedObject(} object {)} ENDNATIVE
NATIVE {RemNamedObject} PROC
PROC RemNamedObject( object:PTR TO namedobject, message:PTR TO mn ) IS NATIVE {RemNamedObject(} object {,} message {)} ENDNATIVE

/* Unique ID generator */

NATIVE {GetUniqueID} PROC
PROC GetUniqueID( ) IS NATIVE {GetUniqueID()} ENDNATIVE !!ULONG
