/*
 * Core routine for integer-only scanf-type functions
 *        only d, o, x, c, s, and u specs are supported.
 */


#include <ctype.h>
#include <stdio.h>

#define ERR (-1)

#pragma proto HDRPRTYPE
extern int scanf1(FILE *, int *);
extern sf_getc(), sf_ungetc(), utoi() ;
#pragma unproto HDRPRTYPE


#asm
        LIB     sf_getc;
        LIB     sf_ungetc
        LIB     utoi
        LIB     isspace
        XREF    smc_sf_oldch
#endasm


extern unsigned char sf_oldch ;


int scanf1(fd, nxtarg)
FILE *fd;
int *nxtarg ;
{
        unsigned char *carg, *ctl, *zunsigned ;
        int *narg, wast, ac, width, ovfl ;
        unsigned char sign, ch, base, cnv;
 

        sf_oldch = EOF ;
        ac = 0 ;
        ctl = *nxtarg-- ;
        while ( *ctl) {
                if ( isspace(*ctl) ) { ++ctl; continue; }
                if ( *ctl++ != '%' ) continue ;
                if ( *ctl == '*' ) { narg = carg = &wast; ++ctl; }
                else                 narg = carg = *nxtarg-- ;
                ctl += utoi(ctl, &width) ;
                if ( !width ) width = 32767 ;
                if ( !(cnv=*ctl++) ) break ;
                while ( isspace(ch=sf_getc(fd)) )
                        ;
                if ( ch == EOF ) {
                        if (ac) break ;
                        else return EOF ;
                }
                sf_ungetc(ch) ;
                switch(cnv) {
                        case 'c' :
                                *carg = sf_getc(fd) ;
                                break ;
                        case 's' :
                                while ( width-- ) {
                                        if ( (*carg=sf_getc(fd)) == EOF ) break ;
                                        if ( isspace(*carg) ) break ;
                                        if ( carg != &wast ) ++carg ;
                                }
                                *carg = 0 ;
                                break ;
                        default :
                                switch(cnv) {
                                        case 'd' : base = 10 ; sign = 0 ; ovfl = 3276 ; break ;
                                        case 'o' : base =  8 ; sign = 1 ; ovfl = 8191 ; break ;
                                        case 'u' : base = 10 ; sign = 1 ; ovfl = 6553 ; break ;
                                        case 'x' : base = 16 ; sign = 1 ; ovfl = 4095 ; break ;
                                        default : return ac ;
                                }
                                *narg = zunsigned = 0 ;
                                while ( width-- && !isspace(ch=sf_getc(fd)) && ch!=EOF ) {
                                        if ( !sign )
                                                if ( ch == '-' ) { sign = -1; continue; }
                                                else sign = 1 ;
                                        if ( ch < '0' ) return ac ;
                                        if ( ch >= 'a') ch -= 87 ;
                                        else if ( ch >= 'A' ) ch -= 55 ;
                                        else ch -= '0' ;
                                        if ( ch >= base || zunsigned > ovfl ) return ac ;
                                        zunsigned = zunsigned * base + ch ;
                                }
                                *narg = sign * zunsigned ;
                }
                ++ac ;
        }
        return ac ;
}
