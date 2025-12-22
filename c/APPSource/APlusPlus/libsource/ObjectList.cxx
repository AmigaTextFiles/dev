/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/ObjectList.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:51:16 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/exec/ObjectList.h>
#include <APlusPlus/environment/APPObject.h>


static const char rcs_id[] = "$Id: ObjectList.cxx,v 1.7 1994/07/27 11:51:16 Armin_Vogt Exp Armin_Vogt $";


ReferenceNode::ReferenceNode(APTR object, UBYTE type) : PriorityNode((UBYTE*)object,type)
{
}

ReferenceList::ReferenceList(UBYTE type) : PriorityList(type)
{
}

TObjNode::TObjNode(APTR object, UBYTE type) : ReferenceNode(object,type)
{
}

TObjList::TObjList(UBYTE type) : ReferenceList(type)
{
}

TObjList::~TObjList()
   /* Delete all traced objects at the end of the programm.
   */
{
   FOREACHSAFE(TObjNode, this)
   {
      delete node;
   }
   NEXTSAFE
   _dprintf("~TObjList done\n");
}

ReferenceNode *ReferenceList::findObject(APTR objectptr,UBYTE objtype)
{
   FOREACHOF(ReferenceNode,this)
      if (objectptr==NULL || node->object() == objectptr)
         if (objtype==0 || node->type() == objtype) return node;

   return NULL;
}

void TObjList::deleteTObj(APTR obj)
{
   TObjNode *node;

   if (node = (TObjNode*)findObject(obj))
   {
      delete node;   // remove node, free resource and free memory
   }
}
