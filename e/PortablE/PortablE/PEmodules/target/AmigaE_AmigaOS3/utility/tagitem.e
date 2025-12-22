/* $VER: tagitem.h 40.1 (19.7.1993) */
OPT NATIVE
MODULE 'target/exec/types'
{MODULE 'utility/tagitem'}

TYPE TAG IS ULONG


NATIVE {tagitem} OBJECT tagitem
    {tag}	tag	:TAG	/* identifies the type of data */
    {data}	data	:ULONG	/* type-specific data	       */
ENDOBJECT

/* constants for Tag.ti_Tag, control tag values */
NATIVE {TAG_DONE}   CONST TAG_DONE   = 0	  /* terminates array of TagItems. ti_Data unused */
NATIVE {TAG_END}	   CONST TAG_END	   = 0   /* synonym for TAG_DONE			  */
NATIVE {TAG_IGNORE} CONST TAG_IGNORE = 1	  /* ignore this item, not end of array		  */
NATIVE {TAG_MORE}   CONST TAG_MORE   = 2	  /* ti_Data is pointer to another array of TagItems
			   * note that this tag terminates the current array
			   */
NATIVE {TAG_SKIP}   CONST TAG_SKIP   = 3	  /* skip this and the next ti_Data items	  */

/* differentiates user tags from control tags */
NATIVE {TAG_USER}   CONST TAG_USER   = $80000000

/*****************************************************************************/


/* Tag filter logic specifiers for use with FilterTagItems() */
NATIVE {TAGFILTER_AND} CONST TAGFILTER_AND = 0		/* exclude everything but filter hits	*/
NATIVE {TAGFILTER_NOT} CONST TAGFILTER_NOT = 1		/* exclude only filter hits		*/


/*****************************************************************************/


/* Mapping types for use with MapTags() */
NATIVE {MAP_REMOVE_NOT_FOUND} CONST MAP_REMOVE_NOT_FOUND = 0	/* remove tags that aren't in mapList */
NATIVE {MAP_KEEP_NOT_FOUND}   CONST MAP_KEEP_NOT_FOUND   = 1	/* keep tags that aren't in mapList   */
