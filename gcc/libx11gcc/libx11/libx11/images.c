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
     images
   PURPOSE
     add Image handling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 27, 1994: Created.

16. Nov 95: xi->bitmap_bit_order=MSBFirst was left out from ZPixmap's in XGetImage
***/

#include <amiga.h>

#include <dos.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#undef memset
#include "x11display.h"

#ifdef XMUI
#include "x11mui.h"
#endif

#ifndef NO020
struct c2pStruct {
  struct BitMap *bmap;
  UWORD startX, startY, width, height;
  UBYTE *chunkybuffer;
} c2p;

extern void ChunkyToPlanarAsm(register struct c2pStruct *);
#endif

#ifndef NO020
struct p2cStruct{
  struct BitMap *bmap;
  UWORD startX, startY, width, height;
  UBYTE *chunkybuffer;
} p2c;

extern void PlanarToChunkyAsm(register struct p2cStruct *);

#endif

/*******************************************************************************************/
/* externals */
/*******************************************************************************************/

extern struct RastPort backrp;
extern int gfxcard;

extern int X11FunctionMapping[];

unsigned char X11InvertMap[256];

long ANop( XImage *xim, int x,int y );
__stdargs int ADestroyImage(struct _XImage *xim);
__stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel);
__stdargs unsigned long  XGet_Pixel(struct _XImage*,int,int);

shift3[] = {13,10,7,12,9,6,11,8};
shift6[] = {10,4,6,0};

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline UBYTE
X11invert( UBYTE n )
{
  return((UBYTE)(((n&128)>>7)+((n&64)>>5)+((n&32)>>3)+((n&16)>>1)+((n&8)<<1)+((n&4)<<3)+((n&2)<<5)+((n&1)<<7)));
}

void
X11init_images(void)
{
  int i;

  for( i=0; i<256; i++ ){
    X11InvertMap[i] = X11invert(i);
  }
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11exit_images(void)
{
}

/*******************************************************************************************/

int show = 0;

#ifdef DEBUGXEMUL_ENTRY
extern int bInformImages; /* outputting information about images */
extern int bSkipImageWrite;
#endif

/********************************************************************************
Name     : XPutPixel()
Author   : Terje Pedersen
Input    : 
     ximage    Specifies a pointer to the image to be modified.

     x
     y
               Specify the x and y coordinates of  the  pixel  to  be  set,
               relative to the origin of the image.

     pixel     Specifies the new pixel value.

Output   : 
Function : set a pixel value in an image.
********************************************************************************/

int XPutPixel(ximage, x, y, pixel)
     XImage *ximage;
     int x;
     int y;
     unsigned long pixel;
{
  extern __stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel);

  return XPut_Pixel(ximage,x,y,pixel);
}

/********************************************************************************
Name     : XGetPixel()
Author   : Terje Pedersen
Input    : 
     ximage    Specifies a pointer to the image.

     x
     y
               Specify the x and y coordinates of the pixel whose value  is
               to be returned.

Output   : 
Function : obtain a single pixel value from an image.
********************************************************************************/

unsigned long
XGetPixel( struct _XImage *xim, int x, int y )
{
  extern __stdargs unsigned long  XGet_Pixel(struct _XImage*,int,int);
  
  return XGet_Pixel(xim,x,y);
#if 0
  int bit;

  if( xim->bitmap_bit_order==LSBFirst ){
    if( xim->depth==1 ){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));

      bit=byte&(1<<(x%8));
    } else {
      int byte=*(xim->data+y*xim->bytes_per_line+x);

      bit=byte;
    }
  } else {
    if( xim->depth==1 ){
      int byte = *(xim->data+y*xim->bytes_per_line+(x>>3));

      bit = byte&(128>>(x%8));
    } else {
      int byte = *(xim->data+y*xim->bytes_per_line+x);

      bit = byte;
    }
  }

  return((unsigned long)bit);
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
XDestroyImage( XImage* ximage )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XDESTROYIMAGE , bInformImages );
#endif
  if( ximage->data )
    free(ximage->data);
#if (MEMORYTRACKING!=0)
  List_RemoveEntry(pMemoryList,(void*)ximage);
#else
  free(ximage);
#endif /* MEMORYTRACKING */
}

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>

#include "x11display.h"
#include "images.h"
#include "debug.h"

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int backrp_Width = 0;
int backrp_Height = 0;
int backrp_Depth = 0;

void
X11testback( int width, int height, int depth )
{
  if( !backrp.BitMap ){
    InitRastPort(&backrp);
/*    printf("has to set backrp! %d %d %d\n",width,height,wbdepth);*/
    backrp.BitMap = alloc_bitmap(width,height,depth,BMF_CLEAR,DG.wb->RastPort.BitMap);
    if( DG.XAllocFailed ) return;
    backrp_Width = width;
    backrp_Height = height;
    backrp_Depth = depth;
    backrp.Layer = NULL;
    DG.bNeedBackRP = 1;
  } else {
    if( backrp_Width<width || backrp_Height<height || backrp_Depth<depth ){
      free_bitmap(backrp.BitMap);
      backrp.BitMap = alloc_bitmap(width,height,depth,BMF_CLEAR,DG.wb->RastPort.BitMap);

      backrp_Width = width;
      backrp_Height = height;
      backrp_Depth = depth;

      if( DG.XAllocFailed ) return;
    }
  }
}

/********************************************************************************
Name     : XCopyArea()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     src
     dest
               Specify  the  source  and  destination  rectangles   to   be
               combined. src and dest must have the same root and depth.

     gc        Specifies the graphics context.

     src_x
     src_y
               Specify the x and y coordinates of the upper-left corner  of
               the  source  rectangle  relative to the origin of the source
               drawable.

     width
     height
               Specify the dimensions in pixels  of  both  the  source  and
               destination rectangles.

     dest_x
     dest_y
               Specify the x  and  y  coordinates  within  the  destination
               window.

Output   : 
Function : copy an area of a drawable.
********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
static int bSkipCopyArea = 0;
#endif

XCopyArea( Display* display,
	   Drawable src,
	   Drawable dest,
	   GC gc,
	   int src_x,
	   int src_y,
	   unsigned int width,
	   unsigned int height, 
	   int dest_x,
	   int dest_y )
{
  struct BitMap *from = NULL; /*=(struct BitMap*)src;*/
  struct BitMap *to = NULL; /*=(struct BitMap*)dest;*/
  struct Window *fromwindow = NULL;
  struct Window *towindow = NULL;
  int blitop = 0xc0 /*(ABC|ABNC|ANBC)*/;
  int srcdrawable = X11Drawables[src],destdrawable=X11Drawables[dest];
  int vWidth = (int)width;
  int vHeight = (int)height;

  assert(X11DrawablesBackground);

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipImageWrite )
    return;
  if( bSkipCopyArea ){
    return;
  }
  FunCount_Enter( XCOPYAREA , bInformImages );
#endif

  if( dest!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(dest)) )
      return;

  assert(gc);
#if 0
  if( !gc ) gc = DG.X11GC;
#endif

  if( dest_x+vWidth<0 || dest_y+height<0 )
    return 0;

  if( dest_x<0 ){
    vWidth += dest_x;
    src_x -= dest_x;
    dest_x = 0;
  }

  if( dest_y<0 ){
    vHeight += dest_y;
    src_y -= dest_y;
    dest_y = 0;
  }

  switch( srcdrawable ){
  case X11WINDOW:
    {
      int root = X11Windows[X11DrawablesMap[src]].root;
      struct Window *w = X11DrawablesWindows[X11DrawablesMap[root]];
      
      if( !w )
	return 0; /*srcdrawable=X11BITMAP;*/
      
      from = w->RPort->BitMap;
      fromwindow = w;
      
      srcdrawable = X11WINDOW;
      src_x = src_x+X11Windows[src].x;
      src_y = src_y+X11Windows[src].y; 
    }
    break;
  case X11BITMAP:
    from = X11DrawablesBitmaps[X11DrawablesMap[src]].pBitMap;
    break;
#ifdef XMUI
  case X11MUI:
    {
      int t,l,w,h;
      
      MUIGetWin( src, &fromwindow, &l, &t,&w, &h );
      from = fromwindow->RPort->BitMap;
      src_x += t;
      src_y += l;
    }
    break;
#endif
  default:
    printf("Illegal source in XCopyArea\n");
    return;
  }


  switch( destdrawable ){
  case X11WINDOW:
    {
      to = DG.vWindow->RPort->BitMap;
      towindow = DG.vWindow;
      
      destdrawable = X11WINDOW;
      dest_x = dest_x+DG.vWinX;
      dest_y = dest_y+DG.vWinY;
      if( dest_x>=DG.vWinX+DG.vWinWidth || dest_y>=DG.vWinY+DG.vWinHeight )
	return 0;
    }
    break;
  case X11BITMAP:
    to = X11DrawablesBitmaps[X11DrawablesMap[dest]].pBitMap;
    if( dest_x>=DG.vWinX+DG.vWinWidth || dest_y>=DG.vWinY+DG.vWinHeight )
      return 0;

    break;
#ifdef XMUI
  case X11MUI: 
    {
      int t,l,w,h;
      
      destdrawable = X11WINDOW;
      DG.vPrevWindow = -1;
      
      MUIGetWin( dest, &towindow, &l, &t, &w, &h );
      to = towindow->RPort->BitMap;
      
      DG.vWinWidth = w-1;
      DG.vWinHeight = h-1;
      if( dest_x>=DG.vWinX+DG.vWinWidth || dest_y>=DG.vWinY+DG.vWinHeight )
	return 0;
      
      dest_x += t;
      dest_y += l;
      
      DG.vWinX = l;
      DG.vWinY = t;
    }
    break;
#endif /* XMUI */
  default:
    printf("Illegal destination in XCopyArea\n");
    return;
  }

  if( dest_x+vWidth>DG.vWinWidth+DG.vWinX ){
    int rest = dest_x+vWidth-(DG.vWinWidth+DG.vWinX);

    vWidth -= rest;
  }
  if( dest_y+vHeight>DG.vWinHeight+DG.vWinY ){
    int rest = dest_y+vHeight-(DG.vWinHeight+DG.vWinY);
    
    vHeight -= rest;
  }
  if( dest_y<DG.vWinY ) {
    vHeight = vHeight-(dest_y-DG.vWinY); dest_y=DG.vWinY; src_y+=DG.vWinY;
  }
  if( dest_x<DG.vWinX ) {
    vWidth = vWidth-(dest_x-DG.vWinX); dest_x=DG.vWinX; src_x+=DG.vWinX; 
  }

  if( vWidth<=0 || vHeight<=0 )
    return 0;

  assert( from );
  assert( to );

  if( from->Depth!=to->Depth
     && gc->values.background!=X11DrawablesBackground[dest] ){
    SetRast(&backrp,gc->values.background);
  }

  if( destdrawable==X11WINDOW ){
    assert( towindow );
    if( from->Depth!=to->Depth
        && gc->values.background!=X11DrawablesBackground[dest] ){
      X11testback(vWidth,vHeight,to->Depth);
      SetABPenDrMd( &backrp, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function]);
    } else {
      SetABPenDrMd( towindow->RPort, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function]);
      vPrevGC = (GC)-1;
    }
  } else if( destdrawable==X11BITMAP ){
    DG.X11BitmapRP.BitMap = (struct BitMap *)to;
    SetABPenDrMd( &DG.X11BitmapRP, gc->values.foreground, gc->values.background, X11FunctionMapping[gc->values.function]);
  }

  if( srcdrawable!=X11WINDOW && destdrawable!=X11WINDOW ){
    if( !CG.bNeedClip ){
      WaitBlit();
      if( from->Depth==1 && from->Depth!=to->Depth
	  && gc->values.background!=X11DrawablesBackground[dest] ){
	X11testback(vWidth,vHeight,to->Depth);
	if( gc->values.function!=GXxor ){
	  BltPattern(&backrp,from->Planes[0],0,0,vWidth-1,vHeight-1,from->BytesPerRow);
	} else {
	  BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,vWidth,vHeight);
	}
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,&DG.X11BitmapRP,dest_x,dest_y,vWidth,vHeight,0xc0);
      } else {
	BltBitMap(from,src_x,src_y,to,dest_x,dest_y,vWidth,vHeight,/*blitop*/ 0xc0,0xFF,NULL);
      }
    } else {
      WaitBlit();
      if( from->Depth==1 && from->Depth!=to->Depth
	  && gc->values.background!=X11DrawablesBackground[dest] ){
	X11testback(vWidth,vHeight,to->Depth);
	if( gc->values.function!=GXxor ){
	  BltPattern(&backrp,CG.pClipBM->Planes[0],0,0,vWidth-1,vHeight-1,
		     CG.pClipBM->BytesPerRow);
	} else {
	  BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,vWidth,vHeight);
	}
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,&DG.X11BitmapRP,dest_x,dest_y,vWidth,vHeight,A_TO_D);
      } else {
	WaitBlit();
	BltPattern(&DG.X11BitmapRP,CG.pClipBM->Planes[0],dest_x,dest_y,dest_x+vWidth-1,dest_y+vHeight-1,
		   CG.pClipBM->BytesPerRow);
	WaitBlit();
	blitop = A_TO_D;
	BltMaskBitMapRastPort(from,src_x,src_y,&DG.X11BitmapRP,dest_x,dest_y,vWidth,vHeight,blitop,
			      CG.pClipBM->Planes[0]);
      }
    }
  } else if( srcdrawable!=X11WINDOW && destdrawable==X11WINDOW ) {
    assert( towindow );
    if( !CG.bNeedClip ){
      if( from->Depth==1 && from->Depth!=to->Depth
	  && gc->values.background!=X11DrawablesBackground[dest] ){
	X11testback(vWidth,vHeight,to->Depth);
	WaitBlit();
	if( gc->values.function!=GXxor ){
	  BltPattern(&backrp,from->Planes[0],0,0,vWidth-1,vHeight-1,
		     from->BytesPerRow);
	} else {
	  BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,vWidth,vHeight);
	}
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,towindow->RPort,dest_x,dest_y,vWidth,vHeight,0xc0);
      } else {
	WaitBlit();
	BltBitMapRastPort(from,src_x,src_y,towindow->RPort,dest_x,dest_y,vWidth,vHeight,0xc0);
      }
    } else {
      if( from->Depth==1 && from->Depth!=to->Depth ){
	if( src_x==0 && src_y==0 ){
	  if( gc->values.function!=GXxor ){
	    WaitBlit();
	    BltPattern(towindow->RPort,CG.pClipBM->Planes[0],dest_x,dest_y,dest_x+vWidth-1,dest_y+vHeight-1,
		       CG.pClipBM->BytesPerRow);
	  } else {
	    WaitBlit();
	    BltTemplate(from->Planes[0],0,from->BytesPerRow,towindow->RPort,dest_x,dest_y,vWidth,vHeight);
	  }
	} else {
	  X11testback(vWidth,vHeight,from->Depth);
	  WaitBlit();
	  BltBitMapRastPort(from,src_x,src_y,&backrp,0,0,vWidth,vHeight,0xC0);
	  if( gc->values.function!=GXxor ){
	    WaitBlit();
	    BltPattern(towindow->RPort,backrp.BitMap->Planes[0],dest_x,dest_y,dest_x+vWidth-1,dest_y+vHeight-1,
		       backrp.BitMap->BytesPerRow);
	  } else {
	    WaitBlit();
	    BltTemplate(backrp.BitMap->Planes[0],0,backrp.BitMap->BytesPerRow,towindow->RPort,dest_x,dest_y,vWidth,vHeight);
	  }
	}
      } else {
	WaitBlit();
	BltBitMapRastPort(from,src_x,src_y,towindow->RPort,dest_x,dest_y,width,height,0xc0);
      }
/*
	WaitBlit();
	BltPattern(&towindow->RPort,CG.pClipBM->Planes[0],dest_x,dest_y,dest_x+vWidth-1,dest_y+vHeight-1,
		   CG.pClipBM->BytesPerRow);
	WaitBlit();
	blitop=A_TO_D;
	BltMaskBitMapRastPort(from,src_x,src_y,towindow->RPort,dest_x,dest_y,vWidth,vHeight,dest_xitop,
			      CG.pClipBM->Planes[0]);
      }
*/
    }
  } else if( srcdrawable==X11WINDOW && destdrawable!=X11WINDOW ){
    WaitBlit();
    BltBitMap(from,src_x,src_y,to,dest_x,dest_y,vWidth,vHeight,0xC0,0xFF,NULL);
  } else if( X11Drawables[src]==X11WINDOW && X11Drawables[dest]==X11WINDOW ){
    WaitBlit();
    assert( fromwindow );
    assert( towindow );

    BltBitMapRastPort(from,src_x+fromwindow->LeftEdge,src_y+fromwindow->TopEdge,towindow->RPort,dest_x,dest_y,vWidth,vHeight,0xc0);
  }

  return(0);
}

Pixmap X11prevtile = NULL;
int X11CurrentTile = 0;
int X11PrevTile = 0;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
void
X11Setup_Tile( GC gc, int tile )
{
  int i,j;
  int FillOp = gc->values.fill_style &0xff00;

  if( X11PrevTile==tile )
    return;
  X11PrevTile = tile;
  if( tile && FillOp==NORMAL_FILL ){
    int width,height;
    struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[tile]].pBitMap;

    if( DG.Xcurrent_tile ){
#if (MEMORYTRACKING!=0)
      List_RemoveEntry(pMemoryList,(void*)DG.Xcurrent_tile);
#else
      free(DG.Xcurrent_tile);
#endif /* MEMORYTRACKING */
      DG.Xcurrent_tile = NULL;
    }
    width=X11DrawablesBitmaps[X11DrawablesMap[tile]].width;
    height=X11DrawablesBitmaps[X11DrawablesMap[tile]].height;
    if( width>16 ){
      width=16;
      if( height>16 )
	height=16;
    } else
      if( width<8 )
	width=8;

    DG.Xcurrent_tile = (WORD *) malloc((width>>3)*height);
    if( !DG.Xcurrent_tile )
      X11resource_exit(IMAGES10);
#if (MEMORYTRACKING!=0)
    List_AddEntry(pMemoryList,(void*)DG.Xcurrent_tile);
#else
    free(DG.Xcurrent_tile);
#endif /* MEMORYTRACKING */
    /*AllocMem(bm->BytesPerRow*bm->Rows,MEMF_CHIP);*/
    for( j=0; j<height; j++ )
      for( i=0; i<(width>>3); i++ )
	*((byte*)DG.Xcurrent_tile+i+j*(width>>3))=(byte)*(bm->Planes[0]+i+j*bm->BytesPerRow);
    {
      double d = log(height)/log(2);
      DG.Xtile_size = (int)ceil(d);
    }
    X11prevtile = tile;
  }
}

#if 1
/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
XPixmapDepth( Display *display, Pixmap pixmap )
{
  struct BitMap *bm;

  if( X11Drawables[pixmap]!=X11BITMAP )
    return 0;
  bm=X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;

  return(bm->Depth);
}

#endif

/********************************************************************************
Name     : XGetSubImage()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XImage *
XGetSubImage( Display* display,
	      Drawable drawable,
	      int x,
	      int y,
	      unsigned int width,
	      unsigned int height,
	      unsigned long plane_mask,
	      int format,
	      XImage* dest_image,
	      int dest_x,
	      int dest_y )
{
  int bdpl,i;
  struct Window *destwin;
  struct BitMap *destBM = NULL;

#if DEBUGXEMUL_ENTRY
  FunCount_Enter( XGETSUBIMAGE, bInformImages );
#endif
  switch( X11Drawables[drawable] ){
  case X11WINDOW: 
    {
      int root = X11Windows[X11DrawablesMap[drawable]].root;
      destwin = X11DrawablesWindows[X11DrawablesMap[root]];
      if( !destwin )
	return 0;
      destBM = destwin->RPort->BitMap;
    }
    break;
  case X11BITMAP:
    {
      destBM = X11DrawablesBitmaps[X11DrawablesMap[drawable]].pBitMap;
    } 
    break;
  default: 
    printf("unsupported source in xgetsubimage\n");
    return;
  }
    {
      bdpl = (width+7)>>3;
      for( i=0; i<bdpl*height; i++ ){
	*(dest_image->data+i)=*(destBM->Planes[0]+(i%bdpl)+(int)(i/bdpl)*destBM->BytesPerRow);
      }
      return(dest_image);
    }

  return(0);
}

/********************************************************************************
Name     : XCopyPlane()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     src
     dest
               Specify the source and destination drawables.

     gc        Specifies the graphics context.

     src_x
     src_y
               Specify the x and y coordinates of the upper-left corner  of
               the source rectangle relative to the origin of the drawable.

     width
     height
               Specify the width and  height  in  pixels.   These  are  the
               dimensions of both the source and destination rectangles.

     dest_x
     dest_y
               Specify the x and y coordinates at  which  the  copied  area
               will  be  placed  relative  to the origin of the destination
               drawable.

     plane     Specifies the source bit-plane.  You must  set  exactly  one
               bit, and the bit must specify a plane that exists in src.

Output   : 
Function : copy a single plane of a drawable into a drawable with
           depth, applying pixel values.
********************************************************************************/

XCopyPlane( Display* display,
	    Drawable src,
	    Drawable dest,
	    GC gc,
	    int src_x,
	    int src_y,
	    unsigned int width,
	    unsigned int height,
	    int dest_x,
	    int dest_y,
	    unsigned long plane )
{
  struct BitMap *from = NULL;
  PLANEPTR oldplanes[8];
  int olddepth = 0;

#ifdef DEBUGXEMUL_ENTRY
  if( bSkipImageWrite )
    return;
  FunCount_Enter( XCOPYPLANE , bInformImages );

#endif
  switch( X11Drawables[src] ){
  case X11WINDOW:
    {
      int root = X11Windows[X11DrawablesMap[src]].root;
      struct Window *w = X11DrawablesWindows[X11DrawablesMap[root]];
      if( !w )
	return 0;
      from = w->RPort->BitMap;
      
      src_x =+ DG.vWinX;
      src_y =+ DG.vWinY; 
    } 
    break;
  case X11BITMAP:
    {
      from = X11DrawablesBitmaps[X11DrawablesMap[src]].pBitMap;
    } 
    break;
  default:
    return;
  }

  assert( from->Depth>0 );
  if( plane ){
    int i;
    for( i=0; i<8; i++ ){
      oldplanes[i]=from->Planes[i];
      from->Planes[i]=0;
    }
    from->Planes[0] = oldplanes[plane-1];
    olddepth = from->Depth;
    from->Depth = 1;
  }
  XCopyArea(display,src,dest,gc,src_x,src_y,width,height,dest_x,dest_y);
  if( plane ){
    int i;

    assert( from );
    for( i=0; i<8; i++ )
      from->Planes[i]=oldplanes[i];
    assert( olddepth );
    from->Depth = olddepth;
  }

  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XImage *
XGetImage_nochunky( Display* display,
		    Drawable drawable,
		    int x,
		    int y,
		    unsigned int width,
		    unsigned int height,
		    unsigned long plane_mask,
		    int format )
{
  XImage *xi;
  struct RastPort temprp;

#if DEBUGXEMUL_ENTRY
  FunCount_Enter( XGETIMAGE, bInformImages );
#endif
  ANop(NULL,0,0);
  return(0);
/*
  if( format==XYPixmap ){ 
    struct BitMap *bm = alloc_bitmap(width,height,1,BMF_CLEAR,DG.wb->RastPort.BitMap);
  
    if( DG.XAllocFailed ) return NULL;
    xi = XCreateImage(display,NULL,1,XYPixmap,0,0,width,height,0,bm->BytesPerRow);
    xi->data = malloc(width*height);
    if(!xi->data)  X11resource_exit(IMAGES4);
#if 0
    if(drawable==rootwin) p2c.bmap = rootwin->RPort.BitMap;
    else 
#endif
      p2c.bmap=(struct BitMap*)drawable;
    BltBitMap(p2c.bmap,x,y,bm,0,0,width,height,0xC0,(UBYTE)plane_mask,NULL);
    WaitBlit();
    p2c.bmap=bm;
    p2c.startX = x; p2c.startY = y;
    p2c.width = width; p2c.height = height;
    p2c.chunkybuffer = xi->data;
    PlanarToChunkyAsm(&p2c);
    free_bitmap(bm);
  } else {
    struct BitMap *bm=(struct BitMap *)drawable;
    int depth=bm->Depth,i;
    UBYTE *Line=malloc(((width+16)>>4)<<4);

    if( !Line )
      X11resource_exit(IMAGES5);
    X11testback(width,height,depth);
    WaitTOF();
    BltBitMapRastPort(bm,x,y,&backrp,0,0,width,height,0xC0);
    WaitBlit();
    temprp.BitMap = alloc_bitmap(width+16,1,8,BMF_CLEAR,DG.wb->RastPort.BitMap);
    if( DG.XAllocFailed ) return NULL;

    xi=XCreateImage(display,NULL,depth,ZPixmap,0,0,width,height,8,0);
    xi->data=malloc(width*height+16);
    if( !xi->data )
      X11resource_exit(IMAGES6);
    for( i=0; i<height; i++ ){
      ReadPixelLine8(&backrp,(unsigned long)0,(unsigned long)i,(unsigned long)width,(UBYTE*)Line,&temprp);
      memcpy((UBYTE*)(xi->data+i*width),Line,width);
    }
    free(Line);
  }

  free_bitmap(temprp.BitMap);

  return(xi);
*/
}

/********************************************************************************
Name     : XGetImage() 
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable to get the data from.

     x
     y
               Specify the x and y coordinates of the upper-left corner  of
               the rectangle, relative to the origin of the drawable.

     width
     height
               Specify the width and height in pixels of the image.

     plane_mask
               Specifies a plane  mask  that  indicates  which  planes  are
               represented in the image.

     format    Specifies the format for the image.  Pass either XYPixmap or
               ZPixmap.

Output   : 
Function : place contents of a rectangle from drawable into an image.
********************************************************************************/

XImage *
XGetImage( Display* display,
           Drawable drawable,
           int src_x,
           int src_y,
           unsigned int width,
           unsigned int height,
           unsigned long plane_mask,
           int format )
{
  XImage *xi;
  struct Window *destwin;
  struct BitMap *destBM = NULL;
  int x,y;

#ifndef NO020
  if( drawable!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(drawable)) )
      return NULL;

  src_x += DG.vWinX;
  src_y += DG.vWinY;
  switch( X11Drawables[drawable] ){
  case X11WINDOW: 
    {
      int root = X11Windows[X11DrawablesMap[drawable]].root;
      destwin = X11DrawablesWindows[X11DrawablesMap[root]];
      if( !destwin )
	return 0;
      destBM = destwin->RPort->BitMap;
      src_x += destwin->LeftEdge;
      src_y += destwin->TopEdge;
    } 
    break;
  case X11BITMAP:
    {
      destBM = X11DrawablesBitmaps[X11DrawablesMap[drawable]].pBitMap;
#if (DEBUG!=0)
      if(show) showbitmap(destBM,width,height,0,0);
#endif
    } 
    break;
#ifdef XMUI
  case X11MUI:
    {
      int l,t,w,h;
      
      MUIGetWin( drawable, &destwin, &l,&t,&w,&h);
      destBM = destwin->RPort->BitMap;
    }
    break;
#endif
  default:
    printf("Illegal source in xgetimage\n");
    return NULL;
  }

  if( format==XYPixmap ){ /* one plane pixmap */
    struct BitMap *bm=alloc_bitmap(width,height,1,BMF_CLEAR,DG.wb->RastPort.BitMap);

    if( DG.XAllocFailed ) return NULL;

    xi = XCreateImage(display,NULL,1,XYPixmap,0,0,width,height,0,bm->BytesPerRow);
    xi->data = malloc(bm->BytesPerRow*bm->Rows);
    if( !xi->data )
      X11resource_exit(IMAGES7);
    xi->bitmap_bit_order = MSBFirst;
    assert( destBM );
    BltBitMap(destBM,src_x,src_y,bm,0,0,width,height,0xC0,(UBYTE)plane_mask,NULL);
#if (DEBUG!=0)
    if(show) showbitmap(bm,width,height,0,1);
#endif
    WaitBlit();
    xi->bytes_per_line = bm->BytesPerRow;
    memcpy(xi->data,bm->Planes[0],bm->BytesPerRow*bm->Rows);
    free_bitmap(bm);
  } else {
    int depth,i;
    char *data2;

    assert( destBM );

    depth = destBM->Depth;
#if 0
    X11testback(width,height,depth);
    if( backrp.BitMap )
      free_bitmap(backrp.BitMap);
    backrp.BitMap=destBM;
/*
    BltBitMapRastPort(destBM,src_x,src_y,&backrp,0,0,width,height,0xC0);
    WaitBlit();
*/
    p2c.bmap=backrp.BitMap;
#else
    p2c.bmap=destBM;
#endif
    depth=p2c.bmap->Depth;
    xi=XCreateImage(display,NULL,depth,ZPixmap,0,0,width,height,0,destBM->BytesPerRow);
    data2=malloc(width*height+16);
    xi->data=calloc(height*xi->bytes_per_line+16,1);
    xi->bitmap_bit_order=MSBFirst;
    if( !data2 || !xi->data )
      X11resource_exit(IMAGES8);
#if (DEBUG!=0)
    if(show) showbitmap(destBM,width,height,0,2);
#endif
    p2c.startX = src_x; p2c.startY = src_y;
    p2c.width = width; p2c.height = height;
    p2c.chunkybuffer = data2;
    PlanarToChunkyAsm(&p2c);
    WaitBlit();
    for( y=0; y<height; y++ )
      for( x=0; x<width; x++ )
	XPut_Pixel(xi,x,y,/*ReadPixel(&backrp,src_x+x,src_y+y)*/ data2[y*width+x]);
#if (DEBUG!=0)
    if( show )
      XPutImage(NULL,1,NULL,xi,0,0,0,0,width,height);
#endif
#if 0
    backrp.BitMap=NULL;
#endif
    free(data2);
  }
  return(xi);
#else
  return 0;
#endif
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__stdargs unsigned long
XGet_Pixel( struct _XImage *xim,
	    int x,
	    int y )
{
  int bit = 0;
  unsigned char *byte = NULL;

  if( xim->bitmap_bit_order==LSBFirst ){
    switch( xim->depth ){
    case 1:
      byte = (xim->data+y*xim->bytes_per_line+(x>>3));
      bit = (*byte)&((128>>(x%8)));

      return (unsigned long)( bit!=0 );
      break;
    case 2:
      byte = xim->data+y*xim->bytes_per_line+(x>>2);
      bit = ((*byte) &(3<<(x%4)*2))>>((x%4)*2);
      break;

    case 3: {
      short *byte;
      int  pos = (int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos);
      bit = (*byte&(7<<shift3[x % 8]))>>shift3[x % 8];
      } break;
    case 4:
      byte = xim->data+y*xim->bytes_per_line+(x>>1);
      bit = (*byte&(15<<((x%2)*4)))>>((x%2)*4);
      break;
    case 6: {
      int *byte;
      int  pos = (int)((x%4)/xim->bits_per_pixel)+(int)(x/4)*3;

      byte = (int*)(xim->data+y*xim->bytes_per_line+pos);
      bit = (*byte&(63<<shift6[x % 4]))>>shift6[x % 4];
      } break;
    case 8:
      byte = (xim->data+y*xim->bytes_per_line+x);
      bit = *byte;
      break;
    default:
      printf("Unsupported display depth..\n");
      exit(-1);
      break;
    }

/*
    if(xim->depth==1){
      int byte = *(xim->data+y*xim->bytes_per_line+(x>>3));
      bit = byte&(1<<(x%8));
    }
    else{
      int byte = *(xim->data+y*xim->bytes_per_line+x);
      bit = byte;
    }
*/
  } else {
    switch( xim->depth ){
    case 1:
      byte = (xim->data+y*xim->bytes_per_line+(x>>3));
      bit = (*byte)&((128>>(x%8)));
      
      return (unsigned long)( bit!=0 );
      break;
    case 2:
      byte = xim->data+y*xim->bytes_per_line+(x>>2);
      bit = ((*byte) &(3<<(x%4)*2))>>((x%4)*2);
      break;

    case 3: {
      short* byte;
      int pos = (int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos);
      bit = (*byte&(7<<shift3[x % 8]))>>shift3[x % 8];
    } break;
    case 4:
      byte = xim->data+y*xim->bytes_per_line+(x>>1);
      bit = (*byte&(15<<((x%2)*4)))>>((x%2)*4);
      break;
    case 6: {
      int* byte;
      int pos = (int)((x%4)/xim->bits_per_pixel)+(int)(x/4)*3;

      byte = (int*)(xim->data+y*xim->bytes_per_line+pos);
      bit = (*byte&(63<<shift6[x % 4]))>>shift6[x % 4];
    } break;
    case 8:
      byte = (xim->data+y*xim->bytes_per_line+x);
      bit = *byte;
      break;
    default:
      printf("Unsupported display depth..\n");
      exit(-1);
      break;
    }

/*
    if(xim->depth==1){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=byte&(128>>(x%8));
    }
    else{
      int byte=*(xim->data+y*xim->bytes_per_line+x);
      bit=byte;
    }
*/
  }

  return((unsigned long)bit);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__stdargs int
XPut_Pixel( XImage *xim,
	    int x,
	    int y,
	    unsigned long pixel )
{
  unsigned char *byte = NULL;

  if( xim->bitmap_bit_order==LSBFirst ){
    switch( xim->depth ){
    case 1:
      byte = (xim->data+y*xim->bytes_per_line+(x>>3));
      *byte = (*byte)|(pixel<<(x%8));
      break;
    case 2:
      byte = xim->data+y*xim->bytes_per_line+(x>>2);
      *byte = *byte|(pixel<<((x%4)*2));
      break;
    case 3:{
      short *byte;
      int  pos = (int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos);
      *byte = *byte|(pixel<<shift3[x % 8]);
      return( (int)*byte );
      } break;
    case 4:
      byte = xim->data+y*xim->bytes_per_line+(x>>1);
      *byte = *byte|(pixel<<((x%2)*4));
      break;
    case 6:{
      short *byte;
      int  pos = (int)((x%4)/xim->bits_per_pixel)+(int)(x/4)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos+(int)((x%4)/2));
      *byte = *byte|(pixel<<shift6[x % 4]);
      return( (int)*byte );
      } break;
    case 8:
      byte = (xim->data+y*xim->bytes_per_line+x);
      *byte = pixel;
      break;
    default:
      printf("Unsupported display depth..\n");
      exit(-1);
      break;
    }
  } else {
    switch( xim->depth ){
    case 1:
      byte = (xim->data+y*xim->bytes_per_line+(x>>3));
      *byte = (*byte)|((128>>(x%8))*pixel);
      break;
    case 2:
      byte = (xim->data+y*xim->bytes_per_line+(x>>2));
      *byte = (*byte)|(pixel<<(6-2*(x%4)));
      break;
    case 3: {
      short *byte;
      int  pos = (int)((x%8)/xim->bits_per_pixel)+(int)(x/8)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos);
      *byte = *byte|(pixel<<shift3[x % 8]);
      return( (int)*byte );
      } break;
    case 4:
      byte = xim->data+y*xim->bytes_per_line+(x>>1);
      *byte = *byte|(pixel<<((x%2)*4));
      break;
    case 6: {
      short *byte;
      int  pos = (int)((x%4)/xim->bits_per_pixel)+(int)(x/4)*3;

      byte = (short*)(xim->data+y*xim->bytes_per_line+pos+(int)((x%4)/2));
      *byte = *byte|(pixel<<shift6[x % 4]);
      return( (int)*byte );
      } break;
    case 8:
      byte = (xim->data+y*xim->bytes_per_line+x);
      *byte = pixel;
      break;
    default:
      printf("Unsupported display depth..\n");
      exit(-1);
      break;
    }
  }

  return((int)*byte);
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__stdargs
ADestroyImage( struct _XImage *xim )
{
  if( xim->data!=NULL )
    free(xim->data);
#if (MEMORYTRACKING!=0)
  List_RemoveEntry(pMemoryList,(void*)xim);
#else
  free(xim);
#endif /* MEMORYTRACKING */
  xim = NULL;

  return(1);
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

long
ANop( XImage *xim, int x, int y )
{
/*
  printf("internal undefined func called!\nPress return..\n");
  getchar();
*/

  return(0);
}

XImage *
ANop2()
{
/*
  printf("internal undefined func(2) called!\nnPress return..");
  getchar();
*/

  return((XImage*)NULL);
}

/********************************************************************************
Name     : XCreateImage()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     visual    Specifies a pointer to a visual that should match the visual
               of the window the image is to be displayed in.

     depth     Specifies the depth of the image.

     format    Specifies the format for  the  image.   Pass  one  of  these
               constants: XYBitmap, XYPixmap, or ZPixmap.

     offset    Specifies the number of pixels beyond the beginning  of  the
               data  (pointed  to by data) where the image actually begins.
               This is useful if the  image  is  not  aligned  on  an  even
               addressable boundary.

     data      Specifies a pointer to the image data.

     width
     height
               Specify the width and height in pixels of the image.

     bitmap_pad
               Specifies the quantum of a scan line.  In other  words,  the
               start  of  one  scan line is separated in client memory from
               the start of the next scan line by an  integer  multiple  of
               this  many  bits. You must pass one of these values:  8, 16,
               or 32.

     bytes_per_line
               Specifies the number of bytes in the  client  image  between
               the start of one scan line and the start of the next. If you
               pass a value of 0 here, Xlib assumes that the scan lines are
               contiguous  in  memory  and  thus  calculates  the  value of
               bytes_per_line itself.

Output   : 
Function : allocate memory for an XImage structure.
********************************************************************************/

XImage *
XCreateImage( Display* display,
	      Visual *visual,
	      unsigned int depth,
	      int format,
	      int offset,
	      char* data,
	      unsigned int width,
	      unsigned int height,
	      int bitmap_pad,
	      int bytes_per_line )
{
  XImage *xim;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEIMAGE , bInformImages );

#endif
  xim=(XImage*)malloc(sizeof(XImage));
  if( !xim )
    X11resource_exit(IMAGES1);
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xim);
#endif /* MEMORYTRACKING */
  xim->width = width;
  xim->height = height;
  xim->bitmap_pad = 0 /*bitmap_pad*/;
  xim->bitmap_unit = 16;
  xim->bytes_per_line = ((width*depth)+7)>>3;
  xim->byte_order = 0 /*MSBFirst*/;
  xim->depth = depth;
  xim->format = format;
  xim->xoffset = offset;
  xim->data = data;
  xim->f.create_image = ANop2;
  xim->f.destroy_image = ADestroyImage;
  xim->f.get_pixel = XGet_Pixel;
  xim->f.put_pixel = XPut_Pixel;
  xim->f.sub_image = ANop;
  xim->f.add_pixel = ANop;

/*
  if(xim->data)
    memset(xim->data,0,xim->height*xim->bytes_per_line);
*/

  switch( format ){
  case XYBitmap: xim->bits_per_pixel=1; break;
  case XYPixmap: break;
  case ZPixmap:
    xim->bits_per_pixel=depth;
/*
    switch( xim->bitmap_pad ){
    case  8: xim->bits_per_pixel=8;break;
    case 16: xim->bits_per_pixel=8;break;
    case 32: xim->bits_per_pixel=8;break;
    }*/
    break;
  }
  return(xim);
}

/********************************************************************************
Name     : _XInitImageFuncPtrs()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

_XInitImageFuncPtrs( XImage *xim )
{
  assert(xim);

  xim->f.create_image = ANop2;
  xim->f.destroy_image = ADestroyImage;
  xim->f.get_pixel = XGet_Pixel;
  xim->f.put_pixel = XPut_Pixel;
  xim->f.sub_image = ANop;
  xim->f.add_pixel = ANop;

  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

char*
make_8bit( XImage *image,
	   int src_x,
	   int src_y,
	   int width,
	   int height )
{
  int p = 0,x,y;
  int vSize;
  char* pData = NULL;

  switch ( image->depth ){
  case 1:
  case 8:
    assert(1==0);
    break;
  case 2:

    pData = malloc((src_x+width)*(src_y+height)+16);
    if( !pData )
      X11resource_exit(IMAGES11);

    for( y=0; y<height; y++ ){
      int vData;

      p = y*width;
      for( x=src_x; x<(int)(width/4); x++ ){
	vData = image->data[(y+src_y)*image->bytes_per_line+x];
	pData[p++]=vData & 0x03;
	pData[p++]=( vData & (0x03<<2) )>>2;
	pData[p++]=( vData & (0x03<<4) )>>4;
	pData[p++]=( vData & (0x03<<6) )>>6;
      }
    }
    break;
  case 3:

    pData = malloc((src_x+width)*(src_y+height+2)+16);
    vSize = (src_x+width)*(src_y+height);
    if( !pData )
      X11resource_exit(IMAGES11);

    if( image->bytes_per_line==2 ){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p++]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
	pData[p++]=(image->data[y*image->bytes_per_line+1]&0x1C)>>2;
      }

      return pData;
    }
    if( image->bytes_per_line==1 ){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
      }

      return pData;
    }

    /* odd, but fast..(hopefully..): */
    for( y=0; y<src_y+height; y++ ){
      p=y*(src_x+width);
      for( x=0; x<(int)((src_x+width)/3); x++ ){
	pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0xE0)>>5;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0x1C)>>2;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0x03)<<1|
	  (image->data[y*image->bytes_per_line+x*3+1]&0x80)>>7;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x70)>>4;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x0E)>>1;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x01)<<2|
	  (image->data[y*image->bytes_per_line+x*3+2]&0xC0)>>6;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+2]&0x38)>>3;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+2]&0x07);
      }
    }
#if 0
    p=((src_y+height)-1)*(src_x+width);
    for( x=0; x<(int)((src_x+width)/3); x++ ){
      pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0xE0)>>5;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0x1C)>>2;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0x03)<<1|
	(image->data[y*image->bytes_per_line+x*3+1]&0x80)>>7;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x70)>>4;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x0E)>>1;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x01)<<2|
	(image->data[y*image->bytes_per_line+x*3+2]&0xC0)>>6;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3+2]&0x38)>>3;
      if( p==vSize )
	break;
      pData[p++] = (image->data[y*image->bytes_per_line+x*3+2]&0x07);
    }
#endif
    break;
  case 4:

    pData = malloc((src_x+width)*(src_y+height)+16);
    if( !pData )
      X11resource_exit(IMAGES11);

    for( y=0; y<height; y++ ){
      p=y*width;
      for( x=src_x; x<(int)(width/2); x++ ){
	pData[p++]=image->data[(y+src_y)*image->bytes_per_line+x]&0x0F;
	pData[p++]=(image->data[(y+src_y)*image->bytes_per_line+x]&0xF0)>>4;
      }
    }
    break;
  case 6:

    pData = malloc((src_x+width)*(src_y+height+2)+16);
    vSize = (src_x+width)*(src_y+height);
    if( !pData )
      X11resource_exit(IMAGES11);

#if 0
    if( image->bytes_per_line==2 ){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p++]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
	pData[p++]=(image->data[y*image->bytes_per_line+1]&0x1C)>>2;
      }

      return pData;
    }
    if( image->bytes_per_line==1 ){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
      }

      return pData;
    }
#endif

    /* odd, but fast..(hopefully..): */
    for( y=0; y<src_y+height; y++ ){
      p=y*(src_x+width);
      for( x=0; x<(int)((src_x+width)/3); x++ ){
	pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0xfc)>>2;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3]&0x03)<<4|
	  (image->data[y*image->bytes_per_line+x*3+1]&0xf0)>>4;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+1]&0x0f)<<2|
	  (image->data[y*image->bytes_per_line+x*3+2]&0xc0)>>6;
	pData[p++] = (image->data[y*image->bytes_per_line+x*3+2]&0x3f);
      }
    }
    break;

  default:
    printf("Unsupported image depth\n");
    break;
  }

  return pData;
}

/********************************************************************************
Name     : XPutImage()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     d         Specifies the drawable.

     gc        Specifies the graphics context.

     image     Specifies the image you want combined with the rectangle.

     src_x
     src_y
               Specify the coordinates of  the  upper-left  corner  of  the
               rectangle to be copied, relative to the origin of the image.

     dest_x
     dest_y
               Specify the x and y coordinates, relative to the  origin  of
               the  drawable,  where  the  upper-left  corner of the copied
               rectangle will be placed.

     width
     height
               Specify the width and height in pixels  of  the  rectangular
               area to be copied.

Output   : 
Function : draw an image on a window or pixmap.
********************************************************************************/

int bSkipPutImage = 0;

XPutImage( Display* display,
	   Drawable d,
	   GC gc,
	   XImage *image,
	   int src_x,
	   int src_y,
	   int dest_x,
	   int dest_y,
	   unsigned int width,
	   unsigned int height )
{
  struct RastPort *mainrp = NULL;
  struct Window *destwin = NULL;
  struct BitMap *destBM = NULL;
  int bt = 0;
  int bl = 0;
  int destdrawable;
  char *pData;

  assert(X11Drawables);

  destdrawable = X11Drawables[d];
#ifdef DEBUGXEMUL_ENTRY
  if( bInformImages )
    printf("XPutImage src [%d %d] dest [%d %d] size [%d %d]\n",src_x,src_y,
	   dest_x,dest_y,width,height);
  if( bSkipImageWrite )
    return;
  if( bSkipPutImage ){
    return;
  }
  FunCount_Enter( XPUTIMAGE , bInformImages );
#endif
#ifndef NO020

  if( image->depth<8 && image->depth>1 && !gfxcard ){
    pData = make_8bit(image,src_x,src_y,width,height);
  } else
    pData = image->data;
  if( gfxcard ){
#endif
    XPutImage_nochunky(display,d,gc,image,src_x,src_y,dest_x,dest_y,width,height);
    return;
#ifndef NO020
  }
  switch( destdrawable ){
  case X11WINDOW: {
    if( d!=DG.vPrevWindow )
      if( !(DG.drp=setup_win(d)) )
	return NULL;

    destBM = DG.vWindow->RPort->BitMap;
    mainrp = DG.vWindow->RPort;
#if 0
    XClearArea(display,d,dest_x,dest_y,width,height,0);
#endif
    bl = GetWinX(d)+DG.vWindow->BorderLeft+DG.vWindow->LeftEdge;
    bt = GetWinY(d)+DG.vWindow->BorderTop+DG.vWindow->TopEdge;
    destdrawable = X11WINDOW;
    destwin = DG.vWindow;
  }
    break;
  case X11BITMAP: {
    destBM = X11DrawablesBitmaps[X11DrawablesMap[d]].pBitMap;
  }
    break;
#ifdef XMUI
  case X11MUI: {
    int w,h;

    MUIGetWin( d, &destwin, &bl,&bt,&w,&h );

    destBM = destwin->RPort->BitMap;
    mainrp = destwin->RPort;
    destdrawable = X11WINDOW;
  }
    break;
#endif
  default:
    printf("unsupported depth in xputimage\n");
    return;
  }

  if( image->depth!=destBM->Depth )
    XClearArea(display,d,dest_x,dest_y,width,height,0);

  if( !CG.bNeedClip ){
    if( destdrawable==X11WINDOW ){
      if( image->depth!=1 ){
	X11testback(image->width,image->height,image->depth);
	c2p.bmap = backrp.BitMap;
	c2p.startX = 0; c2p.startY = 0;
	c2p.width = src_x+width; c2p.height = src_y+height;
	c2p.chunkybuffer = pData;
	ChunkyToPlanarAsm(&c2p);
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,src_x,src_y,destwin->RPort,dest_x+bl,dest_y+bt,width,height,
			  /*0xc0*/  (ABC|ABNC|ANBC));
      } else {
	int x,y;
	struct BitMap *bm = alloc_bitmap(image->width,image->height,1,0,DG.wb->RastPort.BitMap);

	if( DG.XAllocFailed ) return NULL;

	if( image->bitmap_bit_order==LSBFirst ){
	  for( y=0; y<image->height; y++ ){
	    for( x=0; x<image->bytes_per_line; x++ ){
	      *(bm->Planes[0]+y*bm->BytesPerRow+x) = X11InvertMap[*((unsigned char*)(image->data+y*image->bytes_per_line+x))];
	    }
	  }
	} else {
	  for( y=0; y<image->height; y++ )
	    memcpy(bm->Planes[0]+y*bm->BytesPerRow,image->data+y*image->bytes_per_line,image->bytes_per_line);
	}
	BltBitMapRastPort(bm,src_x,src_y,destwin->RPort,dest_x+bl,dest_y+bt,width,height,0xc0 /*(ABC|ABNC|ANBC)*/);
	free_bitmap(bm);
      }
    } else {
      X11testback(image->width,image->height,image->depth);
      if( image->depth!=1 ){
#if 0
      if( destBM->Depth!=1 ){
#endif
	c2p.bmap = backrp.BitMap;
	c2p.startX = 0; c2p.startY = 0;
	c2p.width = src_x+width; c2p.height = src_y+height;
	c2p.chunkybuffer = pData;
	ChunkyToPlanarAsm(&c2p);
	WaitBlit();
	BltBitMap(backrp.BitMap,src_x,src_y,destBM,dest_x,dest_y,width,height,0xc0 /*(ABC|ABNC|ANBC)*/,0xFF,NULL);
#if (DEBUG!=0)
	if(show) showbitmap(backrp.BitMap,width,height,0,0);
#endif
      } else {
#if 0
	int bdpl = (width+7)>>3,bpl=destBM->BytesPerRow,i;

	for( i=0; i<bdpl*height; i++ ){
	  *(destBM->Planes[0]+(i%bdpl)+(int)(dest_x/8)+(int)((i/bdpl)+dest_y)*bpl)=*((unsigned char*)(image->data+i));
	}
#endif
	int x,y;
	struct BitMap *bm = alloc_bitmap(image->width,image->height,1,0,DG.wb->RastPort.BitMap);

	if( image->bitmap_bit_order==LSBFirst ){
	  for( y=0; y<image->height; y++ ){
	    for( x=0; x<image->bytes_per_line; x++ ){
	      *(bm->Planes[0]+y*bm->BytesPerRow+x) = X11InvertMap[*((unsigned char*)(image->data+y*image->bytes_per_line+x))];
	    }
	  }
	} else {
	  for( y=0; y<image->height; y++ )
	    memcpy(bm->Planes[0]+y*bm->BytesPerRow,image->data+y*image->bytes_per_line,image->bytes_per_line);
	}
	BltBitMap(bm,src_x,src_y,destBM,dest_x+bl,dest_y+bt,width,height,0xc0,0xff,NULL);
	free_bitmap(bm);

#if (DEBUG!=0)
	if( X11Drawables[d]!=X11WINDOW ){
	  if( show )
	    XPutImage(NULL,1,NULL,image,0,0,0,0,width,height);
	}
#endif

#if (DEBUG!=0)
	if(show) showbitmap(destBM,width,height,0,0);
#endif

      }
    }
  } else {
    struct BitMap *bm;

    X11testback(image->width,image->height,image->depth);
    bm = alloc_bitmap(image->width,image->height,image->depth,BMF_CLEAR,DG.wb->RastPort.BitMap);
    if( DG.XAllocFailed ) return NULL;

    c2p.bmap = bm;
    c2p.startX = 0; c2p.startY = 0;
    c2p.width = src_x+width; c2p.height = src_y+height;
    c2p.chunkybuffer = pData;
    ChunkyToPlanarAsm(&c2p);
    if( X11Drawables[d]==X11WINDOW ){
      WaitBlit();
      BltBitMap(destBM,bl+dest_x,bt+dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,0,0,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,mainrp->BitMap,bl+dest_x,bt+dest_y,width,height,0xC0,0xFF,NULL);
    } else {
      int bm_srcx = 0,bm_srcy = 0;
      int bm_width = width,bm_height = height;
      int destWidth = GetBitMapAttr(destBM,BMA_WIDTH);
      int destHeight = GetBitMapAttr(destBM,BMA_HEIGHT);

      if( dest_x<0 ){
	bm_srcx =- dest_x;
	dest_x = 0;
	bm_width -= bm_srcx;
      }
      if( dest_y<0 ){
	bm_srcy =- dest_y;
	dest_y = 0;
	bm_height -= bm_srcy;
      }
      if( dest_x+width>destWidth ){
	bm_width = bm_width-(dest_x+width-destWidth);
      }
      if( dest_y+height>destHeight ){
	bm_height = bm_height-(dest_y+height-destHeight);
      }
      if( bm_width<1 || bm_height<1 ){
	free_bitmap(bm); 

	return(0);
      }
      WaitBlit();
      BltBitMap(destBM,dest_x,dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,bm_srcx,bm_srcy,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,dest_x,dest_y,bm_width,bm_height,0xC0,0xFF,NULL);
#if (DEBUG!=0)
      if(show) showbitmap(backrp.BitMap,width,height,0,0);
#endif
    }
    free_bitmap(bm);
  }
  if( image->depth<8 && image->depth>1 && !gfxcard )
    free(pData);

  return(0);
#endif
}


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XPutImage_nochunky( Display* display,
		    Drawable d,
		    GC gc,
		    XImage* image,
		    int src_x,
		    int src_y,
		    int dest_x,
		    int dest_y,
		    unsigned int width,
		    unsigned int height )
{
  UBYTE *data = NULL;
  int bt = 0;
  int bl = 0;
  int bwide;
  int fromx,fromy;
  struct Window *destwin;
  struct BitMap *destBM = NULL;
  struct RastPort *mainrp = NULL;
  int destdrawable;
  char *pData;
  struct RastPort temprp;

  assert(X11Drawables);
  assert(image);

  destdrawable = X11Drawables[d];
  bwide = (((image->width+15)>>4)<<4);
  if( image->depth<8 ){
    pData = make_8bit(image,src_x,src_y,width,height);
  } else
    pData = image->data;

  X11testback(width,height,image->depth);
  switch( destdrawable ){
  case X11WINDOW: {
    if( d!=DG.vPrevWindow )
      if( !(DG.drp=setup_win(d)) )
	return NULL;

    destBM = DG.vWindow->RPort->BitMap;
    mainrp = DG.vWindow->RPort;
    bl = GetWinX(d)+DG.vWindow->BorderLeft;
    bt = GetWinY(d)+DG.vWindow->BorderTop;
    destdrawable = X11WINDOW;
  }
    break;
#ifdef XMUI
  case X11MUI: {
    int w,h;

    MUIGetWin( d, &destwin, &bl,&bt,&w,&h );

    destBM = destwin->RPort->BitMap;
    mainrp = destwin->RPort;
    destdrawable = X11WINDOW;
  } break;
#endif
  case X11BITMAP:
    destBM = X11DrawablesBitmaps[X11DrawablesMap[d]].pBitMap;
    break;
  default:
    printf("Unsupported destination in xputimage\n");
    return;
  }
  
  if( image->depth!=destBM->Depth )
    XClearArea(display,d,dest_x,dest_y,width,height,0);

  if( image->width!=bwide ){
    int i;

    data = (UBYTE*)malloc(bwide*(image->height+1));
    if( !data )
      X11resource_exit(IMAGES2);
    for( i=0; i<image->height; i++ ){
      memset((data+(i+1)*bwide-16),0,16);
      memcpy((data+i*bwide),(pData /*image->data*/+i*image->width),image->width);
    }
    fromx = dest_x;fromy=dest_y;
  } else {
    int size=image->width*image->height;

    data = malloc(size+image->width);
    if( !data )
      X11resource_exit(IMAGES3);
    memcpy(data,pData /*image->data*/,size);
    if( width<image->width ) {
      fromx = dest_x-src_x;
      fromy = dest_y-src_y;
    }
    else {
      fromx = dest_x;
      fromy = dest_y;
    }
  }
  temprp.BitMap = alloc_bitmap(image->width+16,1,image->depth,BMF_CLEAR,DG.wb->RastPort.BitMap);
  if( DG.XAllocFailed )
    return NULL;

  if( !CG.bNeedClip ){
    if(destdrawable==X11WINDOW){
      assert( mainrp );
      WritePixelArray8(mainrp,bl+fromx,bt+fromy,bl+fromx+image->width-1,bt+fromy+image->height-1,data,&temprp);
    } else {
      if( destBM->Depth!=1 ){
	WritePixelArray8(&backrp,0,0,image->width-1,image->height-1,data,&temprp);
	BltBitMap(backrp.BitMap,0,0,destBM,fromx,fromy,width,height,0xc0 /*(ABC|ABNC|ANBC)*/,0xFF,NULL);
	WaitBlit();
      } else {
	int bdpl=(width+7)>>3,bpl=destBM->BytesPerRow,i;

	for( i=0; i<bdpl*height; i++ ){
	  *(destBM->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl) = *((unsigned char*)(image->data+i));
	}
      }
/*      RectFill(&(wb->RastPort),20,20,20+width,20+height);
      BltBitMapRastPort(backrp.BitMap,0,0,&(wb->RastPort),22,22,image->width,image->height,(ABC|ABNC|ANBC));*/
    }
  } else { /* need clip */
    struct BitMap *bm = alloc_bitmap(width,height,image->depth,BMF_CLEAR,DG.wb->RastPort.BitMap);

    if( DG.XAllocFailed ){
      free_bitmap( temprp.BitMap );
      return NULL;
    }
    WritePixelArray8(&backrp,0,0,image->width-1,image->height-1,data,&temprp);
    BltBitMap(backrp.BitMap,0,0,bm,0,0,width,height,0xC0,0xFF,NULL);
    WaitBlit();
    if( destdrawable==X11WINDOW ){
      BltBitMap(destBM,dest_x+bl,dest_y+bt,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,0,0,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,bl+dest_x,bt+dest_y,width,height,0xC0,0xFF,NULL);
      WaitBlit();
    } else {
      int bm_srcx = 0,bm_srcy = 0;
      int bm_width = width,bm_height = height;
      int destWidth = GetBitMapAttr(destBM,BMA_WIDTH);
      int destHeight = GetBitMapAttr(destBM,BMA_HEIGHT);

      if( dest_x<0 ){
	bm_srcx =- dest_x;
	dest_x = 0;
	bm_width -= bm_srcx;
      }
      if( dest_y<0 ){
	bm_srcy =- dest_y;
	dest_y = 0;
	bm_height -= bm_srcy;
      }
      if( dest_x+width>destWidth ){
	bm_width = bm_width-(dest_x+width-destWidth);
      }
      if( dest_y+height>destHeight ){
	bm_height = bm_height-(dest_y+height-destHeight);
      }
      if( bm_width<1 || bm_height<1 ){
	free_bitmap( temprp.BitMap );
	free_bitmap( bm );

	return(0);
      }

      BltBitMap(destBM,dest_x,dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,bm_srcx,bm_srcy,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,dest_x,dest_y,bm_width,bm_height,0xC0,0xFF,NULL);
    }
    free_bitmap( bm );
  }

  free_bitmap( temprp.BitMap );

  if( image->depth<8 )
    free(pData);
  free(data);
}

