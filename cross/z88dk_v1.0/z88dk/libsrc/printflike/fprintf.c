/*
 *      printf - core routines for printf, sprintf, fprintf
 *               used by both integer and f.p. versions
 *
 *      Compile with -m option
 *
 *      R M Yorston 1987
 */


#include <stdio.h>

#asm

                LIB  printf1
                LIB  getarg 

#endasm


/*
 * printf(controlstring, arg, arg, ...)  or 
 * sprintf(string, controlstring, arg, arg, ...) or
 * fprintf(file, controlstring, arg, arg, ...) -- formatted print
 *        operates as described by Kernighan & Ritchie
 *        only d, x, c, s, and u specs are supported.
 */

/* These are placed in z88_crt0.asm */

extern char *pf_string ;
extern int pf_count ;

fprintf(args)
int args ;
{
        int *nxtarg ;

        pf_string = NULL ;
        nxtarg = getarg() + &args ;
        return( printf1( *(--nxtarg), --nxtarg ) ) ;
}



