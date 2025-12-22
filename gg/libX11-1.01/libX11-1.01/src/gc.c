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

16. Nov 96: Added function and input description to all functions.
16. Nov 96: Added clip_mask to XCopyGC(),XCreateGC(),XGetGCValues() and XChangeGC()
26. Now 96: Added clip_x_origin/clip_y_origion to XCopyGC(),XCreateGC(),XGetGCValues() andXChangeGC()
***/

#include <time.h>
#include <intuition/intuition.h>
#include <proto/intuition.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

#include "debug.h"

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>

#include "x11display.h"

/********************************************************************************/
/* external */
/********************************************************************************/

void X11RemoveTileStippled( int vBitmap );
int ImageCache_Delete( int vSource );

/********************************************************************************/
/* internal */
/********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
extern int bInformGC; /* ignore outputting information about events */
#endif

/********************************************************************************
Name     : XCopyGC()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     src       Specifies the components of the source graphics context.

     valuemask Specifies the components in the source GC  structure  to  be
               copied  into  the  destination  GC.   valuemask  is  made by
               combining any number of  the  mask  symbols  listed  in  the
               Structures section using bitwise OR (|).

     dest      Specifies the destination graphics context.

Output   : 
Function : copy a graphics context.
********************************************************************************/

XCopyGC( Display* display,
	 GC src,
	 unsigned long valuemask,
	 GC dest )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCOPYGC , bInformGC );
#endif
  if( valuemask&GCClipMask )
    dest->values.clip_mask = src->values.clip_mask;
  if( valuemask&GCForeground )
    dest->values.foreground = src->values.foreground;
  if( valuemask&GCBackground )
    dest->values.background = src->values.background;
  if( valuemask&GCFunction )
    dest->values.function = src->values.function;
  if( valuemask&GCFillStyle )
    dest->values.fill_style = src->values.fill_style;
  if( valuemask&GCStipple )
    XSetStipple(display,dest,src->values.stipple);
  if( valuemask&GCLineStyle )
    dest->values.line_style = src->values.line_style;
#if (DEBUG!=0)
  if( dest->values.line_style>2 ){
    printf("Invalid line_style %d\n",dest->values.line_style);
  }
#endif
  if( valuemask&GCFont )
    dest->values.font = src->values.font;
  if( valuemask&GCClipXOrigin )
    dest->values.clip_x_origin = src->values.clip_x_origin;
  if( valuemask&GCClipYOrigin )
    dest->values.clip_y_origin = src->values.clip_y_origin;

  vPrevGC = (GC)-1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCOPYGC , bInformGC );
#endif

  return(0);
}

/********************************************************************************
Name     : XCreateGC()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies a drawable.  The created GC can only  be  used  to
               draw in drawables of the same depth as this drawable.

     valuemask Specifies which members of  the  GC  are  to  be  set  using
               information  in  the values structure.  valuemask is made by
               combining any number of  the  mask  symbols  listed  in  the
               Structures section.

     values    Specifies a pointer to an  XGCValues  structure  which  will
               provide components for the new GC.

Output   : 
Function : create a new graphics context for a given screen with the
           depth of the specified drawable.
********************************************************************************/

GC
XCreateGC( Display* display,
	   Drawable drawable,
	   unsigned long valuemask,
	   XGCValues* values )
{
  GC agcs;

  agcs = calloc(sizeof(struct _XGC),1);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEGC , bInformGC );
#endif
  agcs->values.foreground = 0;
  agcs->values.background = 0;
  agcs->values.line_width = 1;
  agcs->values.function = GXcopy;

  if( !DG.X11Font )
    X11init_fonts();

  agcs->values.font = DG.X11Font->fid;

  agcs->values.subwindow_mode = X11NewGC(agcs);
  if( valuemask&GCClipMask )
    XSetClipMask(display,agcs,values->clip_mask);
  if( valuemask&GCForeground )
    agcs->values.foreground = values->foreground;
  if( valuemask&GCBackground )
    agcs->values.background = values->background;
  if( valuemask&GCLineWidth )
    agcs->values.line_width = values->line_width;
  if( valuemask&GCLineStyle )
    XSetLineAttributes(display,agcs,1,values->line_style,0,0);
  if( valuemask&GCCapStyle )
    agcs->values.cap_style = values->cap_style;
  if( valuemask&GCJoinStyle )
    agcs->values.join_style = values->join_style;
  if( valuemask&GCFunction )
    agcs->values.function = values->function;
  if( valuemask&GCFont )
    agcs->values.font = values->font;
  if( valuemask&GCFillStyle )
    agcs->values.fill_style = values->fill_style;
  if( valuemask&GCStipple )
    XSetStipple(display,agcs,values->stipple);
  if( valuemask&GCLineStyle )
    agcs->values.line_style = values->line_style;
#if (DEBUG!=0)
  if( agcs->values.line_style>2 ){
    printf("Invalid line_style %d\n",agcs->values.line_style);
  }
#endif
  if( valuemask&GCClipXOrigin )
    agcs->values.clip_x_origin = values->clip_x_origin;
  if( valuemask&GCClipYOrigin )
    agcs->values.clip_y_origin = values->clip_y_origin;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCREATEGC , bInformGC );
#endif
  /* X11ActiveGC++; */
  return(agcs);
}

/********************************************************************************
Name     : XFreeGC()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context to be freed.

Output   : 
Function : free a graphics context.
********************************************************************************/

XFreeGC( Display* display,
	 GC gc )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XFREEGC , bInformGC );
#endif
  if( gc->values.stipple ){
    X11DrawablesBitmaps[X11DrawablesMap[gc->values.stipple]].vNumActive--;
    if( X11DrawablesBitmaps[X11DrawablesMap[gc->values.stipple]].vNumActive<=0 ){
      X11RemoveTileStippled( gc->values.stipple );
      /* ImageCache_Delete( gc->values.stipple ); */
    }
  }
  if( gc->values.tile ){
    X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive--;
    if( X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive<=0 ){
      X11RemoveTileStippled( gc->values.tile );
      /* ImageCache_Delete( gc->values.tile ); */
    }
  }
  X11FreeGC( gc );
  free(gc);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XFREEGC , bInformGC );
#endif

  return(0);
}

/********************************************************************************
Name     : XSetForeground()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     foreground
               Specifies the  foreground  pixel  value  you  want  for  the
               specified graphics context.

Output   : 
Function : set the foreground pixel value in a graphics context.
********************************************************************************/

//#if (DEBUG!=0)
XSetForeground( Display* d,
	        struct _XGC* gc,
	        unsigned long pen )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETFOREGROUND , bInformGC );
#endif
  gc->values.foreground = pen;
  vPrevGC = (GC)-1;
}
//#else
//#endif 

/********************************************************************************
Name     : XSetBackground()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     background
               Specifies the background component of the GC.

Output   : 
Function : set the background pixel value in a graphics context.
********************************************************************************/

//#if (DEBUG!=0)
XSetBackground( Display* d,
	        struct _XGC* gc,
	        unsigned long pen )
{ 
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETBACKGROUND , bInformGC );
#endif
  gc->values.background = pen;
  vPrevGC = (GC)-1;
}
//#else

//#endif

/********************************************************************************
Name     : XSetState()
Author   : Terje Pedersen
Input    : 
     display    Specifies a  connection  to  an  X  server;  returned  from
                XOpenDisplay().

     gc         Specifies the graphics context.

     foreground  Specifies  the  foreground  for  the  specified   graphics
                context.

     background  Specifies  the  background  for  the  specified   graphics
                context.

     function   Specifies the logical function for the  specified  graphics
                context.

     plane_mask  Specifies  the  plane  mask  for  the  specified  graphics
                context.

Output   : 
Function : set the foreground, background, logical function, and
           plane mask in a graphics context.
********************************************************************************/

XSetState( Display* display,
	   GC gc,
	   unsigned long foreground,
	   unsigned long background,
	   int function,
	   unsigned long plane_mask )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETSTATE , bInformGC );
#endif
  XSetForeground(display,gc,foreground);
  XSetBackground(display,gc,foreground);
  XSetFunction(display,gc,function);
  XSetPlaneMask(display,gc,plane_mask);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSETSTATE , bInformGC );
#endif

  return(0);
}

/********************************************************************************
Name     : XGContextFromGC()
Author   : Terje Pedersen
Input    : gc        Specifies the graphics context of the desired resource ID.
Output   : 
Function : obtain the GContext (resource ID) associated with
           the specified graphics context.
********************************************************************************/
GContext
XGContextFromGC( GC gc )
{
  return gc->gid;
}

/********************************************************************************
Name     : XGetGCValues()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to an X server; returned from
               XOpenDisplay().

     gc        Specifies the GC.

     valuemask Specifies which components in the GC are to be returned in
               the values_return argument. This argument is the bitwise
               inclusive OR of zero or more of the valid GC component mask
               bits.

     values_return
               Returns the GC values in the specified XGCValues structure.

Output   : 
Function : obtain components of a given GC from Xlib's GC cache.
********************************************************************************/

Status
XGetGCValues( Display* display,
	      GC gc,
	      unsigned long valuemask,
	      XGCValues* values )
{
#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XGETGCVALUES , bInformGC );
#endif
  if( valuemask&GCClipMask )
    values->clip_mask = gc->values.clip_mask ;
  if( valuemask&GCFillStyle )
    values->fill_style = gc->values.fill_style;
  if( valuemask&GCLineStyle )
    values->line_style = gc->values.line_style;
  if( valuemask&GCLineWidth )
    values->line_width = gc->values.line_width;
  if( valuemask&GCCapStyle )
    values->cap_style = gc->values.cap_style;
  if( valuemask&GCJoinStyle )
    values->join_style = gc->values.join_style;
  if( valuemask&GCFunction )
    values->function = gc->values.function;
  if( valuemask&GCFont )
    values->font = gc->values.font;
  if( valuemask&GCForeground )
    values->foreground = gc->values.foreground;
  if( valuemask&GCBackground )
    values->background = gc->values.background;
  if( valuemask&GCClipXOrigin )
    values->clip_x_origin = gc->values.clip_x_origin;
  if( valuemask&GCClipYOrigin )
    values->clip_y_origin = gc->values.clip_y_origin;

#if (DEBUGXEMUL_ENTRY)
  FunCount_Leave( XGETGCVALUES , bInformGC );
#endif
  
  return(0);
}

/********************************************************************************
Name     : XSetTSOrigin()
Author   : Terje Pedersen
Input    : 
     display     Specifies a connection  to  an  X  server;  returned  from
                 XOpenDisplay().

     gc          Specifies the graphics context.

     ts_x_origin
     ts_y_origin
                 Specify the  x  and  y  coordinates  of  the  tile/stipple
                 origin.

Output   : 
Function : set the tile/stipple origin in a graphics context.
********************************************************************************/

#if (DEBUG!=0)
XSetTSOrigin( Display* display,
	      GC gc,
	      int ts_x_origin,
	      int ts_y_origin )
{
#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XSETTSORIGIN , bInformGC );
#endif
  gc->values.ts_x_origin = ts_x_origin;
  gc->values.ts_y_origin = ts_y_origin;

  return(0);
}
#endif

/********************************************************************************
Name     : XChangeGC()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     valuemask Specifies the components in the graphics  context  that  you
               want  to  change.  This argument is the bitwise OR of one or
               more of the GC component masks.

     values    Specifies a pointer to the XGCValues structure.

Output   : 
Function : change the components of a given graphics context.
********************************************************************************/

XChangeGC( Display* display,
	   GC gc,
	   unsigned long valuemask,
	   XGCValues* values )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCHANGEGC , bInformGC );
#endif
  if( valuemask&GCStipple ){
    XSetStipple(display,gc,values->stipple);
  }
  if( valuemask&GCTile ){
    XSetTile(display,gc,values->tile);
  }
  if( valuemask&GCClipMask )
    XSetClipMask(display,gc,values->clip_mask);
  if( valuemask&GCFillStyle ){
    /* XSetFillStyle(display,gc,values->fill_style); */
    gc->values.fill_style=(gc->values.fill_style&0xff00)|values->fill_style;
  }
  if( valuemask&GCLineStyle ){
    /* XSetLineAttributes(display,gc,1,values->line_style,0,0); */
    gc->values.line_style = values->line_style;
#if (DEBUG!=0)
    if( gc->values.line_style>2 ){
      printf("Invalid line_style %d\n",gc->values.line_style);
    }
#endif
    X11LineMapping[1] = 0xaaaa;
  }
  if( valuemask&GCLineWidth )
    gc->values.line_width = values->line_width;
  if( valuemask&GCCapStyle )
    gc->values.cap_style = values->cap_style;
  if( valuemask&GCJoinStyle )
    gc->values.join_style = values->join_style;
  if( valuemask&GCFunction )
    gc->values.function = values->function;
  if( valuemask&GCFont ){
    /* XSetFont(display,gc,values->font); */
    gc->values.font = values->font;
  }
  if( valuemask&GCForeground ){
    /* XSetForeground(display,gc,values->foreground); */
    gc->values.foreground = values->foreground;
  }
  if( valuemask&GCBackground ){
    /* XSetBackground(display,gc,values->background); */
    gc->values.background = values->background;
  }
  if( valuemask&GCClipXOrigin )
    gc->values.clip_x_origin = values->clip_x_origin;
  if( valuemask&GCClipYOrigin )
    gc->values.clip_y_origin = values->clip_y_origin;

  vPrevGC = (GC)-1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCHANGEGC, bInformGC );
#endif 

  return(0);
}

/********************************************************************************
Name     : XSetArcMode()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     arc_mode  Specifies the arc mode for the specified  graphics  context.
               Possible values are ArcChord or ArcPieSlice.

Output   : 
Function : set the arc mode in a graphics context.
********************************************************************************/

XSetArcMode( Display* display,
	     GC gc,
	     int arc_mode )
{
#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XSETARCMODE , bInformGC );
#endif
  gc->values.arc_mode = arc_mode;
  vPrevGC = (GC)-1;

  return(0);
}

/********************************************************************************
Name     : XSetFunction()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

//#if (DEBUG!=0)
XSetFunction( Display* display,
	      GC gc,
	      int function )
{
  gc->values.function = function;
  vPrevGC = (GC)-1;
  return(0);
}
//#else
//#endif

/********************************************************************************
Name     : XSetLineAttributes()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSetLineAttributes( Display* display,
		    GC gc,
		    unsigned int line_width,
		    int line_style,
		    int cap_style,
		    int join_style )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETLINEATTRIBUTES , bInformGC );
#endif

  gc->values.line_style = line_style;
#if (DEBUG!=0)
  if( gc->values.line_style>2 ){
    printf("Invalid line_style %d\n",gc->values.line_style);
  }
#endif
  gc->values.line_width = line_width;
  gc->values.cap_style = cap_style;
  gc->values.join_style = join_style;

  if( line_style==LineOnOffDash ){ /* reset this.. */
    X11LineMapping[1] = 0xaaaa;
  }

#if 0
  switch( line_style ){
  case LineSolid: Xdash = 0xffff;break;
  case LineOnOffDash: Xdash = 0xaaaa;break;
  case LineDoubleDash: Xdash = 0xff00;break;
  }
#endif
  vPrevGC = (GC)-1;
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSETLINEATTRIBUTES, bInformGC );
#endif 
  return(0);
}

/********************************************************************************
Name     : XSetTile()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     gc       Specifies the graphics context.

     tile      Specifies  the  desired  tile  for  the  specified  graphics
              context.

Output   : 
Function : set the fill tile in a graphics context.
********************************************************************************/

XSetTile( Display* display,
	  GC  gc,
	  Pixmap tile )
{
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFilling )
    return;
  FunCount_Enter( XSETTILE , bInformGC );
#endif
/*
  if( X11prevtile==tile )
    return;
*/
  if( gc->values.tile!=0 ){
    X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive--;
    if( X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive<=0
       && (X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].bTileStipple&BITMAP_DELETED) ){
      /* ImageCache_Delete( gc->values.tile ); */
      X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].bTileStipple = 0;
      XFreePixmap(NULL,gc->values.tile);
    }
  }

  X11DrawablesBitmaps[X11DrawablesMap[tile]].vNumActive++;
  X11DrawablesBitmaps[X11DrawablesMap[tile]].bTileStipple |= BITMAP_USED;
  gc->values.tile = tile;
  vPrevGC = (GC)-1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSETTILE, bInformGC );
#endif 

  return(0);
}

void X11RemoveTileStippled( int vBitmap );
int ImageCache_Delete( int vSource );

void
X11RemoveTileStippled( int vBitmap )
{
  X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].vNumActive--;
  if ( X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].vNumActive<=0 ){
    if( DG.X11UnCached && vBitmap==DG.X11FillSource ){
      free_bitmap( DG.X11FillBitMap );
      DG.X11FillSource = -1;
      DG.X11UnCached = FALSE;
    }
    X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].bTileStipple &= (~BITMAP_USED);
    if( X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].bTileStipple & BITMAP_DELETED ){
      X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].bTileStipple = 0;
      XFreePixmap(NULL,vBitmap);
    } 
  }
}

boolean
X11IsTileStippleActive( int vBitmap )
{
  return (X11DrawablesBitmaps[X11DrawablesMap[vBitmap]].vNumActive);
}

/********************************************************************************
Name     : XSetStipple()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     gc       Specifies the graphics context.

     stipple  Specifies the stipple for the specified graphics context.

Output   : 
Function : set the stipple in a graphics context.
********************************************************************************/

XSetStipple( Display* display,
	     GC gc,
	     Pixmap stipple )
{
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFilling )
    return;
  FunCount_Enter( XSETSTIPPLE , bInformGC );
#endif
  if( gc->values.tile!=0 ){
    X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive--;
    if( X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].vNumActive<=0
       && (X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].bTileStipple&BITMAP_DELETED) ){
      /* ImageCache_Delete( gc->values.tile ); */
      X11DrawablesBitmaps[X11DrawablesMap[gc->values.tile]].bTileStipple = 0;
      XFreePixmap(NULL,gc->values.tile);
    }
  }
  gc->values.tile = stipple;
  X11DrawablesBitmaps[X11DrawablesMap[stipple]].bTileStipple |= BITMAP_USED;
  X11DrawablesBitmaps[X11DrawablesMap[stipple]].vNumActive++;
  if ( X11DrawablesBitmaps[X11DrawablesMap[stipple]].width>16 ){
    gc->values.fill_style = INTERNAL_FILL|gc->values.fill_style;
  } else {
    gc->values.fill_style = NORMAL_FILL|gc->values.fill_style;
  }
  vPrevGC = (GC)-1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XSETSTIPPLE, bInformGC );
#endif 

  return(0);
}
