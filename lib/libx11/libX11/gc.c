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
     gc
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jul 14, 1996: Created.
***/

#include <time.h>
#include <intuition/intuition.h>
#include <proto/intuition.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>

/* externals */

extern GC      amiga_gc;
extern struct Screen *wb;

/* funcs */

XCopyGC(display, src, valuemask, dest)
     Display *display;
     GC src;
     unsigned long valuemask;
     GC dest;
{/*                 File 'sprayOp.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XCopyGC\n");
#endif
  if(valuemask&GCForeground) dest->values.foreground=src->values.foreground;
  if(valuemask&GCBackground) dest->values.background=src->values.background;
  if(valuemask&GCFunction) dest->values.function=src->values.function;
  if(valuemask&GCFillStyle) dest->values.fill_style=src->values.fill_style;
  if(valuemask&GCStipple) dest->values.line_style=src->values.line_style;
  if(valuemask&GCFont) dest->values.font=src->values.font;
  return(0);
}

GC XCreateGC(display, drawable, valuemask, values)
     Display *display;
     Drawable drawable;
     unsigned long valuemask;
     XGCValues *values;
{
  GC agcs;
  agcs=calloc(sizeof(struct _XGC),1);
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XCreateGC %d\n",agcs);
#endif
  agcs->values.foreground=0;
  agcs->values.background=0;
  agcs->values.line_width=1;
  agcs->values.function=GXcopy;
  agcs->values.font=(unsigned long)wb->RastPort.Font;
  agcs->values.subwindow_mode=X11NewGC(agcs);
  if(valuemask&GCForeground) agcs->values.foreground=values->foreground;
  if(valuemask&GCBackground) agcs->values.background=values->background;
  if(valuemask&GCLineWidth) agcs->values.line_width=values->line_width;
  if(valuemask&GCLineStyle) XSetLineAttributes(display,agcs,1,values->line_style,0,0);
  if(valuemask&GCCapStyle) agcs->values.cap_style=values->cap_style;
  if(valuemask&GCJoinStyle) agcs->values.join_style=values->join_style;
  if(valuemask&GCFunction)   agcs->values.function=values->function;
  if(valuemask&GCFont) agcs->values.font=values->font;
  if(valuemask&GCFillStyle) agcs->values.fill_style=values->fill_style;
  if(valuemask&GCStipple) agcs->values.line_style=values->line_style;
  return(agcs);
}

XFreeGC(display, gc)
     Display *display;
     GC gc;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(events)XFreeGC %d\n",gc);
#endif
  X11GC[gc->values.subwindow_mode]=NULL;
  free(gc);
  return(0);
}

XSetForeground(d,gc,pen)
     Display *d;
     struct _XGC *gc;
     unsigned long pen;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetForeground\n");
#endif
  gc->values.foreground=pen;
  prevgc=(GC)-1;
}

XSetBackground(d,gc,pen)
     Display *d;
     struct _XGC *gc;
     unsigned long pen;
{ 
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetBackground\n");
#endif
  gc->values.background=pen;
  prevgc=(GC)-1;
}

XSetState(display, gc, foreground, background, function,
	  plane_mask)
     Display *display;
     GC gc;
     unsigned long foreground, background;
     int function;
     unsigned long plane_mask;
{/*               File 'xvdial.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetState\n");
#endif
  XSetForeground(display,gc,foreground);
  XSetBackground(display,gc,foreground);
  XSetFunction(display,gc,function);
  XSetPlaneMask(display,gc,plane_mask);
  return(0);
}

GContext XGContextFromGC(gc)
     GC gc;
{
  return gc->gid;
}

Status XGetGCValues(display, gc, valuemask, values)
     Display *display;
     GC gc;
     unsigned long valuemask;
     XGCValues *values;
{
#if (DEBUGXEMUL_ENTRY)
  printf("XGetGCValues\n");
#endif
  if(valuemask&GCFillStyle) values->fill_style=gc->values.fill_style;
  if(valuemask&GCLineStyle) values->line_style=gc->values.line_style;
  if(valuemask&GCLineWidth) values->line_width=gc->values.line_width;
  if(valuemask&GCCapStyle) values->cap_style=gc->values.cap_style;
  if(valuemask&GCJoinStyle) values->join_style=gc->values.join_style;
  if(valuemask&GCFunction) values->function=gc->values.function;
  if(valuemask&GCFont) values->font=gc->values.font;
  if(valuemask&GCForeground) values->foreground=gc->values.foreground;
  if(valuemask&GCBackground) values->background=gc->values.background;
  
  return(0);
}

XSetTSOrigin(display, gc, ts_x_origin, ts_y_origin)
     Display *display;
     GC gc;
     int ts_x_origin, ts_y_origin;
{
#if (DEBUGXEMUL_ENTRY)
  printf("WARNING: XSetTSOrigin\n");
#endif
  gc->values.ts_x_origin=ts_x_origin;
  gc->values.ts_y_origin=ts_y_origin;
  return(0);
}

XChangeGC(display, gc, valuemask, values)
     Display *display;
     GC gc;
     unsigned long valuemask;
     XGCValues *values;
{/*               File 'bitmaps.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XChangeGC\n");
#endif
  if(valuemask&GCStipple) XSetStipple(display,gc,values->stipple);
  else {
    gc->values.stipple=0;
    if(valuemask&GCTile) XSetTile(display,gc,values->tile);
    else gc->values.tile=0;
  }
  if(valuemask&GCFillStyle) XSetFillStyle(display,gc,values->fill_style);
  if(valuemask&GCLineStyle) XSetLineAttributes(display,gc,1,values->line_style,0,0);
  if(valuemask&GCLineWidth) gc->values.line_width=values->line_width;
  if(valuemask&GCCapStyle) gc->values.cap_style=values->cap_style;
  if(valuemask&GCJoinStyle) gc->values.join_style=values->join_style;
  if(valuemask&GCFunction) gc->values.function=values->function;
  if(valuemask&GCFont) XSetFont(display,gc,values->font);
  if(valuemask&GCForeground) XSetForeground(display,gc,values->foreground);
  if(valuemask&GCBackground) XSetBackground(display,gc,values->background);
  prevgc=(GC)-1;
  return(0);
}

XSetArcMode(display, gc, arc_mode)
     Display *display;
     GC gc;
     int arc_mode;
{/*             File 'do_arcs.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetArcMode\n");
#endif
  gc->values.arc_mode=arc_mode;
  prevgc=(GC)-1;
  return(0);
}
