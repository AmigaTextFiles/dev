/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _window.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/window.h>
#include <math.h>




//------------------------------------------------------------------------------
// WINDOW BASICS
//------------------------------------------------------------------------------


static void window_error_handler(int i, const char* s)
{ if (i==0) return;
  panel P;
  P.text_item(string("ERROR(%d): %s",i,s));
  P.button("exit");
  P.button("dump core");
  if (P.open() == 0)
     exit(0);
  else 
     abort();
 }

window::window(float width,float height,float xpos,float ypos,const char* label)
: LEDA_WINDOW(width,height,xpos,ypos, label)
{ set_error_handler(window_error_handler); }

window::window(float width, float height, const char* label)
: LEDA_WINDOW(width,height,label)
{ set_error_handler(window_error_handler); }

window::window(const char* label) : LEDA_WINDOW(label)
{ set_error_handler(window_error_handler); }

window::window(int) // do not open
{ set_error_handler(window_error_handler); }



//------------------------------------------------------------------------------
// WINDOW OUTPUT
//------------------------------------------------------------------------------


// pixels

void window::draw_pix(double x, double y, color c ) 
{ LEDA_WINDOW::draw_pix(x,y,c); }

void window::draw_pix(const point& p, color c ) 
{ draw_pix(p.xcoord(),p.ycoord(),c); }

void window::draw_text(double x, double y, string s, color c)
{ LEDA_WINDOW::draw_text(x,y,s,c); }

void window::draw_text(const point& p, string s, color c)
{ draw_text(p.xcoord(),p.ycoord(),s,c); }

void window::draw_ctext(double x, double y, string s, color c)
{ LEDA_WINDOW::draw_ctext(x,y,s,c); }

void window::draw_ctext(const point& p, string s, color c)
{ draw_ctext(p.xcoord(),p.ycoord(),s,c); }

// points

void window::draw_point(double x0,double y0,color c)
{ LEDA_WINDOW::draw_point(x0,y0,c); }

void window::draw_point(const point& p,color c)
{ draw_point(p.xcoord(),p.ycoord(),c); }


// segments

void window::draw_segment(double x1, double y1, double x2, double y2, color c )
{ LEDA_WINDOW::draw_segment(x1,y1,x2,y2,c); }

void window::draw_segment(const point& p, const point& q, color c )
{ window::draw_segment(p.xcoord(),p.ycoord(),q.xcoord(),q.ycoord(),c); }

void window::draw_segment(const segment& s, color c )
{ draw_segment(s.start(),s.end(),c); }


// lines


void window::draw_line(const line& l, color c )
{
  double a,x0,x1,y0,y1;

  if (l.vertical()) 
  { draw_vline(l.x_proj(0),c);
    return;
   }

  a = l.slope();

  if (fabs(a) < 1)
  { x0 = xmin();
    x1 = xmax();
    y0 = l.y_proj(x0);
    y1 = l.y_proj(x1);
   }
  else
  { y0 = ymin();
    y1 = ymax();
    x0 = l.x_proj(y0);
    x1 = l.x_proj(y1);
   }

  LEDA_WINDOW::draw_segment(x0,y0,x1,y1,c);

}


void window::draw_line(const segment& s, color c )
{ draw_line(line(s),c); }

void window::draw_line(const point& p, const point& q, color c) 
{ draw_line(line(p,q),c); }

void window::draw_line(double x1, double y1, double x2, double y2, color c )
{ draw_line(segment(x1,y1,x2,y2),c); }


void window::draw_hline(double y, color c )
{ LEDA_WINDOW::draw_segment(xmin(),y,xmax(),y,c); }

void window::draw_vline(double x, color c )
{ LEDA_WINDOW::draw_segment(x,ymin(),x,ymax(),c); }




// nodes

void window::draw_node(double x0,double y0,color c) 
{ LEDA_WINDOW::draw_node(x0,y0,c); }

void window::draw_node(const point& p, color c)
{ window::draw_node(p.xcoord(),p.ycoord(),c); }

void window::draw_filled_node(double x0,double y0,color c)
{ LEDA_WINDOW::draw_filled_node(x0,y0,c); }

void window::draw_filled_node(const point& p, color c)
{ window::draw_filled_node(p.xcoord(),p.ycoord(),c); }

void window::draw_text_node(double x,double y,string s,color c)
{ LEDA_WINDOW::draw_text_node(x,y,~s,c); }

void window::draw_text_node(const point& p ,string s,color c)
{ window::draw_text_node(p.xcoord(),p.ycoord(),~s,c); }

void window::draw_int_node(double x,double y,int i,color c)
{ LEDA_WINDOW::draw_int_node(x,y,i,c); }

void window::draw_int_node(const point& p ,int i,color c)
{ window::draw_int_node(p.xcoord(),p.ycoord(),i,c); }


//circles

void window::draw_circle(double x,double y,double r,color c)
{ LEDA_WINDOW::draw_circle(x,y,r,c); }

void window::draw_circle(const point& p,double r,color c)
{ LEDA_WINDOW::draw_circle(p.xcoord(),p.ycoord(),r,c); }

void window::draw_circle(const circle& C,color c)
{ point p = C.center();
  double r = C.radius();
  LEDA_WINDOW::draw_circle(p.xcoord(),p.ycoord(),r,c); 
 }


// discs

void window::draw_disc(double x,double y,double r,color c)
{ LEDA_WINDOW::draw_filled_circle(x,y,r,c); }

void window::draw_disc(const point& p,double r,color c)
{ window::draw_disc(p.xcoord(),p.ycoord(),r,c); }


void window::draw_disc(const circle& C,color c)
{ draw_disc(C.center(),C.radius(),c); }



//ellipses

void window::draw_ellipse(double x,double y,double r1,double r2,color c)
{ LEDA_WINDOW::draw_ellipse(x,y,r1,r2,c); }

void window::draw_ellipse(const point& p, double r1, double r2, color c)
{ LEDA_WINDOW::draw_ellipse(p.xcoord(),p.ycoord(),r1,r2,c); }

void window::draw_filled_ellipse(double x,double y,double r1,double r2,color c)
{ LEDA_WINDOW::draw_filled_ellipse(x,y,r1,r2,c); }

void window::draw_filled_ellipse(const point& p, double r1, double r2, color c)
{ LEDA_WINDOW::draw_filled_ellipse(p.xcoord(),p.ycoord(),r1,r2,c); }



// arcs

void window::draw_arc(const segment& s, double r, color col)
{ double d   = s.length()/(2*fabs(r));
  if (d > 1) return;
  double acd = acos(d);
  if (r < 0) 
    { point   m  = s.start().translate(s.angle()-acd,-r);
      segment x(m,s.end());
      LEDA_WINDOW::draw_arc(m.xcoord(),m.ycoord(),-r,-r,x.angle(),M_PI-2*acd,col);
     }
  else 
    { point   m  = s.start().translate(s.angle()+acd,r);
      segment x(m,s.end());
      LEDA_WINDOW::draw_arc(m.xcoord(),m.ycoord(),r,r,x.angle(),2*acd-M_PI,col);
     }
 }

void window::draw_arc(double x0,double y0,double x1,double y1,double r,color c)
{ draw_arc(segment(x0,y0,x1,y1),r,c); }

void window::draw_arc(const point& p, const point& q, double r, color c)
{ draw_arc(segment(p,q),r,c); }



void window::draw_arc_arrow(const segment& s, double r, color col)
{ double d   = s.length()/(2*r);
  if (d > 1) return;
  point p = draw_arrow_head(s.end(), s.angle() + M_PI/2 - acos(d), col);
  draw_arc(s.start(),p,r,col);
 }

void window::draw_arc_arrow(double x0,double y0,double x1,double y1,double r,color c)
{ draw_arc_arrow(segment(x0,y0,x1,y1),r,c); }

void window::draw_arc_arrow(const point& p, const point& q, double r, color c)
{ draw_arc_arrow(segment(p,q),r,c); }


// polygons

void window::draw_polygon(const list<point>& lp, color c)
{ int n = lp.length();
  double* X = new double[n];
  double* Y = new double[n];
  n = 0;
  point p;
  forall(p,lp) 
  { X[n] = p.xcoord();
    Y[n] = p.ycoord();
    n++;
   }
  LEDA_WINDOW::draw_polygon(n,X,Y,c);
  delete X;
  delete Y;
}

void window::draw_filled_polygon(const list<point>& lp, color c)
{ int n = lp.length();
  double* X = new double[n];
  double* Y = new double[n];
  n = 0;
  point p;
  forall(p,lp) 
  { X[n] = p.xcoord();
    Y[n] = p.ycoord();
    n++;
   }
  LEDA_WINDOW::draw_filled_polygon(n,X,Y,c);
  delete X;
  delete Y;
}

void window::draw_polygon(const polygon& P, color c )
{ draw_polygon(P.vertices(),c); }

void window::draw_filled_polygon(const polygon& P,color c )
{ draw_filled_polygon(P.vertices(),c); }




void window::draw_rectangle(double a, double  b, double c, double d, color col)
{ LEDA_WINDOW::draw_rectangle(a,b,c,d,col); }

void window::draw_filled_rectangle(double a, double  b, double c, double d, color col)
{ LEDA_WINDOW::draw_filled_rectangle(a,b,c,d,col); }


// functions

void window::plot_xy(double x0, double x1, draw_func_ptr f, color c)
{ LEDA_WINDOW::plot_xy(x0,x1,f,c); }

void window::plot_yx(double y0, double y1, draw_func_ptr f, color c)
{ LEDA_WINDOW::plot_yx(y0,y1,f,c); }



// arrows

point window::draw_arrow_head(const point& q, double a, color c)
{ double X[4];
  double Y[4];
  
  double alpha = a-M_PI; 

  double d = 2*((get_line_width()+2)/3.0)/scale();

  point l = q.translate(alpha+M_PI/6, 7*d);
  point m = q.translate(alpha,        4*d);
  point r = q.translate(alpha-M_PI/6, 7*d);


  X[0] = q.xcoord();
  Y[0] = q.ycoord();
  X[1] = l.xcoord();
  Y[1] = l.ycoord();
  X[2] = m.xcoord();
  Y[2] = m.ycoord();
  X[3] = r.xcoord();
  Y[3] = r.ycoord();

  LEDA_WINDOW::draw_filled_polygon(4,X,Y,c);
  return m;
}


void window::draw_arrow(const segment& s, color c)
{ point q = draw_arrow_head(s.end(),s.angle(),c);
  draw_segment(s.start(),q,c);
}

void window::draw_arrow(const point& p, const point& q, color c)
{ draw_arrow(segment(p,q),c); }

void window::draw_arrow(double x0, double y0, double x1, double y1, color c)
{ draw_arrow(segment(x0,y0,x1,y1),c); }





// edges

void window::draw_edge(double x0, double y0, double x1, double y1, color c)
{ LEDA_WINDOW::draw_edge(x0,y0,x1,y1,c); }

void window::draw_edge(const point& p, const point& q, color c)
{ draw_edge(p.xcoord(),p.ycoord(),q.xcoord(),q.ycoord(),c); }

void window::draw_edge(const segment& s, color c)
{ draw_edge(s.start(),s.end(),c); }


void window::draw_arc_edge(double x0, double y0, double x1, double y1, color c)
{ draw_arc_edge(segment(x0,y0,x1,y1),c); }

void window::draw_arc_edge(const point& p, const point& q, double r, color c)
{ draw_arc_edge(segment(p,q),r,c); }

void window::draw_arc_edge(const segment& s, double r, color c)
{ double R = get_node_width()/scale();
  double d = s.length()/(2*r);
  if (d > 1) return;
  point p = s.start().translate(s.angle() - M_PI/2 + acos(d), R);
  point q = s.end().translate(s.angle() + M_PI/2 - acos(d),  -R);
  draw_arc(p,q,r,c);
 }


void window::draw_edge_arrow(double x0,double y0,double x1,double y1,color c)
{ draw_edge_arrow(segment(x0,y0,x1,y1),c); }

void window::draw_edge_arrow(const point& p, const point& q, color c)
{ draw_edge_arrow(segment(p,q),c); }

void window::draw_edge_arrow(const segment& s, color c)
{ double  alpha = s.angle();
  point p = s.start().translate(alpha,get_node_width()/scaling);
  point q = s.end().translate(alpha,-get_node_width()/scaling);
  draw_arrow(p,q,c);
}



void window::draw_arc_edge_arrow(double x,double y,double x1,double y1,color c)
{ draw_arc_edge_arrow(segment(x,y,x1,y1),c); }

void window::draw_arc_edge_arrow(const point& p, const point& q, double r, color c)
{ draw_arc_edge_arrow(segment(p,q),r,c); }

void window::draw_arc_edge_arrow(const segment& s, double r, color c)
{ double R = get_node_width()/scale();
  double d = s.length()/(2*r);
  if (d > 1) return;
  point p = s.start().translate(s.angle() - M_PI/2 + acos(d), R);
  point q = s.end().translate(s.angle() + M_PI/2 - acos(d),  -R);
  draw_arc_arrow(p,q,r,c);
 }


//------------------------------------------------------------------------------
// WINDOW INPUT
//------------------------------------------------------------------------------


int window::get_button() 
{ double x,y;
  return LEDA_WINDOW::get_button(x,y); 
 }

int window::get_button(double& x, double& y) 
{ return LEDA_WINDOW::get_button(x,y); }

int  window::get_button(point& q)
{ double x,y;
  int key = LEDA_WINDOW::get_button(x,y);
  q = point(x,y);
  return key;
 }


int window::read_mouse()
{ double d;
  return LEDA_WINDOW::read_mouse(0,0.0,0.0,d,d);
 }

int  window::read_mouse(double& x, double& y)
{ return LEDA_WINDOW::read_mouse(0,0.0,0.0,x,y); }

int  window::read_mouse(point& q)
{ double x,y;
  int key = LEDA_WINDOW::read_mouse(0,0.0,0.0,x,y);
  q = point(x,y);
  return key;
 }


int  window::read_mouse_seg(double x0, double y0, double& x, double& y)
{ return LEDA_WINDOW::read_mouse(1,x0,y0,x,y); }

int  window::read_mouse_seg(const point& p, point& q)
{ double X,Y;
  int key = LEDA_WINDOW::read_mouse(1,p.xcoord(),p.ycoord(),X,Y);
  q = point(X,Y);
  return key;
}


int  window::read_mouse_rect(double x0, double y0, double& x, double& y)
{ return LEDA_WINDOW::read_mouse(2,x0,y0,x,y); }


int  window::read_mouse_rect(const point& p, point& q)
{ double X,Y;
  int key = LEDA_WINDOW::read_mouse(2,p.xcoord(),p.ycoord(),X,Y);
  q = point(X,Y);
  return key;
}


int  window::read_mouse_circle(double x0, double y0, double& x, double& y)
{ return LEDA_WINDOW::read_mouse(3,x0,y0,x,y); }


int  window::read_mouse_circle(const point& p, point& q)
{ double X,Y;
  int key = LEDA_WINDOW::read_mouse(3,p.xcoord(),p.ycoord(),X,Y);
  q = point(X,Y);
  return key;
}



int window::read_mouse_action(mouse_action_func_ptr f, double& x, double& y)
{ return LEDA_WINDOW::read_mouse_action(f,0.0,0.0,x,y); }


int window::read_mouse_action(mouse_action_func_ptr f, point& q)
{ double X,Y;
  int key = LEDA_WINDOW::read_mouse_action(f,0.0,0.0,X,Y);
  q = point(X,Y);
  return key;
}



window& window::read(point& p)
{ double x,y;
  state = 1;
  int k;
  while ((k = read_mouse(x,y)) != 1) 
   if (k == 3) 
    { state = 0;
      return *this;
     }
  p = point(x,y);
  return *this;
 }


window& window::read(segment& s)
{ double x,y;
  point p;
  int key = 0;
  state = 1;

  if (!read(p).state) 
   return *this;

  while ((key=read_mouse_seg(p.xcoord(),p.ycoord(),x,y)) != 1)
  { if (key== 3)  
     { state = 0;
       break; 
      }

    if (key==-1)
      if (!read(p).state) break;
   }

   if (state) s = segment(p.xcoord(),p.ycoord(),x,y);

  return *this;
}

window& window::read(line& l)
{ segment s;
  state = 1;
  read(s);
  if (state) l = line(s);
  return *this;
 }


window& window::read(circle& c)
{ double x,y;
  point p;
  int key = 0;
  state = 1;

  if (!read(p).state) 
   return *this;

  drawing_mode save = set_mode(xor_mode);
  draw(p);

  while ((key=read_mouse_circle(p.xcoord(),p.ycoord(),x,y)) != 1)
  { if (key== 3)  
     { state = 0;
       break; 
      }

    if (key==-1)
    { draw(p);
      if (!read(p).state) break;
      draw(p);
     }
   }
   if (state) 
   { double dx = x-p.xcoord();
     double dy = y-p.ycoord();
     c = circle(p,hypot(dx,dy));
     draw(p);
    }

  set_mode(save);
  return *this;
}

window& window::read(polygon& P)
{ double x,y;
  int key = 0;
  state = 1;
  point first,last,p;
  list<point> pl;

  if (!read(first).state) return *this;

  pl.append(first);

  p = first;

  drawing_mode save = set_mode(xor_mode);

  while ((key = read_mouse_seg(p.xcoord(),p.ycoord(),x,y)) !=2)
  { 
    if (key==3) break;

    if (key==-1 && pl.length() > 1 ) 
    { point l = pl.Pop();
      draw_segment(pl.tail(),l);
      p = pl.tail();
     }

    if (key==1)
    { point q(x,y);
      draw_segment(p,q);
      pl.append(q);
      p = q;
     }
  }


  draw_segment(first,p);

  list_item it;
  forall_items(it,pl) draw_segment(pl[it],pl[pl.cyclic_succ(it)]);


  P = polygon(pl);

  if (key==3)
  { state = 0;
    Clear(P);
    Init(P);
   }

  set_mode(save);

  return *this;

}


window& window::operator>>(point& p)    
{ set_frame_label(">> POINT");
  read(p); 
  reset_frame_label();
  return *this; 
 }

window& window::operator>>(segment& s)  
{ set_frame_label(">> SEGMENT");
  read(s); 
  reset_frame_label();
  return *this; 
 }

window& window::operator>>(line& l)     
{ set_frame_label(">> LINE");
  read(l); 
  reset_frame_label();
  return *this; 
 }

window& window::operator>>(circle& C)   
{ set_frame_label(">> CIRCLE");
  read(C); 
  reset_frame_label();
  return *this; 
 }

window& window::operator>>(polygon& P)  
{ set_frame_label(">> POLYGON");
  read(P); 
  reset_frame_label();
  return *this; 
 }




int window::confirm(string s)
{ panel p;
  p.text_item(s);
  p.button("YES");
  p.button("NO");
  return 1 - p.open();
}


void window::acknowledge(string s)
{ panel p;
  p.text_item(s);
  p.button("CONTINUE");
  p.open();
}

void window::notice(string s)
{ panel p;
  p.text_item(s);
  p.button("CONTINUE");
  p.open();
}


int  window::read_panel(string header, int n, string* L)
{ panel P("LEDA PANEL");
  P.text_item(header);
  for(int i = 0; i < n; i++) P.button(L[i]);
  return P.open();
 }


int  window::read_vpanel(string header, int n, string* L)
{ panel P("LEDA PANEL");
  P.text_item(header);
  for(int i = 0; i < n; i++) 
  { P.button(L[i]);
    P.new_button_line();
   }
  return P.open();
 }


string  window::read_string(string prompt)
{ panel P("STRING INPUT PANEL");
  string s;
  P.string_item(prompt,s);
  P.open();
  return s;
 }

int  window::read_int(string prompt)
{ panel P("INT INPUT PANEL");
  int i;
  P.int_item(prompt,i);
  P.open();
  return i;
}

double  window::read_real(string prompt)
{ panel P("DOUBLE INPUT PANEL");
  double x;
  P.real_item(prompt,x);
  P.open();
  return x;
 }
