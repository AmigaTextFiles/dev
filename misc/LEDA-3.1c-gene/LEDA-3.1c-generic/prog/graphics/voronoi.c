#include <LEDA/voronoi.h>
#include <LEDA/subdivision.h>
#include <LEDA/window.h>





main()
{

  window W;

  W.init(0,1000,0);

  int node_width = 4;
  int line_width = 1;
  int input = 1;
  int grid_width = 0;
  int N = 100;

  panel P("VORONOI");

  P.text_item("This program computes the Voronoi diagram for a set  "); 
  P.text_item("of point sites S in the plane. There are two ways of ");
  P.text_item("defining set S. Mouse input: Use the left button to  ");
  P.text_item("insert a sequence of points and terminate the input  ");
  P.text_item("by clicking the right button. Random input: Give the ");
  P.text_item("number of random points to be created by the program.");
  P.text_item("The Voronoi diagram Vor(S) is computed and shown. Now");
  P.text_item("you can define query points with the left button, for");
  P.text_item("each of which a point location in Vor(S) is performed.");
  P.text_item("Terminate the program by clicking the right button.  "); 
  P.text_item("                                                     ");

  P.choice_item("INPUT",input,"RANDOM","MOUSE");

  P.int_item("GRID",grid_width,0,40,10);
  P.int_item("SITES",N);
  P.int_item("node width",node_width,1,10);
  P.int_item("line width",line_width,1,5);

  P.open(W);


  W.set_node_width(node_width);
  W.set_line_width(line_width);

  double x, y;
  point c;

  double R = 1000;  // length of the "infinite rays"

  list<point> sites;


  W.clear();

  if (input)
  { W.init(0,1000,0,grid_width);
    while ( W >> c ) 
    { W << c;
      sites.append(c);
     }
   }
  else 
   { init_random();
     while (N--)
     { c = point(random(100,900),random(100,900));
       W << c;
       sites.append(c);
     }
   }

  cout << "Computing Voronoi diagram\n";
  newline;

  edge e;

  GRAPH<point,point> G;

  VORONOI(sites,R,G);


  // Draw Graph

  forall_edges(e,G) W.draw_segment(G[source(e)], G[target(e)]);

  cout << "Computing subdivision\n";
  newline;
  
  subdivision<point> S(G);


  // locate points

  W.message("Give query points!");


  W.set_mode(xor_mode);
  face f = nil;

  while (W.read_mouse(x,y)!=3)
  { if (f!=nil)                      // delete previously located site
      W.draw_filled_node(S.inf(f));
  
    f = S.locate_point(point(x,y));
  
    W.draw_filled_node(S.inf(f));
    cout << S.inf(f);
    newline;
   }

  return 0;
}
