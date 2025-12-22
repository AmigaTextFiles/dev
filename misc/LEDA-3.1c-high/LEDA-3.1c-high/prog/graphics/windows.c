#include <LEDA/window.h>


main()
{
   // we open five windows w1, w2, w3, w4, and w5
   // for points, segments, lines, and circles
   // w5 is used as a log-window

   window w1(550,410,window::min,window::min,"DRAW POINTS");
   window w2(550,410,window::max,window::min,"DRAW SEGMENTS");
   window w3(550,410,window::min,window::max,"DRAW LINES");
   window w4(550,410,window::max,window::max,"DRAW CIRCLES");
   window w5(160,480,window::center,window::center,"CENTER WINDOW");

   w5.set_show_coordinates(false);

   double  x,y;
   point   p;
   segment s;
   line    l;
   circle  c;

   window* w;


   // wait for mouse click and get pointer to the corresponding window 

   while(read_mouse(w,x,y) != 3)  
   { 
     if (w == &w1) // draw points
     { put_back_event();
       w1 >> p;
       w1.draw_point(p,blue);
       w5.message("w1: point");
       continue;
      }

     if (w == &w2) // draw segments
     { put_back_event();
       w2 >> s;
       w2.draw_segment(s,violet);
       w5.message("w2: segment");
       continue;
      }

     if (w == &w3) // draw lines
     { put_back_event();
       w3 >> l;
       w3.draw_line(l,green);
       w5.message("w3: line");
       continue;
      }

     if (w == &w4) // draw circles
     { put_back_event();
       w4 >> c;
       w4.draw_circle(c,orange);
       w5.message("w4: circle");
       continue;
      }

     if (w == &w5) // clear log-window
     { w5.clear();
       continue;
      }

    }

   return 0;
}
