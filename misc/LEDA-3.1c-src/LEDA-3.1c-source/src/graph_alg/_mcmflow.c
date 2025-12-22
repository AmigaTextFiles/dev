/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _mcmflow.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



//------------------------------------------------------------------------------
//
// MIN_COST_MAX_FLOW(G,s,t,cap,cost,flow)
//
// computes a maximal s-t flow of minimal total cost in network (G,cap,cost)
//
// Algorithm: successive shortest path augmentation + capacity scaling
//
// Based on:  J. Edmonds and R. M. Karp: 
//            "Theoretical Improvements in Algorithmic Efficiency for Network 
//            Flow Problems", Journal of the  ACM, Vol. 19, No. 2, 1972
//
//            R.K. Ahuja, T.L. Magnanti, J.B. Orlin: 
//            "Network Flows", Section 10.2, Prentice Hall Publ. Company, 1993
//
//
// S. N"aher  (December 1993)
//------------------------------------------------------------------------------

#include <LEDA/graph_alg.h>
#include <LEDA/node_pq.h>


static node DIJKSTRA_IN_RESIDUAL(const graph& G, node s, int delta, 
                                 const edge_array<num_type>& cost,
                                 const edge_array<num_type>& cap_minus_flow,
                                 const edge_array<num_type>& flow,
                                 const node_array<num_type>& excess,
                                 node_array<num_type>& pi,
                                 node_array<edge>& pred)
{
   /*  Computes a shortest path from node s until a node t with excess <= -delta
       is reached in the delta-residual graph of network G. Edges are traversed
       in both directions using the forall_in/out_edges iteration macros.The 
       residual capacity of an edge e is cap_minus_flow[e] if e is used from 
       source(e) to target(e) and flow[e] otherwise. The reduced cost of an
       edge e = (u,v) is equal to cost[e] + pi[u] - pi[v] if it is used from 
       u and -cost[e] + pi[v] - pi[u] if it is used from v.

       precondition: every edge in the delta-residual network has non-negative 
                     reduced cost.
       
       returns t (nil,if there is no path from s to a node with excess<-delta)

       and

       pred[v] = predecessor edge of v on the shortest path from s to t

       pi[v]   = pi'[v] + dist[v] - dist[t], if v is permanently labeled
                 pi'[v],                     if v is temporarily labeled
                 (here pi' is the old potential vector)

  */

  node_array<num_type> dist(G,MAXINT);
  node_pq<num_type> PQ(G);
  node v;
  edge e;

  node t = nil;

  node_list perm_labeled; // list of permanently labeled nodes

  dist[s] = 0;
  PQ.insert(s,0);

  while (!PQ.empty())
  { node u = PQ.del_min();

    perm_labeled.append(u);

    if (excess[u] <= -delta) 
    { t = u;
      break;
     }

    num_type du = dist[u] + pi[u]; 

    forall_out_edges(e,u) 
      if (cap_minus_flow[e] >= delta)  // e in delta-residual graph
      { v = target(e);
        num_type c = du - pi[v] + cost[e];
        if (c < dist[v])
        { if (dist[v] == MAXINT) // v has not been reached before
            PQ.insert(v,c);
          else
            PQ.decrease_inf(v,c);
          dist[v] = c;
          pred[v] = e;
         }
       }

    forall_in_edges(e,u) 
      if (flow[e] >= delta)  // e in delta-residual graph
      { v = source(e);
        num_type c = du - pi[v] - cost[e];
        if (c < dist[v])
        { if (dist[v] == MAXINT) // v has not been reached before
            PQ.insert(v,c);
          else
            PQ.decrease_inf(v,c);
          dist[v] = c;
          pred[v] = e;
         }
       }

   }

   if (t != nil) // update potentials of all permanently labeled nodes
   { num_type dt = dist[t];
     forall(v,perm_labeled) pi[v] += dist[v] - dt;
    }

   return t;
}



num_type MIN_COST_MAX_FLOW(graph& G, node src, node sink,
                                              const edge_array<num_type>& cap0,
                                              const edge_array<num_type>& cost0,
                                              edge_array<num_type>& flow0)
{ 
  double n = G.number_of_nodes();
  double m = G.number_of_edges();

  num_type total_flow = 0;               // total flow value (returned)
  int  count = 0;                        // number of augmentations
  node v;
  edge e;

  num_type supply = MAX_FLOW(G,src,sink,cap0,flow0);


  num_type C = 0;  // maximal cost of an s-t path in G

  forall_edges(e,G)
  { if (cost0[e] > C)  C = cost0[e];
    if (cost0[e] < -C) C = -cost0[e];
   }

  C = C * G.number_of_nodes();



  list<edge> art_edges;  // list of artificial edges (see below)
  list<edge> neg_edges;  // list of negative cost edges

  // add artificial edges to guarantee existence of a path of infinite
  // capacity (MAXINT) and huge cost (C) between any pair of nodes  (v,w)
  // with b(v) > 0 and b(w) < 0
   
  //forall_nodes(v,G) 
  //if (v != src) 
  //{ art_edges.append(G.new_edge(v,src));
  //  art_edges.append(G.new_edge(src,v));
  // }

  art_edges.append(G.new_edge(src,sink));


  node_array<num_type> pi(G,0);           // node potential
  node_array<num_type> excess(G,0);       // excess
  node_array<edge>     pred(G,nil);       // predecessor edge on shortest path
  edge_array<num_type> flow(G,0);
  edge_array<num_type> cap(G,0);
  edge_array<num_type> cost(G,0);
  edge_array<num_type> cap_minus_flow(G,0);


  forall_edges(e,G)
  { cap[e] = cap0[e];
    cost[e] = cost0[e];
    cap_minus_flow[e] = cap[e];
    if (cost[e] < 0) neg_edges.append(e);
   }

  forall(e,art_edges)
  { cap[e] = MAXINT;
    cost[e] = C;
    cap_minus_flow[e] = MAXINT;
   }

  excess[src]  =  supply;
  excess[sink] = -supply;


  // eliminate negative cost edges by edge reversals 
  // (Ahuja/Magnanti/Orlin, section 2.4)

  forall(e,neg_edges)
  { node u = source(e);
    node v = target(e);
    excess[u] -= cap[e];
    excess[v] += cap[e];
    cost[e] = -cost[e];
    G.rev_edge(e);
  }
 
  int delta = 1;

  double delta_max = supply * m/(n*n);  // seems to be a good choice

  while (2*delta <= delta_max) delta = 2*delta;

  while (delta > 0)  // delta scaling phase
  {
    forall_edges(e,G)  
    { // Saturate all edges entering the delta residual network which have
      // a negative reduced edge cost. Then only the reverse edge (with positive
      // reduced edge cost) will stay in the residual network. 

      node u = source(e);
      node v = target(e);
      num_type c = cost[e] + pi[u] - pi[v];

      if (cap_minus_flow[e] >= delta && c < 0)
        { excess[v] += cap_minus_flow[e];
          excess[u] -= cap_minus_flow[e];
          flow[e] = cap[e];
          cap_minus_flow[e] = 0;
         }
      else
        if (flow[e] >= delta && c > 0)
        { excess[u] += flow[e];
          excess[v] -= flow[e];
          flow[e] = 0;
          cap_minus_flow[e] = cap[e];
         }

     }


    // As long as there is a node s with excess >= delta compute a minimum
    // cost augmenting path from s to a sink node t with excess <= -delta in 
    // the delta-residual network and augment the flow by at least delta units 
    // along P (if there are nodes with excess > delta and excess < -delta
    // respectively, the existence of P is guaranteed by the artificial edges 
    // inserted at the begining of the algorithm)

    node s;
    node t;
  
    forall_nodes(s,G)
    while (excess[s] >= delta)
    { 
      count++;
  
      t = DIJKSTRA_IN_RESIDUAL(G,s,delta,cost,cap_minus_flow,flow,excess,pi,pred);
      if (t == nil) break; // there is no node with excess < -delta
  
      // compute maximal amount f of flow that can be pushed through P
  
      num_type f = excess[s];
  
      v = t; 
      while (v != s)
      { e = pred[v]; 
        num_type rcap;
        if (v==target(e))
           { rcap = cap_minus_flow[e];
             v = source(e);
            }
        else
           { rcap = flow[e];
             v = target(e);
            }
        if (rcap < f) f = rcap;
       }
  
      if (f > -excess[t]) f = -excess[t];
  
  
      // add f units of flow along the augmenting path 
  
      v = t; 
      while (v != s)
      { e = pred[v]; 
        if (v==target(e))
           { flow[e] += f;
             cap_minus_flow[e] -= f;
             v = source(e);
            }
        else
           { flow[e] -= f;
             cap_minus_flow[e] += f;
             v = target(e);
            }
       }
  
       excess[s] -= f;
       excess[t] += f;
  
    } // end of delta-phase
  
   delta /= 2;
  
  } // end of scaling
  


  // restore negative edges
  forall(e,neg_edges) 
  { flow[e] = cap[e] - flow[e];
    G.rev_edge(e);
   }

  // delete artificial edges
  forall(e,art_edges) G.del_edge(e); 

  // total flow  = total flow out of the source node
  forall_out_edges(e,src) total_flow += flow[e];

  forall_edges(e,G) flow0[e] = flow[e];

  //cout << "count = " << count << endl;

  return total_flow;
}

