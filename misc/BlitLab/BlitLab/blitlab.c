/*
 *   This is the main routine from BlitLab.
 */
#include "structures.h"
/*
 *   Here are all the globals we use.  (Yuck!  Globals!)
 */
struct Window *mywindow ;
struct GfxBase *GfxBase ;
struct IntuitionBase *IntuitionBase ;
struct RastPort *myrp ;
char strings[900] ;
char *bufarr[MAXGADG] ;
long gvals[MAXGADG] ;
struct Gadget *gadgets[MAXGADG] ;
char errorbuf[140] ;
short *realbits ;
struct blitregs blitregs ;
int custscreen ;
/*
 *   Externals we use:
 */
extern int blitsafe() ;
extern int doblit() ;
/*
 *   Some statics to this module.
 */
static int updatethem ;
/*
 *   Errors go through here.  Currently, we write to the CLI window.
 *   Later, we will write to the title bar of the window.
 */
error(s)
char *s ;
{
   if (mywindow == NULL || *s == '!')
      printf("blitlab: %s\n", s) ;
   else {
      SetWindowTitles(mywindow, s, -1L) ;
   }
   if (*s == '!')
      cleanup() ;
}
/*
 *   This routine handles a gadget selection.
 */
handlegadget(gp)
register struct Gadget *gp ;
{
   static int gocount = 0 ;

   if (bufarr[gp->GadgetID] == NULL)
   switch(gp->GadgetID) {
      case GDGPNTREG:
      case GDGLINE:
      case GDGDESC:
      case GDGFCI:
      case GDGIFE:
      case GDGEFE:
      case GDGUSEA:
      case GDGUSEB:
      case GDGUSEC:
      case GDGUSED:
      case GDGOVF:
      case GDGSIGN:
      case GDGSIM:
         flipgadg(gp->GadgetID) ;
         break ;
      case GDGCALC:
         parseall() ;
         updatethem = 0 ;
         if (blitsafe()) {
            error("Blit safe.") ;
         } else {
            error("Blit unsafe.") ;
         }
         break ;
      case GDGSETUP:
         setupline() ;
         parseall() ;
         break ;
      case GDGGO:
         gocount += 2 ;
         parseall() ;
         updatethem = 0 ;
         if (!blitsafe() && gocount < 3) {
            error("Blit unsafe---hit again to override") ;
         } else {
            if (doblit())
               error("Zero flag SET") ;
            else
               error("Zero flag CLEAR") ;
            updatebits() ;
         }
         break ;
      case GDGUNDO:
         undobits() ;
         break ;
      default:
         error("! bad value in gadget switch") ;
         break ;
   }
   if (gocount > 0)
      gocount-- ;
}
/*
 *   The main routine, no arguments.  Sets things up, and then goes
 *   through the standard Intuition message loop.
 *
 *   It may look like I'm setting message to NULL and checking it and
 *   everything all over, but that is so I can introduce interruptibility
 *   into some operations later, if I choose.
 */
struct IntuiMessage *message = NULL ;
main(argc, argv)
int argc ;
char *argv[] ;
{
   struct IntuiMessage *message = NULL ;
   int x, y ;
   int mousemoved = 0 ;
   int getouttahere = 0 ;
   int selectdown = 0 ;
   int menudown = 0 ;
   int bam ;
   int ox, oy ;
   char *p ;
   int on ;

   while (argc > 1) {
      argv++ ;
      p = *argv ;
      if (*p == '-')
         p++ ;
      if (*p == 'c' || *p == 'C')
         custscreen = 1 ;
      else {
         printf("%s\n", BANNER) ;
         printf("Usage:  blitlab [-c]\n") ;
         printf("   -c:  Open on custom screen\n") ;
         cleanup() ;
      }
      argc-- ;
   }
   initialize() ;
   while (1) {
      mousemoved = 0 ;
      bam = 0 ;
      if (message == NULL)
         WaitPort(mywindow->UserPort) ;
      while (message || (message = 
                       (struct IntuiMessage *)GetMsg(mywindow->UserPort))) {
         x = message->MouseX ;
         y = message->MouseY ;
         
         if (message->Class == MOUSEMOVE) {
            ReplyMsg(message) ;
            message = NULL ;
            mousemoved = 1 ;
         } else {
            if (message->Class == MOUSEBUTTONS) {
               selectdown = (message->Code == SELECTDOWN) ;
               menudown = (message->Code == MENUDOWN) ;
               bam = 1 ;
            } else if (message->Class == GADGETDOWN || 
                       message->Class == GADGETUP) {
               updatethem = 1 ;
               handlegadget((struct Gadget *)(message->IAddress)) ;
            } else if (message->Class == CLOSEWINDOW) {
               getouttahere = 1 ;
            } else if (message->Class == VANILLAKEY) {
               if (1 <= message->Code && message->Code <= 26)
                  saveall(message->Code) ;
               else if ('a' <= message->Code && message->Code <= 'z')
                  readall(message->Code - 'a' + 1) ;
               else if ('A' <= message->Code && message->Code <= 'Z')
                  readall(message->Code - 'Z' + 1) ;
            } else
               error("! undefined message class") ;
            ReplyMsg(message) ;
            message = NULL ;
         }
      }
      if (getouttahere)
         break ;
      if (updatethem) {
         parseall() ;
         updatethem = 0 ;
      }
      x = (x - HBITSTART + 2) / 6 ;
      y = (y - VBITSTART) / 3 ;
      if (y < 32 && x < 96 && x >= 0 && y >= 0) {
         if (gvals[GDGPNTREG]) {
            if (bam) {
               if (selectdown || menudown) {
                  ox = x ;
                  oy = y ;
                  on = selectdown ;
               } else {
                  preg(ox, oy, x, y, on) ;
               }
            }
         } else {
            if (selectdown || menudown)
               pdot(x, y, selectdown) ;
         }
         if (message != NULL || (message = 
               (struct IntuiMessage *)GetMsg(mywindow->UserPort))) ;
         else
            updatepos(x, y) ;
      }      
   }
   cleanup() ;
}
/*
 *   This routine gives us a log file, if appropriate.
 */
char filename[120] ;
FILE *openlogfile() {
   char *p, *q ;
   FILE *f ;

   f = NULL ;
   p = bufarr[GDGLF] ;
   if (p) {
      while (*p == ' ')
         p++ ;
      for (q = filename; *p > ' '; q++, p++)
         *q = *p ;
      *q = 0 ;
      if (filename[0]!=0)
         f = fopen(filename, "a") ;
   }
   return(f) ;
}
/*
 *   This routine writes out additional information about the
 *   blitter variables.
 */
static char *flags[] = { "LINE", "DESC", "FCI", "IFE", "EFE", "OVF", "SIGN" } ;
logflagdata(f)
FILE *f ;
{
   unsigned short t ;
   unsigned short con0, con1 ;

   con0 = blitregs.con0 ;
   con1 = blitregs.con1 ;
   fprintf(f, "ASH = %d BSH = %d ", con0 >> 12, con1 >> 12) ;
   if (con0 & SRCA)
      fprintf(f, "SRCA ") ;
   if (con0 & SRCB)
      fprintf(f, "SRCB ") ;
   if (con0 & SRCC)
      fprintf(f, "SRCC ") ;
   if (con0 & DEST)
      fprintf(f, "DEST ") ;
   fprintf(f, "\nFunction = %d (%s)\nFlags:  ", con0 & 255, bufarr[GDGFUNC]) ;
   for (t=0; t<7; t++)
      if (con1 & (1 << t))
         fprintf(f, "%s ", flags[t]) ;
   fprintf(f, "\n") ;
}
