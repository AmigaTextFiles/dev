/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _dfs.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  DFS  (depth first search)                                                   *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>

list<node> DFS(const graph& G, node v, node_array<bool>& reached)
{ 
  list<node>  L;
  node_stack  S;
  node w;

  if (!reached[v])
   { reached[v] = true;
     L.append(v);
     S.push(v);
    }

  while (!S.empty())
   { v = S.pop(); 
     forall_adj_nodes(w,v) 
       if (!reached[w]) 
        { reached[w] = true;
          L.append(w);
          S.push(w);
         }
    }

  return L;
 
} 
