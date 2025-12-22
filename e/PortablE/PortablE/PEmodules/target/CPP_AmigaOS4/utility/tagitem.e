/* $Id: tagitem.h,v 1.12 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/tagitem.h>}
NATIVE {UTILITY_TAGITEM_H} CONST

TYPE TAG IS NATIVE {Tag} ULONG


/* Tags are a general mechanism of extensible data arrays for parameter
 * specification and property inquiry. In practice, tags are used in arrays,
 * or chain of arrays.
 *
 */
NATIVE {Tag} CONST

NATIVE {TagItem} OBJECT tagitem
    {ti_Tag}	tag	:TAG  /* identifies the type of data */
    {ti_Data}	data	:ULONG /* type-specific data          */
ENDOBJECT

/* constants for Tag.ti_Tag, control tag values */
NATIVE {TAG_DONE}   CONST TAG_DONE   = (0) /* terminates array of TagItems. ti_Data unused */
NATIVE {TAG_END}    CONST TAG_END    = (0) /* synonym for TAG_DONE */
NATIVE {TAG_IGNORE} CONST TAG_IGNORE = (1) /* ignore this item, not end of array */
NATIVE {TAG_MORE}   CONST TAG_MORE   = (2) /* ti_Data is pointer to another array of TagItems
                            note that this tag terminates the current array */
NATIVE {TAG_SKIP}   CONST TAG_SKIP   = (3) /* skip this and the next ti_Data items */

/* differentiates user tags from control tags */
NATIVE {TAG_USER}   CONST TAG_USER   = $80000000

/* If the TAG_USER bit is set in a tag number, it tells exex.library that
 * the tag is not a control tag (like TAG_DONE, TAG_IGNORE, TAG_MORE) and is
 * instead an application tag. "USER" means a client of exec.library in
 * general, including system code like Intuition or ASL, it has nothing to do
 * with user code.
 */

/*****************************************************************************/

/* Tag filter logic specifiers for use with FilterTagItems() */
NATIVE {enTagLogic} DEF
NATIVE {TAGFILTER_AND} CONST TAGFILTER_AND = 0 /* exclude everything but filter hits */
NATIVE {TAGFILTER_NOT} CONST TAGFILTER_NOT = 1  /* exclude only filter hits           */


/*****************************************************************************/

/* Mapping types for use with MapTags() */
NATIVE {enTagMap} DEF
NATIVE {MAP_REMOVE_NOT_FOUND} CONST MAP_REMOVE_NOT_FOUND = 0 /* remove tags that aren't in mapList */
NATIVE {MAP_KEEP_NOT_FOUND}   CONST MAP_KEEP_NOT_FOUND   = 1  /* keep tags that aren't in mapList   */
