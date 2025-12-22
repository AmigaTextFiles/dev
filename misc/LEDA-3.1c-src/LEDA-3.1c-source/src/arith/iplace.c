/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iplace.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*              iplace.c           RD, 24.09.91 	*/
/* 	Dies ersetzt irv.c!				*/

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

#ifdef USE_DOUBLEPLACE

#ifdef __GNUC__
PLACE PLACEadd(PLACE a, PLACE b, PLACE carry, PLACE *sum)
#else
PLACE PLACEadd(a, b, carry, sum)
	PLACE a, b, carry, *sum;
#endif
	/* *sum=a+b+carry, return Uebertrag */
{	register DOUBLEPLACE accu = 0;
        accu = a;
        accu += b;
        accu += carry;
        *sum = accu;
        return accu >> LOGPLACE;
}

#ifdef __GNUC__
PLACE PLACEsub(PLACE a, PLACE b, PLACE carry, PLACE *diff)
#else
PLACE PLACEsub(a, b, carry, diff)
        PLACE a, b, carry, *diff;
#endif
	/* *diff=a-b-carry, return Uebertrag 0 oder 1 */
{       register DOUBLEPLACE accu = 0;
        accu = a;
        accu -= b;
        accu -= carry;
        *diff = accu;
        accu >>= LOGPLACE;
        return accu & 1;
}

#ifdef __GNUC__
PLACE PLACEmuladd(PLACE a, PLACE b, PLACE carry, PLACE *paccu)
#else
PLACE PLACEmuladd(a, b, carry, paccu)
	PLACE a, b, carry, *paccu;
#endif
	/* *paccu=*paccu+a*b+carry, return Uebertrag */
{       register DOUBLEPLACE accu = 0;
        accu = a;
        accu *= b;
        accu += *paccu;
        accu += carry;
        *paccu = accu;
        return accu >> LOGPLACE;
}

#ifndef __PARC__
#ifdef __GNUC__
PLACE PLACEmul(PLACE a, PLACE b, PLACE carry, PLACE *paccu)
#else
PLACE PLACEmul(a, b, carry, paccu)
        PLACE a, b, carry, *paccu; 
#endif
	/* *paccu=a*b+carry, return Uebertrag */
{       register DOUBLEPLACE accu = 0;
        accu = a;
        accu *= b;
        accu += carry;
        *paccu = accu;
        return accu >> LOGPLACE;
}
#endif

#ifdef __GNUC__
PLACE PLACEmulsub(PLACE a, PLACE b, PLACE carry, PLACE *paccu) 
#else
PLACE PLACEmulsub(a, b, carry, paccu) 
        PLACE a, b, carry, *paccu; 
#endif
	/* *paccu=*paccu-a*b-carry, return Uebertrag */
{       register SDOUBLEPLACE saccu = 0;
	register DOUBLEPLACE prod;
        prod = a;
        prod *= b;
        prod += carry;
        saccu = *paccu;
	saccu-=(PLACE) prod;
	prod>>=LOGRADIX;
	*paccu=saccu;
	saccu>>=LOGRADIX;
	prod += (saccu & 1);
        return prod;
}

#ifndef __PARC__
#ifdef __GNUC__
PLACE PLACEdiv(PLACE h, PLACE l, PLACE n, PLACE *q)
#else
PLACE PLACEdiv(h, l, n, q)
	PLACE h, l, n, *q;
#endif
	/* h*RADIX+l / n ergibt Quotient *q, return Rest */
        /* Division mit Rest
              Voraussetzung:     h < n                */
{       register DOUBLEPLACE accu = 0;
        accu = (h<<LOGPLACE) | l;
        *q = accu / n;
        return accu % n;
}
#endif
#endif

/**************************************************************/

#ifdef USE_IF_IN_ADD_AND_SUB

PLACE PLACEadd(a, b, carry, sum)
	PLACE a, b, carry, *sum;
	/* *sum=a+b+carry, return Uebertrag */
{	PLACE accu;
        accu = a + b + carry;
        *sum = accu;
	if (accu < a)
		return 1;
	else
		return 0;
}

PLACE PLACEsub(a, b, carry, diff)
        PLACE a, b, carry, *diff;
	/* *diff=a-b-carry, return Uebertrag 0 oder 1 */
{       PLACE accu;
        accu = a-b-carry;
        *diff = accu;
	if (accu > a)
		return 1;
	else
		return 0;
}

#endif

#ifndef USE_SPARC_ASM
#ifdef sparc
#ifndef USE_DOUBLEPLACE

#define LPM1 (LOGPLACE-1)

PLACE PLACEdiv(h, l, n, q)
	PLACE h, l, n, *q;
	/* h*RADIX+l / n ergibt Quotient *q, return Rest */
        /* Division mit Rest
              Voraussetzung:     h < n                */
{       register PLACE qd = 0, carry;
	register int i;
	for (i=0; i<LOGPLACE; i++) {
		carry=h>>LPM1;
		h = (h<<1) | (l>>LPM1);
		l = l<<1;
		qd<<=1;
		if (carry || h>=n) {
			qd+=1;
			h-=n;
	}	}
	*q = qd;
	return h;
}

#endif
#endif
#endif

/***************************************************************/

#ifndef ATARI
BOOLEAN veceq(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* return a[count]==b[count]; */
{       for ( ; count>0; count--)
                if (*a++ != *b++)
                        return FALSE;
        return TRUE;
}
#endif

#ifndef ATARI
BOOLEAN vecgt(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* return a[count]>b[count] lexikographisch */
{       for (a+=count, b+=count; count>0; count--) {
		register PLACE aa, bb;
		aa=*--a;
		bb=*--b;
                if (aa > bb)
                        return TRUE;
                else if (aa < bb)
                        return FALSE;
	}
        return FALSE;
}
#endif

#ifndef ATARI
#ifndef __PARC__
BOOLEAN vecsr1(u, l)
	register PLACE * u;
	register int l;
/*	b=u[l]%2; u[l]/=2; return b; */
{	register PLACE b, bold, c;
	u=u + l;
	bold=0;
	while(l) {
		b=*--u;
		c=b>>1;
		c|=(bold<<(LOGRADIX-1));
		bold=b;
		*u=c;
		l--;
	}
	b&=1;
	return (BOOLEAN) b;
}		/* vecsr1 */
#endif
#endif

#ifndef __PARC__
#ifndef ATARI
void vecsri(u, l, i)
	register PLACE * u;
	register int l;
	register int i;
/*	b=u[l]%2^i; u[l]/=2^i; 	i<LOGRADIX */
{	register PLACE b, bold, c;
	u=u + l;
	bold=0;
	while(l) {
		b=*--u;
		c=b>>i;
		c|=(bold<<(LOGRADIX-i));
		bold=b;
		*u=c;
		l--;
	}
}		/* vecsri */
#endif
#endif

/**************************************************************/

#ifndef USE_DOUBLEPLACE

int cvadd(sum, a, b, counta, countb)
        register pPLACE sum, a, b; 
        register int counta, countb;
        /* sum[]=a[counta]+b[countb]; 
	   sum soll auch Uebertraege fassen */
{       register PLACE carry=0;
	register int countmax;
	if (counta>countb) {
		countmax=counta;
		counta-=countb;
	        for ( ; countb>0; countb--)
			carry=PLACEadd(*a++, *b++, carry, sum++);
	        for ( ; counta>0; counta--)
			carry=PLACEadd(*a++, 0, carry, sum++);
	} else {
		countmax=countb;
		countb-=counta;
	        for ( ; counta>0; counta--)
			carry=PLACEadd(*a++, *b++, carry, sum++);
	        for ( ; countb>0; countb--)
			carry=PLACEadd(0, *b++, carry, sum++);
    	}
	*sum=carry;
	if (carry)
		return countmax+1;
	else
		return countmax;
}	/* cvadd */

#ifndef USE_SPARC_ASM
void cvecsubto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[]-=b[count]; a muss groesser oder gleich b sein */
{       register PLACE carry=0;
        for ( ; count>0; count--) {
		carry=PLACEsub(*a, *b++, carry, a);
		a++;
	}
        while (carry) {
		carry=PLACEsub(*a, 0, carry, a);
		a++;
	}
}		/* cvecsubto */
#endif

int cvsub(diff, a, b, counta, countb)
	register pPLACE diff, a, b;
	register int counta, countb;
	/* diff[]=a[counta]-b[countb]; a>=b */
{       register PLACE carry=0;
	register int l=counta;
	counta-=countb;
	for ( ; countb>0; countb--)
		carry=PLACEsub(*a++, *b++, carry, diff++);
	while (carry) {
		carry=PLACEsub(*a++, 0, carry, diff++);
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

PLACE vecaddto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[count]+=b[count]; return carry; */
{       register PLACE carry=0;
        for ( ; count>0; count--) {
		carry=PLACEadd(*a, *b++, carry, a);
		a++;
	}
        return carry;
}

PLACE vecsubto(a, b, count)
        register PLACE *a, *b; 
        register int count;
        /* a[count]-=b[count]; return carry; 0 oder 1 */
{       register PLACE carry=0;
        for ( ; count>0; count--) {
		carry=PLACEsub(*a, *b++, carry, a);
		a++;
	}
        return (carry & 1);
}

#ifdef __GNUC__
PLACE vecdiv(PLACE *q, PLACE *a, PLACE d, int count)
#else
PLACE vecdiv(q, a, d, count)
        register PLACE *q, *a;
	register PLACE d;
        register int count;
#endif
        /* q[count]=a[count]/d; return a[count]%d; */
{       register PLACE carry=0;
        for (q+=count, a+=count; count>0; count--)
		carry=PLACEdiv(carry, *--a, d, --q);
        return carry;
}

#ifdef __GNUC__
PLACE vecmul(PLACE *product, PLACE *a, PLACE m, int count)
#else
PLACE vecmul(product, a, m, count)
        register PLACE *product, *a, m;
        register int count;
#endif
        /* product[count]=m*a[count]; return carry; */
{       register PLACE carry=0;
        for ( ; count>0; count--)
		carry=PLACEmul(*a++, m, carry, product++);
        return carry;
}		/* vecmul */

#ifndef USE_SPARC_ASM
#ifdef __GNUC__
PLACE vecmuladd(PLACE *paccu, PLACE *a, PLACE m, int count)
#else
PLACE vecmuladd(paccu, a, m, count)
        register PLACE *paccu, *a, m; 
        register int count;
#endif
        /* paccu[count] += m*a[count]; return carry; */
{       register PLACE carry=0;
        for ( ; count>0; count--) {
 		carry=PLACEmuladd(*a++, m, carry, paccu++);
        }
        return carry;
}		/* vecmuladd */
#endif

#ifdef __GNUC__
PLACE vecmulsub(PLACE *paccu, PLACE *a, PLACE m, int count)
#else
PLACE vecmulsub(paccu, a, m, count)
        register PLACE *paccu, *a, m;
        register int count;
#endif
        /* paccu[count+1] -= m*a[count]; return carry; 
        carry ist 0 oder 1 */
{	register PLACE carry=0;
        for ( ; count>0; count--)
		carry=PLACEmulsub(*a++, m, carry, paccu++);
	carry=PLACEsub(*paccu, carry, 0, paccu);
        return carry;
}

#endif
