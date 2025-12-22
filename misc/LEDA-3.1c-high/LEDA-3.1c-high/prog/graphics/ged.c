#include <LEDA/graph_edit.h>

main(int argc, char** argv)
{
  window W;
  GRAPH<point,int> G;

  if (argc > 1) G.read(argv[1]);

  graph_edit(W,G);

  if (argc > 1)
   if (W.confirm(string("write graph back to file %s",argv[1]))) 
     G.write(argv[1]);

  return 0;
}
