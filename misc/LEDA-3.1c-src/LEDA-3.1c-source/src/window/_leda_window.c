/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _leda_window.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



// defines the LEDA_WINDOW operations declared in <LEDA/leda_window.h>
// using the basic graphics routines from <LEDA/impl/x_basic.h>

#include <LEDA/leda_window.h>
#include <LEDA/impl/x_basic.h>

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>

color::color(const char* name) { col_index = new_color(name);  }

color::color(int i ) { col_index = i;  }

color FG_color = black;
color BG_color = white;


void LEDA_WINDOW::flush() { flush_display(); }

void LEDA_WINDOW::set_frame_label(const char* label) 
{ ::set_header(draw_win,label); }

int LEDA_WINDOW::load_text_font(const char* fname) 
{ return ::load_text_font(fname); }

int LEDA_WINDOW::load_bold_font(const char* fname) 
{ return ::load_bold_font(fname); }

int LEDA_WINDOW::load_message_font(const char* fname) 
{ return ::load_message_font(fname); }

int LEDA_WINDOW::set_font(const char* fname) 
{ return ::set_font(fname); }

void LEDA_WINDOW::reset_frame_label() 
{ ::set_header(draw_win,default_frame_label); }

void LEDA_WINDOW::set_grid_mode(int i) 
{ if (i != grid_mode) init(xmin(),xmax(),ymin(),i); }

drawing_mode LEDA_WINDOW::set_mode(drawing_mode m) 
{ drawing_mode save = drawing_mo;
  drawing_mo = m;
  ::set_mode(m);
  return save;
 }

int LEDA_WINDOW::set_line_width(int w)
{ if (w < 1) w = 1;
  int save = line_width;
  line_width = w;
  ::set_line_width(w);
  return save;
 }

line_style LEDA_WINDOW::set_line_style(line_style s)
{ line_style save = line_st;
  line_st = s;
  ::set_line_style(s);
  return save;
 }

int LEDA_WINDOW::set_node_width(int w)
{ if (w < 1) w = 1;
  int save = node_width;
  node_width = w;
  return save;
 }

text_mode LEDA_WINDOW::set_text_mode(text_mode m)
{ text_mode save = text_mo;
  text_mo = m;
  return save;
 }


int LEDA_WINDOW::read_event(int& k, double& x, double& y)
{ LEDA_WINDOW* w=0;
  int e = event_handler(w,1);
  while (w != this) e = event_handler(w,1);
  x = mouse_xreal;
  y = mouse_yreal;
  k = mouse_key;
  return e;
 }

int LEDA_WINDOW::get_event(int& k, double& x, double& y)
{ LEDA_WINDOW* w=0;
  int e = event_handler(w,0);
  while (e != no_event && w != this) e = event_handler(w,0);
  x = mouse_xreal;
  y = mouse_yreal;
  k = mouse_key;
  return e;
 }

void LEDA_WINDOW::put_back_event() { ::put_back_event(); }


int LEDA_WINDOW::event_handler(LEDA_WINDOW*& w, int blocking)
{
  char s[32];
  Window win;

  int   val,x,y,e;

  unsigned long t;

  if (blocking)
     e = get_next_event(&win, &val, &x, &y, &t);
  else
     e = check_next_event(&win, &val, &x, &y, &t);

  for(int i = 0; i<count && window_list[i]->draw_win != win; i++); 

  if (i >= count)  return no_event;

  w = window_list[i];

  active_window = w;

  switch (e) {

  case configure_event:
           if (w->xdots != x || w->ydots != y)
           { drawing_mode save = w->set_mode(src_mode);
             w->init(w->min_xcoord,w->max_xcoord,w->min_ycoord,w->grid_mode);
             w->set_mode(save);
            }
           break;


  case button_press_event:
           w->mouse_key = val;
           w->mouse_xpix = x;
           w->mouse_ypix = y;
           w->mouse_press_time = t;
           break;

  case button_release_event:
           w->mouse_key = val;
           w->mouse_xpix = x;
           w->mouse_ypix = y;
           w->mouse_release_time = t;
           break;

  case motion_event:

         w->mouse_xpix = x;
         w->mouse_ypix = y;

         if (w->grid_mode) w->cursor();

         w->mouse_xreal =  w->min_xcoord + ((double)w->mouse_xpix)/w->scaling;
         w->mouse_yreal =  w->max_ycoord - ((double)w->mouse_ypix)/w->scaling;
        
         if (blocking)
         { if (w->grid_mode)
           { int g = w->grid_mode;
             w->mouse_xreal = g*(int)(w->mouse_xreal/g +((w->mouse_xreal>0) ? 0.5:-0.5));
             w->mouse_yreal = g*(int)(w->mouse_yreal/g +((w->mouse_yreal>0) ? 0.5:-0.5));
             w->mouse_xpix  = w->xpix(w->mouse_xreal);
             w->mouse_ypix  = w->ypix(w->mouse_yreal);
             w->cursor();
            }
     
           if (w->show_coord && blocking)
           { sprintf(s,"%8.2f %8.2f\0", w->mouse_xreal,w->mouse_yreal);
             show_coordinates(win,s);
            }
          
           if (w->mouse_action && w == read_window) /* user defined action */
           { w->mouse_action(w->mouse_last_xreal,w->mouse_last_yreal);
             w->mouse_action(w->mouse_xreal,w->mouse_yreal);
            }
          }
      
         w->mouse_last_xreal = w->mouse_xreal;
         w->mouse_last_yreal = w->mouse_yreal;

     }

  return e;
}


int LEDA_WINDOW::read_mouse(int kind, double xstart, double ystart, double &x, double &y)
{ 
  // 0: point, 1: segment, 2:rectangle, 3: circle 

  switch(kind) {
  case  0: return read_mouse_action(mouse_default_action,xstart,ystart,x,y);
  case  1: return read_mouse_action(mouse_segment_action,xstart,ystart,x,y);
  case  2: return read_mouse_action(mouse_rect_action,xstart,ystart,x,y);
  case  3: return read_mouse_action(mouse_circle_action,xstart,ystart,x,y);
  default: return read_mouse_action(mouse_default_action,xstart,ystart,x,y);
  }

}


int LEDA_WINDOW::get_button(double &x, double &y)
{ mouse_key = 0;
  drawing_mode s = set_mode(xor_mode);
  set_read_gc();
  LEDA_WINDOW* w;
  int e = event_handler(w,0);
  while (e != no_event && e != button_press_event && w != this) 
      e = event_handler(w,0);
  reset_gc();
  set_mode(s);
  x = mouse_xreal;
  y = mouse_yreal;
  return mouse_key;
 }

unsigned long LEDA_WINDOW::button_press_time()  { return mouse_press_time; }
unsigned long LEDA_WINDOW::button_release_time(){ return mouse_release_time; }


int LEDA_WINDOW::read_mouse_action(mouse_action_func_ptr action, double xstart, double ystart, double &x, double &y)
{
  read_window = this;

  mouse_action = action;

  drawing_mode s = set_mode(xor_mode);
  set_read_gc();

  mouse_key = 0;

  mouse_start_xreal = xstart;
  mouse_start_yreal = ystart;

  mouse_start_xpix = xpix(xstart);
  mouse_start_ypix = ypix(ystart);

  if (grid_mode) cursor();

  if (show_coord)
  { char s[64];
    sprintf(s,"%8.2f %8.2f\0", mouse_xreal,mouse_yreal);
    show_coordinates(draw_win,s);
   }

  if (mouse_action) mouse_action(mouse_last_xreal,mouse_last_yreal);

  LEDA_WINDOW* w;

  while (event_handler(w,1) != button_press_event || w != this);

  if (mouse_action) mouse_action(mouse_xreal,mouse_yreal);

  if (grid_mode) cursor();

  x = mouse_xreal;
  y = mouse_yreal;

  reset_gc();
  set_mode(s);

  mouse_action = mouse_default_action;

  return mouse_key;
}


void LEDA_WINDOW::close() 
{ if (draw_win)
  { int i = 0;
    while (window_list[i] != this) i++;
    count--;
    window_list[i] = window_list[count];
    close_window(draw_win); 
    draw_win = 0;
    if (count==0) close_display(); 
   }
 }



LEDA_WINDOW::LEDA_WINDOW(float width, float height, float xpos, float ypos, 
                                                      const char *frame_label)
{ ref_count = 1;
  state = 1;
  draw_win = 0;
  open(int(width),int(height),int(xpos),int(ypos),frame_label);
 }


LEDA_WINDOW::LEDA_WINDOW(float width, float height, const char* frame_label)
{ ref_count = 1;
  state = 1;
  draw_win = 0;
  open(int(width),int(height),-3,-1,frame_label); 
 }

LEDA_WINDOW::LEDA_WINDOW(const char* frame_label)
{ ref_count = 1;
  state = 1;
  draw_win = 0;
  int l  =  screen_height() - 35;
  if (l > 700) l = 700;
  open(l,l,-3,-1,frame_label);
 }

LEDA_WINDOW::LEDA_WINDOW()
{ ref_count = 1;
  state = 1;
  draw_win = 0;
  //int l  =  screen_height() - 35;
  //if (l > 700) l = 700;
  //open(l,l,-3,-1,"");
 }

LEDA_WINDOW::LEDA_WINDOW(const LEDA_WINDOW& w)
{ state = w.state;
  ref_count = w.ref_count+1;
  draw_win = w.draw_win;
 }

LEDA_WINDOW::~LEDA_WINDOW() 
{ if (--ref_count == 0) close(); }


LEDA_WINDOW& LEDA_WINDOW::operator=(const LEDA_WINDOW& w)
{ if (&w != this)
  { if (--ref_count == 0) close();
    state = w.state;
    ref_count = w.ref_count + 1;
    draw_win = w.draw_win;
   }
  return *this;
 }



void LEDA_WINDOW::open(int w_width, int w_height, int w_xpos, int w_ypos, 
                                                      const char *frame_label)
{
  if (draw_win) return;

  active_window = this;

  default_frame_label[0] = 0;

  if (frame_label) strcpy(default_frame_label,frame_label);

  if (count==0) open_display();

  window_list[count] = this;

  count++;

  if (w_xpos < 0)
    switch (w_xpos) {
    case -1 : w_xpos = 0;
              break;
    case -2 : w_xpos = (screen_width() - w_width - 10)/2;
              break;
    case -3 : w_xpos = (screen_width() - w_width - 10);
              break;
    default : w_xpos = 0;
    }

  if (w_ypos < 0)
    switch (w_ypos) {
    case -1 : w_ypos = 0;
              break;
    case -2 : w_ypos = (screen_height() - w_height - 30)/2;
              break;
    case -3 : w_ypos = (screen_height() - w_height - 30);
              break;
    default : w_ypos = 0;
    }

  draw_win = open_window(w_xpos, w_ypos, w_width, w_height,
                         default_frame_label,"LEDA WINDOW");
  set_color(black);
  set_text_font();

  set_mode(src_mode);
  set_line_style(solid);
  set_line_width(1);
  set_node_width(12);
  set_text_mode(transparent);

  set_show_coordinates(1);

  redraw = 0;

  depth = display_depth();
  min_xcoord = 0;
  min_ycoord = 0;
  max_xcoord = 0;
  max_ycoord = 0;
  scaling = 1;
  mouse_xpix = 0;
  mouse_ypix = 0;

  mesg_count = 0;

  screen_flush = 1;

  window_xpos = w_xpos;
  window_ypos = w_ypos;
  window_width = w_width;
  window_height = w_height;

  init(0,100,0,0);
}


void LEDA_WINDOW::init(double x0, double x1, double y0, int g_mode)
{
 if (x0 >= x1)
 { fprintf(stderr,"Illegal arguments in draw_init: x0 (%f) >= x1 (%f)\n",x0,x1);
   abort();
  }

  grid_mode = g_mode;


  xdots = ::window_width(draw_win);
  ydots = ::window_height(draw_win);


  scaling = ((double)xdots)/(x1-x0);

  /* at least grid distance of 2 pixels */
  if ((grid_mode) && (grid_mode*scaling < 2))
  { grid_mode=0; 
    fprintf(stderr,"warning: grid distance to small.\n");
   }

  if (grid_mode)
  { if (scaling < 1) scaling = 1;
    else scaling = (int)scaling;
  }

  min_xcoord = x0;
  min_ycoord = y0;
  max_xcoord = x0+xdots/scaling;
  max_ycoord = y0+ydots/scaling;

  xorigin = (int)(-x0*scaling);
  yorigin = (int)(ydots+y0*scaling);

  mouse_xreal = 0;
  mouse_yreal = 0;

  clear(0);  

  if (redraw) (*redraw)();

  flush_display();

}


void LEDA_WINDOW::draw_pix(double x, double y, int col)
{ set_color(col);
  pixel(draw_win,xpix(x),ypix(y));
  if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_segment(double x1, double y1, double x2, double y2, int col)
{ set_color(col);
  line(draw_win, xpix(x1), ypix(y1), xpix(x2), ypix(y2));
  if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_point(double x, double y, int col)
{ int X = xpix(x);
  int Y = ypix(y);
  set_color(col);
  pixel(draw_win,X-2,Y-2);
  pixel(draw_win,X+2,Y-2);
  pixel(draw_win,X-1,Y-1);
  pixel(draw_win,X+1,Y-1);
  pixel(draw_win,X,Y);
  pixel(draw_win,X-1,Y+1);
  pixel(draw_win,X+1,Y+1);
  pixel(draw_win,X-2,Y+2);
  pixel(draw_win,X+2,Y+2);
  if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_arc(double x0, double y0, double r1, double r2, double start, double angle, int col)
{ int R1 = (int)(r1*scaling);
  int R2 = (int)(r2*scaling);
  set_color(col);
  arc(draw_win,xpix(x0),ypix(y0),R1,R2,start,angle);
  if (screen_flush) flush_display();
}

void LEDA_WINDOW::draw_filled_arc(double x0, double y0, double r1, double r2, double start, double angle, int col)
{ int R1 = (int)(r1*scaling);
  int R2 = (int)(r2*scaling);
  set_color(col);
  fill_arc(draw_win,xpix(x0),ypix(y0),R1,R2,start,angle);
  if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_node(double x0, double y0, int col)
{ int save = set_line_width(1);
  double R = node_width/scaling;
  draw_circle(x0,y0,R,col);
  set_line_width(save);
 }

void LEDA_WINDOW::draw_filled_node(double x0, double y0, int col)
{ double R = node_width/scaling;
  if (depth==1 && col!=white) col = black;
  draw_filled_circle(x0,y0,R,col);
  if (col != black) 
  { int save = set_line_width(1);
    draw_circle(x0,y0,R,col);
    draw_circle(x0,y0,R,black);
    set_line_width(save);
   }
 }


void LEDA_WINDOW::draw_text_node(double x0, double y0, char *s, int col)
{ text_mode t_save = set_text_mode(transparent);
  set_bold_font();

  if (depth==1 && col!=black) col = white;
  draw_filled_node(x0,y0,col);
  
  draw_ctext(x0,y0,s,col);

  if (col == black) 
     draw_ctext(x0,y0,s,white);
  else
     draw_ctext(x0,y0,s,black);

  set_text_mode(t_save);
  set_text_font();
}

void LEDA_WINDOW::draw_int_node(double x0, double y0, int i, int col)
{ char buf[16];
  sprintf(buf,"%d",i);
  draw_text_node(x0,y0,buf,col);
 }


void LEDA_WINDOW::draw_edge(double x1, double y1, double x2, double y2, int col)
{ double dx = x2-x1;
  double dy = y2-y1;
  if (dx==0 && dy==0) return;
  double l = node_width/(scaling*hypot(dx,dy));
  x1 += l*dx;
  x2 -= l*dx;
  y1 += l*dy;
  y2 -= l*dy;
  draw_segment(x1,y1,x2,y2,col);
}



void LEDA_WINDOW::draw_circle(double x0, double y0, double r, int col)
{ int R = (int)(r*scaling);
  set_color(col);
  circle(draw_win,xpix(x0),ypix(y0),R);
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::draw_filled_circle(double x0, double y0, double r, int col)
{ int R = (int)(r*scaling);
  set_color(col);
  if (R > 0)
     fill_circle(draw_win,xpix(x0),ypix(y0),R);
  else
     pixel(draw_win,xpix(x0),ypix(y0));
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::draw_ellipse(double x0, double y0, double a, double b, int col)
{ int R1 = (int)(a*scaling);
  int R2 = (int)(b*scaling);
  set_color(col);
  ellipse(draw_win,xpix(x0),ypix(y0),R1,R2);
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::draw_filled_ellipse(double x0, double y0, double a, double b, int col)
{ int R1 = (int)(a*scaling);
  int R2 = (int)(b*scaling);
  set_color(col);
  fill_ellipse(draw_win,xpix(x0),ypix(y0),R1,R2);
  if (screen_flush) flush_display();
 }



void LEDA_WINDOW::plot_xy(double x0, double x1, double (*f) (double), int col)
{
  int *xcoord;
  int *ycoord;

  int x = xpix(x0);
  int y_old = ypix((*f)(x0));
  int i,y_new;
  int size = 0;
  int n = 0;

  set_color(col);

  for(x = xpix(x0)+1; x <= xpix(x1); x++)
  { y_new = ypix((*f)(xreal(x)));
    if (y_new > y_old)
       size += (y_new-y_old+1);
    else
       size += (y_old-y_new+1);
    y_old = y_new;
   }

  xcoord = (int*) malloc(size*sizeof(int));
  ycoord = (int*) malloc(size*sizeof(int));

  y_old = ypix((*f)(x0));

  for(x = xpix(x0)+1; x <= xpix(x1); x++)
  { y_new = ypix((*f)(xreal(x)));
    if (y_new > y_old)
      for(i=y_old; i<=y_new; i++) 
      { xcoord[n] = x;
        ycoord[n] = i;
        n++;
       }
    else
      for(i=y_old; i>=y_new; i--) 
      { xcoord[n] = x;
        ycoord[n] = i;
        n++;
       }
    y_old = y_new;
  }

 pixels(draw_win,size,xcoord,ycoord);
 
 free((char*)xcoord);
 free((char*)ycoord);

  if (screen_flush) flush_display();
}


void LEDA_WINDOW::plot_yx(double y0, double y1, double (*f) (double), int col)
{
  int *xcoord;
  int *ycoord;

  int y;
  int i,x_new;
  int x_old = xpix((*f)(y0));
  int size = 0;
  int n = 0;

  set_color(col);

  for(y = ypix(y0)-1; y >= ypix(y1); y++)
  { x_new = xpix((*f)(yreal(y)));
    if (x_new > x_old)
       size += (x_new-x_old+1);
    else
       size += (x_old-x_new+1);
    x_old = x_new;
   }

  xcoord = (int*) malloc(size*sizeof(int));
  ycoord = (int*) malloc(size*sizeof(int));

  x_old = xpix((*f)(y0));

  for(y = ypix(y0)-1; y >= ypix(y1); y--)
  {
    x_new = xpix((*f)(yreal(y)));
    if (x_new > x_old)
      for(i=x_old; i<=x_new; i++) 
      { xcoord[n] = i;
        ycoord[n] = y;
        n++;
       }
    else
      for(i=x_old; i>=x_new; i--) 
      { xcoord[n] = i;
        ycoord[n] = y;
        n++;
       }
    x_old = x_new;
  }

 pixels(draw_win,size,xcoord,ycoord);
 
 free((char*)xcoord);
 free((char*)xcoord);

 if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_filled_polygon(int n, double *xcoord, double *ycoord, int col)
{
 int* x = (int*) malloc(n*sizeof(int));
 int* y = (int*) malloc(n*sizeof(int));
 int i;

 for(i=0;i<n;i++)
 { x[i] = xpix(xcoord[i]);
   y[i] = ypix(ycoord[i]);
  }

 set_color(col);

 fill_polygon(draw_win,n,x,y);

 free((char*)x);
 free((char*)y);

  if (screen_flush) flush_display();
}

void LEDA_WINDOW::draw_polygon(int n, double *xcoord, double *ycoord, int col)
{ int i;

  for(i=0;i<n-1;i++)
    draw_segment(xcoord[i],ycoord[i], xcoord[i+1],ycoord[i+1],col);

  draw_segment(xcoord[n-1],ycoord[n-1],xcoord[0],ycoord[0],col);

  if (screen_flush) flush_display();

 }


void LEDA_WINDOW::draw_rectangle(double x1, double y1, double x2, double y2, int col)
{ set_color(col);
  rectangle(draw_win,xpix(x1),ypix(y1),xpix(x2),ypix(y2));
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::draw_filled_rectangle(double x1, double y1, double x2, double y2, int col)
{ set_color(col);
  box(draw_win,xpix(x1),ypix(y1),xpix(x2),ypix(y2));
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::copy_rect(double x1, double y1, double x2, double y2, double x, double y)
{ ::copy_rect(draw_win,xpix(x1),ypix(y1),xpix(x2),ypix(y2),xpix(x),ypix(y));
  if (screen_flush) flush_display();
 }

void LEDA_WINDOW::insert_bitmap(int width, int height, char* data)
{ ::insert_bitmap(draw_win,width,height,data);
  if (screen_flush) flush_display();
 }


void LEDA_WINDOW::clear(int col)
{ int x0,y0,n;
  double x,y;

  int *xcoord;
  int *ycoord;

  int save_lw = set_line_width(1);
  line_style save_ls = set_line_style(solid);

 del_messages();

 if (depth == 1) col = 0;

 clear_window(draw_win,col);

 set_color(black);

 if (grid_mode) /* draw grid */
 { n =  (int)((max_xcoord - min_xcoord)/grid_mode + 1);
   n *= (int)((max_ycoord - min_ycoord)/grid_mode + 1);

   x0 = ((int)(min_xcoord/grid_mode))*grid_mode;
   y0 = ((int)(min_ycoord/grid_mode))*grid_mode;

   xcoord = (int *) malloc(n*sizeof(int));
   ycoord = (int *) malloc(n*sizeof(int));

   n = 0;

   for(x = x0; x<=max_xcoord; x+=grid_mode)
   for(y = y0; y<=max_ycoord; y+=grid_mode)
   { if (x == 0 || y == 0)
        fill_circle(draw_win,xpix(x),ypix(y),1);
     else
        { xcoord[n] = xpix(x);
          ycoord[n] = ypix(y);
          n++;
         }
    }

   pixels(draw_win,n,xcoord,ycoord);

   free((char*)xcoord);
   free((char*)ycoord);
  }

 set_line_width(save_lw);
 set_line_style(save_ls);

 flush_display();
}



void LEDA_WINDOW::message(const char *s)
{ drawing_mode save = set_mode(xor_mode);

  mesg_list[mesg_count] = (char*)malloc(strlen(s)+1);
  strcpy(mesg_list[mesg_count],s);

  mesg_count++;

  set_color(black);
  set_message_font();
  int h = int(1.3 * text_height("H"));
  put_text(draw_win,20,10+h*mesg_count,s,0);
  set_text_font();
  set_mode(save);
  flush_display();
}


void LEDA_WINDOW::del_messages(void)
{ drawing_mode save = set_mode(xor_mode);
  set_color(black);
  set_message_font();
  int h = int(1.3 * text_height("H"));
  while(mesg_count > 0)
  { char* s = mesg_list[mesg_count-1];
    put_text(draw_win,20,10+h*mesg_count,s,0);
    mesg_count--;
    free(s);
   }
  set_text_font();
  set_mode(save);
  flush_display();
}



void LEDA_WINDOW::draw_text(double x, double y, const char *s, int col)
{ set_color(col);
  put_text(draw_win,xpix(x),ypix(y),s,text_mo);
  if (screen_flush) flush_display();
}


void LEDA_WINDOW::draw_ctext(double x, double y, const char *s, int col)
{ set_color(col);
  put_ctext(draw_win,xpix(x),ypix(y),s,text_mo);
  if (screen_flush) flush_display();
}

void LEDA_WINDOW::cursor(void)
{ int X = xpix(mouse_xreal);
  int Y = ypix(mouse_yreal);
  line(draw_win, X,Y,X+10,Y);
  line(draw_win, X,Y,X-10,Y);
  line(draw_win, X,Y,X,Y+10);
  line(draw_win, X,Y,X,Y-10);
}

// define static members

LEDA_WINDOW* LEDA_WINDOW::window_list[32];
LEDA_WINDOW* LEDA_WINDOW::read_window = 0;
LEDA_WINDOW* LEDA_WINDOW::active_window = 0;
int          LEDA_WINDOW::count = 0;

int  LEDA_WINDOW::screen_width(void)  { return display_width(); }
int  LEDA_WINDOW::screen_height(void) { return display_height(); }
int  LEDA_WINDOW::screen_depth(void)  { return display_depth(); }

void LEDA_WINDOW::mouse_default_action(double,double) 
{ /* do nothing */}

void LEDA_WINDOW::mouse_segment_action(double x, double y) 
{ double x0 = read_window->mouse_start_xreal;
  double y0 = read_window->mouse_start_yreal;
  read_window->draw_segment(x0,y0,x,y,black); 
 }

void LEDA_WINDOW::mouse_rect_action(double x, double y)
{ double x0 = read_window->mouse_start_xreal;
  double y0 = read_window->mouse_start_yreal;
  read_window->draw_rectangle(x0,y0,x,y,black);
 }

void LEDA_WINDOW::mouse_circle_action(double x, double y)
{ double x0 = read_window->mouse_start_xreal;
  double y0 = read_window->mouse_start_yreal;
  read_window->draw_circle(x0,y0,hypot(x-x0,y-y0),black);
 }


#include <fstream.h>

char* Read_Leda_Bitmap(const char* fname, int& w, int& h)
{
  ifstream bitmap(fname);

  unsigned char c1,c2;

  bitmap.get(c1);
  bitmap.get(c2);
  w = c2;
  w *= 256;
  w += c1;

  bitmap.get(c1);
  bitmap.get(c2);
  h = c2;
  h *= 256;
  h += c1;

  int n = w*h/8;

  char* map = new char[n];

  int i = 0;
  while(i<n && bitmap) 
  { char c;
    bitmap.get(c);
    if (c == char(0xff) || c == char(0x00))
       { unsigned char j;
         bitmap.get(j);
         while (j--) map[i++] = c;
        }
    else 
       map[i++] = c;
   }

  return map;
}



int read_mouse(LEDA_WINDOW*& w, double& x, double& y)
{ int e = LEDA_WINDOW::event_handler(w,1);
  while (e != button_press_event) e = LEDA_WINDOW::event_handler(w,1);
  x = w->mouse_xreal;
  y = w->mouse_yreal;
  return w->mouse_key;
 }
