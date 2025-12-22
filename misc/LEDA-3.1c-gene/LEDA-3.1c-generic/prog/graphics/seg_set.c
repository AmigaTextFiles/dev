#include <LEDA/segment_set.h>
#include <LEDA/plane.h>
#include <LEDA/window.h>

#include <math.h>




main()
{ 
  segment s,x;

  window W;

  W.init(-1000,1000,-1000);

  W.set_line_width(1);

  panel P("SEGMENT SET");
  
  P.text_item("Use the left mouse button to insert a set of segments, ");
  P.text_item("all with the same orientation. Terminate the input by  ");
  P.text_item("clicking the right button. During input, the segments  ");
  P.text_item("are rotated to be parallel to the first read segment.  ");
  P.text_item("Now you can input orthogonal query segments, for each  ");
  P.text_item("of which the set of intersected segments is computed   ");
  P.text_item("and displayed. To leave the program, click the right   ");
  P.text_item("mouse button.                                          ");
  P.text_item("                                                       ");

  P.button("continue");

  P.open();


  W >> s;
  W << s;

  double alpha = s.angle();

  segment_set<double> S(alpha);

  S.insert(s,s.xcoord1());

  while (W >> s)
  { point p = s.start();
    point q = p.translate(alpha,s.length());
    s = segment(p,q);
    W << s;
    S.insert(s,s.xcoord1());

/*
    W.set_line_style(dashed);
    W<< s.rotate(point(0,0),-alpha);
    W.set_line_style(solid);
*/
   }

  W.set_mode(xor_mode);

  list<seg_item> L;
  seg_item it;
  point p;

  s = segment(W.xmin(),W.ymin(),W.xmax(),W.ymin());

  while (W >> p)
  { double x,y;

    // erase previously found segments
    W.set_line_width(4);
    forall(it,L) W << S.key(it);
    W.set_line_width(1);
    forall(it,L) W << S.key(it);


    W << s;

    W.read_mouse_seg(p.xcoord(),p.ycoord(),x,y);

    point q(x,y);

    q = p.translate(alpha+M_PI_2,p.distance(q));
   
    s = segment(p,q);

    W << s;

    L = S.intersection(s);

    forall(it,L) W << S.key(it);
    W.set_line_width(4);
    forall(it,L) W << S.key(it);

    forall(it,L) 
      cout << "key = " << S.key(it) << "  info = " << S.inf(it) << "\n";
    newline;


  }


  return 0;
}
