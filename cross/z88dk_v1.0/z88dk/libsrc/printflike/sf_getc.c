/*
 *      Scanf support routines
 *
 *      Added to archive 14/3/99 djm
 *
 */

#include <stdio.h>

#pragma proto HDRPRTYPE

extern unsigned char sf_getc(FILE *fd);

#pragma unproto HDRPRTYPE


/*
 *      STATIC VARIABLES!
 */

unsigned char sf_oldch;
unsigned char *sf_string1;


#asm
        LIB     fgetc
        XDEF    smc_sf_oldch
        XDEF    smc_sf_string1
#endasm

/*
 * _getc - fetch a single character from file
 *         if _String1 is not null fetch from a string instead
 */
unsigned char sf_getc(fd)
FILE *fd ;
{
        unsigned char c ;

        if ( sf_oldch != EOF ) {
                c = sf_oldch ;
                sf_oldch = EOF ;
                return c ;
        }
        else {
                if ( sf_string1 != NULL ) {
                        if ( (c=*sf_string1++) ) return c ;
                        else {
                                --sf_string1 ;
                                return EOF ;
                        }
                }
                else {
                        return fgetc(fd) ;
                }
        }
}
