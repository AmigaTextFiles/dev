/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  x_basic.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_X_BASIC_H
#define LEDA_X_BASIC_H

#include <LEDA/impl/x_window.h>


/* init/close graphics display */

void open_display(void);
void close_display(void);
void flush_display(void);


/* return display parameters */

int display_width(void);
int display_height(void);
int display_depth(void);

int new_color(const char*);


/* windows */

Window open_window(int x,int y,int width,int height,const char* header,
                                                    const char* label);
void   close_window(Window win);
void   clear_window(Window win, int col=0);
int    window_height(Window win);
int    window_width(Window win);
void   window_position(Window win, int* x, int* y);


/* drawing */

void pixel(Window win, int x, int y);
void pixels(Window win, int n, int* x, int* y);
void line(Window win, int x1, int y1, int x2, int y2);
void rectangle(Window win, int x1, int y1, int x2, int y2);
void box(Window win, int x1, int y1, int x2, int y2);
void arc(Window win,int x0,int y0,int r1,int r2,double start,double angle);
void circle(Window win, int x0, int y0, int r);
void ellipse(Window win, int x0, int y0, int r1, int r2);
void fill_arc(Window win,int x0,int y0,int r1,int r2,double start,double angle);
void fill_circle(Window win, int x0, int y0, int r);
void fill_ellipse(Window win, int x0, int y0, int r1, int r2);
void fill_polygon(Window win, int n, int* xcoord, int* ycoord);
void put_text(Window win, int x, int y, const char* s, int opaque);
void put_ctext(Window win, int x, int y, const char* s, int opaque);


/* miscellaneous */

void copy_rect(Window win, int x1, int y1, int x2, int y2, int x, int y);
void insert_bitmap(Window win, int width, int height, char* data);
void show_coordinates(Window win, const char* s);


/* text geometry in current font */

int text_width(const char* s);
int text_height(const char* s);


/* loading fonts */

int load_text_font(const char* font_name);
int load_bold_font(const char* font_name);
int load_message_font(const char* font_name);


/* setting parameters */

void set_header(Window win, const char *s);
int  set_color(int col);
int  set_mode(int m);
int  set_line_width(int w);
int  set_line_style(int s);
int  set_font(const char* fname);
void set_text_font(void);
void set_bold_font(void);
void set_message_font(void);
void set_read_gc(void);
void reset_gc(void);

/* events */

int  get_next_event(Window* win, int* val, int* x, int* y, unsigned long *t);
int  check_next_event(Window* win, int* val, int* x, int* y, unsigned long *t);
void put_back_event(void);


#endif
