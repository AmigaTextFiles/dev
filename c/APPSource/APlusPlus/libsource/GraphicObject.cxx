/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/GraphicObject.cxx,v $
 **   $Revision: 1.13 $
 **   $Date: 1994/08/02 17:49:25 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

#include <APlusPlus/intuition/Intui_TypeInfo.h>
#include <APlusPlus/graphics/GraphicObject.h>
#include <APlusPlus/graphics/GBorder.h>
#include <APlusPlus/intuition/GadgetCV.h>


static const char rcs_id[] = "$Id: GraphicObject.cxx,v 1.13 1994/08/02 17:49:25 Armin_Vogt Exp Armin_Vogt $";


//runtime type inquiry support
intui_typeinfo(GraphicObject, derived(from(IntuiObject)), rcs_id)


GraphicObject::GraphicObject(GraphicObject* owner,AttrList& attrs)
   : IntuiObject(owner,attrs)
{
   if (Ok())
   {
      setIOType(GRAPHICOBJECT);
      GBorder* gbObj = (GBorder*)intuiAttrs().getTagData(GOB_Border);
      if (gbObj) gbObj->makeBorder(this);    // fill in border dimensions

      setRectWH(0,0, // upper left corner will be set by adjustChilds()
         intuiAttrs().getTagData(GOB_Width,0),
         intuiAttrs().getTagData(GOB_Height,0) );
   }
}

GraphicObject::~GraphicObject()
{

}


ULONG GraphicObject::setAttributes(AttrList& attrs)
   /* only propagates the update attrs to the base class.
   */
{
   GBorder* gbObj = (GBorder*)attrs.getTagData(GOB_Border);
   if (gbObj) gbObj->makeBorder(this);

   return IntuiObject::setAttributes(attrs);
}

ULONG GraphicObject::getAttribute(Tag tag,ULONG& dataStore)
{
   return IntuiObject::getAttribute(tag,dataStore);
}

APTR GraphicObject::redrawSelf(GWindow* homeWindow,ULONG& returnType)
{
   GBorder* gbObj = (GBorder*)intuiAttrs().getTagData(GOB_Border);
   if (gbObj) gbObj->drawBorder(this,homeWindow);

   returnType = 0L;
   return NULL;
}

void GraphicObject::adjustChilds()
   /* Adjust graphical dimensions of the GraphicObject childs of 'this' GraphicObject
      according to the GOB_ tags defined in GraphicObject.h, depending on the dimensions
      of 'this'. The adjustment of each child will cause adjustments of all its GraphicObject
      childs down the IntuiObject tree.
      'adjustChilds' needs to be invoked on every window since each invokation only
      regards non-window childs.
   */
{
   GraphicObject* pred = NULL;

   FOREACHOF(GraphicObject,this)
   {
   if (ptr_cast(GadgetCV,node))  
   {   
      
      WHVAL oldWidth=node->width(),oldHeight=node->height();   // preserve the former width/height

      AttrIterator next(node->intuiAttrs());
      XYVAL minx=0,miny=0,maxx=0,maxy=0;
      while (next())
      {
         LONG data = (LONG)next.data();
         ULONG tagID = next.tag() - GOB_Spec_Dummy;

         if (tagID < 16)
         {
            GraphicObject* relative = tagID&gob_relative ? (pred==NULL?this:pred) : this;

            _dprintf("relative has (%ld,%ld,%ld,%ld)\n",relative->iLeft(),relative->iTop(),relative->iRight(),relative->iBottom());
            WHVAL distance;

            if (tagID & gob_orient)
            {
               distance = ((tagID & gob_reledge)?
                     ((tagID & gob_relative)?relative->bottom():relative->iBottom())
                     :
                     ((tagID & gob_relative)?relative->top():relative->iTop())
                     ) + (WHVAL)GOB_Absolute(iHeight(),data);
               if (tagID & gob_edge)
                  maxy = distance;
               else
                  miny = distance;
            }
            else
            {
               distance = ((tagID & gob_reledge) ?
                  ((tagID & gob_relative)?relative->right():relative->iRight())
                  :
                  ((tagID & gob_relative)?relative->left():relative->iLeft())
                  ) + (WHVAL)GOB_Absolute(iWidth(),data);
               if (tagID & gob_edge)
                  maxx = distance;
               else
                  minx = distance;
            }
         }
         else switch(next.tag())       // other GraphicObject tags
         {

            default: break;
         }
      }

      // if there were not sufficient GOB_Tags declared to fully specify the rectangle
      // missing values are deduced from the former width/height plus the specified corner
      if (oldWidth != 0)
      {
         if (maxx==0) maxx = minx + oldWidth;
         if (minx==0) minx = maxx - oldWidth;
      }
      if (oldHeight != 0)
      {
         if (maxy==0) maxy = miny + oldHeight;
         if (miny==0) miny = maxy - oldHeight;
      }

      node->setRect(minx,miny,maxx,maxy);

      pred = node;
      _dprintf("adjustChild to: (%ld/%ld,%ld/%ld,%ld/%ld,%ld/%ld)\n",node->left(),node->iLeft(),node->top(),node->iTop(),node->right(),node->iRight(),node->bottom(),node->iBottom());
      node->adjustChilds();
   } /* if */
   } /* FOREACHOF */
}
