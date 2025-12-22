#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


GRAPH<int,int> shortest_path_tree(GRAPH<int,int>& G, edge_array<int>& cost)
{
  // returns a shortest-paths tree  as a subgraph of G

  node_array<int> dist(G);
  node_array<edge> pred(G);

  node s = G.first_node();

  DIJKSTRA(G,s,cost,dist,pred);

  list<edge> el;

  node v;
  forall_nodes(v,G) if (pred[v]!=0) el.append(pred[v]);

  return GRAPH<int,int>(G,G.all_nodes(),el);   // subgraph constructor
}



main()

{ GRAPH<int,int> G;

  test_graph(G);

  edge_array<int> cost(G);

  int a = read_int("a = ");
  int b = read_int("b = ");

  init_random();

  edge e;
  forall_edges(e,G) cost[e] = G[e] = random(a,b);


  GRAPH<int,int> S = shortest_path_tree(G,cost);


  G.print("graph G");
  newline; 

  S.print("subgraph S");
  newline; 


  edge_array<int> cost1(S);

  forall_edges(e,S) cost1[e] = S[e];  

  GRAPH<int,int> S1 = shortest_path_tree(S,cost1);

  S1.print("subgraph S1");
  newline;

return 0;
}
