/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  partition.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_PARTITION_H
#define LEDA_PARTITION_H

//------------------------------------------------------------------------------
// partition   (union find)
//------------------------------------------------------------------------------

#include <LEDA/basic.h>


class partition_node {

friend class partition;

partition_node* father;
partition_node* next;
int size;
GenPtr info;

public:

partition_node(GenPtr x, partition_node* n)  
{ 
  father=0; size=1; info=x; next = n; 
 }

  LEDA_MEMORY(partition_node)

};


// a partition item is a pointer to a partition node:

typedef partition_node* partition_item;



class partition {

virtual void clear_inf(GenPtr&) const {}

partition_item used_items;                 // List of used partition items

public:  // operations 

void  union_blocks(partition_item,partition_item);
partition_item find(partition_item);

partition_item make_block(GenPtr x = nil) 
{ used_items = new partition_node(x,used_items); 
  return used_items; 
 }

int  same_block(partition_item a, partition_item b) 
{ return find(a)==find(b); }

GenPtr   inf(partition_item a) { return find(a)->info; }

void  set_inf(partition_item a, GenPtr x) { find(a)->info = x; }

void clear();                      // deletes all used items

partition() { used_items = 0; }  
virtual ~partition() { clear(); }

};


//------------------------------------------------------------------------------
// PARTITION  (named partitions)
//-----------------------------------------------------------------------------

template <class type>

class PARTITION : public partition {

void clear_inf(GenPtr& x) const { Clear(ACCESS(type,x)); }

public:

partition_item make_block(type x) { return partition::make_block(Convert(x)); }

type  inf(partition_item a)       { return (type)partition::inf(a); }

void  set_inf(partition_item a, type x) { partition::set_inf(a,Convert(x)); }

 PARTITION() {}
~PARTITION() {}
};


#endif
