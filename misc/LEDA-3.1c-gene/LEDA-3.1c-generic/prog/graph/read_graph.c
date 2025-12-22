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

  int n = G.read(read_string("read graph from file: "));

  cout << "n = " << n << "\n";

  G.print();

  return 0;
}
