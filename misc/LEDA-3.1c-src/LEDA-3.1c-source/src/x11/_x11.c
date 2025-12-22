/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _x11.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



// basic graphic routines for libWx declared in <LEDA/impl/x_basic.h>
// implemented using the X11 library functions (libX11)


#include <LEDA/impl/x_basic.h>

#include <iostream.h>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include <LEDA/bitmaps/leda_icon.xbm>


static char dot_mask[2] = { 1,4 };
static char dash_mask[2] = { 4,4 };

static char* text_font_name = "screen16";
static char* bold_font_name = "screen-bold16";
static char* mesg_font_name = "10x20";

static char* text_font_name2 = "9x15";
static char* bold_font_name2 = "9x15bold";
static char* mesg_font_name2 = "lucidasans20";



static Display     *display = NULL;
static int          screen;
static XEvent       event;
static XGCValues    gc_val;
static GC           gc;
static Colormap     color_map;

static XFontStruct *text_font;
static XFontStruct *bold_font;
static XFontStruct *mesg_font;
static XFontStruct *current_font;

static int mesg_char_width;
static int bold_char_width;
static int text_char_width;
static int current_char_width;

const  int MAX_COLORS = 256; 
static unsigned long color_pix[MAX_COLORS];
static char* color_name[MAX_COLORS];
static int color_count= 0;

static int LINESTYLE = 0;
static int MODE      = 0;
static int COLOR     = 1;


static int get_char_width(XFontStruct* fp)
{ XCharStruct char_struct;
  int asc, desc, dir;
  XQueryTextExtents(display,fp->fid,"H",1, &dir,&asc,&desc,&char_struct);
  return char_struct.width;
}


void open_display(void)
{ 
  if (display!=NULL) return;

  if ((display = XOpenDisplay(0)) == NULL)	
  { fprintf(stderr, "Can\'t open display: \n");
    abort();
   }

  screen    = DefaultScreen(display);
  color_map = DefaultColormap(display,screen);
  gc        = DefaultGC(display,screen);


  if ((text_font = XLoadQueryFont(display,text_font_name)) == NULL)
  if ((text_font = XLoadQueryFont(display,text_font_name2)) == NULL)
  { fprintf(stderr,"Error: Cannot load text font");
    exit(1);
   }

  if ((bold_font = XLoadQueryFont(display,bold_font_name)) == NULL)
  if ((bold_font = XLoadQueryFont(display,bold_font_name2)) == NULL)
  { fprintf(stderr,"Error: Cannot load bold font");
    exit(1);
   }

  if ((mesg_font = XLoadQueryFont(display,mesg_font_name)) == NULL)
  if ((mesg_font = XLoadQueryFont(display,mesg_font_name2)) == NULL)
  { fprintf(stderr,"Error: Cannot load message font\n");
    exit(1);
   }


  XSetLineAttributes(display,gc,1,LineSolid,CapButt,JoinMiter);


  // 16 predefined colors from /usr/lib/X11/rgb.txt

  color_count = 0;

  new_color("white");          // 0: white
  new_color("black");          // 1: black
  new_color("red");            // 2: red
  new_color("green");          // 3: green
  new_color("blue");           // 4: blue
  new_color("yellow");         // 5: yellow
  new_color("purple");         // 6: violet
  new_color("darkorange");     // 7: orange
  new_color("cyan");           // 8: cyan
  new_color("sienna");         // 9: brown
  new_color("magenta");        //10: pink 
  new_color("forestgreen");    //11: darkgreen
  new_color("cornflowerblue"); //12: darkblue 
  new_color("grey75");         //13: grey1
  new_color("grey60");         //14: grey2
  new_color("grey45");         //15: grey3

  gc_val.foreground = color_pix[1];
  gc_val.function  = GXor; 
  gc_val.line_style = LineSolid;
  gc_val.line_width = 1;
  gc_val.font = text_font->fid;
  XChangeGC(display,gc,
            GCForeground|GCFunction|GCLineStyle|GCLineWidth|GCFont,&gc_val);

  text_char_width = get_char_width(text_font);
  bold_char_width = get_char_width(bold_font);
  mesg_char_width = get_char_width(mesg_font);
  current_char_width = text_char_width;
  current_font = text_font;
}


static char* duplicate_string(const char* p)
{ char* q = new char[strlen(p)+1];
  strcpy(q,p);
  return q;
}

int new_color(const char* name)
{ 
  open_display();

  // first test if color has been allocated before

  for(int i = 0; i < color_count; i++)
     if (strcmp(color_name[i],name)==0) break;
  if (i < color_count) return i;
  
  // if not, try to allocate it

  if (color_count == MAX_COLORS) return 0;

  XColor xcolor;

  if (DefaultDepth(display,screen)==1 && strcmp(name,"white")!=0) 
     XParseColor(display, color_map, "black", &xcolor);
  else
     XParseColor(display, color_map, name, &xcolor);

  XAllocColor(display,color_map,&xcolor);
  color_pix[color_count] = xcolor.pixel;
  char* p = new char[strlen(name)+1];
  strcpy(p,name);
  color_name[color_count] = p;
  return color_count++;
}
 
  

Window open_window(int x, int y, int width, int height, const char* header,
                                                        const char* label)
{
  Window win;
  XEvent e;
  XSetWindowAttributes attrib;
  XSizeHints size_hints;
  XWMHints wm_hints;
  Pixmap icon_pixmap;

  attrib.backing_store = Always;

  win= XCreateWindow(display, RootWindow(display, screen), x, y,
                           width,height,2,DefaultDepth(display,screen),
                           InputOutput, DefaultVisual(display,screen), 
                           CWBackingStore, &attrib);
 
  XSelectInput(display,win, KeyPressMask    | PointerMotionMask  | 
                            ButtonPressMask | ButtonReleaseMask  |
                            ExposureMask    | StructureNotifyMask ); 
  
  XSetWindowBackground(display,win, WhitePixel(display, screen)); 
 
  XStoreName(display,win,header);
  XSetIconName(display,win,label);

  icon_pixmap = XCreateBitmapFromData(display, win, leda_icon_bits, 
			leda_icon_width, leda_icon_height);

  size_hints.flags = PPosition;
  size_hints.x = x;
  size_hints.y = y;

  wm_hints.flags = StateHint | IconPixmapHint | InputHint;
  wm_hints.initial_state = NormalState;
  wm_hints.icon_pixmap = icon_pixmap;
  wm_hints.input = True;
  
  XSetWMProperties(display,win,0,0,0,0,&size_hints,&wm_hints,0);

  XMapWindow(display,win);

  while (1) 
  { XNextEvent(display, &e);
    if (e.type == Expose) break;
   }

  XDrawLine(display,win,gc,0,0,width-1,0);

  return win;
}


int display_width(void)
{ open_display();
  return DisplayWidth(display,screen);  
 }

int display_height(void)
{ open_display();
  return DisplayHeight(display,screen); 
 }

int display_depth(void)
{ open_display();
  return DefaultDepth(display,screen); 
 }

void flush_display(void)
{ XFlush(display); }

void close_display()
{ if (display) 
  { XCloseDisplay(display); 
    for(int i=0; i < color_count; i++) delete color_name[i];
    display = 0; 
   } 
}

void close_window(Window win)
{ XDestroyWindow(display,win); }
 
void clear_window(Window win, int col)
{ /* XClearWindow(display,win);  */
  int save_col = set_color(col);
  int save_mode = set_mode(0);
  box(win,1,1,window_width(win)-2,window_height(win)-2);
  set_color(1);
  rectangle(win,0,0,window_width(win)-1,window_height(win)-1);
  set_color(save_col);
  set_mode(save_mode);
}


void pixel(Window win, int x, int y)
{ XDrawPoint(display,win,gc,x,y); }


void pixels(Window win, int n, int *x, int *y)
{ XPoint* points = new XPoint[n];
  int i;
  for(i=0; i<n; i++)
  { points[i].x = (short)x[i];
    points[i].y = (short)y[i];
   }
  XDrawPoints(display,win,gc,points,n,CoordModeOrigin);
  delete points;
 }


void line(Window win, int x1, int y1, int x2, int y2)
{
   /* problems with clipping coordinates in [i*2^15..(i+1)*2^15-1], i odd  */

  if ((x1/(1<<15)) % 2) x1 = -x1;
  if ((x2/(1<<15)) % 2) x2 = -x2;
  if ((y1/(1<<15)) % 2) y1 = -y1;
  if ((y2/(1<<15)) % 2) y2 = -y2;

  XDrawLine(display,win,gc,x1,y1,x2,y2); 
 }
 

void rectangle(Window win, int x1, int y1, int x2, int y2)
{ if (x1 > x2)
  { int x = x1;
    x1 = x2;
    x2 = x;
   }
  if (y1 > y2)
  { int y = y1;
    y1 = y2;
    y2 = y;
   }
  XDrawRectangle(display,win,gc,x1,y1,x2-x1,y2-y1);
}
 
 
void box(Window win, int x1, int y1, int x2, int y2)
{ if (x1 > x2)
  { int x = x1;
    x1 = x2;
    x2 = x;
   }
  if (y1 > y2)
  { int y = y1;
    y1 = y2;
    y2 = y;
   }
  XFillRectangle(display,win,gc,x1,y1,x2-x1+1,y2-y1+1);
}


void arc(Window win, int x0, int y0, int r1, int r2, double start, double angle)
{ int s = (int)(360*32*start/M_PI);
  int a = (int)(360*32*angle/M_PI);
  XDrawArc(display,win,gc,x0-r1,y0-r2,2*r1,2*r2,s,a);
}


void circle(Window win, int x0, int y0, int r)
{ XDrawArc(display,win,gc,x0-r,y0-r,2*r,2*r,0,360*64); }

void ellipse(Window win, int x0, int y0, int r1, int r2)
{ XDrawArc(display,win,gc,x0-r1,y0-r2,2*r1,2*r2,0,360*64); }


void fill_arc(Window win, int x0, int y0, int r1, int r2, double start, double angle)
{ int s = (int)(360*32*start/M_PI);
  int a = (int)(360*32*angle/M_PI);
  XFillArc(display,win,gc,x0-r1,y0-r2,2*r1,2*r2,s,a);
}

void fill_circle(Window win, int x0, int y0, int r)
{ XFillArc(display,win,gc,x0-r,y0-r,2*r,2*r,0,360*64); }


void fill_ellipse(Window win, int x0, int y0, int r1, int r2)
{ XFillArc(display,win,gc,x0-r1,y0-r2,2*r1,2*r2,0,360*64); }


void fill_polygon(Window win, int n, int *xcoord, int *ycoord)
{ XPoint* edges = new XPoint[n];
  int i;
  for(i=0;i<n;i++) 
  { edges[i].x = (short) xcoord[i];
    edges[i].y = (short) ycoord[i];
   }

  XFillPolygon(display,win,gc,edges,n,Nonconvex,CoordModeOrigin);

  delete edges;
}


void put_text(Window win, int x, int y, const char* s, int opaque)
{ y += current_font->ascent;
  if (opaque)
     XDrawImageString(display,win,gc,x,y,s,strlen(s));
  else
     XDrawString(display,win,gc,x,y,s,strlen(s));
}


void put_ctext(Window win, int x, int y, const char* s, int opaque)
{ x -= text_width(s)/2;
  y -= text_height(s)/2;
  put_text(win,x,y,s,opaque);
 }


void show_coordinates(Window win, const char* s)
{ put_text(win,window_width(win)-160,2,s,1); }

 
int text_width(const char* s)
{ return current_char_width * strlen(s); }
 
 
int text_height(const char*)
{ return(current_font->ascent+current_font->descent/2); }
 

void copy_rect(Window win, int x1, int y1, int x2, int y2, int x, int y)
{
  int save = set_mode(0);   /* src-mode */

  Pixmap P=XCreatePixmap(display,win,x2-x1,y2-y1,DefaultDepth(display,screen));

  XCopyArea(display,win,P,gc, x1,y1,x2-x1,y2-y1,0,0);
  XCopyArea(display,P,win,gc,0,0,x2-x1,y2-y1,x,y);

  set_mode(save);
 }

void insert_bitmap(Window win, int width, int height, char* data)
{ int save = set_mode(0);
  Pixmap P=XCreatePixmapFromBitmapData(display,win,data,width,height,
                                       BlackPixel(display,screen), 
                                       WhitePixel(display,screen), 
                                       DefaultDepth(display,screen));
  XCopyArea(display,P,win,gc,0,0,width,height,0,0);
  set_mode(save);
 }

 
void set_header(Window win, const char* s)
{ XStoreName(display,win,s); }


int set_color(int col)
{ int save = COLOR;
  COLOR = col;
  gc_val.foreground = color_pix[col];
  XChangeGC(display,gc,GCForeground,&gc_val);
  return col;
 }


int set_mode(int m)
{ int save = MODE;

  MODE = m;

  switch (m)  {

   case 0 : gc_val.function = GXcopy;
            break;

   case 1 : gc_val.function = GXxor;
            break;

   case 2 : gc_val.function = GXor;
            break;

  }

  XChangeGC(display,gc,GCFunction,&gc_val);

  return save;
}


int load_text_font(const char* font_name)
{ XFontStruct* fp = XLoadQueryFont(display,font_name);
  if (fp)  
  { text_font = fp;
    text_char_width = get_char_width(fp);
   }
  return (fp != NULL);
 }


int load_bold_font(const char* font_name)
{ XFontStruct* fp = XLoadQueryFont(display,font_name);
  if (fp)  
  { bold_font = fp;
    bold_char_width = get_char_width(fp);
   }
  return (fp != NULL);
 }


int load_message_font(const char* font_name)
{ XFontStruct* fp = XLoadQueryFont(display,font_name);
  if (fp)  
  { mesg_font = fp;
    mesg_char_width = get_char_width(fp);
   }
  return (fp != NULL);
 }


int set_font(const char *fname)
{ XFontStruct* fp = XLoadQueryFont(display,fname);
  if (fp)
  { current_font = fp;
    current_char_width = get_char_width(fp);
    gc_val.font = fp->fid;
    XChangeGC(display,gc,GCFont,&gc_val);
   }
  return (fp != NULL);
 }


void set_text_font(void)
{ current_font = text_font;
  gc_val.font = text_font->fid;
  XChangeGC(display,gc,GCFont,&gc_val);
  current_char_width = text_char_width;
 }


void set_bold_font(void)
{ current_font = bold_font;
  gc_val.font = bold_font->fid;
  XChangeGC(display,gc,GCFont,&gc_val);
  current_char_width = bold_char_width;
 }


void set_message_font(void)
{ current_font = mesg_font;
  gc_val.font = mesg_font->fid;
  XChangeGC(display,gc,GCFont,&gc_val);
  current_char_width = mesg_char_width;
 }



int set_line_width(int w)
{ int save = gc_val.line_width;
  gc_val.line_width = w;
  XChangeGC(display,gc,GCLineWidth,&gc_val);
  return save;
}


int set_line_style(int s)
{ 
  int save = LINESTYLE;

  LINESTYLE = s;

  switch (s)  {

   case 0 : gc_val.line_style = LineSolid;
            break;

   case 1 : gc_val.line_style = LineOnOffDash;
            XSetDashes(display,gc,0,dash_mask,2);
            break;

   case 2 : gc_val.line_style = LineOnOffDash;
            XSetDashes(display,gc,0,dot_mask,2);
            break;
   }

  XChangeGC(display,gc,GCLineStyle,&gc_val);
  return save;
}


void set_read_gc(void)
{XGCValues gc_val0;
 gc_val0.function = GXxor; 
 gc_val0.foreground = BlackPixel(display,screen); 
 gc_val0.line_style = LineSolid;
 gc_val0.line_width = 1;
 XChangeGC(display,gc,GCForeground|GCFunction|GCLineStyle|GCLineWidth,&gc_val0);
 flush_display();
}

void reset_gc(void)
{ XChangeGC(display,gc,GCForeground|GCFunction|GCLineStyle|GCLineWidth,&gc_val);
  flush_display();
}


int window_height(Window win)
{ Window w;
  int xpos,ypos;
  unsigned width,height,bw,dep;
  XGetGeometry(display,win,&w,&xpos,&ypos,&width,&height,&bw,&dep);
  return height;
 }

int window_width(Window win)
{ Window w;
  int xpos,ypos;
  unsigned width,height,bw,dep;
  XGetGeometry(display,win,&w,&xpos,&ypos,&width,&height,&bw,&dep);
  return width;
 }


void window_position(Window win, int *x, int *y)
{ XSizeHints size_hints;
  long flags = PPosition;
  XGetWMNormalHints(display,win,&size_hints,&flags);
  *x = size_hints.x;
  *y = size_hints.y;
 }


static int  handle_event(Window *win,int *val,int *x,int *y,unsigned long *t)
{
  KeySym keysym;
  XComposeStatus status;

  int  kind;
  char c;

  *win = event.xany.window;
  *val = 0;

  switch (event.type) {

  case ConfigureNotify: kind = configure_event;
                        *x = event.xconfigure.width;
                        *y = event.xconfigure.height;
                        break;

  case DestroyNotify: kind = destroy_event;
                      break;

  case ButtonPress: *val = event.xbutton.button;
                    *x = event.xbutton.x;
                    *y = event.xbutton.y;
                    *t = event.xbutton.time;
                    kind = button_press_event;
                    if (event.xbutton.state & Mod1Mask) *val = 2; 
                    if (event.xbutton.state & ShiftMask) *val = -*val;
                    if (event.xbutton.state & ControlMask) *val += 3;
                    break;

  case ButtonRelease: *val = event.xbutton.button;
                      *x = event.xbutton.x;
                      *y = event.xbutton.y;
                      *t = event.xbutton.time;
                      if (event.xbutton.state & Mod1Mask) *val = 2; 
                      if (event.xbutton.state & ShiftMask) *val = -*val;
                      if (event.xbutton.state & ControlMask) *val += 3;
                      kind = button_release_event;
                      break;

  case MotionNotify: *x = event.xmotion.x;
                     *y = event.xmotion.y;
                     kind = motion_event;
                     break;

  case KeyPress: *x = event.xmotion.x;
                 c = 0;
                 XLookupString((XKeyEvent*)&event,&c,1, &keysym, &status);
                 *val = c;
                 kind = key_press_event;
                 break;

  }

  return kind;
}


int check_next_event(Window *win, int *val, int *x, int *y, unsigned long *t) 
{ // non-blocking 
 
  if (XCheckMaskEvent(display, 
                      KeyPressMask    | // PointerMotionMask  | 
                      ButtonPressMask | ButtonReleaseMask  |
                      ExposureMask    | StructureNotifyMask, &event) == 0) 
      return no_event; 

  return handle_event(win,val,x,y,t);
}


int get_next_event(Window *win, int *val, int *x, int *y, unsigned long *t)
{ // blocking

  XNextEvent(display, &event);
  return handle_event(win,val,x,y,t);
}



void put_back_event(void)
{ XPutBackEvent(display,&event); }

