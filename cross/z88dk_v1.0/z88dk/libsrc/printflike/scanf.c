/*
 * Main interface to scanf-type routines, independent of integer/float
 *
 * scanf(controlstring, arg, arg, ...)  or 
 * sscanf(string, controlstring, arg, arg, ...) or
 * fscanf(file, controlstring, arg, arg, ...) --  formatted read
 *        operates as described by Kernighan & Ritchie
 */


#include <stdio.h>
#include <ctype.h>

#pragma proto HDRPRTYPE
extern scanf();
#pragma unproto HDRPRTYPE


#define EOF (-1)

extern unsigned char *sf_string1;

#asm
        LIB     scanf1
        LIB     getarg
        XREF    smc_sf_string1
        XREF    smc_sgoioblk
#endasm


scanf(args)
int args ;
{
        sf_string1 = NULL ;
        return( scanf1(stdin, getarg() + &args - 1) ) ;
}
