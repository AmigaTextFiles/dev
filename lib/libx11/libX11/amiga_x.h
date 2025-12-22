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
     amiga_x
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 3, 1996: Created.
***/

#ifndef AMIGA_X
#define AMIGA_X

#include "libx11.h"

UBYTE *Xm_init_area(Object *,int,int,int);
int isopen(Object *);
int XmSetBackground(Object *,GC,int);
int XmSetForeground(Object *,GC,int);
int XXmSetForeground(Object *,GC,int);
int XmUnmapWindow(Display *,Object *);
int XmMapRaised(Object *);
int XmFillPolygon(Display *,Object *,GC,XPoint *,int,int,int);
int XmFillRectangle(Display *,Object *,GC,int,int,unsigned int,unsigned int);
int XmFillRectangles(Display *,Object *,GC,XRectangle *,int);
int XmFillArc(Display *,Object *,GC,int,int,unsigned int,unsigned int,int,int);
int XmDrawPoint(Display *,Object *,GC,int,int);
int XmDrawString(Display *,Object *,GC,int,int,char *,int);
int XmMapRaised(Object *);
int XmCenterMapWindow(Window,int,int,int,int);
int XmDrawArc(Display *,Object *,GC,int,int,unsigned int,unsigned int,int,int);
int XmDrawLines(Display *,Object *,GC,XPoint *,int,int);
int XmDrawLine(Display *,Object *,GC,int,int,int,int);
int XmDrawRectangle(Display *,Object *,GC,int,int,unsigned int,unsigned int);
int XmDrawRectangles(Display *,Object *,GC,XRectangle *,int);

void Xm_settemp(Object *,UBYTE *);
void unclipWindow(struct Layer *);
void Xm_exit_area(Object *,UBYTE*);
void XmSetClipRectangles(Display *,Object *,GC,int,int, XRectangle *,int,int);
void XmClearWindow(Display *,Object *);
void XmSetClipMask(Object *, Pixmap);
int XmCopyArea(Display *display,Drawable src, Drawable dest,GC gc,int src_x,int src_y,unsigned int width,unsigned int height,int dest_x,int dest_y);
int XmClearArea(Display *display,Window w,GC gc,int x,int y,unsigned int width, unsigned int height,Bool exposures);

extern Object **X11DrawablesMUI;
extern struct Window **X11DrawablesWindows;
extern X11BitMap_t *X11DrawablesBitmaps;

extern void Xm_remtemp(Object *);
extern Window X11NewMUI(Object *);
extern struct Window *Agetwin(Window win);
extern void clip_end(struct Window *);
extern int check_inside_subwindows(struct Window *,int,int);
extern void X11AddExpose(Drawable,struct Window *);
extern void X11AddConfigure(Drawable,struct Window *);
extern void init_area(struct Window*,int,int,int);
extern void exit_area(struct Window*);
void showbitmap(struct BitMap *bm,int width,int height, int pos);
void X11Fit_InternalFill( int w, int h );
void X11Setup_InternalFill(Pixmap pm);

typedef struct {
  void * win_rastptr; /* PLANEPTR */
  int AWidth,AHeight,max_coords;
  WORD *coor_buf;
  struct TmpRas win_tmpras /*,*oldtmpras*/;
  struct AreaInfo win_AIstruct;
  int background;
} X11userdata;

#endif /* AMIGA_X */
