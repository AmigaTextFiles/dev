#include <LEDA/graph_alg.h>

main(int argc, char** argv)
{
  graph G;

  cmdline_graph(G,argc,argv);

  float T = used_time();

  cout << "MAX_CARD_MATCHING (heur=1)           ";
  cout.flush();
  list<edge> M = MAX_CARD_MATCHING(G,1);
  cout << string("time %.2f sec    |M| = %d\n",used_time(T), M.length());

  cout << "MAX_CARD_MATCHING (heur=2)           ";
  cout.flush();
  M = MAX_CARD_MATCHING(G,2);
  cout << string("time %.2f sec    |M| = %d\n",used_time(T), M.length());

  return 0;
}
