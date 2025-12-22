@DATABASE "gg:doc/NDK/Guide/Include/utility/tagitem.h"
@MASTER   "gg:os-include/utility/tagitem.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:35
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/tagitem.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/tagitem.h" LINK File}


@{b}Structures@{ub}

@{"TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}


@{b}Typedefs@{ub}

@{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}


@{b}#defines@{ub}

@{"MAP_KEEP_NOT_FOUND" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 71}  @{"MAP_REMOVE_NOT_FOUND" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 70}  @{"TAG_DONE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 39}  @{"TAG_END" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 40}
@{"TAG_IGNORE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 41}          @{"TAG_MORE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 42}              @{"TAG_SKIP" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 45}  @{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}
@{"TAGFILTER_AND" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 62}       @{"TAGFILTER_NOT" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 63}         

@ENDNODE
@NODE File "utility/tagitem.h"
#ifndef UTILITY_TAGITEM_H
#define UTILITY_TAGITEM_H
/*
**      $VER: tagitem.h 40.1 (19.7.1993)
**      Includes Release 45.1
**
**      Extended specification mechanism
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif


/*****************************************************************************/


/* Tags are a general mechanism of extensible data arrays for parameter
 * specification and property inquiry. In practice, tags are used in arrays,
 * or chain of arrays.
 *
 */

typedef @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} Tag;

struct TagItem
{
    @{"Tag" LINK File 30}   ti_Tag;       /* identifies the type of data */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ti_Data;      /* type-specific data          */
};

/* constants for Tag.ti_Tag, control tag values */
#define TAG_DONE   (0L)   /* terminates array of TagItems. ti_Data unused */
#define TAG_END    (0L)   /* synonym for @{"TAG_DONE" LINK File 39}                         */
#define TAG_IGNORE (1L)   /* ignore this item, not end of array           */
#define TAG_MORE   (2L)   /* ti_Data is pointer to another array of TagItems
                           * note that this tag terminates the current array
                           */
#define TAG_SKIP   (3L)   /* skip this and the next ti_Data items         */

/* differentiates user tags from control tags */
#define TAG_USER   ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})(1L<<31))

/* If the @{"TAG_USER" LINK File 48} bit is set in a tag number, it tells @{"utility.library" LINK "gg:doc/NDK/Guide/utility/MAIN"} that
 * the tag is not a control tag (like @{"TAG_DONE" LINK File 39}, @{"TAG_IGNORE" LINK File 41}, @{"TAG_MORE" LINK File 42}) and is
 * instead an application tag. "USER" means a client of @{"utility.library" LINK "gg:doc/NDK/Guide/utility/MAIN"} in
 * general, including system code like Intuition or ASL, it has nothing to do
 * with user code.
 */


/*****************************************************************************/


/* Tag filter logic specifiers for use with @{"FilterTagItems()" LINK "gg:doc/NDK/Guide/utility/FilterTagItems"} */
#define TAGFILTER_AND 0         /* exclude everything but filter hits   */
#define TAGFILTER_NOT 1         /* exclude only filter hits             */


/*****************************************************************************/


/* Mapping types for use with @{"MapTags()" LINK "gg:doc/NDK/Guide/utility/MapTags"} */
#define MAP_REMOVE_NOT_FOUND 0  /* remove tags that aren't in mapList */
#define MAP_KEEP_NOT_FOUND   1  /* keep tags that aren't in mapList   */


/*****************************************************************************/


#endif /* UTILITY_TAGITEM_H */
@ENDNODE
