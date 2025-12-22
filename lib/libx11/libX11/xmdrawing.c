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
     these funcs uses MUI objects to draw in.
   HISTORY
     Terje Pedersen - Oct 22, 1994: Created.
***/

#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>
#include <graphics/regions.h>

#include <proto/intuition.h>
#include <proto/graphics.h>

#include <dos.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <libraries/mui.h>
#include <proto/muimaster.h>

#include "amigax_proto.h"
#include "amiga_x.h"

/*******************************************************************************************/
/* externals */

extern struct RastPort *Arp;
extern struct Window *rootwin;
extern GC      amiga_gc;
extern int X_relx,X_rely;
extern struct Screen *Scr,*wb;

extern struct Region *clipWindow(struct Layer *l,
				 LONG minX, LONG minY, LONG maxX, LONG maxY);

/*******************************************************************************************/
/* prototypes */

#include "amigax_proto.h"

#define MAX_COORD 200 /* 100 vertices, 5 bytes each = 500 bytes. */ 

typedef struct {
  void * win_rastptr; /* PLANEPTR */
  int AWidth,AHeight,max_coords;
  WORD *coor_buf;
  struct TmpRas win_tmpras /*,*oldtmpras*/;
  struct AreaInfo win_AIstruct;
  int background;
} X11userdata;

X11userdata *XMuserdata=NULL;
struct TmpRas *oldtmpras;
struct AreaInfo *oldarea;

Window XMprevwin=NULL;
GC XMprevgc=NULL;

int X11muiapp=0;

Object *_muicanvas;

UBYTE *Xm_set_area(int w,int h);

#define M_PI      3.14159265358979323846

#define rad(x) ((double)(x)*M_PI/180)

/*******************************************************************************************/
/*** functions ***/

int isopen(Object *win){
  LONG open;
/*
#ifdef DEBUGXEMUL
  printf("isopen %d\n",win);
#endif
*/
  if(win){
    if(_win(win)){
      get(_win(win),MUIA_Window_Open,&open);
      if(open) return(1);
    }
  }
  return(0);
}

int _passit=0;

struct Region *old_region;

XRectangle oldrec;

void XmSetClipRectangles(Display *d,Object *win,GC gc,int clip_x_origin,
		   int clip_y_origin, XRectangle *rectangles, int n, int ordering)
{
  int right;
  int bottom;
  
  if(_passit){XSetClipRectangles(d,gc,clip_x_origin,clip_y_origin,rectangles,n,ordering); return;}
  bottom=_mtop(win)+rectangles[0].y+rectangles[0].height-1;
  right=_mleft(win)+rectangles[0].x+rectangles[0].width-1;
#ifdef DEBUGXEMUL
  printf("XsetClipRectangles\n");
#endif
  if(bottom>_mbottom(win))bottom=_mbottom(win)-1;
  if(right>_mright(win))right=_mright(win)-1;
  if(win){
    struct Window *w=_window(win);
    if(old_region=clipWindow(w->WLayer,_mleft(win)+rectangles[0].x,_mtop(win)+rectangles[0].y,right,bottom)){
      oldrec.x=old_region->bounds.MinX;
      oldrec.y=old_region->bounds.MinY;
      oldrec.width=old_region->bounds.MaxX;
      oldrec.height=old_region->bounds.MaxY;
      DisposeRegion(old_region);
    }
  }
}

void XmSetClipMask(Object *win, Pixmap pixmap)
{
#ifdef DEBUGXEMUL
  printf("XSetClipMask\n");
#endif
  if(_passit){ XSetClipMask(win,NULL,pixmap); return;}
  if(win){
    struct Window *w=_window(win);
    unclipWindow(w->WLayer);
/*    oldrec.x=0;oldrec.y=0;oldrec.width=w->Width; oldrec.height=w->Height;
    clipWindow(w->WLayer,oldrec.x,oldrec.y,oldrec.width,oldrec.height);*/
  }
}

XmCenterMapWindow(Window win,int dx,int dy,int w,int h)
{
  Object *mwin=X11DrawablesMUI[X11DrawablesMap[win]];
#ifdef DEBUGXEMUL
  printf("CenterMapWindow\n");
#endif
  if(_passit){/*XCenterMapWindow(win,dx,dy,w,h); */return;}
  set(mwin,MUIA_Window_Open,TRUE);
  return;
}

void Xm_settemp(Object *win,UBYTE *data){
  X11userdata *ud=(X11userdata*)data;
  if(isopen(win)){
    if(_rp(win)){
      oldtmpras=(_rp(win))->TmpRas;
      oldarea=(_rp(win))->AreaInfo;
      (_rp(win))->TmpRas=&(ud->win_tmpras);
      (_rp(win))->AreaInfo = &(ud->win_AIstruct);
      _window(win)->UserData=data;
    }
  }
}

void Xm_remtemp(Object *win){
  if(isopen(win)){
    if(_rp(win)){
      _rp(win)->TmpRas=oldtmpras;
      _rp(win)->AreaInfo=oldarea;
    }
  }
}





/*
XmUnmapWindow(Display *d,Object *window){
#ifdef DEBUGXEMUL
  printf("XmUnmapWindow\n");
#endif
  if(_passit) {XUnmapWindow(d,window); return;}
  if(window!=NULL) set(window,MUIA_Window_Open,FALSE);
  return(0);
}

XmMapRaised(Object *window){
  LONG open;
#ifdef DEBUGXEMUL
  printf("XmMapWindow\n");
#endif
  if(_passit) {XMapRaised(NULL,window); return;}
  if(window) set(window,MUIA_Window_Open,TRUE);
  get(window,MUIA_Window_Open,&open);
  if(!open) return(BadWindow);
  return(0);
}
*/

XSetCanvas(Drawable win){
  _muicanvas=X11DrawablesMUI[X11DrawablesMap[win]];
}

XSetRootwin(Drawable win){
  rootwin=_window(win);
}

XSetPass(n){
  extern Window prevwin;
  extern GC prevgc;
  _passit=n;
  if(n) init_area(rootwin,MAX_COORD,DG.nDisplayWidth,DG.nDisplayHeight);
  else exit_area(rootwin);
  prevwin=NULL;
  prevgc=NULL;
  XMprevwin=NULL;
  XMprevgc=NULL;
}

XmPutImage(display, d, gc, image, src_x, src_y,
	  dest_x, dest_y, width, height)
     Display *display;
     Drawable d;
     GC gc;
     XImage *image;
     int src_x, src_y;
     int dest_x, dest_y;
     unsigned int width, height;
{
  XPutImage(display,_window(d),gc,image,src_x,src_y,_mleft(d)+dest_x,_mtop(d)+dest_y,width,height);
}

Status XmGetWindowAttributes(display, w, window_attributes_return)
     Display *display;
     Window w;
     XWindowAttributes *window_attributes_return;
{/*    File 'image_f_io.o'*/
  Window win=Agetwin(w);
#ifdef DEBUGXEMUL0
  printf("XGetWindowAttributes\n");
#endif
  XGetWindowAttributes(display,_window(w),window_attributes_return);
  return(0);
}
