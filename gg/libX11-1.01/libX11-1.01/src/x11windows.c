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

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
17 Nov 96: Improved handling of resizing of windows
           XClearWindow cleared the window relative to the screen instead of
	   relative to the window itself.
***/

#include "amiga.h"

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

#include <X11/Xatom.h>

#include "x11display.h"
#include "x11windows.h"
#include "x11events.h"
#include "clipping.h"
#include "clipboard.h"

#undef memset

/********************************************************************************/
/* external */
/********************************************************************************/

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
/*extern struct Library *AslBase;*/
extern struct Library *GadToolsBase;
extern struct Library *DiskfontBase;
extern struct Library *LayersBase;
extern struct DosLibrary *DOSBase;

extern int X11BorderLess;

/********************************************************************************/
/* internal */
/********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
extern int bInformWindows; /* outputting information about windows */
extern int bIgnoreWindowWarnings; /* ignore outputting information about window warnings */
#endif

/********************************************************************************/
/* functions */
/********************************************************************************/

int X11windepth = 0;

void adjustreal( Window win );
void adjustsiblings( Window win );

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

struct RastPort *
setup_win( Window win )
{

  DG.vPrevWindow = -1;
  
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( WINCONTEXTSWAP, 0 );
#endif

#if 0
  if( win==ROOTID || !win ){ /* oops drawing to root! */
    DG.drp = &DG.wb->RastPort;
    DG.vWinWidth = DG.nDisplayWidth;
    DG.vWinHeight = DG.nDisplayHeight;
    DG.vWinX = DG.vWindow->BorderLeft;
    DG.vWinY = DG.vWindow->BorderTop;
} else
#endif
  if ( X11Drawables[win]==X11WINDOW ){
    int root = X11Windows[X11DrawablesMap[win]].root;
    DG.vWindow = X11DrawablesWindows[X11DrawablesMap[root]];

    /* printf("Setupwin %x for %d\n", DG.vWindow, win ); */

    if( !GetWinFlag(win,WIN_MAPPED) ){
#if 0
      printf("Window not mapped - no drawing here..\n");
#endif
      return 0;
    }
    if( !DG.vWindow )
      return 0;
    DG.drp = DG.vWindow->RPort;

    DG.vWinX = X11Windows[X11DrawablesMap[win]].rx+DG.vWindow->BorderLeft;
    DG.vWinY = X11Windows[X11DrawablesMap[win]].ry+DG.vWindow->BorderTop;
    DG.vWinWidth = X11Windows[X11DrawablesMap[win]].rwidth;
    DG.vWinHeight = X11Windows[X11DrawablesMap[win]].rheight;
#if 0
    def OPTDBG
    printf("Window %d dim %d %d %d %d\n",win,DG.vWinX,DG.vWinY,DG.vWinWidth,DG.vWinHeight);
#endif

#if 0
    def DOCLIPPING
    r.x = DG.vWinX;
    r.y = DG.vWinY;
    r.width = DG.vWinWidth;
    r.height = DG.vWinHeight;
    XSetClipRectangles(&DG.X11Display,NULL,0,0,&r,1,0);
#endif /* DOCLIPPING */
  } else if( X11Drawables[win]==X11BITMAP ) {
    DG.vWinX = 0;
    DG.vWinY = 0;
    DG.X11BitmapRP.BitMap = X11DrawablesBitmaps[X11DrawablesMap[win]].pBitMap;
    DG.vWinWidth = X11DrawablesBitmaps[X11DrawablesMap[win]].width;
    DG.vWinHeight = X11DrawablesBitmaps[X11DrawablesMap[win]].height;
    DG.drp = &DG.X11BitmapRP;
    DG.vWindow = EG.X11eventwin;
  } 
#ifdef XMUI
  else if( X11Drawables[win]==X11MUI ) { /* a mui object */
    MUIsetup_win( win , &DG.drp, &DG.vWindow, &DG.vWinX, &DG.vWinY, &DG.vWinWidth, &DG.vWinHeight );
  }
#endif
#if 0
     else {
       printf("Invalid drawable window %d -> %d\n",win, X11Drawables[win]);
     }
#endif
  if( !DG.Xuserdata ){
    DG.Xuserdata = init_area(NULL,200,DG.vWinWidth,DG.vWinHeight);
  }
  DG.drp->TmpRas = &(DG.Xuserdata->win_tmpras);
  DG.drp->AreaInfo = &(DG.Xuserdata->win_AIstruct);

  DG.vPrevWindow = win;
  return( DG.drp );
}

/********************************************************************************
Name     : XCreateWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     parent   Specifies the parent window.  Parent must be  InputOutput  if
              class of window created is to be InputOutput.

     x
     y
              Specify the x and y coordinates of the  upper-left  pixel  of
              the  new window's border relative to the origin of the parent
              (upper left inside the parent's border).

     width
     height
              Specify the width and  height,  in  pixels,  of  the  window.
              These   are   the  new  window's  inside  dimensions.   These
              dimensions do not include the new window's borders, which are
              entirely  outside  of the window.  Must be nonzero, otherwise
              the server generates a BadValue error.

     border_width
              Specifies the width, in pixels, of the new  window's  border.
              Must  be  0 for InputOnly windows, otherwise a BadMatch error
              is generated.

     depth    Specifies the depth of the window,  which  can  be  different
              from the parent's depth.  A depth of CopyFromParent means the
              depth  is  taken  from  the  parent.   Use  XListDepths()  if
              choosing  an  unusual depth.  The specified depth paired with
              the visual argument must be supported on the screen.

     class     Specifies  the  new  window's  class.   Pass  one  of  these
              constants: InputOutput, InputOnly, or CopyFromParent.

     visual   Specifies a connection to an visual structure describing  the
              style   of   colormap   to   be   used   with   this  window.
              CopyFromParent is valid.

     valuemask
              Specifies  which  window  attributes  are  defined   in   the
              attributes  argument.   If  valuemask is 0, attributes is not
              referenced.  This  mask  is  the  bitwise  OR  of  the  valid
              attribute mask bits listed in the Structures section below.

     attributes
               Attributes of the window to be set at creation  time  should
               be  set  in  this  structure.  The valuemask should have the
               appropriate bits set to indicate which attributes have  been
               set in the structure.

Output   : 
Function : create a window and set attributes.
********************************************************************************/

Window
XCreateWindow( Display* display,
	       Window parent,
	       int x,
	       int y,
	       unsigned int width,
	       unsigned int height,
	       unsigned int border_width,
	       int depth,
	       unsigned int class,
	       Visual* visual,
	       unsigned long valuemask,
	       XSetWindowAttributes* attributes )
{
  int bg = 0;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEWINDOW, bInformWindows );
#endif
  if( attributes )
    bg=attributes->background_pixel;
  X11windepth = depth;

  return(XCreateSimpleWindow(display,parent,x,y,width,height,border_width,1,bg));
}

/********************************************************************************
Name     : XCreateSimpleWindow()
Author   : Terje Pedersen
Input    : 
     display  Specifies a pointer to the Display structure;  returned  from
              XOpenDisplay().

     parent   Specifies the parent  window  ID.   Must  be  an  InputOutput
              window.

     x
     y
              Specify the x and y coordinates of the  upper-left  pixel  of
              the  new window's border relative to the origin of the parent
              (inside the parent window's border).

     width
     height
              Specify the width and height, in pixels, of the  new  window.
              These  are  the  inside  dimensions,  not  including  the new
              window's borders, which are entirely outside of  the  window.
              Must be nonzero.  Any part of the window that extends outside
              its parent window is clipped.

     border_width
              Specifies the width, in pixels, of the new window's border.

     border   Specifies the pixel value for the border of the window.

     background
              Specifies the pixel value for the background of the window.

Output   : 
Function : create an unmapped InputOutput window.
********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
int vWatchFor=-1;
#endif

Window
XCreateSimpleWindow( Display* display,
		     Window parent,
		     int x,
		     int y,
		     unsigned int width,
		     unsigned int height,
		     unsigned int border_width,
		     unsigned long border,
		     unsigned long background )
{
  Window newwin;
  int p;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATESIMPLEWINDOW, bInformWindows );
#endif

  DG.vWBapp = 1;

#if (DEBUG!=0)
  if( parent==vWatchFor ){
    printf("Opening window: %d\n",parent);
  }
#endif
  if( !border_width )
    border = 0;
  if( !DG.Scr )
    DG.Scr = DG.wb;
  if( !X11windepth )
    X11windepth = DG.Scr->RastPort.BitMap->Depth;

  if( parent==ROOTID ){
    if( width>DG.Scr->Width
        || height>DG.Scr->Height
        || X11windepth>DG.Scr->RastPort.BitMap->Depth ){ 
      int i,nXMax = 0,nYMax = 0;
      /*asking for a bigger window than wb can handle */

      DG.vWBapp = 0;

      for( i=0; i<DG.X11NumDrawablesWindows; i++ )
	if( GetWinFlagD(i,WIN_MAPPED) ){
	  XUnmapWindow(NULL,X11Windows[i].win);
	  if( X11Windows[i].width>nXMax )
	    nXMax = X11Windows[i].width;
	  if( X11Windows[i].height>nYMax )
	    nYMax = X11Windows[i].height;
	  SetWinFlagD(i,WIN_MAPPED2);
	}
/*
      if( AmigaCreateWindow(max(width,nXMax),max(height,nYMax),X11windepth,0,0) ){
	return(0);
      }
*/
      for( i=0; i<DG.X11NumDrawablesWindows; i++ )
	if( GetWinFlagD(i,WIN_MAPPED2) ){
	  XMapWindow(NULL,X11Windows[i].win);
	}
      DG.vUseWB = 0;
      DG.vWBapp = 0;
    }
  }
  newwin = X11NewWindow(0);
#if 0
  if( width>DG.Scr->Width )
    width = DG.Scr->Width;
  if( height>DG.Scr->Height )
    height = DG.Scr->Height;
#endif

  X11Windows[X11DrawablesMap[newwin]].x = x;
  X11Windows[X11DrawablesMap[newwin]].y = y;

  X11Windows[X11DrawablesMap[newwin]].parent = parent;
  if( parent == ROOTID ){
    X11Windows[X11DrawablesMap[newwin]].rx = 0;
    X11Windows[X11DrawablesMap[newwin]].ry = 0;
    XSelectInput(display,newwin,0xffffff);
    X11Windows[X11DrawablesMap[newwin]].root = newwin;
  } else {
    X11Windows[X11DrawablesMap[newwin]].rx = X11Windows[X11DrawablesMap[parent]].rx+x;
    X11Windows[X11DrawablesMap[newwin]].ry = X11Windows[X11DrawablesMap[parent]].ry+y;
    X11DrawablesMask[newwin] = X11DrawablesMask[parent];

    p = newwin;
    while( X11Windows[X11DrawablesMap[p]].parent != ROOTID ){
      p = X11Windows[X11DrawablesMap[p]].parent;
    }
    X11Windows[X11DrawablesMap[newwin]].root = p;
  }

  X11Windows[X11DrawablesMap[newwin]].width = width;
  X11Windows[X11DrawablesMap[newwin]].height = height;
  X11Windows[X11DrawablesMap[newwin]].rwidth = width;
  X11Windows[X11DrawablesMap[newwin]].rheight = height;
  X11Windows[X11DrawablesMap[newwin]].win = newwin;
  X11Windows[X11DrawablesMap[newwin]].pixmap = 0;
  X11Windows[X11DrawablesMap[newwin]].flags = 0;

  X11Windows[X11DrawablesMap[newwin]].mChildren = Map_Init( 10 );
  X11Windows[X11DrawablesMap[newwin]].mMappedChildren = Map_Init( 10 );

  Map_NewIEntry( X11Windows[X11DrawablesMap[parent]].mChildren, newwin );

  X11Windows[X11DrawablesMap[newwin]].border = border;
  X11Windows[X11DrawablesMap[newwin]].background = background;
  X11DrawablesBackground[newwin] = background;

  adjustreal( newwin );
  adjustsiblings( newwin );

  X11Windows[X11DrawablesMap[newwin]].RelX = 0;
  X11Windows[X11DrawablesMap[newwin]].RelY = 0;
  X11Windows[X11DrawablesMap[newwin]].RelWidth = 0;
  X11Windows[X11DrawablesMap[newwin]].RelHeight = 0;

#ifdef OPTDBG
  printf("New window %d: x %d y %d w %d h %d parent %d\n",newwin,x,y,width,height,parent);
#endif
  // display->screens[0].white_pixel=background;

  XSelectInput( display, newwin, 0xffffff );
  X11init_cmaps();

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCREATESIMPLEWINDOW, bInformWindows );
#endif

  return( newwin );
}

void
adjustsiblings( Window win )
{
  int i;
  int parent = X11Windows[X11DrawablesMap[win]].parent;
  int thisx, thisy, thisw, thish;
  int child;
  IMap_p pChildren;

  if( parent == ROOTID )
    return;
  thisx = X11Windows[X11DrawablesMap[win]].rx;
  thisy = X11Windows[X11DrawablesMap[win]].ry;
  thisw = X11Windows[X11DrawablesMap[win]].rwidth;
  thish = X11Windows[X11DrawablesMap[win]].rheight;
  
  pChildren = X11Windows[X11DrawablesMap[parent]].mChildren;

  for( i=0; i<pChildren->nTopEntry; i++ ){
    int childid = pChildren->pData[i];
    child = X11DrawablesMap[childid];
    if( childid == win )
      continue;
    if( (X11Windows[child].rx+X11Windows[child].rwidth > thisx
	 && thisx+thisw>X11Windows[child].rx)
       &&  (X11Windows[child].ry+X11Windows[child].rheight > thisy
	    && thisy+thish>X11Windows[child].ry) ){
/*
  X11Windows[child].RelWidth = X11Windows[child].rwidth-(X11Windows[child].rx-thisx);
  X11Windows[child].RelHeight = X11Windows[child].rheight-(X11Windows[child].ry-thisy);
*/
      if( (thisx-X11Windows[child].rx)==0 && (thisy-X11Windows[child].ry)==0 )
	continue;
      if( thisx != X11Windows[child].rx )
	X11Windows[child].rwidth = (thisx-X11Windows[child].rx);
      if( thisy != X11Windows[child].ry )
	X11Windows[child].rheight = (thisy-X11Windows[child].ry); 
#ifdef OPTDBG
      printf("sibling obscured..win %d sibling %d %d %d\n", win, childid,
	     X11Windows[child].rwidth,
	     X11Windows[child].rheight);
#endif
      adjustchildren( childid );
    }
  }
}

void
adjustreal( Window win )
{
  int parent = X11Windows[X11DrawablesMap[win]].parent;

  if( parent != ROOTID ){
    if( X11Windows[X11DrawablesMap[win]].rx < X11Windows[X11DrawablesMap[parent]].rx )
      X11Windows[X11DrawablesMap[win]].rx = X11Windows[X11DrawablesMap[parent]].rx;
    if( X11Windows[X11DrawablesMap[win]].ry < X11Windows[X11DrawablesMap[parent]].ry )
      X11Windows[X11DrawablesMap[win]].ry = X11Windows[X11DrawablesMap[parent]].ry;
#if 1
    if( X11Windows[X11DrawablesMap[win]].rx+X11Windows[X11DrawablesMap[win]].rwidth > X11Windows[X11DrawablesMap[parent]].rx+X11Windows[X11DrawablesMap[parent]].rwidth )
      X11Windows[X11DrawablesMap[win]].rwidth = X11Windows[X11DrawablesMap[parent]].rx+X11Windows[X11DrawablesMap[parent]].rwidth-X11Windows[X11DrawablesMap[win]].rx;
    if( X11Windows[X11DrawablesMap[win]].ry+X11Windows[X11DrawablesMap[win]].rheight > X11Windows[X11DrawablesMap[parent]].ry+X11Windows[X11DrawablesMap[parent]].rheight )
      X11Windows[X11DrawablesMap[win]].rheight = X11Windows[X11DrawablesMap[parent]].ry+X11Windows[X11DrawablesMap[parent]].rheight-X11Windows[X11DrawablesMap[win]].ry;
#endif
#if 0 /* def OPTDBG */
    printf("real adjust %d - %d %d %d %d\n",
	   win,
	   X11Windows[X11DrawablesMap[win]].rx,
	   X11Windows[X11DrawablesMap[win]].ry,
	   X11Windows[X11DrawablesMap[win]].rwidth,
	   X11Windows[X11DrawablesMap[win]].rheight);
#endif

#if (DEBUG!=0)
    if( X11Windows[X11DrawablesMap[win]].rwidth<0 ){
      printf("width less than zero!\n");
    }

    if( X11Windows[X11DrawablesMap[win]].rheight<0 ){
      printf("height less than zero!\n");
    }      
#endif    
  }
}

void
adjustchildren( Window win )
{
  int i;
  int child;
  IMap_p pChildren;

#if 1

  pChildren = X11Windows[X11DrawablesMap[win]].mChildren;
  for( i=0; i<pChildren->nTopEntry; i++ ){
    child = X11DrawablesMap[pChildren->pData[i]];

    X11Windows[child].rx = X11Windows[X11DrawablesMap[win]].rx+X11Windows[child].x;
    X11Windows[child].ry = X11Windows[X11DrawablesMap[win]].ry+X11Windows[child].y;
    X11Windows[child].rwidth = X11Windows[child].width;
    X11Windows[child].rheight = X11Windows[child].height;

    adjustreal( pChildren->pData[i] );
    adjustchildren( pChildren->pData[i] );
  }
#endif
}

/********************************************************************************
Name     : XDestroyWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window to be destroyed.

Output   : 
Function : unmap and destroy a window and all subwindows.
********************************************************************************/

XDestroyWindow( Display* display, Window win )
{
  int i;
  int parent = X11Windows[X11DrawablesMap[win]].parent;
  int child;
  IMap_p pChildren;

  pChildren = X11Windows[X11DrawablesMap[win]].mChildren;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XDESTROYWINDOW, bInformWindows );
#endif
  if( win == ROOTID )
    return;

  /* get rid of any unused events */

  ClearWinFlag(win,WIN_EXPOSED);
  Events_FreeInternalWindowXEvents( win );

  if( pChildren->nTopEntry != 0)
  do {
    i = 0;
    child = pChildren->pData[i];
    if( GetWinFlag( child, WIN_DELETED ) ){
      assert( 1==0 );
    }
    XDestroyWindow( display, child );
    X11Windows[X11DrawablesMap[child]].parent = -1;
  } while( pChildren->nTopEntry != 0);

  Map_FreeIEntry( X11Windows[X11DrawablesMap[parent]].mChildren, win );

  if( GetWinFlag(win,WIN_MAPPED) )
    XUnmapWindow( display, win );
  X11FreeWindow( win );

  return(0);
}

extern int XDrawRectangle(Display *,Drawable,GC,int,int,unsigned int,unsigned int);

/********************************************************************************
Name     : XUnmapWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the window ID.

Output   : 
Function : unmap a window.
********************************************************************************/

XUnmapWindow( Display* display, Window win )
{
  int i;
  int child;
  struct Window *deleted;
  int parent = X11Windows[X11DrawablesMap[win]].parent;
  IMap_p pChildren;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XUNMAPWINDOW, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XUnmapWindow %d parent %d\n", win, parent );
#endif

  if( win==ROOTID ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XUNMAPWINDOW, bInformWindows );
#endif
    return;
  }
  DG.vPrevWindow = -1;
  vPrevGC = (GC)-1;
#ifdef XMUI
  if( X11Drawables[win]==X11MUI ){
    MUIUnmapWindow( win );
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XUNMAPWINDOW, bInformWindows );
#endif
    return 0;
  } 
#endif

  ClearWinFlag( win, WIN_OBSCURED );

  if( !GetWinFlag(win,WIN_MAPPED) ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XUNMAPWINDOW, bInformWindows );
#endif
    return;
  }
  /* get rid of any unused events, to get map/expose events in correct order */
  Events_FreeInternalWindowXEvents( win );

  Events_AddEvent( win, UnmapNotify, sizeof(XUnmapEvent) );

  ClearWinFlag( win, WIN_MAPPED|WIN_EXPOSED );

  if( X11Windows[X11DrawablesMap[win]].depth == 1 ){
    int child;
    IMap_p pChildren;
    int i;

    /* map any obscured windows */
    parent = X11Windows[X11DrawablesMap[win]].parent;

#ifdef OPTDBG
    printf("Checking previously obscured windows to %d parent %d\n",win,parent);
#endif
    
    X11Windows[X11DrawablesMap[win]].depth = 0;
    pChildren = X11Windows[X11DrawablesMap[parent]].mChildren;
    
    for( i=0; i<pChildren->nTopEntry; i++ ){
      child = X11DrawablesMap[pChildren->pData[i]];

      if( pChildren->pData[i] == win )
	continue;
      
#if 0
      printf("Checking %d flags %d\n",pChildren->pData[i],X11Windows[child].flags);
#endif
      if( GetWinFlag(pChildren->pData[i],WIN_OBSCURED) ){
#ifdef OPTDBG
	printf("Mapping previously obscured child %d\n",pChildren->pData[i]);
#endif
	ClearWinFlag( pChildren->pData[i], WIN_OBSCURED );
	X11Windows[child].depth = 0;
	XMapWindow( display, pChildren->pData[i] );
	Events_AddExpose( pChildren->pData[i] );
      }
    }
  }

#if 0
  printf("Removing %d from parent %d\n",win,parent);
#endif
  Map_FreeIEntry( X11Windows[X11DrawablesMap[parent]].mMappedChildren, win );

  ClearWinFlag( win, WIN_MAPPED );

  if( X11Windows[X11DrawablesMap[win]].parent != ROOTID ){
#ifdef DEBUGXEMUL_ENTRY
    FunCount_Leave( XUNMAPWINDOW, bInformWindows );
#endif
    return;
  }
  if( X11DrawablesWindows[X11DrawablesMap[win]]==EG.X11eventwin )
    EG.X11eventwin = 0;

  /* printf("Unmapping %p\n",X11DrawablesWindows[X11DrawablesMap[win]]); */

  if( X11DrawablesWindows[X11DrawablesMap[win]] ){
    unclipWindow(X11DrawablesWindows[X11DrawablesMap[win]]->WLayer);
    CG.pPreviousLayer = NULL;
    if( X11Windows[X11DrawablesMap[win]].parent == ROOTID ){
      CloseWindow(X11DrawablesWindows[X11DrawablesMap[win]]);
    }
    EG.fwindowsig = 0;
    deleted = X11DrawablesWindows[X11DrawablesMap[win]];
    X11DrawablesWindows[X11DrawablesMap[win]] = NULL;

    pChildren = X11Windows[ROOTID].mChildren;

    for( i=0; i<pChildren->nTopEntry; i++ ){
      child = pChildren->pData[i];
      if( X11DrawablesWindows[X11DrawablesMap[child]] == deleted ){
	X11DrawablesWindows[X11DrawablesMap[child]] = NULL;
	ClearWinFlag(child,/*WIN_MAPPED|*/WIN_EXPOSED);
      } else if( GetWinFlag(child,WIN_MAPPED) ){
	EG.fwindowsig |= (1<<X11DrawablesWindows[X11DrawablesMap[child]]->UserPort->mp_SigBit);
      }
    }
  }

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XUNMAPWINDOW, bInformWindows );
#endif
  return(0);
}

/********************************************************************************
Name     : XMapWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the ID of the window to be mapped.

Output   : 
Function : map a window.
********************************************************************************/

MapWindow( Window win )
{
  int i,x,y,width,height,background;
  int parent = X11Windows[X11DrawablesMap[win]].parent;
  int vBorderLess;
  extern char *LibX11Info;
  struct Window *Win;

  if( X11Windows[X11DrawablesMap[win]].depth == -1 ){
#ifdef OPTDBG
    printf("mapwindow: Obscured %d\n",win);
#endif
    return;
  }
  if( !GetWinFlag(win,WIN_MAPPED|WIN_MAPMELATER) ){
    if( !GetWinFlag(win,WIN_MAPMELATER) ){
      Map_NewIEntry( X11Windows[X11DrawablesMap[parent]].mMappedChildren, win );
#if 0
      printf("Adding %d to parent %d \n",win,parent);
#endif
    }
  }

#if 0
  printf("Mapping %d\n",win);
#endif
  /* get rid of any unused events, to get map/expose events in correct order */
#if 1
  ClearWinFlag(win,WIN_EXPOSED);
  Events_FreeInternalWindowXEvents( win );
#endif

  x = X11Windows[X11DrawablesMap[win]].x;
  y = X11Windows[X11DrawablesMap[win]].y;
  width = X11Windows[X11DrawablesMap[win]].width;
  height = X11Windows[X11DrawablesMap[win]].height;
  background = X11DrawablesBackground[win];

  if( x<0 ) x = 0;
  if( y<0 ) y = 0;

  if( X11BorderLess )
    vBorderLess = WFLG_BORDERLESS;
  else
    vBorderLess = WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET;
  
  if( X11Windows[X11DrawablesMap[win]].parent == ROOTID ){
    if ( !(Win = 
	   OpenWindowTags(NULL,
			  WA_Left,x,WA_Top,y,
			  WA_MinWidth, 64, WA_MinHeight, 64,
			  WA_InnerWidth,width,WA_InnerHeight,height,
			  WA_MaxWidth,DG.nDisplayMaxWidth,WA_MaxHeight,DG.nDisplayMaxHeight,
			  WA_DetailPen,1,WA_BlockPen,0,
			  WA_IDCMP,IDCMP_CHANGEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_ACTIVEWINDOW|
			  IDCMP_NEWSIZE|IDCMP_RAWKEY|IDCMP_INACTIVEWINDOW|IDCMP_MOUSEMOVE|
			  IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW,
			  WA_Flags, WFLG_SMART_REFRESH|WFLG_REPORTMOUSE|WFLG_RMBTRAP|vBorderLess,
			  WA_ScreenTitle,	"X11",
			  WA_CustomScreen, DG.Scr,
			  TAG_DONE ))) return(NULL);
    EG.X11eventwin = Win;
    SetWindowTitles(Win,X11Windows[X11DrawablesMap[win]].name, LibX11Info);
    X11DrawablesWindows[X11DrawablesMap[win]] = Win;
    if( !DG.Xuserdata )
      DG.Xuserdata = init_area(Win,MAX_COORD,Win->Width,Win->Height);
  } else {
    int root = X11Windows[X11DrawablesMap[win]].root;
    Win = X11DrawablesWindows[X11DrawablesMap[root]];
  }

  /* Events_ExposeChildren( win ); */
  SetWinFlag(win,WIN_MAPPED);

  EG.fwindowsig = 0;
  /* X11Windows[X11DrawablesMap[win]].depth = 0; */
  {
    IMap_p pMapped;

    pMapped = X11Windows[ROOTID].mMappedChildren;

    for( i=0; i<pMapped->nTopEntry; i++ ){
      /* printf("signal from %d\n",pMapped->pData[i]); */
      EG.fwindowsig |= (1<<X11DrawablesWindows[X11DrawablesMap[pMapped->pData[i]]]->UserPort->mp_SigBit);
    }
  }

  if( X11Windows[X11DrawablesMap[win]].pixmap != 0 )
    XCopyArea( NULL, X11Windows[X11DrawablesMap[win]].pixmap, win, DG.X11GC,0,0,width,height,0,0);

  SetBackground( background );
  ClearWinFlag( win, WIN_EXPOSED );
  if( GetWinFlag( win, WIN_MAPMELATER ) ){
    Events_AddEvent( win, MapNotify, sizeof(XMapEvent) );
  }
  Events_AddExpose( win );
  ClearWinFlag( win, WIN_MAPMELATER );
#if 0
  Events_AddEvent( win, VisibilityNotify, sizeof(XVisibilityEvent) );
  Events_AddChildEvent( win, VisibilityNotify, sizeof(XVisibilityEvent) );
#endif
}

XMapWindow( Display* d, Window win )
{
  int parent = X11Windows[X11DrawablesMap[win]].parent;

#ifdef DEBUGXEMUL_ENTRY
  if( win==vWatchFor ){
    printf("Opening window: %d\n",win);
  }
  FunCount_Enter( XMAPWINDOW, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XMapWindow %d parent %d\n", win, parent );
#endif
#if 0
  if( GetWinFlag(win,WIN_MAPPED) ){
    return;
  }
#endif


  if( win==ROOTID )
    return;

  if( X11Windows[X11DrawablesMap[win]].depth == -1 ){
#ifdef OPTDBG
    printf("Obscured %d\n",win);
#endif
    return;
  }
  if( !GetWinFlag( parent, WIN_MAPPED ) ){
#ifdef OPTDBG
    printf( "Parent not mapped %d\n", win );
#endif
    if( !GetWinFlag(win,WIN_MAPMELATER) ){
      Map_NewIEntry( X11Windows[X11DrawablesMap[parent]].mMappedChildren, win );
#if 0
      printf("Adding %d to parent %d later\n",win,parent);
#endif
      SetWinFlag( win, WIN_MAPMELATER );
    }
    /* will be mapped when parent gets mapped */
    return;
  }

  /* Window_DrawBorder(win); */

  /* EG.nEventDrawable = win; */

  MapWindow( win );

  if( !GetWinFlag( parent, WIN_PARENTCLEARED ) )
#if 1
    XClearWindow( &DG.X11Display, win );
#endif
  // Events_AddConfigure( win );

  Events_MapMappedChildren( win );

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XMAPWINDOW, bInformWindows );
#endif 

  return(0);
}

void
Events_MapMappedChildren( Window win )
{
  int i;
  int child;
  IMap_p pChildren;
  int parent, parentw, parenth;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( MAPMAPPED, bInformWindows );
#endif 

#ifdef OPTDBG
  printf("Map mapped children to %d\n",win);
#endif
  pChildren = X11Windows[X11DrawablesMap[win]].mMappedChildren;

  SetWinFlag( win, WIN_PARENTCLEARED );

  for( i=0; i<pChildren->nTopEntry; i++ ){
    child = X11DrawablesMap[pChildren->pData[i]];

    if( !GetWinFlag( pChildren->pData[i], WIN_MAPPED|WIN_MAPMELATER ) )
      continue;
    parent = X11Windows[child].parent;
    parentw = X11Windows[X11DrawablesMap[parent]].rx+X11Windows[X11DrawablesMap[parent]].rwidth;
    parenth = X11Windows[X11DrawablesMap[parent]].ry+X11Windows[X11DrawablesMap[parent]].rheight;

    if( X11Windows[child].rx+X11Windows[child].rwidth >= X11Windows[X11DrawablesMap[parent]].rx
        && X11Windows[child].rx < parentw
        && X11Windows[child].ry+X11Windows[child].rheight >= X11Windows[X11DrawablesMap[parent]].ry
        && X11Windows[child].ry < parenth ){
      /* ClearWinFlag( pChildren->pData[i], WIN_MAPPED|WIN_EXPOSED ); */
      XMapWindow( &DG.X11Display, pChildren->pData[i] );
#if 1
      Events_AddExpose( pChildren->pData[i] );
#endif
      /* Events_AddEvent( pChildren->pData[i], MapNotify, sizeof(XMapEvent) ); */
      /* Events_AddMapEvents( pChildren->pData[i] ); */
    } else {
#ifdef OPTDBG
      printf("not mapping %d\n",child);
      printf("%d %d %d %d (parent %d %d)\n",
	     X11Windows[child].x,
	     X11Windows[child].y,
	     X11Windows[child].width,
	     X11Windows[child].height,
	     parentw,parenth);
#endif
    }
  }
  ClearWinFlag( win, WIN_PARENTCLEARED );
  
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( MAPMAPPED, bInformWindows );
#endif 
}

extern int XSetClipMask(Display *,GC,Pixmap);

/********************************************************************************
Name     : XClearWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window to be cleared.

Output   : 
Function : clear an entire window.
********************************************************************************/

XClearWindow( Display* display, Window w )
{
  struct Window *vWindow;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCLEARWINDOW, bInformWindows );
#endif

  if( X11Drawables[w]==X11WINDOW ) {
    int root = X11Windows[X11DrawablesMap[w]].root;

    if( !GetWinFlag( w, WIN_MAPPED ) ){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XCLEARWINDOW, bInformWindows );
#endif
      return;
    }

    vWindow = X11DrawablesWindows[X11DrawablesMap[root]];

    if( !vWindow ){
#ifdef DEBUGXEMUL_ENTRY
      FunCount_Leave( XCLEARWINDOW, bInformWindows );
#endif
      return;
    }
#ifdef DOCLIPPING
    clip_begin(X11Windows[X11DrawablesMap[w]].rx,
	       X11Windows[X11DrawablesMap[w]].ry,
	       X11Windows[X11DrawablesMap[w]].rwidth-1,
	       X11Windows[X11DrawablesMap[w]].rheight-1);

    pChildren = X11Windows[X11DrawablesMap[w]].mMappedChildren;
    /* and exclude all subwins */
    for( i=0; i<pChildren->nTopEntry; i++ ){
      child = X11DrawablesMap[pChildren->pData[i]];
      clip_exclude(X11Windows[child].rx,
		     X11Windows[child].ry,
		     X11Windows[child].rwidth-1,
		     X11Windows[child].rheight-1);
    }
    clip_end(vWindow);
#endif
    SetABPenDrMd( vWindow->RPort, X11DrawablesBackground[w], 0, JAM1 ); /* X11Windows[X11DrawablesMap[w]].background */

#ifdef OPTDBG
    printf("XClearWindow %d rectangle %d %d %d %d\n", w,
	   X11Windows[X11DrawablesMap[w]].rx,
	   X11Windows[X11DrawablesMap[w]].ry,
	   X11Windows[X11DrawablesMap[w]].rwidth-1,
	   X11Windows[X11DrawablesMap[w]].rheight-1);
#endif

    RectFill(vWindow->RPort,vWindow->BorderLeft+X11Windows[X11DrawablesMap[w]].rx,
	     vWindow->BorderTop+X11Windows[X11DrawablesMap[w]].ry,
	     vWindow->BorderLeft+X11Windows[X11DrawablesMap[w]].rx+X11Windows[X11DrawablesMap[w]].rwidth-1,
	     vWindow->BorderTop+X11Windows[X11DrawablesMap[w]].ry+X11Windows[X11DrawablesMap[w]].rheight-1);
#ifdef DOCLIPPING
    XSetClipMask( display, DG.X11GC, None );
#endif
    /* DG.vPrevWindow=-1; */
    if( X11Windows[X11DrawablesMap[w]].pixmap ){
      int dx = 0;
      int dy = 0;
      int srcw = X11DrawablesBitmaps[X11Windows[X11DrawablesMap[w]].pixmap].width;
      int srch = X11DrawablesBitmaps[X11Windows[X11DrawablesMap[w]].pixmap].height;
      int x,y;
      for( y=0; y<X11Windows[X11DrawablesMap[w]].rheight; y += srch ){
	for( x=0; x<X11Windows[X11DrawablesMap[w]].rwidth; x += srcw ){
	  XCopyArea( display, X11Windows[X11DrawablesMap[w]].pixmap, w, DG.X11GC,
		    0, 0, srcw, srch, x, y);
	}
      }
    }
  }
#ifdef XMUI
  else if( X11Drawables[w]==X11MUI ) {
    MUIClearWindow( w );
  } 
#endif
  else if( X11Drawables[w]==X11BITMAP ) {
    /* X11ClearArea */
    XClearArea(display,w,0,0,
		 X11DrawablesBitmaps[X11DrawablesMap[w]].width,
		 X11DrawablesBitmaps[X11DrawablesMap[w]].height,0);
  }
  vPrevGC = (GC)-1;
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCLEARWINDOW, bInformWindows );
#endif
}

/********************************************************************************
Name     : XDestroySubwindows()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window whose subwindows  are  to  be
               destroyed.

Output   : 
Function : destroy all subwindows of a window.
********************************************************************************/

XDestroySubwindows( Display* display, Window win )
{
  IMap_p pChildren;
  int child;

#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XDESTROYSUBWINDOWS, bInformWindows );
#endif
  pChildren = X11Windows[X11DrawablesMap[win]].mChildren;

  if( pChildren->nTopEntry != 0)
    do {
      child = pChildren->pData[0];
      XDestroySubwindows( display, child );
      XDestroyWindow( display, child );
    } while( pChildren->nTopEntry != 0 );
  return(0);
}


/********************************************************************************
Name     : XMapSubwindows()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the ID of the window whose  subwindows  are  to  be
              mapped.

Output   : 
Function : map all subwindows of window.
********************************************************************************/

XMapSubwindows( Display* display, Window win )
{
  int i;
  IMap_p pChildren;
  int child;

#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XMAPSUBWINDOWS, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XMapSubwindows\n");
#endif
  pChildren = X11Windows[X11DrawablesMap[win]].mChildren;


  for( i=0; i<pChildren->nTopEntry; i++ ){
    /* XMapSubwindows( display, pChildren->pData[i] ); */
    child = pChildren->pData[i];
    if( !GetWinFlag(win,WIN_MAPPED) ){
      if( !GetWinFlag(child,WIN_MAPPED|WIN_MAPMELATER) ){
	Map_NewIEntry( X11Windows[X11DrawablesMap[win]].mMappedChildren, child );
#if 0
	printf("Adding %d to parent %d subwins\n",child,win);
#endif
#if 0
	printf("Preparing %d for mapping\n", child );
#endif
	SetWinFlag( child, WIN_MAPMELATER );
      }
    } else {
      XMapWindow( display, child );
    }
  }

#if (DEBUGXEMUL_ENTRY)
  FunCount_Leave( XMAPSUBWINDOWS, bInformWindows );
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

void
Window_DrawBorder( Window win )
{
  int x,y,w,h;

  if( GetWinBorder(win) ){
    DG.drp = setup_win(win);

    SetDrMd(DG.drp,JAM1);
    SetAPen(DG.drp,X11DrawablesBackground[win]);
    x = -1;
    y = -1;
    w = X11Windows[X11DrawablesMap[win]].rwidth+2;
    h = X11Windows[X11DrawablesMap[win]].rheight+2;

#if 0
    RectFill(DG.drp,
	     DG.vWinX+x,
	     DG.vWinY+y,
	     DG.vWinX+x+w,
	     DG.vWinY+y+h);
#endif
    SetAPen(DG.drp,GetWinBorder(win) );
    Move(DG.drp,DG.vWinX+x,DG.vWinY+y);
    Draw(DG.drp,DG.vWinX+x+w,DG.vWinY+y);
    Draw(DG.drp,DG.vWinX+x+w,DG.vWinY+y+h);
    Draw(DG.drp,DG.vWinX+x,DG.vWinY+y+h);
    Draw(DG.drp,DG.vWinX+x,DG.vWinY+y);
    vPrevGC = (GC)-1;
  }
}

#if 0
void
ResetWindow( struct Window *win, int vW, int vH )
{
  assert(win);

  SetAPen(win->RPort,X11DrawablesBackground[EG.nEventDrawable]);
  SetDrMd(win->RPort,JAM1);
  vPrevGC = (GC)-1;
  RectFill(win->RPort,win->BorderLeft,win->BorderTop,win->BorderLeft+vW,win->BorderTop+vH);
  RefreshWindowFrame(win);
}
#endif

/********************************************************************************
Name     : XMapRaised()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the window ID  of  the  window  to  be  mapped  and
              raised.

Output   : 
Function : map a window on top of its siblings.
********************************************************************************/

XMapRaised( Display* display, Window win )
{
  int child;
  IMap_p pChildren;
  int i;
  int thisx, thisy, thisw, thish;
  int parent;
#if 0
  XEvent event;
#endif

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XMAPRAISED, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XMapRaised %d\n",win);
#endif
#ifdef XMUI
  if( X11Drawables[win]==X11MUI ){
    return MUIMapRaised( win );
  }
#endif
  parent = X11Windows[X11DrawablesMap[win]].parent;

/*
  if( GetWinFlag(win,WIN_MAPPED) ){
    return;
  }
*/

  if( parent == ROOTID ){
    XMapWindow( display, win );
#if 0
#if 0
    XClearWindow( &DG.X11Display, win );
#endif
    /* get rid of any unused events, to get map/expose events in correct order */
#if 1
    ClearWinFlag(win,WIN_EXPOSED);
    Events_FreeInternalWindowXEvents( win );
#endif
    Events_AddEvent( win, MapNotify, sizeof(XMapEvent) );
    Events_AddExpose( win );
#if 1
    Events_AddChildEvent( win, VisibilityNotify, sizeof(XVisibilityEvent) );
    Events_MapMappedChildren( win );
#endif
#endif
    ActivateWindow( X11DrawablesWindows[X11DrawablesMap[win]] );
    WindowToFront( X11DrawablesWindows[X11DrawablesMap[win]] );
    return;
  }

  X11Windows[X11DrawablesMap[win]].depth = 1;

  MapWindow( win );
  XClearWindow( display, win );

  thisx = X11Windows[X11DrawablesMap[win]].rx;
  thisy = X11Windows[X11DrawablesMap[win]].ry;
  thisw = X11Windows[X11DrawablesMap[win]].rwidth;
  thish = X11Windows[X11DrawablesMap[win]].rheight;
  
  pChildren = X11Windows[X11DrawablesMap[parent]].mMappedChildren;

  i = 0;
  if( pChildren->nTopEntry != 0)
    do {
      int childid = pChildren->pData[i];
      child = X11DrawablesMap[pChildren->pData[i]];
      if( pChildren->pData[i] == win ){
	i++;
	continue;
      }
      if( X11Windows[child].rx >= thisx
	 && X11Windows[child].ry >= thisy
	 && X11Windows[child].rwidth <= thisx+thisw
	 && X11Windows[child].rheight <= thisy+thish
	 && GetWinFlag(pChildren->pData[i],WIN_MAPPED) ){
#ifdef OPTDBG
	printf("Win %d Unmapping obscured child %d\n",win,pChildren->pData[i]);
#endif
	X11Windows[child].depth = -1;
	
	XUnmapWindow( display, pChildren->pData[i] );
	SetWinFlag( childid, WIN_OBSCURED );
      } else
	i++;
    } while( i<pChildren->nTopEntry );

  Events_MapMappedChildren( win );
  
  return(0);
}

/********************************************************************************
Name     : XConfigureWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window to be reconfigured.

     value_mask
               Specifies which values are to be set  using  information  in
               the  values  structure.  value_mask is the bitwise OR of any
               number of symbols listed in the Structures section below.

     values     Specifies  a  pointer  to  the   XWindowChanges   structure
               containing   new   configuration   information.    See   the
               Structures section below.

Output   : 
Function : change the window position, size, border width, or stacking order.
********************************************************************************/

XConfigureWindow( Display* display,
		  Window w,
		  unsigned int value_mask,
		  XWindowChanges* values )
{
  struct Window *win;
  int parent = X11Windows[X11DrawablesMap[w]].parent;
  int root = X11Windows[X11DrawablesMap[w]].root;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCONFIGUREWINDOW, bInformWindows );
#endif

  if( X11Drawables[w]==X11BITMAP ){
    return;
  }
  if( value_mask&CWX ){
    X11Windows[X11DrawablesMap[w]].x = values->x;
    if( parent != ROOTID )
      X11Windows[X11DrawablesMap[w]].rx = X11Windows[X11DrawablesMap[w]].x+X11Windows[X11DrawablesMap[parent]].rx;
  }
  if( value_mask&CWY ){
    X11Windows[X11DrawablesMap[w]].y = values->y;
    if( parent != ROOTID )
      X11Windows[X11DrawablesMap[w]].ry = X11Windows[X11DrawablesMap[w]].y+X11Windows[X11DrawablesMap[parent]].ry;
  }
  if( value_mask&CWWidth ){
    X11Windows[X11DrawablesMap[w]].width = values->width;
    X11Windows[X11DrawablesMap[w]].rwidth = values->width;
  }
  if( value_mask&CWHeight ){
    X11Windows[X11DrawablesMap[w]].height = values->height;
    X11Windows[X11DrawablesMap[w]].rheight = values->height;
  }

  adjustreal( w );
  adjustchildren( w );

  win = X11DrawablesWindows[X11DrawablesMap[root]];

  Events_AddConfigure( w );
  Events_ConfigureChildren( w );
#if 1
  Events_AddExpose( w );
  Events_ExposeChildren( w );
#endif

  if( !win )
    return 0;
  if( parent == ROOTID ){
    ChangeWindowBox(win,
		    X11Windows[X11DrawablesMap[w]].x,
		    X11Windows[X11DrawablesMap[w]].y,
		    X11Windows[X11DrawablesMap[w]].width+win->BorderLeft+win->BorderRight,
		    X11Windows[X11DrawablesMap[w]].height+win->BorderTop+win->BorderBottom);
  }

  return(0);
}

/********************************************************************************
Name     : XMoveResizeWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the ID of the window to be reconfigured.

     x
     y
              Specify the new x and y coordinates of the  upper-left  pixel
              of the window's border, relative to the window's parent.

     width
     height
              Specify the new width and height in pixels.  These  arguments
              define the interior size of the window.

Output   : 
Function : change the size and position of a window.
********************************************************************************/

XMoveResizeWindow( Display * display,
		   Window w,
		   int x,
		   int y,
		   unsigned int width,
		   unsigned int height )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XMOVERESIZEWINDOW, bInformWindows );
#endif

  XMoveWindow(display,w,x,y);
  XResizeWindow(display,w,width,height);

  return(0);
}

/********************************************************************************
Name     : XMoveWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the ID of the window to be moved.

     x
     y
              Specify the new x and y coordinates of the  upper-left  pixel
              of the window's border (or of the window itself, if it has no
              border), relative to the window's parent.

Output   : 
Function : move a window.
********************************************************************************/

XMoveWindow( Display* display,
	     Window win,
	     int x,
	     int y )
{
  int parent = X11Windows[X11DrawablesMap[win]].parent;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XMOVEWINDOW, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XMoveWindow %d by %d %d\n",win,x,y);
#endif
#if 0
  if( X11Windows[X11DrawablesMap[win]].x == x
      && X11Windows[X11DrawablesMap[win]].y == y ){
    printf("Already there..\n");
    return;
  }
#endif
  if( parent == ROOTID ){
    X11Windows[X11DrawablesMap[win]].x = x;
    X11Windows[X11DrawablesMap[win]].y = y;
  } else {
    X11Windows[X11DrawablesMap[win]].x = x;
    X11Windows[X11DrawablesMap[win]].y = y;
    if( x<0 )
      X11Windows[X11DrawablesMap[win]].RelX = -x;
    if( y<0 )
      X11Windows[X11DrawablesMap[win]].RelY = -y;
    X11Windows[X11DrawablesMap[win]].rx = X11Windows[X11DrawablesMap[parent]].rx+X11Windows[X11DrawablesMap[win]].x;
    X11Windows[X11DrawablesMap[win]].ry = X11Windows[X11DrawablesMap[parent]].ry+X11Windows[X11DrawablesMap[win]].y;
#if 0
    if( x>0 )
      if( x+X11Windows[X11DrawablesMap[win]].width>
	 X11Windows[X11DrawablesMap[parent]].width )
	X11Windows[X11DrawablesMap[win]].RelWidth =
	  X11Windows[X11DrawablesMap[parent]].width - x;
    if( y>0 )
      if( y+X11Windows[X11DrawablesMap[win]].height>
	 X11Windows[X11DrawablesMap[parent]].height )
	X11Windows[X11DrawablesMap[win]].RelHeight =
	  X11Windows[X11DrawablesMap[parent]].height - y;
#endif
#if 0
/* def OPTDBG */
    printf("Rel win %d - %d %d %d %d\n",
	   win,
	   X11Windows[X11DrawablesMap[win]].RelX,
	   X11Windows[X11DrawablesMap[win]].RelY,
	   X11Windows[X11DrawablesMap[win]].RelWidth,
	   X11Windows[X11DrawablesMap[win]].RelHeight);
#endif
  }
#if 1
  adjustreal( win );
  adjustchildren( win );
#endif
  XClearWindow( display, win );
  if( parent != ROOTID && GetWinFlag(win,WIN_MAPPED) ){ /* or maybe do the configure part? */
#if 1
    Events_AddConfigure( win );
    Events_ConfigureChildren( win );
#endif
    Events_MapMappedChildren( win );
#if 1
    Events_AddExpose( win );
    Events_ExposeChildren( win );
#endif
  }
  return(0);
}

/********************************************************************************
Name     : XRaiseWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window to be raised to  the  top  of
               the stack.

Output   : 
Function : raise a window to the top of the stacking order.
********************************************************************************/

XRaiseWindow( Display* display, Window w )
{

#if (DEBUGXEMUL_ENTRY)
  FunCount_Enter( XRAISEWINDOW, bInformWindows );
#endif
#ifdef OPTDBG
  printf("XRaiseWindow %d\n",w);
#endif

  Events_AddConfigure( w );
  if( X11Windows[X11DrawablesMap[w]].parent == ROOTID ){
    struct Window *win = X11DrawablesWindows[X11DrawablesMap[w]];

    assert(win);
    ChangeWindowBox(win,
		    X11Windows[X11DrawablesMap[w]].x,
		    X11Windows[X11DrawablesMap[w]].y,
		    X11Windows[X11DrawablesMap[w]].width+win->BorderLeft+win->BorderRight,
		    X11Windows[X11DrawablesMap[w]].height+win->BorderTop+win->BorderBottom);
    WindowToFront(X11DrawablesWindows[X11DrawablesMap[w]]);
  }

#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  FunCount_Leave( XRAISEWINDOW, bInformWindows );
#endif

  return(0);
}

/********************************************************************************
Name     : XReconfigureWMWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to an X server; returned from
               XOpenDisplay().

     w         Specifies the window.

     screen_number
               Specifies the appropriate screen number on the host server.

     value_mask
               Specifies which values are to be set using information in
               the values structure.  This mask is the bitwise inclusive OR
               of the valid configure window values bits.

     values    Specifies a pointer to the XWindowChanges structure.

Output   : 
Function : request that a top-level window be reconfigured.
********************************************************************************/

Status
XReconfigureWMWindow( Display* display,
		      Window win,
		      int screen_number,
		      unsigned int value_mask,
		      XWindowChanges* values )
{
  X11Window *aw;
  XWindowChanges xwc;
  int parent = X11Windows[X11DrawablesMap[win]].parent;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XRECONFIGUREWMWINDOW, bInformWindows );
#endif

  if( X11Drawables[win]!=X11WINDOW )
    return; /* not window */
  aw = &X11Windows[X11DrawablesMap[win]];
  if( value_mask&PPosition ){
    aw->x = values->x;
    aw->y = values->y;
    if( parent != ROOTID ){
      aw->rx = X11Windows[X11DrawablesMap[parent]].rx+values->x;
      aw->ry = X11Windows[X11DrawablesMap[parent]].ry+values->y;
    }
  }
  if( value_mask&PSize ){
    aw->width = values->width;
    aw->height = values->height;
    aw->rwidth = aw->width;
    aw->rheight = aw->height;
  }
  if( aw->x+aw->width>DG.wb->Width ){
    aw->x = DG.wb->Width-aw->width;
  }
  if( aw->y+aw->height>DG.wb->Height ){
    aw->y = DG.wb->Height-aw->height;
  }
  adjustreal( win );
  xwc.x = aw->x;
  xwc.y = aw->y;
  xwc.width = aw->width;
  xwc.height = aw->height;
  adjustchildren( win );

  if( GetWinFlag(win,WIN_MAPPED) && X11Windows[X11DrawablesMap[win]].parent == ROOTID ){
    XConfigureWindow(display,win,CWX|CWY|CWWidth|CWHeight,&xwc);
  } else {
#if 1
    Events_AddConfigure( win );
    Events_ConfigureChildren( win );
#endif
#if 0
    Events_AddExpose( win );
    Events_ExposeChildren( win );
#endif
  }

  return(0);
}

/********************************************************************************
Name     : XResizeWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window to be resized.

     width
     height
               Specify the new dimensions of the window in pixels.

Output   : 
Function : change a window's size.
********************************************************************************/

XResizeWindow( Display* display,
	       Window win,
	       unsigned int width,
	       unsigned int height )
{
  struct Window *w;
  int root = X11Windows[X11DrawablesMap[win]].root;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XRESIZEWINDOW, bInformWindows );
#endif

  if( X11Drawables[win]==X11BITMAP ) {
#ifdef DEBUGX11BITMAP
    printf("resize bitmap with XResizeWindow?\n"); 
#endif

    return;
  }

  X11Windows[X11DrawablesMap[win]].width = width;
  X11Windows[X11DrawablesMap[win]].height = height;
  
  X11Windows[X11DrawablesMap[win]].rwidth = width;
  X11Windows[X11DrawablesMap[win]].rheight = height;

  adjustreal( win );
  adjustchildren( win );

  if( !GetWinFlag(win,WIN_MAPPED) )
    return;

  {
#if 1
    Events_AddConfigure( win );
    Events_ConfigureChildren( win );
#endif
#if 0
    Events_AddExpose( win );
    Events_ExposeChildren( win );
#endif
  }

  w = X11DrawablesWindows[X11DrawablesMap[root]];
  if( !w )
    return 0;
  Window_DrawBorder(win);
  if (X11Windows[X11DrawablesMap[win]].parent == ROOTID ){
    ChangeWindowBox(w,w->LeftEdge,w->TopEdge,width+w->BorderLeft+w->BorderRight,
		    height+w->BorderTop+w->BorderBottom);

    SetRast(w->RPort,(UBYTE)X11DrawablesBackground[win]);
  }

  return(0);
}


void
X11Windows_Exit( void )
{
  int i;

  for( i=0; i<DG.X11NumDrawablesWindows; i++ ){
    Map_Exit( X11Windows[i].mChildren );
    Map_Exit( X11Windows[i].mMappedChildren );
  }
}

void
X11Windows_Init( void )
{
}
/*
XUnmapSubwindows(){
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUnmapSubwindows\n");
#endif
  return(0);
}
*/
