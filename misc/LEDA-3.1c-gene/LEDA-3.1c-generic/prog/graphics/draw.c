#include <LEDA/plane.h>
#include <LEDA/window.h>

main()
{
  window W;

  line_style lstyle = solid;
  int        lwidth = 1;
  color      col    = black;
  bool       fill   = false;

  panel P("DRAW");

  P.bool_item  ("fill",fill);
  P.color_item ("color",col);
  P.lstyle_item("line style",lstyle);
  P.int_item   ("line width",lwidth,1,10);

  P.button("point");
  P.button("segment");
  P.button("line");
  P.button("circle");
  P.button("poly");
  P.new_button_line();
  P.button("clear");
  P.button("continue");
  P.button("quit");

  int but = 5;

  for(;;)
  {
    int i = P.open(W);

    W.set_line_width(lwidth);
    W.set_line_style(lstyle);

    if (i!=6) but = i;

    switch(but) {


    case 0: { point p;
              while (W >> p)  W.draw_point(p,col);
              break;
             }
    case 1: { segment s;
              while (W >> s)  W.draw_segment(s,col);
              break;
             }
    case 2: { line l;
              while (W >> l)  W.draw_line(l,col);
              break;
             }
    case 3: { circle c;
              while (W >> c)  
                if (fill) W.draw_disc(c,col);
                else      W.draw_circle(c,col);
              break;
             }
    case 4: { polygon P;
              while (W >> P)  
                if (fill) W.draw_filled_polygon(P,col);
                else      W.draw_polygon(P,col);
              break;
             }

    case 5: W.clear();
            break;

    case 7: exit(0);

    }

  }

  return 0;
}
