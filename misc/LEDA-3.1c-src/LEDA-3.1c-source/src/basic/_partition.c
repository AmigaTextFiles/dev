/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _partition.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



//------------------------------------------------------------------------------
//
// partitions
//
// implementation: union find with weighted union rule and path compression
//
// S. N.  (1989)
//------------------------------------------------------------------------------

#include <LEDA/partition.h>


void partition::clear()
{ // free all used items
  partition_item p = used_items; 
  while (used_items)
  { p = used_items;
    used_items = used_items->next;
    clear_inf(p->info);
    delete p;
   }
 }
  


partition_item partition::find(partition_item y) 
{ // find with path compression

  register partition_item x = y->father;

  if (x==0) return y;

  register partition_item root = y;

  while (root->father) root = root->father;

  while (x!=root)
  { y->father = root;
    y = x;
    x = y->father;
   }
  return root;
 }

void partition::union_blocks(partition_item a, partition_item b)
{ // weighted union

  a = find(a);
  b = find(b);

  if (a==b) return;

  if (a->size > b->size)
       { b->father = a;
         a->size += b->size; }
  else { a->father = b;
         b->size += a->size; }

 }

