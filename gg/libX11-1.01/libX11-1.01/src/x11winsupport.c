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

/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11winsupport
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 7, 1997: Created.
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

/********************************************************************************
Name     : XSetWindowBorder()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the window ID.  Must be an InputOutput window.

     border_pixel
              Specifies the colormap entry with which the server will paint
              the border.

Output   : 
Function : change a window border pixel value attribute and repaint the border.
********************************************************************************/

XSetWindowBorder( Display* display,
		  Window w,
		  unsigned long border_pixel )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XSetWindowBorder\n");
#endif

  return 0;
}

/********************************************************************************
Name     : XClearArea()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the ID of an InputOutput window.

     x
     y
              Specify the x and y coordinates of the upper-left  corner  of
              the  rectangle  to  be cleared, relative to the origin of the
              window.

     width    Specify the dimensions in  pixels  of  the  rectangle  to  be
              cleared.
     height

     exposures
              Specifies whether exposure events  are  generated.   Must  be
              either True or False.

Output   : 
Function : clear a rectangular area in a window.
********************************************************************************/

XClearArea( Display* display,
	    Window win,
	    int x,
	    int y,
	    unsigned int width,
	    unsigned int height,
	    Bool exposures )
{
  int endx,endy;
  int oldfg,olddrmd;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCLEARAREA, bInformWindows );
#endif

  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  endx = x+width-1;
  endy = y+height-1;
  oldfg = DG.drp->FgPen;
  olddrmd = DG.drp->DrawMode;
#ifdef XMUI
  if( X11Drawables[win]==X11MUI ){
    MUISetAPenBG( win );
  } else
#endif
    SetAPen(DG.drp,X11DrawablesBackground[win]);
  SetDrMd(DG.drp,JAM1);
  if( !width || endx>DG.vWinWidth )
    endx = DG.vWinWidth;
  if( !height || endy>DG.vWinHeight )
    endy = DG.vWinHeight;
  if( x<0 )
    x = 0;
  if( y<0 )
    y = 0;
  RectFill( DG.drp, DG.vWinX+x, DG.vWinY+y, DG.vWinX+endx, DG.vWinY+endy );
  DG.drp->DrawMode = olddrmd;
  DG.drp->FgPen = oldfg;
  vPrevGC = (GC)-1;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Leave( XCLEARAREA, bInformWindows );
#endif

  return(0);
}

/********************************************************************************
Name     : XSetScreenSaver()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     timeout   Specifies the time of inactivity,  in  seconds,  before  the
               screen saver turns on.

     interval  Specifies the interval, in  seconds,  between  screen  saver
               invocations.   This  is  for  intermittent  changes  to  the
               display, not blanking.

     prefer_blanking
               Specifies  whether  to  enable  screen  blanking.   Possible
               values    are    DontPreferBlanking,    PreferBlanking,   or
               DefaultBlanking.

     allow_exposures
               Specifies the current screen saver control values.  Possible
               values    are    DontAllowExposures,    AllowExposures,   or
               DefaultExposures.

Output   : 
Function : set the parameters of the screen saver.
********************************************************************************/

XSetScreenSaver( Display* display,
		 int timeout,
		 int interval,
		 int prefer_blanking,
		 int allow_exposures )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XSetScreenSaver\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XForceScreenSaver()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     mode      Specifies whether the screen saver is active or reset.   The
               possible modes are: ScreenSaverActive or ScreenSaverReset.

Output   : 
Function : turn the screen saver on or off.
********************************************************************************/

XForceScreenSaver( Display* display, int mode )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XForceScreenSaver\n");
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

#if 0
int XSynchronize(Display *d,Bool b){
  return(0);
}
#endif

/********************************************************************************
Name     : XChangeProperty()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window whose property  you  want  to
               change.

     property  Specifies the property atom.

     type      Specifies the type of the property.  X  does  not  interpret
               the  type,  but simply passes it back to an application that
               later calls XGetWindowProperty.

     format    Specifies whether the data should be viewed as a list of  8-
               bit,  16-bit, or 32-bit quantities.  This information allows
               the X server to correctly perform  byte-swap  operations  as
               necessary.   If  the  format  is  16-bit or 32-bit, you must
               explicitly cast your data pointer to a (char *) in the  call
               to XChangeProperty().  Possible values are 8, 16, and 32.

     mode      Specifies the mode of the operation.   Possible  values  are
               PropModeReplace, PropModePrepend, PropModeAppend.

     data      Specifies the property data.

     nelements Specifies the number of elements in the property.

Output   : 
Function : change a property associated with a window.
********************************************************************************/

XChangeProperty( Display* display,
		 Window w,
		 Atom property,
		 Atom type,
		 int format,
		 int mode,
		 unsigned char* data,
		 int nelements )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XChangeProperty\n");
#endif
/*
  if( (int)type==XA_STRING ){
    WriteClip( (char*)data );
  }
*/
  return(0);
}

/********************************************************************************
Name     : XGetScreenSaver()
Author   : Terje Pedersen
Input    :
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     timeout_return
               Returns the idle time, in seconds, until  the  screen  saver
               turns on.

     interval_return
               Returns the interval between screen  saver  invocations,  in
               seconds.

     prefer_blanking_return
               Returns the current screen blanking preference, one of these
               constants:      DontPreferBlanking,    PreferBlanking,    or
               DefaultBlanking.

     allow_exposures_return
               Returns  the  current  screen  save  control  value,  either
               DontAllowExposures, AllowExposures, or DefaultExposures.

Output   : 
Function : get the current screen saver parameters.
********************************************************************************/

XGetScreenSaver(Display* display,
		int* timeout_return,
		int* interval_return,
		int* prefer_blanking_return, 
		int* allow_exposures_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XGetScreenSaver\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XDisplayName()
Author   : Terje Pedersen
Input    : string    Specifies the character string.
Output   : 
Function : 
********************************************************************************/

char *
XDisplayName( char *name )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XDisplayName\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XQueryBestSize()
Author   : Terje Pedersen
Input    : 
     display        Specifies a connection to an X  server;  returned  from
                    XOpenDisplay().

     class          Specifies the class that you are interested  in.   Pass
                    one  of  these  constants:  TileShape,  CursorShape, or
                    StippleShape.

     which_screen   Specifies a drawable ID that  tells  the  server  which
                    screen you want the best size for.

     width
     height
                    Specify the preferred width and height in pixels.

     width_return
     height_return
                    Return the  closest  supported  width  and  height,  in
                    pixels,   available  for  the  object  on  the  display
                    hardware.

Output   : 
Function : obtain the "best" supported cursor, tile, or stipple size.
********************************************************************************/

Status
XQueryBestSize( Display *display,
	        int class,
	        Drawable which_screen,
	        unsigned int width,
	        unsigned int height,
	        unsigned int* width_return,
	        unsigned int* height_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XQueryBestSize\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XCirculateSubwindows()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the window ID of the parent of the  subwindows  to
               be circulated.

     direction Specifies the direction  (up  or  down)  that  you  want  to
               circulate   the   children.   Pass   either  RaiseLowest  or
               LowerHighest.

Output   : 
Function : circulate the stacking order of children up or down.
********************************************************************************/

XCirculateSubwindows( Display* display,
		      Window w,
		      int direction )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XCirculateSubwindows\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XWithdrawWindow()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to an X server; returned from
               XOpenDisplay().

     w         Specifies the window.

     screen_number
               Specifies the appropriate screen number on the server.

Output   : 
Function : request that a top-level window be withdrawn.
********************************************************************************/

Status
XWithdrawWindow( Display* display,
		 Window w,
		 int screen_number )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XWITHDRAWWINDOW, bInformWindows );
#endif
  XUnmapWindow(display,w);

  return(0);
}

/********************************************************************************
Name     : XDefaultRootWindow()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Window
XDefaultRootWindow( Display *d )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XDEFAULTROOTWINDOW, bInformWindows );
#endif

  return(RootWindowOfScreen(DefaultScreenOfDisplay(d)));
}

/********************************************************************************
Name     : XGetGeometry()
Author   : Terje Pedersen
Input    : 
     display     Specifies a connection  to  an  X  server;  returned  from
                 XOpenDisplay().

     drawable    Specifies the drawable, either a window or a pixmap.

     root_return Returns the root window ID of the specified window.

     x_return
     y_return
                 Return the coordinates of  the  upper-left  pixel  of  the
                 window's  border,  relative  to  its parent's origin.  For
                 pixmaps, these coordinates are always zero.

     width_return
     height_return
                 Return the dimensions of  the  drawable.   For  a  window,
                 these return the inside size (not including the border).

     border_width_return
                 Returns  the  borderwidth,  in  pixels,  of  the  window's
                 border,  if the drawable is a window.  Returns zero if the
                 drawable is a pixmap.

     depth_returnReturns the depth of the pixmap  or window (bits per pixel
                 for the object).

Output   : 
Function : obtain the current geometry of drawable.
********************************************************************************/

Status
XGetGeometry( Display* display,
	      Drawable drawable,
	      Window* root_return,
	      int* x_return,
	      int* y_return,
	      unsigned int* width_return,
	      unsigned int* height_return,
	      unsigned int* border_width_return,
	      unsigned int* depth_return )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XGETGEOMETRY, bInformWindows );
#endif

  if( border_width_return )
    *border_width_return=0;
  if( X11Drawables[drawable]==X11WINDOW ){
    int root = X11Windows[X11DrawablesMap[drawable]].root;
    struct Window *win = X11DrawablesWindows[X11DrawablesMap[root]];

    if( !win )
      return 0;
    *width_return = win->Width-(win->BorderLeft+win->BorderRight);;
    *height_return = win->Height-(win->BorderTop+win->BorderBottom);
    *depth_return = win->RPort->BitMap->Depth;
    *x_return = X11Windows[X11DrawablesMap[drawable]].x;
    *y_return = X11Windows[X11DrawablesMap[drawable]].y;
  } else if( X11Drawables[drawable]==X11BITMAP ){
    *x_return = 0;
    *y_return = 0;
    *width_return = X11DrawablesBitmaps[X11DrawablesMap[drawable]].width;
    *height_return = X11DrawablesBitmaps[X11DrawablesMap[drawable]].height;
    *border_width_return = 0;
    *depth_return = X11DrawablesBitmaps[X11DrawablesMap[drawable]].depth;
  } else if( X11Drawables[drawable]==X11MUI ){
  } 

  return(TRUE);
}

/********************************************************************************
Name     : XGetWMName()
Author   : Terje Pedersen
Input    : 
 display    Specifies  a  connection  to  an   X   server;   returned   from
           XOpenDisplay().
 w         Specifies the window.
 text_prop_return
           Returns the XTextProperty structure.

Output   : 
Function : 
********************************************************************************/

XGetWMName( Display* display,
	    Window w,
	    XTextProperty* text_prop_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XGetWMName\n");
#endif
  text_prop_return->value = X11Windows[X11DrawablesMap[w]].name;

  return(0);
}

/********************************************************************************
Name     : XSetWMName()
Author   : Terje Pedersen
Input    : 
 display    Specifies  a  connection  to  an   X   server;   returned   from
           XOpenDisplay().
 w         Specifies the window.
 text_prop Specifies the XTextProperty structure to be used.

Output   : 
Function : 
********************************************************************************/

void
XSetWMName( Display* display,
	    Window w,
	    XTextProperty* text_prop )
{
  struct Window *win;
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XSetWMName\n");
#endif
  X11Windows[X11DrawablesMap[w]].name = text_prop->value;
  if( GetWinFlag(w,WIN_MAPPED) ){
    int root = X11Windows[X11DrawablesMap[w]].root;
    win = X11DrawablesWindows[X11DrawablesMap[root]];
    SetWindowTitles(win,X11Windows[X11DrawablesMap[w]].name,text_prop->value);
  }

  return;
}

/********************************************************************************
Name     : XParseGeometry()
Author   : Terje Pedersen
Input    : 
     parsestring Specifies the string you want to parse.

     x_return
     y_return
                 Return the x and y coordinates (offsets) from the string.

     width_return
     height_return
                 Return the width and height in pixels from the string.


Output   : 
Function : generate position and size from standard window geometry string.
********************************************************************************/

int
XParseGeometry( char* parsestring,
	        int* x_return,
	        int* y_return,
	        unsigned int* width_return,
	        unsigned int* height_return )
{
  int n;
  int ret = 0;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPARSEGEOMETRY, bInformWindows );
#endif
  if( !parsestring )
    return;
  *x_return = 0;
  *y_return = 0;
  *width_return = 0;
  *height_return = 0;
  if( strchr(parsestring,'x') ){
    sscanf(parsestring,"%dx%d",width_return,height_return);
    ret = WidthValue|HeightValue;
  }
  if( strchr(parsestring,'+')!=0
      || strchr(parsestring,'-') ){
    ret = ret|XValue|YValue;
    sscanf(parsestring,"%dx%d%d%d",&n,&n,x_return,y_return);
  }

  return(ret);
}

/********************************************************************************
Name     : XStoreName()
Author   : Terje Pedersen
Input    : 
 display    Specifies  a  connection  to  an   X   server;   returned   from
           XOpenDisplay().
 w         Specifies the ID of the window to which  you  want  to  assign  a
           name.
 window_name
           Specifies the name of the window.  The name  should  be  a  null-
           terminated  string.   If  the  string is not in the Host Portable
           Character Encoding, the result is implementation-dependent.  This
           name is returned by any subsequent call to

Output   : 
Function : Place a name in the window header.
********************************************************************************/

XStoreName( Display* display, Window w, char* window_name )
{
  struct Window *win;
  char *str;
  extern char *LibX11Info;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSTORENAME, bInformWindows );
#endif
  if( X11Drawables[w]!=X11WINDOW )
    return; /* not window */

  str = (char*)malloc(strlen(window_name)+1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)str);
#endif /* MEMORYTRACKING */
  strcpy(str,window_name);
  X11Windows[X11DrawablesMap[w]].name = str;
  if( GetWinFlag(w,WIN_MAPPED) ){
    int root = X11Windows[X11DrawablesMap[w]].root;
    win = X11DrawablesWindows[X11DrawablesMap[root]];
    SetWindowTitles(win,X11Windows[X11DrawablesMap[w]].name,LibX11Info);
  }

  return(0);
}

/********************************************************************************
Name     : XWMGeometry()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to an X server; returned from
               XOpenDisplay().

     screen    Specifies the screen.

     user_geom Specifies the user-specified geometry or NULL.

     def_geom  Specifies the application's default geometry or NULL.

     bwidth    Specifies the border width.

     hints     Specifies the size hints for the window in its normal state.

     x_return
     y_return  Return the x and y offsets.

     width
     height_return
               Return the width and height determined.

     gravity_return
               Returns the window gravity.

Output   : 
Function : obtain a window's geometry information.
********************************************************************************/

int
XWMGeometry( Display* display,
	     int screen,
	     char* user_geom,
	     char* def_geom,
	     unsigned int bwidth_return,
	     XSizeHints* hints,
	     int* x_return,
	     int* y_return,
	     int* width_return,
	     int* height_return,
	     int* gravity_return )
{
  XWindowAttributes xattr;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XWMGEOMETRY, bInformWindows );
#endif
  XGetWindowAttributes(display,RootWindow(display,screen),&xattr);
  *x_return = xattr.x;
  *y_return = xattr.y;
  *width_return = xattr.width;
  *height_return = xattr.height;
  *gravity_return = 0;

  return(0);
}

/********************************************************************************
Name     : XQueryTree()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     w         Specifies the ID of the window  to  be  queried.   For  this
               window,  XQueryTree()  will list its children, its root, its
               parent, and the number of children.

     root_return
               Returns the root ID for the specified window.

     parent_return
               Returns the parent window of the specified window.

     children_return
               Returns the list of children associated with  the  specified
               window.

     nchildren_return
               Returns the number of children associated with the specified
               window.

Output   : 
Function : return a list of children, parent, and root.
********************************************************************************/

Status
XQueryTree( Display* display,
	    Window w,
	    Window* root_return,
	    Window* parent_return,
	    Window** children_return,
	    unsigned int* nchildren_return )
{
  int i;
  int childrens;
  IMap_p pChildren;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XQUERYTREE, bInformWindows );
#endif

  *children_return = NULL;
  *nchildren_return = 0;
  *root_return = DefaultRootWindow(display);
  if( w==ROOTID ){
#if 0
    printf("*** Requesting ROOT! ***\n");
#endif
    *parent_return = ROOTID;
    *root_return = ROOTID;
  } else {
    *parent_return = X11Windows[X11DrawablesMap[w]].parent;
  }

  pChildren = X11Windows[X11DrawablesMap[w]].mChildren;

  childrens = pChildren->nTopEntry;

  *nchildren_return = childrens;
  if( childrens ){
    Window *aWins;
    int n = 0;

    aWins = (Window*)malloc(sizeof(Window)*(childrens));
#if (MEMORYTRACKING!=0)
    List_AddEntry(pMemoryList,(void*)aWins);
#endif /* MEMORYTRACKING */
    for( i=0; i<pChildren->nTopEntry; i++ )
      aWins[n++] = pChildren->pData[i];
    *children_return = aWins;
  }

#if 0
  if( !childrens && w==ROOTID ){
    Window *aWins;
    int n = 0;

    aWins = (Window*)malloc(sizeof(Window)*(DG.X11NumDrawablesWindows));
#if (MEMORYTRACKING!=0)
    List_AddEntry(pMemoryList,(void*)aWins);
#endif /* MEMORYTRACKING */
    for( i=0; i<DG.X11NumDrawablesWindows; i++ )
      if( X11Windows[i].parent==ROOTID ){
	aWins[n++] = (Window)X11Windows[i].win;
      }
    *children_return = aWins;
  }
#endif
  return(1);
}

/********************************************************************************
Name     : XSetStandardProperties()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSetStandardProperties( Display* display,
		        Window w,
		        char* window_name,
		        char* icon_name,
		        Pixmap icon_pixmap,
		        char** argv,
		        int argc,
		        XSizeHints* hints )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETSTANDARDPROPERTIES, bInformWindows );
#endif
  if( X11Drawables[w]!=X11WINDOW )
    return; /* not window */
  X11Windows[X11DrawablesMap[w]].name=window_name;

  return(0);
}

/********************************************************************************
Name     : XChangeWindowAttributes()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XChangeWindowAttributes( Display* display,
			 Window w,
			 unsigned long valuemask,
			 XSetWindowAttributes* attributes )
{
#ifdef DEBUGXEMUL_ENTRY
  if( bInformWindows )
    printf("XChangeWindowAttributes %d mask %d\n",w,valuemask);
#endif
  if( valuemask&CWEventMask ){
    XSelectInput(display,w,(long)attributes->event_mask);
  }
  if( valuemask&CWColormap ){
    XSetWindowColormap(display,w,attributes->colormap);
  }
  if( valuemask&CWCursor )
    XDefineCursor(display,w,attributes->cursor);

  return(0);
}

/********************************************************************************
Name     : XGetWindowAttributes()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the window whose current attributes you want.

     window_attributes_return
              Returns a filled XWindowAttributes structure, containing  the
              current attributes for the specified window.

Output   : 
Function : obtain the current attributes of window.
********************************************************************************/

Status
XGetWindowAttributes( Display* display, 
		      Window win, 
		      XWindowAttributes* window_attributes_return )
{
  struct Window *w = NULL;
  int root = X11Windows[X11DrawablesMap[win]].root;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XGETWINDOWATTRIBUTES, bInformWindows );
#endif

  if( X11Drawables[win]==X11BITMAP ) {
#ifdef DEBUGX11BITMAP
    printf("XGetWindowAttributes to bitmap?\n"); 
#endif

    return;
  }
  if( X11Drawables[win]==X11WINDOW )
    w = X11DrawablesWindows[X11DrawablesMap[root]];
#ifdef XMUI
  else if( X11Drawables[win]==X11MUI ){
    int l,t,w,h;

    MUIGetWin( win, &w, &l,&t,&w,&h);
  }
#endif

  if( !w )
    return 0;

  window_attributes_return->x = w->LeftEdge+w->BorderLeft;
  window_attributes_return->y = w->TopEdge+w->BorderTop;
  window_attributes_return->depth = w->RPort->BitMap->Depth;
  window_attributes_return->width = w->Width-(w->BorderLeft+w->BorderRight);
  window_attributes_return->height = w->Height-(w->BorderTop+w->BorderBottom);
  window_attributes_return->border_width = 0;

  return(1);
}

/********************************************************************************
Name     : XSetWindowBackgroundPixmap()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
              XOpenDisplay().

     w        Specifies the  window  ID.   Must  be  an  InputOutput  class
              window.

     background_pixmap
              Specifies a pixmap ID, None or ParentRelative, to be used  as
              a background.

Output   : 
Function : change the background tile attribute of a window.
********************************************************************************/

XSetWindowBackgroundPixmap( Display* display,
			    Window w,
			    Pixmap background_pixmap )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreWindowWarnings )
    printf("WARNING: XSetWindowBackgroundPixmap\n");
#endif

  if( X11Drawables[w] == X11WINDOW ){
    X11Windows[X11DrawablesMap[w]].pixmap = background_pixmap;
  }
  return(0);
}

XSetSelectionOwner( Display* d,
		    Atom     selection,
		    Window   owner,
		    Time     t )
{
  XEvent ievent;
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetSelectionOwner\n");
#endif

  ievent.type = SelectionRequest;
  ievent.xselectionrequest.owner = ievent.xany.window = owner;
  ievent.xselectionrequest.target = XA_STRING;
  ievent.xselectionrequest.requestor = ROOTID;

  Events_NewInternalXEvent( &ievent, sizeof(XSelectionRequestEvent) );

  return(0);
}

