/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  node_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_NODE_SET_H
#define LEDA_NODE_SET_H

#include <LEDA/graph.h>

//------------------------------------------------------------------------------
// node_set  
//------------------------------------------------------------------------------

class node_set {
graph* g;
list<node> L;
graph_array(node) A;
public:
void insert(node x)  { if (A.inf(x) == nil) A.entry(x) = Convert(L.append(x)); }
void del(node x)     { if (A.inf(x) != nil) 
                        { L.del(list_item(A.inf(x))); A.entry(x) = nil;} 
                      }
bool member(node x)      { return (A.inf(x) != nil); }
node choose()  const     { return L.head(); }
int  size()    const     { return L.length(); }
bool empty()   const     { return L.empty(); }
void clear()             { L.clear(); A.init(*g,nil); }
node_set(const graph& G) { g = (graph*)&G; A.init(G,nil);}
~node_set()              { L.clear(); A.clear(); }
};

#endif
