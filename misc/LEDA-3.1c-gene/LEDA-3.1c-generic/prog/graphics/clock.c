#include <LEDA/window.h>
#include <time.h>
#include <math.h>

const char* month[] =
{ "Januar",
  "Februar",
  "Maerz",
  "April",
  "Mai",
  "Juni",
  "Juli",
  "August",
  "September",
  "Oktober",
  "November",
  "Dezember"
 };


float radius;
float mx,my;
int   h;
int   m;
int   s;

string  datum;

window* Wp;

color face_color   = white;
color text_color   = black;
color min_color    = white;
color hour_color   = white;
bool  seconds      = false;

list<point> make_hand(float rad, float l1, float l2,float pos)
{ circle c(mx,my,rad);
  float  phi = 2*M_PI*pos/60;
  point  p(mx+l1*sin(phi),my+l1*cos(phi));
  double l = c.left_tangent(p).direction();
  double r = c.right_tangent(p).direction();

  list<point> L;
  L.append(p);
  L.append(p.translate(l,l2));
  L.append(p.translate(r,l2));

  return L;
}


void hour_hand(float pos,int mode)
{ 
  float  length = 0.65 * radius;
  color      bg = (hour_color == black) ? white : black;
  list<point> P = make_hand(radius/11,length,1.3*length,pos);

  if (mode==0) // erase
    { Wp->draw_filled_polygon(P,face_color);
      Wp->draw_polygon(P,face_color);
     }
  else         // draw
    { Wp->draw_filled_polygon(P,hour_color);
      Wp->draw_polygon(P,bg);
     }
}

void min_hand(float pos,int mode)
{ 
  float  length = 0.95*radius;
  color      bg = (min_color == black) ? white : black;
  list<point> P = make_hand(radius/13,length,1.20*length,pos);

  if (mode==0) // erase
    { Wp->draw_filled_polygon(P,face_color);
      Wp->draw_polygon(P,face_color);
     }
  else         // draw
    { Wp->draw_filled_polygon(P,min_color);
      Wp->draw_polygon(P,bg);
      Wp->draw_disc(mx,my,radius/35,bg);
     }
}

void sec_hand(float pos)
{ 
  float  length = 0.95*radius;
  color      bg = (min_color == black) ? white : black;
  list<point> P = make_hand(radius/60,length,1.15*length,pos);

  Wp->set_mode(xor_mode);
  Wp->draw_filled_polygon(P,orange);
  Wp->set_mode(src_mode);
  Wp->draw_disc(mx,my,radius/35,bg);
}


void draw_clock()
{ 
  int i;
  float x,y;

  mx = (Wp->xmax()-Wp->xmin())/2;
  my = (Wp->ymax()-Wp->ymin())/2;

  radius = (mx < my) ? 0.9*mx : 0.9*my;

  Wp->clear();

  Wp->draw_disc(mx,my,1.1*radius,face_color);
  Wp->draw_circle(mx,my,1.1*radius,black);

  for(i = 1; i<=12; i++)
  { x = mx + radius*sin(2*M_PI*i/12);
    y = my + radius*cos(2*M_PI*i/12);
    Wp->draw_disc(x,y,radius/30,text_color);
   }

  long clock; 
  time(&clock);
  tm* T = localtime(&clock);

  s = T->tm_sec;
  m = T->tm_min;
  h = T->tm_hour;

  datum = string("%d. %s 19%0d",T->tm_mday,month[T->tm_mon], T->tm_year%100);

  Wp->set_frame_label(datum);

  hour_hand(5*(h+m/60.0),1);
  min_hand(m,1);

  if (seconds) sec_hand(s);

}


void move_hands(int hour, int min, int sec)
{ 
  if (seconds && sec != s) sec_hand(s);

  if (min != m || hour != h)
  { min_hand(m,0);
    hour_hand(5*(h+m/60.0),0);
    hour_hand(5*(hour+min/60.0),1);
    min_hand(min,1);
   }

  if (seconds && sec != s) sec_hand(sec);

  s = sec;
  m = min;
  h = hour;
 }


void sync_time()
{ long clock; 
  time(&clock);
  tm* T = localtime(&clock); 

  while (T->tm_sec > 50)
  { sleep(1);
    time(&clock);
    T = localtime(&clock); 
   } 

  move_hands(T->tm_hour,T->tm_min,T->tm_sec);

  if (h+m+s == 0) 
  { datum = string("%d. %s 19%0d",T->tm_mday,month[T->tm_mon], T->tm_year%100);
    Wp->set_frame_label(datum);
   }

 }


void demo()
{ for(int h = 0; h < 12; h++)
     for(int m = 0; m < 60; m++)
       for(int s = 0; s < 60; s++)
          move_hands(h,m,s);
 }


#if defined(__MSDOS__)
int wait_a_second()
{ long clock; 
  time(&clock);
  long clock1 = clock; 
  while (clock1 == clock && Wp->get_button() == 0) time(&clock1);
  return (clock1 == clock);
}
#else
int wait_a_second()
{ usleep(950000);
  //sleep(1);
  return Wp->get_button();
}
#endif


main(int argc, char** argv)
{  
  int height = window::screen_height()/2;
  int width  = height;
  int xpos   = 0;
  int ypos   = 0;

  if (argc > 1)
  { if (argc == 3)
      { width  = atoi(argv[1]);
        height = atoi(argv[2]);
       }
    else
      if (argc == 5)
        { width  = atoi(argv[1]);
          height = atoi(argv[2]);
          xpos   = atoi(argv[3]);
          ypos   = atoi(argv[4]);
         }
      else 
        { cout << "usage: clock [ width height [ xpos ypos ]]\n";
          exit(1);
         }
   }

  window W(width,height,xpos,ypos);

  Wp = &W;

  W.set_show_coordinates(false);
  W.set_redraw(draw_clock);

  if (!W.mono())
  { face_color   = violet;
    text_color   = black;
    min_color    = red;
    hour_color   = red;
   }

  panel P("clock panel");

  P.bool_item("seconds", seconds);
  P.color_item("face   color", face_color);
  P.color_item("hour   color", hour_color);
  P.color_item("minute color", min_color);
  P.color_item("text   color", text_color);

  P.button("ok");
  P.button("quit");

  draw_clock();

  for(;;)
  { if (wait_a_second())
    { if(P.open() == 1) break;
      draw_clock();
      continue;
     }
    move_hands(h,m,s+1);
    if (s == 59) sync_time();
   }

 return 0;
}
