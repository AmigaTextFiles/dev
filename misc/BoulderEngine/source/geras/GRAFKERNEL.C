
#include <stdio.h>
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/copper.h>
#include <graphics/view.h>
#include <graphics/rastport.h>
#include <graphics/gels.h>
#include <graphics/regions.h>
#include <graphics/clip.h>
#include <graphics/sprite.h>
#include <exec/exec.h>
#include <graphics/text.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <hardware/dmabits.h>
#include <hardware/custom.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#define DEPTH 1L
#define WIDTH 630L
#define HEIGHT 400L
#define VPWIDTH 630L
#define VPHEIGHT 400L

#define NOT_ENOUGH_MEMORY -1000
struct View view;
struct ViewPort viewport;
struct ColorMap *cm;
struct RasInfo rasinfo;
struct BitMap bitmap;
struct RastPort rastport;
extern struct ColorMap *GetColorMap();
struct GfxBase *GfxBase;
struct View *oldview;
USHORT colortable[]={
0x000,0x2f5,0x44e,0x0c1,
0x999,0x445,0x999,0xd10,
0x356,0x55f,0x888,0xc57,
0x115,0x023,0xf00,0x209,
0x127,0x213,0x209,0x15f,
0x190,0x088,0x090,0xf22,
0x333,0x444,0x555,0x666,
0x777,0x888,0x999,0xaaa,
0 };
UWORD *colorpalette;

pasiruosk()
{
LONG i,n;
UBYTE *displaymem;
 GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",0L);
 if (GfxBase==NULL) exit(100);

 oldview=GfxBase->ActiView;

 InitView(&view);
 InitVPort(&viewport);
 view.ViewPort = &viewport;
 view.Modes=HIRES+LACE;
 InitBitMap(&bitmap,DEPTH,WIDTH,HEIGHT);
 InitRastPort(&rastport);
 rastport.BitMap = &bitmap;
 rasinfo.BitMap = &bitmap;
 rasinfo.RxOffset = 0;      /* Kad nesimatytu pvz. */
 rasinfo.RyOffset = 0;
 rasinfo.Next = NULL;

 viewport.DWidth = VPWIDTH;
 viewport.DHeight = VPHEIGHT;
 viewport.RasInfo = &rasinfo;
 viewport.DyOffset = 0;
 viewport.DxOffset = 0;
 viewport.Modes =HIRES + LACE; /* DUALPF , PFBA , HIRES , LACE , HAM ,SPRITES*/
 cm = GetColorMap(32L);
 if (cm == NULL) { exit(100); }
 colorpalette = (UWORD *)cm->ColorTable;
 for(i=0;i<32;i++) { *colorpalette++ = colortable[i]; }
 viewport.ColorMap = cm;
 for(i=0; i<DEPTH;i++) {
  bitmap.Planes[i] = (PLANEPTR) AllocRaster(WIDTH,HEIGHT);
  }
  MakeVPort(&view,&viewport);
  MrgCop(&view);
  LoadView(&view);
  }


plot(x,y)
LONG x,y;
{ Move(&rastport,x,y); Draw(&rastport,x,y); }
Tekstscreen(xx,yy)
SHORT xx,yy;
{
  rasinfo.RxOffset = xx;
  rasinfo.RyOffset = yy;
  MakeVPort(&view,&viewport);
  MrgCop(&view);
  LoadView(&view);
}

/* --------------------------------------------------------------*/
FreeMemory()
{
LONG i;
LoadView(oldview);
WaitTOF();
for(i=0;i<DEPTH; i++) { if (bitmap.Planes[i] != NULL) {
  FreeRaster(bitmap.Planes[i],WIDTH,HEIGHT);
 }}
if (cm != NULL) FreeColorMap(cm);
FreeVPortCopLists(&viewport);
FreeCprList(view.LOFCprList);
CloseLibrary(GfxBase);
return(0);
}

SHORT galima(range)
short range;
{
static int konst;
short l=0;
konst+=range;
if(konst>254) {konst-=254; l=1; }
return(l);
}

