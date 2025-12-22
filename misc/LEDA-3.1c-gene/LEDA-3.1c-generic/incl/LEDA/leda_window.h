/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  leda_window.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BASIC_WINDOW_H
#define LEDA_BASIC_WINDOW_H

#include <LEDA/impl/x_window.h>

typedef double (*draw_func_ptr) (double);
typedef void   (*redraw_func_ptr) ();
typedef void   (*mouse_action_func_ptr) (double,double);


class color {

  int col_index;

public:

  color(const char*);
  color(int=black);
  operator int() const  { return col_index; }
};


extern color FG_color;
extern color BG_color;



struct LEDA_WINDOW {

Window draw_win;

int ref_count;

char default_frame_label[128];

mouse_action_func_ptr mouse_action;
redraw_func_ptr redraw;

int show_coord;

// pixel coordinates
int xdots;
int ydots;
int xorigin;
int yorigin;

// mouse data
int mouse_key;
int mouse_xpix;
int mouse_ypix;
int mouse_start_xpix;
int mouse_start_ypix;
unsigned long mouse_press_time;
unsigned long mouse_release_time;

double mouse_xreal;
double mouse_yreal;
double mouse_last_xreal;
double mouse_last_yreal;
double mouse_start_xreal;
double mouse_start_yreal;


char* mesg_list[32];
int   mesg_count;

//window coordinates
double max_xcoord;
double min_xcoord;
double max_ycoord;
double min_ycoord;
double scaling;

//window geomtry
int window_xpos;
int window_ypos;
int window_width;
int window_height;
int grid_mode;
int depth;

//window parameters

int line_width;
int node_width;
int screen_flush;

line_style   line_st;
text_mode    text_mo;
drawing_mode drawing_mo;


void cursor(void);

static int event_handler(LEDA_WINDOW*&,int);

static LEDA_WINDOW* window_list[32]; // list of all opened windows
static int count;  // number of opened windows

static LEDA_WINDOW*  read_window; 
static LEDA_WINDOW*  active_window; 

static void mouse_default_action(double,double);
static void mouse_segment_action(double x, double y) ;
static void mouse_rect_action(double x, double y);
static void mouse_circle_action(double x, double y);
static int screen_width(void);
static int screen_height(void);
static int screen_depth(void);


protected:

int state;


public:

// setting parameters

void set_show_coordinates(int x) { show_coord = x; }
void set_redraw(redraw_func_ptr f) { redraw = f; }

int  load_text_font(const char* fname);
int  load_bold_font(const char* fname);
int  load_message_font(const char* fname);

int          set_font(const char* s);
void         set_grid_mode(int i);
line_style   set_line_style(line_style s);
int          set_line_width(int w);
drawing_mode set_mode(drawing_mode m);
int          set_node_width(int w);
text_mode    set_text_mode(text_mode m);
void         set_frame_label(const char* s);
void         reset_frame_label();
void         set_flush(int b) { screen_flush = b; }
void         set_palette(int c, int r, int g, int b);


// reading parameters

int          get_line_width() { return line_width; }
int          get_node_width() { return node_width; }
int          get_grid_mode()  { return grid_mode; }
line_style   get_line_style() { return line_st;    }
text_mode    get_text_mode()  { return text_mo;    }
drawing_mode get_mode()       { return drawing_mo; }

int    mono()  { return depth == 1; }
double xmin()  { return min_xcoord; }
double xmax()  { return max_xcoord; }
double ymin()  { return min_ycoord; }
double ymax()  { return max_ycoord; }
double scale() { return scaling; }

int xpos() { return window_xpos; }
int ypos() { return window_ypos; }
int width() { return window_width; }
int height() { return window_height; }


int xpix(double coord) { return int(xorigin + (coord)*scaling); }
int ypix(double coord) { return int(yorigin - (coord)*scaling); }

double pix_num(int p) { return p/scaling; }
double pix_to_real(int p) { return p/scaling; }
int real_to_pix(double d) { return int(d*scaling); }

double xreal(int pix)  { return double(pix-xorigin)/scaling; }
double yreal(int pix)  { return double(yorigin-pix)/scaling; }


void init(double x0, double x1, double y0, int g_mode=0);


void flush();

void open(int w_width, int w_height, int w_xpos, int w_ypos, 
                                                      const char *frame_label);
void close();

 LEDA_WINDOW(float width,float height,float xpos,float ypos,
                                                  const char *frame_label = "");
 LEDA_WINDOW(float width,float height, const char *frame_label = "");
 LEDA_WINDOW(const char* frame_label);
 LEDA_WINDOW();
 LEDA_WINDOW(const LEDA_WINDOW&);

~LEDA_WINDOW();

 LEDA_WINDOW& operator=(const LEDA_WINDOW&);

// events

int  read_event(int& k, double& x, double& y);
int  get_event(int& k, double& x, double& y);
void put_back_event();


// mouse input

friend int read_mouse(LEDA_WINDOW*&,double&,double&);

int read_mouse_action(mouse_action_func_ptr action, double xstart, double ystart, double& x, double& y);
int read_mouse(int kind, double xstart, double ystart, double& x, double& y);
int get_button(double& x, double& y);

unsigned long button_press_time();
unsigned long button_release_time();


// drawing

void draw_pix(double x, double y, int col=black);
void draw_point(double x, double y, int col=black);
void draw_segment(double x1, double y1, double x2, double y2, int col=black);

void draw_node(double x0, double y0, int col=black);
void draw_filled_node(double x0, double y0, int col=black);
void draw_text_node(double x0, double y0, char *s, int col=white);
void draw_int_node(double x0, double y0, int i, int col=white);

void draw_edge(double x1, double y1, double x2, double y2, int col=black);

void draw_circle(double x0, double y0, double r, int col=black);
void draw_filled_circle(double x0, double y0, double r, int col=black);
void draw_ellipse(double x0, double y0, double a, double b, int col=black);
void draw_filled_ellipse(double x0, double y0, double a, double b, int col=black);
void draw_arc(double x0, double y0, double r1, double r2, double start, double angle, int col=black);
void draw_filled_arc(double x0, double y0, double r1, double r2, double start, double angle, int col=black);

void draw_polygon(int n, double *xcoord, double *ycoord, int col=black);
void draw_filled_polygon(int n, double *xcoord, double *ycoord, int col=black);
void draw_rectangle(double x1, double y1, double x2, double y2, int col=black);
void draw_filled_rectangle(double x1, double y1, double x2, double y2, int col=black);


void plot_xy(double x0, double x1, double (*f) (double), int col=black);
void plot_yx(double y0, double y1, double (*f) (double), int col=black);

// text

void draw_text(double x, double y, const char* s, int col=black);
void draw_ctext(double x, double y, const char* s, int col=black);


// misc

void clear(int col=white);
void message(const char *s);
void del_messages(void);
void copy_rect(double x1, double y1, double x2, double y2, double x, double y);
void insert_bitmap(int width, int height, char* data);

};



// some useful functions

char* Read_Leda_Bitmap(const char* fname, int& w, int& h) ;

void put_back_event();

#endif
