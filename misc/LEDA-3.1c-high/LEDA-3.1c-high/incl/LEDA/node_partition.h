/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  node_partition.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_NODE_PARTITION_H
#define LEDA_NODE_PARTITION_H

#include <LEDA/graph.h>



//------------------------------------------------------------------------------
// node partitions 
//------------------------------------------------------------------------------

#include <LEDA/partition.h>

class node_partition : private partition
{

public:

void init(const graph& G);

 node_partition(const graph& G) { init(G); }
~node_partition()               {}   

int  same_block(node v, node w)   
{ return partition::same_block(partition_item(v->data[1]),
                               partition_item(w->data[1])); }

void union_blocks(node v, node w) 
{ partition::union_blocks(partition_item(v->data[1]), 
                          partition_item(w->data[1])); }

void make_rep(node v) 
{ partition::set_inf(partition_item(v->data[1]),v); }

node find(node v) 
{ return node(partition::inf(partition::find(partition_item(v->data[1])))); }

node operator()(node v) { return find(v); }


};


#endif
