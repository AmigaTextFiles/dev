/*
=========================================================
== TO COMPILE : CC FILE.C +L -S                        ==
== TO LINK    : LN FILE.O +LC32  (It's not main body)  ==
==                                                     ==
== ©1993 by Savel soft inc.                            ==
==                                                     ==
==                                                     ==
== Rockford & Boulder Dash is © by First Star soft.    ==
========Cia BOULDER-DASH Grafinis modulis================
*/
#include "INCLUDE:stdio.h"
#include "INCLUDE:exec/types.h"
#include "INCLUDE:devices/audio.h"
#include "INCLUDE:graphics/gfx.h"
#include "INCLUDE:graphics/copper.h"
#include "INCLUDE:graphics/view.h"
#include "INCLUDE:graphics/rastport.h"
#include "INCLUDE:graphics/gels.h"
#include "INCLUDE:graphics/regions.h"
#include "INCLUDE:graphics/clip.h"
#include "INCLUDE:graphics/sprite.h"
#include "INCLUDE:exec/exec.h"
#include "INCLUDE:graphics/text.h"
#include "INCLUDE:graphics/gfxbase.h"
#include "INCLUDE:graphics/gfxmacros.h"
#include "INCLUDE:hardware/dmabits.h"
#include "INCLUDE:hardware/custom.h"
#include "INCLUDE:exec/memory.h"
#include "INCLUDE:intuition/intuition.h"
#define e(x,y) ek[y*30+x]
#define k(x,y) kk[y*30+x]

#define DEPTH 3L
#define WIDTH 800L
#define HEIGHT 256L
#define VPWIDTH 640L
#define VPHEIGHT 256L

#define NOT_ENOUGH_MEMORY -1000
STATIC UBYTE ek[430];
STATIC UBYTE kk[430];
STATIC UBYTE Adzin,Abum;
SHORT galima();
LONG hsefektai();
STATIC SHORT nereikia,TIM,CRISTAL,HMAGMA;
/* ------ cia prasideda displejus ----- */
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
0x000,0xfff,0x44e,0x0c1,
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
 view.Modes =HIRES;
 InitBitMap(&bitmap,DEPTH,WIDTH,HEIGHT);
 InitRastPort(&rastport);
 rastport.BitMap = &bitmap;
 rasinfo.BitMap = &bitmap;
 rasinfo.RxOffset = 20;      /* Kad nesimatytu pvz. */
 rasinfo.RyOffset = 0;
 rasinfo.Next = NULL;

 viewport.DWidth = VPWIDTH;
 viewport.DHeight = VPHEIGHT;
 viewport.RasInfo = &rasinfo;
 viewport.DyOffset = 0;
 viewport.DxOffset = 0;
 viewport.Modes =HIRES; /* DUALPF , PFBA , HIRES , LACE , HAM ,SPRITES*/
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
PrntI(x,y,n)
SHORT x,y,n;
{
ClipBlit(&rastport,(long)42,(long)n*10L,&rastport,x,y,(long)10,(long)10,(long)0xC0);
}
Prnt(x,y,n)
USHORT x,y,n;
{
USHORT a;
if(n>999){ return; }
a=n/100; PrntI(x,y,a); n-=a*100; a=n/10; PrntI(x+10,y,a);
n-=a*10; PrntI(x+20,y,n);
}
PrntL(x,y,n)
USHORT x,y;
ULONG n;
{
ULONG a;
a=n/1000; Prnt(x,y,a); n-=a*1000; Prnt(x+30,y,n);
}
hide()
{
LONG x,y,n,i=0;
Audiodzin();
for(n=0;n<7;n++)
{ for(x=0;x<30;x++)
{ for(y=0;y<13;y++)
{ if(galima(47) && e(x,y)!=7) { e(x,y)=7;
ClipBlit(&rastport,(long)0,(long)140,&rastport,(long)x*20L+63L,(long)y*19,(long)20,(long)19,(long)0xC0); }
i=hsefektai(i);
} } }
for(x=0;x<30;x++) { for(y=0;y<13;y++) {
if(e(x,y)!=7) { set(x,y,7);
i=hsefektai(i);
 } } } Audiopip(0);
}
LONG hsefektai(i)
LONG i;
{
 Audiodzin2(i);
 i++;
 if(i==30) {i=0;}
 return(i);
}
show()
{
LONG x,y,n,xx,yy,zz,i=0;
   for(y=0; y<13; y++)
    {
     for(x=0; x<30; x++)
      { ClipBlit(&rastport,(long)0,(long)140,&rastport,(long)x*20L+63L,(long)y*19,(long)20,(long)19,(long)0xC0); }
     }
for(xx=0;xx<390;xx++) {kk[xx]=11; }
Audiodzin();
for(xx=0;xx<6;xx++)
{
 for(x=0;x<30;x++)
 {
  for(y=0;y<13;y++)
  {
   if(k(x,y)>10)
    {
     if(galima((short)53)) {
          i=hsefektai(i);
         set(x,y,e(x,y)); if(e(x,y)==9)
       { set(x,y,7); e(x,y)=9; }
       }
    }
  }
 }
}
for(x=0;x<30;x++)
{
 for(y=0;y<13;y++)
 {
  if(k(x,y)>10) { 
     i=hsefektai(i);
     set(x,y,e(x,y)); if(e(x,y)==9)
    { set(x,y,7); e(x,y)=9; }
   }
 }
} Audiopip(0);
} /* END of SHOW */

set(x,y,n)
LONG x,y,n;
{
LONG xx;
 k(x,y)=0;
 e(x,y)=n;
 if(n>14) {
           if(n==15){n=8;}
           if(n==16){n=6;}
           if(n==17){n=11;}
           if(n==20){n=10;}
          }
 xx=63L+x*20L;
if(n<12)
 ClipBlit(&rastport,(long)0,(long)n*20,&rastport,(long)xx,(long)y*19,(long)20,(long)19,(long)0xc0);
else
 {
ClipBlit(&rastport,(long)21,(long)20L*(n-12),&rastport,(long)xx,(long)y*19,(long)20,(long)19,(long)0xc0);}
  }
/* END of SET */
Makegraphics()
{
LONG n,a,b;

SetAPen(&rastport,4L); RectFill(&rastport,0L,100L,20L,103L);
RectFill(&rastport,0L,115L,20L,119L);
SetAPen(&rastport,3L); RectFill(&rastport,0L,104L,20L,107L);
RectFill(&rastport,0L,112L,20L,114L);
SetAPen(&rastport,2L); RectFill(&rastport,0L,108L,20L,111L);
SetAPen(&rastport,0L);
for(n=0;n<20;n++) {Move(&rastport,n,99L); Draw(&rastport,20L-n,120L); }
                             /* Supaprastintas drugelis */

SetAPen(&rastport,1L); RectFill(&rastport,21L,20L,41L,39L);
SetAPen(&rastport,0L); plot(21,26); Draw(&rastport,42L,26L);
plot(21,32); Draw(&rastport,42L,32L);
plot(21,39); Draw(&rastport,42L,39L);
/* judancios sienos variantas */


SetAPen(&rastport,5L);
for(n=8;n>0;n--) { DrawEllipse(&rastport,30L,49L,n,n); }
SetAPen(&rastport,6L);
DrawEllipse(&rastport,30L,49L,9L,8L);
plot(30,43); plot(30,44); plot(33,46); plot(36,48);
SetAPen(&rastport,7L); plot(29,57); plot(30,56);
plot(32,56); plot(34,55);
/* BOMBA */

SetAPen(&rastport,1L); RectFill(&rastport,22L,121L,41L,130L);
SetAPen(&rastport,6L); plot(26,132); plot(27,133);
plot(28,134); plot(29,135); /* Akmenu generat. */

SetAPen(&rastport,2L); RectFill(&rastport,28L,145L,35L,157L);
SetAPen(&rastport,1L); RectFill(&rastport,22L,141L,41L,150L);
SetAPen(&rastport,0L); plot(22,145); Draw(&rastport,141L,145L);
/* Bril. generatorius */

SetAPen(&rastport,7L); RectFill(&rastport,22L,193L,41L,199L);
SetAPen(&rastport,1L); RectFill(&rastport,23L,194L,40L,198L);
SetAPen(&rastport,3L); RectFill(&rastport,28L,189L,35L,192L);
/* Mina */

SetAPen(&rastport,1L); RectFill(&rastport,31L,226L,32L,236L);
RectFill(&rastport,25L,230L,35L,231L); SetAPen(&rastport,2L);
plot(31,230); plot(32,231); SetAPen(&rastport,4L);
plot(32,230); plot(31,231); /* Juod. skyle. */

SetAPen(&rastport,6L);
for(n=8;n>0;n--) { DrawEllipse(&rastport,10L,49L,n,n); }
SetAPen(&rastport,1L);
DrawEllipse(&rastport,10L,49L,9L,8L);
plot(10,43); plot(10,44); plot(13,46); plot(16,48);
SetAPen(&rastport,5L); plot(9,57); plot(10,56);
plot(12,56); plot(14,55);  /* Akmuo */

for(n=0;n<9;n++)
 {SetAPen(&rastport,n/2+2);
  Move(&rastport,9-n,60+n);
  Draw(&rastport,n+9,60+n);
 }
for(n=9;n>0;n--)
 {SetAPen(&rastport,n/2+2);
  Move(&rastport,9-n,79-n);
  Draw(&rastport,n+9,79-n);   /* Kristalas */
 }

SetAPen(&rastport,2L); RectFill(&rastport,1L,81L,20L,99L);
SetAPen(&rastport,3L); RectFill(&rastport,4L,84L,15L,95L);
SetAPen(&rastport,4L); RectFill(&rastport,7L,87L,12L,92L); /* Blake */


SetAPen(&rastport,6L);
RectFill(&rastport,0L,20L,20L,39L);
SetAPen(&rastport,0L); Move(&rastport,7L,29L); Draw(&rastport,18L,27L);
Move(&rastport,8L,23L); Draw(&rastport,20L,21L);
plot(5,21); plot(13,22); SetAPen(&rastport,1L); plot(16,25);
plot(19,27);                          /* Zeme */

SetAPen(&rastport,1L);
RectFill(&rastport,0L,159L,20L,179L);
SetAPen(&rastport,0L);
Move(&rastport,0L,164L);
Draw(&rastport,20L,164L);
Move(&rastport,0L,169L);
Draw(&rastport,20L,169L);
Move(&rastport,0L,174L); Draw(&rastport,20L,174L);
Move(&rastport,0L,178L); Draw(&rastport,20L,178L);
Move(&rastport,3L,159L); Draw(&rastport,3L,164L);
Move(&rastport,13L,159L); Draw(&rastport,13L,164L);
Move(&rastport,8L,164L); Draw(&rastport,8L,169L);
Move(&rastport,18L,164L); Draw(&rastport,18L,169L);
Move(&rastport,3L,169L); Draw(&rastport,3L,174L);
Move(&rastport,13L,169L); Draw(&rastport,13L,174L);
Move(&rastport,8L,174L); Draw(&rastport,8L,178L);
Move(&rastport,18L,174L); Draw(&rastport,18L,178L);   /* Muras */

SetAPen(&rastport,6L);
RectFill(&rastport,1L,141L,20L,159L);
spot(4,142); spot(4,152); spot(13,142); spot(13,152); /* metAlas */

SetAPen(&rastport,7L);
RectFill(&rastport,0L,120L,20L,139L);
SetAPen(&rastport,0L);
RectFill(&rastport,3L,123L,7L,127L);
RectFill(&rastport,13L,132L,16L,134L);
/* Kvazi Magme */
SetAPen(&rastport,1L); square(0,180,20,199);
square(3,183,17,196);
SetAPen(&rastport,7L); square(1,181,19,198);
SetAPen(&rastport,3L); square(2,182,18,197);

SetAPen(&rastport,6L);
RectFill(&rastport,3L,203L,14L,207L);
Move(&rastport,6L,208L); Draw(&rastport,11L,208L);
Move(&rastport,4L,202L); Draw(&rastport,5L,202L);
Move(&rastport,12L,202L); Draw(&rastport,13L,202L);
RectFill(&rastport,2L,205L,15L,206L);
SetAPen(&rastport,1L); Move(&rastport,0L,213L); Draw(&rastport,1L,213L);
Draw(&rastport,4L,210L); Draw(&rastport,14L,210L); Draw(&rastport,17L,213L);
Draw(&rastport,18L,213L); RectFill(&rastport,5L,212L,13L,214L);
RectFill(&rastport,4L,215L,5L,217L); RectFill(&rastport,13L,215L,14L,217L);
Move(&rastport,2L,217L); Draw(&rastport,3L,217L); Move(&rastport,15L,217L);
Draw(&rastport,16L,217L); plot(6,211); plot(21,211);
SetAPen(&rastport,7L); Move(&rastport,6L,213L); Draw(&rastport,11L,213L);
SetAPen(&rastport,0L); RectFill(&rastport,4L,205L,6L,206L);
RectFill(&rastport,11L,205L,13L,206L); /* Rockford ® */

SetAPen(&rastport,1L); Move(&rastport,5L,225L); Draw(&rastport,15L,235L);
Move(&rastport,7L,233L); Draw(&rastport,13L,225L);
SetAPen(&rastport,7L); Move(&rastport,7L,226L); Draw(&rastport,13L,227L);
Move(&rastport,5L,230L); Draw(&rastport,15L,229L);
SetAPen(&rastport,1L); Move(&rastport,0L,221L); Draw(&rastport,20L,238L);
Move(&rastport,20L,221L); Draw(&rastport,0,239L); plot(9,229); plot(10,230);
plot(5,230); plot(15,235); Move(&rastport,9L,223L);
Draw(&rastport,11L,239L); Draw(&rastport,8L,225L);
Move(&rastport,0L,231L); Draw(&rastport,20L,229L);
Draw(&rastport,4L,229L);
 /* Blast ! */
a=43; b=48;
SetAPen(&rastport,5L); RectFill(&rastport,42L,0L,62L,250L);
SetAPen(&rastport,1L); Move(&rastport,a,1L); Draw(&rastport,b,1L);
Draw(&rastport,b,8L); Draw(&rastport,a,8L); Draw(&rastport,a,1L);

Move(&rastport,45L,11L); Draw(&rastport,45L,18L); plot(44,12);

Move(&rastport,a,21L); Draw(&rastport,b,21L);
Draw(&rastport,b,24L); Draw(&rastport,a,24L);
Draw(&rastport,a,28L); Draw(&rastport,b,28L);

Move(&rastport,a,31L); Draw(&rastport,b,31L);
Draw(&rastport,b,38L); Draw(&rastport,a,38L);
Move(&rastport,a,34L); Draw(&rastport,b,34L);

Move(&rastport,a,41L); Draw(&rastport,a,44L);
Draw(&rastport,b,44L); Move(&rastport,b,41L);
Draw(&rastport,b,48L);

Move(&rastport,b,51L); Draw(&rastport,a,51L);
Draw(&rastport,a,54L); Draw(&rastport,b,54L);
Draw(&rastport,b,58L); Draw(&rastport,a,58L);

Move(&rastport,b,61L); Draw(&rastport,a,61L);
Draw(&rastport,a,68L); Draw(&rastport,b,68L);
Draw(&rastport,b,64L); Draw(&rastport,a,64L);

Move(&rastport,a,71L); Draw(&rastport,b,71L);
Draw(&rastport,b,78L);

Move(&rastport,a,81L); Draw(&rastport,b,81L);
Draw(&rastport,b,88L); Draw(&rastport,a,88L);
Draw(&rastport,a,81L); Move(&rastport,a,84L);
Draw(&rastport,b,84L);

Move(&rastport,b,94L); Draw(&rastport,a,94L);
Draw(&rastport,a,91L); Draw(&rastport,b,91L);
Draw(&rastport,b,98L); Draw(&rastport,a,98L);
 /* Tai buvo skaiciai nuo 0 iki 9 */
Move(&rastport,a,101L); Draw(&rastport,a,108L); Draw(&rastport,b,108L);
Move(&rastport,45L,111L); Draw(&rastport,45L,118L);
Move(&rastport,a,121L); Draw(&rastport,45L,128L);
Draw(&rastport,48L,121L);
Move(&rastport,b,131L); Draw(&rastport,a,131L); Draw(&rastport,a,138L);
Draw(&rastport,b,138L); Move(&rastport,a,134L); Draw(&rastport,b,134L);
Move(&rastport,b,141L); Draw(&rastport,a,141L); Draw(&rastport,a,148L);
Draw(&rastport,b,148L);
Move(&rastport,a,158L); Draw(&rastport,a,151L); Draw(&rastport,b,151L);
Draw(&rastport,b,154L); Draw(&rastport,a,154L); Draw(&rastport,b,158L);
Move(&rastport,a,161L); Draw(&rastport,b,161L); Move(&rastport,45L,161L);
Draw(&rastport,45L,168L);
Move(&rastport,a,171L); Draw(&rastport,a,178L); Move(&rastport,b,171L);
Draw(&rastport,b,178L); Move(&rastport,a,174L); Draw(&rastport,b,174L);
Move(&rastport,a,184L); Draw(&rastport,b,184L);

} /* END of Makegraphics */
square(x,y,x2,y2)
LONG x,y,x2,y2;
{ Move(&rastport,x,y); Draw(&rastport,x2,y); Draw(&rastport,x2,y2);
Draw(&rastport,x,y2); Draw(&rastport,x,y); }
spot(x,y)
LONG x,y;
{ SetAPen(&rastport,0L); RectFill(&rastport,x,y,x+4L,y+4L);
  SetAPen(&rastport,5L); RectFill(&rastport,x-1L,y-1L,x+3,y+3);
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
FMemory()
{
LONG i;
LoadView(oldview);
WaitTOF(); Delay(1);
for(i=0;i<DEPTH; i++) { if (bitmap.Planes[i] != NULL) {
  FreeRaster(bitmap.Planes[i],WIDTH,HEIGHT);
 }}
if (cm != NULL) FreeColorMap(cm);
FreeVPortCopLists(&viewport);
FreeCprList(view.LOFCprList);
CloseLibrary(GfxBase);
return;
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

