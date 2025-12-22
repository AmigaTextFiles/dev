/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _all_pairs.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  ALL PAIRS SHORTEST PATHS                                                    *
*                                                                              *
*******************************************************************************/

#include <LEDA/graph_alg.h>

bool ALL_PAIRS_SHORTEST_PATHS(graph&G, const edge_array<num_type>& cost, 
                                             node_matrix<num_type>& DIST)
{ 
  // computes for every node pair (v,w) DIST(v,w) = cost of the least cost
  // path from v to w, the single source shortest paths algorithms BELLMAN_FORD
  // and DIJKSTRA are used as subroutines. Returns false if there is a
  // negative cost circle and true otherwise.

  edge e;
  node v,w;

  num_type C = 0;
  forall_edges(e,G)  C += ((cost[e]>0) ? cost[e] : -cost[e]);

  node s = G.new_node();
  forall_nodes(v,G) G.new_edge(s,v);

  edge_array<num_type> cost1(G);
  node_array<num_type> dist1(G);

  node_array<edge>  pred(G);

  forall_edges(e,G)  
    if (source(e)==s) cost1[e] = C;
    else cost1[e] =  cost[e];

  if (!BELLMAN_FORD(G,s,cost1,dist1,pred)) return false;

  G.del_node(s);

  forall_edges(e,G) cost1[e] = dist1[source(e)] + cost[e] - dist1[target(e)];


  // (G,cost1) is a non-negative network
  // for every node v compute row DIST[v] of the distance matrix  DIST 
  // by a call of DIJKSTRA(G,v,cost1,DIST[v])

  forall_nodes(v,G) DIJKSTRA(G,v,cost1,DIST[v],pred);


  // correct the entries of DIST

  forall_nodes(v,G)
  { num_type dv = dist1[v];
    forall_nodes(w,G) DIST(v,w) += (dist1[w] - dv);
   }

 return true;
}

