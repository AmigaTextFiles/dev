/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/AttrList.cxx,v $
 **   $Revision: 1.14 $
 **   $Date: 1994/07/31 13:13:31 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

extern "C"
{
#include <stdlib.h>
}
#include <APlusPlus/utility/AttrList.h>
//#include <APlusPlus/utility/Taglist.h>


static const char rcs_id[] = "$Id: AttrList.cxx,v 1.14 1994/07/31 13:13:31 Armin_Vogt Exp Armin_Vogt $";


AttrList::AttrList(TagList tl)
{
   taglist = tl!=NULL?cloneTagItems(tl):NULL;
}

AttrList::AttrList(LONG tag1Type,...)
{
   taglist = cloneTagItems((TagList)&tag1Type);
}

AttrList::AttrList(const AttrList& from)
{
   taglist = from.taglist!=NULL?cloneTagItems(from.taglist):NULL;
}

void AttrList::freeTagItems(TagList tlist)
{
   free(tlist);
}

AttrList::~AttrList()
{
   freeTagItems(taglist);
}

AttrList& AttrList::operator=(const AttrList& from) // assignment is copying
{
   if (this != &from)
   {
      freeTagItems(taglist);
      taglist = from.taglist!=NULL?cloneTagItems(from.taglist):NULL;
   }
   return *this;
}

BOOL AttrList::addAttrs(AttrList& attrs)
   /* Enhance the attribute taglist with additional tags from the given
      taglist in a way so that not already present tags will be added,
      while already present remain untouched.
      The new tags will be added at the head of the attribute taglist
      with their respective values.
      Already present tags are deleted in 'attrs' (set to TAG_IGNORE).
      If 'attrs' contained no new tags nothing will happen.
   */
{
   /** Set tags in the modifying taglist that are already present in the 
    ** attribute taglist to TAG_IGNORE. The remaining tags are added to the 
    ** attribute taglist with their values.
    **/
    
   //puts("AttrList::addAttrs("); attrs.print(); puts(")\n");
   
   if (taglist==NULL)
   {
      taglist = cloneTagItems(attrs);
      _dprintf("addAttrs to null list.\n");
      return TRUE;
   }  // for an empty AttrList only copy additional tags to this.

   // Check if there are any new tags..
   // Set those which are already present in 'this' in 'attrs' to TAG_IGNORE.
   // The number of tags that were not set to TAG_IGNORE is returned.
   if (FilterTagItems(attrs.taglist,(Tag*)taglist,TAGFILTER_NOT)>0)
   {
      // get the end of the taglist
      TagList tag = attrs.taglist;
      while (tag->ti_Tag != TAG_END)
         tag++;

      // concatenate additional taglist to attribute taglist
      tag->ti_Tag = TAG_MORE;
      tag->ti_Data = (ULONG)taglist;

      // copy concatenated taglist to a private memory (removes TAG_MORE)
      TagList newTL;
      if (NULL != (newTL = cloneTagItems(attrs.taglist)) )
      {
         // free old private attribute taglist copy
         freeTagItems(taglist);

         taglist = newTL;  // set to new concatenated attribute taglist.
         //puts("added. result is "); print(); puts("\n");
         return TRUE;
      }
      else puterr("OUT_OF_MEMORY");
   }
   else _dprintf("no additional tags found\n");

   return FALSE;
}

BOOL AttrList::updateAttrs(const AttrList& attrlist)
   /* updates the tag data in 'this' of tags present in both 'this'
      and 'attrlist' with the corresponding tag data in attrlist.
      Returns TRUE if any tags adopted new values.
   */
{
   BOOL changed = FALSE;   // any changes done
   AttrManipulator next(*this);
   AttrIterator read(attrlist);

   _dprintf("IntuiObject::writeTags : ");
   while (read())
   {
      if (next.findTagItem(read.tag()) )
      {
         if (read.data() != next.data())
         {
            next.writeData(read.data());
            changed = TRUE;
         }
      }
   }
   if (!changed)
   {
      _dprintf(" no changes.\n");
   }
   else
   {
      _dprintf("\n");
   }
   return changed;
}

ULONG AttrList::mapAttrs(const AttrList& mapAt)
   /* Maps taglist according to mapAt. All tags that are not appearing
      in the mapAt list are being deleted (set to TAG_IGNORE). Still remaining
      valid tags will be mapped to the new tag identifiers in the mapAt list.
   */
{
   MapTags(taglist,mapAt.taglist,FALSE);
   // include miss is FALSE, so unmatched tags are being deleted.
   // ERROR: MapTags() does NOT remove unmatched tags!!!!
   // Bug fix: use subsequent FilterTagItems().
   return filterAttrs(mapAt);
   //return 1L;
}
ULONG AttrList::mapAttrs(TagList mapList)
{
   MapTags(taglist,mapList,FALSE);
   return filterAttrs(mapList);
}

ULONG AttrList::filterAttrs(const AttrList& filterAt, int filter)
   /* Filters taglist according to FilterTagItems logic: 
      TAGFILER_AND : Preserve only those tags in 'this' list that are also
         present in the 'filterAt' list.
      TAGFILTER_NOT : Remove all tags from 'this' list that are not within
         the 'filterAt' list (set to TAG_IGNORE).
      The number of tags that are not set to TAG_IGNORE is returned.
   */
{
   return FilterTagItems(taglist,(Tag*)filterAt.taglist,(ULONG)filter);
}

ULONG AttrList::filterAttrs(TagList filterList)
{
   return FilterTagItems(taglist,(Tag*)filterList,TAGFILTER_AND);

}

TagList AttrList::cloneTagItems(TagList source)
   /* This method is a replacement for the Utility/CloneTagItems() function.
      It has the advantage to allocate memory with malloc() which is
      faster than AllocMem() and causes less memory fragmentation.
   */
{
   TagList oldTaglist = taglist;    // preserve 'this' taglist
   {
      taglist = source;                // and store the taglist to copy
      AttrIterator next(*this);        // so we can use an AttrIterator
      int tCount = 0;

      // run the taglist that is to be cloned and count the tag items
      while ( next() ) tCount++;
      tCount++;   // reserve one TagItem for the TAG_END

      // allocate memory for the counted number of tag items
      if (NULL != (source = (TagList)malloc(tCount*sizeof(struct TagItem)) ) )
      {
         TagList tl = source;

         next.reset();
         while ( next() )
         { tl->ti_Tag = next.tag(); tl->ti_Data = next.data(); tl++;}

         tl->ti_Tag = tl->ti_Data = TAG_END;
      }
   }
   taglist = oldTaglist;   // restore the taglist in 'this'
   return source;
}

//------------------- AttrIterator methods -------------------------------------
AttrIterator::AttrIterator(const AttrList& alist)
   : al(&alist), atTag(alist.taglist), tstate(alist.taglist)
{
}

BOOL AttrIterator::findTagItem(Tag tagVal)
{
   /** This method assumes that NextTagItem() keeps track of the scanned taglist with
    ** the 'tstate' pointer referencing to the next tag item to be fetched with NextTagItem().
    ** Since NextTagItem() does not return TAG_MORE ,TAG_SKIP and TAG_END the found tag item
    ** must be a user tag thus the following tag item is at the successing (TagItem*) address.
    **/
   if (NULL != (atTag = FindTagItem(tagVal,tstate)))
   {
      tstate = atTag+1; // set NextTagItem() internal track to next tag item
      return TRUE;
   }
   else return FALSE;
}

AttrManipulator::AttrManipulator(AttrList& calist)
   : AttrIterator((const AttrList&)calist)
{
}

void AttrList::print()
{
   //printTaglist(taglist);
}