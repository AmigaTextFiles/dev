#include <LEDA/ugraph.h>
#include <LEDA/stream.h>


main(){

GRAPH<int,int> G;

int N = read_int("N = ");

grid_graph(G,N);

edge e;
forall_edges(e,G) G[e] = random(0,100);

node v;
forall_nodes(v,G) G[v] = index(v);

G.write(string("grid%d.graph",N));


// write Lauther's format:

file_ostream lauther(string("grid%d",N));

lauther << index(G.first_node());
lauther << " ";
lauther << index(G.last_node());
lauther << endl;

forall_nodes(v,G)
{ forall_adj_edges(e,v)
  { lauther << index(v) << " ";
    lauther << index(target(e)) << " "; 
    lauther << G[e];
    lauther << endl;
   }
 }

}
