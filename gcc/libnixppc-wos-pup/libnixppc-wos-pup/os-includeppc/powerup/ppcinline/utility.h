/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_UTILITY_H
#define _PPCINLINE_UTILITY_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef UTILITY_BASE_NAME
#define UTILITY_BASE_NAME UtilityBase
#endif /* !UTILITY_BASE_NAME */

#define AddNamedObject(nameSpace, object) \
	LP2(0xde, BOOL, AddNamedObject, struct NamedObject *, nameSpace, a0, struct NamedObject *, object, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AllocNamedObjectA(name, tagList) \
	LP2(0xe4, struct NamedObject *, AllocNamedObjectA, CONST_STRPTR, name, a0, CONST struct TagItem *, tagList, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AllocateTagItems(numTags) \
	LP1(0x42, struct TagItem *, AllocateTagItems, ULONG, numTags, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define Amiga2Date(seconds, result) \
	LP2NR(0x78, Amiga2Date, ULONG, seconds, d0, struct ClockData *, result, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ApplyTagChanges(list, changeList) \
	LP2NR(0xba, ApplyTagChanges, struct TagItem *, list, a0, CONST struct TagItem *, changeList, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AttemptRemNamedObject(object) \
	LP1(0xea, LONG, AttemptRemNamedObject, struct NamedObject *, object, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CallHookPkt(hook, object, paramPacket) \
	LP3(0x66, ULONG, CallHookPkt, struct Hook *, hook, a0, APTR, object, a2, APTR, paramPacket, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CheckDate(date) \
	LP1(0x84, ULONG, CheckDate, CONST struct ClockData *, date, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define CloneTagItems(tagList) \
	LP1(0x48, struct TagItem *, CloneTagItems, CONST struct TagItem *, tagList, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define Date2Amiga(date) \
	LP1(0x7e, ULONG, Date2Amiga, CONST struct ClockData *, date, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FilterTagChanges(changeList, originalList, apply) \
	LP3NR(0x36, FilterTagChanges, struct TagItem *, changeList, a0, struct TagItem *, originalList, a1, ULONG, apply, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FilterTagItems(tagList, filterArray, logic) \
	LP3(0x60, ULONG, FilterTagItems, struct TagItem *, tagList, a0, CONST Tag *, filterArray, a1, ULONG, logic, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindNamedObject(nameSpace, name, lastObject) \
	LP3(0xf0, struct NamedObject *, FindNamedObject, struct NamedObject *, nameSpace, a0, CONST_STRPTR, name, a1, struct NamedObject *, lastObject, a2, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindTagItem(tagVal, tagList) \
	LP2(0x1e, struct TagItem *, FindTagItem, Tag, tagVal, d0, CONST struct TagItem *, tagList, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeNamedObject(object) \
	LP1NR(0xf6, FreeNamedObject, struct NamedObject *, object, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeTagItems(tagList) \
	LP1NR(0x4e, FreeTagItems, struct TagItem *, tagList, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetTagData(tagValue, defaultVal, tagList) \
	LP3(0x24, ULONG, GetTagData, Tag, tagValue, d0, ULONG, defaultVal, d1, CONST struct TagItem *, tagList, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetUniqueID() \
	LP0(0x10e, ULONG, GetUniqueID, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define MapTags(tagList, mapList, mapType) \
	LP3NR(0x3c, MapTags, struct TagItem *, tagList, a0, CONST struct TagItem *, mapList, a1, ULONG, mapType, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NamedObjectName(object) \
	LP1(0xfc, STRPTR, NamedObjectName, struct NamedObject *, object, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NextTagItem(tagListPtr) \
	LP1(0x30, struct TagItem *, NextTagItem, struct TagItem **, tagListPtr, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PackBoolTags(initialFlags, tagList, boolMap) \
	LP3(0x2a, ULONG, PackBoolTags, ULONG, initialFlags, d0, CONST struct TagItem *, tagList, a0, CONST struct TagItem *, boolMap, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PackStructureTags(pack, packTable, tagList) \
	LP3(0xd2, ULONG, PackStructureTags, APTR, pack, a0, CONST ULONG *, packTable, a1, CONST struct TagItem *, tagList, a2, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RefreshTagItemClones(clone, original) \
	LP2NR(0x54, RefreshTagItemClones, struct TagItem *, clone, a0, CONST struct TagItem *, original, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReleaseNamedObject(object) \
	LP1NR(0x102, ReleaseNamedObject, struct NamedObject *, object, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RemNamedObject(object, message) \
	LP2NR(0x108, RemNamedObject, struct NamedObject *, object, a0, struct Message *, message, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SDivMod32(dividend, divisor) \
	LP2(0x96, LONG, SDivMod32, LONG, dividend, d0, LONG, divisor, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SMult32(arg1, arg2) \
	LP2(0x8a, LONG, SMult32, LONG, arg1, d0, LONG, arg2, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SMult64(arg1, arg2) \
	LP2(0xc6, LONG, SMult64, LONG, arg1, d0, LONG, arg2, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define Stricmp(string1, string2) \
	LP2(0xa2, LONG, Stricmp, CONST_STRPTR, string1, a0, CONST_STRPTR, string2, a1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define Strnicmp(string1, string2, length) \
	LP3(0xa8, LONG, Strnicmp, CONST_STRPTR, string1, a0, CONST_STRPTR, string2, a1, LONG, length, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define TagInArray(tagValue, tagArray) \
	LP2(0x5a, BOOL, TagInArray, Tag, tagValue, d0, CONST Tag *, tagArray, a0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ToLower(character) \
	LP1(0xb4, UBYTE, ToLower, ULONG, character, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ToUpper(character) \
	LP1(0xae, UBYTE, ToUpper, ULONG, character, d0, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define UDivMod32(dividend, divisor) \
	LP2(0x9c, ULONG, UDivMod32, ULONG, dividend, d0, ULONG, divisor, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define UMult32(arg1, arg2) \
	LP2(0x90, ULONG, UMult32, ULONG, arg1, d0, ULONG, arg2, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define UMult64(arg1, arg2) \
	LP2(0xcc, ULONG, UMult64, ULONG, arg1, d0, ULONG, arg2, d1, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define UnpackStructureTags(pack, packTable, tagList) \
	LP3(0xd8, ULONG, UnpackStructureTags, CONST APTR, pack, a0, CONST ULONG *, packTable, a1, struct TagItem *, tagList, a2, \
	, UTILITY_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_UTILITY_H */
