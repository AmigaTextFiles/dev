#ifndef _INCLUDE_PRAGMA_UTILITY_LIB_H
#define _INCLUDE_PRAGMA_UTILITY_LIB_H

/*
**  $VER: utility_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_UTILITY_PROTOS_H
#include <clib/utility_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(UtilityBase, 0x1e, FindTagItem(d0,a0))
#pragma amicall(UtilityBase, 0x24, GetTagData(d0,d1,a0))
#pragma amicall(UtilityBase, 0x2a, PackBoolTags(d0,a0,a1))
#pragma amicall(UtilityBase, 0x30, NextTagItem(a0))
#pragma amicall(UtilityBase, 0x36, FilterTagChanges(a0,a1,d0))
#pragma amicall(UtilityBase, 0x3c, MapTags(a0,a1,d0))
#pragma amicall(UtilityBase, 0x42, AllocateTagItems(d0))
#pragma amicall(UtilityBase, 0x48, CloneTagItems(a0))
#pragma amicall(UtilityBase, 0x4e, FreeTagItems(a0))
#pragma amicall(UtilityBase, 0x54, RefreshTagItemClones(a0,a1))
#pragma amicall(UtilityBase, 0x5a, TagInArray(d0,a0))
#pragma amicall(UtilityBase, 0x60, FilterTagItems(a0,a1,d0))
#pragma amicall(UtilityBase, 0x66, CallHookPkt(a0,a2,a1))
#pragma amicall(UtilityBase, 0x78, Amiga2Date(d0,a0))
#pragma amicall(UtilityBase, 0x7e, Date2Amiga(a0))
#pragma amicall(UtilityBase, 0x84, CheckDate(a0))
#pragma amicall(UtilityBase, 0x8a, SMult32(d0,d1))
#pragma amicall(UtilityBase, 0x90, UMult32(d0,d1))
#pragma amicall(UtilityBase, 0x96, SDivMod32(d0,d1))
#pragma amicall(UtilityBase, 0x9c, UDivMod32(d0,d1))
#pragma amicall(UtilityBase, 0xa2, Stricmp(a0,a1))
#pragma amicall(UtilityBase, 0xa8, Strnicmp(a0,a1,d0))
#pragma amicall(UtilityBase, 0xae, ToUpper(d0))
#pragma amicall(UtilityBase, 0xb4, ToLower(d0))
#pragma amicall(UtilityBase, 0xba, ApplyTagChanges(a0,a1))
#pragma amicall(UtilityBase, 0xc6, SMult64(d0,d1))
#pragma amicall(UtilityBase, 0xcc, UMult64(d0,d1))
#pragma amicall(UtilityBase, 0xd2, PackStructureTags(a0,a1,a2))
#pragma amicall(UtilityBase, 0xd8, UnpackStructureTags(a0,a1,a2))
#pragma amicall(UtilityBase, 0xde, AddNamedObject(a0,a1))
#pragma amicall(UtilityBase, 0xe4, AllocNamedObjectA(a0,a1))
#pragma tagcall(UtilityBase, 0xe4, AllocNamedObject(a0,a1)) // New
#pragma amicall(UtilityBase, 0xea, AttemptRemNamedObject(a0))
#pragma amicall(UtilityBase, 0xf0, FindNamedObject(a0,a1,a2))
#pragma amicall(UtilityBase, 0xf6, FreeNamedObject(a0))
#pragma amicall(UtilityBase, 0xfc, NamedObjectName(a0))
#pragma amicall(UtilityBase, 0x102, ReleaseNamedObject(a0))
#pragma amicall(UtilityBase, 0x108, RemNamedObject(a0,a1))
#pragma amicall(UtilityBase, 0x10e, GetUniqueID())

#ifdef __cplusplus
}
#endif

#endif
