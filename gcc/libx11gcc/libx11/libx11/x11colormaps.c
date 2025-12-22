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
     colormaps
   PURPOSE
     add colormap handling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 22, 1994: Created.

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <dos.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#undef memset

#include "x11display.h"
#include "x11colormaps.h"

/********************************************************************************/
/* external */
/********************************************************************************/

/* colormaps */

/********************************************************************************/
/* internal */
/********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
extern int bInformColormaps; /* outputting information about colormaps */
#endif

ULONG AmigaCmap[256*3+2] = {0};
ULONG *BackupCmap = NULL;

int prevcm = -1;
int colorno = 4;

XColor *Backupcolors = NULL;
#if 0
XColor *Maincolors = NULL;
#endif

int lockcol=0,lockhigh = 0;
char *Xallocated = NULL;
short *XCanAllocate = NULL,nGlobalAllocateMax;

int X11prealloced;
int X11initcolor = 1;

/********************************************************************************/
/* functions */
/********************************************************************************/

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11init_cmaps( void )
{
  if ( !X11initcolor )
    return;
  X11initcolor = 0;
  /* memset(AmigaCmap,0,256*3+2); */
  X11prealloced = 0;
  if( DG.vUseWB || DG.vWBapp ){
    int i;

    if( !Xallocated )
      Xallocated = (char*)calloc(1,1<<DG.nDisplayDepth);
    BackupCmap = (ULONG*)malloc(sizeof(ULONG)*(256*3+2));
    Backupcolors  =(XColor*)malloc(256*sizeof(XColor));
/*     Maincolors = (XColor*)malloc(256*sizeof(XColor)); */
    if( !Backupcolors
/*        || !Maincolors */
        || !BackupCmap
        || !Xallocated )
      X11resource_exit(COLORMAPS2);
    XCanAllocate = (short*)calloc(1,256*sizeof(short));
    nGlobalAllocateMax = 0;
    for( i=0; i<256; i++ ){
      int n;

      XCanAllocate[i] = -1;
      if( (n=ObtainPen(DG.Scr->ViewPort.ColorMap,-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1 ){
	XCanAllocate[nGlobalAllocateMax++] = n;
      } 
    }
    for( i=0; i<256; i++ ){
      if( XCanAllocate[i]!=-1 )
	ReleasePen(DG.Scr->ViewPort.ColorMap,XCanAllocate[i]);
    }
/*    nCanAllocatePos=2;*/
  } else {
    Xallocated=(char*)calloc(1,1<<DG.nDisplayDepth);
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11exit_cmaps( void )
{
  int i;

  if ( !Xallocated ){
    free(X11Cmaps);
    return;
  }
  if( DG.vUseWB || DG.vWBapp ){
    swapwbcm(0,NULL);
    for( i=0; i<DG.nDisplayColors; i++ )
      if( Xallocated[i] ) {
	ReleasePen((struct ColorMap*)X11Cmaps[0] /*DG.X11Screen[0].cmap*/,i);
      }
  }
  if( Xallocated )
    free( Xallocated );
  if( XCanAllocate )
    free( XCanAllocate );
  Xallocated = NULL;
  if( BackupCmap )
    free( BackupCmap );
  if( Backupcolors )
    free( Backupcolors );
#if 0
  if( Maincolors )
    free( Maincolors );
#endif
  free( X11Cmaps );
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

#define SCALE8TO32(x) ((x)|((x)<<8)|((x)<<16)|((x)<<24))

void X11updatecmap(void);

void
X11updatecmap( void )
{
  int i;

  if( !Xallocated ){
    X11initcolor=1;
    DG.vUseWB = 1;
    X11init_cmaps();
    X11prealloced = 1;
  }
  if( X11prealloced ){
    AmigaCmap[1]=0; AmigaCmap[2]=0; AmigaCmap[3]=0;
    AmigaCmap[4]=SCALE8TO32(255); AmigaCmap[5]=SCALE8TO32(255); AmigaCmap[6]=SCALE8TO32(255);
    for( i=0; i<(1<<DG.nDisplayDepth); i++ ){
      XColor cdef;

      cdef.pixel=i;
      cdef.red=(unsigned short)AmigaCmap[i*3+1] /*<<8*/;
      cdef.green=(unsigned short)AmigaCmap[i*3+2] /*<<8*/;
      cdef.blue=(unsigned short)AmigaCmap[i*3+3] /*<<8*/;
      XStoreColor(NULL,0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/,&cdef);
    }
  }
}

/********************************************************************************
Name     : XStoreColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XStoreColor( Display* dp,
	     Colormap cm,
	     XColor* cdef )
{
  int r = cdef->red>>8,
      g = cdef->green>>8,
      b = cdef->blue>>8;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSTORECOLOR, bInformColormaps );
#endif
  if( cm!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    X11ColorMap_t* cmap = (X11ColorMap_t*)X11Cmaps[cm];

    assert(cdef->pixel>=0 && cdef->pixel<256);
    cmap->aColorDef[cdef->pixel].red = cdef->red>>8;
    cmap->aColorDef[cdef->pixel].green = cdef->green>>8;
    cmap->aColorDef[cdef->pixel].blue = cdef->blue>>8;
    cmap->aColorDef[cdef->pixel].pixel = cdef->pixel;

    if( cmap->vWindow==-1 )
      return;
    /* else assume the attached window is mapped..may have to be improved though.. */
    cm = 0;
  }
  if( ( DG.vUseWB || DG.vWBapp ) && cdef->pixel>=DG.nDisplayColors )
    return;

  if( !DG.Scr )
    return;
  if( cdef->pixel>=0 && cdef->pixel<256 ){
    if( DG.bUse30 ){
#if 0
      SetRGB32(((struct ColorMap*)cm)->cm_vp /*&Scr->ViewPort*/,
#else
      SetRGB32(X11Cmaps[cm]->cm_vp /*&DG.Scr->ViewPort*/,
#endif
	       (ULONG)cdef->pixel,
	       (ULONG)SCALE8TO32(r),(ULONG)SCALE8TO32(g),(ULONG)SCALE8TO32(b));
    } else
      SetRGB4(&DG.Scr->ViewPort,cdef->pixel,(cdef->red)>>12,(cdef->green)>>12,(cdef->blue)>>12);
  }
}

/********************************************************************************
Name     : XQueryColors()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XQueryColors( Display *display,
	      Colormap colormap,
	      XColor* defs_in_out,
	      int ncolors )
{
  int i;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XQUERYCOLORS, bInformColormaps );
#endif
  if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    for( i=0; i<ncolors; i++ ){
      X11ColorMap_t* cmap = (X11ColorMap_t*)X11Cmaps[colormap];

      defs_in_out[i].pixel = cmap->aColorDef[i].pixel;
      defs_in_out[i].red  = cmap->aColorDef[i].red<<8|cmap->aColorDef[i].red;
      defs_in_out[i].green = cmap->aColorDef[i].green<<8|cmap->aColorDef[i].green;
      defs_in_out[i].blue = cmap->aColorDef[i].blue<<8|cmap->aColorDef[i].blue;

#if (DEBUG!=0)
      if( bInformColormaps )
	printf("returning (not default) %x %x %x for color %d\n",defs_in_out[i].red,defs_in_out[i].green,defs_in_out[i].blue,defs_in_out[i].pixel);
#endif /* DEBUG */
    }

    return(0);
  }
  if( DG.bUse30 ){
    if( DG.Scr )
      GetRGB32(DG.Scr->ViewPort.ColorMap,0L,(ULONG)256,(ULONG*)&AmigaCmap[1]);
    for( i=0; i<ncolors; i++ ){
      int c = defs_in_out[i].pixel;

      defs_in_out[i].red  = AmigaCmap[c*3+1]>>16|AmigaCmap[c*3+1]>>24;
      defs_in_out[i].green = AmigaCmap[c*3+2]>>16|AmigaCmap[c*3+2]>>24;
      defs_in_out[i].blue = AmigaCmap[c*3+3]>>16|AmigaCmap[c*3+3]>>24;
#if(DEBUG!=0)
      if( bInformColormaps )
	printf("returning %x %x %x for color %d\n",defs_in_out[i].red,defs_in_out[i].green,defs_in_out[i].blue,c);
#endif /* DEBUG */

    }
  } else {
    ULONG v=0;

    for( i=0; i<ncolors; i++ ){
      if( DG.Scr )
	v=GetRGB4(DG.Scr->ViewPort.ColorMap,i);
      if( v!=-1 ){
	defs_in_out[i].pixel=i;
	defs_in_out[i].blue=((v&15)<<4)<<8;
	defs_in_out[i].green=(((v&(15<<4))>>4)<<4)<<8;
	defs_in_out[i].red=(((v&(15<<8))>>8)<<4)<<8;
      }
    }
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

void
savewbcm( void )
{
  if( prevcm==1 )
    return;
  if( DG.vUseWB ){
    if( DG.bUse30 ){
      if( DG.Scr )
	GetRGB32(DG.Scr->ViewPort.ColorMap,0L,(ULONG)DG.nDisplayColors,(ULONG*)&(BackupCmap[1]));
      BackupCmap[0] = (DG.nDisplayColors<<16+0);
      BackupCmap[(DG.nDisplayColors-lockhigh)*3+1] = 0;
/*    for( i=0; i<DG.nDisplayColors; i++ )
	printf("saved %d (%d %d %d)\n",i,
	       BackupCmap[i*3+1]&255,BackupCmap[i*3+2]&255,BackupCmap[i*3+3]&255);*/
    } else {
      if( DG.Scr )
	XQueryColors(&DG.X11Display,0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/,(XColor*)Backupcolors,(int)(DG.nDisplayColors-lockhigh));
    }
    DG.bWbSaved=1;
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
swapwbcm( int cm, ULONG *colors )
{
  if( DG.vUseWB ){
    if( prevcm!=cm ){
#if 0
      if( cm==1 ){
	if( DG.bUse30 )
	  LoadRGB32(&DG.Scr->ViewPort,(ULONG*)colors);
	else
	  XStoreColors(&DG.X11Display,0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/,Maincolors,1<<DG.nDisplayDepth);
      } else
#endif
	{
/*	for( i=0; i<DG.nDisplayColors; i++ )
	  printf("restoring %d (%d %d %d)\n",i,
		 BackupCmap[i*3+1]&255,BackupCmap[i*3+2]&255,BackupCmap[i*3+3]&255);*/
	if( DG.bUse30 )
	  LoadRGB32(&DG.Scr->ViewPort,(ULONG *)BackupCmap);
	else
	  XStoreColors(&DG.X11Display,0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/,Backupcolors,DG.nDisplayColors);
      }
      prevcm=cm;
    }
  }
}

/********************************************************************************
Name     : XAllocNamedColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XAllocNamedColor( Display* display,
		  Colormap colormap,
		  char* color_name,
		  XColor* screen_def_return,
		  XColor* exact_def_return )
{
  int ok;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XALLOCNAMEDCOLOR, bInformColormaps );
#endif

  ok = XLookupColor(display,colormap,color_name,exact_def_return,screen_def_return);

  if( ok ){
    screen_def_return->red = exact_def_return->red;
    screen_def_return->green = exact_def_return->green;
    screen_def_return->blue = exact_def_return->blue;
    ok = XAllocColor(display,colormap,screen_def_return);
    if( ok==-1 )
      screen_def_return->pixel = colorno++;
    exact_def_return->pixel = screen_def_return->pixel;

    return 1;
  }

  return 0;
/*
  if( !stricmp(color_name,"black") ){
    screen_def_return->pixel = BlackPixel(display,DefaultScreen(display));
  } else if( !stricmp(color_name,"White") ){
    screen_def_return->pixel = WhitePixel(display,DefaultScreen(display));
  } else {
    screen_def_return->pixel = unused_col++;
  }
  exact_def_return->pixel = screen_def_return->pixel;

  return(1);
*/
}

/********************************************************************************
Name     : XFreeColors()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XFreeColors( Display* display,
	     Colormap colormap,
	     unsigned long *pixels,
	     int npixels,
	     unsigned long planes )
{
  int i;
  X11ColorMap_t* cmap = (X11ColorMap_t*)X11Cmaps[colormap];

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XFREECOLORS, bInformColormaps );
#endif

  if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    if( npixels==256 ){
      DG.X11Screen[1].max_maps = 1;
      cmap->nAllocNext = 0;
    } else
      DG.X11Screen[1].max_maps -= npixels;

    return(0);
  }
  if( npixels>DG.nDisplayColors )
    npixels = DG.nDisplayColors;
  if( ( DG.vUseWB || DG.vWBapp ) && DG.bUse30 ){
    for( i=0; i<npixels; i++ )
      if( Xallocated[pixels[i]] ){
#if(DEBUG!=0)
      if( bInformColormaps )
	printf("releasing %d\n",pixels[i]);
#endif /* DEBUG */
	ReleasePen(X11Cmaps[colormap],pixels[i]);
	Xallocated[pixels[i]] = 0;
      }
  } else {
    if( colorno>0 )
      colorno -= npixels;
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

hextoint( char c )
{
  if( c>'9' )
    return toupper(c)-'A'+10;
  else
    return c-'0';
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int 
hexscan( char *pStr, int nChars )
{
  int nSum = 0;
  int i;

  for( i=0; i<nChars; i++ )
    nSum += hextoint(*(pStr+(nChars-i-1)))<<i*4;

  return nSum;
}

/********************************************************************************
Name     : XLookupColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XLookupColor( Display* display,
	      Colormap colormap,
	      char* colorname,
	      XColor* exact_def_return,
	      XColor* screen_def_return )
{
  FILE *fp;
  char str[80];
  int r,g,b;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XLOOKUPCOLOR, bInformColormaps );
#endif
  if( !colorname )
    return(0);
  if( colorname[0]=='#' ){ /* #FFFF FFFF FFFF */
    int hexeach = 4;
    
    if( strlen(colorname)==7 )
      hexeach = 2;

    exact_def_return->red = hexscan(&colorname[1],hexeach);
    exact_def_return->red = exact_def_return->red<<8|exact_def_return->red;
    exact_def_return->green = hexscan(&colorname[1+hexeach],hexeach);
    exact_def_return->green = exact_def_return->green<<8|exact_def_return->green;
    exact_def_return->blue = hexscan(&colorname[1+2*hexeach],hexeach);
    exact_def_return->blue = exact_def_return->blue<<8|exact_def_return->blue;

    return 1;
  }

  if( !strcmp(colorname,"black") ){
    exact_def_return->red = 0;
    exact_def_return->green = 0;
    exact_def_return->blue = 0;

    return 1;
  }
  if( !strcmp(colorname,"white") ){

    exact_def_return->red = (255<<8)|255;
    exact_def_return->green = (255<<8)|255;
    exact_def_return->blue = (255<<8)|255;
    
    return 1;
  }

  if( !(fp=fopen("libx11:rgb.txt","r")) ){
    //system("c:copy libx11:rgb.txt t:");
    fp = fopen("libx11:rgb.txt","r");
  }
  if( !fp )
    return(0);
  while( !feof(fp) ){
    char c;

    fscanf(fp,"%d %d %d%c%c\n",&r,&g,&b,&c,&c);
    fgets(str,80,fp);
    str[strlen(str)-1] = 0;
/*    printf("%d %d %d [%s]\n",r,g,b,str);*/
    if( !strcmp(str,colorname) ){
      exact_def_return->red = (r<<8)|r;
      exact_def_return->green = (g<<8)|g;
      exact_def_return->blue = (b<<8)|b;
      fclose(fp);

      return(1);
    }
  }
  fclose(fp);

  return(0);
}

/********************************************************************************
Name     : XAllocColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XAllocColor( Display* display,
	     Colormap colormap,
	     XColor* cio )
{
  int n;
  X11ColorMap_t* cmap = (X11ColorMap_t*)colormap;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XALLOCCOLOR, bInformColormaps );
#endif

  if( colormap==0 /*DG.X11Screen[0].cmap*/
      && ( DG.vUseWB || DG.vWBapp || DG.wb==DG.Scr )
      && DG.bUse30 ){
    ULONG red,green,blue;

#if 1
    red = SCALE8TO32(cio->red>>8);
    green = SCALE8TO32(cio->green>>8);
    blue = SCALE8TO32(cio->blue>>8);
#else
    red = cio->red>>8;
    green = cio->green>>8;
    blue = cio->blue>>8;
#endif
    if( (n=ObtainPen(X11Cmaps[colormap],-1,red,green,blue,PEN_EXCLUSIVE))!=-1 ){
      cio->pixel = n;
#if (DEBUG!=0)
      if( bInformColormaps )
	printf("xalloccolor obtained public pen for %x %x %x ",red,green,blue);
#endif
      XStoreColor(display,colormap,cio);
      Xallocated[n] = 1;
#if (DEBUG!=0)
      if( bInformColormaps )
	printf("got %d\n",n);
#endif

#if 1
      return 1;
#else
      return(n);
#endif
    } else
      if( (n=ObtainBestPen(X11Cmaps[colormap],red,green,blue,NULL))!=-1 ){
#if (DEBUG!=0)
      if( bInformColormaps )
	printf("xalloccolor obtained best pen for %x %x %x ",red,green,blue);
#endif
	cio->pixel = n;
	Xallocated[n] = 1;

#if (DEBUG!=0)
      if( bInformColormaps )
	printf("got %d\n",n);
#endif
#if 0
	return 1;
#else
	return n;
#endif
      }

#if (DEBUG!=0)
    if( bInformColormaps )
      printf("got none..\n");
#endif

    return(0);
  }
#if 0
  if( !cio->red
      && !cio->green
      && !cio->blue ){
    cio->pixel = 1;
    
    if( DG.vUseWB )
      XStoreColor(display,colormap,cio);
    else
      cio->pixel = 0; /* color 0 is black */

    return(1);
  }
  if( cio->red>>8==0xff
      && cio->green>>8==0xff
      && cio->blue>>8==0xff ){
    cio->pixel = 2;
    if( DG.vUseWB )
      XStoreColor(display,colormap,cio);
    else
      cio->pixel = 1; /* color 1 is white */

    return(1);
  }
#endif
  if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    cio->pixel = cmap->aAllocMap[cmap->nAllocNext++];
    if( cio->pixel<256 && cmap->nAllocNext<cmap->nAllocateMax ){
      XStoreColor(display,colormap,cio);

#if 1
      return(1);
#else
      return((int)cio->pixel);
#endif
    }
    cio->pixel = 0;

    return(0);
  }
  if( !DG.vUseWB /*DG.wb!=Scr*/ ){
    cio->pixel = 2+colorno++;
    if( cio->pixel>255 )
      return 0;
    if( !DG.Scr ){
      X11prealloced = 1;
      AmigaCmap[cio->pixel*3+1] = cio->red;
      AmigaCmap[cio->pixel*3+2] = cio->green;
      AmigaCmap[cio->pixel*3+3] = cio->blue;
    } else
      XStoreColor(display,colormap,cio);
    
#if 1
    return(1);
#else
    return((int)cio->pixel);
#endif
  }
  if( colorno<(1<<DG.nDisplayDepth) ){
    cio->pixel = colorno++;
#if 1
    return(1);
#else
    return((int)cio->pixel);
#endif
  }

  return(0);
}

/********************************************************************************
Name     : XDefaultColormapOfScreen()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Colormap
XDefaultColormapOfScreen( Screen *s )
{
  assert(s);

  return(s->cmap);
}

/********************************************************************************
Name     : XAllocColorCells()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XAllocColorCells( Display* display,
		  Colormap colormap,
		  Bool contig,
		  unsigned long* plane_masks_return,
		  unsigned int nplanes,
		  unsigned long* pixels_return,
		  unsigned int npixels_return )
{
  int i,n;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XALLOCCOLORCELLS, bInformColormaps );
#endif
  if( nplanes>0 ){
    n = 1;
    for( i=0; i<nplanes; i++ ){
      plane_masks_return[i] = n;
      n = (n<<1);
    }
    return 1;
  }

  if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    for( i=0; i<npixels_return; i++ )
      pixels_return[i] = i;

    return(1);
  }
  if( (DG.vUseWB || DG.vWBapp ) && DG.bUse30 ){
    for( i=0; i<npixels_return; i++ ){
      if( (n = ObtainPen(X11Cmaps[colormap],-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1 ){
	pixels_return[i] = n;
	Xallocated[n] = 1;
#if(DEBUG!=0)
	if( bInformColormaps )
	  printf("xalloccolorcells Obtained color %d\n",n);
#endif /* DEBUG */
      } else {
#if(DEBUG!=0)
	if( bInformColormaps )
	  printf("Failed to obtain color\n");
#endif /* DEBUG */
	return(0);
      }
    }
  } else {
    for( i=0; i<npixels_return; i++ ){
      if( colorno<(1<<DG.nDisplayDepth) )
	pixels_return[i] = colorno++;
      else {
	return(0);
      }
    }
  }

  return(1);
}

/********************************************************************************
Name     : XAllocStandardColormap()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XStandardColormap *
XAllocStandardColormap()
{
  XStandardColormap *xsc = malloc(sizeof(XStandardColormap));

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XALLOCSTANDARDCOLORMAP, bInformColormaps );
#endif
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)xsc);
#endif /* MEMORYTRACKING */
  return(xsc);
}

/********************************************************************************
Name     : XCopyColormapAndFree()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     colormap  Specifies the colormap you are moving out of.

Output   : 
Function : copy a colormap and return a new colormap ID.
********************************************************************************/

Colormap
XCopyColormapAndFree( Display* display,
		      Colormap colormap )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCOPYCOLORMAPANDFREE, bInformColormaps );
#endif
  if( DG.Scr!=NULL && colormap==0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/ ){
    int i;

    for( i=0; i<DG.nDisplayColors; i++ )
      if( Xallocated[i] ) {
#if(DEBUG!=0)
	if( bInformColormaps )
	  printf("copy and releasing %d\n",i);
#endif /* DEBUG */
	ReleasePen((struct ColorMap*)DG.Scr->ViewPort.ColorMap,i);
	Xallocated[i] = 0;
      }

    return colormap;
  }
  return(0);
}

/********************************************************************************
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Colormap
XCreateColormap( Display* display,
		 Window w,
		 Visual* visual,
		 int alloc )
{
  X11ColorMap_t *cm;
  int i;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XCREATECOLORMAP , bInformColormaps );
  printf("XCreateColormap %d\n",alloc);
#endif

  alloc = 256; /* assume 8 planes, should be available in visual */

  if( !(cm = (X11ColorMap_t*)calloc( sizeof(X11ColorMap_t), 1 )) )
    X11resource_exit(COLORMAPS3);
/*  return(GetColorMap(256));*/
#if (MEMORYTRACKING!=0)
  List_AddEntry(pMemoryList,(void*)cm);
#endif /* MEMORYTRACKING */

  cm->nAllocNext = 0;
  cm->nAllocateMax = 0;
  cm->vWindow = -1;

  if( DG.vUseWB || DG.vWBapp ){
    for( i=0; i<256; i++ ){
      int n;
      
      cm->aColorDef[i].pixel = 255;
      if( (n=ObtainPen(DG.Scr->ViewPort.ColorMap,-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1 ){
	cm->aAllocMap[cm->nAllocateMax++] = n;
      }
    }
    for( i=0; i<256; i++ ){
      if( cm->aAllocMap[i] )
	ReleasePen(DG.Scr->ViewPort.ColorMap,cm->aAllocMap[i]);
    }
  } else {
    for( i=0; i<256; i++ ){
      cm->aColorDef[i].pixel = 255;
      cm->aAllocMap[cm->nAllocateMax++] = i;
    }
  }

  return((Colormap)X11NewCmap((struct ColorMap*)cm));
}

/********************************************************************************
Name     : XFreeColormap()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XFreeColormap( Display* display, Colormap colormap )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XFREECOLORMAP, bInformColormaps );

#endif
#if (MEMORYTRACKING!=0)
  List_RemoveEntry(pMemoryList,(void*)X11Cmaps[colormap]);
#else
  free(X11Cmaps[colormap]);
#endif /* MEMORYTRACKING */


  return(0);
}

/********************************************************************************
Name     : XInstallColormap()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XInstallColormap( Display* display,
		  Colormap colormap_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XInstallColormap no %d\n",colormap_return);
#endif

  return(0);
}

/********************************************************************************
Name     : XUninstallColormap()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XUninstallColormap( Display* display, Colormap colormap )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUninstallColormap\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XListInstalledColormaps()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Colormap *
XListInstalledColormaps( Display* display,
			 Window w,
			 int* num_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XListInstalledColormaps\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XGetRGBColormaps()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XGetRGBColormaps( Display* display,
		  Window w,
		  XStandardColormap** std_colormap_return,
		  int* count_return,
		  Atom property )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetRGBColormaps\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XGetWMColormapWindows()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XGetWMColormapWindows( Display* display,
		       Window w,
		       Window** colormap_windows_return,
		       int* count_return )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetWMColormapWindows\n");
#endif
  return(0);
}

/********************************************************************************
Name     : XStoreNamedColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XStoreNamedColor( Display* display,
		  Colormap colormap,
		  char* color,
		  unsigned long pixel,
		  int flags )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XStoreNamedColor\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XSetGraphicsExposures()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSetGraphicsExposures( Display* display,
		       GC gc,
		       Bool graphics_exposures )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetGraphicsExposures\n");
#endif

  return(0);
}

/********************************************************************************
Name     : XParseColor()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

Status
XParseColor( Display* display,
	     Colormap colormap,
	     char* spec,
	     XColor* exact_def_return )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XPARSECOLOR, bInformColormaps );
#endif
  if( XLookupColor(display,colormap,spec,exact_def_return,exact_def_return) ){
    if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){
/*      exact_def_return->pixel=0;*/
    } else if( ( DG.vUseWB || DG.vWBapp ) && DG.bUse30 ){
      ULONG red,green,blue;
      int n;

      red = SCALE8TO32(exact_def_return->red>>8);
      green = SCALE8TO32(exact_def_return->green>>8);
      blue = SCALE8TO32(exact_def_return->blue>>8);
      n = ObtainBestPen(X11Cmaps[colormap],red,green,blue,NULL);
      Xallocated[n] = 1;
      exact_def_return->pixel = n;
#if(DEBUG!=0)
      if( bInformColormaps )
	printf("XParseColor: got best pen %d for %x %x %x\n",n,red,green,blue);
#endif /* DEBUG */
    } else {
      exact_def_return->pixel = 1 /*colorno++ */;
    }
  }

  return(1);
}

/********************************************************************************
Name     : XStoreColors()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XStoreColors( Display* display,
	      Colormap colormap,
	      XColor* color,
	      int ncolors )
{
  int i;

#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSTORECOLORS , bInformColormaps );
  printf("XStoreColors %x entries %d\n",ncolors);
#endif

  if( colormap!=0 /*DG.X11Screen[0].cmap*/ ){ /* not default */
    for( i=0; i<ncolors; i++ ){
      X11ColorMap_t* cmap = (X11ColorMap_t*)X11Cmaps[colormap];

      cmap->aColorDef[i].red = color[i].red>>8;
      cmap->aColorDef[i].green = color[i].green>>8;
      cmap->aColorDef[i].blue = color[i].blue>>8;
      cmap->aColorDef[i].pixel = color[i].pixel;
#if (DEBUG!=0)
      if( bInformColormaps )
	printf("Pre storing color %d with %x %x %x\n",color[i].pixel,color[i].red,color[i].green,color[i].blue);
#endif /* DEBUG */

    }
    XStoreColors(display,0 /*DG.X11Screen[0].cmap*/,color,ncolors);

    return(0);
  }
  if( DG.bUse30 ){
#if 0
    AmigaCmap[0]=CellsOfScreen(DefaultScreenOfDisplay(display))<<16+0;
#else
    AmigaCmap[0]=(1<<DG.nDisplayDepth)<<16+0;
#endif

    if( DG.vUseWB || DG.vWBapp ){
      for( i=0; i<DG.nDisplayColors; i++ ){
	AmigaCmap[i*3+1]=SCALE8TO32(BackupCmap[i*3+1]);
	AmigaCmap[i*3+2]=SCALE8TO32(BackupCmap[i*3+2]);
	AmigaCmap[i*3+3]=SCALE8TO32(BackupCmap[i*3+3]);
      }
    }
    for( i=0; i<ncolors; i++ ){
      AmigaCmap[color[i].pixel*3+1] = SCALE8TO32(color[i].red);
      AmigaCmap[color[i].pixel*3+2] = SCALE8TO32(color[i].green);
      AmigaCmap[color[i].pixel*3+3] = SCALE8TO32(color[i].blue);
#if (DEBUG!=0)
      if( bInformColormaps )
	printf("Storing color %d with %x %x %x\n",color[i].pixel,color[i].red,color[i].green,color[i].blue);
#endif /* DEBUG */
    }
#if 0
    AmigaCmap[CellsOfScreen(DefaultScreenOfDisplay(display))*3+1] = 0L;
#else
    {
  AmigaCmap[CellsOfScreen(DefaultScreenOfDisplay(display))*3+1] = 0L;
    /* int last = CellsOfScreen(DefaultScreenOfDisplay(display))*3;
      AmigaCmap[(min((1<<DG.nDisplayDepth),ncolors))*3+1] = 0L;
*/
    }
#endif
    if( DG.Scr )
      LoadRGB32(&DG.Scr->ViewPort,(ULONG *)AmigaCmap);
  } else {
    UWORD Acolors[256];

    for( i=0; i<(1<<DG.nDisplayDepth); i++ ){
      Acolors[color[i].pixel]=(UWORD)((((UBYTE)(color[i].red>>12)))<<8|
				      (((UBYTE)(color[i].green>>12)))<<4|
				      ((UBYTE)((color[i].blue>>12))));
    }
    if( DG.Scr )
      LoadRGB4(&DG.Scr->ViewPort,(UWORD *)Acolors,(1<<DG.nDisplayDepth));
  }
  prevcm = 1;

  return(0);
}

/********************************************************************************
Name     : XSetWindowColormap()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

XSetWindowColormap( Display* display,
		    Window w,
		    Colormap colormap )
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter( XSETWINDOWCOLORMAP, bInformColormaps );
#endif
  if( DG.Scr!=NULL && colormap!=0 /*(Colormap)Scr->ViewPort.ColorMap*/ ){
    int i;

    X11ColorMap_t *cmap = (X11ColorMap_t*)X11Cmaps[colormap];
    DG.X11Screen[0].cmap = 0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/;
    cmap->vWindow = w;
/*
    for( i=0; i<256; i++ ){
      Maincolors[i].red = cmap->aColorDef[i].red;
      Maincolors[i].green = cmap->aColorDef[i].green;
      Maincolors[i].blue = cmap->aColorDef[i].blue;
      Maincolors[i].pixel = cmap->aColorDef[i].pixel;
    }
    XStoreColors(display,(Colormap)DG.Scr->ViewPort.ColorMap,Maincolors,256);
*/
    for( i=0; i<256; i++ ){
      XColor cdef;

      cdef.red = cmap->aColorDef[i].red<<8;
      cdef.green = cmap->aColorDef[i].green<<8;
      cdef.blue = cmap->aColorDef[i].blue<<8;
      cdef.pixel = cmap->aColorDef[i].pixel;
      XStoreColor(NULL,0 /*(Colormap)DG.Scr->ViewPort.ColorMap*/,&cdef);
    }
  }

  return(0);
}

/********************************************************************************
Name     : XQueryColor - obtain the RGB values and flags for a specified colorcell.
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 

Description
     XQueryColor() returns the RGB values  in  colormap  colormap  for  the
     colorcell  corresponding  to  the  pixel  value specified in the pixel
     member of  the  XColor  structure  def_in_out.   The  RGB  values  are
     returned  in  the  red, green, and blue members of that structure, and
     the flags member of that structure  is  set  to  (DoRed  |  DoGreen  |
     DoBlue).   The values returned for an unallocated entry are undefined.
     For more information, see Volume One, Chapter 7, Color.

********************************************************************************/

XQueryColor(display, colormap, def_in_out)
     Display *display;
     Colormap colormap;
     XColor *def_in_out;
{/*             File 'graphic.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XQueryColor\n");
#endif
  return(0);
}
