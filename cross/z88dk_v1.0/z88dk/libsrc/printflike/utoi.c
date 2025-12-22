#include <stdio.h>

/*
 * utoi -- convert unsigned decimal string to integer nbr
 *              returns field size, else ERR on error
 */

#define ERR -1

#pragma proto HDRPRTYPE
extern int utoi(char *decstr, int nbr);
#pragma unproto HDRPRTYPE


utoi(decstr, nbr)
char *decstr ;
int *nbr;
{
        int t, d ;

        d = 0 ;
        *nbr = 0 ;
        while ( *decstr >= '0' && *decstr <= '9' ) {
                t = *nbr ;
                t = (10*t) + (*decstr++ - '0') ;
                if ( t >= 0 && *nbr < 0 )
                        return ERR ;
                ++d ;
                *nbr = t ;
        }
        return d ;
}
