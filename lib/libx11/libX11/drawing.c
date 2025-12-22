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
***/

/*#define DOCLIPPING*/
/*#define TEST*/

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

/*#define XLIB_ILLEGAL_ACCESS 1*/

#include <X11/X.h>
#include <X11/Xlib.h>
/*
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>
*/
/*
#include <libraries/mui.h>
#include <proto/muimaster.h>
*/
#include <X11/Xlibint.h>

#include "amigax_proto.h"
#include "amiga_x.h"

/*
#define DEBUGXEMUL_ENTRY 1
*/
/*******************************************************************************************/
/* externals */
extern GC      amiga_gc;

extern struct Screen *Scr,*wb;

extern int X_relx,X_rely,X_right,X_bottom,X_width,X_height;
extern int Xdash;
extern Window prevwin;
extern GC prevgc;

#define M_PI      3.14159265358979323846
#define rad(x) ((double)(x)*M_PI/180)
/*******************************************************************************************/
/* prototypes */

polygon_draw(struct RastPort *drp,XPoint *aPoints,int nPoints,int xmin,int ymin);
X11FillPolygon(struct RastPort *drp,XPoint *points,int nPoints,int xmin,int ymin, char black);

XPoint *polygon_clip( int nPoints,
		      XPoint *points,
		      boolean bFill,
		      int PolygonType,
		      int *nPointsReturn,
		      int move,
		      int end );

enum {
  Polygon_Open=1,
  Polygon_Closed
};

/*******************************************************************************************/
extern struct RastPort drawrp,backrp;
extern struct RastPort *drp;

extern void _Xfillfit(Window,int);
extern int X11check_size(Window,int,int);

/*******************************************************************************************/
/* globals */

XPoint xp[4];
XPoint *aPoints;
int vMaxEntries=100;

/*******************************************************************************************/

void polygon_findminmax( XPoint *aPoints, int nPoints, int *xmin, int *xmax, int *ymin, int *ymax){
  int i;
  
  *xmin=*xmax=aPoints[0].x;
  *ymin=*ymax=aPoints[0].y;
  for(i=1;i<nPoints;i++){
    if(aPoints[i].x<*xmin) *xmin=aPoints[i].x;
    if(aPoints[i].x>*xmax) *xmax=aPoints[i].x;
    if(aPoints[i].y<*ymin) *ymin=aPoints[i].y;
    if(aPoints[i].y>*ymax) *ymax=aPoints[i].y;
  }
}

void X11ClearPattern(Window win,int x,int y,int w,int h,int background){
  SetAPen(drp,background /*X11DrawablesBackground[win]*/);
  SetDrPt(drp,0xFFFF);
  SetAfPt(drp,0,0);
  SetDrMd(drp,JAM1);
  BltPattern(drp,backfillrp.BitMap->Planes[0],X_relx+x,X_rely+y,X_relx+x+w,X_rely+y+h,backfillrp.BitMap->BytesPerRow);
  WaitBlit();
  prevgc=(GC)-1;
}

void X11init_drawing(void){
  aPoints=malloc(vMaxEntries*sizeof(XPoint));
  if(!aPoints) X11resource_exit(DRAWING1);
}

void X11Expand_Points(int n){
  free(aPoints);
  aPoints=malloc((n+50)*sizeof(XPoint));
  vMaxEntries=n+50;
  if(!aPoints) X11resource_exit(DRAWING2);
}

void X11exit_drawing(void){
  free(aPoints);
}


XDrawArc(d,win,gc,x,y,w,h,v1,v2)
     Display *d;
     Drawable win;
     GC gc;
     int x,y,v1,v2;
     unsigned int w,h;
{
  float px0,py0,fx,fy,px1,py1;
  int n;
  int vX[200],vY[200];
  int p=0;
  boolean simple=True;
  int type=Polygon_Open;
  XPoint *points;
  int np;
  int error;

#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawArc\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);
  _Xfillfit(win,100);
  if(h<2) h=2;
  if(w<2) w=2;

  v1=v1>>6;
  v2=v2>>6;
  if(v1==0&&v2==360) type=Polygon_Closed;
  if(v1!=0||v2!=360) simple=False;
  if(x<0 || y<0 || x+w>X_width || y+h>X_height){
    type=Polygon_Open;
    simple=False;
  }
  if(simple){
    if( gc->values.line_width<2 )
      DrawEllipse(drp,X_relx+((w>>1)+x),X_rely+((h>>1)+y),(w>>1),(h>>1));
    else {
      error=AreaEllipse(drp,X_relx+(w>>1)+x,X_rely+(h>>1)+y,
			(w>>1)+(gc->values.line_width>>1),(h>>1)+(gc->values.line_width>>1));
      if( error==-1 ) return 0;
      if( ((int)(w>>1)-(gc->values.line_width>>1)) >0 &&
	 ((int)(h>>1)-(gc->values.line_width>>1)) >0 )
	error=AreaEllipse(drp,X_relx+(w>>1)+x,X_rely+(h>>1)+y,
			  (w>>1)-(gc->values.line_width>>1),(h>>1)-(gc->values.line_width>>1));
      if( error==-1 ) return 0;
      AreaEnd(drp);
    }
    return;
  }

  px0=cos(rad(-(v1+v2)))*(w>>1);
  py0=sin(rad(-(v1+v2)))*(h>>1);
  fx=cos(rad(-5));
  fy=sin(rad(-5));
  if(vMaxEntries<200) X11Expand_Points(200);
  if( gc->values.line_width<2 ){
    aPoints[p].x=(int)(x+(w>>1)+px0); aPoints[p++].y=(int)((h>>1)+y+py0);
    for(n=0;n<(int)(v2/5);n++){
      px1=fx*px0+fy*py0;
      py1=fx*py0-fy*px0;
      aPoints[p].x=(int)((w>>1)+x+px1); aPoints[p++].y=(int)((h>>1)+y+py1*h/w);
      px0=px1;
      py0=py1;
    }
#ifdef DOCLIPPING
    polygon_draw(drp,aPoints,p,X_relx,X_rely);
#else
    points=polygon_clip(p,aPoints,0,type,&np,1,1);
    if(np) polygon_draw(drp,points,np,X_relx,X_rely);
    if(points) free(points);
#endif
  } else /* wide lines */ { 
    int p=0;
    float f;

    if(((int)w-(int)gc->values.line_width)>0){
      _Xfillfit(win,200);
    }
/*
    px0=cos(rad(-(v1+v2)))*((int)(w>>1)+(gc->values.line_width>>1));
    py0=sin(rad(-(v1+v2)))*((int)(w>>1)+(gc->values.line_width>>1));
    x0=(int)(x+(w>>1)+px0);
    y0=(int)(y+(w>>1)+py0);
*/
    px0=(w>>1)+(gc->values.line_width>>1);
    py0=0;
    aPoints[p].x=(int)(x+w+(gc->values.line_width>>1)); aPoints[p++].y=y+(h>>1);
    f=(float)((int)h+(gc->values.line_width>>1))/((int)w+(gc->values.line_width>>1));
    for(n=0;n<(int)(v2/5);n++){
      px1=fx*px0+fy*py0;
      py1=fx*py0-fy*px0;
      aPoints[p].x=(int)((w>>1)+x+px1); 
      aPoints[p++].y=(int)((h>>1)+y+py1*f);
      px0=px1;
      py0=py1;
    }

    
    if(((int)w-(int)gc->values.line_width)>0){
      int pn=1,n;
      float f;
#ifdef DOCLIPPING
#ifdef TEST
      polygon_draw(drp,aPoints,p,X_relx,X_rely);
#else
      AreaMove(drp,X_relx+aPoints[0].x,X_rely+aPoints[0].y);
      for( n=1;n<p;n++ ){
	AreaDraw(drp,X_relx+aPoints[n].x,X_rely+aPoints[n].y);
      }
#endif
#else
      points=polygon_clip(p,aPoints,1,Polygon_Closed,&np,1,0);
      if(!np) {
	if(points) free(points);
	return;
      }
      if(AreaMove(drp,X_relx+points[0].x,X_rely+points[0].y)==-1){
	printf("error!\n");
	return 0;
      }
      for( n=1;n<np;n++ ){
	if(AreaDraw(drp,X_relx+points[n].x,X_rely+points[n].y)==-1){
	  printf("error!\n");
	  return 0;
	}
      }
      if(points) free(points);
#endif
/*
      px0=cos(rad(-(v1+v2)))*((int)(w>>1)-(gc->values.line_width>>1));
      py0=sin(rad(-(v1+v2)))*((int)(w>>1)-(gc->values.line_width>>1));
*/
      px0=(w>>1)-(gc->values.line_width>>1);
      py0=0;

      fx=cos(rad(-5)); fy=sin(rad(-5));
      vX[0]=(int)(x+w-(gc->values.line_width>>1));
      vY[0]=(int)(y+(h>>1));
      f=(float)((int)h-(gc->values.line_width>>1))/((int)w-(gc->values.line_width>>1));
      for(n=0;n<(int)(v2/5);n++){
	px1=fx*px0+fy*py0;
	py1=fx*py0-fy*px0;
	vX[pn]=(int)((w>>1)+x+px1);
        vY[pn++]=(int)((h>>1)+y+py1*f);
	px0=px1; py0=py1;
      }
      if(v1==0 && v2==360)
	AreaMove(drp,X_relx+vX[pn-1],X_rely+vY[pn-1]);
      else
	AreaDraw(drp,X_relx+vX[pn-1],X_rely+vY[pn-1]);
      p=0;
      for(n=pn-1;n>=0;n--){
	aPoints[p].x=vX[n]; aPoints[p++].y=vY[n];
      }
    } else {
      aPoints[p].x=x+(w>>1); aPoints[p++].y=y+(w>>1);
      AreaMove(drp,X_relx+aPoints[0].x,X_rely+aPoints[0].y);
    }
#ifdef DOCLIPPING
#ifdef TEST
    polygon_draw(drp,aPoints,p,X_relx,X_rely);
#else
    for( n=1;n<p;n++ ){
      AreaDraw(drp,X_relx+aPoints[n].x,X_rely+aPoints[n].y);
    }
    AreaEnd(drp);
#endif
#else
    points=polygon_clip(p,aPoints,1,Polygon_Closed,&np,0,1);
    if(!np){
      if(points) free(points);
      AreaEnd(drp);
      return;
    }
    for( n=1;n<np;n++ ){
      if(AreaDraw(drp,X_relx+points[n].x,X_rely+points[n].y)==-1){ 
	printf("error!\n");
	return 0;
      }
    }
    AreaEnd(drp);
    if(points) free(points);
#endif
  }
}
     

XDrawArcs(display, drawable, gc, arcs, narcs)
     Display *display;
     Drawable drawable;
     GC gc;
     XArc *arcs;
     int narcs;
{
  int i;
  for(i=0;i<narcs;i++)
    XDrawArc(display,drawable,gc,arcs[i].x,arcs[i].y,arcs[i].width,arcs[i].height,arcs[i].angle1,arcs[i].angle2);
}

XFillArc(d,win,gc,x,y,w,h,v1,v2)
     Display *d;
     Drawable win;
     GC gc;
     int x,y,v1,v2;
     unsigned int w,h;
{
  float px0,py0,fx,fy,px1,py1;
  int n;
  int p=0;
  boolean simple=True;
/*  printf("(drawing)XFillArc %d %d %d %d %d %d\n",x,y,w,h,v1,v2);*/
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XFillArc\n");
#endif

  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if(h<2) h=2;
  if(w<2) w=2;

  if(X11check_size(win,w,h)) return;
  v1=v1>>6;
  v2=v2>>6;
  if(v1!=0||v2!=360) simple=False;
  if(x<0 || y<0 || x+w>X_width || y+h>X_height) simple=False;

  if(simple){
    if( X11InternalFill ){
      X11Fit_InternalFill(w,h);
      SetAfPt(&backfillrp,0,0);
      SetDrMd(&backfillrp,JAM1);
      SetAPen(&backfillrp,1);
      AreaEllipse(&backfillrp,(w>>1),(h>>1),(w>>1),(h>>1));
      AreaEnd(&backfillrp);
      X11ClearPattern(win,x,y,w,h,gc->values.background);
/*
      BltMaskBitMapRastPort(X11FillBitMap,0,0,&backfillrp2,X_relx+x,X_rely+y,w,h,
			    (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
      WaitBlit();
*/

      SetDrMd(drp,JAM2);
      SetAPen(drp,gc->values.foreground);
      SetBPen(drp,X11DrawablesBackground[win]);
      prevgc=(GC)-1;
      BltMaskBitMapRastPort(X11FillBitMap,0,0,&backfillrp2,0,0,w,h,
			  (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
      WaitBlit();
      BltPattern(drp,backfillrp2.BitMap->Planes[0],X_relx+x,X_rely+y,X_relx+x+w,X_rely+y+h,backfillrp.BitMap->BytesPerRow);
      WaitBlit();
      return;
    }
    AreaEllipse(drp,X_relx+x+(w>>1),X_rely+y+(h>>1),(w>>1),(h>>1));
    AreaEnd(drp);
    return;
  }

  px0=cos(rad(-(v1+v2)))*(w>>1);
  py0=sin(rad(-(v1+v2)))*(h>>1);
  fx=cos(rad(-5));
  fy=sin(rad(-5));
  if(gc->values.arc_mode==ArcPieSlice){
    aPoints[p].x=(int)(x+(w>>1)); aPoints[p++].y=(int)(y+(h>>1));
  }
  aPoints[p].x=(int)(x+(w>>1)+px0); aPoints[p++].y=(int)(y+(h>>1)+py0);
  for(n=0;n<(int)(v2/5);n++){
    px1=fx*px0+fy*py0;
    py1=fx*py0-fy*px0;
    aPoints[p].x=(int)(x+(w>>1)+px1); aPoints[p++].y=(int)(y+(h>>1)+py1*h/w);
    px0=px1;
    py0=py1;
  }
  aPoints[p].x=(int)(x+(w>>1)); aPoints[p++].y=(int)(y+(h>>1));
  {
    int np;
    XPoint *points;
    points=polygon_clip(p,aPoints,1,Polygon_Closed,&np,1,1);
    if(!np){
      if(points) free(points);
      return;
    }
    if( X11InternalFill ){
      int xmin,xmax,ymin,ymax;

      polygon_findminmax(points,np,&xmin,&xmax,&ymin,&ymax);
      X11Fit_InternalFill(xmax-xmin,ymax-ymin);
      SetAfPt(&backfillrp,0,0);
      SetDrMd(&backfillrp,JAM1);
      SetAPen(&backfillrp,1);
      X11FillPolygon(&backfillrp,points,np,xmin,ymin,1);
      X11ClearPattern(win,xmin,ymin,xmax-xmin,ymax-ymin,gc->values.background);
/*
      BltMaskBitMapRastPort(X11FillBitMap,0,0,drp,X_relx+xmin,X_rely+ymin,xmax-xmin,ymax-ymin,
			    (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
      WaitBlit();
*/
      SetDrMd(drp,JAM2);
      SetAPen(drp,gc->values.foreground);
      SetBPen(drp,X11DrawablesBackground[win]);
      prevgc=(GC)-1;
      BltMaskBitMapRastPort(X11FillBitMap,0,0,&backfillrp2,0,0,xmax-xmin,ymax-ymin,
			    (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
      WaitBlit();
      BltPattern(drp,backfillrp2.BitMap->Planes[0],X_relx+xmin,X_rely+ymin,X_relx+xmax,X_rely+ymax,backfillrp.BitMap->BytesPerRow);
      WaitBlit();
    } else
      if(np) X11FillPolygon(drp,points,np,-X_relx,-X_rely,0);
    prevgc=(GC)-1;
    if(points) free(points);
  }
}

XFillArcs(display, drawable, gc, arcs, narcs)
     Display *display;
     Drawable drawable;
     GC gc;
     XArc *arcs;
     int narcs;
{
  int i;
  for(i=0;i<narcs;i++)
    XFillArc(display,drawable,gc,arcs[i].x,arcs[i].y,arcs[i].width,arcs[i].height,arcs[i].angle1,arcs[i].angle2);
}

XDrawPoint(d,win,gc,x1,y1)
     Display *d;
     Drawable win;
     GC gc;
     int x1,y1;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawPoint\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  WritePixel(drp,X_relx+x1,X_rely+y1);
}

MakeBevel(XPoint *xp1,XPoint *xp2){
  xp1[0].x=xp1[3].x;
  xp1[0].y=xp1[3].y;
  xp1[1].x=xp1[2].x;
  xp1[1].y=xp1[2].y;
  xp1[2].x=xp2[1].x;
  xp1[2].y=xp2[1].y;
  xp1[3].x=xp2[0].x;
  xp1[3].y=xp2[0].y;
}

#define distance(x1,y1,x2,y2) (sqrt((double)(y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)))

void GetCrossing(XPoint p1,XPoint p2,XPoint p3,XPoint p4,XPoint *pRet);

void GetCrossing(p1,p2,p3,p4,pRet)
XPoint p1,p2,p3,p4,*pRet;
{
  float d1,d2;
  float ycross1,ycross2;

  assert(pRet);

  if((p2.x-p1.x)!=0){
    d1=(float)(p2.y-p1.y)/(p2.x-p1.x);
    ycross1=p1.y-p1.x*d1;
    if((p4.x-p3.x)!=0){
      d2=(float)(p4.y-p3.y)/(p4.x-p3.x);
      ycross2=p3.y-p3.x*d2;
      pRet->x=(int)((ycross2-ycross1)/(d1-d2));
      pRet->y=(int)(d1*pRet->x+ycross1);
    } else {
      pRet->x=p4.x;
      pRet->y=d1*p4.x+ycross1;
    }
  } else {
    if((p4.x-p3.x)!=0){
      d2=(float)(p4.y-p3.y)/(p4.x-p3.x);
      ycross2=p3.y-p3.x*d2;
      pRet->x=p2.x;
      pRet->y=d2*p2.x+ycross2;
    } else {
      pRet->x=p1.x;
      pRet->y=p1.y;
    }
  }

}

MakeMiter(Display *d,Drawable win,GC gc,XPoint *xp1,XPoint *xp2){
/*
  float d1,d2;
  float ycross1,ycross2;
  int xcross,ycross;
*/
  int p1=0,p2=3;
  XPoint p;

  if(distance(xp1[1].x,xp1[1].y,xp2[2].x,xp2[2].y)>
     distance(xp1[0].x,xp1[0].y,xp2[3].x,xp2[3].y)) {
       p1=2; p2=1;
     }
/*
  if((xp1[0].x-xp1[3].x)!=0){
    d1=(float)(xp1[p2].y-xp1[p1].y)/(xp1[p2].x-xp1[p1].x);
    ycross1=xp1[p1].y-xp1[p1].x*d1;
    if((xp2[0].x-xp2[3].x)!=0){
      d2=(float)(xp2[p2].y-xp2[p1].y)/(xp2[p2].x-xp2[p1].x);
      ycross2=xp2[p1].y-xp2[p1].x*d2;
      xcross=(int)((ycross2-ycross1)/(d1-d2));
      ycross=(int)(d1*xcross+ycross1);
    } else {
      xcross=xp2[p2].x;
      ycross=d1*xp2[p2].x+ycross1;
    }
  } else {
    if((xp2[0].x-xp2[3].x)!=0){
      d2=(float)(xp2[p2].y-xp2[p1].y)/(xp2[p2].x-xp2[p1].x);
      ycross2=xp2[p1].y-xp2[p1].x*d2;
      xcross=xp1[p2].x;
      ycross=d2*xp1[p2].x+ycross2;
    } else {
      xcross=xp1[1].x;
      ycross=xp1[1].y;
    }
  }
*/
  GetCrossing(xp1[p1],xp1[p2],xp2[p1],xp2[p2],&p);

  if( p2==3 ){
    xp1[0].x=xp1[3].x; xp1[0].y=xp1[3].y;
    xp1[1].x=xp1[2].x; xp1[1].y=xp1[2].y;
    xp1[2].x=xp2[0].x; xp1[2].y=xp2[0].y;
    xp1[3].x=p.x;   xp1[3].y=p.y;
  } else {
    xp1[0].x=xp1[2].x; xp1[0].y=xp1[2].y;
    xp1[1].x=p.x;   xp1[1].y=p.y;
    xp1[2].x=xp2[1].x; xp1[2].y=xp2[1].y;
    xp1[3].x=xp1[3].x; xp1[3].y=xp1[3].y;
  }
}

XDrawLine(Display  *d,Drawable win,GC gc,int x1,int y1,int x2,int y2){
  float fx,fy,px1,py1;
  int p=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawLine %d %d %d %d %d\n",win,x1,y1,x2,y2);
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if( gc->values.line_width<2 ){
    int np;
    XPoint *points;
    aPoints[p].x=x1; aPoints[p++].y=y1;
    aPoints[p].x=x2; aPoints[p++].y=y2;
    points=polygon_clip(p,aPoints,0,Polygon_Open,&np,1,1);
    if(np) polygon_draw(drp,points,np,X_relx,X_rely);
    prevgc=(GC)-1;
    if(points) free(points);
  } else {
    float vRad;
    int vHalfWidth=(int)(gc->values.line_width/2);
    vRad=distance(x1,y1,x2,y2);;
    fx=(y2-y1)/vRad;
    fy=(x2-x1)/vRad;
    px1=fx*vHalfWidth;
    py1=-fy*vHalfWidth;
    xp[0].x=x1+px1;
    xp[0].y=y1+py1;
    xp[1].x=x1-px1;
    xp[1].y=y1-py1;
    xp[2].x=x2-px1;
    xp[2].y=y2-py1;
    xp[3].x=x2+px1;
    xp[3].y=y2+py1;
    XFillPolygon(d,win,gc,xp,4,0,0);
  }
}

XDrawLines(Display *d,Drawable win,GC gc,XPoint array[],int entries,int mode)
{
  int i;
  int p=0;
  int np;
  XPoint *points;
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawLines\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);
  if(entries>vMaxEntries){
    X11Expand_Points(entries);
  }
  if(mode==CoordModeOrigin){
    aPoints[p].x=array[0].x; aPoints[p++].y=array[0].y;
/*
    if(X_relx!=0||X_rely!=0){
*/
      if( gc->values.line_width<2 ){
	for(i=1;i<entries;i++){
	  aPoints[p].x=array[i].x; aPoints[p++].y=array[i].y;
	}
	points=polygon_clip(p,aPoints,0,Polygon_Open,&np,1,1);
	if(np) polygon_draw(drp,points,np,X_relx,X_rely);
	if(points) free(points);
      } else {
	XPoint xp2[4];
	XDrawLine(d,win,gc,array[0].x,array[0].y,array[1].x,array[1].y);
	for(i=2;i<entries;i++){
	  memcpy(xp2,xp,sizeof(XPoint)*4);
	  XDrawLine(d,win,gc,array[i-1].x,array[i-1].y,array[i].x,array[i].y);
	  if(gc->values.join_style==JoinBevel){
	    MakeBevel(xp2,xp);
	  }  else if(gc->values.join_style==JoinMiter){
	    MakeMiter(d,win,gc,xp2,xp);
	  } else if(gc->values.join_style==JoinRound){
	    XFillArc(d,win,gc,array[i-1].x-(gc->values.line_width>>1),array[i-1].y-(gc->values.line_width>>1),gc->values.line_width,gc->values.line_width,0,360<<6);
	  } else
	    MakeBevel(xp2,xp);
	  if(gc->values.join_style!=JoinRound)
	    XFillPolygon(d,win,gc,xp2,4,0,0);
	}
      }
/*
    } else {
      PolyDraw(drp,entries,(WORD*)array);
    }
*/
  }else{
    int px=array[0].x,py=array[0].y;
    if( gc->values.line_width<2 ){
      for(i=0;i<entries-1;i++){
	aPoints[p].x=px; aPoints[p++].y=py;
	aPoints[p].x=px+array[i+1].x; aPoints[p++].y=py+array[i+1].y;
	px=px+array[i+1].x;
	py=py+array[i+1].y;
      }
      points=polygon_clip(p,aPoints,0,Polygon_Open,&np,1,1);
      if(np) polygon_draw(drp,points,np,X_relx,X_rely);
      if(points) free(points);
    } else {
      for(i=0;i<entries-1;i++){
	XDrawLine(d,win,gc,px,py,px+array[i+1].x,py+array[i+1].y);
	px=px+array[i+1].x;
	py=py+array[i+1].y;
      }
    }
  }
  return;
}

XFillRectangle(d,win,gc,x1,y1,w,h)
     Display *d;
     Drawable win;
     GC gc;
     int x1,y1;
     unsigned int w,h;
{
  int width=w,height=h;
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XFillRectangle\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);
/*
  printf("win %d X_relx %d X_rely %d [%d %d] [%d %d]\n",win,X_relx,X_rely,x1,y1,w,h);
*/

  if(x1+width<0||y1+height<0||x1>X_width||y1>X_height) return;
  if((int)x1<0){
    width+=x1;
    x1=0;
  }
  if((int)y1<0){
    height+=y1;
    y1=0;
  }
  if((int)(+x1+width)>=(int)X_width){
    width=X_width-x1;
    if(width<=0) return(0);
  }
  if((int)(y1+height)>=(int)X_height){
    height=X_height-y1;
    if(height<=0) return(0);
  }
  if(width<0){
    x1=x1+width;
    width=-width;
  }
  if(height<0){
    y1=y1+height;
    height=-height;
  }
  if(width<1||height<1) return;

  if( X11InternalFill ){
    int blitop=(ABC|ABNC|ANBC);
    int olddrmd;
    int oldfg,oldbg;

    X11Fit_InternalFill(width,height);
    XClearArea(d,win,x1,y1,width,height,0);
    if(!CG.bNeedClip){
      SetDrMd(drp,JAM1);
      SetAPen(drp,0);
      RectFill(&backfillrp,0,0,width-1,height-1);
    }
    else {
      BltBitMapRastPort(CG.pClipBM,0,0,&backfillrp,0,0,width,height,0xC0);
      WaitBlit();
    }
    olddrmd=drp->DrawMode;
    oldfg=drp->FgPen;
    oldbg=drp->BgPen;
    SetDrMd(drp,JAM2);
    SetAPen(drp,gc->values.foreground);
    SetBPen(drp,X11DrawablesBackground[win]);
    BltMaskBitMapRastPort(X11FillBitMap,0,0,&backfillrp2,0,0,width,height,blitop,
			  backfillrp.BitMap->Planes[0]);
    WaitBlit();
    BltPattern(drp,backfillrp2.BitMap->Planes[0],X_relx+x1,X_rely+y1,X_relx+x1+width,X_rely+y1+height,backfillrp.BitMap->BytesPerRow);
    WaitBlit();

    drp->DrawMode=olddrmd;
    drp->FgPen=oldfg;
    drp->BgPen=oldbg;
    return;
  }
  if(!CG.bNeedClip)
    RectFill(drp,X_relx+x1,X_rely+y1,X_relx+x1+width-1,X_rely+y1+height-1);
  else{
    BltBitMapRastPort(CG.pClipBM,0,0,drp,X_relx+x1,X_rely+y1,width,height,0xC0);
    WaitBlit();
  }
  return;
}

XFillRectangles(display, drawable, gc, rectangles, nrectangles)
     Display *display;
     Drawable drawable;
     GC gc;
     XRectangle *rectangles;
     int nrectangles;
{
  int i;
  for(i=0;i<nrectangles;i++)
    XFillRectangle(display,drawable,gc,rectangles[i].x,rectangles[i].y,rectangles[i].width,rectangles[i].height);
}

polygon_draw(struct RastPort *drp,XPoint *aPoints,int nPoints,int xmin,int ymin){
  int n;
  Move(drp,xmin+aPoints[0].x,ymin+aPoints[0].y);
  for( n=1;n<nPoints;n++ ){
    Draw(drp,xmin+aPoints[n].x,ymin+aPoints[n].y);
  }
}

XDrawRectangle(d,win,gc,x1,y1,w,h)
Display *d;
GC gc;
Drawable win;
int x1,y1;
unsigned int w,h;
{
  int p=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XDrawRectangle\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if( gc->values.line_width<2 ){
    int np;
    XPoint *points;
    aPoints[p].x=x1; aPoints[p++].y=y1;
    aPoints[p].x=x1; aPoints[p++].y=y1+h;
    aPoints[p].x=x1+w; aPoints[p++].y=y1+h;
    aPoints[p].x=x1+w; aPoints[p++].y=y1;
    aPoints[p].x=x1; aPoints[p++].y=y1;
    points=polygon_clip(p,aPoints,0,Polygon_Open,&np,1,1);
    if(np) polygon_draw(drp,points,np,X_relx,X_rely);
    if(points) free(points);
  } else {
    XDrawLine(d,win,gc,x1,y1,x1,y1+h);
    XDrawLine(d,win,gc,x1,y1+h,x1+w,y1+h); 
    XDrawLine(d,win,gc,x1+w,y1+h,x1+w,y1);
    XDrawLine(d,win,gc,x1+w,y1,x1,y1);
 }
  return;
}

XDrawRectangles(display, drawable, gc, rectangles, nrectangles)
     Display *display;
     Drawable drawable;
     GC gc;
     XRectangle rectangles[];
     int nrectangles;
{
  int i;
  for(i=0;i<nrectangles;i++)
    XDrawRectangle(display,drawable,gc,rectangles[i].x,rectangles[i].y,rectangles[i].width,rectangles[i].height);
}

int X11polysizex,X11polysizey;

X11FillPolygon(struct RastPort *drp,XPoint *points,int nPoints,int xmin,int ymin, char black){
  int i;
  if(black){
    SetAfPt(drp,0,0);
    SetDrMd(drp,JAM1);
    SetAPen(drp,1);
  }
  AreaMove(drp,points[0].x-xmin,points[0].y-ymin);
  for(i=1;i<nPoints;i++) 
    AreaDraw(drp,points[i].x-xmin,points[i].y-ymin);
  AreaEnd(drp);
  prevgc=(GC)-1;
}

XFillPolygon(Display *d,Drawable win,GC gc,XPoint *xp,int num,int shape,int mode){
  int clipped=0;
  int xmin,xmax,ymin,ymax;
  XPoint *points=xp;
  int np=num;
#ifdef DEBUGXEMUL_ENTRY
  printf("(drawing)XFillPolygon %d\n",num);
#endif
  if(num<1){
    printf("no entries in fill\n");
    return 0;
  }
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  if(X11check_size(win,X11polysizex,X11polysizey)) return;
  polygon_findminmax(xp,num,&xmin,&xmax,&ymin,&ymax);
  if( xmin<0 || xmax>X_width || ymin<0 || ymax>X_height ){
    points=polygon_clip(num,xp,True,Polygon_Closed,&np,1,1);
    if(!np){
      if(points) free(points);
      return;
    }
    clipped=1;
  }
  _Xfillfit(win,np);
  if( X11InternalFill ){
    X11Fit_InternalFill(xmax-xmin,ymax-ymin);
    X11FillPolygon(&backfillrp,points,np,xmin,ymin,1);
    X11ClearPattern(win,xmin,ymin,xmax-xmin,ymax-ymin,gc->values.background);
/*
    BltMaskBitMapRastPort(X11FillBitMap,0,0,drp,X_relx+xmin,X_rely+ymin,xmax-xmin,ymax-ymin,
			  (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
    WaitBlit();
*/
    SetDrMd(drp,JAM2);
    SetAPen(drp,gc->values.foreground);
    SetBPen(drp,X11DrawablesBackground[win]);
    prevgc=(GC)-1;
    BltMaskBitMapRastPort(X11FillBitMap,0,0,&backfillrp2,0,0,xmax-xmin,ymax-ymin,
			  (ABC|ABNC|ANBC),backfillrp.BitMap->Planes[0]);
    WaitBlit();
    BltPattern(drp,backfillrp2.BitMap->Planes[0],X_relx+xmin,X_rely+ymin,X_relx+xmax,X_rely+ymax,backfillrp.BitMap->BytesPerRow);
    WaitBlit();
  } else {
    X11FillPolygon(drp,points,np,-X_relx,-X_rely,0);
    prevgc=(GC)-1;
  }
  if(clipped && points) free(points);
}

XSetFunction(display, gc, function)
     Display *display;
     GC gc;
     int function;
{
/*  struct Window *win=RootWindowOfScreen(DefaultScreenOfDisplay(display));*/
#ifdef DEBUGXEMUL
  printf("(events)XSetFunction\n");
#endif
  gc->values.function=function;
/*
  if(function==GXinvert) SetDrMd(drp,COMPLEMENT);
  else SetDrMd(drp,JAM1);
*/
  prevgc=(GC)-1;
  return(0);
}

XDrawPoints(display, win, gc, points, npoints, mode)
     Display *display;
     Drawable win;
     GC gc;
     XPoint *points;
     int npoints;
     int mode;
{/*             File 'xast.o'*/
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("XDrawPoints\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);

  for(i=0;i<npoints;i++)
    WritePixel(drp,X_relx+points[i].x,X_rely+points[i].y);
/*    XDrawPoint(display,win,gc,points[i].x,points[i].y);*/
  return(0);
}

char *XGetAtomName(Display *d,Atom a){/*            File 'do_simple.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetAtomName\n");
#endif
  return(0);
}

XmuGetHostname(char *name,int length){/*          File 'x11perf.o'*/
  char *tmpstr=getenv("hostname");
#ifdef DEBUGXEMUL_ENTRY
  printf("XmuGetHostname\n");
#endif
  if(tmpstr){
    strncpy(name,tmpstr,length);
    free(tmpstr);
  }
  else strcpy(name,"Unknown");
  return(0);
}

X_GETTIMEOFDAY(struct timeval *tp){/*          File 'x11perf.o'*/
  unsigned int clock[2];
  int x=timer(clock);
#ifdef DEBUGXEMUL_ENTRY
  printf("X_GETTIMEOFDAY\n");
#endif
  if(!x){
    tp->tv_sec=clock[0];
    tp->tv_usec=clock[1];
  }else{
    tp->tv_sec=0;
    tp->tv_usec=0;
  }
  return(0);
}

int _Xdash_list[]={0xffff,0xeeee,0xf0f0,0xff00,0x5f5f}; /* have to fake it..*/
/* solid, dotted, dashed, long dashed, dot-dashed */

XSetLineAttributes(display, gc, line_width, line_style,
		   cap_style, join_style)
     Display *display;
     GC gc;
     unsigned int line_width;
     int line_style;
     int cap_style;
     int join_style;
{/*      File 'xvlib.o'*/
#ifdef DEBUGXEMUL
  printf("XSetLineAttributes style %d width %d\n",line_style,line_width);
#endif
  gc->values.line_style=line_style;
  gc->values.line_width=line_width;
  gc->values.cap_style=cap_style;
  gc->values.join_style=join_style;
  switch(line_style){
  case LineSolid: Xdash=0xffff;break;
  case LineOnOffDash: Xdash=0xaaaa;break;
  case LineDoubleDash: Xdash=0xff00;break;
  }
  prevgc=(GC)-1;
  return(0);
}

XDrawSegments(d, win, gc, segments, nsegments)
     Display *d;
     Drawable win;
     GC gc;
     XSegment *segments;
     int nsegments;
{
  int i;
#ifdef DEBUGXEMUL
  printf("XDrawSegments\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  if(gc!=prevgc) setup_gc(gc);
  if(nsegments*2>vMaxEntries){
    X11Expand_Points(nsegments*2);
  }

  if( gc->values.line_width<2 ){
    XPoint *points;
    int np;
    for(i=0;i<nsegments;i++){
      points=polygon_clip(2,(XPoint*)&segments[i],0,Polygon_Open,&np,1,1);
      if(np) polygon_draw(drp,points,np,X_relx,X_rely);
      if(points) free(points);
    }
  } else {
    for(i=0;i<nsegments;i++){
      XDrawLine(d,win,gc,segments[i].x1,segments[i].y1,segments[i].x2,segments[i].y2);
    }
  }

  return(0);
}

/* polygon clipping */

enum {
  LEFTEDGE=0,
  RIGHTEDGE,
  TOPEDGE,
  BOTTOMEDGE,
};

int new_edge[4];
XPoint aFirstPoint[4],aS[4];

boolean inside( XPoint p, int edge ){
  switch ( edge ){
  case LEFTEDGE:
    if( p.x>=0 ) return True;
    break;
  case RIGHTEDGE:
    if( p.x<=X_width ) return True;
    break;
  case TOPEDGE:
    if( p.y>=0 ) return True;
    break;
  case BOTTOMEDGE:
    if( p.y<=X_height ) return True;
    break;
  }
  return False;
}

boolean cross( XPoint p, XPoint s, int edge ){
  switch ( edge ){
  case LEFTEDGE:
/*
    if( p.y<0 && s.y < 0 || p.y>X_height && s.y>X_height ) return False;
*/
    if( p.x<0 && s.x>=0 || p.x>=0 && s.x<0 ) return True;
    break;
  case RIGHTEDGE:
/*
    if( p.y<0 && s.y < 0 || p.y>X_height && s.y>X_height ) return False;
*/
    if( p.x<X_width && s.x>=X_width || p.x>=X_width && s.x<X_width ) return True;
    break;
  case TOPEDGE:
/*
    if( p.x<0 && s.x < 0 || p.x>X_width && s.x>X_width ) return False;
*/
    if( p.y<0 && s.y>=0 || p.y>=0 && s.y<0 ) return True;
    break;
  case BOTTOMEDGE:
/*
    if( p.x<0 && s.x < 0 || p.x>X_width && s.x>X_width ) return False;
*/
    if( p.y<X_height && s.y>=X_height || p.y>=X_height && s.y<X_height ) return True;
    break;
  }
  return False;
}

XPoint *aXP;
int nOutput;

output_vertex( XPoint p ){
  aXP[nOutput++]=p;
}

XPoint find_intersection( XPoint p, XPoint s, int edge ){
  XPoint r;
  XPoint p1,p2;
/*
  float ycross;
  float d1;
  d1=(float)(p.y-s.y)/(p.x-s.x);
*/

  switch ( edge ){
  case LEFTEDGE:
    p1.x=0; p1.y=0;
    p2.x=0; p2.y=X_height;
    GetCrossing(p,s,p1,p2,&r);
/*
    r.x=0;
    r.y=p.y-p.x*d1;
*/
    break;
  case RIGHTEDGE:
    p1.x=X_width; p1.y=0;
    p2.x=X_width; p2.y=X_height;
    GetCrossing(p,s,p1,p2,&r);
/*
    r.x=X_width;
    r.y=p.y-p.x*d1+X_width*d1;
*/
    break;
  case TOPEDGE:
    p1.x=0; p1.y=0;
    p2.x=X_width; p2.y=0;
    GetCrossing(p,s,p1,p2,&r);

/*
    ycross=p.y-p.x*d1;
    r.x=-ycross/d1;
    r.y=0;
*/
    break;
  case BOTTOMEDGE:
    p1.x=0; p1.y=X_height;
    p2.x=X_width; p2.y=X_height;
    GetCrossing(p,s,p1,p2,&r);

/*
    ycross=p.y-p.x*d1;
    r.x=(X_height-ycross)/d1;
    r.y=X_height;
*/
    break;
  }
  return r;
}

void clip_this( XPoint p, int edge ){
  XPoint i;

  if( new_edge[edge]){
    aFirstPoint[edge]=p;
    new_edge[edge]=False;
  } else {
    if( cross(p,aS[edge],edge) ){
      i=find_intersection(p,aS[edge],edge);
      if( edge<3 ) clip_this(i,edge+1);
      else output_vertex(i);
    }
  }
  aS[edge]=p;
  if( inside(p,edge) )
    if( edge<3 ) clip_this(p,edge+1);
    else output_vertex(p);
}

void clip_closer(void){
  XPoint i;
  int edge;

  for( edge=0; edge<4; edge++ ){
    if( cross(aS[edge],aFirstPoint[edge],edge) ){
      i= find_intersection(aS[edge],aFirstPoint[edge],edge);
      if( edge<3 ) clip_this(i,edge+1);
      else output_vertex(i);
    }
  }
}

XPoint *polygon_clip( int nPoints,
		      XPoint *points,
		      boolean bFill,
		      int PolygonType,
		      int *nPointsReturn,
		      int move,
		      int end ){
  XPoint p;
  int n;

  nOutput=0;
  aXP=malloc(sizeof(XPoint)*nPoints*2);
  if(!aXP) X11resource_exit(DRAWING3);
  for( n=0; n<4; n++ )
    new_edge[n]=True;
  for( n=0; n<nPoints; n++ ){
    p.x=points[n].x;
    p.y=points[n].y;
    clip_this(p,0);
  }
  if( nOutput>2 && PolygonType==Polygon_Closed )
    clip_closer();

  *nPointsReturn=nOutput;
  if(!nOutput){
    free(aXP);
    return NULL;
  }
  return aXP;
}
