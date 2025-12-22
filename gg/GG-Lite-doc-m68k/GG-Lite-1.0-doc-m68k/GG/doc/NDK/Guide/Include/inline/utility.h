@DATABASE "gg:doc/NDK/Guide/Include/inline/utility.h"
@MASTER   "gg:os-include/inline/utility.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:47
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/utility.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/utility.h" LINK File}


@{b}#defines@{ub}

@{"AddNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 151}         @{"AllocateTagItems()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 59}      @{"AllocNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 160}
@{"AllocNamedObjectA()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 155}      @{"Amiga2Date()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 87}            @{"ApplyTagChanges()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 131}
@{"AttemptRemNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 164}  @{"CallHookPkt()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 83}           @{"CheckDate()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 95}
@{"CLIB_UTILITY_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 5}    @{"CloneTagItems()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 63}         @{"Date2Amiga()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 91}
@{"FilterTagChanges()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 51}       @{"FilterTagItems()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 79}        @{"FindNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 168}
@{"FindTagItem()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 35}            @{"FreeNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 172}       @{"FreeTagItems()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 67}
@{"GetTagData()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 39}             @{"GetUniqueID()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 188}           @{"MapTags()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 55}
@{"NamedObjectName()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 176}        @{"NextTagItem()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 47}           @{"PackBoolTags()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 43}
@{"PackStructureTags()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 143}      @{"RefreshTagItemClones()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 71}  @{"ReleaseNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 180}
@{"RemNamedObject()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 184}         @{"SDivMod32()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 107}             @{"SMult32()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 99}
@{"SMult64()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 135}                @{"Stricmp()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 115}               @{"Strnicmp()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 119}
@{"TagInArray()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 75}             @{"ToLower()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 127}               @{"ToUpper()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 123}
@{"UDivMod32()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 111}              @{"UMult32()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 103}               @{"UMult64()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 139}
@{"UnpackStructureTags()" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 147}    @{"UTILITY_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 32}       

@ENDNODE
@NODE File "inline/utility.h"
#ifndef _INLINE_UTILITY_H
#define _INLINE_UTILITY_H

#ifndef CLIB_UTILITY_PROTOS_H
#define CLIB_UTILITY_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  UTILITY_DATE_H
#include <@{"utility/date.h" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  UTILITY_NAME_H
#include <@{"utility/name.h" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File"}>
#endif

#ifndef UTILITY_BASE_NAME
#define UTILITY_BASE_NAME UtilityBase
#endif

#define @{"FindTagItem" LINK "gg:doc/NDK/Guide/utility/FindTagItem"}(tagVal, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x1e, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, FindTagItem, Tag, tagVal, d0, const struct TagItem *, tagList, a0, \\
        , UTILITY_BASE_NAME)

#define @{"GetTagData" LINK "gg:doc/NDK/Guide/utility/GetTagData"}(tagValue, defaultVal, tagList) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x24, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetTagData" LINK File 39}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, tagValue, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, defaultVal, d1, const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, \\
        , UTILITY_BASE_NAME)

#define @{"PackBoolTags" LINK "gg:doc/NDK/Guide/utility/PackBoolTags"}(initialFlags, tagList, boolMap) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x2a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"PackBoolTags" LINK File 43}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, initialFlags, d0, const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, const struct TagItem *, boolMap, a1, \\
        , UTILITY_BASE_NAME)

#define @{"NextTagItem" LINK "gg:doc/NDK/Guide/utility/NextTagItem"}(tagListPtr) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x30, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, NextTagItem, struct TagItem **, tagListPtr, a0, \\
        , UTILITY_BASE_NAME)

#define @{"FilterTagChanges" LINK "gg:doc/NDK/Guide/utility/FilterTagChanges"}(changeList, originalList, apply) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x36, @{"FilterTagChanges" LINK File 51}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, changeList, a0, struct TagItem *, originalList, a1, ULONG, apply, d0, \\
        , UTILITY_BASE_NAME)

#define @{"MapTags" LINK "gg:doc/NDK/Guide/utility/MapTags"}(tagList, mapList, mapType) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x3c, @{"MapTags" LINK File 55}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, const struct TagItem *, mapList, a1, ULONG, mapType, d0, \\
        , UTILITY_BASE_NAME)

#define @{"AllocateTagItems" LINK "gg:doc/NDK/Guide/utility/AllocateTagItems"}(numTags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x42, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, AllocateTagItems, ULONG, numTags, d0, \\
        , UTILITY_BASE_NAME)

#define @{"CloneTagItems" LINK "gg:doc/NDK/Guide/utility/CloneTagItems"}(tagList) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, CloneTagItems, const struct TagItem *, tagList, a0, \\
        , UTILITY_BASE_NAME)

#define @{"FreeTagItems" LINK "gg:doc/NDK/Guide/utility/FreeTagItems"}(tagList) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x4e, @{"FreeTagItems" LINK File 67}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, \\
        , UTILITY_BASE_NAME)

#define @{"RefreshTagItemClones" LINK "gg:doc/NDK/Guide/utility/RefreshTagItemClones"}(clone, original) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x54, @{"RefreshTagItemClones" LINK File 71}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, clone, a0, const struct TagItem *, original, a1, \\
        , UTILITY_BASE_NAME)

#define @{"TagInArray" LINK "gg:doc/NDK/Guide/utility/TagInArray"}(tagValue, tagArray) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x5a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"TagInArray" LINK File 75}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, tagValue, d0, const @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} *, tagArray, a0, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"FilterTagItems" LINK "gg:doc/NDK/Guide/utility/FilterTagItems"}(tagList, filterArray, logic) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x60, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"FilterTagItems" LINK File 79}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a0, const Tag *, filterArray, a1, ULONG, logic, d0, \\
        , UTILITY_BASE_NAME)

#define @{"CallHookPkt" LINK "gg:doc/NDK/Guide/utility/CallHookPkt"}(hook, object, paramPacket) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x66, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CallHookPkt" LINK File 83}, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, hook, a0, APTR, object, a2, APTR, paramPacket, a1, \\
        , UTILITY_BASE_NAME)

#define @{"Amiga2Date" LINK "gg:doc/NDK/Guide/utility/Amiga2Date"}(seconds, result) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x78, @{"Amiga2Date" LINK File 87}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, seconds, d0, @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *, result, a0, \\
        , UTILITY_BASE_NAME)

#define @{"Date2Amiga" LINK "gg:doc/NDK/Guide/utility/Date2Amiga"}(date) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x7e, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"Date2Amiga" LINK File 91}, const @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *, date, a0, \\
        , UTILITY_BASE_NAME)

#define @{"CheckDate" LINK "gg:doc/NDK/Guide/utility/CheckDate"}(date) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x84, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CheckDate" LINK File 95}, const @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *, date, a0, \\
        , UTILITY_BASE_NAME)

#define @{"SMult32" LINK "gg:doc/NDK/Guide/utility/SMult32"}(arg1, arg2) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x8a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SMult32" LINK File 99}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg1, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg2, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"UMult32" LINK "gg:doc/NDK/Guide/utility/UMult32"}(arg1, arg2) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x90, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"UMult32" LINK File 103}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, arg1, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, arg2, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"SDivMod32" LINK "gg:doc/NDK/Guide/utility/SDivMod32"}(dividend, divisor) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x96, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SDivMod32" LINK File 107}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, dividend, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, divisor, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"UDivMod32" LINK "gg:doc/NDK/Guide/utility/UDivMod32"}(dividend, divisor) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x9c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"UDivMod32" LINK File 111}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, dividend, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, divisor, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"Stricmp" LINK "gg:doc/NDK/Guide/utility/Stricmp"}(string1, string2) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xa2, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"Stricmp" LINK File 115}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, string1, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, string2, a1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"Strnicmp" LINK "gg:doc/NDK/Guide/utility/Strnicmp"}(string1, string2, length) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xa8, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"Strnicmp" LINK File 119}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, string1, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, string2, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, length, d0, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"ToUpper" LINK "gg:doc/NDK/Guide/utility/ToUpper"}(character) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xae, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"ToUpper" LINK File 123}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, character, d0, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"ToLower" LINK "gg:doc/NDK/Guide/utility/ToLower"}(character) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xb4, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"ToLower" LINK File 127}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, character, d0, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"ApplyTagChanges" LINK "gg:doc/NDK/Guide/utility/ApplyTagChanges"}(list, changeList) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xba, @{"ApplyTagChanges" LINK File 131}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, list, a0, const struct TagItem *, changeList, a1, \\
        , UTILITY_BASE_NAME)

#define @{"SMult64" LINK "gg:doc/NDK/Guide/utility/SMult64"}(arg1, arg2) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xc6, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SMult64" LINK File 135}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg1, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, arg2, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"UMult64" LINK "gg:doc/NDK/Guide/utility/UMult64"}(arg1, arg2) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xcc, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"UMult64" LINK File 139}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, arg1, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, arg2, d1, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#define @{"PackStructureTags" LINK "gg:doc/NDK/Guide/utility/PackStructureTags"}(pack, packTable, tagList) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xd2, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"PackStructureTags" LINK File 143}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, pack, a0, const @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *, packTable, a1, const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a2, \\
        , UTILITY_BASE_NAME)

#define @{"UnpackStructureTags" LINK "gg:doc/NDK/Guide/utility/UnpackStructureTags"}(pack, packTable, tagList) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xd8, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"UnpackStructureTags" LINK File 147}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, pack, a0, const @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *, packTable, a1, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a2, \\
        , UTILITY_BASE_NAME)

#define @{"AddNamedObject" LINK "gg:doc/NDK/Guide/utility/AddNamedObject"}(nameSpace, object) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xde, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AddNamedObject" LINK File 151}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, nameSpace, a0, struct NamedObject *, object, a1, \\
        , UTILITY_BASE_NAME)

#define @{"AllocNamedObjectA" LINK "gg:doc/NDK/Guide/utility/AllocNamedObjectA"}(name, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xe4, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, AllocNamedObjectA, CONST_STRPTR, name, a0, const struct TagItem *, tagList, a1, \\
        , UTILITY_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"AllocNamedObject" LINK "gg:doc/NDK/Guide/utility/AllocNamedObjectA"}(name, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocNamedObjectA" LINK File 155}((name), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"AttemptRemNamedObject" LINK "gg:doc/NDK/Guide/utility/AttemptRemNamedObject"}(object) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xea, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"AttemptRemNamedObject" LINK File 164}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, object, a0, \\
        , UTILITY_BASE_NAME)

#define @{"FindNamedObject" LINK "gg:doc/NDK/Guide/utility/FindNamedObject"}(nameSpace, name, lastObject) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xf0, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, FindNamedObject, struct NamedObject *, nameSpace, a0, CONST_STRPTR, name, a1, struct NamedObject *, lastObject, a2, \\
        , UTILITY_BASE_NAME)

#define @{"FreeNamedObject" LINK "gg:doc/NDK/Guide/utility/FreeNamedObject"}(object) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xf6, @{"FreeNamedObject" LINK File 172}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, object, a0, \\
        , UTILITY_BASE_NAME)

#define @{"NamedObjectName" LINK "gg:doc/NDK/Guide/utility/NamedObjectName"}(object) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xfc, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"NamedObjectName" LINK File 176}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, object, a0, \\
        , UTILITY_BASE_NAME)

#define @{"ReleaseNamedObject" LINK "gg:doc/NDK/Guide/utility/ReleaseNamedObject"}(object) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x102, @{"ReleaseNamedObject" LINK File 180}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, object, a0, \\
        , UTILITY_BASE_NAME)

#define @{"RemNamedObject" LINK "gg:doc/NDK/Guide/utility/RemNamedObject"}(object, message) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x108, @{"RemNamedObject" LINK File 184}, @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *, object, a0, struct Message *, message, a1, \\
        , UTILITY_BASE_NAME)

#define @{"GetUniqueID()" LINK "gg:doc/NDK/Guide/utility/GetUniqueID"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x10e, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetUniqueID" LINK File 188}, \\
        , @{"UTILITY_BASE_NAME" LINK File 32})

#endif /*  _INLINE_UTILITY_H  */
@ENDNODE
