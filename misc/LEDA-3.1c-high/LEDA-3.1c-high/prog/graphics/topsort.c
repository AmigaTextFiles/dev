#include <LEDA/graph.h>
#include <LEDA/graph_edit.h>


bool TOPSORT(const graph& G, node_array<int>& ord)
{ 
  node_array<int> cur_indeg(G);

  list<node> zero_indeg;

  int count = 0;

  node v,w;

  forall_nodes(v,G) 
  { cur_indeg[v] = G.indeg(v);
    if (G.indeg(v)==0) 
       zero_indeg.append(v); 
   }

  while ( ! zero_indeg.empty() )
  { 
    count++;

    v = zero_indeg.pop();
  
    ord[v] = count;

    forall_adj_nodes(w,v) 
       if (--cur_indeg[w]==0) zero_indeg.append(w);
   }
  
  return (count==G.number_of_nodes());
}
     




main()
{
  GRAPH<point,int>  G;

  window W;

  for(;;)
  { 
    graph_edit(W,G);

    node_array<int> node_num(G);

    if (TOPSORT(G,node_num)==false)
    { W.acknowledge("Graph is cyclic, cannot sort");
      continue;
     }

    node v;
    forall_nodes(v,G)
       W.draw_int_node(G[v],node_num[v],blue);

   if (W.read_mouse() == 3) break;

  }

  return 0;
}
