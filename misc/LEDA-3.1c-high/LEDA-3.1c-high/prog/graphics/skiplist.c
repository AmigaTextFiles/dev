#include <LEDA/impl/skiplist.h>
#include <LEDA/window.h>
 
main()
{ 
  window W;
  skiplist SKIP;
  skiplist_item p;
 
  int  N = W.read_int("# keys = ");
 
  if (W.confirm("random"))
    { init_random();
      while(N--)  SKIP.insert(GenPtr(random(0,MAXINT-1)),0);
     }
  else
    while(N--)  SKIP.insert(GenPtr(N),0);
 
  W.init(0,2+SKIP.size(),0);
  float d = W.ymax()/8;

  W.set_line_style(dashed);
  for(int i = 1; i<8; i++) W.draw_hline(i*d);

  W.set_line_style(solid);
 
  for(p = SKIP.first_item(),i=1; p; p= SKIP.next_item(p),i++)
       W.draw_segment(i,0,i,d*(1+SKIP.get_level(p)));

  W.read_mouse();
   

  return 0;
}
