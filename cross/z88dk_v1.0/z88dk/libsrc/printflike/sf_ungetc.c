/*
 *      Scanf support routines
 *
 *      Added to archive 14/3/99 djm
 *
 */

#include <stdio.h>

#pragma proto HDRPRTYPE

extern void sf_ungetc(char ch);

#pragma unproto HDRPRTYPE


/*
 *      STATIC VARIABLES!
 */

unsigned char sf_oldch;


#asm
        XREF    smc_sf_oldch
#endasm

/*
 * unget character assume only one source of characters
 * i.e. does not require file descriptor
 */
void sf_ungetc(ch)
char ch ;
{
        sf_oldch = ch ;
}
