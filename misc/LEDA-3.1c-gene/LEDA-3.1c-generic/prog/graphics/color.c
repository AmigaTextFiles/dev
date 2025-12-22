#include <LEDA/window.h>


window W(500,500);

void draw_mouse_label(double x, double y)
{ W.draw_text(x,y,"MOUSE","steelblue"); }

main()
{  
  W.init(0,4,0);
  W.set_show_coordinates(false);
  W.clear("grey30");

  for(int i=0;i<16;i++)
  { W.set_line_style(solid);

    int y = 10*(i+1);

    W.draw_disc(i%4+0.5,i/4+0.5,0.45,i);
    W.draw_circle(i%4+0.5,i/4+0.5,0.45,black);
   }

  double x,y; 

  W.read_mouse_action(draw_mouse_label,x,y); 

  return 0;

 }
