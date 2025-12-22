#include <LEDA/plane.h>
#include <LEDA/interval_set.h>
#include <LEDA/window.h>




main()
{ 
  interval_set<segment>  I;

  window W;

  W.init(-1000,1000,-1000);
  W.set_line_width(1);

  panel P("interval_set");

  P.text_item("Use the left mouse button to insert a set of segments, ");
  P.text_item("terminate the input by clicking the right button. Now, ");
  P.text_item("you can define query slabs by giving two vertical lines");
  P.text_item("with the left mouse button. For each slab, the program ");
  P.text_item("computes and shows all segments intersecting it. Leave ");
  P.text_item("the program by clicking the right mouse button.        ");

  P.button("continue");

  P.open();


  segment s;

  while (W >> s)
  { W << s;
    if (s.xcoord1() <= s.xcoord2())
      I.insert(s.xcoord1(),s.xcoord2(),s);
    else
      I.insert(s.xcoord2(),s.xcoord1(),s);
   }

  W.set_mode(xor_mode);

  list<is_item> L;
  is_item it;
  double    x0 = W.xmin();
  double    x1 = W.xmin();

  point   p;

  while (W >> p)
  { 
    W.draw_vline(x0);
    W.draw_vline(x1);

    W.set_line_width(4);
    forall(it,L) W << I.inf(it);
    W.set_line_width(1);
    forall(it,L) W << I.inf(it);

    x0 = p.xcoord();
    W.draw_vline(x0);

    W >> p;
    x1 = p.xcoord();
    W.draw_vline(x1);

    L = I.intersection(x0,x1);

    forall(it,L) W << I.inf(it);
    W.set_line_width(4);
    forall(it,L) W << I.inf(it);
    W.set_line_width(1);

    forall(it,L) cout << I.inf(it) << "\n";
    newline;

  }

  return 0;
}
