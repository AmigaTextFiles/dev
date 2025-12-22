/*
 *   Parse.c of BlitLab software package.  This routine handles
 *   parsing the strings into integers, in any of the possible
 *   formats.
 */
#include "structures.h"
/*
 *   Externals we use.
 */
extern short *realbits ;
extern char *bufarr[] ;
extern long gvals[] ;
extern struct blitregs blitregs ;
extern char errorbuf[] ;
/*
 *   This is the main parse routine.  First, a static to indicate if
 *   we saw a parse error or not.
 */
static int parseerr ;
/*
 *   We allow the following formats:
 *
 *      (M+)?-?[$%]?[0-9a-f]+
 *      (~?[ABC])(+(~?[ABC]))*
 */
long parse(s)
register char *s ;
{
   int negative = 1 ;
   int c ;
   int radix = 10 ;
   long toadd = 0 ;
   long val ;
   static varr[] = { 0xf0, 0xcc, 0xaa } ;

   parseerr = 0 ;
   while (*s == ' ')
      s++ ;
   if (*s=='~' || *s=='A' || *s=='B' || *s=='C' || *s=='a' || *s=='b'
               || *s=='c') {
      val = 0 ;
      while (1) {
         toadd = 255 ;
         while (1) {
            if (*s == '~') {
               negative = 255 ;
               s++ ;
            } else
               negative = 0 ;
            c = *s++ ;
            if (c == 0 || c == '+') {
               if (toadd == 255)
                  parseerr = 1 ;
               break ;
            }
            if (c >= 'a' && c <= 'z')
               c -= 'a' - 'A' ;
            if (c < 'A' || c > 'C') {
               parseerr = 1 ;
               break ;
            }
            toadd &= negative ^ varr[c-'A'] ;
         }
         val |= toadd ;
         if (c != '+') {
            if (c != 0)
               parseerr = 1 ;
            break ;
         }
      }
      return(val) ;
   } else {
      if (*s == 'm' || *s == 'M') {
         if (s[1]=='+') {
            s += 2 ;
            toadd = (long)realbits ;
         } else if (s[1]==0)
            return((long)realbits) ;
         else {
            parseerr = 1 ;
            return(0) ;
         }
      }
      if (*s == '-') {
         negative = -1 ;
         s++ ;
      }
      if (*s == '$') {
         radix = 16 ;
         s++ ;
      } else if (*s == '%') {
         radix = 2 ;
         s++ ;
      }
      val = 0 ;
      if (*s == 0) {
         parseerr = 1 ;
         return(val) ;
      }
      while (1) {
         c = *s ++ ;
         if (c == 0)
            break ;
         if (c >= 'a' && c <= 'z')
            c -= 'a' - 'A' ;
         if (c >= 'A' && c <= 'F')
            c -= 'A' - 10 ;
         else
            c -= '0' ;
         if (c < 0 || c >= radix) {
            parseerr = 1 ;
            break ;
         }
         val = val * radix + c ;
      }
      return(toadd + negative * val) ;
   }
}
/*
 *   This routine parses all of the string gadgets.  If it is successful,
 *   it returns 1, otherwise it returns 0.
 */
int parseall() {
   int i ;

   for (i=0; i<MAXGADG; i++)
      if (bufarr[i] != NULL && i!=GDGLF) {
         gvals[i] = parse(bufarr[i]) ;
         if (parseerr) {
            sprintf(errorbuf, "I can't parse %s", bufarr[i]) ;
            error(errorbuf) ;
            return(0) ;
         }
      }
   updateregs() ;
   return(1) ;
}
/*
 *   This routine writes a four-digit hexadecimal value to the
 *   screen.
 */
static char *hex = "0123456789abcdef" ;
static char tmp[5] ;
static writefour(x, y, val)
int x, y, val ;
{
   tmp[3] = hex[val & 15] ;
   val >>= 4 ;
   tmp[2] = hex[val & 15] ;
   val >>= 4 ;
   tmp[1] = hex[val & 15] ;
   val >>= 4 ;
   tmp[0] = hex[val & 15] ;
   drawtext(x, y, tmp) ;
}
/*
 *   This routine calculates and writes out *all* of the blitter
 *   register values.
 */
updateregs() {
   int i ;

   blitregs.con0 = ((gvals[GDGASH] & 15) << 12) + (gvals[GDGUSEA] << 11) +
      (gvals[GDGUSEB] << 10) + (gvals[GDGUSEC] << 9) + (gvals[GDGUSED] << 8) +
      (gvals[GDGFUNC] & 255) ;
   blitregs.con1 = ((gvals[GDGBSH] & 15) << 12) + (gvals[GDGSIGN] << 6) +
      (gvals[GDGOVF] << 5) + (gvals[GDGEFE] << 4) +
      (gvals[GDGIFE] << 3) + (gvals[GDGFCI] << 2) + (gvals[GDGDESC] << 1) +
      gvals[GDGLINE] ;
   blitregs.size = ((gvals[GDGV] & 1023) << 6) + (gvals[GDGH] & 63) ;
   blitregs.afwm = (gvals[GDGAFWM] & 65535) ;
   blitregs.alwm = (gvals[GDGALWM] & 65535) ;
   for (i=0; i<4; i++) {
      blitregs.pth[i] = ((gvals[GDGAPT+i] >> 16) & 65535) ;
      blitregs.ptl[i] = (gvals[GDGAPT+i] & 65535) ;
      blitregs.mod[i] = (gvals[GDGAMOD+i] & 65535) ;
   }
   for (i=0; i<3; i++)
      blitregs.dat[i] = (gvals[GDGADAT+i] & 65535) ;
/*
 *   Now we write out the values.
 */
   writefour(HRVC2, VRVL1, blitregs.con0) ;
   writefour(HRVC2, VRVL2, blitregs.con1) ;
   writefour(HRVC2, VRVL3, blitregs.size) ;
   writefour(HRVC2, VRVL4, blitregs.afwm) ;
   writefour(HRVC2, VRVL5, blitregs.alwm) ;
   for (i=0; i<4; i++) {
      writefour(HRVC4, VRVL2 + 10 * i, blitregs.pth[i]) ;
      writefour(HRVC5, VRVL2 + 10 * i, blitregs.ptl[i]) ;
      writefour(HRVC6, VRVL2 + 10 * i, blitregs.mod[i]) ;
   }
   for (i=0; i<3; i++)
      writefour(HRVC6B, VRVL2 + 10 * i, blitregs.dat[i]) ;
}
