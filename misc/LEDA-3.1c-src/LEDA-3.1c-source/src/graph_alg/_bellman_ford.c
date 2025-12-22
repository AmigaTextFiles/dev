/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _bellman_ford.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  BELLMAN FORD                                                                *
*                                                                              *
*******************************************************************************/

#include <LEDA/graph_alg.h>
#include <LEDA/b_queue.h>


bool BELLMAN_FORD(const graph& G, node s, const edge_array<num_type>& cost, 
                                                node_array<num_type>& dist, 
                                                node_array<edge>& pred ) 

/* single source shortest paths from s using a queue (breadth first search)
   computes for all nodes v:
   a) dist[v] = cost of shortest path from s to v
   b) pred[v] = predecessor edge of v in shortest paths tree
*/

{ 
  node_data<int> count(G,0);

  int n = G.number_of_nodes();

  node_list Q;

  node u,v;
  edge e;

  forall_nodes(v,G) 
  { pred[v] = 0;
    dist[v] = max_num; 
   }

  dist[s] = 0;
  Q.append(s);

  while(! Q.empty() )
  { u = Q.pop();

    if (++count[u] > n) return false;   // negative cycle

    num_type du = dist[u];

    forall_adj_edges(e,u) 
    { v = target(e);
      num_type c = du + cost[e];
      if (c < dist[v]) 
      { dist[v] = c; 
        pred[v] = e;
        if (!Q.member(v)) Q.append(v);
       }
     } 
   }
  return true;
}

