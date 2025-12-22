/* $Id: tagitem.h 28320 2008-04-15 20:16:32Z schulz $ */
OPT NATIVE
MODULE 'target/exec/types' /*, 'target/stdarg'*/
{#include <utility/tagitem.h>}
NATIVE {UTILITY_TAGITEM_H} CONST

TYPE TAG IS NATIVE {Tag} ULONG


NATIVE {Tag} CONST

NATIVE {TagItem} OBJECT tagitem
    {ti_Tag}	tag	:TAG  /* What is this ? */
    {ti_Data}	data	:STACKIPTR /* Tag-specific data */
ENDOBJECT

/* constants for Tag.ti_Tag, control tag values */
NATIVE {TAG_DONE}   CONST TAG_DONE   = (0)   /* terminates array of TagItems. ti_Data unused */
NATIVE {TAG_END}    CONST TAG_END    = (0)   /* synonym for TAG_DONE                         */
NATIVE {TAG_IGNORE} CONST TAG_IGNORE = (1)   /* ignore this item, not end of array           */
NATIVE {TAG_MORE}   CONST TAG_MORE   = (2)   /* ti_Data is pointer to another array of TagItems
			     note that this tag terminates the current array */
NATIVE {TAG_SKIP}   CONST TAG_SKIP   = (3)   /* skip this and the next ti_Data items         */

/* What separates user tags from system tags */
NATIVE {TAG_USER}    CONST TAG_USER    = $80000000
NATIVE {TAG_OS}	    CONST TAG_OS	    = (16)   /* The first tag used by the OS */

/* Tag-Offsets for the OS */
NATIVE {DOS_TAGBASE}	    CONST DOS_TAGBASE	    = (TAG_OS)        /* Reserve 16k tags for DOS */
NATIVE {INTUITION_TAGBASE}   CONST INTUITION_TAGBASE   = (TAG_OS OR $2000) /* Reserve 16k tags for Intuition */

/* Tag filter for FilterTagItems() */
NATIVE {TAGFILTER_AND} CONST TAGFILTER_AND = 0 	/* exclude everything but filter hits	*/
NATIVE {TAGFILTER_NOT} CONST TAGFILTER_NOT = 1 	/* exclude only filter hits		*/

/* Mapping types for MapTags() */
NATIVE {MAP_REMOVE_NOT_FOUND} CONST MAP_REMOVE_NOT_FOUND = 0	/* remove tags that aren't in mapList */
NATIVE {MAP_KEEP_NOT_FOUND}   CONST MAP_KEEP_NOT_FOUND   = 1	/* keep tags that aren't in mapList   */

/* Macro for syntactic sugar (and a little extra bug-resiliance) */
NATIVE {TAGLIST} CONST	->TAGLIST(args...) ((struct TagItem *)(IPTR []){ args, TAG_DONE })

/*
    Some macros to make it easier to write functions which operate on
    stacktags on every CPU/compiler/hardware.
*/
   NATIVE {AROS_TAGRETURNTYPE} CONST ->AROS_TAGRETURNTYPE = IPTR

	NATIVE {AROS_SLOWSTACKTAGS_PRE} CONST	->AROS_SLOWSTACKTAGS_PRE(arg) AROS_TAGRETURNTYPE retval;
	NATIVE {AROS_SLOWSTACKTAGS_ARG} CONST	->AROS_SLOWSTACKTAGS_ARG(arg) ((struct TagItem *)&(arg))
	NATIVE {AROS_SLOWSTACKTAGS_POST}     CONST ->AROS_SLOWSTACKTAGS_POST     = return retval;
