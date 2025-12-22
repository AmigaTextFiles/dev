/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_IFFPARSE_H
#define _PPCINLINE_IFFPARSE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef IFFPARSE_BASE_NAME
#define IFFPARSE_BASE_NAME IFFParseBase
#endif /* !IFFPARSE_BASE_NAME */

#define AllocIFF() \
	LP0(0x1e, struct IFFHandle *, AllocIFF, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AllocLocalItem(type, id, ident, dataSize) \
	LP4(0xba, struct LocalContextItem *, AllocLocalItem, LONG, type, d0, LONG, id, d1, LONG, ident, d2, LONG, dataSize, d3, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CloseClipboard(clipHandle) \
	LP1NR(0xfc, CloseClipboard, struct ClipboardHandle *, clipHandle, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CloseIFF(iff) \
	LP1NR(0x30, CloseIFF, struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CollectionChunk(iff, type, id) \
	LP3(0x8a, LONG, CollectionChunk, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CollectionChunks(iff, propArray, numPairs) \
	LP3(0x90, LONG, CollectionChunks, struct IFFHandle *, iff, a0, CONST LONG *, propArray, a1, LONG, numPairs, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CurrentChunk(iff) \
	LP1(0xae, struct ContextNode *, CurrentChunk, CONST struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define EntryHandler(iff, type, id, position, handler, object) \
	LP6(0x66, LONG, EntryHandler, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, position, d2, struct Hook *, handler, a1, APTR, object, a2, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ExitHandler(iff, type, id, position, handler, object) \
	LP6(0x6c, LONG, ExitHandler, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, position, d2, struct Hook *, handler, a1, APTR, object, a2, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindCollection(iff, type, id) \
	LP3(0xa2, struct CollectionItem *, FindCollection, CONST struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindLocalItem(iff, type, id, ident) \
	LP4(0xd2, struct LocalContextItem *, FindLocalItem, CONST struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, ident, d2, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindProp(iff, type, id) \
	LP3(0x9c, struct StoredProperty *, FindProp, CONST struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindPropContext(iff) \
	LP1(0xa8, struct ContextNode *, FindPropContext, CONST struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeIFF(iff) \
	LP1NR(0x36, FreeIFF, struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeLocalItem(localItem) \
	LP1NR(0xcc, FreeLocalItem, struct LocalContextItem *, localItem, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GoodID(id) \
	LP1(0x102, LONG, GoodID, LONG, id, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GoodType(type) \
	LP1(0x108, LONG, GoodType, LONG, type, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define IDtoStr(id, buf) \
	LP2(0x10e, STRPTR, IDtoStr, LONG, id, d0, STRPTR, buf, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InitIFF(iff, flags, streamHook) \
	LP3NR(0xe4, InitIFF, struct IFFHandle *, iff, a0, LONG, flags, d0, CONST struct Hook *, streamHook, a1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InitIFFasClip(iff) \
	LP1NR(0xf0, InitIFFasClip, struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InitIFFasDOS(iff) \
	LP1NR(0xea, InitIFFasDOS, struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LocalItemData(localItem) \
	LP1(0xc0, APTR, LocalItemData, CONST struct LocalContextItem *, localItem, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenClipboard(unitNumber) \
	LP1(0xf6, struct ClipboardHandle *, OpenClipboard, LONG, unitNumber, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenIFF(iff, rwMode) \
	LP2(0x24, LONG, OpenIFF, struct IFFHandle *, iff, a0, LONG, rwMode, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ParentChunk(contextNode) \
	LP1(0xb4, struct ContextNode *, ParentChunk, CONST struct ContextNode *, contextNode, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ParseIFF(iff, control) \
	LP2(0x2a, LONG, ParseIFF, struct IFFHandle *, iff, a0, LONG, control, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PopChunk(iff) \
	LP1(0x5a, LONG, PopChunk, struct IFFHandle *, iff, a0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PropChunk(iff, type, id) \
	LP3(0x72, LONG, PropChunk, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PropChunks(iff, propArray, numPairs) \
	LP3(0x78, LONG, PropChunks, struct IFFHandle *, iff, a0, CONST LONG *, propArray, a1, LONG, numPairs, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PushChunk(iff, type, id, size) \
	LP4(0x54, LONG, PushChunk, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, size, d2, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadChunkBytes(iff, buf, numBytes) \
	LP3(0x3c, LONG, ReadChunkBytes, struct IFFHandle *, iff, a0, APTR, buf, a1, LONG, numBytes, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadChunkRecords(iff, buf, bytesPerRecord, numRecords) \
	LP4(0x48, LONG, ReadChunkRecords, struct IFFHandle *, iff, a0, APTR, buf, a1, LONG, bytesPerRecord, d0, LONG, numRecords, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetLocalItemPurge(localItem, purgeHook) \
	LP2NR(0xc6, SetLocalItemPurge, struct LocalContextItem *, localItem, a0, CONST struct Hook *, purgeHook, a1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StopChunk(iff, type, id) \
	LP3(0x7e, LONG, StopChunk, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StopChunks(iff, propArray, numPairs) \
	LP3(0x84, LONG, StopChunks, struct IFFHandle *, iff, a0, CONST LONG *, propArray, a1, LONG, numPairs, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StopOnExit(iff, type, id) \
	LP3(0x96, LONG, StopOnExit, struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StoreItemInContext(iff, localItem, contextNode) \
	LP3NR(0xde, StoreItemInContext, struct IFFHandle *, iff, a0, struct LocalContextItem *, localItem, a1, struct ContextNode *, contextNode, a2, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define StoreLocalItem(iff, localItem, position) \
	LP3(0xd8, LONG, StoreLocalItem, struct IFFHandle *, iff, a0, struct LocalContextItem *, localItem, a1, LONG, position, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteChunkBytes(iff, buf, numBytes) \
	LP3(0x42, LONG, WriteChunkBytes, struct IFFHandle *, iff, a0, CONST APTR, buf, a1, LONG, numBytes, d0, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteChunkRecords(iff, buf, bytesPerRecord, numRecords) \
	LP4(0x4e, LONG, WriteChunkRecords, struct IFFHandle *, iff, a0, CONST APTR, buf, a1, LONG, bytesPerRecord, d0, LONG, numRecords, d1, \
	, IFFPARSE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_IFFPARSE_H */
