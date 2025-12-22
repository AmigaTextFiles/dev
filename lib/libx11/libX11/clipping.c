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
     clipping
   PURPOSE
     add clipping support in libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 22, 1994: Created.
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

#define XLIB_ILLEGAL_ACCESS 1

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
#include "amigax_proto.h"
#include "amiga_x.h"

ClippingGlobals_s CG;

int XSetClipMask(Display *,GC,Pixmap);

extern int X_relx,X_rely;
extern struct Screen *Scr,*wb;
extern struct BitMap *alloc_bitmap(int,int,int,int);
extern int free_bitmap(struct BitMap *),wbapp;

void unclipWindow(struct Layer *l);
struct Region *clipWindow(struct Layer *l,
				 LONG minX, LONG minY, LONG maxX, LONG maxY);
void clip_begin(int,int,int,int);
void clip_exclude(int,int,int,int);
void clip_end(struct Window *);

/*clipping from rkm */

#define DOCLIPPING
/*
#define DEBUGCLIPPING
*/
/*
** clipWindow()
** Clip a window to a specified rectangle (given by upper left and
** lower right corner.)  the removed region is returned so that it
** may be re-installed later.
*/
struct Region *clipWindow(struct Layer *l,
    LONG minX, LONG minY, LONG maxX, LONG maxY)
{
#ifdef DOCLIPPING
  struct Region    *new_region,*retregion;
  struct Rectangle  my_rectangle;

#ifdef DEBUGCLIPPING
  printf("clipWindow %d\n",l);
#endif /* DEBUGCLIPPING */

/* set up the limits for the clip */
  my_rectangle.MinX = minX;
  my_rectangle.MinY = minY;
  my_rectangle.MaxX = maxX;
  my_rectangle.MaxY = maxY;

/* get a new region and OR in the limits. */
  if (NULL != (new_region = NewRegion())){
    if (FALSE == OrRectRegion(new_region, &my_rectangle)){
      DisposeRegion(new_region);
      new_region = NULL;
    }
  }

/* Install the new region, and return any existing region.
** If the above allocation and region processing failed, then
** new_region will be NULL and no clip region will be installed.
*/
  retregion=InstallClipRegion(l, new_region);
  return(retregion);
#endif
}

/*
** unclipWindow()
**
** Used to remove a clipping region installed by clipWindow() or
** clipWindowToBorders(), disposing of the installed region and
** reinstalling the region removed.
*/
void unclipWindow(struct Layer *l)
{
#ifdef DOCLIPPING
  struct Region     *old_region;
#ifdef DEBUGCLIPPING
  printf("unclipWindow %d\n",l);
#endif /* DEBUGCLIPPING */
  /* Remove any old region by installing a NULL region,
   ** then dispose of the old region if one was installed.
   */
  if (NULL != (old_region = InstallClipRegion(l, NULL)))
    DisposeRegion(old_region);
#endif
}

XSetClipRectangles(d,gc, clip_x_origin,
		   clip_y_origin, rectangles, n, ordering)
     Display *d;
/*     Drawable win;*/
     GC gc;
     int clip_x_origin, clip_y_origin;
     XRectangle *rectangles;
     int n;
     int ordering;
{
  struct Region *old_region;
  struct Window *win;
#ifdef DOCLIPPING
  Window w=RootWindowOfScreen(DefaultScreenOfDisplay(d));
#ifdef DEBUGXEMUL_ENTRY
  printf("(clipping)XsetClipRectangles [%d]\n",w);
#endif
/*
  printf("rect [%d %d] [%d %d]\n",rectangles[0].x,rectangles[0].y,rectangles[0].x+rectangles[0].width-1,rectangles[0].y+rectangles[0].height-1);
*/
  if( w==ROOTID ){
    return;
  }
  win=X11DrawablesWindows[X11DrawablesMap[w]];
  if(!win) return 0;
  if(!win->WLayer){
    return;
  }
  if(win && X11ActualWindows[X11DrawablesMap[w]].mapped){
    if(CG.pPreviousLayer){
      unclipWindow(CG.pPreviousLayer);
      CG.pPreviousLayer=NULL;
    }
    if(old_region=clipWindow(win->WLayer,X_relx+rectangles[0].x,X_rely+rectangles[0].y,X_relx+rectangles[0].x+rectangles[0].width-1,X_rely+rectangles[0].y+rectangles[0].height-1)){
      DisposeRegion(old_region);
      CG.pPreviousLayer=win->WLayer;
    } else CG.pPreviousLayer=NULL;
  }
  prevwin=-1;
#endif
}

/*
_SetBmClip(struct BitMap *bm,struct RastPort *rp){
  if(old_region=clipWindow(rp->Layer,0,0,bm->BytesPerRow*8-1,bm->Rows-1))
    DisposeRegion(old_region);
}
*/

XSetClipMask(d,gc,pixmap)
     Display *d;
/*     Object *win;*/
     GC gc;
     Pixmap pixmap;
{
#ifdef DOCLIPPING
  struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;
/*
  Window w=RootWindowOfScreen(DefaultScreenOfDisplay(d));
*/
#ifdef DEBUGXEMUL
  if(bm)
    printf("(clipping)XSetClipMask [%d,%d]\n",bm->BytesPerRow*8,bm->Rows);
  else
    printf("(clipping)XSetClipMask\n");
#endif


  if(pixmap==None&&wbapp){
/*
    struct Window *win=X11DrawablesWindows[X11DrawablesMap[w]];
    if(win) unclipWindow(win->WLayer);*/
  }
  if(pixmap){
    int BmWidth=GetBitMapAttr(bm,BMA_WIDTH);
    int BmHeight=GetBitMapAttr(bm,BMA_HEIGHT);
/*
    int BmDepth=GetBitMapAttr(bm,BMA_DEPTH);
    if(BmDepth!=1) {printf("wrong depth!\n");getchar();}*/
    CG.bNeedClip=1;
/*    if(CG.pClipBM) {printf("already got one!\n");getchar();}*/
    CG.pClipBM=alloc_bitmap(BmWidth,BmHeight,1,BMF_CLEAR);
    BltBitMap(bm,0,0,CG.pClipBM,0,0,BmWidth,BmHeight,0xC0,0xff,NULL);
/*    memcpy(&CG.pClipBM->Planes[0],&bm->Planes[0],bm->BytesPerRow*bm->Rows);*/
  }else{
    CG.bNeedClip=0;
    if(CG.pClipBM) free_bitmap(CG.pClipBM);
    CG.pClipBM=NULL;
  }
#endif
}

void clip_begin(minX,minY,maxX,maxY){
#ifdef DOCLIPPING
  struct Rectangle my_rectangle;
#ifdef DEBUGXEMUL
  printf("clip_begin %d %d %d %d\n",minX,minY,maxX,maxY);
#endif
  my_rectangle.MinX = minX;
  my_rectangle.MinY = minY;
  my_rectangle.MaxX = maxX;
  my_rectangle.MaxY = maxY;
  if (CG.pClipRegion = NewRegion()){
    OrRectRegion(CG.pClipRegion, &my_rectangle);
  }
#endif
}

void clip_exclude(X,Y,width,height){
#ifdef DOCLIPPING
  int minX=X,minY=Y,maxX=X+width,maxY=Y+height;
  struct Rectangle my_rectangle;

#ifdef DEBUGXEMUL
  printf("clip_exclude %d %d %d %d\n",minX,minY,maxX,maxY);
#endif

  my_rectangle.MinX = minX;
  my_rectangle.MinY = minY;
  my_rectangle.MaxX = maxX;
  my_rectangle.MaxY = maxY;
  if(!XorRectRegion(CG.pClipRegion, &my_rectangle))
    printf("clip_exclude failed!\n");
#endif
}

void clip_end(struct Window *win){
#ifdef DOCLIPPING
  struct Region *old_region;
#ifdef DEBUGXEMUL
  printf("win %d\n",win);
#endif
  old_region=InstallClipRegion(win->WLayer, CG.pClipRegion);
  if(old_region!=NULL) DisposeRegion(old_region);
#endif
}

XSetPlaneMask(display, gc, plane_mask)
     Display *display;
     GC gc;
     unsigned long plane_mask;
{
#ifdef DEBUGXEMUL
  printf("(clipping)XSetPlaneMask [%d]\n",plane_mask);
#endif
  if(Scr&&Scr!=wb)
    SetWriteMask(&Scr->RastPort,plane_mask);
  return(0);
}

XSetClipOrigin(display, gc, clip_x_origin, clip_y_origin)
     Display *display;
     GC gc;
     int clip_x_origin, clip_y_origin;
{
#ifdef DEBUGXEMUL
  printf("XSetClipOrigin [%d,%d]\n",clip_x_origin,clip_y_origin);
#endif
  CG.nXClipOrigin=clip_x_origin;
  CG.nYClipOrigin=clip_y_origin;
  return(0);
}

struct Region *clipWindowToBorders(struct Window *win)
{
  return(clipWindow(win->WLayer, win->BorderLeft, win->BorderTop,
		    win->Width - win->BorderRight - 1, win->Height - win->BorderBottom - 1));
}

VOID clip_test(struct Window *win){
#ifdef DOCLIPPING
  struct Region    *old_region;
  
  if (NULL != (old_region = clipWindowToBorders(win)))
    DisposeRegion(old_region);
#endif
}

void X11init_clipping(void){
  memset(&CG,0,sizeof(ClippingGlobals_s));
}

void X11exit_clipping(void){
}
