/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iloc.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*              iloc.h          RD, 18.12.89 */

#ifndef ILOC_H
#define ILOC_H

#include "iint.h"

#define LOGRADIX LOGPLACE

#ifndef USE_64_BIT_INTEGERS
    typedef 	UNSIGNED32 	DOUBLEPLACE;
    typedef 	SIGNED32 	SDOUBLEPLACE;
#define RADIX 0x10000
#define HALFRADIX 0x8000
#define RADIXMINUSONE 0xffff
#else
    typedef 	UNSIGNED64 	DOUBLEPLACE;
    typedef 	SIGNED64 	SDOUBLEPLACE;
#define RADIX 0x100000000
#define HALFRADIX 0x80000000
#define RADIXMINUSONE 0xffffffff
#endif

#define INITLENGTH 4

EXTERN_FUNCTION(PLACE PLACEadd, (PLACE a, PLACE b, PLACE carry, PLACE *sum));
	/* *sum=a+b+carry, return Uebertrag */
EXTERN_FUNCTION(PLACE PLACEsub, (PLACE a, PLACE b, PLACE carry, PLACE *diff));
	/* *diff=a-b-carry, return Uebertrag */
EXTERN_FUNCTION(PLACE PLACEmuladd,(PLACE a,PLACE b,PLACE carry,PLACE *paccu));
	/* *paccu=*paccu+a*b+carry, return Uebertrag */
EXTERN_FUNCTION(PLACE PLACEmul,(PLACE a,PLACE b,PLACE carry,PLACE *paccu));
	/* *paccu=a*b+carry, return Uebertrag */
EXTERN_FUNCTION(PLACE PLACEmulsub,(PLACE a,PLACE b,PLACE carry,PLACE *paccu));
	/* *paccu=*paccu-a*b-carry, return Uebertrag */
EXTERN_FUNCTION(PLACE PLACEdiv, (PLACE h, PLACE l, PLACE n, PLACE *q));
	/* h*RADIX+l / n ergibt Quotient *q, return Rest */

EXTERN_FUNCTION(void cvecsubto, (PLACE *a, PLACE *b, int count));
        /* a[]-=b[count]; */
EXTERN_FUNCTION(int cvadd, (PLACE *sum, PLACE *a, PLACE *b, 
				int counta, int countb));
	/* sum[]=a[counta]+b[countb]; return sum->length */
EXTERN_FUNCTION(int cvsub, (PLACE *diff, PLACE *a, PLACE *b, 
				int counta, int countb));
	/* diff[]=a[counta]-b[countb]; return diff->length */

EXTERN_FUNCTION(PLACE vecaddto, (PLACE *a, PLACE *b, int count));
	/* a[count]+=b[count]; return carry; */
EXTERN_FUNCTION(PLACE vecsubto, (PLACE *a, PLACE *b, int count));
        /* a[count]-=b[count]; return carry; 0 oder 1 */
EXTERN_FUNCTION(BOOLEAN veceq, (PLACE *a, PLACE *b, int count));
        /* return a[count]==b[count]; */
EXTERN_FUNCTION(BOOLEAN vecgt, (PLACE *a, PLACE *b, int count));
        /* return a[count]>b[count] lexikographisch */
EXTERN_FUNCTION(PLACE vecdiv, (PLACE *q, PLACE *a, PLACE d, int count));
        /* q[count]=a[count]/d; return a[count]%d; */
EXTERN_FUNCTION(PLACE vecmul, (PLACE *product, PLACE *a, PLACE m, int count));
        /* product[count]=m*a[count]; return carry; */
EXTERN_FUNCTION(PLACE vecmuladd, (PLACE *paccu, PLACE *a, PLACE m, int count));
        /* paccu[count] += m*a[count]; return carry; */
EXTERN_FUNCTION(PLACE vecmulsub, (PLACE *paccu, PLACE *a, PLACE m, int count));
        /* paccu[count+1] -= m*a[count]; return carry; 
        carry ist 0 oder 1 */

EXTERN_FUNCTION(BOOLEAN vecsr1, (PLACE *u, int l));
	/* b=u[l]%2; u[l]/=2; return b; */
EXTERN_FUNCTION(void vecsri, (PLACE *u, int l, int i));
	/* b=u[l]%2^i; u[l]/=2^i; 	0<i<LOGRADIX  */

EXTERN_FUNCTION(PLACE *	newvec, (int *maxl));
EXTERN_FUNCTION(void delvec, (PLACE *u, int maxl));

EXTERN_FUNCTION(Integer * newInteger, (_VOID_));
EXTERN_FUNCTION(void delInteger, (Integer *u));


EXTERN_FUNCTION(void karatsuba_mult, (PLACE *prod, PLACE *a, PLACE *b, PLACE *tmp, int n2));

#endif
