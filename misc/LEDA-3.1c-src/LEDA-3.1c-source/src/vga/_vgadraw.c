/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _vgadraw.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/* basic graphic routines of libWx  declared in <LEDA/impl/x_basic.h>) 
 * iplemented for MSDOS using the VGA 640x480x16 color graphics mode
 */

#include "vga.h"
#include "vgafont"

static VIDEO_PTR video_buf;
static int COLOR = 1;
static int MODE  = 0;
static int LINEWIDTH = 1;
static int LINESTYLE = 0;


void flush_display() {}

int  new_color(const char*) { return 1; }

int  text_height(const char*)  { return FONT_HEIGHT; }
int  text_width(const char* s) { return FONT_WIDTH*strlen(s); }

int load_text_font(const char*) { return 0;}
int load_bold_font(const char*) { return 0;}
int load_message_font(const char*) { return 0;}

int  set_font(const char*) { return 0;}
void set_text_font() {}
void set_bold_font() {}
void set_message_font() {}

int set_line_width(int width)
{ int save = LINEWIDTH;
  LINEWIDTH = width;
  return save;
}

int set_line_style(int style)
{ int save = LINESTYLE;
  LINESTYLE = style;
  return save;
}

int set_color(int color)
{  int save = COLOR;
   COLOR = color;
   port_out(0x00, GRA_I );
   port_out(color, GRA_D );
   return save;
 }

int set_mode(int mode)
{ int save = MODE;

  MODE = mode;

  if (mode==1)         mode = 3; /* xor */
  else if (mode==2)    mode = 2; /* or  */
     else if (mode==3) mode = 1; /* and */
                  else mode = 0; /* src */

  port_out(0x03, GRA_I );
  port_out(mode<<3, GRA_D );
  return save;
}


static void put_pixel(VgaWindow win, int x, int y)
{ VIDEO_PTR p;

  if (x < 0 || x >= win->width || y < 0 || y >= win->height) return;

  x += win->xpos;
  y += win->ypos;

  if (VIDEO==0)   /* write into (monochrome) buffer */
     video_buf[y*LINE_BYTES+(x>>3)] |= (0x80 >> (x & 7));
  else
  { p = VIDEO + y*LINE_BYTES + (x>>3);
    port_out(8, GRA_I);
    port_out((0x80 >> (x & 7)), GRA_D);
    *p = *p;
   }
}

static void vline(VgaWindow win,int x, int y0, int y1)
{ register VIDEO_PTR p;
  register VIDEO_PTR last;

  if (y0 > y1)
  { int y = y0;
    y0 = y1;
    y1 = y;
   }

  if (x < 0 || x >= win->width || y1 < 0 || y0 >= win->height) return;

  if (y0 < 0) y0 = 0;
  if (y1 >= win->height) y1 = win->height-1;

  x  += win->xpos;
  y0 += win->ypos;
  y1 += win->ypos;

  port_out(8, GRA_I);
  port_out(128 >> (x&7), GRA_D);
  last  = VIDEO + LINE_BYTES*y1 + (x>>3);
  for(p = VIDEO + LINE_BYTES*y0 + (x>>3); p <= last; p+=LINE_BYTES)  *p = *p;

}


static void hline(VgaWindow win, int x0, int x1, int y)
{ register VIDEO_PTR p;
  register VIDEO_PTR first;
  register VIDEO_PTR last;
  char byte;

  if (x0 > x1)
  { int x = x0;
    x0 = x1;
    x1 = x;
   }
  if (y < 0 || y >= win->height || x1 < 0 || x0 >= win->width) return;
  if (x0 < 0) x0 = 0;
  if (x1 >= win->width) x1 = win->width-1;

  x0 += win->xpos;
  x1 += win->xpos;
  y  += win->ypos;


  if (x0 > DISP_MAX_X  || y > DISP_MAX_Y || y < 0) return;

  if (x1 > DISP_MAX_X) x1 = DISP_MAX_X;
  if (x0 < 0) x0 = 0;

  first = VIDEO + LINE_BYTES*y + (x0>>3);
  last  = VIDEO + LINE_BYTES*y + (x1>>3);

  port_out(8, GRA_I);

  if (first == last)
  { byte  = 0xFF>>(x0&7);
    byte &= 0xFF<<((~x1)&7);
    port_out(byte, GRA_D);
    *first = *first;
    return;
   }

  port_out(0xFF>>(x0&7), GRA_D);
  *first = *first;

  port_out(0xFF<<((~x1)&7), GRA_D);
  *last = *last;

  port_out(0xFF, GRA_D);
  for(p=first+1; p<last; p++) *p = *p;

 }


static void Draw_Line(VgaWindow win, int x1, int y1, int x2, int y2)
{
  register int sy = 1;
  register int dx = x2 - x1;
  register int dy = y2 - y1;
  register int c;
  int i;

  if (dx < 0)
  { int i = x1;
    x1 = x2;
    x2 = i;
    dx = -dx;
    i = y1;
    y1 = y2;
    y2 = i;
    dy = -dy;
   }
  if (dy < 0)
  { dy = -dy;
    sy = -1;
   }

  if (dx > dy)
  { c = dx / 2;
    put_pixel(win,x1,y1);
    for (i=1; i<=LINEWIDTH/2; i++)
    { put_pixel(win,x1,y1+i);
      put_pixel(win,x1,y1-i);
     }
    while(x1 != x2)
    { x1++;
      c += dy;
      if (c >= dx)
      { c -= dx;
        y1 += sy;
       }
      put_pixel(win,x1,y1);
      for (i=1; i<=LINEWIDTH/2; i++)
      { put_pixel(win,x1,y1+i);
        put_pixel(win,x1,y1-i);
       }
    }
  }
  else
  { c = dy / 2;
    put_pixel(win,x1,y1);
    for (i=1; i<=LINEWIDTH/2; i++)
    { put_pixel(win,x1+i,y1);
      put_pixel(win,x1-i,y1);
     }
    while(y1 != y2)
    { y1 += sy;
      c += dx;
      if (c >= dy)
      { c -= dy;
        x1++;
       }
      put_pixel(win,x1,y1);
      for (i=1; i<=LINEWIDTH/2; i++)
      { put_pixel(win,x1+i,y1);
        put_pixel(win,x1-i,y1);
       }
    }
  }
}

void line(Window w, int x1, int y1, int x2, int y2)
{ int i;

  VgaWindow win = win_stack[w];

  if (x1 == x2)
  { vline(win,x1,y1,y2);
    for (i=1; i<=LINEWIDTH/2; i++)
    { vline(win,x1-i,y1,y2);
      vline(win,x1+i,y1,y2);
     }
    return;
   }

  if (y1 == y2)
  { hline(win,x1,x2,y1);
    for (i=1; i<=LINEWIDTH/2; i++)
    { hline(win,x1,x2,y1-i);
      hline(win,x1,x2,y1+i);
     }
    return;
   }

  Draw_Line(win,x1,y1,x2,y2);
}



static int get_pixel(int x, int y)
{
  register int bit = 0x80 >> (x&7);
  register VIDEO_PTR byte = VIDEO + LINE_BYTES*y+(x>>3);
  register int c;

  if (x < 0 || x > DISP_MAX_X || y < 0 || y > DISP_MAX_Y) return 0;

  /* set read mode 1 */
  port_out(5, GRA_I);
  port_out(8, GRA_D);

  for(c=0; c<16; c++)
  { port_out(2, GRA_I);
    port_out(c, GRA_D);
    if (*byte & bit)  break;
   }

  return c;
}


#define FILLPUT(pos,byte)\
{ p = pos;\
  if ((*p & (byte)) == 0)\
  { *p |= (byte);\
    POS[top] = p; \
    BYTE[top] = byte; \
    top = (top+1) % 512; } else;\
}

static  VIDEO_PTR      POS[512];
static  unsigned char  BYTE[512];

static void fill_bits(VIDEO_PTR pos,unsigned char byte)
{ register int bot = 0;
  register int top = 0;
  register VIDEO_PTR p;

  FILLPUT(pos,byte)

  while (top != bot)
  { pos  = POS[bot];
    byte = BYTE[bot];

    bot = (bot+1) % 512;

    if (byte == 128)
       FILLPUT(pos-1,1)
    else
       FILLPUT(pos,byte<<1)

    if (byte == 1)
       FILLPUT(pos+1,128)
    else
       FILLPUT(pos,byte>>1)

    FILLPUT(pos-LINE_BYTES,byte)
    FILLPUT(pos+LINE_BYTES,byte)
  }
}

static  VIDEO_PTR  POS1[512];
static  int pos_top = 0;

void fill_bytes(VIDEO_PTR pos, int d)
{ VIDEO_PTR p = pos+d;

  unsigned char c = *p;
  unsigned char pat = 0xFF;

  if (c == 0)
  { *p = 0xFF;
    fill_bytes(p,  1);
    fill_bytes(p, -1);
    fill_bytes(p, LINE_BYTES);
    fill_bytes(p,-LINE_BYTES);
    return;
   }

  if (d == -1)
  { while((c&1) == 0)
    { pat <<= 1;
      c >>= 1;
     }
    *p |= ~pat;
   }

  if (d == 1)
  { while((c&128) == 0)
    { pat >>= 1;
      c <<= 1;
     }
    *p |= ~pat;
   }

  if((c&8) == 0 && (d == LINE_BYTES || d == -LINE_BYTES))   POS1[pos_top++] = p;

 }


void fill_polygon(Window w, int n, int* xcoord, int* ycoord)
{
  VgaWindow win = win_stack[w];

  register VIDEO_PTR p;
  register VIDEO_PTR q;
  register VIDEO_PTR first;
  register VIDEO_PTR first1;
  register VIDEO_PTR last;

  int i,m1,m2;
  int minxi = 0;
  int maxxi = 0;
  int minyi = 0;
  int maxyi = 0;
  int minx,maxx,miny,maxy,x,y;

  VIDEO_PTR video_save = VIDEO;

  VIDEO = 0;

  video_buf = (VIDEO_PTR)malloc(LINE_BYTES*480);


  for(i=1;i<n;i++)
  { minxi = (xcoord[i] < xcoord[minxi]) ? i : minxi;
    minyi = (ycoord[i] < ycoord[minyi]) ? i : minyi;
    maxxi = (xcoord[i] > xcoord[maxxi]) ? i : maxxi;
    maxyi = (ycoord[i] > ycoord[maxyi]) ? i : maxyi;
   }

  minx = (xcoord[minxi] + win->xpos)/8;
  maxx = (xcoord[maxxi] + win->xpos)/8;
  miny = ycoord[minyi] + win->ypos;
  maxy = ycoord[maxyi] + win->ypos;

  m1 =  (minxi == 0)   ?  n-1 : minxi-1;
  m2 =  (minxi == n-1) ?  0   : minxi+1;

  for(i=miny; i<=maxy; i++)
  { last = video_buf+LINE_BYTES*i + maxx;
    for(p=video_buf+LINE_BYTES*i+minx; p<=last; p++) *p= 0;
   }

  for(i=0; i<n-1; i++)
      Draw_Line(win,xcoord[i],ycoord[i],xcoord[i+1],ycoord[i+1]);

  Draw_Line(win,xcoord[0],ycoord[0],xcoord[n-1],ycoord[n-1]);

  x = (xcoord[m1] + xcoord[m2] + xcoord[minxi])/3 + win->xpos;
  y = (ycoord[m1] + ycoord[m2] + ycoord[minxi])/3 + win->ypos;

  pos_top = 0;
  fill_bytes(video_buf + LINE_BYTES*y + x/8,0);

  while (pos_top--) fill_bits(POS1[pos_top],8);

  fill_bits(video_buf+LINE_BYTES*y+x/8,128>>(x%8));

  VIDEO = video_save;

  first  = video_buf+LINE_BYTES*miny + minx;
  first1 = VIDEO+LINE_BYTES*miny + minx;
  last   = video_buf+LINE_BYTES*miny + maxx;

  port_out(8, GRA_I);

  while(miny <= maxy)
  { for(p=first, q = first1; p<=last; p++, q++)
    { port_out(*p, GRA_D);
      *q = *q;
     }
    first  += LINE_BYTES;
    first1 += LINE_BYTES;
    last   += LINE_BYTES;
    miny++;
   }

  free((char*)video_buf);
}


void box(Window w, int x0, int y0, int x1, int y1)
{ VgaWindow win = win_stack[w];
  if (y0 > y1)
  { int y = y0;
    y0 = y1;
    y1 = y;
   }
  while(y0<=y1) hline(win,x0,x1,y0++);
 }


void  rectangle(Window w, int x0, int y0, int x1, int y1)
{ 
  int left  = x0;
  int right = x1;
  int top   = y0;
  int bottom= y1;

  if (x0 > x1)
  { left  = x1;
    right = x0;
   }

  if (y0 > y1)
  { top  = y1;
    bottom = y0;
   }

  line(w,left, top,     right,top);
  line(w,left, bottom,  right,bottom);
  line(w,left, bottom-1,left, top+1);
  line(w,right,bottom-1,right,top+1);
}


void circle(Window w, int x0,int y0,int r0)
{ VgaWindow win = win_stack[w];
  int r;

  for (r = r0-LINEWIDTH/2; r <= r0+LINEWIDTH/2; r++)
  { int y = r;
    int x = 0;
    int e = 3-2*y;

    put_pixel(win,x0,y0+r);
    put_pixel(win,x0,y0-r);
    put_pixel(win,x0+r,y0);
    put_pixel(win,x0-r,y0);

    for (x=1;x<y;)
      { put_pixel(win,x0+x,y0+y);
        put_pixel(win,x0+x,y0-y);
        put_pixel(win,x0-x,y0+y);
        put_pixel(win,x0-x,y0-y);
        put_pixel(win,x0+y,y0+x);
        put_pixel(win,x0+y,y0-x);
        put_pixel(win,x0-y,y0+x);
        put_pixel(win,x0-y,y0-x);
        x++;
        if (e>=0) { y--; e = e - 4*y; }
        e = e + 4*x + 2;
       }

    if (x == y)
    { put_pixel(win,x0+x,y0+y);
      put_pixel(win,x0+x,y0-y);
      put_pixel(win,x0-x,y0+y);
      put_pixel(win,x0-x,y0-y);
     }
  }
}


void fill_circle(Window w, int x0, int y0, int r)
{ VgaWindow win = win_stack[w];
  int y = 1;
  int x = r;
  int e = 3-2*r;

  hline(win,x0-x,x0+x,y0);

  while (y<=x)
  { hline(win,x0-x,x0+x,y0+y);
    hline(win,x0-x,x0+x,y0-y);

    if (y<x && e>=0)
    { hline(win,x0-y,x0+y,y0+x);
      hline(win,x0-y,x0+y,y0-x);
      x--;
      e = e - 4*x;
     }
    y++;
    e = e + 4*y + 2;
   }
}



static void Put_Text(VgaWindow win, int x, int y, const char *str, int bg_col)
{ /* bgcol = -1 : transparent */
  register unsigned char *fp1;
  register unsigned char *fp2;
  register unsigned char c;

  register VIDEO_PTR start;
  register VIDEO_PTR stop;
  register VIDEO_PTR q;

  char text[128];
  int dy,i;
  int len = strlen(str);
  int l = (win->width-x)/text_width("H");
  if (len > l) len = l;
  if (len > 0) strncpy(text,str,len);
  text[len] = 0;


  if (y < 0 || y >= win->height || x < 0 || x >= win->width) return;

  if (bg_col >= 0)
  { int save_color = set_color(bg_col);
    int save_mode = set_mode(0);
    box(win->id,x,y,x+text_width(text)-1,y+text_height(text)-1);
    set_mode(save_mode);
    set_color(save_color);
   }

  dy = win->height - y;

  if (dy > FONT_HEIGHT) dy = FONT_HEIGHT;

  x += win->xpos;
  y += win->ypos;

  fp1 = FONT + FONT_HEIGHT * ' ';
  fp2 = FONT + FONT_HEIGHT * (text[0] & 127);

  start = VIDEO + LINE_BYTES*y + x/8;
  stop = start + LINE_BYTES*dy;

  x &= 7;

  port_out(8, GRA_I);

  for(i=0;i<len; i++)
  { for (q = start; q < stop; q+=LINE_BYTES, fp1++,fp2++)
    { c = ((*fp2)>>x) | ((*fp1)<<(8-x));
      port_out(c, GRA_D);
      *q = *q;
     }
    fp1 = FONT + FONT_HEIGHT * (text[i] & 127);
    fp2 = FONT + FONT_HEIGHT * (text[i+1] & 127);
    start++;
    stop++;
   }

  if (x > 0)
    for (q = start; q < stop; q+=LINE_BYTES, fp1++,fp2++)
    { c = (*fp1)<<(8-x);
      port_out(c, GRA_D);
      *q = *q;
     }

}

void put_text(Window w, int x, int y, const char *text, int opaque)
{ VgaWindow win = win_stack[w];
  Put_Text(win,x,y,text,opaque ? win->bg_col : -1); }


void put_ctext(Window w, int x, int y, const char* str, int opaque)
{ put_text(w,x-(text_width(str)-1)/2, y-(text_height(str)-1)/2, str, opaque);
 }


void show_coordinates(Window w, const char* s)
{ VgaWindow win = win_stack[w];
  int save_mode = set_mode(0);
  int save_col  = set_color(4);
  put_text(w,win->width-138,1,s,1); 
  set_mode(save_mode);
  set_color(save_col);
}


void clear_window(Window w, int c)
{ VgaWindow win = win_stack[w];
  int save_col  = set_color(win->bg_col);
  int save_mode = set_mode(0);
  box(w,0,0,win->width-1,win->height-1);
  set_color(save_col);
  set_mode(save_mode);
 }


void pixel(Window w, int x, int y) { put_pixel(win_stack[w],x,y);}

void pixels(Window w, int n, int* x, int* y)
{ while(n--) put_pixel(win_stack[w],x[n],y[n]); }



#define put_arc_pixel(X,Y,x,y,top) { X[top] = x; Y[top] = y; top++; }

void arc(Window w, int x0, int y0, int r1, int r2, double start, double angle)
{ VgaWindow win = win_stack[w];
  int* X = new int[10*r1];
  int* Y = new int[10*r2];
  int r;

 x0 += win->xpos;
 y0 += win->ypos;

 if (angle < 0)
 { start += angle;
   angle *= -1;
  }

 if (angle > 2*M_PI) angle = 2*M_PI;

 while (start < 0) start += 2*M_PI;

 for (r = r1-LINEWIDTH/2; r <= r1+LINEWIDTH/2; r++)
 { int y = r;
   int x = 0;
   int e = 3-2*y;
   int top = 0;
   int high;
   int high1;
   int s,l;
   float L;
   int i;

   while (x < y)
   { put_arc_pixel(X,Y,x,y,top);
     x++;
     if (e>=0) { y--; e -= 4*y; }
     e += 4*x + 2;
    }

   high = top-1;

   if (x==y) put_arc_pixel(X,Y,x,y,top);

   high1 = top;

   for(i = 0;    i < high1; i++) put_arc_pixel(X,Y, Y[i],-X[i],top);
   for(i = high; i > 0;     i--) put_arc_pixel(X,Y, X[i],-Y[i],top);
   for(i = 0;    i < high1; i++) put_arc_pixel(X,Y,-X[i],-Y[i],top);
   for(i = high; i > 0;     i--) put_arc_pixel(X,Y,-Y[i],-X[i],top);
   for(i = 0;    i < high1; i++) put_arc_pixel(X,Y,-Y[i], X[i],top);
   for(i = high; i > 0;     i--) put_arc_pixel(X,Y,-X[i], Y[i],top);
   for(i = 0;    i < high1; i++) put_arc_pixel(X,Y, X[i], Y[i],top);
   for(i = high; i > 0;     i--) put_arc_pixel(X,Y, Y[i], X[i],top);

   L = (top - high1)/(2*M_PI);
   s = high1 - 1 + (int)(start*L);
   l = s + (int)(angle*L);

   if (l >= top)
   { for(i=s; i < top; i++) put_pixel(win,x0+X[i],y0+Y[i]);
     s = high - 1;
     l = s + l - top;
    }
   for(i=s; i < l; i++) put_pixel(win,x0+X[i],y0+Y[i]);
  }

  delete X;
  delete Y;
}


static void ellipse_point(VgaWindow win, int x0, int y0, int x, int y)
{ put_pixel(win,x0+x,y0+y);
  put_pixel(win,x0-x,y0+y);
  put_pixel(win,x0+x,y0-y);
  put_pixel(win,x0-x,y0-y);
 }


void ellipse(Window w, int x0, int y0, int a, int b)
{ 
  /* Foley, van Dam, Feiner, Huges: Computer Graphics, page 90 */

  VgaWindow win = win_stack[w];

  double d1,d2;
  int x,y;
  int a_2 = a*a;
  int b_2 = b*b;

  put_pixel(win,x0,y0-b);
  put_pixel(win,x0,y0+b);
  put_pixel(win,x0-a,y0);
  put_pixel(win,x0+a,y0);

  x = 0;
  y = b;

  d1 = b*b + a*a*(0.25 - b); 
   
  while (a_2*(y - 0.5) > b_2*(x+1))
  { if (d1 < 0)
      d1 += b_2*(2*x + 3);
    else
    { d1 += b_2*(2*x + 3) + a_2*(2 - 2*y);
      y--;
     }
    x++;
    ellipse_point(win,x0,y0,x,y);
  }

  d2 = b_2*(x+0.5)*(x+0.5) + a_2*(y - 1)*(y - 1) - a_2*b_2;

  while (y > 1)
  { if (d2 < 0)
     { d2 += b_2*(2*x+2)+a_2*(3-2*y);
       x++;
      }
    else
       d2 += a*a*(3-2*y);

    y--;

    ellipse_point(win,x0,y0,x,y);
   }
}


void fill_ellipse(Window w, int x0, int y0, int a, int b)
{ VgaWindow win = win_stack[w];
  double d1,d2;
  int x,y;
  int a_2 = a*a;
  int b_2 = b*b;

  x = 0;
  y = b;

  d1 = b*b + a*a*(0.25 - b); 
   
  while (a_2*(y - 0.5) > b_2*(x+1))
  { if (d1 < 0)
      d1 += b_2*(2*x + 3);
    else
    { d1 += b_2*(2*x + 3) + a_2*(2 - 2*y);
      hline(win,x0-x,x0+x,y0+y);
      hline(win,x0-x,x0+x,y0-y);
      y--;
     }
    x++;
  }
  hline(win,x0-x,x0+x,y0+y);
  hline(win,x0-x,x0+x,y0-y);

  d2 = b_2*(x+0.5)*(x+0.5) + a_2*(y - 1)*(y - 1) - a_2*b_2;

  while (y > 1)
  { if (d2 < 0)
     { d2 += b_2*(2*x+2)+a_2*(3-2*y);
       x++;
      }
    else
       d2 += a*a*(3-2*y);

    y--;

    hline(win,x0-x,x0+x,y0+y);
    hline(win,x0-x,x0+x,y0-y);
   }

  hline(win,x0-x,x0+x,y0);

}


void fill_arc(Window,int,int,int,int,double,double)
{ }


static void copy_box(int left, int top, int width, int height, int x, int y)
{
  register VIDEO_PTR first1;
  register VIDEO_PTR first;
  register VIDEO_PTR last1;
  register VIDEO_PTR last;
  register VIDEO_PTR p;
  register VIDEO_PTR q;

  int i;

  if(x < 0) 
  { left += x;
    width -= x;
    x = 0;
   }

  if(y < 0) 
  { top += y;
    height -= y;
    y = 0;
   }

  if(x+width > DISP_MAX_X) width = DISP_MAX_X - x;

  if(y+height > DISP_MAX_Y) height = DISP_MAX_Y - y;

  /* set write mode 1 */
  port_out(5, GRA_I);
  port_out(1, GRA_D);

  if (y <= top)
  { first1 = VIDEO + LINE_BYTES*y + x/8;
    last1  = VIDEO + LINE_BYTES*y + (x+width-1)/8;
    first  = VIDEO + LINE_BYTES*top + left/8;
    last   = VIDEO + LINE_BYTES*top + (left+width-1)/8;
   }
  else
  { first1 = VIDEO + LINE_BYTES*(y+height-1) + x/8;
    last1  = VIDEO + LINE_BYTES*(y+height-1) + (x+width-1)/8;
    first  = VIDEO + LINE_BYTES*(top+height-1) + left/8;
    last   = VIDEO + LINE_BYTES*(top+height-1) + (left+width-1)/8;
   }

  for(i=0; i<height; i++)
  { 
    if (x <= left)
      for(q=first, p=first1; q<=last; q++,p++) *p = *q;
    else
      for(q=last, p=last1; q>=first; q--,p--) *p = *q;

    if (y <= top)
    { first1 += LINE_BYTES;
      first  += LINE_BYTES;
      last1  += LINE_BYTES;
      last   += LINE_BYTES;
     }
    else
    { first1 -= LINE_BYTES;
      first  -= LINE_BYTES;
      last1  -= LINE_BYTES;
      last   -= LINE_BYTES;
     }
   }

  /* set write mode 0 */
  port_out(5, GRA_I);
  port_out(0, GRA_D);

 }

void copy_rect(Window w, int x1, int y1, int x2, int y2, int x, int y)
{ VgaWindow win = win_stack[w];
  int width = x2-x1+1;
  int height = y2-y1+1;
  x1 += win->xpos; 
  y1 += win->ypos; 
  x  += win->xpos; 
  y  += win->ypos; 
  copy_box(x1,y1,width,height,x,y); 
 }


static char rev_byte(char c)
{ char c1 = 0x00;
   for(int i=0; i<8; i++)
   { c1 <<= 1;
     if (c&1) c1 |= 1;
     c >>= 1;
    }
  return c1;
}


void insert_bitmap(Window w, int width, int height, char* data)
{
  register VIDEO_PTR first;
  register VIDEO_PTR last;
  register VIDEO_PTR q;

  VgaWindow win = win_stack[w];

  int x = win->x0/8 + 1;
  int y = win->ypos;

  int wi = (width > win->width) ? win->width : width;
  int he = (height > win->height) ? win->height : height;

  first  = VIDEO + LINE_BYTES*y + x;
  last   = VIDEO + LINE_BYTES*y + x + wi/8 - 1;

  if (width % 8)
     width  = 1+ width/8;
  else
     width  = width/8;

  port_out(8, GRA_I);

  for(int i=0; i<he; i++)
  { char* p = data + i*width;
    for(q=first; q<=last; q++) 
    { port_out(rev_byte(*p++), GRA_D);
      *q = *q;
     }
    first += LINE_BYTES;
    last  += LINE_BYTES;
   }
 }

