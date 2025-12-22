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

#include "debug.h"

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include "x11display.h"
#include "imagecache.h"


/*******************************************************************************************/
/* externals */
/*******************************************************************************************/

extern int show;

extern UWORD X11LineMapping[];

/********************************************************************************/
/* internal */
/********************************************************************************/

X11userdata *XBackUserData = NULL;
X11userdata *XBack2UserData = NULL;

struct RastPort fillmaskrp = {0},backfillrp2 = {0};

#ifdef DEBUGXEMUL_ENTRY
extern int bInformFilling; /* outputting information about filling */
extern int bSkipFilling;
#endif

/********************************************************************************/
/* functions */
/********************************************************************************/

void X11Filling_Init(void)
{
  DG.X11FillBitMap = NULL;
  DG.X11FillSource = 0;
  DG.X11UnCached = 0;
  DG.oldX11FillSource = -1;

  ImageCache_Init();
}

void X11Filling_Exit(void)
{
  if( fillmaskrp.BitMap ){
    free_bitmap(fillmaskrp.BitMap);
    free_bitmap(backfillrp2.BitMap);
  }
  ImageCache_Exit();

  if( DG.X11UnCached )
    free_bitmap( DG.X11FillBitMap );
    
  if( XBackUserData )
    exit_area(NULL, XBackUserData );
  if( XBack2UserData )
    exit_area(NULL, XBack2UserData );

}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#if (DEBUG!=0)
XSetFillStyle( Display* display,
	       GC gc,
	       int fill_style )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETFILLSTYLE , bInformFilling );
#endif
  gc->values.fill_style = (gc->values.fill_style&0xff00)|fill_style;
  vPrevGC = (GC)-1;

  return(0);
}
#endif

/********************************************************************************
Name     : XSetDashes()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     gc        Specifies the graphics context.

     dash_offset
               Specifies the phase of  the  pattern  for  the  dashed  line
               style.

     dash_list Specifies the dash list for the dashed line style.  An  odd-
               length list is equivalent to the same list concatenated with
               itself to produce an even-length list.

     n         Specifies the length of the dash list argument.

Output   : 
Function : set a pattern of line dashes in a graphics context.
********************************************************************************/

XSetDashes( Display* display,
	    GC gc,
	    int dash_offset,
	    char dash_list[],
	    int n )
{
  int i;
  UWORD nOut = 0;
  UWORD nShift = 1<<15;
  int nDashIndex = 0;
  int vOnOff = 1;
  int nBitCount;


#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETDASHES , bInformFilling );
#endif
  
  if( n==1 && dash_list[0] == 1 ){ /* solid line */
    nOut = 0xffff;
  } 
#ifdef DASHEXACT
  else if( n==2 && dash_list[0] == 1 && dash_list[1] == 1 ){ /* dotted line */
    nOut = 0xaaaa;
  } else {
    nBitCount = dash_list[0];
    for( i=0; i<16; i++ ){
      if( !nBitCount ){ /* move on to next dash */
	nDashIndex++;
	if( nDashIndex==n ){ /* wrap */
	  nDashIndex = 0;
	}
	nBitCount = dash_list[ nDashIndex ]; 
	if( nDashIndex==0 || !(nDashIndex & 1) )
	  vOnOff = 1;
	else
	  vOnOff = 0;
      }
      nBitCount--;
      
      if( vOnOff )
	nOut |= nShift;
      nShift >>= 1;
    }
  }
#else
  nOut = 0xaaaa;
#endif
  X11LineMapping[1] = nOut;

#ifdef DEBUGXEMUL_EXIT
  FunCount_Leave( XSETDASHES , bInformFilling );
#endif

  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSetFillRule( Display* display,
	      GC gc,
	      int fill_rule )
{
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11Setup_InternalFill( Pixmap pm )
{
  DG.X11FillSource = pm;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11Fit_InternalFill( int w, int h, int invert, int xmin, int ymin )
{
  int x,y,nItemsX,nItemsY;
  int width;
  int height;
  struct BitMap *Source;
  int blitop;
  CacheEntry_p pEntry;

  width = X11DrawablesBitmaps[X11DrawablesMap[DG.X11FillSource]].width;
  height = X11DrawablesBitmaps[X11DrawablesMap[DG.X11FillSource]].height;

  w += xmin % (width-1);
  h += ymin % (height-1);

  if( DG.oldX11FillSource==DG.X11FillSource ){
    int nNewItemsX,nNewItemsY;

    nNewItemsX = (int)((w+DG.X11FillWidth)/DG.X11FillWidth);
    nNewItemsY = (int)((h+DG.X11FillHeight)/DG.X11FillHeight);
    
    if( nNewItemsX*DG.X11FillWidth<=DG.X11FillX 
        && nNewItemsY*DG.X11FillHeight<=DG.X11FillY )
      return;
  }
#if 1
  if( (pEntry = ImageCache_Find( w,h,DG.X11FillSource, DG.X11FillX,DG.X11FillY )) ){
    if( DG.X11UnCached )
      free_bitmap( DG.X11FillBitMap );
    DG.X11UnCached = FALSE;
    DG.X11FillX = pEntry->vFillX;
    DG.X11FillY = pEntry->vFillY;
    DG.X11FillWidth = pEntry->vFillWidth;
    DG.X11FillHeight = pEntry->vFillHeight;
    DG.X11FillDepth = pEntry->vFillDepth;
    DG.X11FillBitMap = pEntry->pData;

    init_backfillrp(DG.X11FillX,DG.X11FillY,/*DG.nDisplayDepth*/DG.X11FillDepth);
    DG.oldX11FillSource = DG.X11FillSource;

    return;
  }
#endif
  Source = X11DrawablesBitmaps[X11DrawablesMap[DG.X11FillSource]].pBitMap;

  if( !Source ){
    printf("Use of illegal bitmap %d (%dx%d)\n",DG.X11FillSource,width,height);
    exit( -1 );
  }

#if (DEBUG!=0)
  if(show) showbitmap(Source,width,height,0,0);
#endif

  nItemsX = (int)((w+2*width)/width);
  nItemsY = (int)((h+2*height)/height);

  if( nItemsX==1 ) nItemsX++;
  if( nItemsY==1 ) nItemsY++;

  DG.X11FillDepth = X11DrawablesBitmaps[X11DrawablesMap[DG.X11FillSource]].depth;
  DG.X11FillX = (nItemsX)*width;
  DG.X11FillY = (nItemsY)*height;

  /* need to expand the source pattern */

  if( DG.X11UnCached ){
    free_bitmap( DG.X11FillBitMap );
  }
  DG.oldX11FillSource = DG.X11FillSource;
  DG.X11FillBitMap =
    alloc_bitmap((nItemsX)*width,(nItemsY)*height,
		 DG.X11FillDepth,BMF_CLEAR,DG.wb->RastPort.BitMap); /* |BMF_INTERLEAVED */

  DG.X11UnCached = FALSE;
  
  init_backfillrp(DG.X11FillX,DG.X11FillY,/*DG.nDisplayDepth*/DG.X11FillDepth );

  if( DG.XAllocFailed )
    return;
  
  DG.X11FillWidth = width;
  DG.X11FillHeight = height;

  WaitBlit();
  blitop = 0xc0;
#if 0
  blitop = 0x33;
#endif

  for( y=0; y<nItemsY; y++ )
    for( x=0; x<nItemsX; x++ ){
      BltBitMap(Source,0,0,DG.X11FillBitMap,x*width,y*height,width,height,blitop /*(ABC|ABNC|ANBC)*/,0xff,NULL);
    }

#if 1
  if ( !ImageCache_Insert(DG.X11FillSource,DG.X11FillX,DG.X11FillY,DG.X11FillDepth,DG.X11FillWidth,DG.X11FillHeight,DG.X11FillBitMap) )
    DG.X11UnCached = TRUE;
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
init_backfillrp( int width, int height, int depth )
{
  int i;

  DG.vLastFill = 0;

  if( fillmaskrp.BitMap ){
    free_bitmap( fillmaskrp.BitMap );
    free_bitmap( backfillrp2.BitMap );
  } else {
    InitRastPort( &fillmaskrp );
    InitRastPort( &backfillrp2 );
  }

  fillmaskrp.BitMap = alloc_bitmap(width,height,1,BMF_CLEAR,DG.wb->RastPort.BitMap);
  backfillrp2.BitMap = alloc_bitmap(width,height,depth,BMF_CLEAR,DG.wb->RastPort.BitMap);

  fillmaskrp.Layer = NULL;
  backfillrp2.Layer = NULL;

  if( XBackUserData )
    exit_area( NULL, XBackUserData );
  if( XBack2UserData )
    exit_area( NULL, XBack2UserData );
  XBackUserData = init_area(NULL,200,width,height);
  
  fillmaskrp.TmpRas = &(XBackUserData->win_tmpras);
  fillmaskrp.AreaInfo = &(XBackUserData->win_AIstruct);

  XBack2UserData = init_area(NULL,200,width,height);

  backfillrp2.TmpRas = &( XBack2UserData->win_tmpras);
  backfillrp2.AreaInfo = &( XBack2UserData->win_AIstruct);
}
