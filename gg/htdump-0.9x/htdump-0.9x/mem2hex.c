/***************************************************************************\
**                                                                         **
**  htdump                                                                 **
**                                                                         **
**  Program to make http requests and redirect, save or pipe the output.   **
**  Ideal for automation and debugging.                                    **
**                                                                         **
**                                                                         **
**  By Ren Hoek (ren@arak.cs.hro.nl) Under Artistic License, 2000          **
**                                                                         **
\***************************************************************************/
  
#include "global.h"

void Mem2Hex(void *Mem, unsigned int Size)
{
unsigned int q1, q2;
unsigned char *p=Mem;

fprintf(stderr, "\n          +00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F\n");
fprintf(stderr, "---------+-------------------------------------------------+------------------+\n");

for(q1=0; q1<Size; q1=q1+16)
  {
  fprintf(stderr, "%8X | ", (unsigned int) p);        /* Print memory address */
  for(q2=0; q2<16; q2++)
    {
    if((q1+q2)>=Size)
      {
      fprintf(stderr, "   ");          /* Pad with spaces      */
      continue;
      }
    fprintf(stderr, "%02X ", p[q2]);
    }
  fprintf(stderr, "| ");

  for(q2=0; q2<16; q2++)
    {
    if((q1+q2)>=Size)
      {
      fprintf(stderr, " ");          /* Pad with spaces      */
      continue;
      }
    fprintf(stderr, "%c", ((p[q2]>31 && p[q2]<127) ? p[q2] : '.'));
    }
  p=p+16;
  fprintf(stderr, " |\n");
  }

fprintf(stderr, "---------+-------------------------------------------------+------------------+\n\n");
}
