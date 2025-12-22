#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


main()
{

GRAPH<int,int> G;

int n = read_int("n = ");

random_planar_graph(G,n);

list<edge> el = G.all_edges();
edge e;
forall(e,el) G.new_edge(target(e),source(e));

if ( ! PLANAR(G,true) )
 { cout << "Graph is not planar\n";
   exit(1);
  }

node v;
node a,b,c;
node_array<int> x(G),y(G);

float T = used_time();

cout << "OLD EMBEDDING       ";
cout.flush();
STRAIGHT_LINE_EMBEDDING(G,x,y);
cout << string("%6.2f sec  \n",used_time(T));

cout << "NEW EMBEDDING       ";
cout.flush();
STRAIGHT_LINE_EMBEDDING2(G,a,b,c,x,y);
cout << string("%6.2f sec  \n",used_time(T));

/*
forall_nodes(v,G) cout << string("x = %2d    y = %2d\n",x[v],y[v]);
*/

 return 0;

}
