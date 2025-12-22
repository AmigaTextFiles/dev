/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _topsort.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  TOPSORT (topological sorting)                                               *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>


bool TOPSORT(const graph& G, node_array<int>& ord)
{ 
  node_data<int> INDEG(G,0);
  node_list ZEROINDEG;

  int count=0;
  node v,w;

  forall_nodes(v,G) if ((INDEG[v]=indeg(v))==0) ZEROINDEG.append(v); 

  while (!ZEROINDEG.empty())
   { v = ZEROINDEG.pop();
     ord[v] = ++count;
     forall_adj_nodes(w,v) 
        if (--INDEG[w]==0) ZEROINDEG.append(w);
    }
  
  if (count==G.number_of_nodes()) 
     return(true);
  else 
     return(false);
}
     



// TOPSORT1 rearrange nodes and edges 

bool TOPSORT1(graph& G)
{ 
  if (G.number_of_nodes()==0 || G.number_of_edges()==0) return true;

  node_array<int> node_ord(G);
  edge_array<int> edge_ord(G);

  if (TOPSORT(G,node_ord))
   { edge e;
     forall_edges(e,G) edge_ord[e] = node_ord[target(e)];
     G.sort_nodes(node_ord);
     G.sort_edges(edge_ord);
     return true;
    }

  else return false;
  
}
     

