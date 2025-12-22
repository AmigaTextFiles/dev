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
     windows
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 14, 1995: Created.
***/

#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

#include "libX11.h"

#define MAX_COORD 200

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include <X11/Xlibint.h>

#include <libraries/mui.h>
#include <proto/muimaster.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#undef memset

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
/*extern struct Library *AslBase;*/
extern struct Library *GadToolsBase;
extern struct Library *DiskfontBase;
extern struct Library *LayersBase;
extern struct DosLibrary *DOSBase;

extern struct Screen *Scr,*wb;
extern struct RastPort temprp,*drp;
extern GC amiga_gc;
extern int usewb,wbapp,adjx,adjy,borderadj;
extern int X_relx,X_rely,X_bottom,X_right;
extern Window prevwin;
extern GC prevgc;
extern X11userdata *Xuserdata;

int XParseGeometry(parsestring, x_return, y_return, width_return,
		   height_return)
     char *parsestring;
     int *x_return, *y_return;
     unsigned int *width_return, *height_return;
{
  int n,ret=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("XParseGeometry [%s]\n",parsestring);
#endif
  if(!parsestring) return;
  *x_return=0;
  *y_return=0;
  *width_return=0;
  *height_return=0;
  if(strchr(parsestring,'x')!=0){
    sscanf(parsestring,"%dx%d",width_return,height_return);
    ret=WidthValue|HeightValue;
  }
  if(strchr(parsestring,'+')!=0||strchr(parsestring,'-')!=0){
    ret=ret|XValue|YValue;
    sscanf(parsestring,"%dx%d%d%d",&n,&n,x_return,y_return);
  }
  return(ret);
}

int X11windepth=3;


Window XCreateWindow(display, parent, x, y, width, height,
		     border_width, depth, class, visual, valuemask,
		     attributes)
     Display *display;
     Window parent;
     int x, y;
     unsigned int width, height;
     unsigned int border_width;
     int depth;
     unsigned int class;
     Visual *visual;
     unsigned long valuemask;
     XSetWindowAttributes *attributes;
{
  int bg=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreateWindow\n");
#endif
  if(attributes) bg=attributes->background_pixel;
  X11windepth=depth;
  return(XCreateSimpleWindow(display,parent,x,y,width,height,border_width,1,bg));
}

Window XCreateSimpleWindow(display, parent, x, y, width, height,
			   border_width, border, background)
     Display *display;
     Window parent;
     int x, y;
     unsigned int width, height, border_width;
     unsigned long border;
     unsigned long background;
{
/*  struct Window *win;*/
  Window newwin;
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XCreateSimpleWindow %d %d %d %d\n",x,y,width,height);
#endif
  wbapp=1;
  if(border_width==0) border=0;
  if(!Scr) Scr=wb;
  if(parent==ROOTID){
    if(width>Scr->Width||height>Scr->Height||X11windepth>Scr->RastPort.BitMap->Depth){ 
      int i,nXMax=0,nYMax=0;
      /*asking for a bigger window than wb can handle */
      wbapp=0;
      for(i=0;i<X11NumDrawablesWindows;i++)
	if(X11ActualWindows[i].mapped){
	  XUnmapWindow(NULL,X11ActualWindows[i].win);
	  if(X11ActualWindows[i].width>nXMax) nXMax=X11ActualWindows[i].width;
	  if(X11ActualWindows[i].height>nYMax) nYMax=X11ActualWindows[i].height;
	  X11ActualWindows[i].mapped=2;
	}
      if(AmigaCreateWindow(max(width,nXMax),max(height,nYMax),DG.nDisplayDepth,0,0)){
	return(0);
      }
      for(i=0;i<X11NumDrawablesWindows;i++)
	if(X11ActualWindows[i].mapped==2){
	  XMapWindow(NULL,X11ActualWindows[i].win);
	}
      wbapp=0;usewb=0;
    }
  }
  else{
    int new=0,i,newid;
    for(i=1;i<=DG.nNumChildren;i++){
      if(X11DrawablesChildren[i].deleted&&i>parent){ /* use this as new window */
	new=i; break;
      }
    }
    if(!new){
      new=++DG.nNumChildren;
      newid=X11NewSubWindow(new);
    } else
      newid=X11OldSubWindow(new);
      
    XSelectInput(display,newid,0xffffff);
    if(X11Drawables[parent]==X11SUBWINDOW){
      X11DrawablesChildren[new].x=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[parent]]].x+x;
      X11DrawablesChildren[new].y=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[parent]]].y+y;
    } else{
      X11DrawablesChildren[new].x=x;
      X11DrawablesChildren[new].y=y;
    }
    X11DrawablesChildren[new].width=width;
    X11DrawablesChildren[new].height=height;
    X11DrawablesChildren[new].border=border;
    X11DrawablesChildren[new].deleted=0;
    X11DrawablesChildren[new].parent=parent;
    X11DrawablesChildren[new].id=newid;
    X11DrawablesMask[newid]=X11DrawablesMask[parent];
    X11DrawablesBackground[newid]=background;
    DG.bSubWins=1;
    return((Window)newid);
  }
  newwin=X11NewWindow(0);
  if(width>wb->Width)width=wb->Width;
  if(height>wb->Height)height=wb->Height;

/*  init_backrp(Scr->Width,Scr->Height,Scr->RastPort.BitMap->Depth);*/

  X11ActualWindows[X11DrawablesMap[newwin]].x=x;
  X11ActualWindows[X11DrawablesMap[newwin]].y=y;
  X11ActualWindows[X11DrawablesMap[newwin]].width=width;
  X11ActualWindows[X11DrawablesMap[newwin]].height=height;
  X11ActualWindows[X11DrawablesMap[newwin]].win=newwin;
  X11ActualWindows[X11DrawablesMap[newwin]].parent=ROOTID;
  X11ActualWindows[X11DrawablesMap[newwin]].pixmap=0;
  X11DrawablesBackground[newwin]=background;
  /*XCreatePixmap(display,NULL,width,height,8);
  if(!Xuserdata)
    init_area(wb->FirstWindow,100,width,height);*/
  XSelectInput(display,newwin,0xffffff);
  X11init_cmaps();
  return(newwin);
}

XDestroyWindow(display, win)
     Display *display;
     Window win;
{/*          File 'grafikk.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XDestroyWindow [%d]\n",(int)win);
#endif
  /*  set(X11App->Root,OM_REMMEMBER,obj);*/
  if(X11Drawables[win]==X11SUBWINDOW){ /* this is a child */
    X11DrawablesChildren[X11DrawablesMap[win]].deleted=1;
    clear_subwin(win,0,0);
  }else{
/*    struct Window *w=X11DrawablesWindows[X11DrawablesMap[win]];*/
    int i;
    if(X11ActualWindows[X11DrawablesMap[win]].mapped)XUnmapWindow(display,win);
    X11DrawablesWindows[X11DrawablesMap[win]]=NULL;
    for(i=0;i<DG.nNumChildren;i++){
      if(X11DrawablesChildren[i].parent==win)
	X11DrawablesChildren[i].deleted=1;
    }
  }
  return(0);
}

extern int XSetBackground(Display *,GC,unsigned long);
extern int XSetForeground(Display *,GC,unsigned long);
extern int XDrawRectangle(Display *,Drawable,GC,int,int,unsigned int,unsigned int);


XMapRaised(display, w)
     Display *display;
     Window w;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XMapRaised\n");
#endif
  if(X11Drawables[w]==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[w]];
    XSetForeground(display,amiga_gc,X11DrawablesChildren[child].border);
    XSetBackground(display,amiga_gc,X11DrawablesBackground[child]);
    XClearArea(display,X11findparent(w), /*amiga_gc,*/
		   X11DrawablesChildren[child].x,
		   X11DrawablesChildren[child].y,
		   X11DrawablesChildren[child].width-1,
		   X11DrawablesChildren[child].height-1,0);
    XMapWindow(display,w);
  } else if (X11Drawables[w]==X11MUI){
    LONG open;
    Object *mwin=X11DrawablesMUI[X11DrawablesMap[w]];
    set(mwin,MUIA_Window_Open,TRUE);
    get(mwin,MUIA_Window_Open,&open);
    if(!open) return(BadWindow);
    return 0;
  }else {
    XMapWindow(display,w);
    ActivateWindow(X11DrawablesWindows[X11DrawablesMap[w]]);
    EG.nEventDrawable=w;
  }
  X11AddInternalEvent(w,VisibilityNotify,sizeof(XVisibilityEvent));
  X11AddInternal(w,VisibilityNotify,sizeof(XVisibilityEvent));
  return(0);
}

XUnmapWindow(display, w)
     Display *display;
     Window w;
{
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XUnmapWindow %d\n",w);
#endif
  prevwin=-1;
  prevgc=(GC)-1;
  if (X11Drawables[w]==X11MUI){
    Object *mwin=X11DrawablesMUI[X11DrawablesMap[w]];
    set(mwin,MUIA_Window_Open,FALSE);
    return 0;
  } 
  if(X11Drawables[w]==X11SUBWINDOW){
    int parent=X11findparent(w);
/*    printf("exposing parent %d\n",parent);*/
    clear_subwin(w,1,X11DrawablesBackground[w]);
    X11AddExpose(parent,X11DrawablesWindows[X11DrawablesMap[parent]]);
    return; /* subwindow */
  }
  if(!X11ActualWindows[X11DrawablesMap[w]].mapped) return;
  X11AddInternalEvent(w,UnmapNotify,sizeof(XUnmapEvent));
/*  X11AddInternal(w,UnmapNotify,sizeof(XUnmapEvent));*/
  unclipWindow(X11DrawablesWindows[X11DrawablesMap[w]]->WLayer);
  CG.pPreviousLayer=NULL;
#if 0
  exit_area(X11DrawablesWindows[X11DrawablesMap[w]]);
#endif
  CloseWindow(X11DrawablesWindows[X11DrawablesMap[w]]);
  X11ActualWindows[X11DrawablesMap[w]].mapped=0;
  EG.fwindowsig=0;
  for(i=0;i<X11NumDrawablesWindows;i++)
    if(X11ActualWindows[i].mapped) EG.fwindowsig|=(1<<X11DrawablesWindows[i]->UserPort->mp_SigBit);
  X11DrawablesWindows[X11DrawablesMap[w]]=NULL;

  return(0);
}

XMapWindow(d, win)
     Display *d;
     Window win;
{
  extern char *LibX11Info;
  struct Window *Win;
  int i,x,y,width,height,background;

#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XMapWindow %d\n",win);
#endif

  X11AddInternalEvent(win,MapNotify,sizeof(XMapEvent));
  if (X11Drawables[win]==X11SUBWINDOW) {
    int x,y,w,h;
/*    int parent=X11findparent(w);*/
/*    if(!X11ActualWindows[X11DrawablesMap[parent]].mapped)
      printf("and parent is not mapped..\n");*/
    X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].mapped=1;
    Win=X11DrawablesWindows[X11DrawablesMap[win]];
    drp=setup_win(X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].parent);
    x=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].x-1;
    y=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].y-1;
    w=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].width+2;
    h=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].height+2;
    if(X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].border){
      SetAPen(drp,X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].border);
      Move(drp,X_relx+x,X_rely+y);
      Draw(drp,X_relx+x+w,X_rely+y);
      Draw(drp,X_relx+x+w,X_rely+y+h);
      Draw(drp,X_relx+x,X_rely+y+h);
      Draw(drp,X_relx+x,X_rely+y);
    }
    prevgc=(GC)-1;
    X11AddExpose(win,NULL);
    for(i=1;i<=DG.nNumChildren;i++)
      if(!X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].parent==win)
	XMapWindow(d,X11DrawablesChildren[i].id);
/*
    X11AddConfigure(w,NULL);
*/
    return;
  }
  if(X11ActualWindows[X11DrawablesMap[win]].mapped==1){
    return;
/*    XUnmapWindow(display,w);*/
  }
  {
    int parent=X11findparent(win);
    if(parent!=win && parent!=0 && !X11ActualWindows[X11DrawablesMap[parent]].mapped){
      X11ActualWindows[X11DrawablesMap[win]].mapped=4;
      return;
    }
  }

  x=X11ActualWindows[X11DrawablesMap[win]].x;
  y=X11ActualWindows[X11DrawablesMap[win]].y;
  width=X11ActualWindows[X11DrawablesMap[win]].width;
  height=X11ActualWindows[X11DrawablesMap[win]].height;
  background=X11DrawablesBackground[win];

  {
  }
  X11ActualWindows[X11DrawablesMap[win]].mapped=1;
  if (!(Win = 
	OpenWindowTags(NULL,
		       WA_Left,x,WA_Top,y,
		       WA_InnerWidth,width,WA_InnerHeight,height,
		       WA_MaxWidth,DG.nDisplayMaxWidth,WA_MaxHeight,DG.nDisplayMaxHeight,
		       WA_DetailPen,1,WA_BlockPen,0,
		       WA_IDCMP,IDCMP_CHANGEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_ACTIVEWINDOW|
		       IDCMP_NEWSIZE|IDCMP_RAWKEY|IDCMP_INACTIVEWINDOW|IDCMP_MOUSEMOVE|
		       IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW,
		       WA_Flags, WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SMART_REFRESH
		       |WFLG_REPORTMOUSE|WFLG_RMBTRAP,
		       WA_ScreenTitle,	"X11",
		       WA_CustomScreen, Scr,
		       TAG_DONE ))) return(NULL);
  
  if(!X11DrawablesWindows[X11DrawablesMap[win]]){
    adjx=Win->BorderLeft+Win->BorderRight;
    adjy=Win->BorderTop+Win->BorderBottom;
    if(borderadj==0)borderadj=1;
  }
  EG.fwindowsig=0;
  X11DrawablesWindows[X11DrawablesMap[win]]=Win;
  for(i=0;i<X11NumDrawablesWindows;i++)
    if(X11ActualWindows[i].mapped==1) EG.fwindowsig|=(1<<X11DrawablesWindows[i]->UserPort->mp_SigBit);

/*
  amiga_screen[0].root=w;
*/
  X11DrawablesChildren[0].id=ROOTID;
  if(!Xuserdata)
    init_area(Win,MAX_COORD,Win->Width,Win->Height);
  SetRast(Win->RPort,background);

/*
  XCopyArea(display,X11ActualWindows[X11DrawablesMap[w]].pixmap,w,amiga_gc,0,0,width,height,0,0);
*/

  RefreshWindowFrame(Win);
  SetBackground(background);

  X11AddExpose(win,Win);
/*
  X11AddConfigure(w,win);
*/
  X11AddInternal(win,VisibilityNotify,sizeof(XVisibilityEvent));

  SetWindowTitles(Win,X11ActualWindows[X11DrawablesMap[win]].name,LibX11Info);

  for(i=1;i<=DG.nNumChildren;i++)
    if(!X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].parent==win)
      XMapWindow(d,X11DrawablesChildren[i].id);
  return(0);
}

XStoreName(display,w,window_name)
     Display *display;
     Window w;
     char *window_name;
{
  struct Window *win;
#ifdef DEBUGXEMUL_ENTRY
  printf("XStoreName [%s]\n",window_name);
#endif
  if(X11Drawables[w]!=X11WINDOW) return; /* not window */
  X11ActualWindows[X11DrawablesMap[w]].name=window_name;
  if(X11ActualWindows[X11DrawablesMap[w]].mapped){
    win=X11DrawablesWindows[X11DrawablesMap[w]];
    SetWindowTitles(win,X11ActualWindows[X11DrawablesMap[w]].name,LibX11Info);
  }
  return(0);
}

XResizeWindow(display, win, width, height)
     Display *display;
     Window win;
     unsigned int width, height;
{
  struct Window *w;
#ifdef DEBUGXEMUL_ENTRY
  printf("XResizeWindow to [%d,%d]\n",width,height);
#endif
  X11AddExpose(win,NULL);
  if(X11Drawables[win]==X11SUBWINDOW){
    X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].width=width;
    X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].height=height;
    return;
  }
  if(X11Drawables[win]==X11BITMAP) {
#ifdef DEBUGX11BITMAP
    printf("resize bitmap with XResizeWindow?\n"); 
#endif
    return;
  }

  X11ActualWindows[X11DrawablesMap[win]].width=width;
  X11ActualWindows[X11DrawablesMap[win]].height=height;
  w=X11DrawablesWindows[X11DrawablesMap[win]];
  if(!w) return 0;
  if(temprp.BitMap) free_bitmap(temprp.BitMap);
  else InitRastPort(&temprp);
  temprp.BitMap=alloc_bitmap((width+16),1,DG.nDisplayDepth,BMF_CLEAR);
  ChangeWindowBox(w,w->LeftEdge,w->TopEdge,width+w->BorderLeft+w->BorderRight,
		  height+w->BorderTop+w->BorderBottom);

  SetRast(w->RPort,(UBYTE)X11DrawablesBackground[win]);
  return(0);
}

Status XGetWindowAttributes(display, win, window_attributes_return)
     Display *display;
     Window win;
     XWindowAttributes *window_attributes_return;
{/*    File 'image_f_io.o'*/
  struct Window *w;
#ifdef DEBUGXEMUL_ENTRY
  printf("XGetWindowAttributes\n");
#endif
  if(X11Drawables[win]==X11SUBWINDOW) return;
  if(X11Drawables[win]==X11BITMAP) {
#ifdef DEBUGX11BITMAP
    printf("XGetWindowAttributes to bitmap?\n"); 
#endif
    return;
  }
  if(X11Drawables[win]==X11WINDOW)
    w=X11DrawablesWindows[X11DrawablesMap[win]];
  else if(X11Drawables[win]==X11MUI)
    w=_window(X11DrawablesMUI[X11DrawablesMap[win]]);

  if(!w) return 0;
  window_attributes_return->x=w->LeftEdge+w->BorderLeft;
  window_attributes_return->y=w->TopEdge+w->BorderTop;
  window_attributes_return->depth=w->RPort->BitMap->Depth;
  window_attributes_return->width=w->Width-(w->BorderLeft+w->BorderRight);
  window_attributes_return->height=w->Height-(w->BorderTop+w->BorderBottom);
  window_attributes_return->border_width=0;
  return(1);
}

XConfigureWindow(display, w, value_mask, values)
     Display *display;
     Window w;
     unsigned int value_mask;
     XWindowChanges *values;
{
  struct Window *win;
#ifdef DEBUGXEMUL_ENTRY
  printf("ConfigureWindow %d\n",w);
#endif

  if(X11Drawables[w]==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[w]];
    X11DrawablesChildren[child].x=values->x;
    X11DrawablesChildren[child].y=values->y;
    X11DrawablesChildren[child].width=values->width;
    X11DrawablesChildren[child].height=values->height;
    X11AddConfigure(w,NULL);
    X11AddExpose(w,NULL);
    return;
  }
  if(X11Drawables[w]==X11BITMAP){
    return;
  }
  if(value_mask&CWX) X11ActualWindows[X11DrawablesMap[w]].x=values->x;
  if(value_mask&CWY) X11ActualWindows[X11DrawablesMap[w]].y=values->y;
  if(value_mask&CWWidth) X11ActualWindows[X11DrawablesMap[w]].width=values->width;
  if(value_mask&CWHeight) X11ActualWindows[X11DrawablesMap[w]].height=values->height;
  win=X11DrawablesWindows[X11DrawablesMap[w]];
  if(!win) return 0;
  ChangeWindowBox(win,
		  X11ActualWindows[X11DrawablesMap[w]].x,
		  X11ActualWindows[X11DrawablesMap[w]].y,
		  X11ActualWindows[X11DrawablesMap[w]].width+win->BorderLeft+win->BorderRight,
		  X11ActualWindows[X11DrawablesMap[w]].height+win->BorderTop+win->BorderBottom);

  X11AddConfigure(w,win);
  X11AddExpose(w,win);
  return(0);
}

XSetWindowBorder(display, w, border_pixel)
     Display *display;
     Window w;
     unsigned long border_pixel;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetWindowBorder\n");
#endif
  return 0;
}

XClearArea(display, win, x, y, width, height, exposures)
     Display *display;
     Window win;
     int x, y;
     unsigned int width, height;
     Bool exposures;
{
  int endx,endy;
  int oldfg,olddrmd;
#ifdef DEBUGXEMUL_ENTRY
  printf("XClearArea\n");
#endif
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  endx=x+width-1;
  endy=y+height-1;
  oldfg=drp->FgPen;
  olddrmd=drp->DrawMode;
  if(X11Drawables[win]==X11MUI){
    Object *w=X11DrawablesMUI[X11DrawablesMap[win]];
    SetAPen(_rp(w),_dri(w)->dri_Pens[BACKGROUNDPEN]);
  }
  else SetAPen(drp,X11DrawablesBackground[win]);
  SetDrMd(drp,JAM1);
  if(width==0) endx=X_right;
  if(height==0) endy=X_bottom;
  RectFill(drp,X_relx+x,X_rely+y,X_relx+endx,X_rely+endy);
  drp->DrawMode=olddrmd;
  drp->FgPen=oldfg;
  return(0);
}

extern int XSetClipMask(Display *,GC,Pixmap);

XClearWindow(display, w)
     Display *display;
     Window w;
{
  extern int usewb,wbapp,adjx,adjy;
  struct Window *win;
#ifdef DEBUGXEMUL_ENTRY
  printf("XClearWindow\n");
#endif
  if(w!=prevwin) if(!(drp=setup_win(w))) return;
  if(X11Drawables[w]==X11SUBWINDOW) { /* subwindow */
    int child=X11DrawablesSubWindows[X11DrawablesMap[w]];
    clear_subwin(w,1,X11DrawablesBackground[child]);
  }else if(X11Drawables[w]==X11WINDOW) {
    int i;
    win=Agetwin(w);
    prevwin=-1;
    if(!win) return;
    if(usewb||wbapp)
      clip_begin(win->LeftEdge+win->BorderLeft,win->TopEdge+win->BorderTop,win->Width-adjx,win->Height-adjy);
    else
      clip_begin(win->LeftEdge,win->TopEdge,win->Width,win->Height);
    /* and exclude all subwins */
    for(i=1;i<=DG.nNumChildren;i++)
      if(!X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].parent==w)
	clip_exclude(X11DrawablesChildren[i].x,X11DrawablesChildren[i].y,X11DrawablesChildren[i].width-1,X11DrawablesChildren[i].height-1);
    clip_end(win);
    SetAPen(win->RPort,(UBYTE)X11DrawablesBackground[w]);
    SetBPen(win->RPort,(UBYTE)0);
    SetDrMd(win->RPort,JAM1);
    RectFill(win->RPort,win->LeftEdge,win->TopEdge,win->Width,win->Height);
    XSetClipMask(display,amiga_gc,None);
    prevwin=-1;
  } else if(X11Drawables[w]==X11MUI) {
    Object *mwin=X11DrawablesMUI[X11DrawablesMap[w]];
    if(!isopen(mwin)) return;
    SetAPen(_rp(mwin),_dri(mwin)->dri_Pens[BACKGROUNDPEN]);
    SetDrMd(_rp(mwin),JAM1);
    RectFill(_rp(mwin),_mleft(mwin),_mtop(mwin),_mright(mwin),_mbottom(mwin));
  } else if(X11Drawables[w]==X11BITMAP) {
    /* X11ClearArea */
    XClearArea(display,w,0,0,
		 X11DrawablesBitmaps[X11DrawablesMap[w]].width,
		 X11DrawablesBitmaps[X11DrawablesMap[w]].height,0);
  }
  prevgc=(GC)-1;
}

XDestroySubwindows(display, w)
     Display *display;
     Window w;
{/*      File 'x11perf.o'*/
  int i;
#if (DEBUGXEMUL_ENTRY)
  printf("XDestroySubwindows\n");
#endif

  for(i=0;i<DG.nNumChildren;i++)
    if(X11DrawablesChildren[i].parent==w)
      XDestroyWindow(display,X11DrawablesChildren[i].id);
  return(0);
}

XSetScreenSaver(display, timeout, interval,
		prefer_blanking, allow_exposures)
     Display *display;
     int timeout, interval;
     int prefer_blanking;
     int allow_exposures;
{/*         File 'x11perf.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetScreenSaver\n");
#endif
  return(0);
}

XForceScreenSaver(display, mode)
     Display *display;
     int mode;
{/*       File 'x11perf.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
/*  printf("WARNING: XForceScreenSaver\n");*/
#endif
  return(0);
}

XMapSubwindows(display, w)
     Display *display;
     Window w;
{
  int i;
#if (DEBUGXEMUL_ENTRY)
  printf("XMapSubwindows %d\n",w);
#endif
  
  for(i=0;i<DG.nNumChildren;i++)
    if(X11DrawablesChildren[i].parent==w)
      XMapWindow(display,X11DrawablesChildren[i].id);
  return(0);
}

/*int XSynchronize(Display *d,Bool b){/*            File 'x11perf.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XSynchronize\n");
#endif
  return(0);
}*/

XChangeProperty(display, w, property, type, format, mode,
		data, nelements)
     Display *display;
     Window w;
     Atom property, type;
     int format;
     int mode;
     unsigned char *data;
     int nelements;
{/*         File 'do_simple.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XChangeProperty\n");
#endif
  return(0);
}

XMoveWindow(display, win, x, y)
     Display *display;
     Window win;
     int x, y;
{/*             File 'do_movewin.o'*/
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("XMoveWindow\n");
#endif
  if(X11Drawables[win]==X11SUBWINDOW){ /* subwindow */
    int w=X11DrawablesSubWindows[X11DrawablesMap[win]];
    X11DrawablesChildren[w].x=x;
    X11DrawablesChildren[w].y=y;
    X11AddExpose(win,NULL);
  } else {
    X11ActualWindows[X11DrawablesMap[win]].x=x;
    X11ActualWindows[X11DrawablesMap[win]].y=y;
    X11AddExpose(win,X11DrawablesWindows[X11DrawablesMap[win]]);
  }
  for(i=0;i<DG.nNumChildren;i++)
    if(X11DrawablesChildren[i].parent==win){
      X11AddExpose(win,NULL);
    }
  
  return(0);
}

XGetScreenSaver(display, timeout_return, interval_return,
		prefer_blanking_return, allow_exposures_return)
     Display *display;
     int *timeout_return, *interval_return;
     int *prefer_blanking_return;
     int *allow_exposures_return;
{/*         File 'x11perf.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetScreenSaver\n");
#endif
  return(0);
}

char *XDisplayName(char *name){/*            File 'x11perf.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDisplayName\n");
#endif
  return(0);
}

Status XQueryBestSize(display, class, which_screen, width,
		      height, width_return, height_return)
     Display *display;
     int class;
     Drawable which_screen;
     unsigned int width, height;
     unsigned int *width_return, *height_return;
{/*          File 'x11perf.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XQueryBestSize\n");
#endif
  return(0);
}

XCirculateSubwindows(display, w, direction)
     Display *display;
     Window w;
     int direction;
{/*    File 'do_movewin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XCirculateSubwindows\n");
#endif
  return(0);
}

int XWMGeometry(display, screen, user_geom, def_geom, bwidth_return,
		hints, x_return, y_return, width_return, height_return,
		gravity_return)
     Display *display;
     int screen;
     char *user_geom;
     char *def_geom;
     unsigned int bwidth_return;
     XSizeHints *hints;
     int *x_return, *y_return;
     int *width_return, *height_return;
     int *gravity_return;
{/*             File 'magick/libMagick.lib' */
  XWindowAttributes xattr;
#ifdef DEBUGXEMUL_ENTRY
  printf("XWMGeometry\n");
#endif
  XGetWindowAttributes(display,RootWindow(display,screen),&xattr);
  *x_return=xattr.x;
  *y_return=xattr.y;
  *width_return=xattr.width;
  *height_return=xattr.height;
  *gravity_return=0;
  return(0);
}

void XSetWMProperties(display, w, window_name, icon_name, argv, argc,
		      normal_hints, wm_hints, class_hints)
     Display *display;
     Window w;
     XTextProperty *window_name;
     XTextProperty *icon_name;
     char **argv;
     int argc;
     XSizeHints *normal_hints;
     XWMHints *wm_hints;
     XClassHint *class_hints;
{/*        File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetWMProperties [%d,%d]\n",normal_hints->width,normal_hints->height);
#endif
  X11ActualWindows[X11DrawablesMap[w]].name=window_name->value;
  if(normal_hints){
    X11ActualWindows[X11DrawablesMap[w]].x=normal_hints->x;
    X11ActualWindows[X11DrawablesMap[w]].y=normal_hints->y;
  }
  return;
}

Status XWithdrawWindow(display, w, screen_number)
     Display *display;
     Window w;
     int screen_number;
{/*         File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XWithdrawWindow\n");
#endif
  XUnmapWindow(display,w);
  return(0);
}

void XSetWMName(display,w,text_prop)
     Display *display;
     Window w;
     XTextProperty *text_prop;
{/*              File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetWMName\n");
#endif
  X11ActualWindows[X11DrawablesMap[w]].name=text_prop->value;
  return;
}

XGetWMName(display,w,text_prop_return)
     Display *display;
     Window w;
     XTextProperty *text_prop_return;
{/*              File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetWMName\n");
#endif
  text_prop_return->value=X11ActualWindows[X11DrawablesMap[w]].name;
  return(0);
}

Status XReconfigureWMWindow(display, w, screen_number, value_mask, values)
     Display *display;
     Window w;
     int screen_number;
     unsigned int value_mask;
     XWindowChanges *values;
{/*    File 'magick/libMagick.lib' */
  _ActualWindow *aw;
  XWindowChanges xwc;
#ifdef DEBUGXEMUL_ENTRY
  printf("XReconfigureWMWindow\n");
#endif
  if(X11Drawables[w]!=X11WINDOW) return; /* not window */
  aw=&X11ActualWindows[X11DrawablesMap[w]];
  if(value_mask&CWX) aw->x=values->x;
  if(value_mask&CWY) aw->y=values->y;
  if(value_mask&CWWidth) aw->width=values->width;
  if(value_mask&CWHeight) aw->height=values->height;
  if (aw->x+aw->width>wb->Width){
    aw->x=wb->Width-aw->width;
  }
  if (aw->y+aw->height>wb->Height){
    aw->y=wb->Height-aw->height;
  }
  xwc.x=aw->x; xwc.y=aw->y; xwc.width=aw->width; xwc.height=aw->height;
  if(X11ActualWindows[X11DrawablesMap[w]].mapped)
    XConfigureWindow(display,w,CWX|CWY|CWWidth|CWHeight,&xwc);
  return(0);
}

XWMHints *XAllocWMHints()
{/*           File 'animate.o' */
  XWMHints *xwmh=malloc(sizeof(XWMHints));
#ifdef DEBUGXEMUL
  printf("XAllocWMHints\n");
#endif
  List_AddEntry(pMemoryList,(void*)xwmh);
  if(!xwmh) X11resource_exit(WINDOW4);
  return(xwmh);
}

Window XDefaultRootWindow(Display *d){/*      File 'w_util.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XDefaultRootWindow\n");
#endif
  return(RootWindowOfScreen(DefaultScreenOfDisplay(d)));
}

XMoveResizeWindow(display, w, x, y, width, height)
     Display *display;
     Window w;
     int x, y;
     unsigned int width, height;
{/*       File 'xvscrl.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XMoveResizeWindow\n");
#endif
  XMoveWindow(display,w,x,y);
  XResizeWindow(display,w,width,height);
  return(0);
}

Status XQueryTree(display, w, root_return, parent_return,
		  children_return, nchildren_return)
     Display *display;
     Window w;
     Window *root_return;
     Window *parent_return;
     Window **children_return;
     unsigned int *nchildren_return;
{
  int i;
  int childrens=0;
#ifdef DEBUGXEMUL_ENTRY
  printf("XQueryTree\n");
#endif

  *children_return=NULL;
  *nchildren_return=0;
  *root_return=DefaultRootWindow(display);
  if( w==ROOTID||w==1 )
    *parent_return=ROOTID;
/*
    return 0;
*/
  else
    *parent_return=X11findparent(w);
/*
  if(w==*parent_return)
    *parent_return=ROOTID;
*/
  for(i=1;i<=DG.nNumChildren;i++)
    if(!X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].parent==w)
      childrens++;

  *nchildren_return=childrens;
  if(childrens){
    Window *aWins;
    int n=0;
    aWins=(Window*)malloc(sizeof(Window)*(childrens));
    List_AddEntry(pMemoryList,(void*)aWins);
    for(i=1;i<=DG.nNumChildren;i++)
      if(!X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].parent==w)
	aWins[n++]=(Window)X11DrawablesChildren[i].id;
    *children_return=aWins;
  }
  if(!childrens && w==ROOTID){
    Window *aWins;
    int n=0;
    aWins=(Window*)malloc(sizeof(Window)*(X11NumDrawablesWindows));
    List_AddEntry(pMemoryList,(void*)aWins);
    for(i=0;i<X11NumDrawablesWindows;i++)
      if(X11ActualWindows[i].parent==ROOTID){
	aWins[n++]=(Window)X11ActualWindows[i].win;
      }
    *children_return=aWins;
  }
  return(1);
}

Status XGetGeometry(display, drawable, root_return, x_return,y_return,
		    width_return, height_return, border_width_return,depth_return)
     Display *display;
     Drawable drawable;
     Window *root_return;
     int *x_return, *y_return;
     unsigned int *width_return, *height_return;
     unsigned int *border_width_return;
     unsigned int *depth_return;
{/*            File 'xvgrab.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XGetGeometry\n");
#endif
  if(border_width_return) *border_width_return=1;
  if(X11Drawables[drawable]==X11WINDOW){
    struct Window *win=X11DrawablesWindows[X11DrawablesMap[drawable]];
    if(!win) return 0;
    *width_return=win->Width-(win->BorderLeft+win->BorderRight);;
    *height_return=win->Height-(win->BorderTop+win->BorderBottom);
    *depth_return=win->RPort->BitMap->Depth;
    *x_return=win->LeftEdge;
    *y_return=win->TopEdge;
  } else if(X11Drawables[drawable]==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[drawable]];
    int parent=X11findparent(drawable);
    struct Window *w=X11DrawablesWindows[X11DrawablesMap[parent]];

    *width_return=X11DrawablesChildren[child].width;
    *height_return=X11DrawablesChildren[child].height;
    *x_return=w->BorderLeft+X11DrawablesChildren[child].x;
    *y_return=w->BorderTop+X11DrawablesChildren[child].y;
  } else if(X11Drawables[drawable]==X11BITMAP){
/*
    struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[drawable]].pBitMap;
*/
    *x_return=0;
    *y_return=0;
    *width_return=X11DrawablesBitmaps[X11DrawablesMap[drawable]].width;
    *height_return=X11DrawablesBitmaps[X11DrawablesMap[drawable]].height;
    *border_width_return=0;
    *depth_return=X11DrawablesBitmaps[X11DrawablesMap[drawable]].depth;
  } else if(X11Drawables[drawable]==X11MUI){
  } 
  return(TRUE);
}

XRaiseWindow(display, w)
     Display *display;
     Window w;
{/*            File 'xvtext.o' */
  XEvent event;
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XRaiseWindow\n");
#endif
  event.type=ConfigureNotify;
  event.xconfigure.window=w;
  if (X11Drawables[w]==X11SUBWINDOW) {
    event.xconfigure.width=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[w]]].width;
    event.xconfigure.height=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[w]]].height;
    event.xconfigure.x=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[w]]].x;
    event.xconfigure.y=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[w]]].y;
  } else {
    event.xconfigure.width=X11ActualWindows[X11DrawablesMap[w]].width;
    event.xconfigure.height=X11ActualWindows[X11DrawablesMap[w]].height;
    event.xconfigure.x=X11ActualWindows[X11DrawablesMap[w]].x;
    event.xconfigure.y=X11ActualWindows[X11DrawablesMap[w]].y;
    WindowToFront(X11DrawablesWindows[X11DrawablesMap[w]]);
  }
  X11NewInternalXEvent(&event,sizeof(XConfigureEvent));

  return(0);
}

shift[]={13,10,7,12,9,6,11,8};

__stdargs unsigned long  XGet_pixel(struct _XImage*,int,int);

__stdargs unsigned long  XGet_pixel(struct _XImage *xim,int x,int y){
  int bit;
  unsigned char *byte;
  if(xim->bitmap_bit_order==LSBFirst){
    switch(xim->depth){
    case 1:
      byte=(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=(*byte)&((128>>(x%8)));
      break;
    case 3: {
      short *byte;
      int  pos=(int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;
      byte=(short*)(xim->data+y*xim->bytes_per_line+pos);
      bit=*byte&(7<<shift[x % 8]);
      } break;
    case 4:
      byte=xim->data+y*xim->bytes_per_line+(x>>1);
      bit=*byte&(15<<((x%2)*4));
    case 8:
      byte=(xim->data+y*xim->bytes_per_line+x);
      bit=*byte;
      break;
    }

/*
    if(xim->depth==1){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=byte&(1<<(x%8));
    }
    else{
      int byte=*(xim->data+y*xim->bytes_per_line+x);
      bit=byte;
    }
*/
  }
  else{
    switch(xim->depth){
    case 1:
      byte=(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=(*byte)&((128>>(x%8)));
      break;
    case 3: {
      short *byte;
      int  pos=(int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;
      byte=(short*)(xim->data+y*xim->bytes_per_line+pos);
      bit=*byte&(7<<shift[x % 8]);
      } break;
    case 4:
      byte=xim->data+y*xim->bytes_per_line+(x>>1);
      bit=*byte&(15<<((x%2)*4));
      break;
    case 8:
      byte=(xim->data+y*xim->bytes_per_line+x);
      bit=*byte;
      break;
    }

/*
    if(xim->depth==1){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=byte&(128>>(x%8));
    }
    else{
      int byte=*(xim->data+y*xim->bytes_per_line+x);
      bit=byte;
    }
*/
  }
  return((unsigned long)bit);
}

__stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel);

__stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel)
{
  unsigned char *byte;
  if(xim->bitmap_bit_order==LSBFirst){
    switch(xim->depth){
    case 1:
      byte=(xim->data+y*xim->bytes_per_line+(x>>3));
      *byte=(*byte)|((1<<(x%8))*pixel);
      break;
    case 3:{
      short *byte;
      int  pos=(int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;
      byte=(short*)(xim->data+y*xim->bytes_per_line+pos);
      *byte=*byte|(pixel<<shift[x % 8]);
      } break;
    case 4:
      byte=xim->data+y*xim->bytes_per_line+(x>>1);
      *byte=*byte|(pixel<<((x%2)*4));
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:
      byte=(xim->data+y*xim->bytes_per_line+x);
      *byte=pixel;
      break;
    }
  } else{
    switch(xim->depth){
    case 1:
      byte=(xim->data+y*xim->bytes_per_line+(x>>3));
      *byte=(*byte)|((128>>(x%8))*pixel);
      break;
    case 3: {
      short *byte;
      int  pos=(int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;
      byte=(short*)(xim->data+y*xim->bytes_per_line+pos);
      *byte=*byte|(pixel<<shift[x % 8]);
      } break;
    case 4:
      byte=xim->data+y*xim->bytes_per_line+(x>>1);
      *byte=*byte|(pixel<<((x%2)*4));
      break;
    case 8:
      byte=(xim->data+y*xim->bytes_per_line+x);
      *byte=pixel;
      break;
    }
  }
  return((int)*byte);
}

XSetWindowBackgroundPixmap(display, w, background_pixmap)
     Display *display;
     Window w;
     Pixmap background_pixmap;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetWindowBackgroundPixmap\n");
#endif
  return(0);
}
