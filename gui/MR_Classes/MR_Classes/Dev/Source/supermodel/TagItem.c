#include "protos.h"
#include <extras/macros/utility.h>

#include <exec/memory.h>

#include <proto/exec.h>
#include <proto/utility.h>
#include <utility/tagitem.h>


/****** supermodel.class/SMTAG_AllocTags ******************************************
*
*   NAME
*       SMTAG_AllocTags -- Allocate blank Tag List
*
*   SYNOPSIS
*       taglist = SMTAG_AllocTags(TagCount)
*
*       struct TagItem *SMTAG_AllocTags(ULONG);
*
*   FUNCTION
*       Allocate tag space for use with other SMTAG_? functions.
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


__asm struct TagItem *LIB_SMTAG_AllocTags(register __d0 ULONG TagCount)
{
  struct TagItem *tl;
  
  if(tl=AllocVec(sizeof(struct TagItem)*(TagCount+1),MEMF_PUBLIC))
  {
    SMTAG_ClearNumTags(tl,TagCount);
  }
  return(tl);
}

/****** supermodel.class/SMTAG_AddTag ******************************************
*
*   NAME
*       SMTAG_AddTag -- Add a tag toa taglist.
*
*   SYNOPSIS
*       ok = SMTAG_AddTag(TagList, Tag, Data)
*
*       BOOL SMTAG_AddTag(struct TagItem *, ULONG, ULONG);
*
*   FUNCTION
*       Add a tag pair to a taglist created with SMTAG_AllocTags()
*
*   INPUTS
*       TagList - TagList created with SMTAG_AllocTags()
*       Tag - ti_Tag value
*       Data - ti_Data value
*
*   RESULT
*       non zero if the tag was added.
*       failure can be due to under sized taglist.
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   NOTES
*       Don't SMTAG_AddTag TAG_IGNORE, TAG_DONE, TAG_MORE, TAG_SKIP.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*       This function overwrites existing same tags.
*
*   SEE ALSO
*       SMTAG_AllocTags()
*
******************************************************************************
*
*/


__asm BOOL LIB_SMTAG_AddTag(register __a0 struct TagItem *TagList,register __d0 ULONG Tag,register __d1  ULONG Data)
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

/****** supermodel.class/SMTAG_AddTags ******************************************
*
*   NAME
*       SMTAG_AddTags -- Add a taglist to a taglist.
*
*   SYNOPSIS
*       ok = SMTAG_AddTags(TagList, Tag, Data)
*
*       BOOL SMTAG_AddTags(struct TagItem *, ULONG, ULONG);
*
*   FUNCTION
*       Add a taglist to a taglist created with SMTAG_AllocTags()
*
*   INPUTS
*       TagList - TagList created with SMTAG_AllocTags()
*       NewTags - Tags to add to TagList
*
*   RESULT
*       non zero if the tag was added.
*       failure can be due to under sized taglist.
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   NOTES
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*       This function overwrites existing same tags.
*
*   SEE ALSO
*       SMTAG_AllocTags()
*
******************************************************************************
*
*/

__asm BOOL LIB_SMTAG_AddTagsA(register __a0 struct TagItem *TagList, register __a1 struct TagItem *NewTags)
{
  struct TagItem *tag, *tstate;
  BOOL retval;
  
  retval=0;
  
  ProcessTagList(NewTags,tag,tstate)
  {
    retval+=SMTAG_AddTag(TagList, tag->ti_Tag, tag->ti_Data);
  }
  
  return(retval);
}


/****** supermodel.class/SMTAG_RemTag ******************************************
*
*   NAME
*       SMTAG_RemTag -- Removea a tag to a taglist.
*
*   SYNOPSIS
*       ok = SMTAG_RemTag(TagList, Tag)
*
*       BOOL SMTAG_RemTag(struct TagItem *, ULONG);
*
*   FUNCTION
*       Find and remove a tag from a taglist.
*
*   INPUTS
*       TagList - TagList created with SMTAG_AllocTags()
*       Tag - ti_Tag value
*
*   RESULT
*       non zero if the tag was found and removed.
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   NOTES
*       Don't SMTAG_AddTag TAG_IGNORE, TAG_DONE, TAG_MORE, TAG_SKIP.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   SEE ALSO
*       SMTAG_AllocTags()
*
******************************************************************************
*
*/

__asm BOOL LIB_SMTAG_RemTag(register __a0 struct TagItem *TL, register __d0 ULONG Tag)
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

/****** supermodel.class/SMTAG_ClearNumTags ******************************************
*
*   NAME
*       SMTAG_ClearTags -- Clear a TagList
*
*   SYNOPSIS
*       void SMTAG_ClearTags(TagList, TagCount)
*
*       SMTAG_ClearTags(struct TagItem *, ULONG);
*
*   FUNCTION
*       Clears the TagList of all data.
*
*   INPUTS
*       TagList - Allocated with SMTAG_AllocTags()
*       TagCount - Number of blank tags to allocate.
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   NOTES
*       This function is called by SMTAG_AllocTags(), so
*       the taglist is cleared when allocated.
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   BUGS
*
*   SEE ALSO
*       see SMTAG_AllocTags()
*
******************************************************************************
*
*/

__asm void LIB_SMTAG_ClearNumTags(register __a0 struct TagItem *TL,register __d0  ULONG TagCount)
{
  ULONG l;
  
  for(l=0;l<(TagCount);l++)
  {
    TL[l].ti_Tag=TAG_IGNORE;
  }
  TL[l].ti_Tag=TAG_DONE;
}

/****** supermodel.class/SMTAG_ClearTags ******************************************
*
*   NAME
*       SMTAG_ClearTags -- Clear a TagList
*
*   SYNOPSIS
*       void SMTAG_ClearTags(TagList)
*
*       SMTAG_ClearTags(struct TagItem *);
*
*   FUNCTION
*       Clears the TagList of all data.
*
*   INPUTS
*       TagList - Allocated with SMTAG_AllocTags()
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   NOTES
*       This function will only effect the specified TagList, and 
*       not any other lists referenced by TAG_MORE.
*
*   BUGS
*
*   SEE ALSO
*       see SMTAG_AllocTags()
*
******************************************************************************
*
*/


__asm void LIB_SMTAG_ClearTags(register __a0 struct TagItem *TL)
{
  struct TagItem *ti;
  
  ti=TL;
  while(ti->ti_Tag!=TAG_DONE && ti->ti_Tag!=TAG_MORE)
  {
    ti->ti_Tag=TAG_IGNORE;
    ti++;
  }
}

/****** supermodel.class/SMTAG_FreeTags ******************************************
*
*   NAME
*       SMTAG_FreeTags -- Clear a TagList
*
*   SYNOPSIS
*       void SMTAG_FreeTags(TagList)
*
*       SMTAG_FreeTags(struct TagItem *);
*
*   FUNCTION
*       Frees the TagList.
*
*   INPUTS
*       TagList - Allocated with SMTAG_AllocTags().
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   SEE ALSO
*       see SMTAG_AllocTags()
*
******************************************************************************
*
*/

__asm void LIB_SMTAG_FreeTags(register __a0 struct TagItem *TL)
{
  FreeVec(TL);
}

/****** supermodel.class/SMTAG_TagMore ******************************************
*
*   NAME
*       SMTAG_TagMore -- End the TagList with TagMore
*
*   SYNOPSIS
*       void SMTAG_FreeTags(TagList, MoreTags)
*
*       SMTAG_FreeTags(struct TagItem *, struct TagItem *);
*
*   FUNCTION
*       Ends the taglist with TAG_MORE and link the list to MoreTags
*
*   INPUTS
*       TagList - Allocated with SMTAG_AllocTags().
*       MoreTags - Tags to link
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   SEE ALSO
*       see SMTAG_AllocTags()
*
******************************************************************************
*
*/


__asm BOOL LIB_SMTAG_TagMore(register __a0 struct TagItem *TagList,register __a1  struct TagItem *More)
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


/****** supermodel.class/SMTAG_TagDone ******************************************
*
*   NAME
*       SMTAG_TagDone -- End the TagList with TagDone
*
*   SYNOPSIS
*       void SMTAG_FreeTags(TagList)
*
*       SMTAG_FreeTags(struct TagItem *);
*
*   FUNCTION
*       Ends the taglist with TAG_MORE and link the list to MoreTags
*
*   INPUTS
*       TagList - Allocated with SMTAG_AllocTags().
*
*   EXAMPLE
*       see SMTAG_AllocTags()
*
*   SEE ALSO
*       see SMTAG_AllocTags()
*
******************************************************************************
*
*/


__asm BOOL LIB_SMTAG_TagDone(register __a0 struct TagItem *TagList)
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

/****** supermodel.class/ProcessTagList ******************************************
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
