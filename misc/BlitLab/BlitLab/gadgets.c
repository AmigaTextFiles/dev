/*
 *   Gadgets for BlitLab.  We have something like 40 gadgets here.
 */
#include "structures.h"
/*
 *   To make things nice, we build the gadgets up, one by one.  First,
 *   the externals we use.
 */
extern struct Window *mywindow ;
extern char *bufarr[] ;
extern char strings[] ;
extern void *allocmem() ;
extern struct Gadget *gadgets[] ;
/*
 *   This routine allocates a border description.
 */
static struct Border *givebox(xsize, ysize)
int xsize, ysize ;
{
   register struct Border *bp ;
   register short *r ;

   bp = allocmem((long)sizeof(struct Border), MEMF_CLEAR) ;
   r = allocmem(20L, MEMF_CLEAR) ;
   r[2] = xsize ;
   r[4] = xsize ;
   r[5] = ysize ;
   r[7] = ysize ;
   bp->FrontPen = WHITE ;
   bp->DrawMode = JAM2 ;
   bp->Count = 5 ;
   bp->XY = r ;
   return(bp) ;
}
/*
 *   This routine allocates an intuitext structure, with a string
 *   centered in it.
 */
static struct IntuiText *centertext(size, s)
int size ;
char *s ;
{
   register struct IntuiText *itp ;

   itp = allocmem((long)sizeof(struct IntuiText), MEMF_CLEAR) ;
   itp->FrontPen = WHITE ;
   itp->DrawMode = JAM2 ;
   itp->TopEdge = 2 ;
   itp->LeftEdge = (size - strlen(s) * 8) / 2 ;
   itp->IText = (UBYTE *)s ;
   return(itp) ;
}
/*
 *   This routine builds a simple hit gadget, given an id, x and
 *   y locations, xsize and ysize, and a string label.
 */
static buildhit(id, x, y, xsize, ysize, s)
int id ;
int x, y, xsize, ysize ;
char *s ;
{
   register struct Gadget *gp ;

   gp = allocmem((long)sizeof(struct Gadget), MEMF_CLEAR) ;
   gp->LeftEdge = x ;
   gp->TopEdge = y ;
   gp->Width = xsize ;
   gp->Height = ysize ;
   gp->Flags = GADGHCOMP ;
   gp->Activation = RELVERIFY ;
   gp->GadgetType = BOOLGADGET ;
   gp->GadgetRender = (APTR)givebox(xsize, ysize) ;
   gp->GadgetText = centertext(xsize, s) ;
   gp->GadgetID = id ;
   gadgets[id] = gp ;
   AddGadget(mywindow, gp, 0) ;
}
/*
 *   This routine builds a gadget with two possible strings.  It is up
 *   to the user to flip the strings when it is selected; this means
 *   taking it off the list and putting it back on.
 */
static buildtoggle(id, x, y, xsize, ysize, s1, s2)
int id ;
int x, y, xsize, ysize ;
char *s1, *s2 ;
{
   register struct Gadget *gp ;

   gp = allocmem((long)sizeof(struct Gadget), MEMF_CLEAR) ;
   gp->LeftEdge = x ;
   gp->TopEdge = y ;
   gp->Width = xsize ;
   gp->Height = ysize ;
   gp->Flags = GADGHNONE ;
   gp->Activation = GADGIMMEDIATE ;
   gp->GadgetType = BOOLGADGET ;
   gp->GadgetRender = (APTR)givebox(xsize, ysize) ;
   gp->GadgetText = centertext(xsize, s1) ;
   gp->GadgetID = id ;
   gp->UserData = (APTR)centertext(xsize, s2) ;
   gadgets[id] = gp ;
   AddGadget(mywindow, gp, 0) ;
}
/*
 *   This routine builds a simple string gadget.  We allocate pieces
 *   of the `strings' array as we do the gadgets.  `p' holds a pointer
 *   to the next available chunk; we have to be careful to initialize.
 *   We also allow a label parameter which lives to the left of the
 *   string gadget.
 */
static char undobuf[100] ;
static char *p ;
static buildstring(id, x, y, width, init, rmax, lab)
int id ;
int x, y ;
int width ;
char *init ;
int rmax ;
char *lab ;
{
   register struct Gadget *gp ;
   register struct StringInfo *sip ;
   register struct Border *bp ;
   int ysize ;
   int xsize ;
   int chars ;

   if (lab != NULL) {
      drawtext(x + 4, y + 2, lab) ;
      x += 8 + strlen(lab) * 8 ;
      width -= 8 + strlen(lab) * 8 ;
   }
   chars = ( width - 4 ) / 8 ;
   ysize = VSTRSIZE ;
   xsize = HSTRSIZE(chars) ;
   bufarr[id] = p ;
   strcpy(p, init) ;
   gp = allocmem((long)sizeof(struct Gadget), MEMF_CLEAR) ;
   sip = allocmem((long)sizeof(struct StringInfo), MEMF_CLEAR) ;
   sip->Buffer = (UBYTE *)p ;
   p += rmax ;
   sip->UndoBuffer = (UBYTE *)undobuf ;
   sip->MaxChars = rmax ;
   gp->LeftEdge = x + 2 ;
   gp->TopEdge = y + 2 ;
   gp->Width = xsize ;
   gp->Height = ysize - 3 ;
   gp->Flags = GADGHCOMP ;
   gp->Activation = RELVERIFY ;
   gp->GadgetType = STRGADGET ;
   bp = givebox(xsize - 2, ysize - 2) ;
   bp->XY[0] = -2 ;
   bp->XY[1] = -2 ;
   bp->XY[3] = -2 ;
   bp->XY[6] = -2 ;
   bp->XY[8] = -2 ;
   bp->XY[9] = -2 ;
   gp->GadgetRender = (APTR)bp ;
   gp->GadgetText = NULL ;
   gp->SpecialInfo = (APTR)sip ;
   gp->GadgetID = id ;
   gadgets[id] = gp ;
   AddGadget(mywindow, gp, 0) ;
}
/*
 *   This routine actually creates all of the gadgets.  Wish
 *   us luck placing all of these correctly!
 */
buildgadgets() {
   int i ;

   p = strings ;
   buildhit(GDGGO, HGOSTART, VGOSTART, HGOSIZE, VGOSIZE, "GO") ;
   buildhit(GDGSETUP, HMG3START, VMG2START, HMGSIZE, VMGSIZE, "Setup") ;
   buildhit(GDGCALC, HLMGSTART, VLMG5, HLMGSIZE, VLMGSIZE, "Calc") ;
   buildhit(GDGUNDO, HLMGSTART, VLMG7, HLMGSIZE, VLMGSIZE, "Undo") ;
   buildtoggle(GDGPNTREG, HLMGSTART, VLMG1, HLMGSIZE, VLMGSIZE, "Point",
      " Box ") ;
   buildtoggle(GDGLINE, HMG3START, VMG1START, HMGSIZE, VMGSIZE, "(line)",
      " LINE ") ;
   buildtoggle(GDGDESC, HMG6START, VMG1START, HMGSSIZE, VMGSIZE, "(desc)", 
      " DESC ") ;
   buildtoggle(GDGFCI, HMG7START, VMG1START, HMGSSIZE, VMGSIZE, "(fci)", 
      " FCI ") ;
   buildtoggle(GDGIFE, HMG8START, VMG1START, HMGSSIZE, VMGSIZE, "(ife)",
      " IFE ") ;
   buildtoggle(GDGEFE, HMG9START, VMG1START, HMGSSIZE, VMGSIZE, "(efe)",
      " EFE ") ;
   buildtoggle(GDGSIGN, HMG10START, VMG1START, HMGSSIZE, VMGSIZE, "(sign)",
      " SIGN ") ;
   buildtoggle(GDGOVF, HMG11START, VMG1START, HMGSSIZE, VMGSIZE, "(ovf)",
      " OVF ") ;
   buildtoggle(GDGSIM, HLMGSTART, VLMG8, HLMGSIZE, VLMGSIZE, "Real ",
      "Simul") ;
   for (i=0; i<4; i++)
      buildtoggle(GDGUSEA+i, HRVC8, VRG1 + 11 * i, 24, VSTRSIZE, "N", "Y") ;
   buildstring(GDGSX, HMG1START, VMG1START, HMGSIZE, "0", 20, "SX") ;
   buildstring(GDGSY, HMG2START, VMG1START, HMGSIZE, "0", 20, "SY") ;
   buildstring(GDGEX, HMG1START, VMG2START, HMGSIZE, "0", 20, "EX") ;
   buildstring(GDGEY, HMG2START, VMG2START, HMGSIZE, "0", 20, "EY") ;
   buildstring(GDGH, HMG4START, VMG1START, HMGSIZE, "0", 20, "W") ;
   buildstring(GDGV, HMG5START, VMG1START, HMGSIZE, "0", 20, "H") ;
   buildstring(GDGFUNC, HMG4START, VMG2START, FUNCSIZE, "0", 100, "Func") ;
   buildstring(GDGLF, HMGFLSTART, VMG2START, FUNCSIZE, "", 100, "Log") ;
   for (i=0; i<4; i++)
      buildstring(GDGAPT+i, HRVC9, VRG1 + 11 * i, HSTRSIZE(8), "0", 20, NULL) ;
   for (i=0; i<4; i++)
      buildstring(GDGAMOD+i, HRVC10, VRG1 + 11 * i, HSTRSIZE(6), "0", 20,
         NULL) ;
   for (i=0; i<3; i++)
      buildstring(GDGADAT+i, HRVC11, VRG1 + 11 * i, HSTRSIZE(18), "0", 20,
         NULL) ;
   for (i=0; i<2; i++)
      buildstring(GDGASH+i, HRVC12, VRG1 + 11 * i, HSTRSIZE(4), "0", 20,
         NULL) ;
   buildstring(GDGAFWM, HRVC11, VRG1 + 33, 180, "%1111111111111111", 20,
      "FWM") ;
   buildstring(GDGALWM, HRVC11, VRG1 + 44, 180, "%1111111111111111", 20,
      "LWM") ;
   RefreshGadgets(mywindow->FirstGadget, mywindow, NULL) ;
}
