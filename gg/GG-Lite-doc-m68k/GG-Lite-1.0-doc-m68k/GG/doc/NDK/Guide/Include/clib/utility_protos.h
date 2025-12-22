@DATABASE "gg:doc/NDK/Guide/Include/clib/utility_protos.h"
@MASTER   "gg:os-include/clib/utility_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/utility_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/utility_protos.h" LINK File}

@ENDNODE
@NODE File "clib/utility_protos.h"
#ifndef  CLIB_UTILITY_PROTOS_H
#define  CLIB_UTILITY_PROTOS_H

/*
**      $VER: utility_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

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
/*--- functions in V36 or higher (Release 2.0) ---*/

/* Tag item functions */

@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *FindTagItem( Tag tagVal, CONST struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetTagData" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 39}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tagValue, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} defaultVal, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"PackBoolTags" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 43}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} initialFlags, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList, CONST struct TagItem *boolMap );
@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *NextTagItem( struct TagItem **tagListPtr );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FilterTagChanges" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 51}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *changeList, struct TagItem *originalList, ULONG apply );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MapTags" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 55}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList, CONST struct TagItem *mapList, ULONG mapType );
@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *AllocateTagItems( ULONG numTags );
@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *CloneTagItems( CONST struct TagItem *tagList );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeTagItems" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 67}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RefreshTagItemClones" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 71}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *clone, CONST struct TagItem *original );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"TagInArray" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 75}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tagValue, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} *tagArray );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"FilterTagItems" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 79}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList, CONST Tag *filterArray, ULONG logic );

/* Hook functions */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CallHookPkt" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 83}( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, APTR object, APTR paramPacket );

/* Date functions */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Amiga2Date" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 87}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} seconds, @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *result );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"Date2Amiga" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 91}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *date );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CheckDate" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 95}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24} *date );

/* 32 bit integer muliply functions */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SMult32" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 99}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg2 );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"UMult32" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 103}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} arg1, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} arg2 );

/* 32 bit integer division funtions. The quotient and the remainder are */
/* returned respectively in d0 and d1 */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SDivMod32" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 107}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dividend, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} divisor );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"UDivMod32" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 111}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dividend, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} divisor );
/*--- functions in V37 or higher (Release 2.04) ---*/

/* International string routines */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Stricmp" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 115}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string1, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string2 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Strnicmp" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 119}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string1, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string2, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} length );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"ToUpper" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 123}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} character );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"ToLower" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 127}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} character );
/*--- functions in V39 or higher (Release 3) ---*/

/* More tag Item functions */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ApplyTagChanges" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 131}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *list, CONST struct TagItem *changeList );

/* 64 bit integer muliply functions. The results are 64 bit quantities */
/* returned in D0 and D1 */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SMult64" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 135}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg2 );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"UMult64" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 139}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} arg1, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} arg2 );

/* Structure to Tag and Tag to Structure support routines */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"PackStructureTags" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 143}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pack, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *packTable, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"UnpackStructureTags" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 147}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} pack, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *packTable, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );

/* New, object-oriented NameSpaces */

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddNamedObject" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 151}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *nameSpace, struct NamedObject *object );
@{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *AllocNamedObjectA( CONST_STRPTR name, CONST struct TagItem *tagList );
@{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *AllocNamedObject( CONST_STRPTR name, Tag tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AttemptRemNamedObject" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 164}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *object );
@{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *FindNamedObject( struct NamedObject *nameSpace, CONST_STRPTR name, struct NamedObject *lastObject );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeNamedObject" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 172}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *object );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"NamedObjectName" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 176}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *object );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseNamedObject" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 180}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *object );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemNamedObject" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 184}( @{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25} *object, struct Message *message );

/* Unique ID generator */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetUniqueID" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File" 188}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_UTILITY_PROTOS_H */
@ENDNODE
