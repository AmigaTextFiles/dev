/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  leda_panel.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/leda_window.h>


#define MAX_BUT_NUM  64
#define MAX_ITEM_NUM 32


class LEDA_PANEL : public LEDA_WINDOW {

Window win;

char*  header;

int    XPOS;
int    YPOS;

int    but_count;
int    item_count;
int    act_str_item;

char*  button_str[MAX_BUT_NUM];
char*  label_str [MAX_ITEM_NUM];

int    kind   [MAX_ITEM_NUM];
void*  ref    [MAX_ITEM_NUM];
int    dat1   [MAX_ITEM_NUM];   // min (slider), size (choice), 
                                // number of menu items (string_menu_item)
int    dat2   [MAX_ITEM_NUM];   // max (slider)  step (choice)
int    offset [MAX_ITEM_NUM];   // choice item only
char** choices[MAX_ITEM_NUM];   // choice item, string_menu_item)

int   but_layout;


void activate_string_item(int xoff, int yoff, int yskip, int ytskip, 
                                                         int t_length, int n);
int  panel_text_edit(int xt, int yt, int t_len, char *str);
void put_text_item(int x, int y, const char* s, int t_len);
void draw_choice_item(int i,int x0, int y0, int width,int yskip);
void draw_bool_item(int i,int x0, int y0, int width,int yskip);
void draw_slider_item(int i, int x01, int x0, int y0,int length, int yskip, float x);
void draw_button(const char* s, int x, int y, int bw,int yskip, int pressed);


public:

void text_item(const char* s);
void string_item(const char* s, char** x);
void string_menu_item(const char* s, char** x, const char* menu_label,int argc,const char** argv);
void int_item(const char* s, int* x);
void slider_item(const char* s, int* x, int min, int max);
void float_item(const char* s, double* x);
void choice_item(const char* text, int* address, int argc, const char** argv, int step, int offset);
void bool_item(const char* text, char* address);
int  button(const char* s);
void button_line(int n, const char** b) ;

void display(int xpos,int ypos,int win_x,int win_y,int win_width,int win_height);

int read();

int open(int xpos,int ypos,int win_x,int win_y,int win_width,int win_height,int mode=1);

void close();

 LEDA_PANEL(const char* label="", int bl=0);

~LEDA_PANEL();

static void panel_redraw_func();

};


