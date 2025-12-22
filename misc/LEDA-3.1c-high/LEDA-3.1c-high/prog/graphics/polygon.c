#include <LEDA/plane.h>
#include <LEDA/window.h>

main()

{ window W;

  W.init(-1000,1000,-1000);

  panel p("polygon");

  p.text_item("This program demonstrates the intersection operation  ");
  p.text_item("for simple polygons (data type polygon). Use the left ");
  p.text_item("mouse button to define the vertex sequence of a simple");
  p.text_item("polygon P in clockwise order. Terminate the input with");
  p.text_item("the middle button. Now, for each next drawn polygon Q ");
  p.text_item("the intersection with P (list of polygons) is computed");
  p.text_item("and displayed. Terminate the program by clicking the  ");
  p.text_item("right button.");

  p.button("continue");

  p.open();



  polygon P,Q,R;

  W >> P;

  W.draw_polygon(P,blue);


  W.set_mode(xor_mode);

  list<polygon> L;

  while (W >> Q)
  { forall(R,L) W.draw_filled_polygon(R,red);
    L = P.intersection(Q);
    forall(R,L) W.draw_filled_polygon(R,red);
   }

 return 0;

}
