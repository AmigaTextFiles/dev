#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>



main()
{

GRAPH<int,int> G;

test_graph(G);

node_array<int> compnum(G);

float T;

cout << "STRONG_COMPONENTS    ";
cout.flush();
T = used_time();
STRONG_COMPONENTS(G,compnum);
cout << string("    %6.2f sec\n",used_time(T));
newline;

if (Yes("Ausgabe?")) 
 { node v;
   forall_nodes(v,G) 
   { G.print_node(v);
     cout << string("  comp = %3d \n", compnum[v]);
    }
  }
newline;

return 0;
}
