/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     clipping
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 8, 1996: Created.
***/

#ifndef CLIPPING
#define CLIPPING

void clip_begin(int,int,int,int);
void clip_exclude(int,int,int,int);
void clip_end(struct Window *);
void unclipWindow(struct Layer *l);
struct Region *clipWindow(struct Layer *l,
				 LONG minX, LONG minY, LONG maxX, LONG maxY);

int XSetClipMask(Display *,GC,Pixmap);

#endif /* CLIPPING */
