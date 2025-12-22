/*
 *   This routine handles the display of the bit array in BlitLab.
 */
#include "structures.h"
/*
 *   This is the address of the real bits we operate on.
 */
extern short int *realbits ;
extern long gvals[] ;
static short safearr[192] ;
static short osafearr[192] ;
static int specbits ; /* should we leave the undo array alone? */
allocbitmem() {
   extern void *allocmem() ;

   realbits = (short *)(allocmem(1000L, MEMF_CHIP | MEMF_CLEAR)) + 150 ;
}
savebits(f)
FILE *f ;
{
   int i ;

   for (i=0; i<192; i++)
      fprintf(f, "%d\n", safearr[i]) ;
}
loadbits(f)
FILE *f ;
{
   int i ;

   for (i=0; i<192; i++)
      if (fscanf(f, "%d\n", realbits+i) != 1)
         error("invalid bit in save file") ;
   updatebits() ;
}
pdot(x, y, on)
int x, y, on ;
{
   int off = (x >> 4) + y * 6 ;
   int bit = 1 << (15 - (x & 15)) ;

   if (on) {
      if ((realbits[off] & bit) == 0) {
         realbits[off] |= bit ;
         safearr[off] |= bit ;
         color(WHITE) ;
         fbox(x * 6 + HBITSTART, y * 3 + VBITSTART + 1, 4, 2) ;
      }
   } else {
      if (realbits[off] & bit) {
         realbits[off] &= ~bit ;
         safearr[off] &= ~bit ;
         color(BLACK) ;
         fbox(x * 6 + HBITSTART, y * 3 + VBITSTART + 1, 4, 2) ;
      }
   }
}
preg(x1, y1, x2, y2, on)
int x1, y1, x2, y2, on ;
{
   int i, j ;

   for (i=x1; i<=x2; i++)
      for (j=y1; j<=y2; j++)
         pdot(i, j, on) ;
}
/*
 *   This routine writes out the new position to the screen.
 */
updatepos(x1, y1)
int x1, y1 ;
{
   char outbuf[4] ;

   sprintf(outbuf, "%3d", ((x1 >> 3) & ~1) + y1 * 12) ;
   drawtext(HLMGSTART+28, VLMG3+10, outbuf) ;
   sprintf(outbuf, "%2d", x1 & 15) ;
   drawtext(HLMGSTART+20, VLMG3+26, outbuf) ;
}
undobits() {
   register short *p2 = osafearr, *p3 = realbits ;
   int i = 192 ;

   while (i-- > 0)
      *p3++ = *p2++ ;
   updatebits() ;
}
updatebits() {
   int x=HBITSTART, y=VBITSTART+1 ;
   register short *p1 = realbits, *p2 = safearr, *p3 = osafearr ;
   int i = 192 ;
   int rc = 6 ;
   int bit ;

   while (i-- > 0) {
      *p3++ = *p2 ;
      if (*p1 == *p2) {
         p1++ ;
         p2++ ;
         x += 6 * 16 ;
      } else {
         if (!specbits) {
            bit = 0x8000 ;
            while (bit != 0) {
               if ((*p2 & bit) != (*p1 & bit)) {
                  color((*p1 & bit) ? WHITE : BLACK) ;
                  fbox(x, y, 4, 2) ;
               }
               bit = (bit >> 1) & 0x7fff ;
               x += 6 ;
            }
         } else
            x += 6 * 16 ;
         *p2++ = *p1++ ;
      }
      if (--rc == 0) {
         rc = 6 ;
         x = HBITSTART ;
         y += 3 ;
      }
   }
   specbits = 0 ;
}
/*
 *   Here we update a single screen word, if it lies on the screen.
 */
screenupdate(where, what)
short *where ;
short what ;
{
   int i, bit, x, y ;

   specbits = 1 ;
   if (where >= realbits && where < realbits + 192) {
      i = where - realbits ;
      y = VBITSTART + 1 + (i / 6) * 3 ;
      x = HBITSTART + (i % 6) * 96 ;
      for (bit=0x8000; bit != 0; bit = (bit >> 1) & 0x7fff, x += 6) {
         if ((bit & what) != (bit & *where)) {
            color((what & bit) ? WHITE : BLACK) ;
            fbox(x, y, 4, 2) ;
         }
      }
      *where = what ;
   } else {
      error("Dangerous assignment!") ;
      Delay(25L) ;
   }
}
