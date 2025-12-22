/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     text
   PURPOSE
     text drawing functions
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 21, 1995: Created.
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"

/*#define XLIB_ILLEGAL_ACCESS 1*/

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

/*
#include <libraries/mui.h>
#include <proto/muimaster.h>
*/
#include <X11/Xlibint.h>

#include "amigax_proto.h"
#include "amiga_x.h"

extern GC      amiga_gc;

extern struct Screen *Scr,*wb;
extern Window prevwin;
extern GC prevgc;
extern struct RastPort *drp;
extern int X_relx,X_rely,X_right,X_bottom;
extern int X11muiapp;

XDrawString(d,win,gc,x,y,string,length)
Display *d;
GC gc;
Drawable win;
int x,y,length;
char *string;
{ 
  char Xtempstr[256];
  struct IntuiText itext;

  strncpy(Xtempstr,string,length);
  Xtempstr[length]=0;

#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawString [%s] length %d (%d %d) -> (%d %d)\n",Xtempstr,length,x,y,X_relx+x,X_rely+y-drp->Font->tf_Baseline-1); 
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if(gc->values.font /*&&!X11muiapp*/){
    ULONG new;
    struct TextFont *tf=(struct TextFont*)((sFont*)gc->values.font)->tfont;
    struct TextAttr *tattr=(struct TextAttr*)((sFont*)gc->values.font)->tattr;
    SetFont(drp,tf);
    new=SetSoftStyle(drp,tattr->ta_Style ^ tf->tf_Style,(FSF_BOLD|FSF_UNDERLINED|FSF_ITALIC));
/*    if(tf->tf_Flags==42||tf==(struct TextFont*)amiga_gc->values.font)StripFont(tf);*/
  }
  if(length<1||!string) {/*printf("zero length string in xdrawstring\n");*/ return;}
/*  if(length>80){ printf("large string! %d\n",length); length=80;}*/
  itext.IText=(char *)Xtempstr;
  itext.LeftEdge=0; itext.TopEdge=0; 
  if(gc->values.function==GXinvert||gc->values.function==GXxor) 
    itext.DrawMode=COMPLEMENT;
  else if(gc->values.background==0) itext.DrawMode=JAM1;
  else itext.DrawMode=JAM2;
  itext.ITextFont=NULL;
  itext.NextText=NULL;
  itext.FrontPen=gc->values.foreground; itext.BackPen=gc->values.background;
  PrintIText(drp,&itext,X_relx+x,X_rely+y-drp->Font->tf_Baseline);
}

XDrawImageString(display, win, gc, x, y, string, length)
     Display *display;
     Window win;
     struct _XGC *gc;
     int x, y;
     char *string;
     int length;
{
  char Xtempstr[256];
  struct IntuiText itext;
  int origx,origy;
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XDrawImageString %d,%d %s (%d)in window %d\n",x,y,string,length,(int)win);
#endif 
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if(gc->values.font /*&&!X11muiapp*/){
    struct TextFont *tf=(struct TextFont*)((sFont*)gc->values.font)->tfont;
    struct TextAttr *tattr=(struct TextAttr*)((sFont*)gc->values.font)->tattr;
    SetFont(drp,tf);
/*    if(tf->tf_Flags==42||tf==(struct TextFont*)amiga_gc->values.font)StripFont(tf);*/
  }
  origx=X_relx+x;
  origy=X_rely+y-drp->Font->tf_Baseline;

  if(length<1||!string) {/*printf("zero length string in xdrawimagestring\n");*/ return;}
/*
  if(length*drp->Font->tf_XSize+origx>X_right){
    length=(int)((X_right-origx)/drp->Font->tf_XSize);
    if(length<0)length=0;
    printf("large string! %d\n",length);
  }*/
  strncpy(Xtempstr,string,length);
  Xtempstr[length]=0;
  itext.IText=Xtempstr; itext.LeftEdge=0; itext.TopEdge=0;
  if(gc->values.function==GXinvert||gc->values.function==GXxor) 
    itext.DrawMode=COMPLEMENT;
  else itext.DrawMode=JAM2;
  itext.ITextFont=NULL; itext.NextText=NULL;
  itext.FrontPen=gc->values.foreground; itext.BackPen=gc->values.background;
  PrintIText(drp,&itext,origx,origy);
}

XDrawText16(display, drawable, gc, x, y, items, nitems)
     Display *display;
     Drawable drawable;
     GC gc;
     int x, y;
     XTextItem16 *items;
     int nitems;
{/*             File 'do_text.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDrawText16\n");
#endif
  return(0);
}

XDrawString16(display, drawable, gc, x, y, string, length)
     Display *display;
     Drawable drawable;
     GC gc;
     int x, y;
     char *string;
     int length;
{/*           File 'do_text.o'*/
#if (DEBUGXEMUL_ENTRY)
  printf("XDrawString16\n");
#endif
  XDrawString(display,drawable,gc,x,y,string,length);
  return(0);
}

XDrawImageString16(display, win, gc, x, y, string, length)
     Display *display;
     Drawable win;
     GC gc;
     int x, y;
     char *string;
     int length;
{/*      File 'do_text.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XDrawImageString16\n");
#endif
  XDrawImageString(display,win,gc,x,y,string,length);
  return(0);
}

XDrawText(display, drawable, gc, x, y, items, nitems)
     Display *display;
     Drawable drawable;
     GC gc;
     int x, y;
     XTextItem *items;
     int nitems;
{/*               File 'do_text.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDrawText\n");
#endif
  return(0);
}
