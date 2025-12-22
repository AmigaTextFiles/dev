/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  node_partition1.h
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


class node_partition {

public:

void init(const graph& G) 
{ init_node_data1(G,nil); 
  node v;
  forall_nodes(v,G) v->data[0] = 1;
}

 node_partition(const graph& G) { init(G); }
~node_partition()               {}   

/*
node find(node v) 
{ node r = v;
  while (r->data[1]) r = node(r->data[1]); 
  while (v->data[1]) 
  { node u = v;
    v = node(v->data[1]); 
    u->data[1] = r;
   }
  return r;
 } 
*/

node find(node v) 
{ while (v->data[1]) v = node(v->data[1]); 
  return v;
 }

int  same_block(node v, node w)   { return find(v) == find(w); }

void union_blocks(node v, node w) 
{ node x = find(v);
  node y = find(w);
  if (x != y) 
    if (int(x->data[0]) <  int(y->data[0]))
      { x->data[1] = y; 
        (int&)y->data[0] += int(x->data[0]);
       }
    else
      { y->data[1] = x; 
        (int&)x->data[0] += int(y->data[0]);
       }
    
}

void set_inf(node v, node w) 
{ if (v->data[1])
  { node r = find(v); 
    v->data[1] = nil; 
    r->data[1] = v; 
    v->data[0] = r->data[0];
   }
 }


node operator()(node v) { return find(v); }


};


#endif
