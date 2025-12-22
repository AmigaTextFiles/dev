/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _components.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*******************************************************************************
*                                                                              *
*  COMPONENTS  (connected components)                                          *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>

#include <LEDA/node_partition.h>

static int count;

static void dfs(node v, node_array<int>& compnum)
{ 
  node_stack  S;

  S.push(v);
  compnum[v] = count;

  while (!S.empty())
   { v = S.pop(); 
     node w;
     forall_adj_nodes(w,v) 
        if (compnum[w] == -1)
        { compnum[w] = count;
          S.push(w);
         }
    }
 
} 

int COMPONENTS(const ugraph& G, node_array<int>& compnum)
{ // computes connected components of undirected graph G
  // compnum[v] = i  iff v in component i
  // number of components is returned

  node v;

  forall_nodes(v,G) compnum[v] = -1;

  count = 0;

  forall_nodes(v,G) 
    if (compnum[v] == -1) 
    { dfs(v,compnum);
      count++; 
     }

  return count;
}



int COMPONENTS1(const ugraph& G, node_array<int>& compnum)
{ 

  node_partition P(G);
  edge e;
  node v;

  forall_nodes(v,G) compnum[v] = -1;

  forall_edges(e,G) P.union_blocks(source(e),target(e));

  int count = 0;
  forall_nodes(v,G) 
   { node w = P.find(v);
     if (compnum[w]==-1) compnum[w] = count++;
     compnum[v] = compnum[w];
    }

  return count;
}


