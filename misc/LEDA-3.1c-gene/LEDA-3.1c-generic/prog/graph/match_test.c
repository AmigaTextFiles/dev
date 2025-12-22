
#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


edge_array<int>* W;

int EDGE_CMP(edge& e1, edge& e2)
{ return (*W[e1]-*W[e2]); }

main()
{

GRAPH<int,int> G;
list<node> A,B;
edge e;

test_bigraph(G,A,B);


edge_array<int> weight(G);

W = &weight;

if (Yes("random edge weights from [a..b] ? "))
 { int a = read_int("a = ");
   int b = read_int("b = ");
   init_random();
   forall_edges(e,G) G[e] = random(a,b);
  }
else
 forall_edges(e,G)
   { G.print_edge(e);
     G[e] = read_int("  w = ");
    }

forall_edges(e,G) weight[e] = G[e];

if (Yes("show graph ? ")) G.print();

list<edge> M1 = MAX_WEIGHT_BIPARTITE_MATCHING(G,A,B,weight);

forall(e,M1) { G.print_edge(e); newline; }
newline;


G.sort_edges(EDGE_CMP);

int i = 0;
forall_edges(e,G) G[e] = weight[e] = i++;
if (Yes("show graph? ")) G.print();

list<edge> M2 = MAX_WEIGHT_BIPARTITE_MATCHING(G,A,B,weight);

forall(e,M2) { G.print_edge(e); newline; }
newline;

return 0;
}
