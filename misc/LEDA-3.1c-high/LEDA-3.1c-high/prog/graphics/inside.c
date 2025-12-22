#include <LEDA/plane.h>
#include <LEDA/window.h>

main()

{ window W;


  string   s[5];

  s[0] = "no grid ";
  s[1] = "10 pixel";
  s[2] = "20 pixel";
  s[3] = "30 pixel";
  s[4] = "40 pixel";

  int grid_width = 10 * W.read_panel("GRID MODE ? ",5,s);

  W.clear();

  W.init(0,1000,0, grid_width);
  W.set_node_width(2);


  polygon P;

  W >> P;

  W << P;

  int key;

  double x,y;

  while ((key = W.read_mouse(x,y)) !=3) 
  { point p(x,y);
    W << p; 
    if (key == 1)
    { if (P.inside(p)) W.draw_text(p,"INSIDE");
      else W.draw_text(p,"OUTSIDE");
     }
    else
    { W.clear();
      W << P; 
      int n = W.read_int("n = ");
      while (n--)
      { p = point(random(0,1000),random(0,1000));
        if (P.inside(p)) W.draw_filled_node(p);
        else W << p;
       }
     }
  }

  return 0;
}
