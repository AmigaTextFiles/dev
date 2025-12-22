/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _leda_panel.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



// defines the LEDA_PANEL operations declared in <LEDA/leda_panel.h>
// using the basic graphics routines from <LEDA/impl/x_basic.h>

#include <LEDA/leda_panel.h>
#include <LEDA/impl/x_basic.h>

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

enum { Text_Item, 
       String_Item, 
       String_Menu_Item, 
       Int_Item, 
       Slider_Item, 
       Float_Item, 
       Button_Item, 
       Choice_Item,
       Bool_Item};

static char* duplicate_string(const char* p)
{ char* q = new char[strlen(p)+1];
  if (q==0) 
  { fprintf(stderr,"duplicate_string: out of memory");
    abort();
   }
  strcpy(q,p);
  return q;
}


void LEDA_PANEL::panel_redraw_func() 
{ LEDA_PANEL* p = (LEDA_PANEL*)active_window; 
  p->open(p->XPOS, p->YPOS, 0, 0, 0, 0, 0); }



LEDA_PANEL::LEDA_PANEL(const char* s, int bl)
{ header = duplicate_string(s);
  but_layout = bl;
  item_count = 0;
  but_count = 0;
  XPOS = -1;
  YPOS = -1;
  win = 0;
  redraw = panel_redraw_func;
 }

void LEDA_PANEL::text_item(const char* s)
{ kind[item_count] = Text_Item;
  label_str[item_count] = duplicate_string(s);
  item_count++;
}

void LEDA_PANEL::string_item(const char* s, char** x)
{ label_str[item_count] = duplicate_string(s);
  ref[item_count] = x;
  kind[item_count] = String_Item;
  item_count++;
 }

void  LEDA_PANEL::string_menu_item(const char* s, char** x, const char* /*menu_label*/,
                                   int argc, const char** argv)
{ label_str[item_count] = duplicate_string(s);
  ref[item_count] = x;
  kind[item_count] = String_Menu_Item;
  dat1[item_count] = argc;
  choices[item_count] = new char*[argc];
  for(int i = 0; i < argc; i++) 
     choices[item_count][i] = duplicate_string(argv[i]);
  item_count++;
 }


void LEDA_PANEL::int_item(const char* s, int* x)
{ label_str[item_count] = duplicate_string(s);
  ref[item_count] = x;
  kind[item_count] = Int_Item;
  item_count++;
 }

void  LEDA_PANEL::slider_item(const char* s, int* x, int min, int max)
{ label_str[item_count] = duplicate_string(s);
  ref[item_count] = x;
  dat1[item_count] = min;
  dat2[item_count] = max;
  kind[item_count] = Slider_Item;
  item_count++;
 }

void LEDA_PANEL::float_item(const char* s, double* x)
{ label_str[item_count] = duplicate_string(s);
  ref[item_count] = x;
  kind[item_count] = Float_Item;
  item_count++;
 }

void LEDA_PANEL::choice_item(const char* s, int* address, int argc,
                             const char** argv, int step, int off)
{ label_str[item_count] = duplicate_string(s);
  kind[item_count] = Choice_Item;
  ref[item_count] = address;
  dat1[item_count] = argc;
  dat2[item_count] = step;
  offset[item_count] = off;
  choices[item_count] = new char*[argc];
  for(int i=0; i<argc; i++) choices[item_count][i] = duplicate_string(argv[i]);
  item_count++;
 }


void LEDA_PANEL::bool_item(const char* s, char* address)
{ label_str[item_count] = duplicate_string(s);
  kind[item_count] = Bool_Item;
  ref[item_count] = address;
  dat1[item_count] = 2;
  dat2[item_count] = 1;
  offset[item_count] = 0;
  choices[item_count] = new char*[2];
  choices[item_count][0] = duplicate_string("off");
  choices[item_count][1] = duplicate_string("on");
  item_count++;
 }



int LEDA_PANEL::button(const char* s)
{ if (but_count == MAX_BUT_NUM) return -1;
  // space before first line of buttons
  if (but_count==0 && item_count>0)  text_item(""); 
  button_str[but_count] = duplicate_string(s);
  return but_count++;
 }


void  LEDA_PANEL::button_line(int n, const char** b) 
{ for(int i=0; i<n; i++) button(b[i]); }



void LEDA_PANEL::activate_string_item(int xoff,int yoff,int yskip,int ytskip, 
                                      int t_length, int n)
{  int y,l,i;

   int old = act_str_item;

   act_str_item = n;

   if (old > -1)
   { y = yoff;
     for(i=0;i<old; i++)
        y += (kind[i] == Text_Item) ? ytskip : yskip; 
     l = dat2[old];
     ::set_mode(1);
     line(win,xoff,y+yskip-3,xoff+t_length,y+yskip-3);
     ::set_mode(0);
     put_text(win,xoff+l*text_width("H"),y+(yskip-text_height("H"))/2," ",1);
   }

   y = yoff;
   for(i=0;i<n; i++)
      y += (kind[i] == Text_Item) ? ytskip : yskip; 
   l = dat2[n];
   line(win,xoff,y+yskip-3,xoff+t_length,y+yskip-3);
   put_text(win,xoff+l*text_width("H"),y+(yskip-text_height("H"))/2,"|",1);

 }
   


int LEDA_PANEL::panel_text_edit(int xt, int yt, int t_len, char *str)
{ int  i = strlen(str);
  int  x;
  int  cw;
  int  xcoord,ycoord,val;
  int  max_c;
  unsigned long t;
   
  cw = text_width("H");
  x  = xt+i*cw;

  max_c = t_len/cw;

  put_text(win,xt,yt,str,1);

  for(;;)
  { int  k;
    char c = 13;

    ::set_read_gc();

    while(1)
    { Window w;
      k = get_next_event(&w,&val,&xcoord,&ycoord,&t);
      if (w != win) continue;
      if (k == key_press_event || k == button_press_event) break;
     }

     reset_gc();

     if (k == key_press_event) c = val;
     if (c == 13) 
     { put_back_event();
       break;
      }

     if (i < max_c && isprint(c))
     { str[i]=c;
       str[i+1]=0;
       put_text(win,xt,yt,str,1);
       i++;
       x += cw;
      }
     if(c==8 && i>0)
     { put_text(win,x,yt," ",1);
       i--;
       x -= cw;
      }
     put_text(win,x,yt,"|",1);
   }

  str[i]='\0';

  ::set_text_font();

  return i;
}


void LEDA_PANEL::put_text_item(int x, int y, const char* s, int t_len)
{ char text[128];
  int i;
  int c_len = t_len/text_width("H");
  strcpy(text,s);
  for(i=strlen(s); i<c_len; i++) text[i] = ' ';
  text[c_len] = '\0';
  put_text(win,x,y,text,1);
}



void LEDA_PANEL::draw_choice_item(int i,int x0, int y0, int width,int yskip)
{ int c = (*(int*)ref[i]-offset[i])/dat2[i];
  int x = x0+c*width;
  int j;

  for(j=0, x=x0; j < dat1[i]; j++, x+=width)
  { ::set_color(0);
    box(win,x+1,y0+4,x+width-1,y0+yskip-3);
    ::set_color(1);
    rectangle(win,x,y0+3,x+width,y0+yskip-2);
    if(j == c) rectangle(win,x+1,y0+4,x+width-1,y0+yskip-3);
    put_ctext(win,x+width/2,y0+yskip/2,choices[i][j],0);
   }
}


void LEDA_PANEL::draw_bool_item(int i,int x0, int y0, int width,int yskip)
{ char c = *(char*)ref[i];
  int x = x0+c*width;
  int j;

  for(j=0, x=x0; j < 2; j++, x+=width)
  { ::set_color(0);
    box(win,x+1,y0+4,x+width-1,y0+yskip-3);
    ::set_color(1);
    rectangle(win,x,y0+3,x+width,y0+yskip-2);
    if(j == c) rectangle(win,x+1,y0+4,x+width-1,y0+yskip-3);
    put_ctext(win,x+width/2,y0+yskip/2,choices[i][j],0);
   }

}


void LEDA_PANEL::draw_slider_item(int i, int x01, int x0, int y0,
                                  int length, int yskip, float x)
{ float mi = dat1[i];
  float ma = dat2[i];
  int x1 = x0 + length;
  int y1 = y0 + (3*yskip)/4;
  char text[16];

  y0 += (1+yskip/4);

  if (x < x0) x = x0;
  if (x > x1) x = x1;

  int val = int(mi + (ma-mi)*(x-x0)/length + 0.5);
  *(int*)ref[i] = val;

  sprintf(text,"%3d",val);
  put_text(win,x01,y0,text,1);

  ::set_color(0);
  box(win,int(x+0.5)+1,y0+1,x1-1,y1-1);
  ::set_color(1);
  box(win,x0,y0+1,int(x+0.5),y1-1);
  rectangle(win,x0,y0,x1,y1);

}

void LEDA_PANEL::draw_button(const char* s, int x, int y, int bw, 
                              int yskip, int pressed)
{ 
  if (pressed)
  { ::set_mode(1);
    box(win,x+2,y+5,x+bw-2,y+yskip-4);
    flush_display();
    ::set_mode(0);
   }
  else
  { ::set_color(0);
    box(win,x+1,y+4,x+bw-1,y+yskip-3);
    ::set_color(1);
    if (s) 
       put_ctext(win,x+bw/2,y+yskip/2,s,0);
    else // menu button  "-->"
      { line(win,x+9, y+8,  x+9,  y+20);
        line(win,x+9, y+8,  x+21, y+14);
        line(win,x+9, y+20, x+21, y+14);
        line(win,x+10, y+9,  x+20, y+14);
        line(win,x+10, y+19, x+20, y+14);
       }
    rectangle(win,x+1,y+4,x+bw-1,y+yskip-3);

    // shadow
    box(win,x+4,y+yskip-2,x+bw,y+yskip);
    box(win,x+bw,y+7,x+bw+2,y+yskip);

   }

  
 }


static int read_panel_at(const char* header, int n, char** but,int x, int y)
{ LEDA_PANEL p(header);
  for(int i=0; i<n; i++) p.button(but[i]);
  return p.open(x,y,0,0,0,0,3);
 }


int  LEDA_PANEL::open(int xpos, int ypos, int win_x, int win_y, 
                      int win_width, int win_height, int mode)
{


  // mode = 0:  just display panel window  on screen
  // mode = 1:  display, read (blocking), and close 
  // mode = 2:  read
  // mode = 3:  display, read (non-blocking) , and close


  char  text[128];
  char  str[128];


repaint:

  int   width = (win) ? ::window_width(win) : 100;
  int   height; 


  int   xoff  = 20;       /* left and right boundary space */
  int   yoff  = 10;       /* top and bottom boundary space */
  int   xoff1 =  0;       /* start of slider items    */
  int   xoff2 =  0;       /* start of all other items */

  int   bxoff;            /* left and right button boundary space */

  int   sl_length = 200;  /* slider item length */
  int   t_length  = 200;  /* string/int/float item length */

  int   ytskip = 18;      /* height of text items   */
  int   yskip  = 28;      /* height of other items  */

  int   bw     = 50;      /* button width (minimal) */
  int   bskip  = 15;      /* button space */
  int   bw1;              /* bw + bskip   */

  int   cw     = 30;      /* choice field width (minimal) */


  int   but_per_line;
  int   but_lines;


  int   but,w,i,j,x,y,yt;

  int   save_lw, save_ls, save_mo;

  int   user_buttons = but_count;

  unsigned long t;

  open_display();

  save_lw = ::set_line_width(1);
  save_ls = ::set_line_style(0);
  save_mo = ::set_mode(0);

  if (but_count==0)
  { button("CONTINUE");
    button("QUIT");
   }


  height = 2*yoff;

  for(i=0;i<item_count; i++)
    if (kind[i] != Text_Item)
       { height += yskip;
         if ((w = text_width(label_str[i])) > xoff1) xoff1 = w;
 
         if (kind[i] == Choice_Item)
         { int j;
           for(j=0; j<dat1[i];j++)
           if ((w = text_width(choices[i][j])) > cw) cw = w;
          }
       }
    else
       height += ytskip;

  cw    += 10;

  xoff1 += 25;

  xoff2 = xoff1 + 35;


  if ((w = text_width(header)) > width) width = w;

  for(i=0;i<item_count; i++)
  { switch (kind[i])
    {
      case  Text_Item:
                  if ((w = 2*xoff + text_width(label_str[i])) > width) width=w;
                  if ((w = text_width(label_str[i])-xoff2) > sl_length)
                     sl_length = w;
                  if (w > t_length) t_length = w;
                  break;


      case Choice_Item:
                 if ((w = xoff2 + cw*dat1[i] + xoff) > width) width = w;
                 break;

      case Slider_Item:
                 if ((w = xoff2+sl_length+xoff) > width) width = w;
                 break;

      case String_Menu_Item:
                 if ((w = xoff2+t_length+2*yskip+xoff) > width) width = w;
                 break;

      default:   if ((w = xoff2+t_length+xoff) > width) width = w;
                 break;
     }
   }


  for(i=0; i < but_count; i++)
     if ((w = text_width(button_str[i])) > bw) bw = w;

  bw  = bw += 10;
  bw1 = bw + bskip;

  if (width < bw1+bskip) width = bw1+bskip;

  if (but_layout == 0)
     but_per_line = (width-bskip)/bw1;
  else
     but_per_line = 1;

  but_lines = but_count/but_per_line;

  if (but_count % but_per_line) but_lines++;

  if (but_lines == 1)
     bxoff = (width - but_count * bw1 + bskip)/2;
  else
     bxoff = (width - but_per_line * bw1 + bskip)/2;

  height += but_lines * yskip;

  for (i=0; i< but_lines; i++)
     kind[item_count+i] = Button_Item;


  if(XPOS == -1)
    if (xpos == -1)
      if (win_width == 0)
         { /* center panel window on the screen */
           XPOS = (display_width() - width)/2;
           YPOS = (display_height() - height)/2;
          }
      else
         { /* center panel window on draw window */
           XPOS = win_x + (win_width - width)/2;
           YPOS = win_y + (win_height- height)/2;
          }
    else /* use supplied coordinates */
      { XPOS = xpos;
        YPOS = ypos;
       }

  //if (win==0) win = open_window(XPOS,YPOS,width,height,header,"LEDA PANEL");

  if (win==0) 
  { LEDA_WINDOW::open(width,height,XPOS,YPOS,header);
    set_show_coordinates(0);
    redraw = panel_redraw_func;
    win = draw_win;
   }


//repaint:

  //clear_window(win,orange);

  act_str_item = -1;

  ::set_color(1);

  y = yoff;

  for(i=0;i<item_count; i++)
  {
    yt = y + (yskip - text_height("H"))/2;

    if (kind[i] != Text_Item) put_text(win,xoff,yt,label_str[i],0);

    switch (kind[i]) {

    case Text_Item:
        { put_text(win,xoff,y,label_str[i],0);
          break;
         }


    case Choice_Item:
        { draw_choice_item(i,xoff2,y,cw,yskip);
          break;
         }

    case Bool_Item:
        { draw_bool_item(i,xoff2,y,cw,yskip);
          break;
         }

    case Slider_Item:
        { float d = float(sl_length)/(dat2[i]-dat1[i]);
          float x = xoff2 + d * (*(int*)ref[i]-dat1[i]);
          draw_slider_item(i,xoff1,xoff2,y,sl_length,yskip,x);
          break;
         }

    case Int_Item:
        { sprintf(text,"%d",*(int*)ref[i]);
          put_text(win,xoff2,yt,text,1);
          dat2[i] = strlen(text);
          line(win,xoff2,y+yskip-4,xoff2+t_length,y+yskip-4);
          if (act_str_item == -1) 
              activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
          break;
         }
 
    case Float_Item:
        { sprintf(text,"%f",*(double*)ref[i]);
          put_text(win,xoff2,yt,text,1);
          dat2[i] = strlen(text);
          line(win,xoff2,y+yskip-4,xoff2+t_length,y+yskip-4);
          if (act_str_item == -1) 
              activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
          break;
         }
  
    case String_Item:
        { put_text(win,xoff2,yt,*(char**)ref[i],1);
          dat2[i] = strlen(*(char**)ref[i]);
          line(win,xoff2,y+yskip-4,xoff2+t_length,y+yskip-4);
          if (act_str_item == -1) 
              activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
          break;
         }

    case String_Menu_Item:
        { put_text(win,xoff2,yt,*(char**)ref[i],1);
          dat2[i] = strlen(*(char**)ref[i]);
          line(win,xoff2,y+yskip-4,xoff2+t_length,y+yskip-4);
          draw_button(0,xoff2+t_length+10,y-1,yskip,yskip-1,0);
          if (act_str_item == -1) 
              activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
          break;
         }
    
    
    }

    if (kind[i] == Text_Item)
        y += ytskip;
    else
        y += yskip;

  }

  y -= yskip;

  for(i=0; i < but_count; i++)
    { if (i % but_per_line == 0)
      { y += yskip;
        x = bxoff;
       }
      draw_button(button_str[i],x,y,bw,yskip,0);
      x += bw1;
     }


  if (mode == 0) return -1;




  but = -1;

  while(but == -1)
  { int b;
    i = -1;


    while (i < 0 || i >= item_count+but_lines)
    { int k;
      ::set_read_gc();
      while (1)
      { Window w;
        k = get_next_event(&w,&b,&x,&y,&t);
        if (w == win)
        { if (k == button_press_event || k == key_press_event) break;
          if (k == configure_event) 
          { reset_gc();
            goto repaint;
           }
         }
        else
          if (mode == 3 && k==button_press_event) 
          { put_back_event();
            reset_gc();
            goto end;
           }
       }
      reset_gc();

      if (k==button_press_event)
        { for(i=0,j=yoff;i<item_count+but_lines && y>j; i++)
            if (kind[i] == Text_Item)
               j += ytskip;
            else
               j += yskip;
  
           if (y <= j) i--;
         }
       else  /* key pressed */
       { if (b == 13 && act_str_item > -1) /* return */
         { j = act_str_item;
           for(;;)
           { j = (j + 1) % item_count;
             k =  kind[j]; 
             if (k==String_Item || k==String_Menu_Item || 
                 k==Int_Item || k == Float_Item) break;
             }
           activate_string_item(xoff2,yoff,yskip,ytskip,t_length,j);
         }
         else
         { x = xoff2;
           i = act_str_item;
           for(k=0,j=yoff; k <= i; k++)
            if (kind[k] == Text_Item)
               j += ytskip;
            else
               j += yskip;
           put_back_event();
          }
       }
     }

    y  = j-yskip;
    yt = y + (yskip - text_height("H"))/2;

    switch (kind[i]) {

    case Text_Item: break;

    case Slider_Item:
    { Window w = win;
      int xx = 0;
      if (x < xoff2 || x > xoff2+sl_length) break;
      ::set_read_gc();
      while(w == win)
      { if (xx != x)
        { xx = x;
          reset_gc();
          draw_slider_item(i,xoff1,xoff2,y,sl_length,yskip,xx);
          ::set_read_gc();
         }
        if (get_next_event(&w,&b,&x,&j,&t) == button_release_event) break;
       }
      reset_gc();
      break;
     }

    case Int_Item:
    { int* ptr = (int*)ref[i];
      sprintf(str,"%d",*ptr);
      activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
      panel_text_edit(xoff2,yt,t_length,str);
      *ptr = atoi(str);
      sprintf(str,"%d",*ptr);
      dat2[i] = strlen(str);
      sprintf(text,"%s|                    ",str);
      put_text_item(xoff2,yt,text,t_length);
      break;
     }

    case Float_Item:
    { double* ptr = (double*)ref[i];
      sprintf(str,"%f",*ptr);
      activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
      panel_text_edit(xoff2,yt,t_length,str);
      *ptr = (double)atof(str);
      sprintf(str,"%f",*ptr);
      dat2[i] = strlen(str);
      sprintf(text,"%s|                    ",str);
      put_text_item(xoff2,yt,text,t_length);
      break;
     }

    case String_Item:
    { strcpy(str,*(char**)ref[i]);
      activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
      panel_text_edit(xoff2,yt,t_length,str);
      delete *(char**)ref[i];
      *(char**)ref[i] = duplicate_string(str);
      dat2[i] = strlen(str);
      put_text_item(xoff2,yt,str,t_length);
      break;
     }

    case String_Menu_Item:
    { activate_string_item(xoff2,yoff,yskip,ytskip,t_length,i);
      strcpy(str,*(char**)ref[i]);
      if (x < xoff2+t_length+10)
         { strcpy(str,*(char**)ref[i]);
           panel_text_edit(xoff2,yt,t_length,str);
          }
      else
         { Window w;
           draw_button(0,xoff2+t_length+10,y-1,yskip,yskip-1,1);
           while (get_next_event(&w,&b,&x,&j,&t) != button_release_event);
           draw_button(0,xoff2+t_length+10,y-1,yskip,yskip-1,1);
           int sel = read_panel_at(label_str[i],dat1[i],choices[i],
                                   XPOS+xoff2+t_length+16, YPOS+y+24);
           if (sel > -1) strcpy(str,(choices[i])[sel]);
          }

      delete *(char**)ref[i];
      *(char**)ref[i] = duplicate_string(str);
      dat2[i] = strlen(str);
      sprintf(text,"%s|                   ",str);
      put_text_item(xoff2,yt,text,t_length);
      break;
     }


   case Choice_Item:
   { j = (x-xoff2)/cw;
     if (j >= 0 && j<dat1[i])
     { *(int*)ref[i] = offset[i] + j * dat2[i];
       draw_choice_item(i,xoff2,y,cw,yskip);
      }
     break;
    }

   case Bool_Item:
   { j = (x-xoff2)/cw;
     if (j >= 0 && j<dat1[i])
     { *(char*)ref[i] = offset[i] + j * dat2[i];
       draw_bool_item(i,xoff2,y,cw,yskip);
      }
     break;
    }

   case Button_Item:
   { j = (x-bxoff)/bw1;
     i = (i-item_count)*but_per_line +j;
     if (x > bxoff && j < but_per_line && i < but_count)
     { Window w;
       draw_button(button_str[i],bxoff+j*bw1,y,bw,yskip,1);
       while (get_next_event(&w,&b,&b,&b,&t) != button_release_event);
       but = i;
       //if (mode == 2) draw_button(button_str[i],bxoff+j*bw1,y,bw,yskip,1);
      }
     break;
    }

   }

  }


 if (mode == 2) // redisplay
     open(XPOS,YPOS,0,0,0,0,0);

/*
  window_position(win,&(XPOS),&(YPOS));
*/

end:


  ::set_line_width(save_lw);
  ::set_line_style(save_ls);
  ::set_mode(save_mo);

  if (user_buttons == 0)
  { but_count = 0;
    item_count--;
    if (but == 1)   /* quit button pressed */
    { close_display();
      exit(0);
     }
   }

  if (mode != 2) close();

  return but;
}


void LEDA_PANEL::display(int xpos, int ypos, int win_x, int win_y, int win_width, int win_height)
{ open(xpos, ypos, win_x, win_y, win_width, win_height, 0); }

/*
int  LEDA_PANEL::read(int xpos, int ypos, int win_x, int win_y, int win_width, int win_height)
{ return open(xpos, ypos, win_x, win_y, win_width, win_height, 2); }
*/

int  LEDA_PANEL::read() { return open(XPOS,YPOS,0,0,0,0,2); }



void  LEDA_PANEL::close() 
{ close_window(win);
  win = 0;
  draw_win = 0;
 }



LEDA_PANEL::~LEDA_PANEL() 
{ delete header; 
  for(int i = 0; i<item_count; i++)
  { delete label_str[i];
    if (   kind[i] == String_Menu_Item 
        || kind[i] == Choice_Item 
        || kind[i] == Bool_Item    )
    { for(int j = 0; j < dat1[i]; j++) delete choices[i][j];
      delete choices[i];
     }
   }
  for(int j = 0; j<but_count; j++) delete button_str[j];
}


