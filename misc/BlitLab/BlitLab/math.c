/*
 *   This is the math routines of BlitLab.  It checks a possible blit to
 *   insure that it is safe.  It also handles the line calculations.
 */
#include "structures.h"
/*
 *   The externals we use.
 */
extern long gvals[] ;
extern struct Gadget *gadgets[] ;
extern short *realbits ;
extern struct Window *mywindow ;
extern char errorbuf[] ;
/*
 *   This routine insures that a blit is safe.  It returns 1 if it is
 *   okay, and 0 if it is not.
 */
int blitsafe() {
   long x1, x2, x3, x4 ;
   long lower, upper ;

   if (gvals[GDGUSED]==0)
      return(1) ;
   lower = (long)realbits ;
   upper = 382 + (long)realbits ;
   if (gvals[GDGH] < 1 || gvals[GDGV] < 1
       || gvals[GDGH] > 64 || gvals[GDGV] > 1024)
      return(0) ;
   if (gvals[GDGLINE]) {
   } else {
      x1 = gvals[GDGDPT] ;
      if (gvals[GDGDESC]) {
         x2 = x1 - gvals[GDGH] * 2 + 2 ;
         x3 = x1 - (gvals[GDGV] - 1) * ((gvals[GDGH] * 2) +
                    (gvals[GDGDMOD] & ~1)) ;
         x4 = x3 - gvals[GDGH] * 2 + 2 ;
         if (x1 < lower || x2 < lower || x3 < lower || x4 < lower ||
             x1 > upper || x2 > upper || x3 > upper || x4 > upper)
            return(0) ;
         else
            return(1) ;
      } else {
         x2 = x1 + gvals[GDGH] * 2 - 2 ;
         x3 = x1 + (gvals[GDGV] - 1) * ((gvals[GDGH] * 2) + 
                        (gvals[GDGDMOD] & ~1)) ;
         x4 = x3 + gvals[GDGH] * 2 - 2 ;
         if (x1 < lower || x2 < lower || x3 < lower || x4 < lower ||
             x1 > upper || x2 > upper || x3 > upper || x4 > upper)
            return(0) ;
         else
            return(1) ;
      }
   }
}
/*
 *   This routine stuffs a value in a gadget.  Could be dangerous, but
 *   that's life.
 */
stuff(id, s)
int id ;
char *s ;
{
   gvals[id] = parse(s) ;
   RemoveGadget(mywindow, gadgets[id]) ;
   strcpy(((struct StringInfo *)(gadgets[id]->SpecialInfo))->Buffer, s) ;
   AddGadget(mywindow, gadgets[id], -1) ;
   RefreshGadgets(gadgets[id], mywindow, NULL) ;
}
/*
 *   This routine flips the state of a toggle gadget.
 */
flipgadg(id)
int id ;
{
   struct IntuiText *temp ;
   struct Gadget *gp = gadgets[id] ;

   RemoveGadget(mywindow, gp) ;
   temp = gp->GadgetText ;
   gp->GadgetText = (struct IntuiText *)gp->UserData ;
   gp->UserData = (APTR)temp ;
   gp->NextGadget = NULL ;
   AddGadget(mywindow, gp, -1) ;
   RefreshGadgets(gp, mywindow, NULL) ;
   gvals[id] = 1 - gvals[id] ;
}
/*
 *   This routine sets up a line.
 */
setupline() {
   int x, y ;
   int i ;
   int X, Y ;
   int q = 0 ;

   parseall() ;
   stuff(GDGADAT, "$8000") ;
   stuff(GDGBDAT, "$ffff") ;
   x = gvals[GDGSX] ;
   y = gvals[GDGSY] ;
   sprintf(errorbuf, "%d", x & 15) ;
   stuff(GDGASH, errorbuf) ;
   i = ((x >> 3) & ~1) + y * 12 ;
   sprintf(errorbuf, "M+%d", i) ;
   stuff(GDGCPT, errorbuf) ;
   stuff(GDGDPT, errorbuf) ;
   stuff(GDGCMOD, "12") ;
   stuff(GDGDMOD, "12") ;
   stuff(GDGH, "2") ;
   x = (gvals[GDGEX] - gvals[GDGSX]) ;
   y = (gvals[GDGEY] - gvals[GDGSY]) ;
   if (x < 0)
      X = - x ;
   else
      X = x ;
   if (y < 0)
      Y = - y ;
   else
      Y = y ;
   if (x > 0) {
      if (y > 0) {
         q = (X > Y ? 1 : 0) ;
      } else {
         q = (X > Y ? 3 : 4) ;
      }
   } else {
      if (y > 0) {
         q = (X > Y ? 5 : 2) ;
      } else {
         q = (X > Y ? 7 : 6) ;
      }
   }
   if (Y > X) {
      i = X ;
      X = Y ;
      Y = i ;
   }
   sprintf(errorbuf, "%d", X+1) ;
   stuff(GDGV, errorbuf) ;
   sprintf(errorbuf, "%d", 4 * Y - 2 * X) ;
   stuff(GDGAPT, errorbuf) ;
   if (2 * Y - X < 0) {
      if (!gvals[GDGSIGN])
         flipgadg(GDGSIGN) ;
   } else {
      if (gvals[GDGSIGN])
         flipgadg(GDGSIGN) ;
   }
   sprintf(errorbuf, "%d", 4 * (Y - X)) ;
   stuff(GDGAMOD, errorbuf) ;
   sprintf(errorbuf, "%d", 4 * Y) ;
   stuff(GDGBMOD, errorbuf) ;
   stuff(GDGAFWM, "%1111111111111111") ;
   stuff(GDGALWM, "%1111111111111111") ;
   if (! gvals[GDGLINE])
      flipgadg(GDGLINE) ;
   if ((q & 1) != gvals[GDGEFE])
      flipgadg(GDGEFE) ;
   if (((q >> 1) & 1) != gvals[GDGIFE])
      flipgadg(GDGIFE) ;
   if (((q >> 2) & 1) != gvals[GDGFCI])
      flipgadg(GDGFCI) ;
   if (! gvals[GDGUSEA])
      flipgadg(GDGUSEA) ;
   if (gvals[GDGUSEB])
      flipgadg(GDGUSEB) ;
   if (! gvals[GDGUSEC])
      flipgadg(GDGUSEC) ;
   if (! gvals[GDGUSED])
      flipgadg(GDGUSED) ;
   if (gvals[GDGOVF])
      flipgadg(GDGOVF) ;
}
