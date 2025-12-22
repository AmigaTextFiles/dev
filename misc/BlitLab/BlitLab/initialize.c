/*
 *   Initialization module of the blitlab program.
 */
#include "structures.h"
/*
 *   These are the externals we reference.
 */
extern struct Window *mywindow ;
extern struct GfxBase *GfxBase ;
extern struct IntuitionBase *IntuitionBase ;
extern struct RastPort *myrp ;
extern int custscreen ;
/*
 *   We use this memory allocator.
 */
extern short *allocmem() ;
/*
 *   This is the screen we use, if we use a screen.  :-)
 */
static char defaulttitle[] =
    "<< Radical Eye Software . . . or I won't get dressed >>" ;
static struct Screen *myscreen ;
static struct TextFont *font ;
static struct TextAttr myfont = {
   (STRPTR) "topaz.font",
   TOPAZ_EIGHTY,
   0,
   0
};
static struct NewScreen mynewscreen = {
   0,                                         /* left edge */
   0,                                         /* top edge */
   640,                                       /* width */
   200,                                       /* height */
   2,                                         /* depth (change for color?)*/
   1,                                         /* detail pen */
   2,                                         /* block pen */
   HIRES,                                     /* screen mode */
   CUSTOMSCREEN,                              /* type */
   &myfont,                                   /* use default font */
   (UBYTE *)defaulttitle,                     /* title */
   NULL,                                      /* initialize this gadget field */
   NULL } ;                                   /* no bitmap supplied */
static short colorTable[] = { 0x058f, 0x0fff, 0x0000, 0x0555 } ;
static short pointerTable[] = 
    { 0x0000, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0380, 0x0280,
      0x0440, 0x0440,
      0xFC7E, 0x0000,
      0x0440, 0x0440,
      0x0380, 0x0280,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0100, 0x0000,
      0x0000, 0x0000 } ;
/*
 *   This is the humongous window we open on the standard
 *   workbench screen.
 */
static struct NewWindow mynewwindow = {
   HWINSTART, VWINSTART, HWINSIZE, VWINSIZE,
   -1, -1,
   MOUSEBUTTONS | MOUSEMOVE | GADGETDOWN | GADGETUP | CLOSEWINDOW | VANILLAKEY,
   WINDOWDEPTH | WINDOWCLOSE | WINDOWDRAG | SMART_REFRESH | REPORTMOUSE
   | ACTIVATE | RMBTRAP,
   NULL,
   NULL,
   (UBYTE *)BANNER,
   NULL,
   NULL,
   0, 0, 0, 0,
   WBENCHSCREEN } ;
/*
 *   This is the main initialize routine, which gets everything started
 *   up.
 */
initialize() {
   int i, j ;
/*
 *   First, we try and open libraries and windows.
 */
   if ((IntuitionBase = (struct IntuitionBase *)OpenLibrary(
      "intuition.library",0L))==NULL ||
       (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0L))
      ==NULL)
      error("! Couldn't open libraries") ;
   if (custscreen) {
      mynewscreen.Width = GfxBase->NormalDisplayColumns ;
      mynewscreen.Height = GfxBase->NormalDisplayRows ;
      if ((myscreen=OpenScreen(&mynewscreen))==NULL)
         error("! Couldn't open screen") ;
      LoadRGB4(&(myscreen->ViewPort), colorTable, 4L) ;
      mynewwindow.Screen = myscreen ;
      mynewwindow.Type = CUSTOMSCREEN ;
   }
   if ((mywindow=OpenWindow(&mynewwindow))==NULL)
      error("! Couldn't open window") ;
   makepointer() ;
   myrp = mywindow -> RPort ;
   if (! custscreen) {
      font = OpenFont(&myfont) ;
      if (font != NULL)
         SetFont(myrp, font) ;
   }
   allocbitmem() ;
   buildgadgets() ;
   drawlabels() ;
   parseall() ;
/*
 *   Here we draw the bits array, hopefully for easy reference.
 */
   color(BLACK) ;
   fbox(HBITSTART, VBITSTART, HBITSIZE, VBITSIZE) ;
   color(WHITE) ;
   box(HBITSTART, VBITSTART, HBITSIZE, VBITSIZE) ;
   color(ORANGE) ;
   for (i=1; i<24; i++)
      box(HBITSTART + i * 24 - 2, VBITSTART, 2, VBITSIZE) ;
   for (i=HBITSTART+4; i<HBITSTART+574; i += 6)
      for (j=VBITSTART+3; j<VBITSTART+96; j += 3)
         fbox(i, j, 1, 1) ;
   color(BLUE) ;
   box(HBITSTART, VBITSTART, HBITSIZE, VBITSIZE) ;
   for (i=1; i<7; i++)
      box(HBITSTART + i * 96 - 2, VBITSTART, 2, VBITSIZE) ;
   for (i=1; i<9; i++)
      line(HBITSTART, VBITSTART + i * 12, HBITSTART + HBITSIZE - 1,
           VBITSTART + i * 12) ;
   updatebits() ;
/*
 *   Now we draw boxes around the blitter register values and user
 *   settable values.
 */
   color(WHITE) ;
   box(HRVSTART, VRVSTART, HRVSIZE, VRVSIZE) ;
   line(HMVSTART, VRVSTART, HMVSTART, VRVSTART + VRVSIZE - 1) ;
}
/*
 *   This routine cleans up for exit.
 */
cleanup() {
   if (font != NULL)
      CloseFont(font) ;
   if (mywindow != NULL) {
      ClearPointer(mywindow) ;
      CloseWindow(mywindow) ;
   }
   if (myscreen != NULL)
      CloseScreen(myscreen) ;
   if (GfxBase != NULL)
      CloseLibrary(GfxBase) ;
   if (IntuitionBase != NULL)
      CloseLibrary(IntuitionBase) ;
   freemem() ;
   exit(0) ;
}
/*
 *   Pointer routines.
 */
makepointer() {
   short *pointer ;
   int i ;

   pointer = allocmem((long)sizeof(pointerTable), MEMF_CHIP) ;
   movmem(pointerTable, pointer, sizeof(pointerTable)) ;
   SetPointer(mywindow, pointer, 15L, 15L, -7L, -7L) ;
}
/*
 *   drawlabels() draws several miscellaneous labels all over the
 *   screen.
 */
drawlabels() {
   drawtext(HLMGSTART+4, VLMG3+2, "Adrs:") ;
   drawtext(HLMGSTART+4, VLMG3+10, " M+") ;
   drawtext(HLMGSTART+4, VLMG3+18, "Shift:") ;
   drawtext(HRVC1 + 12, VRVL6, "Blitter Register Values") ;
   drawtext(HRVC7 + 4, VRVLL6+1, "DMA Channels") ;
   drawtext(HRVC1, VRVL1, "CON0") ;
   drawtext(HRVC1, VRVL2, "CON1") ;
   drawtext(HRVC1, VRVL3, "SIZE") ;
   drawtext(HRVC1, VRVL4, "AFWM") ;
   drawtext(HRVC1, VRVL5, "ALWM") ;
   drawtext(HRVC3, VRVL2, "A") ;
   drawtext(HRVC3, VRVL3, "B") ;
   drawtext(HRVC3, VRVL4, "C") ;
   drawtext(HRVC3, VRVL5, "D") ;
   drawtext(HRVC4 + 4, VRVL1, "PTH  PTL  MOD  DAT") ;
   drawtext(HRVC7, VRVLL2+1, "A") ;
   drawtext(HRVC7, VRVLL3+1, "B") ;
   drawtext(HRVC7, VRVLL4+1, "C") ;
   drawtext(HRVC7, VRVLL5+1, "D") ;
   drawtext(HRVC8, VRVLL1, "USE    PT     MOD          DAT          SH") ;
}
