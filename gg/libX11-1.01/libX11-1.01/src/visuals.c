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

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
***/

#include "amiga.h"

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

#include "libX11.h"

#include "x11display.h"

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
extern struct Library *AslBase;
extern struct Library *GadToolsBase;
extern struct Library *DiskfontBase;
extern struct Library *LayersBase;
extern struct DosLibrary *DOSBase;

XFreeVisualInfo(Display *display, XVisualInfo *vis){
  free(vis);
}

XVisualInfo *X11vis = NULL;

void
X11Visuals_init( void )
{
}

void
X11Visuals_exit( void )
{
  if( X11vis )
    free( X11vis );
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
void 
X11SetupVisual( void )
{
  int i;

  /* fill the visual info with something meaningfull */
  for( i=0; i<2; i++ ){
    DG.X11Visual[i].visualid = i;
    DG.X11Visual[i].class = PseudoColor;
    DG.X11Visual[i].red_mask = 0x800;
    DG.X11Visual[i].green_mask = 0x080;
    DG.X11Visual[i].blue_mask = 0x008;
    DG.X11Visual[i].bits_per_rgb = 8;
  }
  DG.X11Visual[0].map_entries = 1<<DG.nDisplayDepth;
  DG.X11Visual[1].map_entries = 1<<DG.nDisplayMaxDepth;
}

/********************************************************************************
Function : XGetVisualInfo()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     vinfo_mask
               Specifies the visual mask value.  Indicates  which  elements
               in template are to be matched.

     vinfo_template
               Specifies the visual attributes  that  are  to  be  used  in
               matching the visual structures.

     nitems_return
               Returns the number of matching visual structures.

Output   : 
Function : find the visual information structures that match the specified template.
********************************************************************************/

XVisualInfo *
XGetVisualInfo( Display* display,
	        long vinfo_mask,
	        XVisualInfo* vinfo_template,
	        int *nitems_return )
{
  int vis_num = 2,i,n = 0;

#ifdef DEBUGXEMUL
  printf("XGetVisualInfo\n");
#endif
/*
  if( usewb )
    vis_num=1;
  *nitems_return=vis_num;
*/
  X11vis = (XVisualInfo*)malloc(sizeof(XVisualInfo)*vis_num);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)X11vis);
#endif /* MEMORYTRACKING */
  for( i=0; i<vis_num; i++ ){ 
/*    if(vinfo_mask&VisualScreenMask && vinfo_template->screen!=i) continue;*/
    if( vinfo_mask&VisualIDMask 
        && vinfo_template->visualid!=i )
      continue;
    
    X11vis[n].visual = &DG.X11Visual[i];
    X11vis[n].visualid = i;
    X11vis[n].screen = 0 /* i */;
    X11vis[n].class = PseudoColor/*StaticColor*/;
    X11vis[n].red_mask = 0x800;
    X11vis[n].green_mask = 0x080;
    X11vis[n].blue_mask = 0x008;
    X11vis[n].bits_per_rgb = 8;
    X11vis[n].depth = ceil(log(DG.X11Visual[i].map_entries)/log(2));
    X11vis[n].colormap_size = 1<<X11vis[n].depth;

    n++;
  }
/*
  X11vis[1].depth = DG.nDisplayMaxDepth;
  X11vis[1].colormap_size = 1<<DG.nDisplayMaxDepth;

  X11vis[1].colormap_size = 1<<DG.nDisplayMaxDepth;
  X11vis[1].depth = DG.nDisplayMaxDepth;
*/

  *nitems_return = n;

  return(X11vis);
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

VisualID
XVisualIDFromVisual( Visual* visual )
{
  if( visual )
    return(visual->visualid);

  return(0);
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
Visual *
XDefaultVisual( Display *d, int n )
{
#ifdef DEBUGXEMUL
  printf("XDefaultVisual\n");
#endif
  if( !n )
    return(&DG.X11Visual[0]);

  return(&DG.X11Visual[1]);
}

/********************************************************************************
Function : XMatchVisualInfo
Author   : Terje Pedersen
Input    : 
     display  Specifies  a  connection  to  an  X  server;  returned   from
             XOpenDisplay().

     screen  Specifies the screen.

     depth   Specifies the desired depth of the visual.

     class   Specifies the desired class of the visual, such as PseudoColor
             or TrueColor.

     vinfo_return
             Returns the matched visual information.

Output   : 
Function : obtain the visual information that matches the desired depth and class.
********************************************************************************/

Status
XMatchVisualInfo( Display* display,
		  int screen,
		  int depth,
		  int class,
		  XVisualInfo* vinfo_return )
{
  XVisualInfo vInfo = {0};
  XVisualInfo *vRetInfo;
  int nItems;
  int i;

  assert(vinfo_return);

  switch( class ){
  case PseudoColor:
    if( DG.nDisplayMaxDepth<depth )
      return 0;

    vRetInfo = XGetVisualInfo(display,0 /*VisualIDMask*/,&vInfo,&nItems);
    for( i=0; i<nItems; i++ ){
      if( vRetInfo[i].depth == depth ){
	memcpy(vinfo_return,&vRetInfo[i],sizeof(XVisualInfo));
	vinfo_return->depth = depth;

	return 1;
      }
    }
  case TrueColor:

    return 0;
  }
  return 0;
}

