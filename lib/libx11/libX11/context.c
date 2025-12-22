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
     context
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jun 29, 1995: Created.
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#define MAXID 200
#define MAXCONTEXT 5
int X11resourceID[MAXID];
int X11contextType[MAXID][MAXCONTEXT];
char *X11contextData[MAXID][MAXCONTEXT];
int X11numIDs=0;

int X11Quarks=1;

X11contextoverflow(d){
  printf("Warning: context overflow(%d)..\n",d); getchar();
}

XrmUniqueQuark(){/*          File 'xco.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmUniqueQuark\n");
#endif
/*
  int i;
  for(i=0;i<X11numIDs;i++)
    if(X11resourceID[i]==0){
      return(i);
    }
*/
  return(X11Quarks++);
}

X11findID(XID rid){
  int i;
  for(i=0;i<X11numIDs;i++)
    if(X11resourceID[i]==rid) break;
  if(i<X11numIDs) return(i);
  else{
    for(i=0;i<X11numIDs;i++)
      if(X11resourceID[i]==0){
	X11resourceID[i]=rid;
	return(i);
      }
    X11resourceID[X11numIDs]=rid;
    if(X11numIDs+1==MAXID){
      X11contextoverflow(1);
      return(X11numIDs);
    }
    return(X11numIDs++);
  }
}

int XSaveContext(display, rid, context, data)
     Display *display;
     XID rid;
     XContext context;
     caddr_t data;
{/*            File 'xco.o' */
  int id=X11findID(rid);
#ifdef DEBUGXEMUL_ENTRY
  printf("XSaveContext\n");
#endif
  if(context>=MAXCONTEXT) X11contextoverflow(2);
  X11contextType[id][context]=context;
  X11contextData[id][context]=data;
  return(0);
}

int XDeleteContext(display, rid, context)
     Display *display;
     XID rid;
     XContext context;
{/*          File 'xco.o' */
  int id=X11findID(rid);
#ifdef DEBUGXEMUL_ENTRY
  printf("XDeleteContext\n");
#endif
  if(context>=MAXCONTEXT)X11contextoverflow(3);
  X11contextType[id][context]=0;
  free(X11contextData[id][context]);
  X11contextData[id][context]=NULL;
  X11resourceID[id]=0;
  return(0);
}

int XFindContext(display, rid, context, data_return)
     Display *display;
     XID rid;
     XContext context;
     XPointer *data_return;
{/*            File 'xgraph.o' */
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("XFindContext\n");
#endif
  for(i=0;i<X11numIDs;i++)
    if(X11resourceID[i]==rid) break;
  if(i==X11numIDs) return(1);
  if(context>=MAXCONTEXT)X11contextoverflow(4);
  *data_return=X11contextData[i][context];
  if(*data_return==0) return(1);
  return(0);
}

