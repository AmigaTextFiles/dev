#include <LEDA/window.h>
#include <math.h>

// this program demonstrates the use of the "read_event" operation

main()
{
  window W;

  W.set_mode(xor_mode);

  int    key;
  double x,y,x0,x1,y0,y1,r1;

  for(;;)
  { 
    int b = W.read_mouse(x0,y0);   // read start corner (x0,y0)

    if (b == 3) break;  
  
    x1 = x0;
    y1 = y0;
    r1 = 0;
  
    if (b == 1)
    { // while button is down draw rectangle from (x0,y0) 
      // to current mouse position 

      while (W.read_event(key,x,y) != button_release_event) 
      { 
        W.draw_rectangle(x0,y0,x1,y1,blue);  // erase old rectangle (xor_mode!)
        W.draw_rectangle(x0,y0,x,y,blue);    // draw new rectangle
        x1 = x;
        y1 = y;
       }
     }


    if (b == 2)
    { // while button is down draw circle with center (x0,y0) 
      // to current mouse position 
    
      while (W.read_event(key,x,y) != button_release_event) 
      { 
        double r = hypot(x1-x0,y1-y0);
        W.draw_circle(x0,y0,r1,red);  // erase old circle (xor_mode!)
        W.draw_circle(x0,y0,r,red);    // draw new circle
        x1 = x;
        y1 = y;
        r1 = r;
       }
     }

  
   }

  return 0;
}
