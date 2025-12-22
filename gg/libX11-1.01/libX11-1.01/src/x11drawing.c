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
     drawing
   PURPOSE
     add some drawing funcs to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 22, 1994: Created.

6. Nov 96: Found a bug in the clipping code that caused lines that
           crossed top/bottom borders with a delta x of 1 to use
	   a point outside the clipping area.
	   Fixed XDrawArc code to behave properly when clipping is
	   involved.
	   Found incorrect setup of tmpras structure that could cause
	   some nasty sideeffects..

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
11. Nov 96: Line crossing didn't check for parallell lines.
            Lines with matching start and end point gave odd results.
12. Now 96: polygons of two points don't draw too well..
25. Nov 96: Added clip_x_origin/clip_y_origin to XFillRectangle as tgif
            uses text as a fill pattern..
***/

#include "amiga.h"

#include <time.h>
#include <math.h>

#include "libX11.h"

#include <X11/Xlibint.h>

#include "x11display.h"
#include "x11drawing.h"

/*******************************************************************************************/
/* externals */

extern int X11FunctionMapping[];
extern UWORD X11LineMapping[];

#define M_PI      3.14159265358979323846
#define rad(x) ((double)(x)*M_PI/180)
/*******************************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
extern int bInformDrawing; /* ignore outputting information about events */
extern int bSkipDrawing;
#endif

/*******************************************************************************************/

void X11Setup_Tile( GC gc, int tile );

__inline void
polygon_draw( struct RastPort *drp,
	      XPoint *aPoints,
	      int nPoints,
	      int xmin,
	      int ymin );


__inline int
clipper ( int* x1,
	  int* y1,
	  int* x2,
	  int* y2 );

/*******************************************************************************************/
/* globals */

static XPoint xp[4]; /* last point set when drawing wide lines, used to make round/bevel joints */

/*******************************************************************************************/

/*#define TEST 1*/

#ifdef TEST
int bMoved = 0;

int X_AreaMove( struct RastPort *pRp, int x, int y );
int X_AreaDraw( struct RastPort *pRp, int x, int y );
int X_AreaEnd( struct RastPort *pRp );

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
X_AreaMove( struct RastPort *pRp, int x, int y )
{
  if( !pRp->TmpRas ){
    printf("Failed on TmpRas\n");
    exit(-1);
  }
  if( !pRp->AreaInfo ){
    printf("Failed on AreaInfo\n");
    exit(-1);
  }
  bMoved = 1;
  return AreaMove(pRp,x,y);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
X_AreaDraw( struct RastPort *pRp, int x, int y )
{
  if( !pRp->TmpRas ){
    printf("Failed on TmpRas\n");
    exit(-1);
  }
  if( !pRp->AreaInfo ){
    printf("Failed on AreaInfo\n");
    exit(-1);
  }
  if( !bMoved ){
    printf("No move before AreaDraw!\n");
    exit(-1);
  }
  return AreaDraw(pRp,x,y);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
X_AreaEnd( struct RastPort *pRp )
{
  if( !pRp->TmpRas ){
    printf("Failed on TmpRas\n");
    exit(-1);
  }
  if( !pRp->AreaInfo ){
    printf("Failed on AreaInfo\n");
    exit(-1);
  }
  if( !bMoved ){
    printf("No move before AreaEnd!\n");
    exit(-1);
  }
  bMoved = 0;
  return AreaEnd(pRp);
}
#else
#define X_AreaMove AreaMove
#define X_AreaDraw AreaDraw
#define X_AreaEnd AreaEnd
#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int X11FunctionMapping[]={
  JAM1,/* GXclear		 0 */
  JAM1,/* GXand		 src AND dst */
  JAM1,/* GXandReverse	 src AND NOT dst */
  JAM1,/* GXcopy		 src */
  JAM1,/* GXandInverted	 NOT src AND dst */
  JAM1,/* GXnoop		 dst */
  COMPLEMENT, /* GXxor		 src XOR dst */
  JAM1,/* GXor		 src OR dst */
  JAM1,/* GXnor		 NOT src AND NOT dst */
  JAM1,/* GXequiv		 NOT src XOR dst */
  COMPLEMENT, /* GXinvert	         NOT dst */
  JAM1,/* GXorRevers          src OR NOT dst */
  JAM1,/* GXcopyInverted	 NOT src */
  JAM1,/* GXorInverted        NOT src OR dst */
  JAM1,/* GXnand		 NOT src OR NOT dst */
  JAM1,/* GXset		 1 */
};

UWORD X11LineMapping[]={
  0xffff,
  0xaaaa,
  0xff00,
};

void
setup_gc( GC gc )
{
  int   FillStyle = gc->values.fill_style&0xff;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( GCCONTEXTSWAP, 0 );
#endif

  if( FillStyle ){
    int FillOp = gc->values.fill_style &0xff00;

    if( FillOp==NORMAL_FILL ){
      X11Setup_Tile(gc,gc->values.tile);
      XSetTile(NULL,gc,gc->values.tile);
      SetAfPt(DG.drp,DG.Xcurrent_tile,DG.Xtile_size);
      DG.X11InternalFill = 0;
    } else {
      SetAfPt(DG.drp,0,0);
      X11Setup_InternalFill(gc->values.tile);
      DG.X11InternalFill = 1;
    }
  } else {
    SetAfPt(DG.drp,0,0);
    DG.X11InternalFill = 0;
  }

  SetDrPt(DG.drp,X11LineMapping[gc->values.line_style]);

  SetABPenDrMd( DG.drp, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function] );

  vPrevGC = gc;
}

#if 0
void
setup_drawgc( GC gc )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( GCCONTEXTDRAWSWAP, 0 );
#endif

  SetDrPt(DG.drp,X11LineMapping[gc->values.line_style]);

  SetABPenDrMd( DG.drp, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function] );

  vPrevGC = (GC)-1;
}
#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void 
polygon_findminmax( XPoint *aPoints,
		    int nPoints,
		    int *xmin,
		    int *xmax,
		    int *ymin,
		    int *ymax )
{
  register int i;
  
  *xmin = *xmax = aPoints[0].x;
  *ymin = *ymax = aPoints[0].y;
  for( i=1; i<nPoints; i++ ){
    if(aPoints[i].x<*xmin) *xmin = aPoints[i].x;
    else if(aPoints[i].x>*xmax) *xmax = aPoints[i].x;
    if(aPoints[i].y<*ymin) *ymin = aPoints[i].y;
    else if(aPoints[i].y>*ymax) *ymax = aPoints[i].y;
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
X11ClearPattern( Window win,
		int x,
		int y,
		int w,
		int h,
		int background )
{
  SetDrPt(DG.drp,0xFFFF);
  SetABPenDrMd( DG.drp, background, X11DrawablesBackground[win], JAM1);
  WaitBlit();

  w = ((w+15)/16)*16;
  BltPattern(DG.drp,fillmaskrp.BitMap->Planes[0],DG.vWinX+x,DG.vWinY+y,DG.vWinX+x+w,DG.vWinY+y+h,fillmaskrp.BitMap->BytesPerRow);
  SetDrPt(DG.drp,X11LineMapping[vPrevGC->values.line_style]);
  SetABPenDrMd( DG.drp, vPrevGC->values.foreground, vPrevGC->values.background, X11FunctionMapping[vPrevGC->values.function] );

}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11init_drawing( void )
{
  DG.vMaxPointBuffer = 100;
  DG.vMaxEntries = 100;
  DG.aPoints = malloc(DG.vMaxEntries*sizeof(XPoint));
  DG.X11PointBuffer = malloc(DG.vMaxPointBuffer*sizeof(XPoint));
  if( !DG.aPoints||!DG.X11PointBuffer ) X11resource_exit(DRAWING1);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XPoint *
X11Expand_Points( XPoint *aPoints, int n )
{
  free(aPoints);
  aPoints = malloc((n+50)*sizeof(XPoint));
  DG.vMaxEntries = n+50;
  if( !aPoints ) X11resource_exit(DRAWING2);

  return aPoints;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11exit_drawing( void )
{
  free(DG.aPoints);
  free(DG.X11PointBuffer);
}

/********************************************************************************
Name     : XDrawArc()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XDrawArc( Display* d,
	  Drawable win,
	  GC gc,
	  int x,
	  int y,
	  unsigned int xw,
	  unsigned int xh,
	  int v1,
	  int v2 )
{
  float px0,py0,fx,fy,px1,py1;
  int w = xw;
  int h = xh;
  register int n;
  int p = 0;
  boolean simple = True;
  int type = Polygon_Open;
#ifndef DOCLIPPING
  int np;
#endif
  int error;
#if 0
  int vFirstX,vFirstY;
#endif

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  FunCount_Enter( XDRAWARC , bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( h<2 ) h = 2;
  if( w<2 ) w = 2;

  v1 = v1>>6;
  v2 = v2>>6;

  if( v1==0 && v2==360 ) type=Polygon_Closed;
  if( v1!=0 || v2!=360 ) simple=False;
  if( x-gc->values.line_width<0
      || y-gc->values.line_width<0 
      || x+w+gc->values.line_width>DG.vWinWidth 
      || y+h+gc->values.line_width>DG.vWinHeight ){
    type = Polygon_Open;
    simple = False;
  }
  if( simple ){
    if( gc->values.line_width<2 )
      DrawEllipse(DG.drp,DG.vWinX+((w>>1)+x),DG.vWinY+((h>>1)+y),(w>>1),(h>>1));
    else {
      if( X11FillCheck(400,w+gc->values.line_width*2,h+gc->values.line_width*2) ) 
	DG.drp=setup_win(win);
      error=AreaEllipse(DG.drp,DG.vWinX+(w>>1)+x,DG.vWinY+(h>>1)+y,
			(w>>1)+(gc->values.line_width>>1),(h>>1)+(gc->values.line_width>>1));
      if( error==-1 ) return 0;
      if( ((int)(w>>1)-(gc->values.line_width>>1)) >0 &&
	 ((int)(h>>1)-(gc->values.line_width>>1)) >0 )
	error=AreaEllipse(DG.drp,DG.vWinX+(w>>1)+x,DG.vWinY+(h>>1)+y,
			  (w>>1)-(gc->values.line_width>>1),(h>>1)-(gc->values.line_width>>1));
      if( error==-1 ) return 0;
      AreaEnd(DG.drp);
    }
    return;
  }

  px0 = cos(rad(-(v1+v2)))*(w>>1);
  py0 = sin(rad(-(v1+v2)))*(h>>1);
  fx = cos(rad(-5));
  fy = sin(rad(-5));
  if( DG.vMaxEntries<400 )
    DG.aPoints = X11Expand_Points(DG.aPoints,400);

  if( gc->values.line_width<2 ){
    DG.aPoints[p].x = (int)(x+(w>>1)+px0);
    DG.aPoints[p++].y = (int)((h>>1)+y+py0*h/w);

    assert((int)(v2/5)<DG.vMaxEntries);

    for( n=0; n<(int)(v2/5); n++ ){
      px1 = fx*px0+fy*py0;
      py1 = fx*py0-fy*px0;
      DG.aPoints[p].x = (short)((w>>1)+x+px1);
      DG.aPoints[p++].y = (short)((h>>1)+y+py1*h/w);
      px0 = px1;
      py0 = py1;
    }
#ifdef DOCLIPPING
    polygon_draw(DG.drp,DG.aPoints,p,DG.vWinX,DG.vWinY);
#else
    polygon_clip(p,DG.aPoints,0,type,&np,1,1);
    if( np>1 )
      polygon_draw(DG.drp,DG.X11PointBuffer,np,0 /*DG.vWinX*/,0 /*DG.vWinY*/);
#endif
  } else /* wide lines */ { 
    int k = 0;
    int oldp;
#if 0
    float f;
#endif
    float fPointsX[200];
    float fPointsY[200];

    float vScaleUp = 1.0+(float)(gc->values.line_width/2)/h;
    float vScaleDown = 1.0-(float)(gc->values.line_width/2)/h;

    fPointsX[p] = px0;
    fPointsY[p++] = py0*h/w;

    assert((int)(v2/5)<DG.vMaxEntries);

    for( n=0; n<(int)(v2/5); n++ ){
      px1 = fx*px0+fy*py0;
      py1 = fx*py0-fy*px0;
      fPointsX[p] = px1;
      fPointsY[p++] = py1*h/w;
      px0 = px1;
      py0 = py1;
    }

    oldp = p;

    if( ((int)w-(int)gc->values.line_width)>0 ){
      if( X11FillCheck(400,w+gc->values.line_width*2,h+gc->values.line_width*2) ){
	DG.drp = setup_win(win);
      }
    }

    for( k=0; k<oldp; k++ ){
      DG.aPoints[oldp*2-1-k].x = (w>>1)+x+fPointsX[k]*vScaleDown;
      DG.aPoints[oldp*2-1-k].y = (h>>1)+y+fPointsY[k]*vScaleDown;
      p++;
      DG.aPoints[k].x = (w>>1)+x+fPointsX[k]*vScaleUp;
      DG.aPoints[k].y = (h>>1)+y+fPointsY[k]*vScaleUp; 
    }

#if 0
    f=(float)((int)h+(gc->values.line_width>>1)*h/w)/((int)w+(gc->values.line_width>>1));
    px0 = cos(rad(-(v1+v2)))*((int)(w>>1)+(gc->values.line_width>>1));
    py0 = sin(rad(-(v1+v2)))*((int)(h>>1)+(gc->values.line_width>>1));
    DG.aPoints[p].x = (int)(x+(w>>1)+px0); 
    DG.aPoints[p++].y = (int)(y+(h>>1)+py0*f); 
    vFirstX = DG.aPoints[0].x;
    vFirstY = DG.aPoints[0].y;
    for( n=0; n<(int)(v2/5); n++ ){
      px1 = fx*px0+fy*py0;
      py1 = fx*py0-fy*px0;
      DG.aPoints[p].x = (short)((w>>1)+x+px1); 
      DG.aPoints[p++].y = (short)((h>>1)+y+(int)(py1*f));
      px0 = px1;
      py0 = py1;
    }
#endif
    
    if( ((int)w-(int)gc->values.line_width)>0 ){
#if 0
      int n;
      float f;
#endif

#if 0
#ifdef DOCLIPPING
#ifdef TEST
      polygon_draw(DG.drp,DG.aPoints,p,DG.vWinX,DG.vWinY);
#else
      X_AreaMove(DG.drp,DG.vWinX+DG.aPoints[0].x,DG.vWinY+DG.aPoints[0].y);
      for( n=1; n<p; n++ ){
	X_AreaDraw(DG.drp,DG.vWinX+DG.aPoints[n].x,DG.vWinY+DG.aPoints[n].y);
      }
#endif
#endif
      fx = cos(rad(5));
      fy = sin(rad(5));
      f=(float)((int)h-(gc->values.line_width>>1)*h/w)/((int)w-(gc->values.line_width>>1));
      px0 = cos(rad(-(v1)))*((int)(w>>1)-(gc->values.line_width>>1));
      py0 = sin(rad(-(v1)))*((int)(h>>1)-(gc->values.line_width>>1));
      DG.aPoints[p].x = (int)(x+(w>>1)+px0);
      DG.aPoints[p++].y = (int)(y+(h>>1)+py0*f);

      assert((int)(v2/5)<200);

      for( n=0; n<(int)(v2/5); n++ ){
	px1 = fx*px0+fy*py0;
	py1 = fx*py0-fy*px0;
	DG.aPoints[p].x = (short)((w>>1)+x+px1);
        DG.aPoints[p++].y = (short)((h>>1)+y+(int)(py1*f));
	px0 = px1;
	py0 = py1;
      }
      DG.aPoints[p].x = vFirstX;
      DG.aPoints[p++].y = vFirstY;
#endif
    } else {
      DG.aPoints[p].x = x+(w>>1);
      DG.aPoints[p++].y = y+(w>>1);
      X_AreaMove(DG.drp,DG.vWinX+DG.aPoints[0].x,DG.vWinY+DG.aPoints[0].y);
    }

    assert(p<DG.vMaxEntries);
#ifdef DOCLIPPING
#ifdef TEST
    polygon_draw(DG.drp,DG.aPoints,p,DG.vWinX,DG.vWinY);
#else
    for( n=1; n<p; n++ ){
      X_AreaDraw(DG.drp,DG.vWinX+DG.aPoints[n].x,DG.vWinY+DG.aPoints[n].y);
    }
    X_AreaEnd(DG.drp);
#endif
#else
#ifdef TEST
    polygon_clip(p,DG.aPoints,1,Polygon_Closed,&p,0,1);
    if( !p ){
      return;
    }
    polygon_draw(DG.drp,DG.X11PointBuffer /*DG.aPoints*/,p,DG.vWinX,DG.vWinY);
#else
    polygon_clip(p,DG.aPoints,1,Polygon_Closed,&p,0,1);
    if( !p ){
      return;
    }
    X_AreaMove(DG.drp,/*DG.vWinX+*/DG.X11PointBuffer[0].x,/*DG.vWinY+*/DG.X11PointBuffer[0].y);
    for( n=1; n<p; n++ ){
      if( X_AreaDraw(DG.drp,/*DG.vWinX+*/DG.X11PointBuffer[n].x,/*DG.vWinY+*/DG.X11PointBuffer[n].y)==-1 ){ 
	return 0;
      }
    }
    X_AreaEnd(DG.drp);
#endif
#endif
  }
}
     

/********************************************************************************
Name     : XDrawArcs()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XDrawArcs( Display* display,
	   Drawable drawable,
	   GC gc,
	   XArc* arcs,
	   int narcs )
{
  int i;

  for( i=0; i<narcs; i++ )
    XDrawArc(display,drawable,gc,arcs[i].x,arcs[i].y,arcs[i].width,arcs[i].height,arcs[i].angle1,arcs[i].angle2);
}

/********************************************************************************
Name     : XFillArc()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XFillArc( Display* d,
	  Drawable win,
	  GC gc,
	  int x,
	  int y,
	  unsigned int xwidth,
	  unsigned int xheight,
	  int v1,
	  int v2 )
{
  float px0,py0,fx,fy,px1,py1;
  int width = xwidth;
  int height = xheight;
  register int n;
  int p = 0;
  boolean simple = True;
  int vXOff = 0;
  int vYOff = 0;
  long blitop = 0xe0;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  FunCount_Enter(  XFILLARC, bInformDrawing );
#endif

  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( height<2 )
    height = 2;
  if( width<2 )
    width = 2;

  if( X11FillCheck(400,width,height) )
    DG.drp = setup_win(win);

  v1 = v1>>6;
  v2 = v2>>6;
  if( v1!=0 || v2!=360 )
    simple = False;
  if( x<0 || y<0 || x+width>DG.vWinWidth || y+height>DG.vWinHeight )
    simple = False;

  if( simple ){
    if( DG.X11InternalFill ){
      int vPatternWidth = width;

      if( vPatternWidth%16 )
	vPatternWidth+=16-(vPatternWidth%16);
      {
	int invert = 0;
	if( gc->values.foreground == X11DrawablesBackground[win] )
	  invert = 1;
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFilling )
    return;
#endif
	X11Fit_InternalFill(vPatternWidth,height,invert, 0 /*x*/, 0 /*y*/);
      }
#if (DEBUG!=0)
    if(show) showbitmap(DG.X11FillBitMap,width,height,0,0);
#endif
      if( DG.vLastFill!=ARC || DG.vLastFillW!=(width>>1) || DG.vLastFillH!=(height>>1) ){
	SetAfPt(&fillmaskrp,0,0);
	SetABPenDrMd( DG.drp, 1, X11DrawablesBackground[win], JAM1);
	AreaEllipse(&fillmaskrp,(width>>1),(height>>1),(width>>1),(height>>1));
	AreaEnd(&fillmaskrp);
	DG.vLastFill = ARC;
	DG.vLastFillW = (width>>1);
	DG.vLastFillH = (height>>1);
      }
#if (DEBUG!=0)
    if(show) showbitmap(fillmaskrp.BitMap,width,height,1,0);
#endif
#if 0
      X11ClearPattern(win,x,y,vPatternWidth,height,gc->values.background);
#endif
      vPrevGC = (GC)-1;
      WaitBlit();
      BltMaskBitMapRastPort(DG.X11FillBitMap,0,0,&backfillrp2,0,0,width,height,
			    blitop,fillmaskrp.BitMap->Planes[0]);
      WaitBlit();
#if (DEBUG!=0)
      if(show) showbitmap(backfillrp2.BitMap,width,height,2,0);
#endif
#if 1
      SetABPenDrMd( DG.drp, gc->values.background, 0, JAM1);
      BltTemplate(fillmaskrp.BitMap->Planes[0],0,fillmaskrp.BitMap->BytesPerRow,DG.drp,DG.vWinX+x,DG.vWinY+y,width,height);
#endif
#if 0
      if( gc->values.function==GXinvert || gc->values.function==GXxor )
	SetDrMd(DG.drp,COMPLEMENT);
      else
	SetDrMd(DG.drp,JAM1);
#else
      SetABPenDrMd( DG.drp, gc->values.foreground, X11DrawablesBackground[win], X11FunctionMapping[gc->values.function]);
#endif
      BltTemplate(backfillrp2.BitMap->Planes[0],0,backfillrp2.BitMap->BytesPerRow,DG.drp,DG.vWinX+x,DG.vWinY+y,width,height);
      /* BltPattern(DG.drp,backfillrp2.BitMap->Planes[0],DG.vWinX+x,DG.vWinY+y,DG.vWinX+x+vPatternWidth,DG.vWinY+y+height,backfillrp2.BitMap->BytesPerRow); */
      /* WaitBlit(); */
      return;
    }
    AreaEllipse(DG.drp,DG.vWinX+x+(width>>1),DG.vWinY+y+(height>>1),(width>>1),(height>>1));
    AreaEnd(DG.drp);

    return;
  }

  px0 = cos(rad(-(v1+v2)))*(width>>1);
  py0 = sin(rad(-(v1+v2)))*(height>>1);
  fx = cos(rad(-5));
  fy = sin(rad(-5));
  if( gc->values.arc_mode==ArcPieSlice ){
    DG.aPoints[p].x = (int)(x+(width>>1));
    DG.aPoints[p++].y = (int)(y+(height>>1));
  }
  DG.aPoints[p].x = (int)(x+(width>>1)+px0);
  DG.aPoints[p++].y = (int)(y+(height>>1)+py0);
  for( n=0; n<(int)(v2/5); n++ ){
    px1 = fx*px0+fy*py0;
    py1 = fx*py0-fy*px0;

    DG.aPoints[p].x = (short)(x+(width>>1)+px1);
    DG.aPoints[p++].y = (short)(y+(height>>1)+py1*height/width);
    px0 = px1;
    py0 = py1;
  }
  DG.aPoints[p].x = (int)(x+(width>>1));
  DG.aPoints[p++].y = (int)(y+(height>>1));
  {
    int np;

    polygon_clip(p,DG.aPoints,1,Polygon_Closed,&np,1,1);
    if( !np ){
      return;
    }
    vXOff = -DG.vWinX;
    vYOff = -DG.vWinY;

    if( DG.X11InternalFill ){
      int xmin,xmax,ymin,ymax;

      polygon_findminmax(DG.X11PointBuffer,np,&xmin,&xmax,&ymin,&ymax);
#if 0
      xmin -= DG.vWinX;
      xmax -= DG.vWinX;
      ymin -= DG.vWinY;
      ymax -= DG.vWinY;
#endif
      if( !(xmax-xmin) || !(ymax-ymin) ){
	return;
      }
#if 0
      if( (xmax-xmin)%16 ){
	xmax += 16-(xmax-xmin)%16;
      }
#endif
      {
	int invert = 0;
	if( gc->values.foreground == X11DrawablesBackground[win] )
	  invert = 1;
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFilling )
    return;
#endif
	X11Fit_InternalFill(xmax-xmin,ymax-ymin,invert, 0 /*xmin*/, 0 /*ymin*/);
      }
#if (DEBUG!=0)
    if(show) showbitmap(DG.X11FillBitMap,DG.X11FillX,DG.X11FillY,0,0);
#endif
      SetRast( &fillmaskrp, 0 );
      SetAfPt(&fillmaskrp,0,0);
      SetABPenDrMd( &fillmaskrp, 1, X11DrawablesBackground[win], JAM1);

      X11FillPolygon(&fillmaskrp,DG.X11PointBuffer,np,xmin,ymin,0,0,1);
      DG.vLastFill = -1;
#if (DEBUG!=0)
      if(show) showbitmap(fillmaskrp.BitMap,xmax-xmin,ymax-ymin,1,0);
#endif
      /* X11ClearPattern(win,xmin,ymin,xmax-xmin,ymax-ymin,gc->values.background); */
      vPrevGC = (GC)-1;
      SetRast( &backfillrp2, (UBYTE)0 );
      WaitBlit();
#if (DEBUG!=0)
      if(show) showbitmap(backfillrp2.BitMap,xmax-xmin,ymax-ymin,0,0);
#endif
      BltMaskBitMapRastPort(DG.X11FillBitMap,0,0,&backfillrp2,0,0,xmax-xmin,ymax-ymin,
			    blitop,fillmaskrp.BitMap->Planes[0]);
#if (DEBUG!=0)
      if(show) showbitmap(backfillrp2.BitMap,xmax-xmin,ymax-ymin,0,0);
#endif
      SetABPenDrMd( DG.drp, gc->values.background, 0, JAM1);
      BltTemplate(fillmaskrp.BitMap->Planes[0],0,fillmaskrp.BitMap->BytesPerRow,DG.drp,DG.vWinX+xmin+vXOff,DG.vWinY+ymin+vYOff,xmax-xmin,ymax-ymin);

      SetABPenDrMd( DG.drp, gc->values.foreground, X11DrawablesBackground[win], X11FunctionMapping[gc->values.function]  /*JAM2*/);
      /* SetDrMd(DG.drp,X11FunctionMapping[gc->values.function]); */
      WaitBlit();
      BltTemplate(backfillrp2.BitMap->Planes[0],0,backfillrp2.BitMap->BytesPerRow,DG.drp,DG.vWinX+xmin+vXOff,DG.vWinY+ymin+vYOff,xmax-xmin,ymax-ymin);
      /* BltPattern(DG.drp,backfillrp2.BitMap->Planes[0],DG.vWinX+xmin,DG.vWinY+ymin,DG.vWinX+xmax,DG.vWinY+ymax,fillmaskrp.BitMap->BytesPerRow); */
    } else
      if( np ) X11FillPolygon(DG.drp,DG.X11PointBuffer,np,vXOff,vYOff,0,0,0);
    vPrevGC = (GC)-1;
  }
}

/********************************************************************************
Name     : XFillArcs() 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XFillArcs( Display* display,
	   Drawable drawable,
	   GC gc,
	   XArc *arcs,
	   int narcs )
{
  int i;

  for( i=0; i<narcs; i++ )
    XFillArc(display,drawable,gc,arcs[i].x,arcs[i].y,arcs[i].width,arcs[i].height,arcs[i].angle1,arcs[i].angle2);
}

/********************************************************************************
Name     : XDrawPoint()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XDrawPoint( Display *d,
	    Drawable win,
	    GC gc,
	    int x1,
	    int y1 )
{
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  FunCount_Enter( XDRAWPOINT, bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

#if 0
  if( x1<0 || y1<0 || x1>DG.vWinWidth || y1>DG.vWinHeight ) return;
#endif

  WritePixel(DG.drp,DG.vWinX+x1,DG.vWinY+y1);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
MakeBevel( XPoint *xp1, XPoint *xp2 )
{
  xp1[0].x = xp1[3].x;
  xp1[0].y = xp1[3].y;
  xp1[1].x = xp1[2].x;
  xp1[1].y = xp1[2].y;
  xp1[2].x = xp2[1].x;
  xp1[2].y = xp2[1].y;
  xp1[3].x = xp2[0].x;
  xp1[3].y = xp2[0].y;
}

#define distance(x1,y1,x2,y2) (sqrt((double)(y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)))

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

boolean
GetCrossing( XPoint p1,
	     XPoint p2,
	     XPoint p3,
	     XPoint p4,
	     XPoint* pRet )
{
  float d1,d2;
  float ycross1,ycross2;

  assert(pRet);

  if( abs(p2.x-p1.x)>1 ){
    d1 = (float)(p2.y-p1.y)/(p2.x-p1.x);
    ycross1 = p1.y-p1.x*d1;
    if( (p4.x-p3.x) ){
      float vX;

      d2 = (float)(p4.y-p3.y)/(p4.x-p3.x);
      ycross2 = p3.y-p3.x*d2;
      if( d1-d2 ){
	vX = (ycross2-ycross1)/(d1-d2);
	pRet->x = (int)vX;
	pRet->y = (int)(d1*vX+ycross1);
      } else {
	/* can't cross! */
	return FALSE;
      }
    } else {
      pRet->x = p4.x;
      pRet->y = d1*p4.x+ycross1;
    }
  } else {
    if( (p4.x-p3.x) ){
      d2 = (float)(p4.y-p3.y)/(p4.x-p3.x);
      ycross2 = p3.y-p3.x*d2;
      pRet->x = p2.x;
      pRet->y = d2*p2.x+ycross2;
    } else {
      pRet->x = p1.x;
      pRet->y = p1.y;

      if( !(p2.x-p1.x) ){
	/* can't cross! */
	return FALSE;
      }

    }
  }
  return TRUE;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
/*
boolean
MakeMiter( Display *d,
	   Drawable win,
	   GC gc,
	   XPoint *xp1,
	   XPoint *xp2 )
{
  int p1 = 0,p2 = 3;
  XPoint p;

  if( distance(xp1[1].x,xp1[1].y,xp2[2].x,xp2[2].y)>
      distance(xp1[0].x,xp1[0].y,xp2[3].x,xp2[3].y) ) {
       p1 = 2; p2 = 1;
     }

  if( !GetCrossing(xp1[p1],xp1[p2],xp2[p1],xp2[p2],&p) )
    return FALSE;

  if( p2==3 ){
    xp1[0].x = xp1[3].x; xp1[0].y = xp1[3].y;
    xp1[1].x = xp1[2].x; xp1[1].y = xp1[2].y;
    xp1[2].x = xp2[0].x; xp1[2].y = xp2[0].y;
    xp1[3].x = p.x;   xp1[3].y = p.y;
  } else {
    xp1[0].x = xp1[2].x; xp1[0].y = xp1[2].y;
    xp1[1].x = p.x;   xp1[1].y = p.y;
    xp1[2].x = xp2[1].x; xp1[2].y = xp2[1].y;
    xp1[3].x = xp1[3].x; xp1[3].y = xp1[3].y;
  }

  return TRUE;
}
*/
/********************************************************************************
Name     : XDrawLine() 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#if (DEBUG!=0)
int bSkipDrawLine = 0;
#endif

XDrawLine( Display  *d,
	   Drawable win,
	   GC gc,
	   int x1,
	   int y1,
	   int x2,
	   int y2 )
{
  float fx,fy,px1,py1;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawLine )
    return;
  FunCount_Enter( XDRAWLINE, bInformDrawing );
#endif
  if( x1==x2 && y1==y2 )
    return BadRequest;
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return BadRequest;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( gc->values.line_width<2 ){
#if 0
    int p = 0;
    int np;

    DG.aPoints[p].x = x1;
    DG.aPoints[p++].y = y1;
    DG.aPoints[p].x = x2;
    DG.aPoints[p++].y = y2;
    polygon_clip(p,DG.aPoints,0,Polygon_Open,&np,1,1);
    if( np>1 ){
      polygon_draw(DG.drp,DG.X11PointBuffer,np,DG.vWinX,DG.vWinY);
    }
#else
    int 
      sx1 = x1,
      sy1 = y1,
      sx2 = x2,
      sy2 = y2;

    if( clipper(&sx1,&sy1,&sx2,&sy2) ){
      Move(DG.drp,DG.vWinX+sx1,DG.vWinY+sy1);
      Draw(DG.drp,DG.vWinX+sx2,DG.vWinY+sy2);
    }
#endif
  } else {
    float vRad;
    int vHalfWidth = (int)(gc->values.line_width/2);

    vRad = distance(x1,y1,x2,y2);;
    fx = (y2-y1)/vRad;
    fy = (x2-x1)/vRad;
    px1 = fx*vHalfWidth;
    py1 = -fy*vHalfWidth;
    xp[0].x = x1+px1;
    xp[0].y = y1+py1;
    xp[1].x = x1-px1;
    xp[1].y = y1-py1;
    xp[2].x = x2-px1;
    xp[2].y = y2-py1;
    xp[3].x = x2+px1;
    xp[3].y = y2+py1;
#ifdef TEST
    polygon_draw(DG.drp,xp,4,DG.vWinX,DG.vWinY);
#else
    XFillPolygon(d,win,gc,xp,4,0,0);
#endif
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XDRAWLINE, bInformDrawing );
#endif 

  return Success;
}

/********************************************************************************
Name     : XDrawLines()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
static bSkipXDrawLines=0;
#endif

XDrawLines( Display *d,
	    Drawable win,
	    GC gc,
	    XPoint array[],
	    int entries,
	    int mode )
{
  int i;
  int p=0;
  int np;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  if( bSkipXDrawLines ){
    return;
  }
  FunCount_Enter( XDRAWLINES, bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( mode==CoordModeOrigin ){
    if( entries>DG.vMaxEntries ){
      DG.aPoints = X11Expand_Points(DG.aPoints,entries);
    }
    if( gc->values.line_width<2 ){
#if 0
      polygon_clip(entries,array,0,Polygon_Open,&np,1,1);
      if( np>1 )
#if 1
	polygon_draw(DG.drp,DG.X11PointBuffer,np,0 /*DG.vWinX*/,0 /*DG.vWinY*/);
#else
      PolyDraw(DG.drp,np,(WORD*)DG.X11PointBuffer);
#endif
#else
      int x1,y1,x2,y2;
      register int i;

      x1 = array[0].x;
      y1 = array[0].y;

      for( i=1; i<entries; i++ ){
	x2 = array[i].x;
	y2 = array[i].y;
	if( clipper(&x1,&y1,&x2,&y2) ){
	  Move(DG.drp,DG.vWinX+x1,DG.vWinY+y1);
	  Draw(DG.drp,DG.vWinX+x2,DG.vWinY+y2);
	} 
	x1 = array[i].x;
	y1 = array[i].y;
      }
#endif
    } else {
      XPoint xp2[4];
      XPoint xp3[4];
      boolean bFailed = FALSE;
      int vErr = 0;
      int vStart = 2;

      i  =0;
      while( XDrawLine(d,win,gc,array[i].x,array[i].y,array[i+1].x,array[i+1].y)
	     && i<entries-1 ){
	i++;
	vStart++;
      }
      if( vStart>=entries )
        return;
      memcpy(xp3,xp,sizeof(XPoint)*4);
      for( i=vStart; i<entries; i++ ){
	
	if( !vErr )
	  memcpy(xp2,xp,sizeof(XPoint)*4);
	vErr = XDrawLine(d,win,gc,array[i-1].x,array[i-1].y,array[i].x,array[i].y);
	if( bFailed || vErr ){
	  bFailed = False;
	  continue;
	}
	switch( gc->values.join_style ){
	case JoinBevel:
	  MakeBevel(xp2,xp);
	  break;
	case JoinMiter:
/*
	  if( !MakeMiter(d,win,gc,xp2,xp) ){
	    bFailed = TRUE;
	    continue;
	  }
*/
	  break;
	case JoinRound:
	  XFillArc(d,win,gc,array[i-1].x-(gc->values.line_width>>1),array[i-1].y-(gc->values.line_width>>1),gc->values.line_width,gc->values.line_width,0,360<<6);
	  break;
	default:
	  MakeBevel(xp2,xp);
	  break;
	}
	if(gc->values.join_style!=JoinRound)
	  XFillPolygon(d,win,gc,xp2,4,0,0);
      }
      if( array[0].x==array[entries-1].x
	 && array[0].y==array[entries-1].y ){ /* join endpoints */
	XPoint tmp;
	
	tmp = xp3[0];
	xp3[0] = xp3[2];
	xp3[2] = tmp;
	tmp = xp3[1];
	xp3[1] = xp3[3];
	xp3[3] = tmp;
	
	tmp = xp[0];
	xp[0] = xp[2];
	xp[2] = tmp;
	tmp = xp[1];
	xp[1] = xp[3];
	xp[3] = tmp;
	switch( gc->values.join_style ){
	case JoinBevel:
	  MakeBevel(xp3,xp);
	  break;
	case JoinMiter:
	  //MakeMiter(d,win,gc,xp3,xp);
	  break;
	case JoinRound:
	  XFillArc(d,win,gc,array[0].x-(gc->values.line_width>>1),array[0].y-(gc->values.line_width>>1),gc->values.line_width,gc->values.line_width,0,360<<6);
	  break;
	default:
	  MakeBevel(xp3,xp);
	  break;
	}
	if(gc->values.join_style!=JoinRound)
	  XFillPolygon(d,win,gc,xp3,4,0,0);
      }
    }
  } else {
    int px=array[0].x,py=array[0].y;

    if( DG.vMaxEntries<entries*2 ){
      DG.aPoints = X11Expand_Points(DG.aPoints,entries*2);
    }

    if( gc->values.line_width<2 ){
      for( i=0; i<entries-1; i++ ){
	DG.aPoints[p].x = px;
	DG.aPoints[p++].y = py;
	DG.aPoints[p].x = px+array[i+1].x;
	DG.aPoints[p++].y = py+array[i+1].y;
	px = px+array[i+1].x;
	py = py+array[i+1].y;
      }
      polygon_clip(p,DG.aPoints,0,Polygon_Open,&np,1,1);
      if( np>1 ) 
	polygon_draw(DG.drp,DG.X11PointBuffer,np,0 /*DG.vWinX*/,0/*DG.vWinY*/);
    } else {
      for( i=0; i<entries-1; i++ ){
	XDrawLine(d,win,gc,px,py,px+array[i+1].x,py+array[i+1].y);
	px = px+array[i+1].x;
	py = py+array[i+1].y;
      }
    }
  }

#ifdef DEBUGXEMUL_EXIT
  FunCount_Leave( XDRAWLINES , bInformDrawing );
#endif
  return;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline void
polygon_draw( struct RastPort *drp,
	      XPoint *aPoints,
	      int nPoints,
	      int xmin,
	      int ymin )
{
  int n;

  Move(drp,xmin+aPoints[0].x,ymin+aPoints[0].y);
  for( n=1; n<nPoints; n++ ){
    Draw(drp,xmin+aPoints[n].x,ymin+aPoints[n].y);
  }
}

/********************************************************************************
Name     : XDrawRectangle()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#if (DEBUG!=0)
int bSkipDrawRectangle = 0;
#endif

XDrawRectangle( Display* d,
	        Drawable win,
	        GC gc,
	        int x1,
	        int y1,
	        unsigned int w,
	        unsigned int h )
{
  int p = 0;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawRectangle )
    return;
  FunCount_Enter(  XDRAWRECTANGLE, bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( gc->values.line_width<2 ){
    int np;

    DG.aPoints[p].x = x1;
    DG.aPoints[p++].y = y1;
    DG.aPoints[p].x = x1;
    DG.aPoints[p++].y = y1+h;
    DG.aPoints[p].x = x1+w;
    DG.aPoints[p++].y = y1+h;
    DG.aPoints[p].x = x1+w;
    DG.aPoints[p++].y = y1;
    DG.aPoints[p].x = x1;
    DG.aPoints[p++].y = y1;
    polygon_clip(p,DG.aPoints,0,Polygon_Open,&np,1,1);
    if( np>1 )
      polygon_draw(DG.drp,DG.X11PointBuffer,np,0,0);
  } else {
    int oldjoin = gc->values.join_style;
    XPoint xp[5];

    xp[0].x = x1;
    xp[0].y = y1;
    xp[1].x = x1;
    xp[1].y = y1+h;
    xp[2].x = x1+w;
    xp[2].y = y1+h;
    xp[3].x = x1+w;
    xp[3].y = y1;
    xp[4].x = x1;
    xp[4].y = y1;

    gc->values.join_style = JoinMiter;
    XDrawLines(d,win,gc,xp,5,CoordModeOrigin);
#if 0
    XDrawLine(d,win,gc,x1,y1,x1,y1+h);
    XDrawLine(d,win,gc,x1,y1+h,x1+w,y1+h); 
    XDrawLine(d,win,gc,x1+w,y1+h,x1+w,y1);
    XDrawLine(d,win,gc,x1+w,y1,x1,y1);
#endif
    gc->values.join_style = oldjoin;
 }
  return;
}

/********************************************************************************
Name     : XDrawRectangles()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XDrawRectangles( Display* display,
		 Drawable drawable,
		 GC gc,
		 XRectangle* rectangles,
		 int nrectangles )
{
  int i;

  for( i=0; i<nrectangles; i++ )
    XDrawRectangle(display,drawable,gc,rectangles[i].x,rectangles[i].y,rectangles[i].width,rectangles[i].height);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

X11FillPolygon( struct RastPort *drp,
	        XPoint *points,
	        int nPoints,
	        int xmin,
	        int ymin, 
	        int vXOff,
	        int vYOff,
	        char black)
{
  int i;

  if( black ){
    SetAfPt(drp,0,0);
    SetABPenDrMd( drp, 1, 0, JAM1 );
  }
#if 0
/* (DEBUG!=0)*/
  {
    int n;

    printf(" ud = %d x %d drp %d %d\n",DG.Xuserdata->AWidth,DG.Xuserdata->AHeight,
	   GetBitMapAttr(drp->BitMap,BMA_WIDTH),
	   GetBitMapAttr(drp->BitMap,BMA_HEIGHT));

    for( n=0; n<nPoints; n++ ){
      printf("%d [%d %d|\n",n,points[n].x-xmin,points[n].y-ymin);
      if( points[n].x-xmin<0 || points[n].y-ymin<0 || points[n].x-xmin>DG.vWinWidth || points[n].y-ymin>DG.vWinHeight ){
	printf("major bug\n");
	X11Internal_Error(1);
      }
    }
  }
  {
    if( points[0].x==points[nPoints-1].x && points[0].y==points[nPoints-1].y ){
      X11Internal_Error(2);
    }
  }
#endif

  X_AreaMove(drp,points[0].x-xmin+vXOff,points[0].y-ymin+vYOff);
  for( i=1; i<nPoints; i++ ) 
    X_AreaDraw(drp,points[i].x-xmin+vXOff,points[i].y-ymin+vYOff);
  X_AreaEnd(drp);
}

/********************************************************************************
Name     : XGetAtomName()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

char *
XGetAtomName( Display *d, Atom a )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetAtomName\n");
#endif
  return(0);
}

int _Xdash_list[] = {0xffff,0xeeee,0xf0f0,0xff00,0x5f5f}; /* have to fake it..*/
/* solid, dotted, dashed, long dashed, dot-dashed */

/********************************************************************************
Name     : XDrawSegments()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#if (DEBUG!=0)
int bSkipDrawSegments = 0;
#endif

XDrawSegments( Display* d,
	       Drawable win,
	       GC gc,
	       XSegment* segments,
	       int nsegments )
{
  register int i;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawSegments )
    return;
  FunCount_Enter(  XDRAWSEGMENTS, bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( nsegments*2>DG.vMaxEntries ){
    DG.aPoints = X11Expand_Points(DG.aPoints,nsegments*2);
  }

  if( gc->values.line_width<2 ){
#ifndef DOCLIPPING
    for( i=0; i<nsegments; i++ ){
      int
	x1 = segments[i].x1,
	y1 = segments[i].y1,
	x2 = segments[i].x2,
	y2 = segments[i].y2;

      if( clipper(&x1,&y1,&x2,&y2) ){
	Move(DG.drp,DG.vWinX+x1,DG.vWinY+y1);
	Draw(DG.drp,DG.vWinX+x2,DG.vWinY+y2);
      }
    }
#else
    for( i=0; i<nsegments; i++ ){
      Move(DG.drp,DG.vWinX+segments[i].x1,DG.vWinY+segments[i].y1);
      Draw(DG.drp,DG.vWinX+segments[i].x2,DG.vWinY+segments[i].y2);
    }
#endif
  } else {
    for( i=0; i<nsegments; i++ ){
      XDrawLine(d,win,gc,segments[i].x1,segments[i].y1,segments[i].x2,segments[i].y2);
    }
  }

  return(0);
}

/********************************************************************************/
/* polygon clipping */
/********************************************************************************/

__inline boolean inside( XPoint p, int edge );
__inline boolean cross( XPoint p, XPoint s, int edge );
__inline void output_vertex( XPoint p );
__inline XPoint find_intersection( XPoint p, XPoint s, int edge );
__inline void clip_this( XPoint p, int edge );
__inline void clip_closer( void );

enum {
  LEFTEDGE=0,
  RIGHTEDGE,
  TOPEDGE,
  BOTTOMEDGE,
};

int new_edge[4];
XPoint aFirstPoint[4],aS[4];

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
__inline boolean
inside( XPoint p, int edge )
{
  switch ( edge ){
  case LEFTEDGE:
    if( p.x>=0 )
      return True;
    break;
  case RIGHTEDGE:
    if( p.x<DG.vWinWidth )
      return True;
    break;
  case TOPEDGE:
    if( p.y>=0 )
      return True;
    break;
  case BOTTOMEDGE:
    if( p.y<DG.vWinHeight )
      return True;
    break;
  }
  return False;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline boolean
cross( XPoint p, XPoint s, int edge )
{
  switch ( edge ){
  case LEFTEDGE:
    if( p.x<0 && s.x>=0 || p.x>=0 && s.x<0 ){
      return True;
    }
    break;
  case RIGHTEDGE:
    if( p.x<DG.vWinWidth-1 && s.x>=DG.vWinWidth-1 || p.x>=DG.vWinWidth-1 && s.x<DG.vWinWidth-1 ){
      return True;
    }
    break;
  case TOPEDGE:
    if( p.y<0 && s.y>=0 || p.y>=0 && s.y<0 ){
      return True;
    }
    break;
  case BOTTOMEDGE:
    if( p.y<DG.vWinHeight-1 && s.y>=DG.vWinHeight-1 || p.y>=DG.vWinHeight-1 && s.y<DG.vWinHeight-1 ){
      return True;
    }
    break;
  }
  return False;
}

int nOutput;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline void
output_vertex( XPoint p )
{
#if 1
  DG.X11PointBuffer[nOutput].x = p.x+DG.vWinX;
  DG.X11PointBuffer[nOutput++].y = p.y+DG.vWinY;
#else
  DG.X11PointBuffer[nOutput++] = p;
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline XPoint
find_intersection( XPoint p, XPoint s, int edge )
{
  XPoint r;
  XPoint p1,p2;

  switch ( edge ){
  case LEFTEDGE:
    p1.x = 0;
    p1.y = 0;
    p2.x = 0;
    p2.y = DG.vWinHeight-1;
    GetCrossing(p,s,p1,p2,&r);
    break;
  case RIGHTEDGE:
    p1.x = DG.vWinWidth-1;
    p1.y = 0;
    p2.x = DG.vWinWidth-1;
    p2.y = DG.vWinHeight-1;
    GetCrossing(p,s,p1,p2,&r);
    break;
  case TOPEDGE:
    p1.x = 0;
    p1.y = 0;
    p2.x = DG.vWinWidth-1;
    p2.y = 0;
    GetCrossing(p,s,p1,p2,&r);
    break;
  case BOTTOMEDGE:
    p1.x = 0;
    p1.y = DG.vWinHeight-1;
    p2.x = DG.vWinWidth-1;
    p2.y = DG.vWinHeight-1;
    GetCrossing(p,s,p1,p2,&r);
    break;
  default:
    r.x = 0; /* shouldn't happen */
    r.y = 0;
    break;
  }
  return r;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline void
clip_this( XPoint p, int edge )
{
  XPoint i;

  if( new_edge[edge] ){
    aFirstPoint[edge] = p;
    new_edge[edge] = False;
  } else {
    if( cross(p,aS[edge],edge) ){
      i = find_intersection(p,aS[edge],edge);
      if( edge<3 )
	clip_this(i,edge+1);
      else
	output_vertex(i);
    }
  }
  aS[edge] = p;
  if( inside(p,edge) )
    if( edge<3 )
      clip_this(p,edge+1);
    else
      output_vertex(p);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline void
clip_closer( void )
{
  XPoint i;
  int edge;

  for( edge=0; edge<4; edge++ ){
    if( cross(aS[edge],aFirstPoint[edge],edge) ){
      i = find_intersection(aS[edge],aFirstPoint[edge],edge);
      if( edge<3 )
	clip_this(i,edge+1);
      else
	output_vertex(i);
    }
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Sutherland & Hodgman clipping
********************************************************************************/

void
polygon_clip( int nPoints,
	      XPoint *points,
	      boolean bFill,
	      int PolygonType,
	      int *nPointsReturn,
	      int move,
	      int end )
{
  XPoint p;
  int n;

  nOutput = 0;
  if( DG.vMaxPointBuffer<nPoints*2 )
    DG.X11PointBuffer = X11Expand_Points( DG.X11PointBuffer, nPoints*2 );

  for( n=0; n<4; n++ )
    new_edge[n] = True;
  for( n=0; n<nPoints; n++ ){
    p.x = points[n].x;
    p.y = points[n].y;
    clip_this(p,0);
  }
  if( nOutput>1 && PolygonType==Polygon_Closed )
    clip_closer();

  *nPointsReturn = nOutput;
  if( !nOutput ){
    return;
  }
#if 0
/* (DEBUG!=0)*/
  for( n=0; n<nOutput; n++ ){
    if( aXP[n].x<0 || aXP[n].y<0 || aXP[n].x>=DG.vWinWidth || aXP[n].y>=DG.vWinHeight ){
      printf("major bug\n");
      X11Internal_Error(0);
    }
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

#if (DEBUG!=0)

extern struct Screen* pRealWB;

void
showbitmap( struct BitMap *bm,
	    int width,
	    int height,
	    int xpos,
	    int ypos ){
  SetAPen(&(pRealWB->RastPort),0);
  SetDrMd(&(pRealWB->RastPort),JAM1);
  if( ypos ){
    RectFill(&(pRealWB->RastPort),20,22+(height+20)*ypos,40+width,40+(height+20)*ypos+height);
    BltBitMapRastPort(bm,0,0,&(pRealWB->RastPort),22,30+(height+20)*ypos,width,height,0xC0);
  } else { 
    RectFill(&(pRealWB->RastPort),20+(width+20)*xpos,22,40+(width+20)*xpos+width,40+height);
    BltBitMapRastPort(bm,0,0,&(pRealWB->RastPort),22+(width+20)*xpos,30,width,height,0xC0);
  }
}

#endif

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : Liang/Barsky clipper
********************************************************************************/

__inline int
cliptest( int p,
	  int q,
	  float* u1,
	  float* u2 )
{
  float r;
  
  if( p<0 ){
    r = (float)q/p;
    if( r>*u2 )
      return 0;
    if( r>*u1 )
      *u1 = r;
  } else {
    if( p>0 ){
      r = (float)q/p;
      if( r<*u1 )
	return 0;
      if( r<*u2 )
	*u2 = r;
    } else {
      if( q<0 ) return 0;
    }
  }
  return 1;
}

__inline int
clipper ( int* x1,
	  int* y1,
	  int* x2,
	  int* y2 )
{
  float u1,u2;
  int dx,dy;

  u1 = 0;
  u2 = 1;
  dx = *x2 - *x1;

  if( cliptest(-dx,*x1,&u1,&u2) ){
    if( cliptest(dx,DG.vWinWidth-1-*x1,&u1,&u2) ){
      dy = *y2-*y1;
      if( cliptest(-dy,*y1,&u1,&u2) ){
	if( cliptest(dy,DG.vWinHeight-1-*y1,&u1,&u2) ){
	  if( u2<1 ){
	    *x2 = *x1+u2*dx;
	    *y2 = *y1+u2*dy;
	  }
	  if( u1>0 ){
	    *x1 = *x1+u1*dx;
	    *y1 = *y1+u1*dy;
	  }
	  return 1;
	}
      }
    }
  }

  return 0;
}

/********************************************************************************
Name     : XDrawPoints()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XDrawPoints( Display* display,
	     Drawable win,
	     GC gc,
	     XPoint* points,
	     int npoints,
	     int mode )
{
  register int i;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  FunCount_Enter(  XDRAWPOINTS, bInformDrawing );

#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

#if (DEBUG!=0)
  if( X11Drawables[win]==X11BITMAP ){
    assert( DG.vWinX==0 );
    assert( DG.vWinY==0 );
  }
#endif
  for( i=0; i<npoints; i++ )
#if 0
    if( points[i].x>0
        && points[i].y>0
        && points[i].x<DG.vWinWidth
        && points[i].y<DG.vWinHeight )
#endif
      WritePixel(DG.drp,DG.vWinX+points[i].x,DG.vWinY+points[i].y);

  return(0);
}

/********************************************************************************
Name     : XFillPolygon()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
static int bSkipXFillPolygon = 0;
#endif

UBYTE abc2 = (ABC|ABNC|ANBC);

UBYTE atod = (ABC|ANBC|ABNC|ANBNC);
UBYTE axorc = NABC|ABNC   | NANBC|ANBNC;
UBYTE aorc = ABC|NABC|ABNC | ANBC|NANBC|ANBNC;
UBYTE aorb = ABC|ANBC|NABC | ABNC|ANBNC|NABNC;

extern int bNoFlicker;

/*****************************************************************/
XFillPolygon( Display *d,
	      Drawable win,
	      GC gc,
	      XPoint *xp,
	      int num,
	      int shape,
	      int mode )
{
  int clipped = 0;
  int xmin,xmax,ymin,ymax;
  XPoint *points = xp;
  int np = num;
  int blitop = 0xc0;
  WORD srcx;
  WORD srcy;
  int vXOff;
  int vYOff;
  
#ifdef DEBUGXEMUL_ENTRY
  if( bSkipDrawing )
    return;
  if( bSkipXFillPolygon ){
    return;
  }
  FunCount_Enter(  XFILLPOLYGON, bInformDrawing );
#endif
  if( num<1 ){
    return 0;
  }
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  /* printf("win %d num %d\n",win,num); */

  vXOff = 0 /*-DG.vWinX*/;
  vYOff = 0 /*-DG.vWinY*/;

  polygon_findminmax(xp,num,&xmin,&xmax,&ymin,&ymax);

  if( xmin<0 || xmax>DG.vWinWidth || ymin<0 || ymax>DG.vWinHeight ){
    polygon_clip(num,xp,True,Polygon_Closed,&np,1,1);
    if( !np ){
      return;
    }
    polygon_findminmax(DG.X11PointBuffer,np,&xmin,&xmax,&ymin,&ymax);
#if 0
    xmin -= DG.vWinX;
    xmax -= DG.vWinX;
    ymin -= DG.vWinY;
    ymax -= DG.vWinY;
    SetABPenDrMd( DG.drp, 1, 0, JAM1 );
    RectFill(DG.drp,DG.vWinX+xmin,DG.vWinY+ymin,DG.vWinX+xmax,DG.vWinY+ymax);
#endif
    clipped = 1;
    points = DG.X11PointBuffer;
    vXOff = -DG.vWinX;
    vYOff = -DG.vWinY;
  }
  if( X11FillCheck(np,xmax-xmin,ymax-ymin) ){
    DG.drp = setup_win(win);
  }
  if( !(xmax-xmin) || !(ymax-ymin) ){
    return;
  }

#if 0
(DEBUG!=0)

  if( GetBitMapAttr(DG.drp->BitMap,BMA_FLAGS) & BMF_INTERLEAVED ){
    printf("interleaved destination\n");
  }

  SetAPen(DG.drp,2);
  RectFill(DG.drp,DG.vWinX,DG.vWinY,DG.vWinX+DG.vWinWidth-1,DG.vWinY+DG.vWinHeight-1);
  SetAPen(DG.drp,1);
  X11FillPolygon(DG.drp,points,np,vXOff,vYOff,0,0,0);
  vPrevGC = (GC)-1;
#endif

  if( DG.X11InternalFill ){
    int addx;
    int addy;

#ifdef DEBUGXEMUL_ENTRY
    if( bSkipFilling )
      return;
#endif
    if( gc->values.ts_x_origin<0 ){
      addx = ceil(-(double)gc->values.ts_x_origin/DG.X11FillWidth);
    } else {
      addx = -floor((double)gc->values.ts_x_origin/DG.X11FillWidth);
    }
    if( gc->values.ts_y_origin<0 ){
      addy = ceil(-(double)gc->values.ts_y_origin/DG.X11FillHeight);
    } else {
      addy = -floor((double)gc->values.ts_y_origin/DG.X11FillHeight);
    }
    srcx = (WORD)((xmin+(DG.X11FillWidth-(gc->values.ts_x_origin+addx*DG.X11FillWidth)))%(DG.X11FillWidth-1));
    srcy = (WORD)((ymin+(DG.X11FillHeight-(gc->values.ts_y_origin+addy*DG.X11FillHeight)))%(DG.X11FillHeight-1));

    /* printf("dx %d dy %d\n",xmax-xmin,ymax-ymin); */
    X11Fit_InternalFill( xmax-xmin+srcx, ymax-ymin+srcy, 0, 0 /*xmin*/, 0 /*ymin*/ );
    /* printf("using %d %d\n",DG.X11FillX,DG.X11FillY); */

    assert( GetBitMapAttr(fillmaskrp.BitMap,BMA_WIDTH)
	    == GetBitMapAttr(DG.X11FillBitMap,BMA_WIDTH) );

    assert( GetBitMapAttr(fillmaskrp.BitMap,BMA_HEIGHT)
	    == GetBitMapAttr(DG.X11FillBitMap,BMA_HEIGHT) );

#if (DEBUG!=0)
    if(show) showbitmap(DG.X11FillBitMap,xmax-xmin,xmax-xmin,0,0);
#endif
    SetABPenDrMd( &fillmaskrp, 0, 0, JAM1 );

    /* printf("using %d %d\n",xmax-xmin+(xmin)%(DG.X11FillWidth-1),ymax-ymin+(ymin)%(DG.X11FillHeight-1)); */
#if 0
    if( srcx<0
        || srcy<0
        || srcx+(xmax-xmin) > GetBitMapAttr(fillmaskrp.BitMap,BMA_WIDTH)
        || srcy+(ymax-ymin) > GetBitMapAttr(fillmaskrp.BitMap,BMA_HEIGHT) ){
      printf("Illegal clip %d %d xmin %d ymin %d xmax %d ymax %d\n",srcx,srcy,
	     xmin,ymin,xmax,ymax);
      printf("fill %d %d\n",DG.X11FillWidth,DG.X11FillHeight);
      printf("origin %d %d\n", gc->values.ts_x_origin, gc->values.ts_y_origin);
      printf("bitmap %d %d\n",
	     GetBitMapAttr(fillmaskrp.BitMap,BMA_WIDTH),
	     GetBitMapAttr(fillmaskrp.BitMap,BMA_HEIGHT) );
      printf("end %d %d\n",srcx+(xmax-xmin),srcy+(ymax-ymin));
      return;
    }
#endif
    assert( srcx >= 0 );
    assert( srcy >= 0 );
    assert( srcx+(xmax-xmin) < GetBitMapAttr(fillmaskrp.BitMap,BMA_WIDTH)  );
    assert( srcy+(ymax-ymin) < GetBitMapAttr(fillmaskrp.BitMap,BMA_HEIGHT) );

    RectFill(&fillmaskrp,srcx,srcy,xmax-xmin+srcx,ymax-ymin+srcy);
    /* SetRast( &fillmaskrp, 0 ); */

    X11FillPolygon(&fillmaskrp,points,np,xmin,ymin,srcx,srcy,1);
    DG.vLastFill = -1;
#if (DEBUG!=0)
    if(show) showbitmap(fillmaskrp.BitMap,xmax-xmin,ymax-ymin,1,0);
#endif
    
    if( bNoFlicker ){

      /* get old screen contents */
      
      WaitBlit();
      BltBitMap(DG.drp->BitMap,DG.vWinX+xmin+vXOff+DG.vWindow->LeftEdge,DG.vWinY+ymin+vYOff+DG.vWindow->TopEdge,backfillrp2.BitMap,0,0,xmax-xmin,ymax-ymin,blitop,0xff,NULL);

      /* clear old area */

#if 1
      if( GetBitMapAttr(DG.drp->BitMap,BMA_DEPTH) != DG.X11FillDepth ){
	SetABPenDrMd( &backfillrp2, gc->values.background, 0, JAM1 );
	X11FillPolygon(&backfillrp2,points,np,xmin,ymin,0,0,0);
#if (DEBUG!=0)
	if(show) showbitmap(backfillrp2.BitMap,xmax-xmin,ymax-ymin,2,0);
#endif
      }
#endif
      /* insert new gfx */

      WaitBlit();      
      BltMaskBitMapRastPort(DG.X11FillBitMap,srcx,srcy,&backfillrp2,0,0,xmax-xmin,ymax-ymin,abc2,fillmaskrp.BitMap->Planes[0]);
#if (DEBUG!=0)
      if(show) showbitmap(backfillrp2.BitMap,xmax-xmin,ymax-ymin,2,0);
#endif
      
      /* output result */

      WaitBlit();      
      BltBitMapRastPort(backfillrp2.BitMap,0,0,DG.drp,DG.vWinX+xmin+vXOff,DG.vWinY+ymin+vYOff,xmax-xmin,ymax-ymin,blitop);
    } else {
      if( GetBitMapAttr(DG.drp->BitMap,BMA_DEPTH) != DG.X11FillDepth ){
	SetABPenDrMd( &backfillrp2, 0, 0, JAM1 );
#if 0
	RectFill(&backfillrp2,(xmin)%(DG.X11FillWidth-1),(ymin)%(DG.X11FillHeight-1),xmax-xmin+(xmin)%(DG.X11FillWidth-1),ymax-ymin+(ymin)%(DG.X11FillHeight-1));
#endif
	WaitBlit();      
	BltMaskBitMapRastPort(DG.X11FillBitMap,(xmin)%(DG.X11FillWidth-1),(ymin)%(DG.X11FillHeight-1),&backfillrp2,0,0,xmax-xmin,ymax-ymin,abc2 /*blitop*/,fillmaskrp.BitMap->Planes[0]);

#if 1
	SetABPenDrMd( DG.drp, gc->values.background, gc->values.background, X11FunctionMapping[gc->values.function] );
	X11FillPolygon(DG.drp,points,np,0,0,DG.vWinX+vXOff,DG.vWinY+vYOff,0);
	SetABPenDrMd( DG.drp, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function] );
#endif
	WaitBlit();      
	{
#if 0
	  int vPatternWidth = xmax-xmin;
	  if( vPatternWidth%16 )
	    vPatternWidth += 16-(vPatternWidth%16);
#endif
	  BltTemplate(backfillrp2.BitMap->Planes[0],0,backfillrp2.BitMap->BytesPerRow,DG.drp,DG.vWinX+xmin+vXOff,DG.vWinY+ymin+vYOff,xmax-xmin,ymax-ymin);
#if 0
	  BltPattern(DG.drp,backfillrp2.BitMap->Planes[0],DG.vWinX+xmin+vXOff,DG.vWinY+ymin+vYOff,
		     DG.vWinX+xmin+vPatternWidth+vXOff,DG.vWinY+ymax+vYOff,backfillrp2.BitMap->BytesPerRow);
#endif
	}
      } else {
	WaitBlit();      
	BltMaskBitMapRastPort(DG.X11FillBitMap,srcx,srcy,DG.drp,DG.vWinX+xmin,DG.vWinY+ymin,xmax-xmin,ymax-ymin,abc2,fillmaskrp.BitMap->Planes[0]);
      }
    }
  } else { /* no pattern stuff: */
#if 0
    X11FillPolygon(DG.drp,points,np,DG.vWinX+vXOff,DG.vWinY+vYOff,0,0,0);
#else
    X11FillPolygon(DG.drp,points,np,0,0,DG.vWinX+vXOff,DG.vWinY+vYOff,0);
#endif
  }
}

/********************************************************************************
Name     : XFillRectangle()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#if (DEBUG!=0)
int bSkipFillRectangle = 0;
#endif

XFillRectangle( Display* d,
	        Drawable win,
	        GC gc,
	        int x1,
	        int y1,
	        unsigned int w,
	        unsigned int h )
{
  int width = w,height = h;
  int vOrigWidth = w,vOrigHeight = h;
  int vPatternXOff = 0,vPatternYOff = 0;
  int vOrigX1 = x1,vOrigY1 = y1;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFillRectangle )
    return;
  FunCount_Enter(  XFILLRECTANGLE, bInformDrawing );
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  /* printf("win %d %d %d %d %d\n",win,x1,y1,w,h); */

  x1 += DG.vWinX;
  y1 += DG.vWinY;

  if( x1+width<=DG.vWinX
     || y1+height<=DG.vWinY
     || x1>=DG.vWinWidth+DG.vWinX
     || y1>=DG.vWinHeight+DG.vWinY ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
    return; /* completely outside */
  }

  if( (int)x1<DG.vWinX ){
    width += x1-DG.vWinX;
    vPatternXOff = x1;
    x1 = DG.vWinX;
  }
  if( (int)y1<DG.vWinY ){
    height += y1-DG.vWinY;
    vPatternYOff = y1;
    y1 = DG.vWinY;
  }
  if( (int)(x1+width)>=(int)DG.vWinWidth+DG.vWinX ){
    if( x1>0 )
      width = DG.vWinWidth+DG.vWinX-x1;
    else
      width = DG.vWinWidth+DG.vWinX-1;
    if( width<=0 ){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
      return(0);
    }
  }
#if (DEBUG!=0)
    else if( width<0 ){
      assert(1==0); /* can't really happen */
    x1 = x1+width;
    width = -width;
  }
#endif

  if( (int)(y1+height)>=(int)DG.vWinHeight+DG.vWinY ){
    if( y1>0 )
      height = DG.vWinHeight+DG.vWinY-y1;
    else
      height = DG.vWinHeight+DG.vWinY-1;
    if(height<=0){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
      return(0);
    }
  }
#if (DEBUG!=0)
 else if( height<0 ){
      assert(1==0); /* can't really happen */
    y1 =+ height;
    height =- height;
  }
#endif

#if (DEBUG!=0)
#endif
  if( width<1 || height<1 ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
    return;
  }

  if( DG.X11InternalFill ){
    int blitop = 0xc0 /*(ABC|ABNC|ANBC)*/;
    int olddrmd;
    int oldfg,oldbg;

    if( CG.bNeedClip ){
      vOrigWidth = GetBitMapAttr(CG.pClipBM,BMA_WIDTH);
      vOrigHeight = GetBitMapAttr(CG.pClipBM,BMA_HEIGHT);
    }

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipFilling )
    return;
#endif
    X11Fit_InternalFill(vOrigWidth,vOrigHeight,0, 0 /*vOrigX1*/, 0 /*vOrigY1*/ );
#if (DEBUG!=0)
    if(show) showbitmap(DG.X11FillBitMap,width,height,0,0);
#endif
    olddrmd = DG.drp->DrawMode;
    oldfg = DG.drp->FgPen;
    oldbg = DG.drp->BgPen;

    /* clear the destination if needed: */
    if( !CG.bNeedClip
        && gc->values.function!=GXinvert
        && gc->values.function!=GXxor
        && gc->values.fill_style!=FillStippled ) {
      SetABPenDrMd( DG.drp, gc->values.background, X11DrawablesBackground[win], JAM1);
      RectFill(DG.drp,/*DG.vWinX+*/x1,/*DG.vWinY+*/y1,/*DG.vWinX+*/x1+width-1,/*DG.vWinY+*/y1+height-1);
    } 
    if( !CG.bNeedClip ){
#if 0
      int bg  = 1;
      if( DG.vLastFill!=REC || DG.vLastFillW!=DG.X11FillX-1 || DG.vLastFillH!=DG.X11FillY-1 ){
	SetABPenDrMd( &fillmaskrp, bg, X11DrawablesBackground[win], JAM1);
	RectFill(&fillmaskrp,0,0,DG.X11FillX-1,DG.X11FillY-1);
	DG.vLastFill = REC;
	DG.vLastFillW = DG.X11FillX-1;
	DG.vLastFillH = DG.X11FillY-1;
      }
#endif
    } else {
      WaitBlit();
      BltBitMapRastPort(CG.pClipBM,0,0,&fillmaskrp,0,0,vOrigWidth,vOrigHeight,0xC0);
#if (DEBUG!=0)
    if(show) showbitmap(fillmaskrp.BitMap,vOrigWidth,vOrigHeight,0,0);
#endif
    }


#if 0
    SetABPenDrMd( DG.drp, gc->values.background, X11DrawablesBackground[win], JAM1);
    
    BltTemplate(fillmaskrp.BitMap->Planes[0],0,fillmaskrp.BitMap->BytesPerRow,DG.drp,x1,y1,width,height);
#endif

    if( vPatternXOff ){
      vPatternXOff =  vPatternXOff % (DG.X11FillWidth+1);
    }

    if( vPatternYOff ){
      vPatternYOff = vPatternYOff % (DG.X11FillHeight+1);
    }

#if 0
    if( GetBitMapAttr(DG.drp->BitMap,BMA_DEPTH) != DG.X11FillDepth ){
      SetRast(&backfillrp2,X11DrawablesBackground[win]);
      SetABPenDrMd( &backfillrp2, 0 /*gc->values.background*/, 0, JAM1 );
      BltPattern(&backfillrp2,DG.X11FillBitMap->Planes[0],0,0,width,height,DG.X11FillBitMap->BytesPerRow);
#if (DEBUG!=0)
      if(show) showbitmap(backfillrp2.BitMap,width,height,0,0);
#endif
    }
#endif

    if( gc->values.clip_x_origin || gc->values.clip_y_origin ){
      int a = 0,b = 0;

      if( vOrigX1<0 )
	a = -gc->values.clip_x_origin;
      else
	a = vOrigX1-gc->values.clip_x_origin;
      if( vOrigY1<0 )
	b = -gc->values.clip_y_origin;
      else
	b = vOrigY1-gc->values.clip_y_origin;
      WaitBlit();
      if( !CG.bNeedClip ){
	BltBitMapRastPort(DG.X11FillBitMap,a,b,&backfillrp2,0,0,width,height,blitop);
      } else {
	BltMaskBitMapRastPort(DG.X11FillBitMap,a,b,&backfillrp2,0,0,
			      width,height,blitop,fillmaskrp.BitMap->Planes[0]);
      }
    } else if( vPatternXOff || vPatternYOff ){
      WaitBlit();
      if( !CG.bNeedClip ){
	BltBitMapRastPort(DG.X11FillBitMap,vPatternXOff,vPatternYOff,&backfillrp2,0,0,
			  width,height,blitop);
      }	else {
	BltMaskBitMapRastPort(DG.X11FillBitMap,vPatternXOff,vPatternYOff,&backfillrp2,0,0,
			      width,height,blitop,fillmaskrp.BitMap->Planes[0]);
      }
    } else {
      WaitBlit();
      if( !CG.bNeedClip ){
	BltBitMapRastPort(DG.X11FillBitMap,0,0,&backfillrp2,0,0,width,height,blitop);
      } else {
	BltMaskBitMapRastPort(DG.X11FillBitMap,0,0,&backfillrp2,0,0,
			      width,height,blitop,fillmaskrp.BitMap->Planes[0]);
      }
    }
#if 1
#if (DEBUG!=0)
    if(show) showbitmap(backfillrp2.BitMap,width,height,0,0);
#endif
    SetABPenDrMd( DG.drp, gc->values.foreground, X11DrawablesBackground[win], X11FunctionMapping[gc->values.function]);
    /* SetDrMd(DG.drp,X11FunctionMapping[gc->values.function]); */
    WaitBlit();
#if 1
    if( /*GetBitMapAttr(backfillrp2.BitMap,BMA_DEPTH)*/ DG.X11FillDepth == 1 ){
      /* apparently there is some alignment needed with BltPattern.
	 I haven't seen it described anywhere, but I guess this will do : */
#if 0
      if( width%16 )
	width += 16-(width%16);
#endif
      BltTemplate(backfillrp2.BitMap->Planes[0],0,backfillrp2.BitMap->BytesPerRow,DG.drp,x1,y1,width,height);
      /* BltPattern(DG.drp,backfillrp2.BitMap->Planes[0],x1,y1,x1+width-1,y1+height-1,backfillrp2.BitMap->BytesPerRow); */
    } else 
#endif
      BltBitMapRastPort(backfillrp2.BitMap,0,0,DG.drp,/*DG.vWinX+*/x1,/*DG.vWinY+*/y1,width,height,0xc0);
#endif
    DG.drp->DrawMode = olddrmd;
    DG.drp->FgPen = oldfg;
    DG.drp->BgPen = oldbg;

#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
    return;
  }
  if( !CG.bNeedClip ){
#if (DEBUG!=0)
    if( X11Drawables[win]==X11BITMAP ){
      assert(/*DG.vWinX+*/x1+width-1<DG.vWinWidth+DG.vWinX);
      assert(/*DG.vWinY+*/y1+height-1<DG.vWinHeight+DG.vWinY);
    }
#endif
    RectFill(DG.drp,/*DG.vWinX+*/x1,/*DG.vWinY+*/y1,/*DG.vWinX+*/x1+width-1,/*DG.vWinY+*/y1+height-1);
  } else {
    WaitBlit();
    BltBitMapRastPort(CG.pClipBM,0,0,DG.drp,/*DG.vWinX+*/x1,/*DG.vWinY+*/y1,width,height,0xC0);
  }
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XFILLRECTANGLE, bInformDrawing );
#endif 
}

/********************************************************************************
Name     : XFillRectangles()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XFillRectangles( Display* display,
		 Drawable drawable,
		 GC gc,
		 XRectangle* rectangles,
		 int nrectangles )
{
  int i;

  for( i=0; i<nrectangles; i++ )
    XFillRectangle(display,drawable,gc,rectangles[i].x,rectangles[i].y,rectangles[i].width,rectangles[i].height);
}
