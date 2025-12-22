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

#include "amigax_proto.h"
#include "amiga_x.h"

#define DOCLIPPING
#define DOREGIONS

Region XPolygonRegion(points, n, fill_rule)
     XPoint points[];
     int n;
     int fill_rule;
{
#ifdef DOREGIONS
  int i;
  struct Rectangle rec;
  int nXMin,nXMax,nYMin,nYMax;
  struct Region *reg;
  
  nXMin=points[0].x;
  nYMin=points[0].y;
  nXMax=points[0].x;
  nYMax=points[0].y;
  for(i=1;i<n;i++){
    if(points[i].x<nXMin) nXMin=points[i].x;
    if(points[i].y<nYMin) nYMin=points[i].y;
    if(points[i].x>nXMax) nXMax=points[i].x;
    if(points[i].y>nYMax) nYMax=points[i].y;
  }
  reg=(struct Region*)XCreateRegion();

  rec.MinX=nXMin;
  rec.MinY=nYMin;
  rec.MaxX=nXMax;
  rec.MaxY=nYMax;
/*
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XPolygonRegion [%d,%d][%d,%d]\n",rec.MinX,rec.MinY,rec.MaxX,rec.MaxY);
#endif
*/
  XUnionRectWithRegion(&rec,(Region)reg,(Region)reg);
  return (Region)reg;
#else
  return 0;
#endif /* DOREGIONS */
}

Region XCreateRegion(void){
#ifdef DOREGIONS
  return (Region)NewRegion();
#else
  return 0;
#endif /* DOREGIONS */
}

XSubtractRegion(sra, srb, dr_return)
     Region sra, srb;
     Region dr_return;
{
#if (DEBUGXEMUL_ENTRY)
  printf("XSubtractRegion\n");
#endif
  OrRegionRegion((struct Region *)sra,(struct Region *)dr_return);
  XorRegionRegion((struct Region*)srb,(struct Region*)dr_return);
  AndRegionRegion((struct Region *)sra,(struct Region *)dr_return);
  return 0;
}

XDestroyRegion(r)
     Region r;
{
#ifdef DOREGIONS
  DisposeRegion((struct Region *)r);
#endif /* DOREGIONS */
  return;
}

XClipBox(r, rect_return)
     Region r;
     XRectangle *rect_return;
{/*                File 'xvevent.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING:XClipBox\n");
#endif
  return(0);
}

XUnionRectWithRegion(rectangle, src_region, dest_region_return)
     XRectangle *rectangle;
     Region src_region;
     Region dest_region_return;
{/*    File 'xvevent.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XUnionRectWithRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion((struct Region *)src_region,(struct Region *)dest_region_return);
  OrRectRegion((struct Region *)dest_region_return,(struct Rectangle *)rectangle);
#endif /* DOREGIONS */

  return(0);
}

XSetRegion(display, gc, r)
     Display *display;
     GC gc;
     Region r;
{/*              File 'xvevent.o' */
#ifdef DOREGIONS
#ifdef DOCLIPPING
  struct Region *old_region=(struct Region *)r;
#endif
  struct Window *win;
  Window w=RootWindowOfScreen(DefaultScreenOfDisplay(display));
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetRegion\n");
  printf("XSetRegion [%d,%d][%d,%d]\n",old_region->bounds.MinX,old_region->bounds.MinY,old_region->bounds.MaxX,old_region->bounds.MaxY);
#endif

#if 0
  if( w==ROOTID ){
    return;
  }
  win=X11DrawablesWindows[X11DrawablesMap[w]];
  if(!win) return 0;
  if(!win->WLayer){
    return;
  }

  if(CG.pPreviousLayer) unclipWindow(CG.pPreviousLayer);
  if(win && X11ActualWindows[X11DrawablesMap[w]].mapped){
    if(old_region=InstallClipRegion(win->WLayer,(struct Region *)r))
      DisposeRegion(old_region);
  }
  CG.pPreviousLayer=win->WLayer;
#endif
#endif /* DOREGIONS */

  return(0);
}

XIntersectRegion(sra, srb, dr_return)
     Region sra, srb;
     Region dr_return;
{
#if (DEBUGXEMUL_ENTRY)
  printf("XIntersectRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion((struct Region *)sra,(struct Region *)dr_return);
  AndRegionRegion((struct Region *)srb,(struct Region *)dr_return);
#else
  return 0;
#endif /* DOREGIONS */
}

XUnionRegion(sra, srb, dr_return)
     Region sra, srb;
     Region dr_return;
{
#if (DEBUGXEMUL_ENTRY)
  printf("XUnionRegion\n");
#endif
#ifdef DOREGIONS
  OrRegionRegion((struct Region *)sra,(struct Region *)dr_return);
  OrRegionRegion((struct Region *)srb,(struct Region *)dr_return);
#else
  return 0;
#endif /* DOREGIONS */
}

inside_rectangle( struct Rectangle rec, int x, int y ){
  if( x>=rec.MinX && x<=rec.MaxX && y>=rec.MinY && y<=rec.MaxY ) return 1;
  return 0;
}

Bool XPointInRegion(r, x, y)
     Region r;
     int x, y;
{
  struct Region *reg=(struct Region *)r;
#if (DEBUGXEMUL_ENTRY)
  printf("XPointInRegion\n");
#endif
  if(inside_rectangle(reg->bounds,x,y))
    return 1;
  else {
    struct RegionRectangle *rr=reg->RegionRectangle;
    while( rr!=NULL ){
      if( inside_rectangle(rr->bounds,x,y) ) return 1;
      rr=rr->Next;
    }
  }
  return(0);
}

XXorRegion(sra, srb, dr_return)
     Region sra, srb;
     Region dr_return;
{
#if (DEBUGXEMUL_ENTRY)
  printf("WARNING:XXorRegion\n");
#endif
  OrRegionRegion((struct Region *)sra,(struct Region *)dr_return);
  XorRegionRegion((struct Region*)srb,(struct Region*)dr_return);
  return(0);
}
