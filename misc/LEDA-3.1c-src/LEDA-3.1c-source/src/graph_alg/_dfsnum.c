/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _dfsnum.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  DFS_NUM (depth first search numbering)                                      *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>

static int dfs_count1,dfs_count2;

static void dfs(node v, node_array<bool>& reached, 
                        node_array<int>& dfsnum, 
                        node_array<int>& compnum,
                        list<edge>& T )
{ node w;
  edge e;

  reached[v] = true;
  dfsnum[v] = ++dfs_count1;

  forall_adj_edges(e,v) 
    { w = target(e);
      if (!reached[w]) 
       { T.append(e);
         dfs(w,reached,dfsnum,compnum,T);
        }
     }

  compnum[v] = ++dfs_count2;
} 

list<edge> DFS_NUM(const graph& G, node_array<int>& dfsnum, 
                                   node_array<int>& compnum)
{ 
  list<edge> T;
  node_array<bool> reached(G,false);
  node v;
  dfs_count1 = dfs_count2 = 0;
  forall_nodes(v,G) if (!reached[v]) dfs(v,reached,dfsnum,compnum,T);
  return T;
}

