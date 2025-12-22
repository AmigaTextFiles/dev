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
     pixmaps
   PURPOSE
     add pixmap handling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 27, 1994: Created.
***/

#include <amiga.h>
#include <stdio.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#include "x11display.h"
#include "images.h"

#ifdef DEBUGXEMUL_ENTRY
extern int bInformImages; /* ignore outputting information about images */
extern int bSkipImageWrite;
#endif

/*******************************************************************************************/

/********************************************************************************
Name     : XCreatePixmap()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.  May be an InputOnly window.

     width
     height
               Specify the width and height in pixels of the  pixmap.   The
               values must be nonzero.

     depth     Specifies the depth  of  the  pixmap.   The  depth  must  be
               supported  by  the  screen  of the specified drawable.  (Use
               XListDepths() if in doubt.)

Output   : 
Function : create a pixmap.
********************************************************************************/

Pixmap
XCreatePixmap( Display* display,
	       Drawable drawable,
	       unsigned int width,
	       unsigned int height,
	       unsigned int depth )
{
  struct BitMap * bitmap;
  Pixmap vPixmap;

  assert(X11DrawablesBackground);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEPIXMAP , bInformImages );
#endif
  bitmap = alloc_bitmap( width, height, depth, BMF_CLEAR, DG.wb->RastPort.BitMap );
  if( DG.XAllocFailed )
    return NULL;

  vPixmap = (Pixmap)X11NewBitmap(bitmap,width,height,depth);
  if( drawable==DG.X11Screen[0].root || drawable==ROOTID ){
    drawable = 0;
  }
  X11DrawablesBackground[vPixmap] = X11DrawablesBackground[drawable];
  return(vPixmap);
}

/********************************************************************************
Name     : XFreePixmap()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     pixmap    Specifies the pixmap whose ID should be freed.

Output   : 
Function : free a pixmap ID.
********************************************************************************/

XFreePixmap( Display* display, Pixmap pixmap )
{
  struct BitMap *bitmap = X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XFREEPIXMAP, bInformImages );
#endif

  assert( bitmap->Depth>0 );

  if( X11DrawablesBitmaps[X11DrawablesMap[pixmap]].bTileStipple ){
    X11DrawablesBitmaps[X11DrawablesMap[pixmap]].bTileStipple |= BITMAP_DELETED;
    return;
  }

  if( DG.oldX11FillSource == pixmap )
    DG.oldX11FillSource = -1;

  X11FreeBitmap( pixmap );
  free_bitmap( bitmap );
  X11DrawablesBitmaps[X11DrawablesMap[pixmap]].pBitMap = NULL;

  return(0);
}

/********************************************************************************
Name     : XCreatePixmapFromBitmapData()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to  an  Display  structure,  returned
               from XOpenDisplay().

     drawable  Specifies a drawable ID which  indicates  which  screen  the
               pixmap is to be used on.

     data      Specifies the data in bitmap format.

     width
     height
               Specify the width and height in  pixels  of  the  pixmap  to
               create.

     fg
     bg
               Specify the foreground and background pixel values to use.

     depth     Specifies the depth of the pixmap.  Must  be  valid  on  the
               screen specified by drawable.

Output   : 
Function : create a pixmap with depth from bitmap data.
********************************************************************************/

Pixmap
XCreatePixmapFromBitmapData( Display* display,
			     Drawable drawable,
			     char* data,
			     unsigned int width,
			     unsigned int height,
			     unsigned long fg,
			     unsigned long bg,
			     unsigned int depth )
{
  Pixmap pm;
#if 1
  Pixmap pm2;
  struct BitMap *bm;
  struct BitMap *bitmap;
  int clear = 1;
/*  int x,y,bpl;*/
#endif

  assert(X11DrawablesBackground);

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEPIXMAPFROMBITMAPDATA , bInformImages );
#endif
#if 1
  pm = XCreatePixmap(display,drawable,width,height,depth);
  bm = X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
  pm2 = XCreateBitmapFromData(display,drawable,data,width,height);
  bitmap = X11DrawablesBitmaps[X11DrawablesMap[pm2]].pBitMap;
/*
  bitmap = alloc_bitmap( width, height, 1, BMF_CLEAR, DG.wb->RastPort.BitMap );
  if( DG.XAllocFailed ) return NULL;

  bpl = (width+7)>>3;
  for( y=0; y<height; y++ )
    for( x=0; x<bpl; x++ )
      *(bitmap->Planes[0]+y*bitmap->BytesPerRow+x) = X11InvertMap[*(data+y*bpl+x)];
*/
  DG.X11BitmapRP.BitMap = bm;

  vPrevGC=(GC)-1;

  
  if( clear ){
    SetAPen(&DG.X11BitmapRP,bg % (1<<depth) /*X11DrawablesBackground[drawable]*/);
    RectFill(&DG.X11BitmapRP,0,0,width-1,height-1);
  }
  SetDrMd(&DG.X11BitmapRP,JAM1);
  SetAPen(&DG.X11BitmapRP, fg % (1<<depth));
  SetBPen(&DG.X11BitmapRP, bg % (1<<depth));

#if 0
  BltTemplate(bitmap->Planes[0],0,bitmap->BytesPerRow,&DG.X11BitmapRP,0,0,width,height);
  SetAPen(&DG.X11BitmapRP,1);
#endif
  WaitBlit();
  BltPattern(&DG.X11BitmapRP,bitmap->Planes[0],0,0,width-1,height-1,bitmap->BytesPerRow);
  WaitBlit();
#if (DEBUG!=0)
  if(show) showbitmap(DG.X11BitmapRP.BitMap,width,height,0,2);
#endif
  XFreePixmap(NULL,pm2);
/*
  free_bitmap(bitmap);
*/
#else
  if( depth==8 ){
    struct BitMap *bm;

    pm = XCreatePixmap(display,drawable,width,height,depth);
    bm = X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
    memcpy(bm->Planes[0],data,bm->BytesPerRow*bm->Rows);
  } else
    return(XCreateBitmapFromData(display,drawable,data,width,height));
#endif

  return(pm);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

/********************************************************************************
Name     : XCreateBitmapFromData()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies a  drawable.   This  determines  which  screen  to
               create the bitmap on.

     data      Specifies the bitmap data, in X11 bitmap file format.

     width
     height
               Specify the dimensions in pixels of the created bitmap.   If
               smaller  than  the bitmap data, the upper-left corner of the
               data is used.

Output   : 
Function : create a bitmap from X11 bitmap format data.
********************************************************************************/

UBYTE
X11invert2( UBYTE n )
{
  return((UBYTE)(((n&128)>>7)+((n&64)>>5)+((n&32)>>3)+((n&16)>>1)+((n&8)<<1)+((n&4)<<3)+((n&2)<<5)+((n&1)<<7)));
}


Pixmap
XCreateBitmapFromData( Display* display,
		       Drawable drawable,
		       char* data,
		       unsigned int width,
		       unsigned int height )
{
  Pixmap pm;
  int bytes,i,bpl,bdpl;
  struct BitMap *bm;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATEBITMAPFROMDATA , bInformImages );
#endif
  pm = XCreatePixmap(display,drawable,width,height,1);
  bm = X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;

  assert( bm->Depth>0 );

  bdpl = (width+7)>>3;
  bytes= bdpl*height;
  bpl = ((width+15)>>4)<<1;
  for( i=0; i<bytes; i++ ){
    *(bm->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl) = (int)X11InvertMap[(int)data[i]];
    assert( X11InvertMap[(int)data[i]] == X11invert2(data[i]) );
    assert( X11InvertMap[*(bm->Planes[0]+(i%bdpl)+(int)(i/bdpl)*bpl)] == (int)data[i] );
  }
#if (DEBUG!=0)
  if(show) showbitmap(bm,width,height,0,2);
#endif

  return(pm);
}

/********************************************************************************
Name     : XReadBitmapFile()
Author   : Terje Pedersen
Input    : 
     display        Specifies a connection to an X  server;  returned  from
                    XOpenDisplay().

     d              Specifies the drawable.

     filename       Specifies the filename  to  use.   The  format  of  the
                    filename is operating system specific.

     width_return
     height_return
                    Return the dimensions in pixels of the bitmap  that  is
                    read.

     bitmap_return  Returns the pixmap resource ID that is created.

     x_hot_return
     y_hot_return
                    Return the hotspot coordinates in the file (or  - 1,  -
                    1 if none present).

Output   : 
Function : read a bitmap from disk.
********************************************************************************/

int
XReadBitmapFile( Display* display,
		 Drawable d,
		 char* filename,
		 unsigned int* width_return,
		 unsigned int* height_return,
		 Pixmap* bitmap_return,
		 int* x_hot_return,
		 int* y_hot_return )
{
  char line[256],line2[256];
  FILE *fp;
  struct BitMap *bm;
  int v,i,bytes,c,/*swap=0,*/perline,base;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XREADBITMAPFILE, bInformImages );
#endif
  fp = fopen(filename,"r+");
  if( !fp )
    return(1);
  fgets(line,256,fp); sscanf(line,"%s %s %d",line2,line2,width_return);
  fgets(line,256,fp); sscanf(line,"%s %s %d",line2,line2,height_return);
  fgets(line,256,fp);
  if( line[0]=='#' ){
    sscanf(line,"%s %s %d",line2,line2,x_hot_return);
    fgets(line,256,fp);
    sscanf(line,"%s %s %d",line2,line2,y_hot_return);
    fgets(line,256,fp);
  }
  *bitmap_return = XCreatePixmap(display,d,*width_return,*height_return,1);
  perline = ((*width_return)+7)>>3;
  bytes = perline*(*height_return);
/*  if(*width_return>8) swap=1;*/
  if( perline&1 )
    base = perline+1;
  else
    base = perline;
  bm = X11DrawablesBitmaps[X11DrawablesMap[*bitmap_return]].pBitMap;
  
  for( i=0; i<bytes; i++ ){
    UBYTE *b = bm->Planes[0];

    fscanf(fp,"%x%c",&v,&c);
    *(b+(int)(i/perline)*base+i%perline) = X11InvertMap[(UBYTE)v];
  }
  *width_return = (((*width_return)+7)>>3)<<3;
  fclose(fp);

  return(0);
}

/********************************************************************************
Name     : XWriteBitmapFile()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     filename  Specifies the filename to use.  The format of  the  filename
               is operating system specific.

     bitmap    Specifies the bitmap to be written.

     width
     height
               Specify the width and height in pixels of the bitmap  to  be
               written.

     x_hot
     y_hot
               Specify where to place the hotspot coordinates (or  - 1, - 1
               if none present) in the file.

Output   : 
Function : write a bitmap to a file.
********************************************************************************/

int
XWriteBitmapFile( Display* display,
		  char* filename,
		  Pixmap bitmap,
		  unsigned int width,
		  unsigned int height,
		  int x_hot,
		  int y_hot )
{
  char outname[40];
  FILE *fptr;
  int i,j,k=0;
  struct BitMap *bm = X11DrawablesBitmaps[X11DrawablesMap[bitmap]].pBitMap;
  unsigned char *outdata = bm->Planes[0];

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XWRITEBITMAPFILE, bInformImages );
#endif
  if( strchr(filename,'/') )
    strcpy(outname,strrchr(filename,'/')+1);
  else
    if( strchr(filename,':') )
      strcpy(outname,strrchr(filename,':')+1);
    else
      strcpy(outname,filename);
  if( strchr(outname,'.') )
    *strchr(outname,'.')=0;
  fptr = fopen(filename,"w+");
  if( !fptr )
    return(BitmapOpenFailed);
  fprintf(fptr,"#define %s_width %d\n",outname,width);
  fprintf(fptr,"#define %s_height %d\n",outname,height);
  fprintf(fptr,"#define %s_x_hot %d\n",outname,x_hot);
  fprintf(fptr,"#define %s_y_hot %d\n",outname,y_hot);
  fprintf(fptr,"static char %s_bits[] = {\n",outname);
  for( i=0; i<height; i++ ){
    for( j=0; j<(width+7)>>3; j++ ){
      unsigned char c = X11InvertMap[(UBYTE)(*(outdata+i*bm->BytesPerRow+j))];

      fprintf(fptr,"0x%02x, ",c);
      k++;
      if( k==12 ){
	fprintf(fptr,"\n");
	k=0;
      }
    }
  }
  fprintf(fptr,"};");
  fclose(fptr);

  return(BitmapSuccess);
}
