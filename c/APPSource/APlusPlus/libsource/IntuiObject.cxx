/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/IntuiObject.cxx,v $
 **   $Revision: 1.11 $
 **   $Date: 1994/07/27 11:49:20 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/intuition/IntuiObject.h>
#include <APlusPlus/intuition/IntuiRoot.h>
#include <APlusPlus/intuition/ITransponder.h>


/*------------------------- Constraints methods ------------------------------*/

static const char rcs_id[] = "$Id: IntuiObject.cxx,v 1.11 1994/07/27 11:49:20 Armin_Vogt Exp Armin_Vogt $";

// runtime type inquiry support
intui_typeinfo(IntuiObject, no_bases, rcs_id)


LONG IntuiObject::newConstraint(Tag onChangedTag,IntuiObject* noticeThis,Tag mapToTag)
{
   MapArray* dTable;
   if (NULL==(dTable=(MapArray*)cTable.find(onChangedTag)))
      cTable[onChangedTag] = dTable = new MapArray;

   (*dTable)[mapToTag] = noticeThis;
   ULONG dataStore;
   return getAttribute(onChangedTag,dataStore);
}

void IntuiObject::releaseObject(IntuiObject* obj)
{
}

void IntuiObject::changedAttrs(AttrList& attrs)
{
   AttrIterator tags(attrs);
   while (tags())
   {
      MapArray* dTable;
      if (NULL!=(dTable=(MapArray*)cTable.find(tags.tag())))
      {
         MapArrayIterator next(*dTable);
         IntuiObject* iob;

         while (NULL != (iob=(IntuiObject*)next()))
         {
            if (!(iob->setAttributesIsRecurrent))
               iob->setAttributes(AttrList(next.key(),tags.data(),TAG_END) );
         }
      }
   }
}

/*------------------------- IntuiObject methods ------------------------------*/

IntuiObject::IntuiObject(IntuiObject* owner,const AttrList& attrs)
   : attrList(attrs)
{
   _dprintf("IntuiObject::IntuiObject()\n");

   iTransponder = NULL;
   setAttributesIsRecurrent = FALSE;

   setIOType(INTUIOBJECT_CLASS);

   if (owner==OWNER_ROOT)
   {
      if (IntuiRoot::APPIntuiRoot)
         IntuiRoot::APPIntuiRoot->addTail(this);
   }
   else
   {
      if (ptr_cast(IntuiObject,owner))
         owner->addTail(this);
      else
      {
         if (IntuiRoot::APPIntuiRoot)
            IntuiRoot::APPIntuiRoot->addTail(this);
         puterr("IntuiObject: owner is not derived from IntuiObject!\n");
      }
   }

   if (IntuiRoot::APPIntuiRoot)
      IntuiRoot::APPIntuiRoot->iob_count++;

   IObject() = NULL;    // initialise for safety

   processAttrs(attrList);
}

void IntuiObject::processAttrs(AttrList& attrs)
{
   AttrManipulator next(attrs);

   if (next.findTagItem(IOB_ITransponder))   // look out for itransponder attachment
   {
      iTransponder = (ITransponder*)next.data();
   }

   next.reset();

   while (next.findTagItem(IOB_CnstSource))     // look out for constraint definition
   {
      IntuiObject* sourceIOB = (IntuiObject*)next.data();
      if (APPOK(sourceIOB))
      {
         if (next())
            if (next.tag()==IOB_CnstTag)  // following tag must be constraint source tag specifier
         {
            Tag sourceTag = next.data();
            // initialise own tag data from constraint source
            if (next())
               next.writeData( sourceIOB->newConstraint(sourceTag,this,next.tag()) );
         }
      }
      else _ierror(INTUIOBJECT_CONSTRAINTSOURCE_NO_IOB);
   }
}

IntuiObject::~IntuiObject()
{
   _dprintf("IntuiObject::~IntuiObject() kill childs..\n");
   FOREACHSAFE(IntuiObject, this)
   {
      _dprintf("kill IntuiObject..\n");
      delete node;
      _dprintf("\tkilled.\n");
   }
   NEXTSAFE

   {
   MapArrayIterator next(cTable);
   MapArray* dTable;
   while (NULL != (dTable = (MapArray*)next())) delete dTable;
   }

   _dprintf("IntuiObject::~IntuiObject() done.\n");
   IObject() = NULL;
   if (IntuiRoot::APPIntuiRoot)  IntuiRoot::APPIntuiRoot->iob_count--;
}


IntuiObject* IntuiObject::findRootOfKind(const Type_info& class_info)
   /* Get the first object upwards searching in the tree that is a kind 
      of the given base class, ie derived from that class..
   */
{
   IntuiObject* io = this;

   // This loop terminates when io addresses the IntuiRoot. Its MinNodeC is
   // not linked into a list and therefore io->findList() will return NULL.*/
   while (NULL != (io = io->findOwner()))
      if (class_info.can_cast(ptr_type_id(io))) return io;

   return NULL;
}

ULONG IntuiObject::setAttributes(AttrList& attrs)
   /* Set attribute tags specified in the given taglist to their corresponding new values
      and start notifying other IntuiObjects via ITransponder and Constraints.
      Return 0L if setAttributes has been called recurrently.
   */
{
   if (!setAttributesIsRecurrent)   // check for a notification loop
   {
      _dprintf("IntuiObject::setAttributes()\n");
      processAttrs(attrs);

      attrList.updateAttrs(attrs);  // apply changes to Attribute Taglist

      setAttributesIsRecurrent = TRUE;
      // a setAttributes call within sendNotification would be recurrent now!
      changedAttrs(attrs);    // notify constraint destinations
      if (iTransponder)
      {
         _dprintf(" IntuiObject::sendNotify()\n");
         iTransponder->sendNotification(attrs);      // attrs will be changed
      }

      setAttributesIsRecurrent = FALSE;
      return 1L;
   }
   else return 0L;
}

ULONG IntuiObject::getAttribute(Tag tag,ULONG& dataStore)
{
   return (dataStore=intuiAttrs().getTagData(tag,0));
}

void IntuiObject::applyDefaultAttrs(const AttrList& userAttrs, 
                                    const AttrList& defaults)
   /* Work on the 'intuiAttrs': add those tags in the 'defaults' list to 
      'intuiAttrs' which are not already present in 'userAttrs'(!).
      Intended is that the class user can override every Attribute Tag
      the class itself preset as default value. Within the class subclasses
      may override presets of their base classes.
   */
{
   AttrList df_copy(defaults);
   // remove tags already set by the user
   df_copy.filterAttrs(userAttrs,TAGFILTER_NOT);
   // add remaining to intuiAttrs       
   intuiAttrs().addAttrs(df_copy);       
   // and override former values in intuiAttrs
   intuiAttrs().updateAttrs(defaults);
}

/*--------------------- IOBrowser methods ------------------------------------*/

IOBrowser::IOBrowser(IntuiObject* start)
   /* Initialises a search object that iteratively visits all IntuiObjects that 
      are dependend from the 'start' IntuiObject. 
      Note, that IntuiObjects on the same hierarchy level as start are not visited.
   */
{
   sp = 0;
   push((IntuiObject*)start->head());
}


IntuiObject* IOBrowser::getNext(const Type_info& class_info)
   /* visits the next IntuiObject in the deep first search through the subtree of
      the start object the IOBrowser was initialised with that is a kind of the
      given IntuiObject type. Subsequent getNext() calls return all IntuiObjects
      in the start object's subtree that are kind of the given IOTYPE except subtrees
      that have a root object of some other kind. The whole subtree is left out.
   */
{
   IntuiObject* root;

   do
   {
      root = pop();  // get the next node.

      if (root==NULL)
      {
          return NULL;
      }
      else
      {
         if (root->succ()) push((IntuiObject*)root->succ());
         // after the root subtree is empty, the successor will be visited

         if (class_info.can_cast(ptr_type_id(root)) && root->head()) push((IntuiObject*)root->head());
         // descent with the next getNext() into the subtree ONLY if the root of the
         // subtree is derived from the specified class.
      }
   }
   while ( !(class_info.can_cast(ptr_type_id(root))) );
   return root;
}

