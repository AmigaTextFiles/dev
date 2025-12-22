/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ivec.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*              ivec.c           RD, 18.12.89 */

/*	RD, 11.9.91, vecsri hinzugefuegt	*/
/*	RD, 27.9.91, veceq, vecgt, vecsr1, vecsri jetzt in iplace.c */

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

#ifdef USE_DOUBLEPLACE

#ifndef ATARI
#ifndef __PARC__
int cvadd(sum, a, b, counta, countb)
        register pPLACE sum, a, b; 
        register int counta, countb;
        /* sum[]=a[counta]+b[countb]; 
	   sum soll auch Uebertraege fassen */
{       register DOUBLEPLACE accu = 0;
	register int countmax;
	if (counta>countb) {
		countmax=counta;
		counta-=countb;
	        for ( ; countb>0; countb--) {
        	        accu+=*a++;
                	accu+=*b++;
	                *sum++=accu;
        	        accu >>= LOGRADIX;
        	}
	        for ( ; counta>0; counta--) {
        	        accu+=*a++;
	                *sum++=accu;
        	        accu >>= LOGRADIX;
    		}
	} else {
		countmax=countb;
		countb-=counta;
	        for ( ; counta>0; counta--) {
        	        accu+=*a++;
                	accu+=*b++;
	                *sum++=accu;
        	        accu >>= LOGRADIX;
        	}
	        for ( ; countb>0; countb--) {
        	        accu+=*b++;
	                *sum++=accu;
        	        accu >>= LOGRADIX;
    	}	}
	*sum=accu;
	if (accu)
		return countmax+1;
	else
		return countmax;
}	/* cvadd */
#endif
#endif

#ifndef ATARI
#ifndef __PARC__
void cvecsubto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[]-=b[count]; a muss groesser oder gleich b sein */
{       register SDOUBLEPLACE accu = 0;
        for ( ; count>0; count--) {
                accu+=*a;
                accu-=*b++;
                *a++=accu;
                accu >>= LOGRADIX;
        }
        while (accu) {
                accu+=*a;
                *a++=accu;
                accu >>= LOGRADIX;
        }
}		/* cvecsubto */
#endif
#endif

#ifndef __PARC__
#ifndef ATARI
int cvsub(diff, a, b, counta, countb)
	register pPLACE diff, a, b;
	register int counta, countb;
	/* diff[]=a[counta]-b[countb]; a>=b */
{       register SDOUBLEPLACE accu = 0;
	register int l=counta;
	counta-=countb;
	for ( ; countb>0; countb--) {
		accu+=*a++;
		accu-=*b++;
		*diff++=accu;
		accu>>=LOGRADIX;
	}
	while (accu) {
		accu+=*a++;
		*diff++=accu;
		accu >>= LOGRADIX;
		counta--;
	}
	for ( ; counta>0; counta--) {
		*diff++=*a++;
	}
	diff--;
	while ((l>0)&&(! *diff)) {
		diff--;
		l--;
	}
	return l;
}		/* cvsub */
#endif
#endif

PLACE vecaddto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[count]+=b[count]; return carry; */
{       register DOUBLEPLACE accu = 0;
        for ( ; count>0; count--) {
                accu+=*a;
                accu+=*b++;
                *a++=accu;
                accu >>= LOGRADIX;
        }
        return accu;
}

PLACE vecsubto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[count]-=b[count]; return carry; 0 oder 1 */
{       register SDOUBLEPLACE accu = 0;
        for ( ; count>0; count--) {
                accu+=*a;
                accu-=*b++;
                *a++=accu;
                accu >>= LOGRADIX;
        }
        return (accu & 1);
}

#ifndef __PARC__
#ifndef ATARI
#ifdef __GNUC__
PLACE vecdiv(PLACE *q, PLACE *a, PLACE d, int count)
#else
PLACE vecdiv(q, a, d, count)
        register PLACE *q, *a;
	register PLACE d;
        register int count;
#endif
        /* q[count]=a[count]/d; return a[count]%d; */
{       register DOUBLEPLACE accu=0;
        for (q+=count, a+=count; count>0; count--) {
                accu <<= LOGRADIX;
                accu+=*--a;
                *--q=accu/d;
                accu%=d;
        }
        return accu;
}
#endif
#endif

#ifndef __PARC__
#ifndef ATARI
#ifdef __GNUC__
PLACE vecmul(PLACE *product, PLACE *a, PLACE m, int count)
#else
PLACE vecmul(product, a, m, count)
        register PLACE *product, *a, m;
        register int count;
#endif
        /* product[count]=m*a[count]; return carry; */
{       register DOUBLEPLACE accu=0;
	register DOUBLEPLACE prod;
        for ( ; count>0; count--) {
		prod=*a++;
		prod*=m;
                accu+=prod;
                *product++ = accu;
                accu >>= LOGRADIX;
        }
        return accu;
}		/* vecmul */
#endif
#endif

#ifndef ATARI
#ifndef __PARC__
#ifdef __GNUC__
PLACE vecmuladd(PLACE *paccu, PLACE *a, PLACE m, int count)
#else
PLACE vecmuladd(paccu, a, m, count)
        register PLACE *paccu, *a, m; 
        register int count;
#endif
        /* paccu[count] += m*a[count]; return carry; */
{       register DOUBLEPLACE accu=0;
	register DOUBLEPLACE prod;
        for ( ; count>0; count--) {
                accu+=*paccu;
		prod=*a++;
		prod*=m;
                accu+=prod;
                *paccu++ = accu;
                accu >>= LOGRADIX;
        }
        return accu;
}		/* vecmuladd */
#endif
#endif

#ifndef __PARC__
#ifndef ATARI
#ifdef __GNUC__
PLACE vecmulsub(PLACE *paccu, PLACE *a, PLACE m, int count)
#else
PLACE vecmulsub(paccu, a, m, count)
        register PLACE *paccu, *a, m;
        register int count;
#endif
        /* paccu[count+1] -= m*a[count]; return carry; 
        carry ist 0 oder 1 */
{       register DOUBLEPLACE accu;
        register SDOUBLEPLACE saccu=0;
        for ( ; count>0; count--) {
                accu =*a++;
		accu*=m;
                saccu=saccu + *paccu - (PLACE)accu;
                *paccu++ = saccu;
                saccu >>= LOGRADIX;
                accu>>=LOGRADIX;
                saccu-=accu;
        }
        saccu += *paccu;
        *paccu = saccu;
        saccu >>= LOGRADIX;
        return (saccu & 1);
}
#endif
#endif

#endif
