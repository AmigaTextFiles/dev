#include <LEDA/graph.h>
#include <LEDA/graph_edit.h>
 
 
void compute_depth(graph& G, node_array<int>& depth)
{
  // reverse all edges and compute longest paths in topological order
  // starting in nodes with indegree 0
  // PRECONDITION: G is acyclic
 
  G.rev();  
 
  node_array<int>  degree(G);
  list<node>       zero_deg;
  node v;
  edge e;
  int  count = 0;
 
  forall_nodes(v,G)
  { depth[v] = 0;
    degree[v] = G.indeg(v);
    if (G.indeg(v) == 0) zero_deg.append(v);
   }
 
  while(! zero_deg.empty())
  { count++;
    v = zero_deg.pop();
    forall_adj_edges(e,v)
    { int  d = depth[v];
      node w = G.target(e);
      if (depth[w] < d+1) depth[w] = d+1;
      if (--degree[w] == 0) zero_deg.append(w);
     }
   }

  if (count < G.number_of_nodes()) 
  { cerr << "Error: cyclic graph\n";
    exit(1);
   }

  G.rev();  // restore original graph
}
 
 
main()
{ 
  GRAPH<point,int> G;
  window W;
  node v;
  edge e;
 
  for(;;)
  { G.clear();
    graph_edit(W,G);
    node_array<int> depth(G);
 
    compute_depth(G,depth);
 
    W.clear();
    forall_nodes(v,G) W.draw_text_node(G[v],string("%d",depth[v]));
    forall_edges(e,G) W.draw_edge_arrow(G[source(e)],G[target(e)]);
 
    if (W.read_mouse() == 3) break;
  }
 
 return 0;
}
