#ifndef _INCLUDE_PRAGMA_IFFPARSE_LIB_H
#define _INCLUDE_PRAGMA_IFFPARSE_LIB_H

/*
**  $VER: parse_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_IFFPARSE_PROTOS_H
#include <clib/iffparse_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(IFFParseBase, 0x1e, AllocIFF())
#pragma amicall(IFFParseBase, 0x24, OpenIFF(a0,d0))
#pragma amicall(IFFParseBase, 0x2a, ParseIFF(a0,d0))
#pragma amicall(IFFParseBase, 0x30, CloseIFF(a0))
#pragma amicall(IFFParseBase, 0x36, FreeIFF(a0))
#pragma amicall(IFFParseBase, 0x3c, ReadChunkBytes(a0,a1,d0))
#pragma amicall(IFFParseBase, 0x42, WriteChunkBytes(a0,a1,d0))
#pragma amicall(IFFParseBase, 0x48, ReadChunkRecords(a0,a1,d0,d1))
#pragma amicall(IFFParseBase, 0x4e, WriteChunkRecords(a0,a1,d0,d1))
#pragma amicall(IFFParseBase, 0x54, PushChunk(a0,d0,d1,d2))
#pragma amicall(IFFParseBase, 0x5a, PopChunk(a0))
#pragma amicall(IFFParseBase, 0x66, EntryHandler(a0,d0,d1,d2,a1,a2))
#pragma amicall(IFFParseBase, 0x6c, ExitHandler(a0,d0,d1,d2,a1,a2))
#pragma amicall(IFFParseBase, 0x72, PropChunk(a0,d0,d1))
#pragma amicall(IFFParseBase, 0x78, PropChunks(a0,a1,d0))
#pragma amicall(IFFParseBase, 0x7e, StopChunk(a0,d0,d1))
#pragma amicall(IFFParseBase, 0x84, StopChunks(a0,a1,d0))
#pragma amicall(IFFParseBase, 0x8a, CollectionChunk(a0,d0,d1))
#pragma amicall(IFFParseBase, 0x90, CollectionChunks(a0,a1,d0))
#pragma amicall(IFFParseBase, 0x96, StopOnExit(a0,d0,d1))
#pragma amicall(IFFParseBase, 0x9c, FindProp(a0,d0,d1))
#pragma amicall(IFFParseBase, 0xa2, FindCollection(a0,d0,d1))
#pragma amicall(IFFParseBase, 0xa8, FindPropContext(a0))
#pragma amicall(IFFParseBase, 0xae, CurrentChunk(a0))
#pragma amicall(IFFParseBase, 0xb4, ParentChunk(a0))
#pragma amicall(IFFParseBase, 0xba, AllocLocalItem(d0,d1,d2,d3))
#pragma amicall(IFFParseBase, 0xc0, LocalItemData(a0))
#pragma amicall(IFFParseBase, 0xc6, SetLocalItemPurge(a0,a1))
#pragma amicall(IFFParseBase, 0xcc, FreeLocalItem(a0))
#pragma amicall(IFFParseBase, 0xd2, FindLocalItem(a0,d0,d1,d2))
#pragma amicall(IFFParseBase, 0xd8, StoreLocalItem(a0,a1,d0))
#pragma amicall(IFFParseBase, 0xde, StoreItemInContext(a0,a1,a2))
#pragma amicall(IFFParseBase, 0xe4, InitIFF(a0,d0,a1))
#pragma amicall(IFFParseBase, 0xea, InitIFFasDOS(a0))
#pragma amicall(IFFParseBase, 0xf0, InitIFFasClip(a0))
#pragma amicall(IFFParseBase, 0xf6, OpenClipboard(d0))
#pragma amicall(IFFParseBase, 0xfc, CloseClipboard(a0))
#pragma amicall(IFFParseBase, 0x102, GoodID(d0))
#pragma amicall(IFFParseBase, 0x108, GoodType(d0))
#pragma amicall(IFFParseBase, 0x10e, IDtoStr(d0,a0))

#ifdef __cplusplus
}
#endif

#endif
