#ifndef _VBCCINLINE_UTILITY_H
#define _VBCCINLINE_UTILITY_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct TagItem * __FindTagItem(struct UtilityBase *, Tag tagVal, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define FindTagItem(tagVal, tagList) __FindTagItem(UtilityBase, (tagVal), (tagList))

ULONG __GetTagData(struct UtilityBase *, Tag tagValue, ULONG defaultVal, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tstw\t6,32(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define GetTagData(tagValue, defaultVal, tagList) __GetTagData(UtilityBase, (tagValue), (defaultVal), (tagList))

ULONG __PackBoolTags(struct UtilityBase *, ULONG initialFlags, const struct TagItem * tagList, const struct TagItem * boolMap) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,36(2)\n"
	"\tli\t3,-42\n"
	"\tblrl";
#define PackBoolTags(initialFlags, tagList, boolMap) __PackBoolTags(UtilityBase, (initialFlags), (tagList), (boolMap))

struct TagItem * __NextTagItem(struct UtilityBase *, struct TagItem ** tagListPtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-48\n"
	"\tblrl";
#define NextTagItem(tagListPtr) __NextTagItem(UtilityBase, (tagListPtr))

VOID __FilterTagChanges(struct UtilityBase *, struct TagItem * changeList, struct TagItem * originalList, ULONG apply) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-54\n"
	"\tblrl";
#define FilterTagChanges(changeList, originalList, apply) __FilterTagChanges(UtilityBase, (changeList), (originalList), (apply))

VOID __MapTags(struct UtilityBase *, struct TagItem * tagList, const struct TagItem * mapList, ULONG mapType) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-60\n"
	"\tblrl";
#define MapTags(tagList, mapList, mapType) __MapTags(UtilityBase, (tagList), (mapList), (mapType))

struct TagItem * __AllocateTagItems(struct UtilityBase *, ULONG numTags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-66\n"
	"\tblrl";
#define AllocateTagItems(numTags) __AllocateTagItems(UtilityBase, (numTags))

struct TagItem * __CloneTagItems(struct UtilityBase *, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-72\n"
	"\tblrl";
#define CloneTagItems(tagList) __CloneTagItems(UtilityBase, (tagList))

VOID __FreeTagItems(struct UtilityBase *, struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-78\n"
	"\tblrl";
#define FreeTagItems(tagList) __FreeTagItems(UtilityBase, (tagList))

VOID __RefreshTagItemClones(struct UtilityBase *, struct TagItem * clone, const struct TagItem * original) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-84\n"
	"\tblrl";
#define RefreshTagItemClones(clone, original) __RefreshTagItemClones(UtilityBase, (clone), (original))

BOOL __TagInArray(struct UtilityBase *, Tag tagValue, const Tag * tagArray) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tli\t3,-90\n"
	"\tblrl";
#define TagInArray(tagValue, tagArray) __TagInArray(UtilityBase, (tagValue), (tagArray))

ULONG __FilterTagItems(struct UtilityBase *, struct TagItem * tagList, const Tag * filterArray, ULONG logic) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-96\n"
	"\tblrl";
#define FilterTagItems(tagList, filterArray, logic) __FilterTagItems(UtilityBase, (tagList), (filterArray), (logic))

ULONG __CallHookPkt(struct UtilityBase *, struct Hook * hook, APTR object, APTR paramPacket) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,40(2)\n"
	"\tstw\t6,36(2)\n"
	"\tli\t3,-102\n"
	"\tblrl";
#define CallHookPkt(hook, object, paramPacket) __CallHookPkt(UtilityBase, (hook), (object), (paramPacket))

VOID __Amiga2Date(struct UtilityBase *, ULONG seconds, struct ClockData * result) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tli\t3,-120\n"
	"\tblrl";
#define Amiga2Date(seconds, result) __Amiga2Date(UtilityBase, (seconds), (result))

ULONG __Date2Amiga(struct UtilityBase *, const struct ClockData * date) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-126\n"
	"\tblrl";
#define Date2Amiga(date) __Date2Amiga(UtilityBase, (date))

ULONG __CheckDate(struct UtilityBase *, const struct ClockData * date) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-132\n"
	"\tblrl";
#define CheckDate(date) __CheckDate(UtilityBase, (date))

LONG __SMult32(struct UtilityBase *, LONG arg1, LONG arg2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-138\n"
	"\tblrl";
#define SMult32(arg1, arg2) __SMult32(UtilityBase, (arg1), (arg2))

ULONG __UMult32(struct UtilityBase *, ULONG arg1, ULONG arg2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-144\n"
	"\tblrl";
#define UMult32(arg1, arg2) __UMult32(UtilityBase, (arg1), (arg2))

LONG __SDivMod32(struct UtilityBase *, LONG dividend, LONG divisor) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-150\n"
	"\tblrl";
#define SDivMod32(dividend, divisor) __SDivMod32(UtilityBase, (dividend), (divisor))

ULONG __UDivMod32(struct UtilityBase *, ULONG dividend, ULONG divisor) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-156\n"
	"\tblrl";
#define UDivMod32(dividend, divisor) __UDivMod32(UtilityBase, (dividend), (divisor))

LONG __Stricmp(struct UtilityBase *, CONST_STRPTR string1, CONST_STRPTR string2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-162\n"
	"\tblrl";
#define Stricmp(string1, string2) __Stricmp(UtilityBase, (string1), (string2))

LONG __Strnicmp(struct UtilityBase *, CONST_STRPTR string1, CONST_STRPTR string2, LONG length) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-168\n"
	"\tblrl";
#define Strnicmp(string1, string2, length) __Strnicmp(UtilityBase, (string1), (string2), (length))

UBYTE __ToUpper(struct UtilityBase *, ULONG character) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-174\n"
	"\tblrl";
#define ToUpper(character) __ToUpper(UtilityBase, (character))

UBYTE __ToLower(struct UtilityBase *, ULONG character) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-180\n"
	"\tblrl";
#define ToLower(character) __ToLower(UtilityBase, (character))

VOID __ApplyTagChanges(struct UtilityBase *, struct TagItem * list, const struct TagItem * changeList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-186\n"
	"\tblrl";
#define ApplyTagChanges(list, changeList) __ApplyTagChanges(UtilityBase, (list), (changeList))

LONG __SMult64(struct UtilityBase *, LONG arg1, LONG arg2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-198\n"
	"\tblrl";
#define SMult64(arg1, arg2) __SMult64(UtilityBase, (arg1), (arg2))

ULONG __UMult64(struct UtilityBase *, ULONG arg1, ULONG arg2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tli\t3,-204\n"
	"\tblrl";
#define UMult64(arg1, arg2) __UMult64(UtilityBase, (arg1), (arg2))

ULONG __PackStructureTags(struct UtilityBase *, APTR pack, const ULONG * packTable, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-210\n"
	"\tblrl";
#define PackStructureTags(pack, packTable, tagList) __PackStructureTags(UtilityBase, (pack), (packTable), (tagList))

ULONG __UnpackStructureTags(struct UtilityBase *, const APTR pack, const ULONG * packTable, struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-216\n"
	"\tblrl";
#define UnpackStructureTags(pack, packTable, tagList) __UnpackStructureTags(UtilityBase, (pack), (packTable), (tagList))

BOOL __AddNamedObject(struct UtilityBase *, struct NamedObject * nameSpace, struct NamedObject * object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-222\n"
	"\tblrl";
#define AddNamedObject(nameSpace, object) __AddNamedObject(UtilityBase, (nameSpace), (object))

struct NamedObject * __AllocNamedObjectA(struct UtilityBase *, CONST_STRPTR name, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define AllocNamedObjectA(name, tagList) __AllocNamedObjectA(UtilityBase, (name), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
struct NamedObject * __AllocNamedObject(struct UtilityBase *, long, long, long, long, long, long, CONST_STRPTR name, Tag tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,32(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define AllocNamedObject(name, ...) __AllocNamedObject(UtilityBase, 0, 0, 0, 0, 0, 0, (name), __VA_ARGS__)
#endif

LONG __AttemptRemNamedObject(struct UtilityBase *, struct NamedObject * object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-234\n"
	"\tblrl";
#define AttemptRemNamedObject(object) __AttemptRemNamedObject(UtilityBase, (object))

struct NamedObject * __FindNamedObject(struct UtilityBase *, struct NamedObject * nameSpace, CONST_STRPTR name, struct NamedObject * lastObject) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define FindNamedObject(nameSpace, name, lastObject) __FindNamedObject(UtilityBase, (nameSpace), (name), (lastObject))

VOID __FreeNamedObject(struct UtilityBase *, struct NamedObject * object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-246\n"
	"\tblrl";
#define FreeNamedObject(object) __FreeNamedObject(UtilityBase, (object))

STRPTR __NamedObjectName(struct UtilityBase *, struct NamedObject * object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-252\n"
	"\tblrl";
#define NamedObjectName(object) __NamedObjectName(UtilityBase, (object))

VOID __ReleaseNamedObject(struct UtilityBase *, struct NamedObject * object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-258\n"
	"\tblrl";
#define ReleaseNamedObject(object) __ReleaseNamedObject(UtilityBase, (object))

VOID __RemNamedObject(struct UtilityBase *, struct NamedObject * object, struct Message * message) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-264\n"
	"\tblrl";
#define RemNamedObject(object, message) __RemNamedObject(UtilityBase, (object), (message))

ULONG __GetUniqueID(struct UtilityBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-270\n"
	"\tblrl";
#define GetUniqueID() __GetUniqueID(UtilityBase)

#endif /*  _VBCCINLINE_UTILITY_H  */
