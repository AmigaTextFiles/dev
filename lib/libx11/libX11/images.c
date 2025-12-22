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
***/

#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>

#include <hardware/blit.h>

#include <proto/intuition.h>

#include <dos.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>

#include "amigax_proto.h"
#include "amiga_x.h"
#undef memset

/*******************************************************************************************/
/* externals */
/*******************************************************************************************/

extern struct Screen *Scr,*wb;
extern struct RastPort temprp,*mainrp;
extern struct RastPort backrp;
extern GC      amiga_gc;

extern int X_relx,X_rely,X_right,X_bottom,X_width,X_height;
extern struct RastPort *drp;

/*******************************************************************************************/
long ANop(XImage *xim,int x,int y);
__stdargs int ADestroyImage(struct _XImage *xim);

#ifdef DEBUG
void showbitmap(struct BitMap *bm,int width,int height,int pos);
#endif

int show=0;

extern WORD *Xcurrent_tile;
int Xhas_tile=0,Xtile_size;

long ANop(XImage *xim,int x,int y){
/*
  printf("internal undefined func called!\nPress return..\n");
  getchar();
*/
  return(0);
}

XImage *ANop2(){
/*
  printf("internal undefined func(2) called!\nnPress return..");
  getchar();
*/
  return((XImage*)NULL);
}

__stdargs ADestroyImage(struct _XImage *xim)
{
#ifdef DEBUGXEMUL_ENTRY
  printf("ADestroyImage\n");
#endif
  if(xim->data!=NULL) free(xim->data);
  List_RemoveEntry(pMemoryList,(void*)xim);
  xim=NULL;
  return(1);
}

unsigned long XGetPixel(struct _XImage *xim,int x,int y){
  int bit;
  if(xim->bitmap_bit_order==LSBFirst){
    if(xim->depth==1){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=byte&(1<<(x%8));
    }
    else{
      int byte=*(xim->data+y*xim->bytes_per_line+x);
      bit=byte;
    }
  }
  else{
    if(xim->depth==1){
      int byte=*(xim->data+y*xim->bytes_per_line+(x>>3));
      bit=byte&(128>>(x%8));
    }
    else{
      int byte=*(xim->data+y*xim->bytes_per_line+x);
      bit=byte;
    }
  }
  return((unsigned long)bit);
}

int XDestroyImage(ximage)
     XImage *ximage;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XDestroyImage\n");
#endif
  if(ximage->data!=0) free(ximage->data);
  List_RemoveEntry(pMemoryList,(void*)ximage);
}

extern __stdargs int XPut_Pixel(XImage *xim, int x, int y, unsigned long pixel);
extern __stdargs unsigned long  XGet_pixel(struct _XImage*,int,int);

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>

#include <libraries/mui.h>
#include <proto/muimaster.h>

XImage *XCreateImage(display, visual, depth, format, offset,
		     data, width, height, bitmap_pad, bytes_per_line)
     Display *display;
     Visual *visual;
     unsigned int depth;
     int format;
     int offset;
     char *data;
     unsigned int width;
     unsigned int height;
     int bitmap_pad;
     int bytes_per_line;
{
  XImage *xim;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreateImage (%d,%d) %d\n",width,height,depth);
#endif
  xim=(XImage*)malloc(sizeof(XImage));
  if(!xim)  X11resource_exit(IMAGES1);
  List_AddEntry(pMemoryList,(void*)xim);
  xim->width=width;
  xim->height=height;
  xim->bitmap_pad=0 /*bitmap_pad*/;
  xim->bitmap_unit=16;
  xim->bytes_per_line=((width*depth)+7)>>3;
/*
  if(depth==3)
    xim->bytes_per_line+=2;
*/
  xim->byte_order=0 /*MSBFirst*/;
  xim->depth=depth;
  xim->format=format;
  xim->xoffset=offset;
  xim->data=data;
  xim->f.create_image=ANop2;
  xim->f.destroy_image=ADestroyImage;
  xim->f.get_pixel=XGet_pixel;
  xim->f.put_pixel=XPut_Pixel;
  xim->f.sub_image=ANop;
  xim->f.add_pixel=ANop;

/*
  if(xim->data)
    memset(xim->data,0,xim->height*xim->bytes_per_line);
*/

  switch(format){
  case XYBitmap: xim->bits_per_pixel=1; break;
  case XYPixmap: break;
  case ZPixmap:
    xim->bits_per_pixel=depth;
/*
    switch(xim->bitmap_pad){
    case  8: xim->bits_per_pixel=8;break;
    case 16: xim->bits_per_pixel=8;break;
    case 32: xim->bits_per_pixel=8;break;
    }*/
    break;
  }
  return(xim);
}

extern void __asm PlanarToChunkyAsm(register __a0 struct p2cStruct *);
extern void __asm ChunkyToPlanarAsm(register __a0 struct c2pStruct *);
extern struct BitMap *alloc_bitmap(int,int,int,int);
extern int free_bitmap(struct BitMap *);
/*extern struct Window *rootwin;*/
extern int x_clip_origin,y_clip_origin,gfxcard;

#ifndef NO020
struct p2cStruct{
  struct BitMap *bmap;
  UWORD startX, startY, width, height;
  UBYTE *chunkybuffer;
} p2c;

struct c2pStruct {
  struct BitMap *bmap;
  UWORD startX, startY, width, height;
  UBYTE *chunkybuffer;
} c2p;

#endif

XPutImage_nochunky(
     Display *display,
     Drawable d,
     GC gc,
     XImage *image,
     int src_x, int src_y,
     int dest_x, int dest_y,
     unsigned int width, unsigned int height
);

XPutImage_nochunky(display, d, gc, image, src_x, src_y,
	  dest_x, dest_y, width, height)
     Display *display;
     Drawable d;
     GC gc;
     XImage *image;
     int src_x, src_y;
     int dest_x, dest_y;
     unsigned int width, height;
{
  UBYTE *data=NULL;
  int bt,bl;
  int bwide=(((image->width+15)>>4)<<4);
  int fromx,fromy;
  struct Window *destwin;
  struct BitMap *destBM;
  struct RastPort *mainrp;
  int destdrawable=X11Drawables[d];

/*
  char *pData;
  if( image->depth<8 ){
    pData=malloc(image->width*image->height+16);
    if(!pData){
      return NULL;
    }
    make_8bit(image,pData);
  } else pData=image->data;
*/
  XClearArea(display,d,dest_x,dest_y,width,height,0);

  if(backrp.BitMap->Depth!=image->depth){
    if(backrp.BitMap) free_bitmap(backrp.BitMap);
    backrp.BitMap=NULL;
  }  
  X11testback(width,height,image->depth);
  if(destdrawable==X11WINDOW){
    destwin=X11DrawablesWindows[X11DrawablesMap[d]];
    if(!destwin) return 0;
    mainrp=destwin->RPort;
    destBM=destwin->RPort->BitMap;
    destdrawable=X11WINDOW;
    bt=destwin->BorderTop;
    bl=destwin->BorderLeft;
  } else if(destdrawable==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[d]];
    destwin=Agetwin(d);
    prevwin=-1;
    if(!destwin) return 0;
    destBM=destwin->RPort->BitMap;
    mainrp=destwin->RPort;
    XClearArea(display,d,dest_x,dest_y,width,height,0);
    bl=X11DrawablesChildren[child].x+destwin->BorderLeft;
    bt=X11DrawablesChildren[child].y+destwin->BorderTop;
    destdrawable=X11WINDOW;
  } else if(destdrawable==X11MUI){
    Object *obj=X11DrawablesMUI[X11DrawablesMap[d]];
    destBM=_window(obj)->RPort->BitMap;
    destwin=_window(obj);
    mainrp=destwin->RPort;
    destdrawable=X11WINDOW;
    bl=_mleft(obj);
    bt=_mtop(obj);
  } else destBM=X11DrawablesBitmaps[X11DrawablesMap[d]].pBitMap;

  if(image->width!=bwide){
    int i;
    data=(UBYTE*)malloc(bwide*(image->height+1));
    if(!data)  X11resource_exit(IMAGES2);
    for(i=0;i<image->height;i++){
      memset((data+(i+1)*bwide-16),0,16);
      memcpy((data+i*bwide),(image->data+i*image->width),image->width);
    }
    fromx=dest_x;fromy=dest_y;
  }else{
    int size=image->width*image->height;
    data=malloc(size+image->width);
    if(!data)  X11resource_exit(IMAGES3);
    memcpy(data,image->data,size);
    if(width<image->width) {fromx=dest_x-src_x; fromy=dest_y-src_y;}
    else { fromx=dest_x;fromy=dest_y;}
  }
  if(temprp.BitMap) free_bitmap(temprp.BitMap);
  temprp.BitMap=alloc_bitmap(image->width+16,1,image->depth,BMF_CLEAR);

  if(!CG.bNeedClip){
    if(destdrawable==X11WINDOW)
      WritePixelArray8(mainrp,bl+fromx,bt+fromy,bl+fromx+image->width-1,bt+fromy+image->height-1,data,&temprp);
    else{
      if(destBM->Depth!=1){
	WritePixelArray8(&backrp,0,0,image->width-1,image->height-1,data,&temprp);
	BltBitMap(backrp.BitMap,0,0,destBM,fromx,fromy,width,height,0xc0 /*(ABC|ABNC|ANBC)*/,0xFF,NULL);
	WaitBlit();
      } else{
	int bdpl=(width+7)>>3,bpl=destBM->BytesPerRow,i;
	for(i=0;i<bdpl*height;i++){
	  *(destBM->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl)=*(image->data+i);
	}
      }
/*      RectFill(&(wb->RastPort),20,20,20+width,20+height);
      BltBitMapRastPort(backrp.BitMap,0,0,&(wb->RastPort),22,22,image->width,image->height,(ABC|ABNC|ANBC));*/
    }
  }else{
    struct BitMap *bm=alloc_bitmap(width,height,image->depth,BMF_CLEAR);
    WritePixelArray8(&backrp,0,0,image->width-1,image->height-1,data,&temprp);
    BltBitMap(backrp.BitMap,0,0,bm,0,0,width,height,0xC0,0xFF,NULL);
    WaitBlit();
    if(destdrawable==X11WINDOW){
      BltBitMap(destBM,dest_x+bl,dest_y+bt,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,0,0,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,bl+dest_x,bt+dest_y,width,height,0xC0,0xFF,NULL);
      WaitBlit();
    }else{
      int bm_srcx=0,bm_srcy=0;
      int bm_width=width,bm_height=height;
      int destWidth=GetBitMapAttr(destBM,BMA_WIDTH);
      int destHeight=GetBitMapAttr(destBM,BMA_HEIGHT);
      if(dest_x<0){bm_srcx=-dest_x; dest_x=0; bm_width-=bm_srcx;}
      if(dest_y<0){bm_srcy=-dest_y; dest_y=0; bm_height-=bm_srcy;}
      if(dest_x+width>destWidth){bm_width=bm_width-(dest_x+width-destWidth);}
      if(dest_y+height>destHeight){bm_height=bm_height-(dest_y+height-destHeight);}
      if(bm_width<1||bm_height<1){free_bitmap(bm); return(0);}

      BltBitMap(destBM,dest_x,dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,bm_srcx,bm_srcy,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,dest_x,dest_y,bm_width,bm_height,0xC0,0xFF,NULL);
      WaitBlit();
    }
    free_bitmap(bm);
  }
  free(data);
}


void X11testback(int width,int height,int depth)
{
  if(!backrp.BitMap){
    InitRastPort(&backrp);
/*    printf("has to set backrp! %d %d %d\n",width,height,wbdepth);*/
    backrp.BitMap=alloc_bitmap(width,height,depth,BMF_CLEAR);
    backrp.Layer=NULL;
    DG.bNeedBackRP=1;
  }else{
    int destWidth;
    int destHeight;
    int destDepth;
    if (DG.bUse30){
      destWidth=GetBitMapAttr(backrp.BitMap,BMA_WIDTH);
      destHeight=GetBitMapAttr(backrp.BitMap,BMA_HEIGHT);
      destDepth=GetBitMapAttr(backrp.BitMap,BMA_DEPTH);
    } else {
      destWidth=backrp.BitMap->BytesPerRow*8;
      destHeight=backrp.BitMap->Rows;
      destDepth=backrp.BitMap->Depth;
    }      
    if(destWidth<width||destHeight<height||destDepth<depth){
      free_bitmap(backrp.BitMap);
      backrp.BitMap=alloc_bitmap(width,height,depth,BMF_CLEAR);
    }
  }
}

make_8bit( XImage *image, char* pData, int src_x, int src_y, int width, int height ){
  int p=0,x,y;

  switch (image->depth){
  case 1:
  case 8:
    break;
  case 2:
    break;
  case 3:
    if(image->bytes_per_line==2){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p++]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
	pData[p++]=(image->data[y*image->bytes_per_line+1]&0x1C)>>2;
      }
      return;
    }
    if(image->bytes_per_line==1){
      for( y=0; y<src_y+height; y++ ){
	p=y*(src_x+width);
	pData[p]=(image->data[y*image->bytes_per_line]&0xE0)>>5;
      }
      return;
    }
    for( y=0; y<src_y+height-1; y++ ){
      p=y*(src_x+width);
      for( x=0; x<(int)((src_x+width)/3); x++ ){
	pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0xE0)>>5;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0x1C)>>2;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0x03)<<1|
	  (image->data[y*image->bytes_per_line+x*3+1]&0x80)>>7;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x70)>>4;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x0E)>>1;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x01)<<2|
	  (image->data[y*image->bytes_per_line+x*3+2]&0xC0)>>6;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3+2]&0x38)>>3;
	pData[p++]=(image->data[y*image->bytes_per_line+x*3+2]&0x07);
      }
      /* and the rest */
    }
    p=((src_y+height)-1)*(src_x+width);
    for( x=0; x<(int)((src_x+width)/3); x++ ){
      pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0xE0)>>5;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0x1C)>>2;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3]&0x03)<<1|
	(image->data[y*image->bytes_per_line+x*3+1]&0x80)>>7;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x70)>>4;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x0E)>>1;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3+1]&0x01)<<2|
	(image->data[y*image->bytes_per_line+x*3+2]&0xC0)>>6;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3+2]&0x38)>>3;
      if(p==image->height*image->width) break;
      pData[p++]=(image->data[y*image->bytes_per_line+x*3+2]&0x07);
    }

    break;
  case 4:
    for( y=0; y<src_y+height; y++ ){
      p=y*(src_x+width);
      for( x=0; x<src_x+width; x++ ){
	pData[p++]=image->data[y*image->bytes_per_line+x]&0x0F;
	pData[p++]=(image->data[y*image->bytes_per_line+x]&0xF0)>>4;
      }
    }
    break;
  }
}

XPutImage(display, d, gc, image, src_x, src_y,
	  dest_x, dest_y, width, height)
     Display *display;
     Drawable d;
     GC gc;
     XImage *image;
     int src_x, src_y;
     int dest_x, dest_y;
     unsigned int width, height;
{
  struct RastPort *mainrp=NULL;
  struct Window *destwin;
  struct BitMap *destBM;
  int bt,bl;
  int destdrawable=X11Drawables[d];
  char *pData;

#ifdef DEBUGXEMUL_ENTRY
  printf("XPutImage src [%d %d] dest [%d %d] size [%d %d]\n",src_x,src_y,
	 dest_x,dest_y,width,height);
#endif
#ifndef NO020

  if( image->depth<8 ){
    pData=malloc((src_x+width)*(src_y+height)+16);
    if(!pData) X11resource_exit(IMAGES11);
    make_8bit(image,pData,src_x,src_y,width,height);
  } else pData=image->data;
  XClearArea(display,d,dest_x,dest_y,width,height,0);
  if(gfxcard){
#endif
    XPutImage_nochunky(display,d,gc,image,src_x,src_y,dest_x,dest_y,width,height);
    return;
#ifndef NO020
  }
  if(destdrawable==X11WINDOW){
    destwin=X11DrawablesWindows[X11DrawablesMap[d]];
    if(!destwin) return 0;
    destBM=destwin->RPort->BitMap;
    mainrp=destwin->RPort;
#if 0
    SetRast(mainrp,0);
    RefreshWindowFrame(destwin);
#endif
    bt=destwin->BorderTop;
    bl=destwin->BorderLeft;
  } else if(destdrawable==X11SUBWINDOW){
    int child=X11DrawablesSubWindows[X11DrawablesMap[d]];
    destwin=Agetwin(d);
    prevwin=-1;
    if(!destwin) return 0;
    destBM=destwin->RPort->BitMap;
    mainrp=destwin->RPort;
    XClearArea(display,d,dest_x,dest_y,width,height,0);
    bl=X11DrawablesChildren[child].x+destwin->BorderLeft+destwin->LeftEdge;
    bt=X11DrawablesChildren[child].y+destwin->BorderTop+destwin->TopEdge;
    destdrawable=X11WINDOW;
  } else if(destdrawable==X11BITMAP){
    destBM=X11DrawablesBitmaps[X11DrawablesMap[d]].pBitMap;
  } else if(destdrawable==X11MUI){
    Object *obj=X11DrawablesMUI[X11DrawablesMap[d]];
    destBM=_window(obj)->RPort->BitMap;
    destwin=_window(obj);
    mainrp=destwin->RPort;
    destdrawable=X11WINDOW;
    bl=_mleft(obj);
    bt=_mtop(obj);
  }

  if(!CG.bNeedClip){
    if(destdrawable==X11WINDOW){
      if(image->depth!=1){
	X11testback(image->width,image->height,image->depth);
	c2p.bmap=backrp.BitMap;
	c2p.startX = 0; c2p.startY = 0;
	c2p.width = image->width; c2p.height = image->height;
	c2p.chunkybuffer = pData;
	ChunkyToPlanarAsm(&c2p);
	BltBitMapRastPort(backrp.BitMap,src_x,src_y,destwin->RPort,dest_x+bl,dest_y+bt,width,height,
			  0xc0 /*(ABC|ABNC|ANBC)*/);
	WaitBlit();
      } else {
	int y;
	struct BitMap *bm=alloc_bitmap(image->width,image->height,1,0);
	for( y=0; y<image->height; y++ )
	  memcpy(bm->Planes[0]+y*bm->BytesPerRow,image->data+y*image->bytes_per_line,image->bytes_per_line);
	BltBitMapRastPort(bm,src_x,src_y,destwin->RPort,dest_x+bl,dest_y+bt,width,height,0xc0 /*(ABC|ABNC|ANBC)*/);
	free_bitmap(bm);
      }
    }
    else{
      X11testback(image->width,image->height,image->depth);
      if(destBM->Depth!=1){
	c2p.bmap=backrp.BitMap;
	c2p.startX = 0; c2p.startY = 0;
	c2p.width = image->width; c2p.height = image->height;
	c2p.chunkybuffer = pData;
	ChunkyToPlanarAsm(&c2p);
	BltBitMap(backrp.BitMap,src_x,src_y,destBM,dest_x,dest_y,width,height,0xc0 /*(ABC|ABNC|ANBC)*/,0xFF,NULL);
	WaitBlit();
      }else{
	int bdpl=(width+7)>>3,bpl=destBM->BytesPerRow,i;
	for(i=0;i<bdpl*height;i++){
	  *(destBM->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl)=*(image->data+i);
	}
      }
    }
  }else{
    struct BitMap *bm;
    X11testback(image->width,image->height,image->depth);
    bm=alloc_bitmap(image->width,image->height,image->depth,BMF_CLEAR);
    c2p.bmap=bm;
    c2p.startX=0; c2p.startY=0;
    c2p.width=image->width; c2p.height=image->height;
    c2p.chunkybuffer = pData;
    ChunkyToPlanarAsm(&c2p);
    if(X11Drawables[d]==X11WINDOW){
      BltBitMap(destBM,bl+dest_x,bt+dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,0,0,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,mainrp->BitMap,bl+dest_x,bt+dest_y,width,height,0xC0,0xFF,NULL);
      WaitBlit();
    }
    else{
      int bm_srcx=0,bm_srcy=0;
      int bm_width=width,bm_height=height;
      int destWidth=GetBitMapAttr(destBM,BMA_WIDTH);
      int destHeight=GetBitMapAttr(destBM,BMA_HEIGHT);
      if(dest_x<0){bm_srcx=-dest_x; dest_x=0; bm_width-=bm_srcx;}
      if(dest_y<0){bm_srcy=-dest_y; dest_y=0; bm_height-=bm_srcy;}
      if(dest_x+width>destWidth){bm_width=bm_width-(dest_x+width-destWidth);}
      if(dest_y+height>destHeight){bm_height=bm_height-(dest_y+height-destHeight);}
      if(bm_width<1||bm_height<1){free_bitmap(bm); return(0);}
      BltBitMap(destBM,dest_x,dest_y,backrp.BitMap,0,0,width,height,0xC0,0xFF,NULL);
      WaitBlit();
      BltMaskBitMapRastPort(bm,bm_srcx,bm_srcy,&backrp,0,0,width,height,0xc0 /*0xE0*/,CG.pClipBM->Planes[0]);
      WaitBlit();
      BltBitMap(backrp.BitMap,0,0,destBM,dest_x,dest_y,bm_width,bm_height,0xC0,0xFF,NULL);
      WaitBlit();
    }
    free_bitmap(bm);
  }
  if( image->depth<8 )
    free(pData);
  return(0);
#endif
}

XImage *XGetImage_nochunky(
     Display *display,
     Drawable drawable,
     int x, int y,
     unsigned int width, unsigned int height,
     unsigned long plane_mask,
     int format);

XImage *XGetImage_nochunky(display, drawable, x, y, width, height,
		  plane_mask, format)
     Display *display;
     Drawable drawable;
     int x, y;
     unsigned int width, height;
     unsigned long plane_mask;
     int format;
{
  XImage *xi;
#ifdef DEBUGXEMUL_ENTRY
  printf("XGetImage\n");
#endif
  ANop(NULL,0,0);
  return(0);
/*
  if(format==XYPixmap){ /* one plane pixmap */
    struct BitMap *bm=alloc_bitmap(width,height,1,BMF_CLEAR);
/*    printf("hm xypixmap..\n");*/
    xi=XCreateImage(display,NULL,1,XYPixmap,0,0,width,height,0,bm->BytesPerRow);
    xi->data=malloc(width*height);
    if(!xi->data)  X11resource_exit(IMAGES4);
    if(drawable==rootwin) p2c.bmap = rootwin->RPort.BitMap;
    else p2c.bmap=(struct BitMap*)drawable;
    BltBitMap(p2c.bmap,x,y,bm,0,0,width,height,0xC0,(UBYTE)plane_mask,NULL);
    WaitBlit();
    p2c.bmap=bm;
    p2c.startX = x; p2c.startY = y;
    p2c.width = width; p2c.height = height;
    p2c.chunkybuffer = xi->data;
    PlanarToChunkyAsm(&p2c);
    free_bitmap(bm);
  }else{
    struct BitMap *bm=(struct BitMap *)drawable;
    int depth=bm->Depth,i;
    UBYTE *Line=malloc(((width+16)>>4)<<4);
    if(!Line) X11resource_exit(IMAGES5);
    X11testback(width,height,depth);
    WaitTOF();
    BltBitMapRastPort(bm,x,y,&backrp,0,0,width,height,0xC0);
    WaitBlit();
    free_bitmap(temprp.BitMap);
    temprp.BitMap=alloc_bitmap(width+16,1,8,BMF_CLEAR);
    xi=XCreateImage(display,NULL,depth,ZPixmap,0,0,width,height,8,0);
    xi->data=malloc(width*height+16);
    if(!xi->data)  X11resource_exit(IMAGES6);
    for(i=0;i<height;i++){
      ReadPixelLine8(&backrp,(unsigned long)0,(unsigned long)i,(unsigned long)width,(UBYTE*)Line,&temprp);
      memcpy((UBYTE*)(xi->data+i*width),Line,width);
    }
    free(Line);
  }
  return(xi);
*/
}

XImage *XGetImage(display, drawable, src_x, src_y, width, height,
		  plane_mask, format)
     Display *display;
     Drawable drawable;
     int src_x, src_y;
     unsigned int width, height;
     unsigned long plane_mask;
     int format;
{
  XImage *xi;
  struct Window *destwin;
  struct BitMap *destBM;
  int x,y;

#ifdef DEBUGXEMUL_ENTRY
  printf("XGetImage\n");
#endif
#ifndef NO020
  if(drawable!=prevwin) if(!(drp=setup_win(drawable))) return NULL;

  src_x+=X_relx;
  src_y+=X_rely;
  if(X11Drawables[drawable]==X11WINDOW){
    destwin=X11DrawablesWindows[X11DrawablesMap[drawable]];
    if(!destwin) return 0;
    destBM=destwin->RPort->BitMap;
    src_x+=destwin->LeftEdge;
    src_y+=destwin->TopEdge;
  }else if(X11Drawables[drawable]==X11BITMAP){
    destBM=X11DrawablesBitmaps[X11DrawablesMap[drawable]].pBitMap;
  }else if(X11Drawables[drawable]==X11MUI){
    Object *obj=X11DrawablesMUI[X11DrawablesMap[drawable]];
    destBM=_window(obj)->RPort->BitMap;
    destwin=_window(obj);
  }
  if(format==XYPixmap){ /* one plane pixmap */
    struct BitMap *bm=alloc_bitmap(width,height,1,BMF_CLEAR);
    xi=XCreateImage(display,NULL,1,XYPixmap,0,0,width,height,0,bm->BytesPerRow);
    xi->data=malloc(bm->BytesPerRow*bm->Rows);
    if(!xi->data)  X11resource_exit(IMAGES7);
    xi->bitmap_bit_order=MSBFirst;
    BltBitMap(destBM,src_x,src_y,bm,0,0,width,height,0xC0,(UBYTE)plane_mask,NULL);
    WaitBlit();
    xi->bytes_per_line=bm->BytesPerRow;
    memcpy(xi->data,bm->Planes[0],bm->BytesPerRow*bm->Rows);
    free_bitmap(bm);
  }else{
    int depth=destBM->Depth,i;
    char *data2;
    X11testback(width,height,depth);
    if(backrp.BitMap) free_bitmap(backrp.BitMap);
    backrp.BitMap=destBM;
/*
    BltBitMapRastPort(destBM,src_x,src_y,&backrp,0,0,width,height,0xC0);
    WaitBlit();
*/
    p2c.bmap=backrp.BitMap;
    depth=p2c.bmap->Depth;
    xi=XCreateImage(display,NULL,depth,ZPixmap,0,0,width,height,0,destBM->BytesPerRow);
    data2=malloc(width*height+16);
    xi->data=calloc(height*xi->bytes_per_line+16,1);
    if(!data2||!xi->data)  X11resource_exit(IMAGES8);
    p2c.startX = src_x; p2c.startY = src_y;
    p2c.width = width; p2c.height = height;
    p2c.chunkybuffer = data2;
    PlanarToChunkyAsm(&p2c);
    for( y=0; y<height; y++ )
      for( x=0; x<width; x++ )
	XPut_Pixel(xi,x,y,/*ReadPixel(&backrp,src_x+x,src_y+y)*/ data2[y*width+x]);
    if(show) XPutImage(NULL,1,NULL,xi,0,0,0,0,width,height);
    backrp.BitMap=NULL;
    free(data2);
  }
  return(xi);
#else
  return 0;
#endif
}

XImage *XGetSubImage(display, drawable, x, y, width, height,
		     plane_mask, format, dest_image, dest_x, dest_y)
     Display *display;
     Drawable drawable;
     int x, y;
     unsigned int width, height;
     unsigned long plane_mask;
     int format;
     XImage *dest_image;
     int dest_x, dest_y;
{
  int bdpl,i;
  struct Window *destwin;
  struct BitMap *destBM;
#ifdef DEBUGXEMUL
  printf("XGetSubImage %d %d <%d,%d>\n",x,y,width,height);
#endif
#ifndef NO020

  if(X11Drawables[drawable]==X11WINDOW){
    destwin=X11DrawablesWindows[X11DrawablesMap[drawable]];
    if(!destwin) return 0;
    destBM=destwin->RPort->BitMap;
  }else if(X11Drawables[drawable]==X11BITMAP){
    destBM=X11DrawablesBitmaps[X11DrawablesMap[drawable]].pBitMap;
  }
  if(X11Drawables[drawable]==X11WINDOW){
  }else{
    bdpl=(width+7)>>3;
    for(i=0;i<bdpl*height;i++){
      *(dest_image->data+i)=*(destBM->Planes[0]+(i%bdpl)+(int)(i/bdpl)*destBM->BytesPerRow);
    }
    return(dest_image);
  }
#endif
  return(0);
}

UBYTE X11invert(UBYTE n){
  return((UBYTE)(((n&128)>>7)+((n&64)>>5)+((n&32)>>3)+((n&16)>>1)+((n&8)<<1)+((n&4)<<3)+((n&2)<<5)+((n&1)<<7)));
}

Pixmap XCreateBitmapFromData(display, drawable, data,
			     width, height)
     Display *display;
     Drawable drawable;
     char *data;
     unsigned int width, height;
{/*   File 'xmgr.o'*/
  Pixmap pm;
  int bytes,i,bpl,bdpl;
  struct BitMap *bm;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreateBitmapFromData (%d,%d)\n",width,height);
#endif
  pm=XCreatePixmap(display,drawable,width,height,1);
  bm=X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
  bdpl=(width+7)>>3;
  bytes=bdpl*height;
  bpl=((width+15)>>4)<<1;
  for(i=0;i<bytes;i++){
    *(bm->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl)=(byte)X11invert(data[i]);
  }
#ifdef DEBUG
  if(show) showbitmap(bm,width,height,0);
#endif
  return(pm);
}

XCopyArea(display, src, dest, gc, src_x, src_y, width,
	  height,  dest_x, dest_y)
     Display *display;
     Drawable src, dest;
     GC gc;
     int src_x, src_y;
     unsigned int width, height;
     int dest_x, dest_y;
{
  struct BitMap *from; /*=(struct BitMap*)src;*/
  struct BitMap *to; /*=(struct BitMap*)dest;*/
  struct Window *fromwindow;
  struct Window *towindow;
  extern struct RastPort drawrp;
  int blitop=0xc0 /*(ABC|ABNC|ANBC)*/;
  int srcdrawable=X11Drawables[src],destdrawable=X11Drawables[dest];
#ifdef DEBUGXEMUL_ENTRY
  printf("XCopyArea src %d %d dest %d %d size %dx%d\n",src_x,src_y,dest_x,dest_y,width,height);
#endif

  if(!gc) gc=amiga_gc;
/*
  if(gc->values.function==GXxor){
    blitop=0x3c;
  }*/

  switch(srcdrawable){
  case X11WINDOW:
  case X11SUBWINDOW: {
    struct Window *w=Agetwin(src);
    prevwin=-1;
    if(!w) return 0; /*srcdrawable=X11BITMAP;*/
    from=w->RPort->BitMap;
    fromwindow=w;
    srcdrawable=X11WINDOW;
    src_x=src_x+X_relx;
    src_y=src_y+X_rely; 
  } 
    break;
  case X11BITMAP:
    from=X11DrawablesBitmaps[X11DrawablesMap[src]].pBitMap;
    break;
  case X11MUI: {
    Object *obj=X11DrawablesMUI[X11DrawablesMap[src]];
    from=_window(obj)->RPort->BitMap;
    src_x=src_x+_mleft(obj);
    src_y=src_y+_mtop(obj);
  }
    break;
  }
  switch(destdrawable){
  case X11WINDOW:
  case X11SUBWINDOW: {
    struct Window *w=Agetwin(dest);
    prevwin=-1;
    if(!w) return 0; /* destdrawable=X11BITMAP; */
    to=w->RPort->BitMap;
    destdrawable=X11WINDOW;
    towindow=w;
    dest_x=dest_x+X_relx;
    dest_y=dest_y+X_rely;
  }
    break;
  case X11BITMAP:
    to=X11DrawablesBitmaps[X11DrawablesMap[dest]].pBitMap;
    X_relx=0;
    X_rely=0;
    X_width=X11DrawablesBitmaps[X11DrawablesMap[dest]].width;
    X_height=X11DrawablesBitmaps[X11DrawablesMap[dest]].height;
    break;
  case X11MUI: {
    Object *obj=X11DrawablesMUI[X11DrawablesMap[dest]];
    to=_window(obj)->RPort->BitMap;
    towindow=_window(obj);
    destdrawable=X11WINDOW;
    dest_x=dest_x+_mleft(obj);
    dest_y=dest_y+_mtop(obj);
    X_relx=_left(obj);
    X_rely=_top(obj);
    X_width=_mwidth(obj);
    X_height=_mheight(obj);
  }
    break;
  }

  if( dest_x+width>X_width+X_relx){
    width=X_width+X_relx-dest_x;
  }
  if( dest_y+height>X_height+X_rely){
    height=X_height+X_rely-dest_y;
  }
  if( dest_y<X_rely ) {
    height-=X_rely-dest_y; dest_y=X_rely; src_y+=X_rely;
  }
  if( dest_x<X_relx ) {
    width-=X_relx-dest_x; dest_x=X_relx; src_x+=X_relx; 
  }
  if(from->Depth!=to->Depth && gc->values.background!=0){
/*
    int oldbg=X11DrawablesBackground[dest];
*/
    X11testback(width,height,to->Depth);
    SetRast(&backrp,gc->values.background);
    
/*
    X11DrawablesBackground[dest]=gc->values.background;
    XClearArea(display,dest,dest_x-X_relx,dest_y-X_rely,width,height,0);
    X11DrawablesBackground[dest]=oldbg;
*/

  }

  if(destdrawable==X11WINDOW){
    if(from->Depth!=to->Depth && gc->values.background!=0){
      SetAPen(&backrp,gc->values.foreground);
      SetBPen(&backrp,gc->values.background);
      if(gc->values.function==GXxor) SetDrMd(&backrp,COMPLEMENT);
      else SetDrMd(&backrp,JAM1);
    } else {
      SetAPen(towindow->RPort,gc->values.foreground);
      SetBPen(towindow->RPort,gc->values.background);
      if(gc->values.function==GXxor) SetDrMd(towindow->RPort,COMPLEMENT);
      else SetDrMd(towindow->RPort,JAM1);
      prevgc=(GC)-1;
    }
  } else if(destdrawable==X11BITMAP){
    drawrp.BitMap=(struct BitMap *)to;
    SetAPen(&drawrp,gc->values.foreground);
    SetBPen(&drawrp,gc->values.background);
    if(gc->values.function==GXxor) SetDrMd(&drawrp,COMPLEMENT);
    else SetDrMd(&drawrp,JAM1);
    prevgc=(GC)-1;
  }

#ifdef DEBUGXEMUL
  printf("from bitmap (%dx%d) %d\n",from->BytesPerRow*8,from->Rows,from->Depth);
  printf("to bitmap (%dx%d) %d\n",to->BytesPerRow*8,to->Rows,to->Depth);
#endif
  if(srcdrawable!=X11WINDOW&&destdrawable!=X11WINDOW){
    if(!CG.bNeedClip){
      int bt=dest_y,bl=dest_x;
      WaitBlit();
      if(from->Depth==1 && gc->values.background!=0){
	if(gc->values.function!=GXxor){
	  BltPattern(&backrp,from->Planes[0],0,0,width-1,height-1,from->BytesPerRow);
	} else 
	  {
	    BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,width,height);
	  }
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,towindow->RPort,bl,bt,width,height,0xc0);
      } else 
	{
	  BltBitMap(from,src_x,src_y,to,dest_x,dest_y,width,height,/*blitop*/ 0xc0,0xFF,NULL);
	}
    }
    else{
      int bt=dest_y,bl=dest_x;
      WaitBlit();
      if(from->Depth==1 && gc->values.background!=0){
	if(gc->values.function!=GXxor){
	  BltPattern(&backrp,CG.pClipBM->Planes[0],0,0,width-1,height-1,
		     CG.pClipBM->BytesPerRow);
	} else 
	  {
	    BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,width,height);
	  }
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,towindow->RPort,bl,bt,width,height,0xc0);
      } 
      else
	BltMaskBitMapRastPort(from,src_x,src_y,&drawrp,dest_x,dest_y,width,height,blitop,
			      CG.pClipBM->Planes[0]);
    }
  }else if(srcdrawable!=X11WINDOW&&destdrawable==X11WINDOW) {
    int bt=dest_y,bl=dest_x;
    WaitBlit();
    if(!CG.bNeedClip){
      if(from->Depth==1 && gc->values.background!=0){
	if(gc->values.function!=GXxor){
	  BltPattern(&backrp,from->Planes[0],0,0,width-1,height-1,
		     from->BytesPerRow);
	}else 
	  {
	    BltTemplate(from->Planes[0],0,from->BytesPerRow,&backrp,0,0,width,height);
	  }
	WaitBlit();
	BltBitMapRastPort(backrp.BitMap,0,0,towindow->RPort,bl,bt,width,height,0xc0);
      } else 
	{
	  BltBitMapRastPort(from,src_x,src_y,towindow->RPort,bl,bt,width,height,0xc0);
	}
    }
    else{
      if(gc->values.function!=GXxor){
	WaitBlit();
	BltPattern(towindow->RPort,CG.pClipBM->Planes[0],bl,bt,bl+width-1,bt+height-1,
		   CG.pClipBM->BytesPerRow);
      }
      WaitBlit();
      BltTemplate(from->Planes[0],0,from->BytesPerRow,towindow->RPort,bl,bt,width,height);
      /*      BltMaskBitMapRastPort(from,src_x,src_y,towindow->RPort,bl,bt,width,height,blitop,
			    CG.pClipBM->Planes[0]);*/
    }
  }else if(srcdrawable==X11WINDOW&&destdrawable!=X11WINDOW){
    int bt=fromwindow->BorderTop /*+fromwindow->TopEdge*/,
    bl=fromwindow->BorderLeft /*+fromwindow->LeftEdge*/;
    WaitBlit();
    BltBitMap(fromwindow->RPort->BitMap,src_x+bl,src_y+bt,to,dest_x,dest_y,width,height,0xC0,
	      0xFF,NULL);
  }else if(X11Drawables[src]==X11WINDOW&&X11Drawables[dest]==X11WINDOW){
    WaitBlit();
    BltBitMapRastPort(from,src_x+fromwindow->LeftEdge,src_y+fromwindow->TopEdge,towindow->RPort,dest_x,dest_y,width,height,0xc0);
  }
  return(0);
}

XCopyPlane(display, src, dest, gc, src_x, src_y, width,
	   height, dest_x, dest_y, plane)
     Display *display;
     Drawable src, dest;
     GC gc;
     int src_x, src_y;
     unsigned int width, height;
     int dest_x, dest_y;
     unsigned long plane;
{
  struct BitMap *from;
  PLANEPTR oldplanes[8];
  int olddepth;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCopyPlane\n");
#endif
  switch(X11Drawables[src]){
  case X11WINDOW:
  case X11SUBWINDOW: {
    struct Window *w=Agetwin(src);
    prevwin=-1;
    from=/*w->RPort*/ drp->BitMap;
    if(!w) return 0;

    src_x=src_x+X_relx;
    src_y=src_y+X_rely; 
  } 
    break;
  case X11BITMAP: {
    from=X11DrawablesBitmaps[X11DrawablesMap[src]].pBitMap;
  } 
    break;
  }

  if(plane){
    int i;
    for(i=0;i<8;i++){
      oldplanes[i]=from->Planes[i];
      from->Planes[i]=0;
    }
    from->Planes[0]=oldplanes[plane-1];
    olddepth=from->Depth;
    from->Depth=1;
/*
    if(dest==rootwin){
      SetWriteMask(rootwin->RPort,plane);
      SetAPen(rootwin->RPort,0);
      RectFill(rootwin->RPort,dest_x,dest_y,dest_x+width,dest_y+height);
      SetWriteMask(rootwin->RPort,255);
      prevgc=(GC)-1;
    }else{
      if(((int)dest>0&&(int)dest<CHILDRENAVAIL)){
	int x,y;
	Window w=Agetwin(dest);
	prevwin=-1;
	if(!w) return 0;
	x=dest_x;
	y=dest_y;

	SetAPen(/*w->RPort*/ drp,0);
	RectFill(/*w->RPort*/ drp,x,y,x+width,y+height);
	prevgc=NULL;
	prevwin=-1;
      }else{
	struct BitMap *to=(struct BitMap*)dest;
	memset(to->Planes[0],0,to->BytesPerRow*to->Rows);
      }
   }
 */
  }
  XCopyArea(display,src,dest,gc,src_x,src_y,width,height,dest_x,dest_y);
  if(plane){
    int i;
    for(i=0;i<8;i++)
      from->Planes[i]=oldplanes[i];
    from->Depth=olddepth;
  }
  return(0);
}


Pixmap X11prevtile=NULL;
int X11CurrentTile=0;
int X11PrevTile=0;

void X11Setup_Tile(GC gc, int tile){
  int i,j;
  int FillOp=gc->values.fill_style &0xff00;
  if( X11PrevTile==tile ) return;
  X11PrevTile=tile;
  if(tile && FillOp==NORMAL_FILL){
    int width,height;
    struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[tile]].pBitMap;

    if(Xcurrent_tile!=NULL){
      List_RemoveEntry(pMemoryList,(void*)Xcurrent_tile);
      Xcurrent_tile=NULL;
    }
    width=X11DrawablesBitmaps[X11DrawablesMap[tile]].width;
    height=X11DrawablesBitmaps[X11DrawablesMap[tile]].height;
    if(width>16){
      width=16;
      if(height>16) height=16;
    } else if(width<8) width=8;

    Xcurrent_tile=(WORD *) malloc((width>>3)*height);
    if(!Xcurrent_tile)  X11resource_exit(IMAGES10);
    List_AddEntry(pMemoryList,(void*)Xcurrent_tile);
    /*AllocMem(bm->BytesPerRow*bm->Rows,MEMF_CHIP);*/
    for(j=0;j<height;j++)
      for(i=0;i<(width>>3);i++)
	*((byte*)Xcurrent_tile+i+j*(width>>3))=(byte)*(bm->Planes[0]+i+j*bm->BytesPerRow);
    Xhas_tile=1;
    {
      double d=log(height)/log(2);
      Xtile_size=(int)ceil(d);
    }
    X11prevtile=tile;
  }
}

XSetTile(display, gc, tile)
     Display *display;
     GC gc;
     Pixmap tile;
{/*                File 'xvlib.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetTile\n");
#endif
  if(X11prevtile==tile) return;
  Xhas_tile=0;
  if(gc->values.tile!=tile && gc->values.tile!=0){
    XFreePixmap(NULL,gc->values.tile);
  }
  X11DrawablesBitmaps[X11DrawablesMap[tile]].bTileStipple=1;
  gc->values.tile=tile;
  prevgc=(GC)-1;
  return(0);
}

XSetStipple(display, gc, stipple)
     Display *display;
     GC gc;
     Pixmap stipple;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetStipple\n");
#endif
  if(gc->values.tile!=stipple && gc->values.tile!=0){
    XFreePixmap(NULL,gc->values.tile);
  }
  gc->values.tile=stipple;
  X11DrawablesBitmaps[X11DrawablesMap[stipple]].bTileStipple=1;
  if (X11DrawablesBitmaps[X11DrawablesMap[stipple]].width>16){
    gc->values.fill_style=INTERNAL_FILL|gc->values.fill_style;
  } else
    gc->values.fill_style=NORMAL_FILL|gc->values.fill_style;
  prevgc=(GC)-1;
  return(0);
}

Pixmap XCreatePixmapFromBitmapData(display, drawable, data,
				   width, height, fg, bg, depth)
     Display *display;
     Drawable drawable;
     char *data;
     unsigned int width, height;
     unsigned long fg, bg;
     unsigned int depth;
{
  Pixmap pm;
#if 0
  Pixmap pm2;
  struct BitMap *bm;
  struct BitMap *bitmap;
  int x,y,bpl;
#endif
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreatePixmapFromBitmapData [%d,%d,%d]\n",width,height,depth);
#endif
#if 0
  pm=XCreatePixmap(display,drawable,width,height,depth);
  bm=X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
  pm2=XCreateBitmapFromData(display,drawable,data,width,height);
  bitmap=X11DrawablesBitmaps[X11DrawablesMap[pm2]].pBitMap;
/*
  bitmap=alloc_bitmap(width,height,1,BMF_CLEAR);

  bpl=(width+7)>>3;
  for( y=0; y<height; y++ )
    for( x=0; x<bpl; x++ )
      *(bitmap->Planes[0]+y*bitmap->BytesPerRow+x)=X11invert(*(data+y*bpl+x));
*/
  drawrp.BitMap=bm;
  SetAPen(&drawrp,X11DrawablesBackground[drawable]);
  RectFill(&drawrp,0,0,width-1,height-1);
  prevgc=(GC)-1;
  SetDrMd(&drawrp,JAM1);
  SetAPen(&drawrp,0);

  BltTemplate(bitmap->Planes[0],0,bitmap->BytesPerRow,&drawrp,0,0,width,height);
  SetAPen(&drawrp,1);
  WaitBlit();
  BltPattern(&drawrp,bitmap->Planes[0],0,0,width,height,bm->BytesPerRow);
  XFreePixmap(NULL,pm2);
/*
  free_bitmap(bitmap);
*/
#else
  if(depth==8){
    pm=XCreatePixmap(display,drawable,width,height,depth);
    memcpy(((struct BitMap*)pm)->Planes[0],data,((struct BitMap*)pm)->BytesPerRow*((struct BitMap*)pm)->Rows);
  }
  else
    return(XCreateBitmapFromData(display,drawable,data,width,height));
#endif
  return(pm);
}

XFreePixmap(display, pixmap)
     Display *display;
     Pixmap pixmap;
{
  struct BitMap *bitmap=X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;
#ifdef DEBUGXEMUL_ENTRY
  printf("XFreePixmap\n");
#endif
  if(X11DrawablesBitmaps[X11DrawablesMap[pixmap]].bTileStipple) return;

  free_bitmap(bitmap);
  X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap=NULL;
  return(0);
}

int XPixmapDepth(Display *display,Pixmap pixmap){
  struct BitMap *bm;
  if(X11Drawables[pixmap]!=X11BITMAP) return 0;
  bm=X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;
  return(bm->Depth);
}

Pixmap XCreatePixmap(display, drawable, width, height, depth)
     Display *display;
     Drawable drawable;
     unsigned int width, height;
     unsigned int depth;
{
  struct BitMap * bitmap;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreatePixmap (w %d,h %d,d %d)\n",width,height,depth);
#endif
  bitmap=alloc_bitmap(width,height,depth,BMF_CLEAR);
  if(!bitmap) X11resource_exit(IMAGES12);
  return((Pixmap)X11NewBitmap(bitmap,width,height,depth));
}

int XReadBitmapFile(display, d, filename, width_return,
		    height_return, bitmap_return, x_hot_return, y_hot_return)
     Display *display;
     Drawable d;
     char *filename;
     unsigned int *width_return, *height_return;
     Pixmap *bitmap_return;
     int *x_hot_return, *y_hot_return;
{
  char line[256],line2[256];
  FILE *fp;
  struct BitMap *bm;
  int v,i,bytes,c,/*swap=0,*/perline,base;
#ifdef DEBUGXEMUL_ENTRY
  printf("XReadBitmapFile [%s]\n",filename);
#endif
  fp=fopen(filename,"r+");
  if(!fp) return(1);
  fgets(line,256,fp); sscanf(line,"%s %s %d",line2,line2,width_return);
  fgets(line,256,fp); sscanf(line,"%s %s %d",line2,line2,height_return);
  fgets(line,256,fp);
  if(line[0]=='#'){
    sscanf(line,"%s %s %d",line2,line2,x_hot_return);
    fgets(line,256,fp);
    sscanf(line,"%s %s %d",line2,line2,y_hot_return);
    fgets(line,256,fp);
  }
  *bitmap_return=XCreatePixmap(display,d,*width_return,*height_return,1);
  perline=((*width_return)+7)>>3;
  bytes=perline*(*height_return);
/*  if(*width_return>8) swap=1;*/
  if(perline&1) base=perline+1;
  else base=perline;
  bm=X11DrawablesBitmaps[X11DrawablesMap[*bitmap_return]].pBitMap;
  
  for(i=0;i<bytes;i++){
    UBYTE *b=bm->Planes[0];
    fscanf(fp,"%x%c",&v,&c);
    *(b+(int)(i/perline)*base+i%perline)=X11invert((UBYTE)v);
  }
  *width_return=(((*width_return)+7)>>3)<<3;
  fclose(fp);
  return(0);
}

int XWriteBitmapFile(display, filename, bitmap, width,
		     height, x_hot, y_hot)
     Display *display;
     char *filename;
     Pixmap bitmap;
     unsigned int width, height;
     int x_hot, y_hot;
{/*        File 'f_wrxbm.o'*/
  char outname[40];
  FILE *fptr;
  int i,j,k=0;
  struct BitMap *bm=X11DrawablesBitmaps[X11DrawablesMap[bitmap]].pBitMap;
  unsigned char *outdata=bm->Planes[0];
#ifdef DEBUGXEMUL_ENTRY
  printf("XWriteBitmapFile\n");
#endif
  if(strchr(filename,'/')!=NULL)
    strcpy(outname,strrchr(filename,'/')+1);
  else
    if(strchr(filename,':')!=NULL)
      strcpy(outname,strrchr(filename,':')+1);
    else
      strcpy(outname,filename);
  if(strchr(outname,'.')!=NULL) *strchr(outname,'.')=0;
  fptr=fopen(filename,"w+");
  if(!fptr) return(BitmapOpenFailed);
  fprintf(fptr,"#define %s_width %d\n",outname,width);
  fprintf(fptr,"#define %s_height %d\n",outname,height);
  fprintf(fptr,"#define %s_x_hot %d\n",outname,x_hot);
  fprintf(fptr,"#define %s_y_hot %d\n",outname,y_hot);
  fprintf(fptr,"static char %s_bits[] = {\n",outname);
  for(i=0;i<height;i++){
    for(j=0;j<(width+7)>>3;j++){
      unsigned char c=X11invert((UBYTE)(*(outdata+i*bm->BytesPerRow+j)));
      fprintf(fptr,"0x%02x, ",c);
      k++;
      if(k==12){ fprintf(fptr,"\n"); k=0;}
    }
  }
  fprintf(fptr,"};");
  fclose(fptr);
  return(BitmapSuccess);
}

#ifdef DEBUG
void showbitmap(struct BitMap *bm,int width,int height,int pos){
  SetAPen(&(wb->RastPort),1);
  SetDrMd(&(wb->RastPort),JAM1);
  RectFill(&(wb->RastPort),20,22+200*pos,40+width,40+200*pos+height);
  BltBitMapRastPort(bm,0,0,&(wb->RastPort),22,30+200*pos,width,height,0xC0);
}

#endif
_XInitImageFuncPtrs(){/*     File 'image_f_io.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING:_XInitImageFuncPtrs\n");
#endif
  return(0);
}
