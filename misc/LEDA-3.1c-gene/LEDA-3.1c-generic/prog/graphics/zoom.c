#include <LEDA/plane.h>
#include <LEDA/window.h>

main()
{
  window W;
  W.init(-100000000, 100000000, -100000000);

  int n =  W.read_int("n = ");

  list<segment> L;
 
  point c(0,0);
  segment s;

  double r = 1000000000;
  double alpha = 0;
  double d = 2*M_PI/n;

  for(int i = 0; i<n; i++)
  { point p(random(-10,+10),random(-10,+10));
    s = segment(p,c.translate(alpha,r));
    L.append(s);
    alpha += d;
   }

  forall(s,L) W << s;

  point p,q;

  for(;;)
  { if (W.read_mouse(p)==3) break;
    W.read_mouse_rect(p,q);
    W.init(p.xcoord(),q.xcoord(),p.ycoord());
    forall(s,L) W << s;
  }


  return 0;
}
  
