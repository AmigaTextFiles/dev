#include <LEDA/graph.h>
#include <LEDA/ugraph.h>
#include <LEDA/graph_alg.h>


main()
{

UGRAPH<int,int> G;

test_ugraph(G);

edge_array<int> compnum(G);

float T = used_time();
cout << "BI_COMPONENTS   ";
cout.flush();
int n = BICONNECTED_COMPONENTS(G,compnum);
cout << string("   %6.2f sec \n",used_time(T));
newline;

cout << n << " components\n";
newline;

if (Yes("ausgabe?")) 
 { edge e;
   forall_edges(e,G) 
   { G.print_edge(e);
     cout << string("  c = %3d  \n", compnum[e]);
    }
  }
newline;

return 0;
}
