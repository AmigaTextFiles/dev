/*
 *   This file handles the graphics primitives for BlitLab.
 */
#include "structures.h"
/*
 *   External variables we use.
 */
extern struct RastPort *myrp ;
/*
 *   color sets the current foreground color to the appropriate value.
 */
color(c)
int c ;
{
   SetAPen(myrp, (long)c) ;
   SetDrMd(myrp, (long)JAM1) ;
}
/*
 *   This routine draws a horizontal or vertical line.
 */
line(x1, y1, x2, y2)
int x1, y1, x2, y2 ;
{
   int t ;
   if (x1 > x2) {
      t = x1 ;
      x1 = x2 ;
      x2 = t ;
   }
   if (y1 > y2) {
      t = y1 ;
      y1 = y2 ;
      y2 = t ;
   }
   if (x1 != x2 && y1 != y2)
      error("! can only draw h/v lines currently") ;
   RectFill(myrp, (long)x1, (long)y1, (long)x2, (long)y2) ;
}
/*
 *   This routine draws a box.
 */
box(x1, y1, xsize, ysize)
int x1, y1, xsize, ysize ;
{
   xsize = x1 + xsize - 1 ;
   ysize = y1 + ysize - 1 ;
   line(x1, y1, xsize, y1) ;
   line(xsize, y1, xsize, ysize) ;
   line(xsize, ysize, x1, ysize) ;
   line(x1, ysize, x1, y1) ;
}
/*
 *   This routine draws a filled box.
 */
fbox(x1, y1, xsize, ysize)
int x1, y1, xsize, ysize ;
{
   RectFill(myrp, (long)x1, (long)y1, (long)(x1 + xsize - 1),
      (long)(y1 + ysize - 1)) ;
}
/*
 *   This routine draws a text string at a particular location.  It is
 *   somewhat crude; we build an IntuiText structure, and tell it to
 *   draw it.
 */
static struct IntuiText dmy = {
   WHITE, BLUE,
   JAM2,
   0, 0,
   NULL,
   NULL,
   NULL
} ;
drawtext(x, y, s)
int x, y ;
char *s ;
{
   dmy.IText = (UBYTE *)s ;
   PrintIText(myrp, &dmy, (long)(x), (long)(y)) ;
}
