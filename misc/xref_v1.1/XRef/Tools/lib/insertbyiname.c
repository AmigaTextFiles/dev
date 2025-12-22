/*
** $PROJECT: xrefsupport.lib
**
** $VER: insertbyiname.c 1.1 (08.09.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 08.09.94 : 001.001 :  initial
*/

#include "/source/Def.h"

void insertbyiname(struct List *list,struct Node *node)
{
   struct Node *sn;
   struct Node *in = NULL;

   for(sn = list->lh_Head ; sn->ln_Succ ; sn = sn->ln_Succ)
   {
      if(Stricmp(sn->ln_Name,node->ln_Name) > 0)
      {
         in = sn->ln_Pred;
         if(!in->ln_Pred)
            in = NULL;
         break;
      }
   }

   if(!in && !sn->ln_Succ)
      in = sn->ln_Pred;

   Insert(list,node,in);
}


