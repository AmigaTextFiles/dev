/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  edge_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_EDGE_SET_H
#define LEDA_EDGE_SET_H

#include <LEDA/graph.h>



//------------------------------------------------------------------------------
// edge_set  
//------------------------------------------------------------------------------

class edge_set {
graph* g;
list(edge) L;
graph_array(edge) A;
public:
void insert(edge x)  { if (A.inf(x) == nil) A.entry(x) = Convert(L.append(x)); }
void del(edge x)     { if (A.inf(x) != nil) 
                        { L.del(list_item(A.inf(x))); A.entry(x) = nil;} 
                      }
bool member(edge x)      { return (A.inf(x) != nil) ? true:false; }
edge choose()  const     { return L.head(); }
int  size()    const     { return L.length(); }
bool empty()   const     { return L.empty(); }
void clear()             { L.clear(); A.init(*g,nil); }

         edge_set(const graph& G) { g = (graph*)&G; A.init(G,nil);}
virtual ~edge_set()               { L.clear(); A.clear(); }
};


#endif
