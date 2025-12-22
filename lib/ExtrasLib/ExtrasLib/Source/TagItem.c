#include <clib/extras/utility_protos.h>
#include <extras/macros/utility.h>

#include <exec/memory.h>

#include <proto/exec.h>
#include <proto/utility.h>
#include <utility/tagitem.h>


/****** extras.lib/tag_AllocTags ******************************************
*
*   NAME
*       tag_AllocTags -- Allocate blank Tag List
*
*   SYNOPSIS
*       taglist = tag_AllocTags(TagCount)
*
*       struct TagItem *tag_AllocTags(ULONG);
*
*   FUNCTION
*       Allocate tag space for use with other tag_? functions.
*
*   INPUTS
*       TagCount - Number of blank tags to allocate.
*
*   RESULT
*       An empty tag space ending with TAG_DONE, or NULL.
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


struct TagItem *tag_AllocTags(ULONG TagCount)
{
  struct TagItem *tl;
  
  if(tl=AllocVec(sizeof(struct TagItem)*(TagCount+1),MEMF_PUBLIC))
  {
    tag_ClearNumTags(tl,TagCount);
  }
  return(tl);
}

/****** extras.lib/tag_AddTag ******************************************
*
*   NAME
*       tag_AddTag -- Add a tag toa taglist.
*
*   SYNOPSIS
*       ok = tag_AddTag(TagList, Tag, Data)
*
*       BOOL tag_AddTag(struct TagItem *, ULONG, ULONG);
*
*   FUNCTION
*       Add a tag pair to a taglist created with tag_AllocTags()
*
*   INPUTS
*       TagList - TagList created with tag_AllocTags()
*       Tag - ti_Tag value
*       Data - ti_Data value
*
*   RESULT
*       non zero if the tag was added.
*       failure can be due to under sized taglist.
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   NOTES
*       Don't tag_AddTag TAG_IGNORE, TAG_DONE, TAG_MORE, TAG_SKIP.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*       This function overwrites existing same tags.
*
*   SEE ALSO
*       tag_AllocTags()
*
******************************************************************************
*
*/


BOOL tag_AddTag(struct TagItem *TagList, ULONG Tag, ULONG Data)
{
  struct TagItem *ti;

  if((Tag & 0x80000000) == 0) return(0);

  ti=TagList;
  while(ti->ti_Tag!=TAG_DONE && ti->ti_Tag!=TAG_MORE)
  {
    if(ti->ti_Tag==Tag)
    {
      ti->ti_Tag  =Tag;
      ti->ti_Data =Data;
      return(1);
    }
    ti++;
  }
  
  ti=TagList;
  while(ti->ti_Tag!=TAG_DONE && ti->ti_Tag!=TAG_MORE)
  {
    if(ti->ti_Tag==TAG_IGNORE)
    {
      ti->ti_Tag  =Tag;
      ti->ti_Data =Data;
      return(1);
    }
    ti++;
  }
  return(0);
}

/****** extras.lib/tag_AddTags ******************************************
*
*   NAME
*       tag_AddTags -- Add a taglist to a taglist.
*
*   SYNOPSIS
*       ok = tag_AddTags(TagList, Tag, Data)
*
*       BOOL tag_AddTags(struct TagItem *, ULONG, ULONG);
*
*   FUNCTION
*       Add a taglist to a taglist created with tag_AllocTags()
*
*   INPUTS
*       TagList - TagList created with tag_AllocTags()
*       NewTags - Tags to add to TagList
*
*   RESULT
*       non zero if the tag was added.
*       failure can be due to under sized taglist.
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   NOTES
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*       This function overwrites existing same tags.
*
*   SEE ALSO
*       tag_AllocTags()
*
******************************************************************************
*
*/


BOOL tag_AddTags(struct TagItem *TagList, ULONG Tag, ...)
{
  struct TagItem *taglist, *tag, *tstate;
  BOOL retval;
  
  retval=0;
  
  taglist=(APTR)&Tag;
  
  ProcessTagList(taglist,tag,tstate)
  {
    retval+=tag_AddTag(TagList, tag->ti_Tag, tag->ti_Data);
  }
  
  return(retval);
}

BOOL tag_AddTagList(struct TagItem *TagList, struct TagItem *NewTags)
{
  struct TagItem *tag, *tstate;
  BOOL retval;
  
  retval=0;
  
  ProcessTagList(NewTags,tag,tstate)
  {
    retval+=tag_AddTag(TagList, tag->ti_Tag, tag->ti_Data);
  }
  
  return(retval);
}


/****** extras.lib/tag_RemTag ******************************************
*
*   NAME
*       tag_RemTag -- Removea a tag to a taglist.
*
*   SYNOPSIS
*       ok = tag_RemTag(TagList, Tag)
*
*       BOOL tag_RemTag(struct TagItem *, ULONG);
*
*   FUNCTION
*       Find and remove a tag from a taglist.
*
*   INPUTS
*       TagList - TagList created with tag_AllocTags()
*       Tag - ti_Tag value
*
*   RESULT
*       non zero if the tag was found and removed.
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   NOTES
*       Don't tag_AddTag TAG_IGNORE, TAG_DONE, TAG_MORE, TAG_SKIP.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   SEE ALSO
*       tag_AllocTags()
*
******************************************************************************
*
*/

BOOL tag_RemTag(struct TagItem *TL, ULONG Tag)
{
  struct TagItem *ti;
  
  ti=TL;
  while(ti->ti_Tag!=TAG_DONE && ti->ti_Tag!=TAG_MORE)
  {
    if(ti->ti_Tag==Tag)
    {
      ti->ti_Tag  =TAG_IGNORE;
      return(1);
    }
    ti++;
  }
  
  return(0); 
}

/****** extras.lib/tag_ClearNumTags ******************************************
*
*   NAME
*       tag_ClearTags -- Clear a TagList
*
*   SYNOPSIS
*       void tag_ClearTags(TagList, TagCount)
*
*       tag_ClearTags(struct TagItem *, ULONG);
*
*   FUNCTION
*       Clears the TagList of all data.
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags()
*       TagCount - Number of blank tags to allocate.
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   NOTES
*       This function is called by tag_AllocTags(), so
*       the taglist is cleared when allocated.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   BUGS
*
*   SEE ALSO
*       see tag_AllocTags()
*
******************************************************************************
*
*/

void tag_ClearNumTags(struct TagItem *TL, ULONG TagCount)
{
  ULONG l;
  
  for(l=0;l<(TagCount);l++)
  {
    TL[l].ti_Tag=TAG_IGNORE;
  }
  TL[l].ti_Tag=TAG_DONE;
}

/****** extras.lib/tag_ClearTags ******************************************
*
*   NAME
*       tag_ClearTags -- Clear a TagList
*
*   SYNOPSIS
*       void tag_ClearTags(TagList)
*
*       tag_ClearTags(struct TagItem *);
*
*   FUNCTION
*       Clears the TagList of all data.
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags()
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   NOTES
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   BUGS
*
*   SEE ALSO
*       see tag_AllocTags()
*
******************************************************************************
*
*/


void tag_ClearTags(struct TagItem *TL)
{
  struct TagItem *ti;
  
  ti=TL;
  while(ti->ti_Tag!=TAG_DONE && ti->ti_Tag!=TAG_MORE)
  {
    ti->ti_Tag=TAG_IGNORE;
    ti++;
  }
}

/****** extras.lib/tag_FreeTags ******************************************
*
*   NAME
*       tag_FreeTags -- Clear a TagList
*
*   SYNOPSIS
*       void tag_FreeTags(TagList)
*
*       tag_FreeTags(struct TagItem *);
*
*   FUNCTION
*       Frees the TagList.
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags().
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   SEE ALSO
*       see tag_AllocTags()
*
******************************************************************************
*
*/

void tag_FreeTags(struct TagItem *TL)
{
  FreeVec(TL);
}

/****** extras.lib/tag_TagMore ******************************************
*
*   NAME
*       tag_TagMore -- End the TagList with TagMore
*
*   SYNOPSIS
*       void tag_FreeTags(TagList, MoreTags)
*
*       tag_FreeTags(struct TagItem *, struct TagItem *);
*
*   FUNCTION
*       Ends the taglist with TAG_MORE and link the list to MoreTags
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags().
*       MoreTags - Tags to link
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   SEE ALSO
*       see tag_AllocTags()
*
******************************************************************************
*
*/


BOOL tag_TagMore(struct TagItem *TagList, struct TagItem *More)
{
  struct TagItem *ti;

  ti=TagList;
  while((ti->ti_Tag!=TAG_DONE) && (ti->ti_Tag!=TAG_MORE))
  {
    ti++;
  }
  
  ti->ti_Tag=TAG_MORE;
  ti->ti_Data=(ULONG)More;
  
  return(0);
}


/****** extras.lib/tag_TagDone ******************************************
*
*   NAME
*       tag_TagDone -- End the TagList with TagDone
*
*   SYNOPSIS
*       void tag_FreeTags(TagList)
*
*       tag_FreeTags(struct TagItem *);
*
*   FUNCTION
*       Ends the taglist with TAG_MORE and link the list to MoreTags
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags().
*
*   EXAMPLE
*       see tag_AllocTags()
*
*   SEE ALSO
*       see tag_AllocTags()
*
******************************************************************************
*
*/


BOOL tag_TagDone(struct TagItem *TagList)
{
  struct TagItem *ti;

  ti=TagList;
  while((ti->ti_Tag!=TAG_DONE) && (ti->ti_Tag!=TAG_MORE))
  {
    ti++;
  }
  ti->ti_Tag=TAG_DONE;
  
  return(0);
}

/****** extras.lib/tag_CountUserTags ******************************************
*
*   NAME
*       tag_CountUserTags -- number of user tags
*
*   SYNOPSIS
*       ULONG tag_CountUserTags(TagList)
*
*       tag_CountUserTags(struct TagItem *);
*
*   FUNCTION
*       Count the number of user tags.
*
*   INPUTS
*       TagList - Allocated with tag_AllocTags().
*
******************************************************************************
*
*/


ULONG tag_CountUserTags(struct TagItem *TagList)
{
  struct TagItem *tag,*tstate;
  ULONG retval=0;

  ProcessTagList(TagList,tag,tstate)
  {
    retval++;
  }
  
  return(retval);
}

/****** extras.lib/ProcessTagList ******************************************
*
*   NAME
*       ProcessTagList -- Macro to process a taglist
*
*   SYNOPSIS
*       ProcessTagList(TagList, Tag, TState)
*
*       TState=TagList; 
*       while(Tag=NextTagItem(&TState))
*
*   EXAMPLE
*       void SomeFunc(struct TagItem *TagList)
*       {
*         struct TagItem *tag, *tstate;
*
*         ProcessTagList(TagList,tag,tstate)
*         {
*           seitch(tag->ti_Tag)
*           {
*             case GA_Left:
*               ...
*               break;
*             etc...
*           }
*         }
*       }
*
******************************************************************************
*
*/

