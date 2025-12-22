#include <LEDA/graph.h>


void Read(GRAPH<float,float>& G, istream& is) { G.read(is); }

void Print(const GRAPH<float,float>& G, ostream& os) { G.write(os); }

int compare(const GRAPH<float,float>&, const GRAPH<float,float>&) { return 0; }

#if !defined(__TEMPLATE_FUNCTIONS__)
typedef GRAPH<float,float> ff_graph;
LEDA_TYPE_PARAMETER(ff_graph)
#endif


main()
{
  GRAPH<GRAPH<float,float>,string> G;

  test_graph(G);

  int  i = 0;
  node v; 

  forall_nodes(v,G) 
  { node x = G[v].new_node(17.5); 
    node y = G[v].new_node(13.7); 
    G[v].new_edge(x,y,0.1234);
   }

  i = 0;
  edge e;
  forall_edges(e,G) G[e] = string("v%d",i++);

  G.write(read_string("write graph to file: "));

  return 0;
}
