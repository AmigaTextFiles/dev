#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


main(int argc,char** argv)
{


node v;
int  i = 0;

GRAPH<int,int> G;

cmdline_graph(G,argc,argv);

node_array<int> xcoord(G), ycoord(G);


cout << "Planarity Test ... " << flush;

float T = used_time();

bool plan = PLANAR(G);  

cout << string(" time = %.2f sec", used_time(T)) << endl;

if (plan)  
    cout << "Graph is planar" << endl;
else
   { cout << "Graph is not planar." << endl;
     cout << "I compute a a Kuratowsky Subgraph ..." << endl;
     list<edge> L;
     PLANAR(G,L);  
     newline;
     edge e;
     forall(e,L) 
     { G.print_edge(e);
       newline;
     }
     newline;
    }

  return 0;

}
