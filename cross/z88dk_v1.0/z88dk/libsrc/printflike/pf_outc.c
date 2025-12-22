

/*
 * _outc - output a single character
 *         if pf_string is not null send output to a string instead
 */

#include <stdio.h>

#pragma proto HDRPRTYPE
extern void pf_outc(unsigned char c, FILE *fd);
#pragma unproto HDRPRTYPE

#asm
                LIB     fputc

#endasm


extern char *pf_string;
extern char *pf_count;

pf_outc(c, fd)
unsigned char c ;
FILE *fd ;                /* Dodgy? */
{
        if ( pf_string == NULL )
                fputc(c, fd) ;
        else
                *pf_string++ = c ;
        ++pf_count ;
}
