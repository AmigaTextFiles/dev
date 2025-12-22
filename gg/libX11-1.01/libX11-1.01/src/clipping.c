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

#include "x11display.h"
#include "clipping.h"

/********************************************************************************/
/* external */
/********************************************************************************/

/*clipping from rkm */


/********************************************************************************/
/* internal */
/********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
int bIgnoreClipping=1; /* ignore outputting information about events */
#endif

ClippingGlobals_s CG;

/********************************************************************************/
/* functions */
/********************************************************************************/

/*
#define DOCLIPPING
#define DEBUGCLIPPING
*/

/*
** clipWindow()
** Clip a window to a specified rectangle (given by upper left and
** lower right corner.)  the removed region is returned so that it
** may be re-installed later.
*/
/********************************************************************************
Name     : 
Author   : Terje Pedersen (not really..some example code..)
Input    : 
Output   : 
Function : 
********************************************************************************/

struct Region *
clipWindow( struct Layer *l,
	    LONG minX,
	    LONG minY,
	    LONG maxX,
	    LONG maxY )
{
#ifdef DOCLIPPING
  struct Region    *new_region,*retregion;
  struct Rectangle  my_rectangle;

#ifdef DEBUGCLIPPING
  if( !bIgnoreClipping )
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
      DisposeRegion( new_region );
      new_region = NULL;
    }
  }

/* Install the new region, and return any existing region.
** If the above allocation and region processing failed, then
** new_region will be NULL and no clip region will be installed.
*/
  retregion = InstallClipRegion(l, new_region);
  return( retregion );
#else
  return 0;
#endif
}

/*
** unclipWindow()
**
** Used to remove a clipping region installed by clipWindow() or
** clipWindowToBorders(), disposing of the installed region and
** reinstalling the region removed.
*/

/********************************************************************************
Name     : 
Author   : Terje Pedersen (not really..some example code..)
Input    : 
Output   : 
Function : 
********************************************************************************/

void
unclipWindow(struct Layer *l)
{
#ifdef DOCLIPPING
  struct Region     *old_region;

#ifdef DEBUGCLIPPING
  if( !bIgnoreClipping )
    printf("unclipWindow %d\n",l);
#endif /* DEBUGCLIPPING */
  /* Remove any old region by installing a NULL region,
   ** then dispose of the old region if one was installed.
   */
  if( NULL != (old_region = InstallClipRegion(l, NULL)) )
    DisposeRegion( old_region );
#endif
}

/********************************************************************************
Name     : XSetClipRectangles()
Author   : Terje Pedersen
Input    : 
     display     Specifies a connection  to  an  X  server;  returned  from
                 XOpenDisplay().

     gc          Specifies the graphics context.

     clip_x_origin
     clip_y_origin
                 Specify the  x  and  y  coordinates  of  the  clip  origin
                 (interpreted  later relative to the window drawn into with
                 this GC).

     rectangles   Specifies  an  array  of  rectangles.   These   are   the
                 rectangles you want drawing clipped to.

     n           Specifies the number of rectangles.

     ordering     Specifies  the  ordering  relations  of  the  rectangles.
                 Possible   values  are  Unsorted,  YSorted,  YXSorted,  or
                 YXBanded.

Output   : 
Function : change clip_mask in a graphics context to a list of rectangles.
********************************************************************************/

XSetClipRectangles( Display* d,
		    GC gc,
		    int clip_x_origin,
		    int clip_y_origin,
		    XRectangle* rectangles,
		    int n,
		    int ordering )
{
#ifdef DOCLIPPING
  struct Region *old_region;
  struct Window *win;
  Window w = RootWindowOfScreen(DefaultScreenOfDisplay(d));
  int root = X11Windows[X11DrawablesMap[w]].root;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("(clipping)XsetClipRectangles [%d]\n",w);
#endif
  if( w==DG.X11Screen[0].root ){
    return;
  }
  win = X11DrawablesWindows[X11DrawablesMap[root]];
  if( !win )
    return 0;
  if( !win->WLayer ){
    return;
  }
  if( win && GetWinFlag(w,WIN_MAPPED) ){
    if( CG.pPreviousLayer ){
      unclipWindow( CG.pPreviousLayer );
      CG.pPreviousLayer = NULL;
    }
    if( (old_region = clipWindow(win->WLayer,DG.
				 vWinX+rectangles[0].x,
				 DG.vWinY+rectangles[0].y,
				 DG.vWinX+rectangles[0].x+rectangles[0].width-1,
				 DG.vWinY+rectangles[0].y+rectangles[0].height-1)) ){
      DisposeRegion( old_region );
      CG.pPreviousLayer = win->WLayer;
    } else 
      CG.pPreviousLayer = NULL;
  }
  DG.vPrevWindow = -1;
#endif
}

/*
_SetBmClip(struct BitMap *bm,struct RastPort *rp){
  if( (old_region = clipWindow(rp->Layer,0,0,bm->BytesPerRow*8-1,bm->Rows-1)) )
    DisposeRegion( old_region );
}
*/

/********************************************************************************
Name     : XSetClipMask()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     pixmap    Specifies a pixmap of depth 1 to be used as the  clip  mask.
               Pass the constant None if no clipping is desired.

Output   : 
Function : set pixmap pixmap in a graphics context.
********************************************************************************/

XSetClipMask( Display* d,
	      GC gc,
	      Pixmap pixmap )
{
  struct BitMap *bm = X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;

#ifdef DEBUGXEMUL
  if( !bIgnoreClipping ){
    if( bm )
      printf("(clipping)XSetClipMask [%d,%d]\n",bm->BytesPerRow*8,bm->Rows);
    else
      printf("(clipping)XSetClipMask\n");
  }
#endif

  if( pixmap==None && DG.vUseWB ){
#ifdef DOCLIPPING
    Window w = RootWindowOfScreen(DefaultScreenOfDisplay(d));

    if( w!=ROOTID )
    if( X11Drawables[w]==X11WINDOW ){
      int root = X11Windows[X11DrawablesMap[w]].root;
      struct Window *win = X11DrawablesWindows[X11DrawablesMap[root]];
      if( win ) unclipWindow(win->WLayer);
    }
#endif
  }
  if( pixmap ){
    int BmWidth = GetBitMapAttr(bm,BMA_WIDTH);
    int BmHeight = GetBitMapAttr(bm,BMA_HEIGHT);
/*
  int BmDepth = GetBitMapAttr(bm,BMA_DEPTH);
  if( BmDepth!=1 ) {printf("wrong depth!\n");getchar();}*/
    CG.bNeedClip = 1;
/*    if(CG.pClipBM) {printf("already got one!\n");getchar();}*/
    CG.pClipBM = alloc_bitmap(BmWidth,BmHeight,1,BMF_CLEAR,NULL);
    if( DG.XAllocFailed ) return NULL;
    BltBitMap(bm,0,0,CG.pClipBM,0,0,BmWidth,BmHeight,0xC0,0xff,NULL);
/*    memcpy(&CG.pClipBM->Planes[0],&bm->Planes[0],bm->BytesPerRow*bm->Rows);*/
  } else {
    CG.bNeedClip = 0;
    if( CG.pClipBM )
      free_bitmap( CG.pClipBM );
    CG.pClipBM = NULL;
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
clip_begin( int minX,
	    int minY,
	    int maxX,
	    int maxY )
{
#ifdef DOCLIPPING
  struct Rectangle my_rectangle;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("clip_begin %d %d %d %d\n",minX,minY,maxX,maxY);
#endif
  my_rectangle.MinX = minX;
  my_rectangle.MinY = minY;
  my_rectangle.MaxX = maxX;
  my_rectangle.MaxY = maxY;
  if ( CG.pClipRegion = NewRegion() ){
    OrRectRegion(CG.pClipRegion, &my_rectangle);
  }
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
clip_exclude( int X,
	      int Y,
	      int width,
	      int height )
{
#ifdef DOCLIPPING
  int minX = X,minY = Y,maxX = X+width,maxY = Y+height;
  struct Rectangle my_rectangle;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("clip_exclude %d %d %d %d\n",minX,minY,maxX,maxY);
#endif

  my_rectangle.MinX = minX;
  my_rectangle.MinY = minY;
  my_rectangle.MaxX = maxX;
  my_rectangle.MaxY = maxY;
  if( !XorRectRegion(CG.pClipRegion, &my_rectangle) )
    printf("clip_exclude failed!\n");
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
clip_end( struct Window *win )
{
#ifdef DOCLIPPING
  struct Region *old_region;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("clip_end win %d\n",win);
#endif
  old_region = InstallClipRegion(win->WLayer, CG.pClipRegion);
  if( old_region!=NULL )
    DisposeRegion( old_region );
#endif
}

/********************************************************************************
Name     : XSetPlaneMask()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     plane_mask
               Specifies the plane mask.  You can use the macro AllPlanes()
               if desired.


Output   : 
Function : set the plane mask in a graphics context.
********************************************************************************/

XSetPlaneMask( Display* display,
	       GC gc,
	       unsigned long plane_mask )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("(clipping)XSetPlaneMask [%d]\n",plane_mask);
#endif
#if 1
  if( DG.Scr && DG.Scr!=DG.wb )
    SetWriteMask(&DG.Scr->RastPort,plane_mask);
#else
  printf("(clipping)XSetPlaneMask [%d]\n",plane_mask);

#endif
  return(0);
}

/********************************************************************************
Name     : XSetClipOrigin()
Author   : Terje Pedersen
Input    : 
     display     Specifies a connection  to  an  X  server;  returned  from
                 XOpenDisplay().

     gc          Specifies the graphics context.

     clip_x_origin
     clip_y_origin
                 Specify the coordinates of the  clip  origin  (interpreted
                 later relative to the window drawn into with this GC).


Output   : 
Function : set the clip origin in a graphics context.
********************************************************************************/

XSetClipOrigin( Display* display,
	        GC gc,
	        int clip_x_origin,
	        int clip_y_origin )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreClipping )
    printf("XSetClipOrigin [%d,%d]\n",clip_x_origin,clip_y_origin);
#endif
  gc->values.clip_x_origin = clip_x_origin;
  gc->values.clip_y_origin = clip_y_origin;
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

struct Region *clipWindowToBorders(struct Window *win)
{
  return(clipWindow(win->WLayer, win->BorderLeft, win->BorderTop,
		    win->Width - win->BorderRight - 1, win->Height - win->BorderBottom - 1));
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

VOID
clip_test( struct Window *win )
{
#ifdef DOCLIPPING
  struct Region    *old_region;
  
  if (NULL != (old_region = clipWindowToBorders(win)))
    DisposeRegion(old_region);
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11init_clipping( void )
{
  memset(&CG,0,sizeof(ClippingGlobals_s));
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11exit_clipping( void )
{
}
