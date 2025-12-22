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
     filling
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jan 28, 1995: Created.
***/

#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>

#include <dos.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include "amigax_proto.h"
#include "amiga_x.h"

extern UWORD *XOrigPattern;
extern byte XOrigPatternSize;
extern int Xdash;

XSetFillStyle(display, gc, fill_style)
     Display *display;
     GC gc;
     int fill_style;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetFillStyle %d\n",fill_style);
#endif
  gc->values.fill_style=(gc->values.fill_style&0xff00)|fill_style;
  prevgc=-1;
  return(0);
}


XSetDashes(display, gc, dash_offset, dash_list, n)
     Display *display;
     GC gc;
     int dash_offset;
     char dash_list[];
     int n;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetDashes\n");
#endif
/*
  Xdash=dash_list;
  prevgc=-1;
*/
  return(0);
}

XSetFillRule(display, gc, fill_rule)
     Display *display;
     GC gc;
     int fill_rule;
{
}
