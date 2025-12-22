/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _d.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



void DIJKSTRA(graph& G, node s, 
              edge_array<int>&  cost, 
              node_array<int>&  dist,
              node_array<edge>& pred,
              priority_queue<node,int>&   PQ)
{
  node_array<pq_item> I(G);
  node v;
                                                                               
  forall_nodes(v,G)
  { pred[v] = nil;
    dist[v] = MAXINT;
   }

  dist[s] = 0;
  I[s] = PQ.insert(s,0);

  while (! PQ.empty())
  { pq_item it = PQ.find_min();
    node u = PQ.key(it);
    int du = dist[u];
    edge e;
    forall_adj_edges(e,u)
    { v = G.target(e);
      int c = du + cost[e];
      if (c < dist[v])
      { if (dist[v] == MAXINT)
          I[v] = PQ.insert(v,c);
        else
          PQ.decrease_inf(I[v],c);
        dist[v] = c;
        pred[v] = e;
       }                                                                 
     }
    PQ.del_item(it);
   }
}


void DIJKSTRA(graph& G, node s, 
              edge_array<int>&  cost, 
              node_array<int>&  dist,
              node_array<edge>& pred)
{
  priority_queue<node,int>  PQ;

  DIJKSTRA(G,s,cost,dist,pred,PQ);

 }
