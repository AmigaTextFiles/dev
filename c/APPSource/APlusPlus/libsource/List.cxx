/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/List.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/08/27 13:21:39 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/exec/List.h>


static const char rcs_id[] = "$Id: List.cxx,v 1.8 1994/08/27 13:21:39 Armin_Vogt Exp Armin_Vogt $";

MinNodeC::MinNodeC()
{
   neutralize();  // allows removing an unattached node
}

void MinNodeC::remove()
{
   Remove((Node*)(MinNode*)this);
   neutralize();
}


MinListC::MinListC()
{
   NewList((List*)(MinList*)this);
}

MinNodeC* MinListC::remHead()
{
   MinNodeC* node = (MinNodeC*)RemHead((List*)(MinList*)this);
   if (node) node->neutralize(); return node;
}

MinNodeC* MinListC::remTail()
{
   MinNodeC* node = (MinNodeC*)RemTail((List*)(MinList*)this);
   if (node) node->neutralize(); return node;
}

void MinListC__Destruct(MinListC* list)
   /* prevents a destructed list object from being used via still existing nodes.
      The nodes within the list are being disconnected from the list.
   */
{
   FOREACHSAFE(MinNodeC,list)
   {
      node->remove();
   }
   NEXTSAFE
}

void NodeC::init(BYTE pri, const UBYTE* name, UBYTE type)
{
   ln_Pri = pri;
   ln_Name = (char*)name;
   ln_Type = type;
   neutralize();
}
NodeC::NodeC(BYTE pri, UBYTE type)
{
   init(pri,NULL,type);
}

NodeC::NodeC(BYTE pri, const UBYTE* name, UBYTE type)
{
   init(pri,name,type);
}

NodeC::NodeC(const UBYTE* name, UBYTE type)
{
   init(0,name,type);
}


ListC::ListC(UBYTE type)
{
   lh_Type = type;
   NewList((List*)this);
}

BOOL MinListC__Member(const MinListC* list,const MinNodeC* find)
{
   FOREACHOF(MinNodeC,list)
      if (node == find) return TRUE;

   return FALSE;
}

MinNodeC* MinListC__RemoveSafely(MinListC* list,MinNodeC* node)
{
   if(list->member(node))
   {
      node->remove();
   }

   return node;
}

MinListC* MinNodeC::findList(void) const
   /* check if the node is chained into a list, then run through the list to
      the start nil node that is integrated into the MinList structure and
      return the MinListC object of this structure.
   */
{
   if (isLonelyNode()) return NULL;   // this node is not chained into a list

   MinNode* node;
   MinNode* pred;

   node = (MinNode*)this;
   while (NULL != (pred = node->mln_Pred))   node = pred;

   return (MinListC*)(MinList*)node;
}

BOOL MinListC::apply(void* any)
   /* It is safe for a MinNodeC object in the list to delete itself during the apply loop.
   */
{
   FOREACHSAFE(MinNodeC,this)
   {
      if (node->applyMinNodeC(any)==FALSE) return FALSE;
   }
   NEXTSAFE
   return TRUE;   // all nodes have been applied to
}

BOOL ListC::apply(void* any)
   /* It is safe for a NodeC object in the list to delete itself during the apply loop.
   */
{
   FOREACHSAFE(NodeC,this)
   {
      if (node->applyNodeC(any)==FALSE) return FALSE;
   }
   NEXTSAFE

   return TRUE;   // all nodes have been applied to
}

BOOL MinNodeC::applyMinNodeC(void* any)
{
   return FALSE;
} // your subclass should overwrite this

BOOL NodeC::applyNodeC(void* any)
{
   return FALSE;
} // your subclass should overwrite this

MinListC::~MinListC()
{
   MinListC__Destruct(this);
}

MinNodeC::~MinNodeC()
{
   remove();
}

ListC::~ListC()
{
   MinListC__Destruct((MinListC*)(MinList*)(List*)this);
}

NodeC::~NodeC()
{
   remove();
}

