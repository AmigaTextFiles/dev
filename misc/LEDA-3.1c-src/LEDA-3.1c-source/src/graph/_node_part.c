/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _node_part.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/node_partition.h>

void node_partition::init(const graph& G) 
{ node v;
  forall_nodes(v,G) v->data[1] = partition::make_block(v);
 }


