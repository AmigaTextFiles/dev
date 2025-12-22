/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/RowColumnGroup.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/08/03 15:17:31 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/graphics/RowColumnGroup.h>
#include <APlusPlus/intuition/GadgetCV.h>


static const char rcs_id[] = "$Id: RowColumnGroup.cxx,v 1.8 1994/08/03 15:17:31 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
intui_typeinfo(RowColumnGroup, derived(from(GadgetCV)), rcs_id)


RowColumnGroup::RowColumnGroup(GOB_OWNER,AttrList& attrs) : GadgetCV(gob_owner,attrs)
{
   if (Ok())
      setIOType(IOTYPE_GROUPGADGET);
}

RowColumnGroup::~RowColumnGroup()
{
}

void RowColumnGroup::callback(const IntuiMessageC* imsg)
{
   // do nothing   
}

void RowColumnGroup::adjustChilds()
   /* Adjust graphical dimensions of the GraphicObject childs of 'this' GraphicObject
      according to the GOB_ tags defined in GraphicObject.h, depending on the dimensions
      of 'this'. The adjustment of each child will cause adjustments of all its GraphicObject
      childs down the IntuiObject tree.
      'adjustChilds' needs to be invoked on every window since each invokation only
      regards non-window childs.
   */
{
   GraphicObject *relative = NULL;
   GraphicObject *pred = NULL;
   WHVAL widthSum=0;
   int numberOfChilds=0;

   // enclose the two FOREACHOF loops in their own scope to allow the 
   // declaration of variable 'node' twice.
   {
      // first run: sum up the width of all childs
      FOREACHOF(GraphicObject,this)
      {
         if (ptr_cast(GadgetCV,node))
         {
            widthSum += node->width();
            numberOfChilds++;
   
            pred = node;
            _dprintf("adjustChild to: (%ld/%ld,%ld/%ld,%ld/%ld,%ld/%ld)\n",node->left(),node->iLeft(),node->top(),node->iTop(),node->right(),node->iRight(),node->bottom(),node->iBottom());
         }
      }
   }
   WHVAL space = 0;
   if (numberOfChilds > 1)
      space = ((iWidth()-widthSum)>0 ?(iWidth()-widthSum):0 )/(numberOfChilds-1);

   // second run: position the childs
   XYVAL leftX = iLeft();
   XYVAL topY = iTop();
   {
      FOREACHOF(GraphicObject,this)
      {
         if (ptr_cast(GadgetCV,node)) 
         {
            node->setRectWH(leftX,topY,node->width(),node->height());
            leftX += node->width()+space;
            node->adjustChilds();
         }
      }
   }
}
