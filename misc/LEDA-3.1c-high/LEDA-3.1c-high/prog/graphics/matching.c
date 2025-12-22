#include <LEDA/graph_edit.h>
#include <LEDA/graph_alg.h>


main()
{ 
  GRAPH<point,int> G;
  window W;
  edge e;

  W.set_line_width(1);
  W.set_node_width(12);

  graph_edit(W,G,false);

  for(;;)
  { 
    list<edge> L = MAX_CARD_MATCHING(G);

    // show matching
    W.set_line_width(5);
    forall(e,L) W.draw_edge(G[source(e)],G[target(e)]);       

    W.message("MAX_CARD_MATCHING");
    W.message("(press left button to return to graph edit)");
    if (W.read_mouse() != 1) break;
    W.del_message();

    // restore picture
    forall(e,L) W.draw_edge(G[source(e)],G[target(e)],white); 
    W.set_line_width(1);
    forall(e,L) W.draw_edge(G[source(e)],G[target(e)]);

    graph_edit(W,G,false,false);     // 2nd false: do not clear window
 
   }

  return 0;
}
