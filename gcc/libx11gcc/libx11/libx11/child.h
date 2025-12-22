/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     child
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jun 29, 1997: Created.
***/

#ifndef CHILD
#define CHILD

#if (DEBUG!=0)

int GetWinIndex( int v );
int GetWinX( int v );
int GetWinY( int v );
int GetWinRX( int v );
int GetWinRY( int v );
int GetWinWidth( int v );
int GetWinHeight( int v );
int GetWinRWidth( int v );
int GetWinRHeight( int v );
int GetWinBorder( int v );
int GetWinParent( int v );

int GetWinFlag( int v, int flag );
int SetWinFlag( int v, int flag  );
int ClearWinFlag( int v, int flag  );
int GetWinFlagD( int v, int flag  );
int SetWinFlagD( int v, int flag  );
int ClearWinFlagD( int v, int flag  );

#else /* Not debug */

#define GetWinFlag(i,n) (X11Windows[X11DrawablesMap[(i)]].flags & (n))
#define SetWinFlag(i,n) (X11Windows[X11DrawablesMap[(i)]].flags |= (n))
#define ClearWinFlag(i,n) (X11Windows[X11DrawablesMap[(i)]].flags &= ~(n))

#define GetWinFlagD(i,n) (X11Windows[(i)].flags & (n))
#define SetWinFlagD(i,n) (X11Windows[(i)].flags |= (n))
#define ClearWinFlagD(i,n) (X11Windows[(i)].flags &= ~(n))

#define GetWinX( v ) X11Windows[X11DrawablesMap[(v)]].x
#define GetWinY( v ) X11Windows[X11DrawablesMap[(v)]].y
#define GetWinRX( v ) X11Windows[X11DrawablesMap[(v)]].rx
#define GetWinRY( v ) X11Windows[X11DrawablesMap[(v)]].ry
#define GetWinWidth( v ) X11Windows[X11DrawablesMap[(v)]].width
#define GetWinHeight( v ) X11Windows[X11DrawablesMap[(v)]].height
#define GetWinRWidth( v ) X11Windows[X11DrawablesMap[(v)]].rwidth
#define GetWinRHeight( v ) X11Windows[X11DrawablesMap[(v)]].rheight
#define GetWinBorder( v ) X11Windows[X11DrawablesMap[(v)]].border
#define GetWinParent( v ) X11Windows[X11DrawablesMap[(v)]].parent
#define GetWinIndex( v ) X11DrawablesMap[(v)]

#endif

#endif /* CHILD */
