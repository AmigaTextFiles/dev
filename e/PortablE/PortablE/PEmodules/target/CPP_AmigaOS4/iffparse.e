/* $Id: iffparse_protos.h,v 1.8 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/iffparse'
MODULE 'target/exec/types', /*'target/libraries/iffparse',*/ 'target/utility/hooks'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/iffparse.h>
}
{
struct Library* IFFParseBase = NULL;
struct IFFParseIFace* IIFFParse = NULL;
}
NATIVE {CLIB_IFFPARSE_PROTOS_H} CONST
NATIVE {PROTO_IFFPARSE_H} CONST
NATIVE {PRAGMA_IFFPARSE_H} CONST
NATIVE {INLINE4_IFFPARSE_H} CONST
NATIVE {IFFPARSE_INTERFACE_DEF_H} CONST

NATIVE {IFFParseBase} DEF iffparsebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IIFFParse} DEF

PROC new()
	InitLibrary('iffparse.library', NATIVE {(struct Interface **) &IIFFParse} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Basic functions */

->NATIVE {AllocIFF} PROC
PROC AllocIFF( ) IS NATIVE {IIFFParse->AllocIFF()} ENDNATIVE !!PTR TO iffhandle
->NATIVE {OpenIFF} PROC
PROC OpenIFF( iff:PTR TO iffhandle, rwMode:VALUE ) IS NATIVE {IIFFParse->OpenIFF(} iff {,} rwMode {)} ENDNATIVE !!VALUE
->NATIVE {ParseIFF} PROC
PROC ParseIFF( iff:PTR TO iffhandle, control:VALUE ) IS NATIVE {IIFFParse->ParseIFF(} iff {,} control {)} ENDNATIVE !!VALUE
->NATIVE {CloseIFF} PROC
PROC CloseIFF( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->CloseIFF(} iff {)} ENDNATIVE
->NATIVE {FreeIFF} PROC
PROC FreeIFF( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->FreeIFF(} iff {)} ENDNATIVE

/* Read/Write functions */

->NATIVE {ReadChunkBytes} PROC
PROC ReadChunkBytes( iff:PTR TO iffhandle, buf:APTR, numBytes:VALUE ) IS NATIVE {IIFFParse->ReadChunkBytes(} iff {,} buf {,} numBytes {)} ENDNATIVE !!VALUE
->NATIVE {WriteChunkBytes} PROC
PROC WriteChunkBytes( iff:PTR TO iffhandle, buf:CONST_APTR, numBytes:VALUE ) IS NATIVE {IIFFParse->WriteChunkBytes(} iff {,} buf {,} numBytes {)} ENDNATIVE !!VALUE
->NATIVE {ReadChunkRecords} PROC
PROC ReadChunkRecords( iff:PTR TO iffhandle, buf:APTR, bytesPerRecord:VALUE, numRecords:VALUE ) IS NATIVE {IIFFParse->ReadChunkRecords(} iff {,} buf {,} bytesPerRecord {,} numRecords {)} ENDNATIVE !!VALUE
->NATIVE {WriteChunkRecords} PROC
PROC WriteChunkRecords( iff:PTR TO iffhandle, buf:CONST_APTR, bytesPerRecord:VALUE, numRecords:VALUE ) IS NATIVE {IIFFParse->WriteChunkRecords(} iff {,} buf {,} bytesPerRecord {,} numRecords {)} ENDNATIVE !!VALUE

/* Context entry/exit */

->NATIVE {PushChunk} PROC
PROC PushChunk( iff:PTR TO iffhandle, type:VALUE, id:VALUE, size:VALUE ) IS NATIVE {IIFFParse->PushChunk(} iff {,} type {,} id {,} size {)} ENDNATIVE !!VALUE
->NATIVE {PopChunk} PROC
PROC PopChunk( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->PopChunk(} iff {)} ENDNATIVE !!VALUE

/* Low-level handler installation */

->NATIVE {EntryHandler} PROC
PROC EntryHandler( iff:PTR TO iffhandle, type:VALUE, id:VALUE, position:VALUE, handler:PTR TO hook, object:APTR ) IS NATIVE {IIFFParse->EntryHandler(} iff {,} type {,} id {,} position {,} handler {,} object {)} ENDNATIVE !!VALUE
->NATIVE {ExitHandler} PROC
PROC ExitHandler( iff:PTR TO iffhandle, type:VALUE, id:VALUE, position:VALUE, handler:PTR TO hook, object:APTR ) IS NATIVE {IIFFParse->ExitHandler(} iff {,} type {,} id {,} position {,} handler {,} object {)} ENDNATIVE !!VALUE

/* Built-in chunk/property handlers */

->NATIVE {PropChunk} PROC
PROC PropChunk( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->PropChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
->NATIVE {PropChunks} PROC
PROC PropChunks( iff:PTR TO iffhandle, propArray:PTR TO VALUE, numPairs:VALUE ) IS NATIVE {IIFFParse->PropChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
->NATIVE {StopChunk} PROC
PROC StopChunk( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->StopChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
->NATIVE {StopChunks} PROC
PROC StopChunks( iff:PTR TO iffhandle, propArray:PTR TO VALUE, numPairs:VALUE ) IS NATIVE {IIFFParse->StopChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
->NATIVE {CollectionChunk} PROC
PROC CollectionChunk( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->CollectionChunk(} iff {,} type {,} id {)} ENDNATIVE !!VALUE
->NATIVE {CollectionChunks} PROC
PROC CollectionChunks( iff:PTR TO iffhandle, propArray:PTR TO VALUE, numPairs:VALUE ) IS NATIVE {IIFFParse->CollectionChunks(} iff {,} propArray {,} numPairs {)} ENDNATIVE !!VALUE
->NATIVE {StopOnExit} PROC
PROC StopOnExit( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->StopOnExit(} iff {,} type {,} id {)} ENDNATIVE !!VALUE

/* Context utilities */

->NATIVE {FindProp} PROC
PROC FindProp( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->FindProp(} iff {,} type {,} id {)} ENDNATIVE !!PTR TO storedproperty
->NATIVE {FindCollection} PROC
PROC FindCollection( iff:PTR TO iffhandle, type:VALUE, id:VALUE ) IS NATIVE {IIFFParse->FindCollection(} iff {,} type {,} id {)} ENDNATIVE !!PTR TO collectionitem
->NATIVE {FindPropContext} PROC
PROC FindPropContext( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->FindPropContext(} iff {)} ENDNATIVE !!PTR TO contextnode
->NATIVE {CurrentChunk} PROC
PROC CurrentChunk( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->CurrentChunk(} iff {)} ENDNATIVE !!PTR TO contextnode
->NATIVE {ParentChunk} PROC
PROC ParentChunk( contextNode:PTR TO contextnode ) IS NATIVE {IIFFParse->ParentChunk(} contextNode {)} ENDNATIVE !!PTR TO contextnode

/* LocalContextItem support functions */

->NATIVE {AllocLocalItem} PROC
PROC AllocLocalItem( type:VALUE, id:VALUE, ident:VALUE, dataSize:VALUE ) IS NATIVE {IIFFParse->AllocLocalItem(} type {,} id {,} ident {,} dataSize {)} ENDNATIVE !!PTR TO localcontextitem
->NATIVE {LocalItemData} PROC
PROC LocalItemData( localItem:PTR TO localcontextitem ) IS NATIVE {IIFFParse->LocalItemData(} localItem {)} ENDNATIVE !!APTR
->NATIVE {SetLocalItemPurge} PROC
PROC SetLocalItemPurge( localItem:PTR TO localcontextitem, purgeHook:PTR TO hook ) IS NATIVE {IIFFParse->SetLocalItemPurge(} localItem {,} purgeHook {)} ENDNATIVE
->NATIVE {FreeLocalItem} PROC
PROC FreeLocalItem( localItem:PTR TO localcontextitem ) IS NATIVE {IIFFParse->FreeLocalItem(} localItem {)} ENDNATIVE
->NATIVE {FindLocalItem} PROC
PROC FindLocalItem( iff:PTR TO iffhandle, type:VALUE, id:VALUE, ident:VALUE ) IS NATIVE {IIFFParse->FindLocalItem(} iff {,} type {,} id {,} ident {)} ENDNATIVE !!PTR TO localcontextitem
->NATIVE {StoreLocalItem} PROC
PROC StoreLocalItem( iff:PTR TO iffhandle, localItem:PTR TO localcontextitem, position:VALUE ) IS NATIVE {IIFFParse->StoreLocalItem(} iff {,} localItem {,} position {)} ENDNATIVE !!VALUE
->NATIVE {StoreItemInContext} PROC
PROC StoreItemInContext( iff:PTR TO iffhandle, localItem:PTR TO localcontextitem, contextNode:PTR TO contextnode ) IS NATIVE {IIFFParse->StoreItemInContext(} iff {,} localItem {,} contextNode {)} ENDNATIVE

/* IFFHandle initialization */

->NATIVE {InitIFF} PROC
PROC InitIFF( iff:PTR TO iffhandle, flags:VALUE, streamHook:PTR TO hook ) IS NATIVE {IIFFParse->InitIFF(} iff {,} flags {,} streamHook {)} ENDNATIVE
->NATIVE {InitIFFasDOS} PROC
PROC InitIFFasDOS( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->InitIFFasDOS(} iff {)} ENDNATIVE
->NATIVE {InitIFFasClip} PROC
PROC InitIFFasClip( iff:PTR TO iffhandle ) IS NATIVE {IIFFParse->InitIFFasClip(} iff {)} ENDNATIVE

/* Internal clipboard support */

->NATIVE {OpenClipboard} PROC
PROC OpenClipboard( unitNumber:VALUE ) IS NATIVE {IIFFParse->OpenClipboard(} unitNumber {)} ENDNATIVE !!PTR TO clipboardhandle
->NATIVE {CloseClipboard} PROC
PROC CloseClipboard( clipHandle:PTR TO clipboardhandle ) IS NATIVE {IIFFParse->CloseClipboard(} clipHandle {)} ENDNATIVE

/* Miscellaneous */

->NATIVE {GoodID} PROC
PROC GoodID( id:VALUE ) IS NATIVE {IIFFParse->GoodID(} id {)} ENDNATIVE !!VALUE
->NATIVE {GoodType} PROC
PROC GoodType( type:VALUE ) IS NATIVE {IIFFParse->GoodType(} type {)} ENDNATIVE !!VALUE
->NATIVE {IDtoStr} PROC
PROC IdtoStr( id:VALUE, buf:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {IIFFParse->IDtoStr(} id {,} buf {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
