#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


main()
{

GRAPH<int,int> G;
node u;
edge e;

test_graph(G);

edge_array<int>  cost(G,0);
node_array<int>  dist(G,0);
node_array<edge> pred(G,nil);
node_array<int>  label(G,0);

int mi = read_int("min cost = ");
int ma = read_int("max cost = ");

forall_edges(e,G) cost[e] = G[e] = random(mi,ma);

node s = G.first_node();

float T = used_time();

cout << "BELLMAN_FORD <int>  " << flush;
bool b = BELLMAN_FORD(G,s,cost,dist,pred);
cout << string("%6.2f sec  ",used_time(T)) << endl;
newline;


if (b == false)
  { cout << "Negative cycle:" << endl;
    int count = 1;
    forall_nodes(u,G)
    { if (label[u] == 0)
       { while (label[u]==0)
         { label[u]=count;
           u=source(pred[u]);
          }
         if (label[u] == count)  // cycle found
         { list<edge> cycle;
           for(e=pred[u]; source(e)!=u; e=pred[source(e)]) cycle.push(e);
           cycle.push(e);
           forall(e,cycle)
           { G.print_edge(e);
             newline;
            }
           newline;
          }
        }
      count++;
     }
   }
else
  cout << "No negativ cycle found" << endl;

return 0;

}
