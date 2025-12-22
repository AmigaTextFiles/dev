OPT NATIVE
PUBLIC MODULE 'target/libraries/iffparse'
MODULE 'target/aros/libcall', 'target/utility/utility', 'target/utility/hooks' /*, 'target/libraries/iffparse'*/
MODULE 'target/exec/libraries', 'target/exec/types'
{
#include <proto/iffparse.h>
}
{
struct Library* IFFParseBase = NULL;
}
NATIVE {CLIB_IFFPARSE_PROTOS_H} CONST
NATIVE {PROTO_IFFPARSE_H} CONST

NATIVE {IFFParseBase} DEF iffparsebase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {AllocIFF} PROC
PROC AllocIFF() IS NATIVE {AllocIFF()} ENDNATIVE !!PTR TO iffhandle
NATIVE {OpenIFF} PROC
PROC OpenIFF(iff:PTR TO iffhandle, rwMode:VALUE) IS NATIVE {OpenIFF(} iff {,} rwMode {)} ENDNATIVE !!VALUE
NATIVE {ParseIFF} PROC
PROC ParseIFF(iff:PTR TO iffhandle, mode:VALUE) IS NATIVE {ParseIFF(} iff {,} mode {)} ENDNATIVE !!VALUE
NATIVE {CloseIFF} PROC
PROC CloseIFF(iff:PTR TO iffhandle) IS NATIVE {CloseIFF(} iff {)} ENDNATIVE
NATIVE {FreeIFF} PROC
PROC FreeIFF(iff:PTR TO iffhandle) IS NATIVE {FreeIFF(} iff {)} ENDNATIVE
NATIVE {ReadChunkBytes} PROC
PROC ReadChunkBytes(iff:PTR TO iffhandle, buf:APTR, numBytes:VALUE) IS NATIVE {ReadChunkBytes(} iff {,} buf {,} numBytes {)} ENDNATIVE !!VALUE
NATIVE {WriteChunkBytes} PROC
PROC WriteChunkBytes(iff:PTR TO iffhandle, buf:APTR, numBytes:VALUE) IS NATIVE {WriteChunkBytes(} iff {,} buf {,} numBytes {)} ENDNATIVE !!VALUE
NATIVE {ReadChunkRecords} PROC
PROC ReadChunkRecords(iff:PTR TO iffhandle, buf:APTR, bytesPerRecord:VALUE, numRecords:VALUE) IS NATIVE {ReadChunkRecords(} iff {,} buf {,} bytesPerRecord {,} numRecords {)} ENDNATIVE !!VALUE
NATIVE {WriteChunkRecords} PROC
PROC WriteChunkRecords(iff:PTR TO iffhandle, buf:APTR, bytesPerRecord:VALUE, numRecords:VALUE) IS NATIVE {WriteChunkRecords(} iff {,} buf {,} bytesPerRecord {,} numRecords {)} ENDNATIVE !!VALUE
NATIVE {PushChunk} PROC
PROC PushChunk(iff:PTR TO iffhandle, type:VALUE, id:VALUE, size:VALUE) IS NATIVE {PushChunk(} iff {,} type {,} id {,} size {)} ENDNATIVE !!VALUE
NATIVE {PopChunk} PROC
PROC PopChunk(iff:PTR TO iffhandle) IS NATIVE {PopChunk(} iff {)} ENDNATIVE !!VALUE
NATIVE {EntryHandler} PROC
PROC EntryHandler(iff:PTR TO iffhandle, type:VALUE, id:VALUE, position:VALUE, handler:PTR TO hook, object:APTR) IS NATIVE {EntryHandler(} iff {,} type {,} id {,} position {,} handler {,} object {)} ENDNATIVE !!VALUE
NATIVE {ExitHandler} PROC
PROC ExitHandler(iff:PTR TO iffhandle, type:VALUE, id:VALUE, position:VALUE, handler:PTR TO hook, object:APTR) IS NATIVE {ExitHandler(} iff {,} type {,} id {,} position {,} handler {,} object {)} ENDNATIVE !!VALUE
NATIVE {PropChunk} PROC
PROC PropChunk(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {PropChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
NATIVE {PropChunks} PROC
PROC PropChunks(iff:PTR TO iffhandle, propArray:PTR TO SLONG, numPairs:VALUE) IS NATIVE {PropChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
NATIVE {StopChunk} PROC
PROC StopChunk(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {StopChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
NATIVE {StopChunks} PROC
PROC StopChunks(iff:PTR TO iffhandle, propArray:PTR TO SLONG, numPairs:VALUE) IS NATIVE {StopChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
NATIVE {CollectionChunk} PROC
PROC CollectionChunk(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {CollectionChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
NATIVE {CollectionChunks} PROC
PROC CollectionChunks(iff:PTR TO iffhandle, propArray:PTR TO SLONG, numPairs:VALUE) IS NATIVE {CollectionChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
NATIVE {StopOnExit} PROC
PROC StopOnExit(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {StopOnExit(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
NATIVE {FindProp} PROC
PROC FindProp(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {FindProp(} iff {,} type {,} id {)} ENDNATIVE !!PTR TO storedproperty
NATIVE {FindCollection} PROC
PROC FindCollection(iff:PTR TO iffhandle, type:VALUE, id:VALUE) IS NATIVE {FindCollection(} iff {,} type {,} id {)} ENDNATIVE !!PTR TO collectionitem
NATIVE {FindPropContext} PROC
PROC FindPropContext(iff:PTR TO iffhandle) IS NATIVE {FindPropContext(} iff {)} ENDNATIVE !!PTR TO contextnode
NATIVE {CurrentChunk} PROC
PROC CurrentChunk(iff:PTR TO iffhandle) IS NATIVE {CurrentChunk(} iff {)} ENDNATIVE !!PTR TO contextnode
NATIVE {ParentChunk} PROC
PROC ParentChunk(contextNode:PTR TO contextnode) IS NATIVE {ParentChunk(} contextNode {)} ENDNATIVE !!PTR TO contextnode
NATIVE {AllocLocalItem} PROC
PROC AllocLocalItem(type:VALUE, id:VALUE, ident:VALUE, dataSize:ULONG) IS NATIVE {AllocLocalItem(} type {,} id {,} ident {,} dataSize {)} ENDNATIVE !!PTR TO localcontextitem
NATIVE {LocalItemData} PROC
PROC LocalItemData(localItem:PTR TO localcontextitem) IS NATIVE {LocalItemData(} localItem {)} ENDNATIVE !!APTR
NATIVE {SetLocalItemPurge} PROC
PROC SetLocalItemPurge(localItem:PTR TO localcontextitem, purgeHook:PTR TO hook) IS NATIVE {SetLocalItemPurge(} localItem {,} purgeHook {)} ENDNATIVE
NATIVE {FreeLocalItem} PROC
PROC FreeLocalItem(localItem:PTR TO localcontextitem) IS NATIVE {FreeLocalItem(} localItem {)} ENDNATIVE
NATIVE {FindLocalItem} PROC
PROC FindLocalItem(iff:PTR TO iffhandle, type:VALUE, id:VALUE, ident:VALUE) IS NATIVE {FindLocalItem(} iff {,} type {,} id {,} ident {)} ENDNATIVE !!PTR TO localcontextitem
NATIVE {StoreLocalItem} PROC
PROC StoreLocalItem(iff:PTR TO iffhandle, localItem:PTR TO localcontextitem, position:VALUE) IS NATIVE {StoreLocalItem(} iff {,} localItem {,} position {)} ENDNATIVE !!VALUE
NATIVE {StoreItemInContext} PROC
PROC StoreItemInContext(iff:PTR TO iffhandle, localItem:PTR TO localcontextitem, contextNode:PTR TO contextnode) IS NATIVE {StoreItemInContext(} iff {,} localItem {,} contextNode {)} ENDNATIVE
NATIVE {InitIFF} PROC
PROC InitIFF(iff:PTR TO iffhandle, flags:VALUE, streamHook:PTR TO hook) IS NATIVE {InitIFF(} iff {,} flags {,} streamHook {)} ENDNATIVE
NATIVE {InitIFFasDOS} PROC
PROC InitIFFasDOS(iff:PTR TO iffhandle) IS NATIVE {InitIFFasDOS(} iff {)} ENDNATIVE
NATIVE {InitIFFasClip} PROC
PROC InitIFFasClip(iff:PTR TO iffhandle) IS NATIVE {InitIFFasClip(} iff {)} ENDNATIVE
NATIVE {OpenClipboard} PROC
PROC OpenClipboard(unitNumber:VALUE) IS NATIVE {OpenClipboard(} unitNumber {)} ENDNATIVE !!PTR TO clipboardhandle
NATIVE {CloseClipboard} PROC
PROC CloseClipboard(clipHandle:PTR TO clipboardhandle) IS NATIVE {CloseClipboard(} clipHandle {)} ENDNATIVE
NATIVE {GoodID} PROC
PROC GoodID(id:VALUE) IS NATIVE {GoodID(} id {)} ENDNATIVE !!VALUE
NATIVE {GoodType} PROC
PROC GoodType(type:VALUE) IS NATIVE {GoodType(} type {)} ENDNATIVE !!VALUE
NATIVE {IDtoStr} PROC
PROC IdtoStr(id:VALUE, buf:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {IDtoStr(} id {,} buf {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
