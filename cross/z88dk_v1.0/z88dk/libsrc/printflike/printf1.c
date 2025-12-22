/*
 *      printf1 - generic _printf routine for integer-only operation
 *
 *
 *      R M Yorston 1987
 */


#include <stdio.h>

#define NULL 0
#define ERR -1

#asm

                LIB utoi
                LIB itod
                LIB itou
                LIB itox
                LIB pf_outc

#endasm


extern char *pf_string ;
extern int pf_count ;
#pragma proto HDRPRTYPE
extern utoi(), itod(), itou(), itox(), pf_outc() ;
#pragma unproto HDRPRTYPE

printf1(fd, nxtarg)
int fd ;
int *nxtarg ;
{
        int i, prec, preclen, len ;
        char c, right, str[7], pad;
        int width ;
        char *sptr, *ctl, *cx ;

        pf_count = 0 ;
        ctl = *nxtarg ;
        while ( c = *ctl++ ) {
                if (c != '%' ) {
                        pf_outc(c, fd) ;
                        continue ;
                }
                if ( *ctl == '%' ) {
                        pf_outc(*ctl++, fd) ;
                        continue ;
                }
                cx = ctl ;
                if ( *cx == '-' ) {
                        right = 0 ;
                        ++cx ;
                }
                else
                        right = 1 ;
                if ( *cx == '0' ) {
                        pad = '0' ;
                        ++cx ;
                }
                else
                        pad = ' ' ;
                if ( (i=utoi(cx, &width)) >= 0 )
                        cx += i ;
                else
                        continue  ;
                if (*cx=='.') {
                        if ( (preclen=utoi(++cx, &prec)) >= 0 )
                                cx += preclen ;
                        else
                                continue ;
                }
                else
                        preclen = 0 ;
                sptr = str ;
                c = *cx++ ;
                i = *(--nxtarg) ;
                switch(c) {
                        case 'd' :
                                itod(i, str, 7) ;
                                break ;
                        case 'x' :
                                itox(i, str, 7) ;
                                break ;
                        case 'c' :
                                str[0] = i ;
                                str[1] = NULL ;
                                break ;
                        case 's' :
                                sptr = i ;
                                break ;
                        case 'u' :
                                itou(i, str, 7) ;
                                break ;
                        default:
                                continue ;
                }
                ctl = cx ; /* accept conversion spec */
                if ( c != 's' )
                        while ( *sptr == ' ' )
                                ++sptr ;
                len = -1 ;
                while ( sptr[++len] )
                        ; /* get length */
                if ( c == 's' && len>prec && preclen>0 )
                        len = prec ;
                if (right)
                        while ( ((width--)-len) > 0 )
                                pf_outc(pad, fd) ;
                while ( len ) {
                        pf_outc(*sptr++, fd) ;
                        --len ;
                        --width ;
                }
                while ( ((width--)-len) > 0 )
                        pf_outc(pad, fd) ;
        }
        if (pf_string != 0) *pf_string = '\000' ;
        return(pf_count) ;
}
