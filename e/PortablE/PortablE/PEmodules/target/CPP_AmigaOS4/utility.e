/* $Id: utility_protos.h,v 1.10 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'target/utility/data_structures', 'target/utility/date', 'target/utility/hooks', 'target/utility/message_digest', 'target/utility/name', 'target/utility/pack', 'target/utility/random', 'target/utility/tagitem', 'target/utility/utility'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/ports', 'target/exec/types', 'target/exec/lists', 'target/exec/nodes', 'target/utility/tagitem', 'target/utility/date', 'target/utility/hooks', 'target/utility/name', 'target/utility/data_structures', 'target/utility/random', 'target/utility/message_digest'
{
#include <proto/utility.h>
}
{
#ifndef __NEWLIB_H__
struct Library* UtilityBase = NULL;
struct UtilityIFace* IUtility = NULL;
#endif
}
NATIVE {CLIB_UTILITY_PROTOS_H} CONST
NATIVE {PROTO_UTILITY_H} CONST
NATIVE {PRAGMA_UTILITY_H} CONST
NATIVE {INLINE4_UTILITY_H} CONST
NATIVE {UTILITY_INTERFACE_DEF_H} CONST

NATIVE {UtilityBase} DEF utilitybase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IUtility}    DEF

PROC new()
	InitLibrary('utility.library', NATIVE {(struct Interface **) &IUtility} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->extra procedures from inline4
NATIVE {CallHook} PROC
NATIVE {ClearMem} PROC
NATIVE {MoveMem} PROC

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Tag item functions */

->NATIVE {FindTagItem} PROC
PROC FindTagItem( tagVal:TAG, tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->FindTagItem(} tagVal {,} tagList {)} ENDNATIVE !!PTR TO tagitem
->NATIVE {GetTagData} PROC
PROC GetTagData( tagValue:TAG, defaultVal:ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->GetTagData(} tagValue {,} defaultVal {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {PackBoolTags} PROC
PROC PackBoolTags( initialFlags:ULONG, tagList:ARRAY OF tagitem, boolMap:ARRAY OF tagitem ) IS NATIVE {IUtility->PackBoolTags(} initialFlags {,} tagList {,} boolMap {)} ENDNATIVE !!ULONG
->NATIVE {NextTagItem} PROC
PROC NextTagItem( tagListPtr:ARRAY OF ARRAY OF tagitem) IS NATIVE {IUtility->NextTagItem(} tagListPtr {)} ENDNATIVE !!PTR TO tagitem
->NATIVE {FilterTagChanges} PROC
PROC FilterTagChanges( changeList:ARRAY OF tagitem, originalList:ARRAY OF tagitem, apply:ULONG ) IS NATIVE {IUtility->FilterTagChanges(} changeList {,} originalList {,} apply {)} ENDNATIVE
->NATIVE {MapTags} PROC
PROC MapTags( tagList:ARRAY OF tagitem, mapList:ARRAY OF tagitem, mapType:ULONG ) IS NATIVE {IUtility->MapTags(} tagList {,} mapList {,} mapType {)} ENDNATIVE
->NATIVE {AllocateTagItems} PROC
PROC AllocateTagItems( numTags:ULONG ) IS NATIVE {IUtility->AllocateTagItems(} numTags {)} ENDNATIVE !!ARRAY OF tagitem
->NATIVE {CloneTagItems} PROC
PROC CloneTagItems( tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->CloneTagItems(} tagList {)} ENDNATIVE !!ARRAY OF tagitem
->NATIVE {FreeTagItems} PROC
PROC FreeTagItems( tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->FreeTagItems(} tagList {)} ENDNATIVE
->NATIVE {RefreshTagItemClones} PROC
PROC RefreshTagItemClones( clone:ARRAY OF tagitem, original:ARRAY OF tagitem ) IS NATIVE {IUtility->RefreshTagItemClones(} clone {,} original {)} ENDNATIVE
->NATIVE {TagInArray} PROC
PROC TagInArray( tagValue:TAG, tagArray:PTR TO TAG ) IS NATIVE {-IUtility->TagInArray(} tagValue {,} tagArray {)} ENDNATIVE !!INT
->NATIVE {FilterTagItems} PROC
PROC FilterTagItems( tagList:ARRAY OF tagitem, filterArray:PTR TO TAG, logic:ULONG ) IS NATIVE {IUtility->FilterTagItems(} tagList {,} filterArray {,} logic {)} ENDNATIVE !!ULONG

/* Hook functions */

->NATIVE {CallHookPkt} PROC
PROC CallHookPkt( hook:PTR TO hook, object:APTR, paramPacket:APTR ) IS NATIVE {IUtility->CallHookPkt(} hook {,} object {,} paramPacket {)} ENDNATIVE !!ULONG

/* Date functions */

->NATIVE {Amiga2Date} PROC
PROC Amiga2Date( seconds:ULONG, result:PTR TO clockdata ) IS NATIVE {IUtility->Amiga2Date(} seconds {,} result {)} ENDNATIVE
->NATIVE {Date2Amiga} PROC
PROC Date2Amiga( date:PTR TO clockdata ) IS NATIVE {IUtility->Date2Amiga(} date {)} ENDNATIVE !!ULONG
->NATIVE {CheckDate} PROC
PROC CheckDate( date:PTR TO clockdata ) IS NATIVE {IUtility->CheckDate(} date {)} ENDNATIVE !!ULONG

/* 32 bit integer muliply functions */

->NATIVE {SMult32} PROC
->Not supported for some reason: PROC Smult32( arg1:VALUE, arg2:VALUE ) IS NATIVE {IUtility->SMult32(} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
PROC Smult32( arg1:VALUE, arg2:VALUE ) RETURNS result:VALUE IS arg1 * arg2
->NATIVE {UMult32} PROC
->Not supported for some reason: PROC Umult32( arg1:ULONG, arg2:ULONG ) IS NATIVE {IUtility->UMult32(} arg1 {,} arg2 {)} ENDNATIVE !!ULONG
PROC Umult32( arg1:ULONG, arg2:ULONG ) RETURNS result:ULONG IS arg1 * arg2

/* 32 bit integer division funtions. The quotient and the remainder are */
/* returned respectively in d0 and d1 */

->NATIVE {SDivMod32} PROC
->Not supported for some reason: PROC SdivMod32( dividend:VALUE, divisor:VALUE ) IS NATIVE {IUtility->SDivMod32(} dividend {,} divisor {)} ENDNATIVE !!VALUE
->NATIVE {UDivMod32} PROC
->Not supported for some reason: PROC UdivMod32( dividend:ULONG, divisor:ULONG ) IS NATIVE {IUtility->UDivMod32(} dividend {,} divisor {)} ENDNATIVE !!ULONG
/*--- functions in V37 or higher (Release 2.04) ---*/

/* International string routines */

->NATIVE {Stricmp} PROC
PROC Stricmp( string1:ARRAY OF CHAR /*STRPTR*/, string2:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {IUtility->Stricmp(} string1 {,} string2 {)} ENDNATIVE !!VALUE
->NATIVE {Strnicmp} PROC
PROC Strnicmp( string1:ARRAY OF CHAR /*STRPTR*/, string2:ARRAY OF CHAR /*STRPTR*/, length:VALUE ) IS NATIVE {IUtility->Strnicmp(} string1 {,} string2 {,} length {)} ENDNATIVE !!VALUE
->NATIVE {ToUpper} PROC
PROC ToUpper( character:ULONG ) IS NATIVE {IUtility->ToUpper(} character {)} ENDNATIVE !!CHAR /*TEXT*/
->NATIVE {ToLower} PROC
PROC ToLower( character:ULONG ) IS NATIVE {IUtility->ToLower(} character {)} ENDNATIVE !!CHAR /*TEXT*/
/*--- functions in V39 or higher (Release 3) ---*/

/* More tag Item functions */

->NATIVE {ApplyTagChanges} PROC
PROC ApplyTagChanges( list:ARRAY OF tagitem, changeList:ARRAY OF tagitem ) IS NATIVE {IUtility->ApplyTagChanges(} list {,} changeList {)} ENDNATIVE

/* 64 bit integer muliply functions. The results are 64 bit quantities */
/* returned in D0 and D1 */

->NATIVE {SMult64} PROC
->PROC Smult64( arg1:VALUE, arg2:VALUE ) IS NATIVE {IUtility->SMult64(} arg1 {,} arg2 {)} ENDNATIVE !!VALUE
->NATIVE {UMult64} PROC
->PROC Umult64( arg1:ULONG, arg2:ULONG ) IS NATIVE {IUtility->UMult64(} arg1 {,} arg2 {)} ENDNATIVE !!ULONG

/* Structure to Tag and Tag to Structure support routines */

->NATIVE {PackStructureTags} PROC
PROC PackStructureTags( pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->PackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG
->NATIVE {UnpackStructureTags} PROC
PROC UnpackStructureTags( pack:APTR, packTable:PTR TO ULONG, tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->UnpackStructureTags(} pack {,} packTable {,} tagList {)} ENDNATIVE !!ULONG

/* Object-oriented NameSpaces */

->NATIVE {AddNamedObject} PROC
PROC AddNamedObject( nameSpace:PTR TO namedobject, object:PTR TO namedobject ) IS NATIVE {-IUtility->AddNamedObject(} nameSpace {,} object {)} ENDNATIVE !!INT
->NATIVE {AllocNamedObjectA} PROC
PROC AllocNamedObjectA( name:ARRAY OF CHAR /*STRPTR*/, tagList:ARRAY OF tagitem ) IS NATIVE {IUtility->AllocNamedObjectA(} name {,} tagList {)} ENDNATIVE !!PTR TO namedobject
->NATIVE {AllocNamedObject} PROC
PROC AllocNamedObject( name:ARRAY OF CHAR /*STRPTR*/, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IUtility->AllocNamedObject(} name {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO namedobject
->NATIVE {AttemptRemNamedObject} PROC
PROC AttemptRemNamedObject( object:PTR TO namedobject ) IS NATIVE {IUtility->AttemptRemNamedObject(} object {)} ENDNATIVE !!VALUE
->NATIVE {FindNamedObject} PROC
PROC FindNamedObject( nameSpace:PTR TO namedobject, name:ARRAY OF CHAR /*STRPTR*/, lastObject:PTR TO namedobject ) IS NATIVE {IUtility->FindNamedObject(} nameSpace {,} name {,} lastObject {)} ENDNATIVE !!PTR TO namedobject
->NATIVE {FreeNamedObject} PROC
PROC FreeNamedObject( object:PTR TO namedobject ) IS NATIVE {IUtility->FreeNamedObject(} object {)} ENDNATIVE
->NATIVE {NamedObjectName} PROC
PROC NamedObjectName( object:PTR TO namedobject ) IS NATIVE {IUtility->NamedObjectName(} object {)} ENDNATIVE !!ARRAY OF CHAR /*STRPTR*/
->NATIVE {ReleaseNamedObject} PROC
PROC ReleaseNamedObject( object:PTR TO namedobject ) IS NATIVE {IUtility->ReleaseNamedObject(} object {)} ENDNATIVE
->NATIVE {RemNamedObject} PROC
PROC RemNamedObject( object:PTR TO namedobject, message:PTR TO mn ) IS NATIVE {IUtility->RemNamedObject(} object {,} message {)} ENDNATIVE

/* Unique ID generator */

->NATIVE {GetUniqueID} PROC
PROC GetUniqueID( ) IS NATIVE {IUtility->GetUniqueID()} ENDNATIVE !!ULONG


/*--- functions in V50 or higher (Beta release for developers only) ---*/

/* String manipulation and formatting */

->NATIVE {Strlcpy} PROC
PROC Strlcpy( destination:ARRAY OF CHAR /*STRPTR*/, source:ARRAY OF CHAR /*STRPTR*/, size:VALUE ) IS NATIVE {IUtility->Strlcpy(} destination {,} source {,} size {)} ENDNATIVE !!VALUE
->NATIVE {Strlcat} PROC
PROC Strlcat( destination:ARRAY OF CHAR /*STRPTR*/, source:ARRAY OF CHAR /*STRPTR*/, size:VALUE ) IS NATIVE {IUtility->Strlcat(} destination {,} source {,} size {)} ENDNATIVE !!VALUE
->NATIVE {VSNPrintf} PROC
PROC VsNPrintf( buffer:ARRAY OF CHAR /*STRPTR*/, buffer_size:VALUE, format:ARRAY OF CHAR /*STRPTR*/, args:APTR ) IS NATIVE {IUtility->VSNPrintf(} buffer {,} buffer_size {,} format {,} args {)} ENDNATIVE !!VALUE
->NATIVE {SNPrintf} PROC
PROC SnPrintf( buffer:ARRAY OF CHAR /*STRPTR*/, buffer_size:VALUE, format:ARRAY OF CHAR /*STRPTR*/, format2=0:ULONG, ... ) IS NATIVE {IUtility->SNPrintf(} buffer {,} buffer_size {,} format {,} format2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {VASPrintf} PROC
PROC VaSPrintf( format:ARRAY OF CHAR /*STRPTR*/, args:APTR ) IS NATIVE {IUtility->VASPrintf(} format {,} args {)} ENDNATIVE !!ARRAY OF CHAR /*STRPTR*/
->NATIVE {ASPrintf} PROC
PROC AsPrintf( format:ARRAY OF CHAR /*STRPTR*/, format2=0:ULONG, ... ) IS NATIVE {IUtility->ASPrintf(} format {,} format2 {,} ... {)} ENDNATIVE !!ARRAY OF CHAR /*STRPTR*/

/* Skip lists */

->NATIVE {CreateSkipList} PROC
PROC CreateSkipList( hook:PTR TO hook, max_levels:VALUE ) IS NATIVE {IUtility->CreateSkipList(} hook {,} max_levels {)} ENDNATIVE !!PTR TO skiplist
->NATIVE {DeleteSkipList} PROC
PROC DeleteSkipList( list:PTR TO skiplist ) IS NATIVE {IUtility->DeleteSkipList(} list {)} ENDNATIVE
->NATIVE {InsertSkipNode} PROC
PROC InsertSkipNode( list:PTR TO skiplist, key:APTR, data_size:ULONG ) IS NATIVE {IUtility->InsertSkipNode(} list {,} key {,} data_size {)} ENDNATIVE !!PTR TO skipnode
->NATIVE {FindSkipNode} PROC
PROC FindSkipNode( list:PTR TO skiplist, key:APTR ) IS NATIVE {IUtility->FindSkipNode(} list {,} key {)} ENDNATIVE !!PTR TO skipnode
->NATIVE {RemoveSkipNode} PROC
PROC RemoveSkipNode( list:PTR TO skiplist, key:APTR ) IS NATIVE {IUtility->RemoveSkipNode(} list {,} key {)} ENDNATIVE !!VALUE
->NATIVE {GetFirstSkipNode} PROC
PROC GetFirstSkipNode( list:PTR TO skiplist ) IS NATIVE {IUtility->GetFirstSkipNode(} list {)} ENDNATIVE !!PTR TO skipnode
->NATIVE {GetNextSkipNode} PROC
PROC GetNextSkipNode( list:PTR TO skiplist, node:PTR TO skipnode ) IS NATIVE {IUtility->GetNextSkipNode(} list {,} node {)} ENDNATIVE !!PTR TO skipnode

/* Splay trees */

->NATIVE {CreateSplayTree} PROC
PROC CreateSplayTree( hook:PTR TO hook ) IS NATIVE {IUtility->CreateSplayTree(} hook {)} ENDNATIVE !!PTR TO splaytree
->NATIVE {DeleteSplayTree} PROC
PROC DeleteSplayTree( st:PTR TO splaytree ) IS NATIVE {IUtility->DeleteSplayTree(} st {)} ENDNATIVE
->NATIVE {InsertSplayNode} PROC
PROC InsertSplayNode( tree:PTR TO splaytree, key:APTR, data_size:ULONG ) IS NATIVE {IUtility->InsertSplayNode(} tree {,} key {,} data_size {)} ENDNATIVE !!PTR TO splaynode
->NATIVE {FindSplayNode} PROC
PROC FindSplayNode( tree:PTR TO splaytree, key:APTR ) IS NATIVE {IUtility->FindSplayNode(} tree {,} key {)} ENDNATIVE !!PTR TO splaynode
->NATIVE {RemoveSplayNode} PROC
PROC RemoveSplayNode( tree:PTR TO splaytree, key:APTR ) IS NATIVE {IUtility->RemoveSplayNode(} tree {,} key {)} ENDNATIVE !!PTR TO splaynode ->Incorrect: !!VALUE

/* Fill memory with a constant byte */

->NATIVE {SetMem} PROC
PROC SetMem( destination:APTR, c:ULONG, length:VALUE ) IS NATIVE {IUtility->SetMem(} destination {,} c {,} length {)} ENDNATIVE !!APTR

/* Find a list node by name (case-insensitive) */

->NATIVE {FindNameNC} PROC
PROC FindNameNC( list:PTR TO lh, name:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {IUtility->FindNameNC(} list {,} name {)} ENDNATIVE !!PTR TO ln

/* Pseudo-random number generation */

->NATIVE {Random} PROC
PROC Random( state:PTR TO randomstate ) IS NATIVE {IUtility->Random(} state {)} ENDNATIVE !!VALUE

/* Message digest calculation */

->NATIVE {MessageDigest_SHA_Init} PROC
PROC MessageDigest_SHA_Init( mdsha:PTR TO messagedigest_sha ) IS NATIVE {IUtility->MessageDigest_SHA_Init(} mdsha {)} ENDNATIVE
->NATIVE {MessageDigest_SHA_Update} PROC
PROC MessageDigest_SHA_Update( mdsha:PTR TO messagedigest_sha, data:APTR, num_bytes:VALUE ) IS NATIVE {IUtility->MessageDigest_SHA_Update(} mdsha {,} data {,} num_bytes {)} ENDNATIVE
->NATIVE {MessageDigest_SHA_Final} PROC
PROC MessageDigest_SHA_Final( mdsha:PTR TO messagedigest_sha ) IS NATIVE {IUtility->MessageDigest_SHA_Final(} mdsha {)} ENDNATIVE
