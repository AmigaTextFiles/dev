/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     xaw
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 1, 1997: Created.
***/

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include <X11/Xmu/WidgetNode.h>
#include <X11/Xaw/AllWidgets.h>
#include <X11/Xaw/List.h>
#include <X11/Xaw/Text.h>
#include <X11/Xaw/TextSrc.h>

#include <stdio.h>

int pannerWidgetClass;
int portholeWidgetClass;
int panedWidgetClass;
WidgetClass widgetClass;

XawInitializeWidgetSet()
{
}

XtPointer
XawToggleGetCurrent( Widget radio_group )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawToggleGetCurrent\n");
#endif
  return(0);
}

void
XawToggleUnsetCurrent( Widget radio_group )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawToggleUnsetCurrent\n");
#endif
  return(0);
}

void
XawListHighlight( Widget w, int item )
{/*        File 'fontSelect.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawListHighlight\n");
#endif
  return(0);
}

void
XawListChange( Widget w,
	       String* list,
	       int nitems,
	       int longest,
	       int resize )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawListChange\n");
#endif
  return(0);
}

XawListReturnStruct*
XawListShowCurrent(Widget w )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XawListShowCurrent\n");
#endif
  return(0);
}

void
XawTextEnableRedisplay( Widget w )
{
}

void
XawTextDisableRedisplay( Widget w )
{
}

XawTextPosition
XawTextSourceScan( Widget w,
		   XawTextPosition position,
#if NeedWidePrototypes
		   int type,
		   int dir,
#else
		   XawTextScanType type,
		   XawTextScanDirection dir,
#endif
		   int count,
#if NeedWidePrototypes
		   int include
#else
		   Boolean include
#endif
)
{
}

Widget
XawTextGetSource( Widget w )
{
}

void
XawTextSetInsertionPoint( Widget w,
			  XawTextPosition position )
{
}

void
XawFormDoLayout( Widget w,
#if NeedWidePrototypes
		 int do_layout
#else
		 Boolean do_layout
#endif
)
{
}

char*
XawDialogGetValueString( Widget w )
{
}

int
XawTextReplace( Widget		w,
	        XawTextPosition	start,
	        XawTextPosition	end,
	        XawTextBlock*	text)
{
}
