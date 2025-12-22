/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     drawing
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 7, 1996: Created.
***/

#ifndef DRAWING
#define DRAWING

enum {
  Polygon_Open=1,
  Polygon_Closed
};

#include "defines.h"

X11FillPolygon( struct RastPort *drp,
	        XPoint *points,
	        int nPoints,
	        int xmin,
	        int ymin,
	        int vXOff,
	        int vYOff,
	        char black );

void
X11ClearPattern( Window win,
		int x,
		int y,
		int w,
		int h,
		int background );

void X11init_drawing( void );
XPoint *X11Expand_Points( XPoint *aPoints, int n );
void X11exit_drawing( void );

void
polygon_clip( int nPoints,
	      XPoint *points,
	      boolean bFill,
	      int PolygonType,
	      int *nPointsReturn,
	      int move,
	      int end );

void 
polygon_findminmax( XPoint *aPoints,
		    int nPoints,
		    int *xmin,
		    int *xmax,
		    int *ymin,
		    int *ymax );

void MakeBevel( XPoint *xp1, XPoint *xp2 );

boolean
MakeMiter( Display *d,
	   Drawable win,
	   GC gc,
	   XPoint *xp1,
	   XPoint *xp2 );

boolean
GetCrossing( XPoint p1,
	     XPoint p2,
	     XPoint p3,
	     XPoint p4,
	     XPoint *pRet );

#endif /* DRAWING */
