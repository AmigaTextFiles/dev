/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11windows
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 2, 1996: Created.
***/

#ifndef X11WINDOWS
#define X11WINDOWS

/********************************************************************************/
/* Prototypes */
/********************************************************************************/

int
XParseGeometry( char* parsestring,
	        int* x_return,
	        int* y_return,
	        unsigned int* width_return,
	        unsigned int* height_return );

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
	       XSetWindowAttributes* attributes );

Window
XCreateSimpleWindow( Display* display,
		     Window parent,
		     int x,
		     int y,
		     unsigned int width,
		     unsigned int height,
		     unsigned int border_width,
		     unsigned long border,
		     unsigned long background );

XDestroyWindow( Display* display, Window win );

XMapRaised( Display* display, Window w );

XUnmapWindow( Display* display, Window w );

XMapWindow( Display* d, Window win );

XStoreName( Display* display, Window w, char* window_name );

XResizeWindow( Display* display,
	       Window win,
	       unsigned int width,
	       unsigned int height );

Status
XGetWindowAttributes( Display* display, 
		      Window win, 
		      XWindowAttributes* window_attributes_return );

XConfigureWindow( Display* display,
		  Window w,
		  unsigned int value_mask,
		  XWindowChanges* values );

XSetWindowBorder( Display* display,
		  Window w,
		  unsigned long border_pixel );

XClearArea( Display* display,
	    Window win,
	    int x,
	    int y,
	    unsigned int width,
	    unsigned int height,
	    Bool exposures );

XClearWindow( Display* display, Window w );

XDestroySubwindows( Display* display, Window w );

XSetScreenSaver( Display* display,
		 int timeout,
		 int interval,
		 int prefer_blanking,
		 int allow_exposures );

XForceScreenSaver( Display* display, int mode );

XMapSubwindows( Display* display, Window w );

XChangeProperty( Display* display,
		 Window w,
		 Atom property,
		 Atom type,
		 int format,
		 int mode,
		 unsigned char* data,
		 int nelements );

XMoveWindow( Display* display,
	     Window win,
	     int x,
	     int y );

XGetScreenSaver(Display* display,
		int* timeout_return,
		int* interval_return,
		int* prefer_blanking_return, 
		int* allow_exposures_return );

char *XDisplayName( char *name );

Status
XQueryBestSize( Display *display,
	        int class,
	        Drawable which_screen,
	        unsigned int width,
	        unsigned int height,
	        unsigned int* width_return,
	        unsigned int* height_return );

XCirculateSubwindows( Display* display,
		      Window w,
		      int direction );


Status
XWithdrawWindow( Display* display,
		 Window w,
		 int screen_number );

Status
XReconfigureWMWindow( Display* display,
		      Window w,
		      int screen_number,
		      unsigned int value_mask,
		      XWindowChanges* values );

Window XDefaultRootWindow( Display *d );

XMoveResizeWindow( Display * display,
		   Window w,
		   int x,
		   int y,
		   unsigned int width,
		   unsigned int height );

Status
XQueryTree( Display* display,
	    Window w,
	    Window* root_return,
	    Window* parent_return,
	    Window** children_return,
	    unsigned int* nchildren_return );

Status
XGetGeometry( Display* display,
	      Drawable drawable,
	      Window* root_return,
	      int* x_return,
	      int* y_return,
	      unsigned int* width_return,
	      unsigned int* height_return,
	      unsigned int* border_width_return,
	      unsigned int* depth_return );

XRaiseWindow( Display* display, Window w );

XSetWindowBackgroundPixmap( Display* display,
			    Window w,
			    Pixmap background_pixmap );

__stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel);

__stdargs unsigned long  XGet_pixel(struct _XImage*,int,int);

void Window_DrawBorder( Window win );

void ResetWindow( struct Window *win, int vW, int vH );

void adjustchildren( Window win );

void X11Windows_Exit( void );
void X11Windows_Init( void );

/********************************************************************************/

#endif /* X11WINDOWS */
