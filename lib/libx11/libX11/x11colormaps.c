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

#include "amigax_proto.h"
#include "amiga_x.h"
#undef memset

void savewbcm(void);
void swapwbcm(int cm,ULONG *colors);

/* colormaps */

extern Display amigaX_display;
extern struct Screen *Scr,*wb;
ULONG AmigaCmap[256*3+2];
ULONG *BackupCmap=NULL;

typedef struct {
  unsigned char red;
  unsigned char green;
  unsigned char blue;
  unsigned char pixel;
} X11color_t;

typedef struct {
  int nMaxColors;
  X11color_t aColorDef[256];
  unsigned char aAllocMap[256];
  short nAllocNext;
  short nAllocateMax;
} X11ColorMap_t;

int prevcm=-1;
int colorno=0;

XColor *Backupcolors=NULL;
XColor *Maincolors=NULL;

int lockcol=0,lockhigh=0;
char *Xallocated=NULL;
unsigned char *XCanAllocate=NULL,nGlobalAllocateMax;
extern int usewb,wbapp;
extern Screen amiga_screen[];

/* *** */
int X11prealloced;

/*
XID *X11Cmaps=NULL;
int X11NumCmaps=0,X11AvailCmaps=0;
*/

void X11init_cmaps(void){
/*  X11Cmaps=NewPointerMap(10,NULL,0);
  X11AvailCmaps=10;*/
  if (Xallocated) return;
  memset(AmigaCmap,0,256*3+2);
  X11prealloced=0;
  if(usewb||wbapp){
    int i;
    Xallocated=(char*)calloc(1,1<<DG.nDisplayDepth);
    BackupCmap=(ULONG*)malloc(sizeof(ULONG)*(256*3+2));
    Backupcolors=(XColor*)malloc(256*sizeof(XColor));
    Maincolors=(XColor*)malloc(256*sizeof(XColor));
    if(!Backupcolors||!Maincolors||!BackupCmap||!Xallocated) X11resource_exit(COLORMAPS2);
    XCanAllocate=(char*)calloc(1,256);
    nGlobalAllocateMax=0;
    for(i=0;i<256;i++){
      int n;
      if((n=ObtainPen(Scr->ViewPort.ColorMap,-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1){
	XCanAllocate[nGlobalAllocateMax++]=n;
      }
    }
    for(i=0;i<256;i++){
      if(XCanAllocate[i])
	ReleasePen(Scr->ViewPort.ColorMap,XCanAllocate[i]);
    }
/*    nCanAllocatePos=2;*/
  }

}

void X11exit_cmaps(void){
  int i;
  if (!Xallocated) return;
  if(usewb||wbapp){
    swapwbcm(0,NULL);
    for(i=0;i<DG.nDisplayColors;i++)
      if(Xallocated[i]) {
	ReleasePen((struct ColorMap*)amiga_screen[0].cmap,i);
      }
  }
  if(Xallocated) free(Xallocated);
  if(XCanAllocate) free(XCanAllocate);
  Xallocated=NULL;
  if(BackupCmap) free(BackupCmap);
  if(Backupcolors) free(Backupcolors);
  if(Maincolors) free(Maincolors);
}

void X11updatecmap(void);

void X11updatecmap(void){
  int i;
  if(X11prealloced){
    AmigaCmap[1]=0; AmigaCmap[2]=0; AmigaCmap[3]=0;
    AmigaCmap[4]=255; AmigaCmap[5]=255; AmigaCmap[6]=255;
    for(i=0;i<(1<<DG.nDisplayDepth);i++){
      XColor cdef;
      cdef.pixel=i;
      cdef.red=(unsigned short)AmigaCmap[i*3+1]<<8;
      cdef.green=(unsigned short)AmigaCmap[i*3+2]<<8;
      cdef.blue=(unsigned short)AmigaCmap[i*3+3]<<8;
      XStoreColor(NULL,(Colormap)Scr->ViewPort.ColorMap,&cdef);
    }
  }
}

#define SCALE8TO32(x) ((x)|((x)<<8)|((x)<<16)|((x)<<24))

XStoreColor(dp,cm,cdef)
Display *dp;
Colormap cm;
XColor *cdef;
{
  int r=cdef->red>>8,g=cdef->green>>8,b=cdef->blue>>8;
#ifdef DEBUGXEMUL_ENTRY
  printf("(colormaps)XStoreColor %d pixel %d\n",cm,cdef->pixel);
#endif
  if(cm!=amiga_screen[0].cmap){ /* not workbench */
    X11ColorMap_t* cmap=(X11ColorMap_t*)cm;

    assert(cdef->pixel>=0 && cdef->pixel<256);
    cmap->aColorDef[cdef->pixel].red=cdef->red>>8;
    cmap->aColorDef[cdef->pixel].green=cdef->green>>8;
    cmap->aColorDef[cdef->pixel].blue=cdef->blue>>8;
    cmap->aColorDef[cdef->pixel].pixel=cdef->pixel;

    return;
  }
  if((usewb||wbapp)&&cdef->pixel>=DG.nDisplayColors) return;

  if(!Scr) return;
  if(cdef->pixel>=0&&cdef->pixel<256){
    if(DG.bUse30){
      SetRGB32(((struct ColorMap*)cm)->cm_vp /*&Scr->ViewPort*/,
	       (ULONG)cdef->pixel,
	       (ULONG)SCALE8TO32(r),(ULONG)SCALE8TO32(g),(ULONG)SCALE8TO32(b));
    } else
      SetRGB4(&Scr->ViewPort,cdef->pixel,(cdef->red)>>12,(cdef->green)>>12,(cdef->blue)>>12);
  }
}

XStoreColors(display, colormap, color, ncolors)
     Display *display;
     Colormap colormap;
     XColor *color;
     int ncolors;
{
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("(colormaps)XStoreColors [%d] wb %d\n",ncolors,DG.nDisplayColors);
#endif
  if(colormap!=amiga_screen[0].cmap){ /* not workbench */
    for(i=0;i<ncolors;i++){
      X11ColorMap_t* cmap=(X11ColorMap_t*)colormap;
      cmap->aColorDef[i].red=color[i].red>>8;
      cmap->aColorDef[i].green=color[i].green>>8;
      cmap->aColorDef[i].blue=color[i].blue>>8;
      cmap->aColorDef[i].pixel=color[i].pixel;
    }
    XStoreColors(display,amiga_screen[0].cmap,color,ncolors);
    return(0);
  }
  if(DG.bUse30){
    AmigaCmap[0]=CellsOfScreen(DefaultScreenOfDisplay(display))<<16+0;
    
    for(i=0;i<DG.nDisplayColors;i++){
      AmigaCmap[i*3+1]=SCALE8TO32(BackupCmap[i*3+1]);
      AmigaCmap[i*3+2]=SCALE8TO32(BackupCmap[i*3+2]);
      AmigaCmap[i*3+3]=SCALE8TO32(BackupCmap[i*3+3]);
    }
    for(i=0;i<ncolors;i++){
      AmigaCmap[color[i].pixel*3+1]=SCALE8TO32(color[i].red);
      AmigaCmap[color[i].pixel*3+2]=SCALE8TO32(color[i].green);
      AmigaCmap[color[i].pixel*3+3]=SCALE8TO32(color[i].blue);
    }
    AmigaCmap[CellsOfScreen(DefaultScreenOfDisplay(display))*3+1] = 0L;
    if(Scr)LoadRGB32(&Scr->ViewPort,(ULONG *)AmigaCmap);
  }else{
    UWORD Acolors[256];
    for(i=0;i<(1<<DG.nDisplayDepth);i++){
      Acolors[color[i].pixel]=(UWORD)((((UBYTE)(color[i].red>>12)))<<8|
				      (((UBYTE)(color[i].green>>12)))<<4|
				      ((UBYTE)((color[i].blue>>12))));
    }
    if(Scr)LoadRGB4(&Scr->ViewPort,(UWORD *)Acolors,(1<<DG.nDisplayDepth));
  }
  prevcm=1;
  return(0);
}

XQueryColors(display, colormap, defs_in_out, ncolors)
     Display *display;
     Colormap colormap;
     XColor *defs_in_out;
     int ncolors;
{
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("(colormaps)XQueryColors [%d]\n",ncolors);
#endif
  if(colormap!=amiga_screen[0].cmap){ /* not workbench */
    for(i=0;i<ncolors;i++){
      X11ColorMap_t* cmap=(X11ColorMap_t*)colormap;
      defs_in_out[i].pixel=cmap->aColorDef[i].pixel;
      defs_in_out[i].red  =cmap->aColorDef[i].red<<8|cmap->aColorDef[i].red;
      defs_in_out[i].green=cmap->aColorDef[i].green<<8|cmap->aColorDef[i].green;
      defs_in_out[i].blue =cmap->aColorDef[i].blue<<8|cmap->aColorDef[i].blue;
    }
    return(0);
  }
  if(DG.bUse30){
    if(Scr)GetRGB32(Scr->ViewPort.ColorMap,0L,(ULONG)256,(ULONG*)&AmigaCmap[1]);
    for(i=0;i<ncolors;i++){
      int c=defs_in_out[i].pixel;
      defs_in_out[i].red  =AmigaCmap[c*3+1]>>16|AmigaCmap[c*3+1]>>24;
      defs_in_out[i].green=AmigaCmap[c*3+2]>>16|AmigaCmap[c*3+2]>>24;
      defs_in_out[i].blue =AmigaCmap[c*3+3]>>16|AmigaCmap[c*3+3]>>24;
    }
  }else{
    ULONG v=0;
    for(i=0;i<ncolors;i++){
      if(Scr)v=GetRGB4(Scr->ViewPort.ColorMap,i);
      if(v!=-1){
	defs_in_out[i].pixel=i;
	defs_in_out[i].blue=((v&15)<<4)<<8;
	defs_in_out[i].green=(((v&(15<<4))>>4)<<4)<<8;
	defs_in_out[i].red=(((v&(15<<8))>>8)<<4)<<8;
      }
    }
  }
  return(0);
}

void savewbcm(void){
#ifdef DEBUGXEMUL_ENTRY
  printf("savewbcm! %d %d (%d)\n",prevcm,DG.nDisplayColors,usewb);
#endif
  if(prevcm==1)return;
  if(usewb||wbapp){
    if(DG.bUse30){
      if(Scr)GetRGB32(Scr->ViewPort.ColorMap,0L,(ULONG)DG.nDisplayColors,(ULONG*)&(BackupCmap[1]));
      BackupCmap[0]=(DG.nDisplayColors<<16+0);
      BackupCmap[(DG.nDisplayColors-lockhigh)*3+1]=0;
/*    for(i=0;i<DG.nDisplayColors;i++)
	printf("saved %d (%d %d %d)\n",i,
	       BackupCmap[i*3+1]&255,BackupCmap[i*3+2]&255,BackupCmap[i*3+3]&255);*/
    }else{
      if(Scr)
	XQueryColors(&amigaX_display,(Colormap)Scr->ViewPort.ColorMap,(XColor*)Backupcolors,(int)(DG.nDisplayColors-lockhigh));
    }
    DG.bWbSaved=1;
  }
}

void swapwbcm(int cm,ULONG *colors){
#ifdef DEBUGXEMUL_ENTRY
  printf("swapwbcm! %d prev %d\n",cm,prevcm);
#endif
  if(usewb){
    if(prevcm!=cm){
      if(cm==1){
	if(DG.bUse30) LoadRGB32(&Scr->ViewPort,(ULONG*)colors);
	else XStoreColors(&amigaX_display,(Colormap)Scr->ViewPort.ColorMap,Maincolors,1<<DG.nDisplayDepth);
      }
      else{
/*	for(i=0;i<DG.nDisplayColors;i++)
	  printf("restoring %d (%d %d %d)\n",i,
		 BackupCmap[i*3+1]&255,BackupCmap[i*3+2]&255,BackupCmap[i*3+3]&255);*/
	if(DG.bUse30) LoadRGB32(&Scr->ViewPort,(ULONG *)BackupCmap);
	else XStoreColors(&amigaX_display,(Colormap)Scr->ViewPort.ColorMap,Backupcolors,DG.nDisplayColors);
      }
      prevcm=cm;
    }
  }
}

XAllocNamedColor(display,colormap,color_name,screen_def_return,exact_def_return)
     Display *display;
     Colormap colormap;
     char *color_name;
     XColor *screen_def_return;
     XColor *exact_def_return;
{/*        File 'sunclock.o'*/
  int ok=XLookupColor(display,colormap,color_name,exact_def_return,screen_def_return);
  if(ok){
    screen_def_return->red=exact_def_return->red;
    screen_def_return->green=exact_def_return->green;
    screen_def_return->blue=exact_def_return->blue;
    ok=XAllocColor(display,colormap,screen_def_return);
    if(!ok) screen_def_return->pixel=colorno++;
    exact_def_return->pixel=screen_def_return->pixel;
    return 1;
  }
  return 0;
/*
  if(stricmp(color_name,"Black")==0){
    screen_def_return->pixel=BlackPixel(display,DefaultScreen(display));
  } else if(stricmp(color_name,"White")==0){
    screen_def_return->pixel=WhitePixel(display,DefaultScreen(display));
  } else{
    screen_def_return->pixel=unused_col++;
  }
  exact_def_return->pixel=screen_def_return->pixel;

#ifdef DEBUGXEMUL_ENTRY
  printf("XAllocNamedColor [%s] using %d\n",color_name,screen_def_return->pixel);
#endif
  return(1);
*/
}

Status XAllocColorCells(display, colormap, contig, plane_masks_return,
			nplanes, pixels_return, npixels_return)
     Display *display;
     Colormap colormap;
     Bool contig;
     unsigned long *plane_masks_return;
     unsigned int nplanes;
     unsigned long *pixels_return;
     unsigned int npixels_return;
{/*        File 'colors.o'*/
  int i,n;
#ifdef DEBUGXEMUL_ENTRY
  printf("XAllocColorCells used %d\n",colorno);
#endif
  if(colormap!=amiga_screen[0].cmap){ /* not workbench */
    for(i=0;i<npixels_return;i++)
      pixels_return[i]=i;
    return(1);
  }
  if((usewb||wbapp)&&DG.bUse30){
    if(!colormap) return(0);
    for(i=0;i<npixels_return;i++){
      if((n=ObtainPen((struct ColorMap*)colormap,-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1){
	pixels_return[i]=n;
	Xallocated[n]=1;
      }
      else return(0);
    }
  }else{
    for(i=0;i<npixels_return;i++){
      if(colorno<(1<<DG.nDisplayDepth)) pixels_return[i]=colorno++;
      else {return(0);}
    }
  }

  return(1);
}

Status XParseColor(display, colormap, spec, exact_def_return)
     Display *display;
     Colormap colormap;
     char *spec;
     XColor *exact_def_return;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XParseColor\n");
#endif
  if(XLookupColor(display,colormap,spec,exact_def_return,exact_def_return)){
    if(colormap!=amiga_screen[0].cmap){
/*      exact_def_return->pixel=0;*/
    }else if((usewb||wbapp)&&DG.bUse30){
      ULONG red,green,blue;
      int n;
      red=SCALE8TO32(exact_def_return->red>>8);
      green=SCALE8TO32(exact_def_return->green>>8);
      blue=SCALE8TO32(exact_def_return->blue>>8);
      n=ObtainBestPen((struct ColorMap*)colormap,red,green,blue,NULL);
      Xallocated[n]=1;
      exact_def_return->pixel=n;
    }else{
      exact_def_return->pixel=colorno++;
    }
  }
  return(1);
}

XInstallColormap(display, colormap_return)
     Display *display;
     Colormap colormap_return;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XInstallColormap no %d\n",colormap_return);
#endif
  return(0);
}

XSetWindowColormap(display, w, colormap)
     Display *display;
     Window w;
     Colormap colormap;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetWindowColormap %d\n",w);
#endif
  if(Scr!=NULL&&colormap!=(Colormap)Scr->ViewPort.ColorMap){
    int i;
    X11ColorMap_t *cmap=(X11ColorMap_t*)colormap;
    amiga_screen[0].cmap=(Colormap)Scr->ViewPort.ColorMap;
/*
    for(i=0;i<256;i++){
      Maincolors[i].red=cmap->aColorDef[i].red;
      Maincolors[i].green=cmap->aColorDef[i].green;
      Maincolors[i].blue=cmap->aColorDef[i].blue;
      Maincolors[i].pixel=cmap->aColorDef[i].pixel;
    }
    XStoreColors(display,(Colormap)Scr->ViewPort.ColorMap,Maincolors,256);
*/
    for(i=0;i<256;i++){
      XColor cdef;
      cdef.red=cmap->aColorDef[i].red;
      cdef.green=cmap->aColorDef[i].green;
      cdef.blue=cmap->aColorDef[i].blue;
      cdef.pixel=cmap->aColorDef[i].pixel;
      if(cdef.pixel)
	XStoreColor(NULL,(Colormap)Scr->ViewPort.ColorMap,&cdef);
    }
  }
  return(0);
}

Colormap XCreateColormap(display, w, visual, alloc)
     Display *display;
     Window w;
     Visual *visual;
     int alloc;
{
  X11ColorMap_t *cm;
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("XCreateColormap [%d]\n",alloc);
#endif

  alloc=256; /* assume 8 planes, should be available in visual */

  if(!(cm=(X11ColorMap_t*)malloc(sizeof(X11ColorMap_t)))) X11resource_exit(COLORMAPS3);
/*  return(GetColorMap(256));*/
  List_AddEntry(pMemoryList,(void*)cm);

  cm->nAllocNext=0;
  cm->nAllocateMax=0;
  memset(cm->aAllocMap,0,256);

  for(i=0;i<256;i++){
    int n;
    if((n=ObtainPen(Scr->ViewPort.ColorMap,-1,0,0,0,PEN_EXCLUSIVE|PEN_NO_SETCOLOR))!=-1){
      cm->aAllocMap[cm->nAllocateMax++]=n;
    }
  }
  for(i=0;i<256;i++){
    if(cm->aAllocMap[i])
      ReleasePen(Scr->ViewPort.ColorMap,cm->aAllocMap[i]);
  }

  return((Colormap)cm);
}

XFreeColormap(display, colormap)
     Display *display;
     Colormap colormap;
{/*           File 'xvmisc.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XFreeColormap\n");
#endif
  List_RemoveEntry(pMemoryList,(void*)colormap);
  return(0);
}

XFreeColors(display, colormap, pixels, npixels, planes)
     Display *display;
     Colormap colormap;
     unsigned long pixels[];
     int npixels;
     unsigned long planes;
{/*             File 'xvcolor.o' */
  int i;
  X11ColorMap_t* cmap=(X11ColorMap_t*)colormap;
#ifdef DEBUGXEMUL_ENTRY
  printf("XFreeColors still allocated[%d]\n",colorno);
#endif

  if(colormap!=amiga_screen[0].cmap){ /* not workbench */
    if(npixels==256){
      amiga_screen[1].max_maps=1;
      cmap->nAllocNext=0;
    }
    else amiga_screen[1].max_maps-=npixels;
    return(0);
  }
  if(npixels>DG.nDisplayColors)npixels=DG.nDisplayColors;
  if((usewb||wbapp)&&DG.bUse30){
    for(i=0;i<npixels;i++)
      if(Xallocated[pixels[i]]){
	ReleasePen((struct ColorMap*)colormap,pixels[i]);
	Xallocated[pixels[i]]=0;
      }
  }else{
    if(colorno>0)
      colorno-=npixels;
  }
  return(0);
}

hextoint(char c){
  if(c>'9') return toupper(c)-'A'+10;
  else return c-'0';
}

int hexscan(char *pStr,int nChars){
  int nSum=0;
  int i;
  for(i=0;i<nChars;i++)
    nSum+=hextoint(*(pStr+(nChars-i-1)))<<i*4;
  return nSum;
}

Status XLookupColor(display, colormap, colorname, exact_def_return,
		    screen_def_return)
     Display *display;
     Colormap colormap;
     char *colorname;
     XColor *exact_def_return, *screen_def_return;
{/*            File 'xvimage.o' */
  FILE *fp;
  char str[80];
  int r,g,b;
#ifdef DEBUGXEMUL_ENTRY
  printf("XLookupColor\n");
#endif
  if(!colorname) return(0);
  if(colorname[0]=='#'){ /* #FFFF FFFF FFFF */
    int hexeach=4;
    
    if(strlen(colorname)==7)
      hexeach=2;

    exact_def_return->red=hexscan(&colorname[1],hexeach);
    exact_def_return->red=exact_def_return->red<<8|exact_def_return->red;
    exact_def_return->green=hexscan(&colorname[1+hexeach],hexeach);
    exact_def_return->green=exact_def_return->green<<8|exact_def_return->green;
    exact_def_return->blue=hexscan(&colorname[1+2*hexeach],hexeach);
    exact_def_return->blue=exact_def_return->blue<<8|exact_def_return->blue;
    return 1;
  }
  if(!(fp=fopen("t:rgb.txt","r"))){
    system("c:copy libx11:rgb.txt t:");
    fp=fopen("t:rgb.txt","r");
  }
  if(!fp) return(0);
  while(!feof(fp)){
    char c;
    fscanf(fp,"%d %d %d%c%c\n",&r,&g,&b,&c,&c);
    fgets(str,80,fp);
    str[strlen(str)-1]=0;
/*    printf("%d %d %d [%s]\n",r,g,b,str);*/
    if(strcmp(str,colorname)==NULL){
      exact_def_return->red=(r<<8)|r;
      exact_def_return->green=(g<<8)|g;
      exact_def_return->blue=(b<<8)|b;
      fclose(fp);
      return(1);
      break;
    }
  }
  fclose(fp);
  return(0);
}

XUninstallColormap(display, colormap)
     Display *display;
     Colormap colormap;
{/*      File 'xvevent.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XUninstallColormap\n");
#endif
  return(0);
}

Status XAllocColor(display, colormap, cio)
     Display *display;
     Colormap colormap;
     XColor *cio;
{
  int n;
  X11ColorMap_t* cmap=(X11ColorMap_t*)colormap;
#ifdef DEBUGXEMUL_ENTRY
  printf("XAllocColor\n");
#endif

  if(colormap==amiga_screen[0].cmap&&(usewb||wbapp||wb==Scr)&&DG.bUse30){
    ULONG red,green,blue;
    red=SCALE8TO32(cio->red>>8);
    green=SCALE8TO32(cio->green>>8);
    blue=SCALE8TO32(cio->blue>>8);

    if ((n=ObtainPen((struct ColorMap*)colormap,-1,red,green,blue,PEN_EXCLUSIVE))!=-1){
      cio->pixel=n;
      XStoreColor(display,colormap,cio);
      Xallocated[n]=1;
      return(n);
    }else
      if ((n=ObtainBestPen((struct ColorMap*)colormap,red,green,blue,NULL))!=-1){
	cio->pixel=n;
	Xallocated[n]=1;
	return n;
      }
    return(0);
  }
  if(cio->red==0&&cio->green==0&&cio->blue==0){
    cio->pixel=1;
    
    if(usewb) XStoreColor(display,colormap,cio);
    else cio->pixel=1; /* assume color 1 is black */
    return(1);
  }
  if(cio->red>>8==0xff&&cio->green>>8==0xff&&cio->blue>>8==0xff){
    cio->pixel=2;
    if(usewb) XStoreColor(display,colormap,cio);
    else cio->pixel=2; /* assume color 2 is white */
    return(1);
  }
  if(colormap!=amiga_screen[0].cmap){ /* not workbench */
    cio->pixel=cmap->aAllocMap[cmap->nAllocNext++];
    if(cio->pixel<256 &&cmap->nAllocNext<cmap->nAllocateMax){
      XStoreColor(display,colormap,cio);
      return (int)cio->pixel;
    }
    cio->pixel=0;
    return(0);
  }
  if(!usewb /*wb!=Scr*/){
    cio->pixel=2+colorno++;
    if(cio->pixel>255) return 0;
    if(Scr==NULL){
      X11prealloced=1;
      AmigaCmap[cio->pixel*3+1]=cio->red;
      AmigaCmap[cio->pixel*3+2]=cio->green;
      AmigaCmap[cio->pixel*3+3]=cio->blue;
    }else XStoreColor(display,colormap,cio);
    
    return((int)cio->pixel);
  }
  if(colorno<(1<<DG.nDisplayDepth)){
    cio->pixel=colorno++;
    return((int)cio->pixel);
  }
  return(0);
}

Colormap XDefaultColormapOfScreen(Screen *s){/* File 'image_f_io.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XDefaultColormapOfScreen\n");
#endif
  return(s->cmap);
}

/* end colormaps */

XSetGraphicsExposures(display, gc, graphics_exposures)
     Display *display;
     GC gc;
     Bool graphics_exposures;
{/*   File 'xast.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XSetGraphicsExposures\n");
#endif
  return(0);
}

XStoreNamedColor(Display *display,
		 Colormap colormap,
		 char *color,
		 unsigned long pixel,
		 int flags)
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XStoreNamedColor\n");
#endif
  return(0);
}

XStandardColormap *XAllocStandardColormap()
{/*  File 'magick/libMagick.lib' */
  XStandardColormap *xsc=malloc(sizeof(XStandardColormap));
#ifdef DEBUGXEMUL_ENTRY
  printf("XAllocStandardColormap\n");
#endif
  List_AddEntry(pMemoryList,(void*)xsc);
  return(xsc);
}

Status XGetRGBColormaps(display, w, std_colormap_return, count_return, property)
     Display *display;
     Window w;
     XStandardColormap **std_colormap_return;
     int *count_return;
     Atom property;
{/*        File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetRGBColormaps\n");
#endif
  return(0);
}

Status XGetWMColormapWindows(display, w, colormap_windows_return, count_return)
     Display *display;
     Window w;
     Window **colormap_windows_return;
     int *count_return;
{/*   File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XGetWMColormapWindows\n");
#endif
  return(0);
}

Colormap *XListInstalledColormaps(display, w, num_return)
     Display *display;
     Window w;
     int *num_return;
{/* File 'magick/libMagick.lib' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XListInstalledColormaps\n");
#endif
  return(0);
}
