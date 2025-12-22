/*
 *   Some code to simulate the blitter!  Original code by Dale Luck
 *   Rewritten by Tomas Rokicki, 12 April 1988.
 */
#include "structures.h"
/*
 *   External values we use.  This is where we get all the parameters
 *   from.  Upper case macros are used to reference this structure
 *   by the names used by the hardware; BLTCON0, for instance, expands
 *   to blitregs.con0.
 */
extern struct blitregs blitregs ;
/*
 *   This routine opens a log file if appropriate.
 */
extern FILE *openlogfile() ;
/*
 *   We use a few macros to make the code easier to understand.
 */
#define BLITTING_FORWARD (!(BLTCON1 & BLITREVERSE))
#define FILL_OK (BLTCON1 & FILL_OR)
#define FILL_XOK (BLTCON1 & FILL_XOR)
#define SRCA_ENABLED (BLTCON0 & SRCA)
#define SRCB_ENABLED (BLTCON0 & SRCB)
#define SRCC_ENABLED (BLTCON0 & SRCC)
#define DEST_ENABLED (BLTCON0 & DEST)
/*
 *   This macro takes two 16-bit words and returns a 32-bit word
 *   formed by concatenating the two words.
 */
#define CATWORDS(a,b) ((((long)(a))<<16)+(unsigned short)(b))
/*
 *   This is the blitter simulator for running the blitter when not
 *   in the line mode.
 */
int donotlineblit() {
   long aptr, bptr, cptr, dptr ;      /* our pointer variables */
   short a_old, b_old ;               /* shifting old values */
   short a_new, b_new ;               /* the input values */
   short a_masked ;                   /* a after masking */
   short a_hold, b_hold, c_hold ;     /* values we build up */
   short h, v ;                       /* indices for iteration */
   short hsize, vsize ;               /* how much to blit */
   short zeroflag ;                   /* see any non-zeros? */
   short amod, bmod, cmod, dmod ;     /* the actual values used */
   short fill_bit ;                   /* for the fill mode */
   short tiny_inc ;                   /* next address (2 or -2) */
   short ashift, bshift ;             /* shift values */
   short minterm ;                    /* the actual function we evaluate */
   short result ;                     /* the value to stuff in d */
   short old_result ;                 /* the blitter is pipelined */
   long old_address ;                 /* where to stuff it */
   short i ;                          /* general purpose iterator */
   FILE *f ;                          /* debug output */

/*
 *   Now we initialize our pointer variables, by concatenating the
 *   high and low order words, and clearing the least significant
 *   bit.  The blitter ignores that least significant bit.
 *   Note that the words concatenated in these four statements are
 *   actually adjacent in the actual blitter layout, so they can be
 *   referenced by a single longword read or write.
 */
   aptr = CATWORDS(BLTAPTH,BLTAPTL) & ~1 ;
   bptr = CATWORDS(BLTBPTH,BLTBPTL) & ~1 ;
   cptr = CATWORDS(BLTCPTH,BLTCPTL) & ~1 ;
   dptr = CATWORDS(BLTDPTH,BLTDPTL) & ~1 ;
/*
 *   Our modulos also lose their least significant bit.  Note that
 *   they are treated as signed 16 bit values.
 */
   amod = BLTAMOD & ~1 ;
   bmod = BLTBMOD & ~1 ;
   cmod = BLTCMOD & ~1 ;
   dmod = BLTDMOD & ~1 ;
/*
 *   Next, we extract some information from our control words.
 *   Note that if either the hsize or vsize are zero, their
 *   maximum values are used instead.
 */
   hsize = BLTSIZE & HSIZEMASK ;
   if (hsize == 0)
      hsize = 64 ;
   vsize = (BLTSIZE >> HSIZEBITS) & VSIZEMASK ;
   if (vsize == 0)
      vsize = 1024 ;
/*
 *   We don't want to ever print out more than 32K of debug; there's no
 *   reason, so we turn tracing off if hsize*vsize > 218.
 */
   if (hsize * (long)vsize > 218)
      f = NULL ;
   else
      f = openlogfile() ;
   ashift = (BLTCON0 >> ASHIFTSHIFT) & 0xf ;
   bshift = (BLTCON1 >> BSHIFTSHIFT) & 0xf ;
   minterm = BLTCON0 & 0xff ;
/*
 *   We initialize the zero flag, the old word registers for the
 *   shifters, and get the initial data values for the A, B, and
 *   C channels.
 */
   zeroflag = 0 ;
   a_old = 0 ;
   b_old = 0 ;
   old_address = -1 ;
   a_new = BLTADAT ;
   b_new = BLTBDAT ;
   c_hold = BLTCDAT ;
/*
 *   If we are blitting forward, each time around each DMA channel's
 *   pointer is increased by 2.  Otherwise, it is decremented by 2.
 *   In addition, when blitting backwards, our modulos are subtracted,
 *   so we take care of that by negating them here.
 */
   if (BLITTING_FORWARD) {
      tiny_inc = 2 ;
   } else {
      tiny_inc = -2 ;
      amod = - amod ;
      bmod = - bmod ;
      cmod = - cmod ;
      dmod = - dmod ;
   }
/*
 *   Debug stuff
 */
   if (f) {
      fprintf(f, "\namod = %04x bmod = %04x cmod = %04x dmod = %04x\n",
              amod, bmod, cmod, dmod) ;
      fprintf(f, "adat = %04x bdat = %04x cdat = %04x size = %04x\n",
              a_new, b_new, c_hold, BLTSIZE) ;
      fprintf(f, "con0 = %04x con1 = %04x afwm = %04x alwm = %04x\n",
              BLTCON0, BLTCON1, BLTAFWM, BLTALWM) ;
      logflagdata(f) ;
   }
/*
 *   We iterate through the rows, and print debug stuff each time.
 */
   for (v=0; v<vsize; v++) {
      if (f)
         fprintf(f, ">>>Row %d\n", v) ;
/*
 *   At the beginning of each row, the fill bit gets set to its initial
 *   value from the control register.
 */
      fill_bit = (BLTCON1 & FILL_CARRYIN ? 0xffff : 0) ;
/*
 *   Now we run through the columns, again printing debug information
 *   each time around.
 */
      for (h=0; h<hsize; h++) {
         if (f)
            fprintf(f, "aptr = %08lx bptr = %08lx cptr = %08lx dptr = %08lx\n",
                    aptr, bptr, cptr, dptr) ;
/*
 *   For each of the three sources, we fetch values if they are
 *   enabled, and then increment (or decrement) the pointers.
 *   I'm not sure if the pointers are actually incremented or not
 *   if the DMA channels are turned off.
 */
         if (SRCA_ENABLED)
            a_new = *(short *)aptr ;
         aptr += tiny_inc ;
         if (SRCB_ENABLED)
            b_new = *(short *)bptr ;
         bptr += tiny_inc ;
         if (SRCC_ENABLED)
            c_hold = *(short *)cptr ;
         cptr += tiny_inc ;
/*
 *   Debug stuff
 */
         if (f)
            fprintf(f, "adat = %04x bdat = %04x cdat = %04x\n",
                    a_new, b_new, c_hold) ;
/*
 *   If we are at the first word on a line, we mask with afwm.
 *   If we are at the last, we mask with alwm.  Note that if the
 *   width is 1, both masks are used.
 */
         a_masked = a_new ;
         if (h == 0)
            a_masked &= BLTAFWM ;
         if (h == hsize - 1)
            a_masked &= BLTALWM ;
/*
 *   Now we concatenate our old values with the new values and shift
 *   them the appropriate amounts to determine the actual values as
 *   input to our function generator.  Note that in decrement mode, the
 *   shifts are backwards.  Then, we save the old values for the next
 *   time around.
 */
         if (BLITTING_FORWARD) {
            a_hold = CATWORDS(a_old,a_masked) >> ashift ;
            b_hold = CATWORDS(b_old,b_new) >> bshift ;
         } else {
            a_hold = CATWORDS(a_masked,a_old) >> (16 - ashift) ;
            b_hold = CATWORDS(b_new,b_old) >> (16 - bshift) ;
         }
         a_old = a_masked ;
         b_old = b_new ;
/*
 *   Our minterm calculation is next.
 */
         result = (minterm & 1 ? ~a_hold & ~b_hold & ~c_hold : 0)
                 | (minterm & 2 ? ~a_hold & ~b_hold & c_hold : 0)
                 | (minterm & 4 ? ~a_hold & b_hold & ~c_hold : 0)
                 | (minterm & 8 ? ~a_hold & b_hold & c_hold : 0)
                 | (minterm & 16 ? a_hold & ~b_hold & ~c_hold : 0)
                 | (minterm & 32 ? a_hold & ~b_hold & c_hold : 0)
                 | (minterm & 64 ? a_hold & b_hold & ~c_hold : 0)
                 | (minterm & 128 ? a_hold & b_hold & c_hold : 0) ;
/*
 *   If we are in the fill mode, we do the appropriate thing.  Note that
 *   fill only works properly when in the descending mode.  FILL_XOK
 *   turns off bits which toggle fill_bit to zero.
 */
         if (FILL_OK || FILL_XOK)
            for (i=1; i; i <<= 1)
               if (result & i) {
                  if (FILL_XOK && fill_bit)
                     result &= ~i ;
                  fill_bit = ~fill_bit ;
               } else
                  result |= (i & fill_bit) ;
/*
 *   Debug stuff.
 */
         if (f)
            fprintf(f, "aval = %04x bval = %04x cval = %04x dval = %04x\n",
                    a_hold, b_hold, c_hold, result) ;
/*
 *   We or in our result to our zero flag; this way, if we ever hit a zero
 *   result, zeroflag will be non-zero.
 */
         zeroflag |= result ;
/*
 *   The actual writing is pipelined one stage; if we buffered a write
 *   last time around, we write it here.
 */
         if (old_address != -1) {
            if (f)
               fprintf(f, "***  [%08lx] <-- %04x\n", old_address, old_result) ;
            screenupdate(old_address, old_result) ;
         }
/*
 *   If the destination is enabled, we buffer up a value to be written the
 *   next time around.  Again, the pointer might not really be incremented
 *   if the destination is disabled.
 */
         if (DEST_ENABLED) {
            old_result = result ;
            old_address = dptr ;
         }
         dptr += tiny_inc ;
      }
/*
 *   Next, we add the modulos to all the pointers at the end of each row.
 */
      aptr += amod ;
      bptr += bmod ;
      cptr += cmod ;
      dptr += dmod ;
   }
/*
 *   Finally, we are at the end of the blit; if we still have a write in
 *   the pipeline, we write it here.
 */
   if (old_address != -1) {
      if (f)
         fprintf(f, "***  [%08lx] <-- %04x\n", old_address, old_result) ;
      screenupdate(old_address, old_result) ;
   }
   if (f)
      fclose(f) ;
/*
 *   If we ever saw a non-zero value, then zeroflag is set, so we return
 *   a zero; otherwise, we return a 1.
 */
   return(!zeroflag) ;
}
/*
 *   And this is the simulator for when we are in the line mode.
 *   (Oh, shucks, you mean it's not written yet?)
 */
int dolineblit() {
   error("we can't simulate line blits yet.") ;
   Delay(50L) ;
   return(0) ;
}
/*
 *   The actual routine.  All we do is call the appropriate real
 *   routine, depending on whether the line mode is set or not.
 */
int dosimblit() {
   error("Simulating . . .") ;
   if (BLTCON1 & LINEMODE)
      return(dolineblit()) ;
   else
      return(donotlineblit()) ;
}
