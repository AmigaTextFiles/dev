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
     visuals
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jul 6, 1995: Created.
***/

#include "libX11.h"

#include <libraries/asl.h>
#include <proto/asl.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include <X11/Xlibint.h>

#include "amigax_proto.h"

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
extern struct Library *AslBase;
extern struct Library *GadToolsBase;
extern struct Library *DiskfontBase;
extern struct Library *LayersBase;
extern struct DosLibrary *DOSBase;

extern int usewb;

Visual  amiga_visual;
Visual X11AmigaVisual[2];

XFreeVisualInfo(Display *display, XVisualInfo *vis){
  free(vis);
}

XVisualInfo *X11vis;

void X11SetupVisual(void){
  int i;
  /* fill the visual info with something meaningfull */
  for(i=0;i<2;i++){
    X11AmigaVisual[i].visualid=i;
    X11AmigaVisual[i].class=PseudoColor;
    X11AmigaVisual[i].red_mask=0x800;
    X11AmigaVisual[i].green_mask=0x080;
    X11AmigaVisual[i].blue_mask=0x008;
    X11AmigaVisual[i].bits_per_rgb=8;
  }
  X11AmigaVisual[0].map_entries=1<<DG.nDisplayDepth;
  X11AmigaVisual[1].map_entries=1<<DG.nDisplayMaxDepth;
}

XVisualInfo *XGetVisualInfo(display, vinfo_mask,
			    vinfo_template, nitems_return)
     Display *display;
     long vinfo_mask;
     XVisualInfo *vinfo_template;
     int *nitems_return;
{
  int vis_num=2,i,n=0;
#ifdef DEBUGXEMUL
  printf("XGetVisualInfo\n");
#endif
/*
  if(usewb) vis_num=1;
  *nitems_return=vis_num;
*/
  X11vis=(XVisualInfo*)malloc(sizeof(XVisualInfo)*vis_num);
  for(i=0;i<vis_num;i++){ 
/*    if(vinfo_mask&VisualScreenMask && vinfo_template->screen!=i) continue;*/
    if(vinfo_mask&VisualIDMask && vinfo_template->visualid!=i) continue;
    
    X11vis[n].visual=&X11AmigaVisual[i];
    X11vis[n].visualid=i;
    X11vis[n].screen=i;
    X11vis[n].class=PseudoColor/*StaticColor*/;
    X11vis[n].red_mask=0x800;
    X11vis[n].green_mask=0x080;
    X11vis[n].blue_mask=0x008;
    X11vis[n].bits_per_rgb=8;
    n++;
  }
  X11vis[0].depth=DG.nDisplayDepth;
  X11vis[0].colormap_size=1<<DG.nDisplayDepth;
  X11vis[1].depth=DG.nDisplayMaxDepth;
  X11vis[1].colormap_size=1<<DG.nDisplayMaxDepth;
/*
  if(!usewb){
    X11vis[0].colormap_size=1<<DG.nDisplayMaxDepth;
    X11vis[1].depth=DG.nDisplayMaxDepth;
  }*/
  *nitems_return=n;
  return(X11vis);
}

VisualID XVisualIDFromVisual(visual)
     Visual *visual;
{
  if(visual) return(visual->visualid);
  return(0);
}

Visual *XDefaultVisual(Display *d,int n){/*          File 'x11perf.o'*/
#ifdef DEBUGXEMUL
  printf("XDefaultVisual\n");
#endif
  if(n==0) return(&X11AmigaVisual[0]);
  return(&X11AmigaVisual[1]);
}
