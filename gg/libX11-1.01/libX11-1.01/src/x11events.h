/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11events
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 2, 1996: Created.
***/

#ifndef X11EVENTS
#define X11EVENTS

#if 0
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#endif

typedef struct {
  unsigned short key;
  unsigned short shiftkey;
  unsigned char symbol;
  char*  name;
  char*  shiftname;
} KeySym_Map;

extern KeySym_Map XKeys[];

/********************************************************************************/
/* Prototypes */
/********************************************************************************/

void Events_Init( void );
void Events_Exit( void );
void Events_MapRawKey( struct IntuiMessage *im );
char Events_LookupKey( char *key );
void Events_GetIntui(void);
int  Events_HandleButtons( XEvent *event, int code );
int  Events_Get( XEvent *event );
void Events_NewInternalXEvent( XEvent *event,int size );
int  Events_NextInternalXEvent( XEvent *event );
void Events_AddEvent( Window win, int type, int size );
void Events_AddChildEvent( Window win, int type, int size );

void Events_AddExpose( Drawable win );
void Events_ExposeChildren( Drawable win );
void Events_AddConfigure( Drawable win );
void Events_ConfigureChildren( Drawable win );
void Events_AddMapEvents( Window win );
int Events_NextInternalWindowXEvent( XEvent *event, Window win );

/********************************************************************************/
/* X11 prototypes */
/********************************************************************************/

#if 0
int XLookupString( XKeyEvent* event_structure, 
		   char* buffer_return,
		   int bytes_buffer,
		   KeySym* keysym_return,
		   XComposeStatus *status_in_out );
#endif

Bool
XQueryPointer(Display* display,
	      Window w,
	      Window* root_return,
	      Window* child_return,
	      int* root_x_return,
	      int* root_y_return,
	      int* win_x_return,
	      int* win_y_return,
	      unsigned int* mask_return );

Bool
XCheckIfEvent(Display* display,
	      XEvent* event_return,
	      Bool (*
#if 1
__stdargs
#endif
predicate)(Display *,XEvent*,char *data),
	      char* arg );

XWindowEvent(Display* display,
	     Window w,
	     long event_mask,
	     XEvent* event_return );

Bool
XCheckTypedEvent(Display* display,
		 int event_type,
		 XEvent* event_return );

int XEventsQueued( Display *display, int  mode );

XRefreshKeyboardMapping( XMappingEvent* map_event );
XFlush( Display *d );

KeySym XLookupKeysym( XKeyEvent* event, int index );
char* XKeysymToString( KeySym keysym );

Bool
XCheckWindowEvent(Display* display,
		  Window w,
		  long event_mask,
		  XEvent* event_return );

XSetInputFocus(Display* display,
	       Window focus,
	       int revert_to,
	       Time time );

int
XGrabPointer( Display* display,
	      Window grab_window,
	      Bool owner_events,
	      unsigned int event_mask,
	      int pointer_mode,
	      int keyboard_mode,
	      Window confine_to,
	      Cursor cursor,
	      Time time );

XUngrabPointer( Display* display, Time time );

#if 0
XSetNormalHints( Display* display,
		 Window w,
		 XSizeHints* hints );
#endif

XIfEvent( Display* display,
	  XEvent* event_return,
	  Bool (*
#if 1
__stdargs
#endif
		predicate)(Display *,XEvent*,char *data),
	  char* args );

Status
XSendEvent( Display* display,
	    Window w,
	    Bool propagate,
	    long event_mask,
	    XEvent* event_send );

XPutBackEvent( Display* display,
	       XEvent* event );

#if 0
int 
XtGrabPointer(Widget 		 widget,
	      _XtBoolean 		 owner_events,
	      unsigned int	 event_mask,
	      int 		 pointer_mode,
	      int 		 keyboard_mode,
	      Window 		 confine_to,
	      Cursor 		 cursor,
	      Time 		 t );
#endif
#if 0
int
XtGrabKeyboard(Widget 		widget,
	       _XtBoolean 		owner_events,
	       int 		pointer_mode,
	       int 		keyboard_mode,
	       Time 		t );
#endif

XWarpPointer(Display *display,
	     Window src_w,
	     Window dest_w,
	     int src_x,
	     int src_y,
	     unsigned int src_width,
	     unsigned int src_height,
	     int dest_x,
	     int dest_y );

Bool
XCheckMaskEvent( Display* display,
		 long event_mask,
		 XEvent* event_return );

XPeekIfEvent( Display* display,
	      XEvent* event_return,
	      Bool (*
#if 1
__stdargs
#endif
		    predicate)(Display *,XEvent*,char *data),
	      XPointer arg );

#if 0
#ifndef XMUIAPP
XSizeHints* XAllocSizeHints();

XClassHint* XAllocClassHint();
#endif
#endif

XFree( void* data );

Bool
XCheckTypedWindowEvent( Display* display,
		        Window w,
		        int event_type,
		        XEvent* event_return );

extern long Xevent_to_mask[];

void Events_FreeInternalWindowXEvents( Window win );
void Events_MapMappedChildren( Window win );

#endif /* X11EVENTS */
