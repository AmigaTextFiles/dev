/*
 *   This file handles the save/restore function of blitlab to
 *   files, useful for demoing purposes.
 */
#include "structures.h"
extern long gvals[] ;
extern char *bufarr[] ;
/*
 *   Save them to a file.
 */
saveall(num)
int num ;
{
   int i ;
   char name[40] ;
   FILE *f ;

   if (parseall()==0)
      return ;
   sprintf(name, "blitlab.save%d", num) ;
   f = fopen(name, "w") ;
   if (f == NULL)
      return ;
   for (i=0; i<MAXGADG; i++) if (i != GDGLF)
      if (bufarr[i] != NULL) {
         fputs(bufarr[i], f) ;
         putc(10, f) ;
      } else {
         fprintf(f, "%ld\n", gvals[i]) ;
      }
   savebits() ;
   fclose(f) ;
}
/*
 *   Read them from a file.
 */
readall(num)
int num ;
{
   int i ;
   long j ;
   char name[40] ;
   FILE *f ;

   sprintf(name, "blitlab.save%d", num) ;
   f = fopen(name, "r") ;
   if (f == NULL)
      return ;
   for (i=0; i<MAXGADG; i++) if (i != GDGLF)
      if (bufarr[i] != NULL) {
         if (fgets(bufarr[i], 200, f)==NULL)
            error("invalid value in save file") ;
         bufarr[i][strlen(bufarr[i])-1] = 0 ;
         stuff(i, bufarr[i]) ;
      } else {
         if (fscanf(f, "%ld\n", &j) != 1)
            error("invalid numeric value in save file") ;
         if (j != gvals[i])
            flipgadg(i) ;
      }
   loadbits() ;
   fclose(f) ;
   parseall() ;
}
