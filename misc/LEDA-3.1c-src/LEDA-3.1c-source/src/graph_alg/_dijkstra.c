/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _dijkstra.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  DIJKSTRA  (single source shortest paths)                                    *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>
#include <LEDA/node_pq.h>


void DIJKSTRA(const graph& G, node s, const edge_array<num_type>& cost,
                                            node_array<num_type>& dist,
                                            node_array<edge>& pred )
{ /* 
     computes single source shortest paths from node s for 
     a non-negative network (G,cost), computes for all nodes v:
     a) dist[v] = cost of shortest path from s to v
     b) pred[v] = predecessor edge of v in shortest paths tree
  */

  node_pq<num_type>  PQ(G);
  node v;                                                                    
  edge e;                                                                      
                                                                               
  forall_nodes(v,G)                                                            
  { pred[v] = nil;                                                             
    dist[v] = max_num;                                                      
   }                                                                         

  dist[s] = 0;
  PQ.insert(s,0);
                                                                               
  while (! PQ.empty())
  { node u = PQ.del_min();
    num_type du = dist[u];
    forall_adj_edges(e,u)                                                    
    { v = target(e);                                                      
      num_type c = du + cost[e];                                              
      if (c < dist[v])                                                    
      { if (dist[v] == max_num) 
           PQ.insert(v,c);
        else 
           PQ.decrease_inf(v,c);
        dist[v] = c;                                                     
        pred[v] = e;                                                     
       }                                                                 
     }                                                                    
   } 
}

