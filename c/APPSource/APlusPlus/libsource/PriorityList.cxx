/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/PriorityList.cxx,v $
 **   $Revision: 1.6 $
 **   $Date: 1994/07/27 11:51:25 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/exec/PriorityList.h>


static const char rcs_id[] = "$Id: PriorityList.cxx,v 1.6 1994/07/27 11:51:25 Armin_Vogt Exp Armin_Vogt $";


PriorityNode::PriorityNode(const UBYTE* name,UBYTE type) : NodeC(name,type)
{
}

PriorityList::PriorityList(UBYTE type) : ListC(type)
{
}

BYTE PriorityList::internalEnqueue(PriorityNode *node,BYTE pri)
{
   BYTE old_pri;

   old_pri = node->priority();
   ((NodeC*)node)->setPriority(pri); // GCC 2.5.4. understands setPriority() to be private!?
   ListC::enqueue(node);

   return old_pri;
}
BYTE PriorityList::internalChangePri(PriorityNode *node,BYTE pri)
{
   // be carefull, membership of the node is not checked here, therefore this is internal only!
   Remove((struct Node*)node);
   return internalEnqueue(node,pri);
}

