/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _maxflow.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/




#include <LEDA/graph_alg.h>
#include <math.h>


static void gt_bfs(node s_vert, int dist_s_vert, 
                   const graph& G, node s, 
                   const edge_array<num_type>& flow,
                   const edge_array<num_type>& cap,
                         node_data<int>& dist);


num_type MAX_FLOW(graph& G, node s, node t, const edge_array<num_type>& cap, 
                                                  edge_array<num_type>& flow)
{

/* Computes a maximum flow from source s to sink t, using the
   Goldberg-Tarjan algorithm [Journal ACM 35 (Oct 1988) p921-940].
   ( Applies push steps to vertices with positive preflow, based on 
     distance labels.  Uses FIFO rule (implemented by FIFO queue) 
     for selecting a vertex with +ve preflow. )

   input:   cap[e]  gives capacity of edge e 
 
   output:  flow[e] flow on edge e
            returns total flow into sink

   node_arrays used by the algorithm:
   dist[v]   = lower bound on shortest distance from v to t
   excess[v] = (total incoming preflow[v]) - (total outgoing preflow[v])

   Implemented by  Joseph Cheriyan & Stefan Naeher.
*/

node_data<int> dist(G,0);

node_array<num_type>  excess(G,0);

node_list U;   // FIFO Queue used for selecting vertex with positive preflow
node v,w;
edge e;

int N = G.number_of_nodes();

/*
 heuristic: parameter for heuristic suggested by Goldberg to speed up algorithm 
            compute exact distance labels after every "heuristic" relabel steps

            experiments indicate that sqrt(|E|) is a good choice  (S.N.)
*/

int heuristic = int(sqrt(G.number_of_edges()));

int limit_heur   = heuristic;
int num_relabels = 0;

if (s == t) error_handler(1,"MAXFLOW: source == sink");
 
forall_edges(e,G) flow[e] = 0;

forall_out_edges(e,s) // saturate all edges leaving from s
{ v = target(e);
  if (excess[v] == 0 && v!=s) U.append(v);
  flow[e] = cap[e];
  excess[v] += cap[e];
 }
 
dist[s] = N;

while (! U.empty() )      /* main loop */
{ 
  v = U.pop();

  if (v == t) continue;

  int dv = dist[v];

  num_type ev = excess[v];

  // push flow along each edge e = (v,w) in the residual graph with
  // dist[v] == dist[w] + 1

  if (dv < N)
   forall_out_edges(e,v)
   { if (ev <= 0) break;
     w = target(e);
     if (dv == dist[w]+1)
     { num_type delta = cap[e]-flow[e];
       if (delta > 0)
       { if (ev < delta) delta = ev;
         if (excess[w] == 0) U.append(w);
         flow[e] += delta;
         excess[w] += delta;
         ev -= delta;
        }
      }
    }

  forall_in_edges(e,v)
  { if (ev <= 0) break;
    w = source(e);
    if (dv == dist[w]+1)
    { num_type delta = flow[e];
      if (delta > 0)
      { if (ev < delta) delta = ev;
        if (excess[w] == 0 && w != s ) U.append(w);
        flow[e] -= delta;
        excess[w] += delta;
        ev -= delta;
       }
     }

    } 

  excess[v] = ev;
  
  if (ev > 0)
  {
    // relabel vertex v (i.e. update dist[v]) because all
    // admissible edges in the residual graph have been saturated 

    num_relabels++;
  
    if (heuristic && (num_relabels == limit_heur))
      { 
        // heuristic suggested by Goldberg to reduce number of relabels:
        // periodically compute exact dist[] labels by two backward bfs 
        // one starting at t and another starting at s

        limit_heur += heuristic;

       node x;
       forall_nodes(x,G) dist[x] = MAXINT;

       gt_bfs(t,0,G,s,flow,cap,dist);
       gt_bfs(s,N,G,s,flow,cap,dist);
      }
    else
      { 
        int min_dist = MAXINT;

        forall_out_edges(e,v)
          if (cap[e] > flow[e] && dist[v] < N)
            //pushes towards s that increase flow[e] are not allowed
            min_dist = Min(min_dist,dist[target(e)]);

        forall_in_edges(e,v)
          if (flow[e] > 0)
            min_dist = Min(min_dist,dist[source(e)]);

        if (min_dist != MAXINT) min_dist++;
        dist[v] = min_dist;
       }

    if (! U.member(v) ) U.push(v);    
     
  } // if (excess[v] > 0)

}  // while (!U.empty())  
       
   

/*
// code to verify that flow is legal
num_type total_s_cap = 0;
forall_out_edges(e,s)  total_s_cap += cap[e];
if (total_s_cap != (excess[s] + excess[t]))
   error_handler(999,"gt_max_flow: total out cap s != excess[s] + excess[t]");
*/

return excess[t];  // value of maximum flow from s to t
  
}




//procedure to perform backward bfs starting at vertex s_vert with 
//distance label dist_s_vert

static
void gt_bfs(node s_vert, 
            int dist_s_vert, 
            const graph& G, 
            node s, 
            const edge_array<num_type>& flow,
            const edge_array<num_type>& cap, 
            node_data<int>& dist)
{ 
  node_queue Q;

  Q.append(s_vert);
  dist[s_vert] = dist_s_vert;

  while (! Q.empty() )
  { 
    node x = Q.pop();
    int  d = dist[x] + 1;

    edge e;
    forall_out_edges(e,x)
    { node y = target(e); 
      if (flow[e] > 0 && dist[y] == MAXINT) // use only edges with positive flow
      { dist[y] = d;
        Q.append(y);
        if (y == s) dist[y] = G.number_of_nodes();
       }
     }

    forall_in_edges(e,x)
    { node y = source(e); 
      if (cap[e] > flow[e] && dist[y] == MAXINT &&  s_vert != s)
      { dist[y] = d;
        Q.append(y);
        if (y == s) dist[y] = G.number_of_nodes();
       }
     }

   } // while Q not empty
}

