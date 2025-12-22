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
     regions
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 24, 1995: Created.

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
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
#include <math.h>

#include "libX11.h"

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>


/*
#define DOCLIPPING
#define DOREGIONS
*/

/********************************************************************************
Function : XPolygonRegion()
Author   : Terje Pedersen
Input    : 
     points    Specifies a pointer to an array of points.

     n         Specifies the number of points in the polygon.

     fill_rule Specifies whether areas overlapping an odd number  of  times
               should  be  part  of the region (WindingRule) or not part of
               the region (EvenOddRule).  See Volume One,  Chapter  5,  The
               Graphics Context, for a description of the fill rule.


Output   : 
Function : generate a region from points in a polygon.
********************************************************************************/

Region
XPolygonRegion( XPoint *points,
	        int n,
	        int fill_rule )
{
#ifdef DOREGIONS
  int i;
  struct Rectangle rec;
  int nXMin,nXMax,nYMin,nYMax;
  struct Region *reg;
  
  nXMin = points[0].x;
  nYMin = points[0].y;
  nXMax = points[0].x;
  nYMax = points[0].y;
  for( i=1; i<n; i++ ){
    if( points[i].x<nXMin )
      nXMin = points[i].x;
    if( points[i].y<nYMin )
      nYMin = points[i].y;
    if( points[i].x>nXMax )
      nXMax = points[i].x;
    if( points[i].y>nYMax )
      nYMax = points[i].y;
  }
  reg = (struct Region*)XCreateRegion();

  rec.MinX = nXMin;
  rec.MinY = nYMin;
  rec.MaxX = nXMax;
  rec.MaxY = nYMax;

  XUnionRectWithRegion( &rec, (Region)reg, (Region)reg );

  return (Region)reg;
#else
  return 0;
#endif /* DOREGIONS */
}

/********************************************************************************
Function : XCreateRegion()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : create a new empty region.
********************************************************************************/

Region
XCreateRegion( void )
{
#ifdef DOREGIONS
  return (Region)NewRegion();
#else
  return 0;
#endif /* DOREGIONS */
}

/********************************************************************************
Function : XSubtractRegion()
Author   : Terje Pedersen
Input    : 
     sra
     srb
               Specify the two regions in which you  want  to  perform  the
               computation.

     dr_return Returns the result of the computation.

Output   : 
Function : subtract one region from another.
********************************************************************************/

XSubtractRegion( Region sra,
		 Region srb,
		 Region dr_return )
{
#if (DEBUGXEMUL_ENTRY)
  printf("XSubtractRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion( (struct Region *)sra, (struct Region *)dr_return );
  XorRegionRegion( (struct Region*)srb, (struct Region*)dr_return );
  AndRegionRegion( (struct Region *)sra, (struct Region *)dr_return );
#endif /* DOREGIONS */

  return 0;
}

/********************************************************************************
Function : XDestroyRegion()
Author   : Terje Pedersen
Input    : r         Specifies the region to be destroyed.
Output   : 
Function : deallocate memory associated with a region.
********************************************************************************/

XDestroyRegion( Region r )
{
#ifdef DOREGIONS
  DisposeRegion((struct Region *)r);
#endif /* DOREGIONS */

  return;
}

/********************************************************************************
Function : XClipBox()
Author   : Terje Pedersen
Input    : 
     r         Specifies the region.

     rect_return
               Returns the smallest rectangle enclosing region r.

Output   : 
Function : generate the smallest rectangle enclosing a region.
********************************************************************************/

XClipBox( Region r, XRectangle* rect_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING:XClipBox\n");
#endif

  return(0);
}

/********************************************************************************
Function : XUnionRectWithRegion()
Author   : Terje Pedersen
Input    : 
     rectangle Specifies the rectangle to add to the region.

     src_region
               Specifies the source region to be used.

     dest_region_return
               Specifies  the  resulting  region.   May  be  the  same   as
               src_region.

Output   : 
Function : add a rectangle to a region.
********************************************************************************/

XUnionRectWithRegion( XRectangle* rectangle,
		      Region src_region,
		      Region dest_region_return )
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XUnionRectWithRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion( (struct Region *)src_region, (struct Region *)dest_region_return );
  OrRectRegion( (struct Region *)dest_region_return, (struct Rectangle *)rectangle );
#endif /* DOREGIONS */

  return(0);
}

/********************************************************************************
Function : XSetRegion()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     r         Specifies the region.


Output   : 
Function : set clip_mask of the graphics context to the specified region.
********************************************************************************/

XSetRegion( Display* display,
	    GC gc,
	    Region r )
{
  int root;
#ifdef DOREGIONS
#if 0
#ifdef DOCLIPPING
  struct Region *old_region = (struct Region *)r;
#endif
  struct Window *win;
  Window w = RootWindowOfScreen( DefaultScreenOfDisplay(display) );

#ifdef DEBUGXEMUL_ENTRY
  printf("XSetRegion [%d,%d][%d,%d]\n",
	 old_region->bounds.MinX,
	 old_region->bounds.MinY,
	 old_region->bounds.MaxX,
	 old_region->bounds.MaxY);
#endif

  if( w==DG.X11Screen[0].root ){
    return;
  }
  root = X11Windows[X11DrawablesMap[w]].root;
  win = X11DrawablesWindows[X11DrawablesMap[root]];
  if( !win )
    return 0;
  if( !win->WLayer ){
    return;
  }

  if( CG.pPreviousLayer )
    unclipWindow( CG.pPreviousLayer );
  if( win && GetWinFlag(w,WIN_MAPPED) ){
    if( old_region  =InstallClipRegion(win->WLayer,(struct Region *)r) )
      DisposeRegion( old_region );
  }
  CG.pPreviousLayer = win->WLayer;
#endif
#endif /* DOREGIONS */

  return(0);
}

/********************************************************************************
Function : XIntersectRegion()
Author   : Terje Pedersen
Input    : 
     sra
     srb
               Specify  the  two  regions  with  which   to   perform   the
               computation.

     dr_return Returns the result of the computation.

Output   : 
Function : compute the intersection of two regions.
********************************************************************************/

XIntersectRegion( Region sra,
		  Region srb,
		  Region dr_return )
{
#if (DEBUGXEMUL_ENTRY)
  printf("XIntersectRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion( (struct Region *)sra, (struct Region *)dr_return );
  AndRegionRegion( (struct Region *)srb, (struct Region *)dr_return );
#else

  return 0;
#endif /* DOREGIONS */
}

/********************************************************************************
Function : XUnionRegion()
Author   : Terje Pedersen
Input    : 
     sra
     srb
               Specify the two regions in which you  want  to  perform  the
               computation.
9
     dr_return Returns the result of the computation.

Output   : 
Function : compute the union of two regions.
********************************************************************************/

XUnionRegion( Region sra,
	      Region srb,
	      Region dr_return )
{
#if (DEBUGXEMUL_ENTRY)
  printf("XUnionRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion( (struct Region *)sra, (struct Region *)dr_return );
  OrRegionRegion( (struct Region *)srb, (struct Region *)dr_return );
#else

  return 0;
#endif /* DOREGIONS */
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

inside_rectangle( struct Rectangle rec, int x, int y )
{
#ifdef DOREGIONS
  if( x>=rec.MinX && x<=rec.MaxX && y>=rec.MinY && y<=rec.MaxY ) return 1;
#endif /* DOREGIONS */
  return 0;
}

/********************************************************************************
Function : XPointInRegion()
Author   : Terje Pedersen
Input    : 
     r         Specifies the region.

     x
     y
               Specify the x and y coordinates of the point relative to the
               region's origin.

Output   : 
Function : determine if a point is inside a region.
********************************************************************************/

Bool XPointInRegion( Region r,
		     int x,
		     int y )
{
#ifdef DOREGIONS
  struct Region *reg = (struct Region *)r;

#if (DEBUGXEMUL_ENTRY)
  printf("XPointInRegion\n");
#endif
  if( inside_rectangle(reg->bounds,x,y) )
    return 1;
  else {
    struct RegionRectangle *rr = reg->RegionRectangle;

    while( rr!=NULL ){
      if( inside_rectangle(rr->bounds,x,y) )
	return 1;
      rr = rr->Next;
    }
  }
#endif /* DOREGIONS */
  return(0);
}

/********************************************************************************
Function : XXorRegion()
Author   : Terje Pedersen
Input    : 
 sra
 srb
           Specify the  two  regions  on  which  you  want  to  perform  the
           computation.

 dr_return Returns the result of the computation.

Output   : 
Function : calculate the difference between the union and intersection of
           two regions.
********************************************************************************/

XXorRegion( Region sra,
	    Region srb, 
	    Region dr_return )
{
#if (DEBUGXEMUL_ENTRY)
  printf("WARNING:XXorRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion( (struct Region *)sra, (struct Region *)dr_return );
  XorRegionRegion( (struct Region*)srb, (struct Region*)dr_return );
#endif /* DOREGIONS */

  return(0);
}
