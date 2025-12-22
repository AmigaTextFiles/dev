#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>


main(int argc, char** argv)
{

GRAPH<int,int>  G;

cmdline_graph(G,argc,argv);

edge x;
forall_edges(x,G) G[x] = random(0,1000000);

edge_array<int>     cost1(G);
edge_array<double>  cost2(G);

forall_edges(x,G) cost2[x] = cost1[x] = G[x];


UGRAPH<int,int> U = G;

edge_array<int>   cost3(U);

forall_edges(x,U) cost3[x] = U[x];


list<edge> el;

float T;

cout << "SPANNING_TREE:             ";
cout.flush();
T = used_time();
el = SPANNING_TREE(G);
cout << string(" %5.2f sec   |T| = %d",used_time(T),el.length());
newline;

if (Yes("Print tree edges ? ")) 
 forall(x,el) { G.print_edge(x); newline; }

el.clear();

cout << "MIN_SPANNING_TREE(int):    ";
cout.flush();
T = used_time();
el = MIN_SPANNING_TREE(G,cost1);
cout << string(" %5.2f sec   |T| = %d",used_time(T),el.length());

int total1 = 0;
forall(x,el)  total1 += cost1[x];

cout << string("   total cost %d\n",total1);

if (Yes("Print tree edges ? ")) 
 forall(x,el) { G.print_edge(x); newline; }


el.clear();

cout << "MIN_SPANNING_TREE(ugraph): ";
cout.flush();
T = used_time();
el = MIN_SPANNING_TREE(U,cost3);
cout << string(" %5.2f sec   |T| = %d",used_time(T),el.length());

total1 = 0;
forall(x,el)  total1 += cost3[x];

cout << string("   total cost %d\n",total1);

if (Yes("Print tree edges ? ")) 
 forall(x,el) { G.print_edge(x); newline; }



cout << "MIN_SPANNING_TREE(double): ";
cout.flush();
T = used_time();
el = MIN_SPANNING_TREE(G,cost2);
cout << string(" %5.2f sec   |T| = %d",used_time(T),el.length());

double total2 = 0;
forall(x,el)  total2 += cost2[x];

cout << string("   total cost %f\n",total2);

if (Yes("Print tree edges ? ")) 
 forall(x,el) { G.print_edge(x); newline; }


return 0;
}
