#include <LEDA/graph.h>
#include <LEDA/ugraph.h>
#include <LEDA/graph_alg.h>


main(int argc, char** argv)
{

GRAPH<int,int> G;

cmdline_graph(G,argc,argv);

ugraph G2(G);

node_array<int> compnum(G2);
node_array<int> compnum1(G2);

float T = used_time();
cout << "COMPONENTS   ";
cout.flush();
COMPONENTS(G2,compnum);
cout << string("   %6.2f sec \n",used_time(T));
newline;

cout << "COMPONENTS 1 ";
cout.flush();
COMPONENTS1(G2,compnum1);
cout << string("   %6.2f sec \n",used_time(T));


if (Yes("ausgabe?")) 
 { node v;
   forall_nodes(v,G2) 
   { G2.print_node(v);
     cout << string("  c = %3d   c1 = %3d \n", compnum[v],compnum1[v]);
    }
  }
newline;

return 0;
}
