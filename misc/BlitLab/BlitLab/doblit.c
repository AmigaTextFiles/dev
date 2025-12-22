/*
 *   This is the routine which actually does the hard blits.  We just get
 *   the blitter, stuff the values, wait for it to finish, disown the
 *   blitter, and get out of there.  In this special version, we also
 *   turn off the display and time the blit, and write the time on the
 *   screen when done.
 */
#include "structures.h"
/*
 *   External values we use.
 */
extern struct blitregs blitregs ;
extern long gvals[] ;
/*
 *   This include file includes the defines for all the blitter functions.
 *   It only allows use of the `blit' operations; for area fills or line
 *   drawing, it will need to be extended.
 *
 *   Information gleaned from the Hardware Reference Manual.
 */
#define BLTADD (0xdff040L)
/*
 *   This structure contains everything we need to know.
 *   Do not do a structure copy into this!  Instead, assign
 *   each field.  The last field assigned must be bltsize; that
 *   starts up the blitter.  Also note that all of these are
 *   write only, and you can't read them.
 */
struct bltstruct {
   short con0 ;
   short con1 ;
   short afwm ;
   short alwm ;
   short cpth, cptl, bpth, bptl, apth, aptl, dpth, dptl ;
   short bltsize ;
   short dmy1, dmy2, dmy3 ;
   short cmod, bmod, amod, dmod ;
   short dmy4, dmy5, dmy6, dmy7 ;
   short cdat, bdat, adat ;
} *blitter = BLTADD ;
/*
 *   The actual routine.  After we own the blitter, we need to wait for
 *   it to finish.
 */
int doblit() {
   int toreturn ;

   if (gvals[GDGSIM])
      return(dosimblit()) ;
   OwnBlitter() ;
   WaitBlit() ;
   blitter->con0 = blitregs.con0 ;
   blitter->con1 = blitregs.con1 ;
   blitter->afwm = blitregs.afwm ;
   blitter->alwm = blitregs.alwm ;
   blitter->apth = blitregs.pth[0] ;
   blitter->bpth = blitregs.pth[1] ;
   blitter->cpth = blitregs.pth[2] ;
   blitter->dpth = blitregs.pth[3] ;
   blitter->aptl = blitregs.ptl[0] ;
   blitter->bptl = blitregs.ptl[1] ;
   blitter->cptl = blitregs.ptl[2] ;
   blitter->dptl = blitregs.ptl[3] ;
   blitter->amod = blitregs.mod[0] ;
   blitter->bmod = blitregs.mod[1] ;
   blitter->cmod = blitregs.mod[2] ;
   blitter->dmod = blitregs.mod[3] ;
   blitter->adat = blitregs.dat[0] ;
   blitter->bdat = blitregs.dat[1] ;
   blitter->cdat = blitregs.dat[2] ;
/*
 *   Wham!  It is the following assignment that starts the blitter.
 */
   blitter->bltsize = blitregs.size ;
   WaitBlit() ;
   toreturn = custom.dmaconr ;
   DisownBlitter() ;
   return(toreturn & DMAF_BLTNZERO ? 1 : 0) ;
}
