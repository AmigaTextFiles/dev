/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  window.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_WINDOW_H
#define LEDA_WINDOW_H

#include <LEDA/basic.h>
#include <LEDA/plane.h>
#include <LEDA/leda_window.h>
#include <LEDA/leda_panel.h>


class window : public LEDA_WINDOW {

public:

enum placement {min = -1, center =-2, max = -3 };

 window(float width, float height, float xpos, float ypos, 
        const char* = LEDA::version_string);

 window(float width, float height,const char* = LEDA::version_string);

 window(const char* = LEDA::version_string);

 window(int);  // just create, do not open

 window(const window& w) : LEDA_WINDOW(w) {}

 window& operator=(const window& w) 
 { LEDA_WINDOW::operator=(w); return *this; }
 
~window() {}   // ~LEDA_WINDOW does this job


operator void*() { return (state==0) ? 0 : this; }

// pixels

void draw_pix(double x, double y, color c=FG_color );
void draw_pix(const point& p, color c=FG_color );


// points

void draw_point(double x0,double y0,color c=FG_color);
void draw_point(const point& p,color c=FG_color);


// nodes

void draw_node(double x0,double y0,color c=FG_color);
void draw_node(const point& p, color c=FG_color);
void draw_filled_node(double x0,double y0,color c=FG_color);
void draw_filled_node(const point& p, color c=FG_color);
void draw_text_node(double x,double y,string s,color c=BG_color);
void draw_text_node(const point& p ,string s,color c=BG_color);
void draw_int_node(double x,double y,int i,color c=BG_color);
void draw_int_node(const point& p ,int i,color c=BG_color);


// drawing segments

void draw_segment(double x1, double y1, double x2, double y2, color c=FG_color );
void draw_segment(const point& p, const point& q, color c=FG_color );
void draw_segment(const segment& s, color c=FG_color );


// drawing arcs

void draw_arc(double,double,double,double,double,color=FG_color);
void draw_arc(const point&,const point&,double,color=FG_color);
void draw_arc(const segment&,double,color=FG_color);


// arrows

point draw_arrow_head(const point& q, double dir, color c=FG_color);

void draw_arrow(double, double, double, double, color=FG_color );
void draw_arrow(const point&, const point&, color=FG_color );
void draw_arrow(const segment&, color=FG_color );

void draw_arc_arrow(double,double,double,double,double,color=FG_color);
void draw_arc_arrow(const point&,const point&,double,color=FG_color);
void draw_arc_arrow(const segment&,double,color=FG_color);


// edges

void draw_edge(double,double,double,double, color c=FG_color);
void draw_edge(const point&, const point&, color=FG_color );
void draw_edge(const segment&, color=FG_color );

void draw_edge_arrow(double,double,double,double, color c=FG_color);
void draw_edge_arrow(const point&, const point&, color=FG_color );
void draw_edge_arrow(const segment&, color=FG_color );

void draw_arc_edge(double,double,double,double, color c=FG_color);
void draw_arc_edge(const point&, const point&, double, color=FG_color );
void draw_arc_edge(const segment&, double, color=FG_color );

void draw_arc_edge_arrow(double,double,double,double, color c=FG_color);
void draw_arc_edge_arrow(const point&, const point&, double, color=FG_color );
void draw_arc_edge_arrow(const segment&, double, color=FG_color );



// lines

void draw_hline(double y, color c=FG_color );
void draw_vline(double x, color c=FG_color );
void draw_line(double x1, double y1, double x2, double y2, color c=FG_color );
void draw_line(const point& p, const point& q, color c=FG_color);
void draw_line(const segment& s, color c=FG_color);
void draw_line(const line& l, color c=FG_color);



//circles

void draw_circle(double x,double y,double r,color c=FG_color);
void draw_circle(const point& p,double r,color c=FG_color);
void draw_circle(const circle& C,color c=FG_color);

void draw_disc(double x,double y,double r,color c=FG_color);
void draw_disc(const point& p,double r,color c=FG_color);
void draw_disc(const circle& C,color c=FG_color);


//ellipses

void draw_ellipse(double x,double y,double r1, double r2, color c=FG_color);
void draw_ellipse(const point& p, double r1, double r2, color c=FG_color);

void draw_filled_ellipse(double x,double y,double r1, double r2, color c=FG_color);
void draw_filled_ellipse(const point& p, double r1, double r2, color c=FG_color);


//polygons 

void draw_polygon(const list<point>& lp, color c=FG_color );
void draw_polygon(const polygon& P, color c=FG_color );

void draw_filled_polygon(const list<point>& lp, color c=FG_color );
void draw_filled_polygon(const polygon& P,color c=FG_color );

void draw_rectangle(double a, double  b, double c, double d, color=FG_color);
void draw_filled_rectangle(double a, double  b, double c, double d, color=FG_color);


// text

void draw_text(double x, double y, string s, color c=FG_color);
void draw_text(const point& p, string s, color c=FG_color);
void draw_ctext(double x, double y, string s, color c=FG_color);
void draw_ctext(const point& p, string s, color c=FG_color);


// functions

void plot_xy(double x0, double x1, draw_func_ptr f, color c=FG_color);
void plot_yx(double y0, double y1, draw_func_ptr f, color c=FG_color);



// miscellaneous

void clear(color c=BG_color) { LEDA_WINDOW::clear(c); };

void del_message() { LEDA_WINDOW::del_messages(); };

void fill(double x, double y, color c=FG_color);

void copy_rect(double x1, double y1, double x2, double y2, double x, double y);
void move_rect(double x1, double y1, double x2, double y2, double x, double y);
void copy(double x1, double y1, double x2, double y2, int i=0);
void cut(double x1, double y1, double x2, double y2, int i=0);
void paste(int i, double x, double y);
void paste(double x, double y);
void clear_buf(int i=0);


// mouse input

/*
friend int read_mouse(window*& w, double& x, double& y);
*/

int get_button();
int get_button(double&, double&);
int get_button(point&);

int read_mouse();
int read_mouse(double&, double&);
int read_mouse(point&);

int read_mouse_seg(double, double, double&, double&);
int read_mouse_seg(const point&, point&);

int read_mouse_rect(double, double, double&, double&);
int read_mouse_rect(const point&, point&);

int read_mouse_circle(double, double, double&, double&);
int read_mouse_circle(const point&, point&);

int read_mouse_action(mouse_action_func_ptr, double&, double&);
int read_mouse_action(mouse_action_func_ptr, point&);


// panel input

int     confirm(string s);
void    acknowledge(string s);
void    notice(string s);

int     read_panel(string, int, string*);
int     read_vpanel(string, int, string*);

string  read_string(string);
double  read_real(string);
int     read_int(string);

// I/O operators

window& read(point&);
window& read(segment&);
window& read(line&);
window& read(circle&);
window& read(polygon&);

window& operator>>(point&);
window& operator>>(segment&);
window& operator>>(line&);
window& operator>>(circle&);
window& operator>>(polygon&);

window& draw(const point& p,color c=FG_color)   { draw_point(p,c); return *this;  }
window& draw(const segment& s,color c=FG_color) { draw_segment(s,c); return *this;}
window& draw(const line& l,color c=FG_color)    { draw_line(l,c); return *this;   }
window& draw(const circle& C,color c=FG_color)  { draw_circle(C,c); return *this; }
window& draw(const polygon& P,color c=FG_color ){ draw_polygon(P,c); return *this;}

window& operator<<(const point& p)   { return draw(p); }
window& operator<<(const segment& s) { return draw(s); }
window& operator<<(const line& l)    { return draw(l); }
window& operator<<(const circle& C)  { return draw(C); }
window& operator<<(const polygon& P) { return draw(P); }



}; // end of class window
  


//------------------------------------------------------------------------------
//   PANELS
//------------------------------------------------------------------------------

class panel : public LEDA_PANEL {

public:

 panel() {}
 panel(string s) : LEDA_PANEL(s) {}
~panel() {}


void label(string s);
void text_item(string s);

void string_item(string s, string& x);
void string_item(string label,string& x,list<string>& L);

void choice_item(string header,int& x,list<string>& L);
void choice_item(string header,int& x,string,string);
void choice_item(string header,int& x,string,string,string);
void choice_item(string header,int& x,string,string,string,string);
void choice_item(string header,int& x,string,string,string,string,string);

void int_item(string s,int& x);
void int_item(string s,int& x, int l, int h, int step);
void int_item(string s,int& x, int l, int h);

void bool_item(string s, bool& x);
void real_item(string s, double& x);
void double_item(string s, double& x);

void color_item(string s, color& x);
void lstyle_item(string s, line_style& x);

int button(string s);

void new_button_line();
void new_button_line(list<string>&);


// display panel window on screen

void display();                       // center on screen
void display(int x,int y);            // at (x,y) on screen
void display(window& W);              // center on window W
void display(window& W, int x,int y); // at (x,y) on window W


// read panel

int  read() { return LEDA_PANEL::read(); }


// open = display + read

int  open();                       // center on screen
int  open(int x,int y);            // at (x,y) on screen
int  open(window& W);              // center on window W
int  open(window& W, int x,int y); // at (x,y) on window W

int  open(list<string> buttons)   { new_button_line(buttons); return open(); }

};

#endif
