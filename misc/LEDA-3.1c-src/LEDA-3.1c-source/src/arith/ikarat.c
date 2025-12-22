/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ikarat.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

#ifndef KARATSUBA_LIMIT2
#define KARATSUBA_LIMIT2 15
#endif

/* Formulae:
    a == B^n a1 + a0;
    b == B^n b1 + b0;
    a b == (B^(2n) + B^n) a1 b1 + B^n (a1 - a0) (b0 - b1) + (B^n + 1) a0 b0;

	-----------------
V	|     a1 b1 	|
	-----------------
		-----------------
IV		|     a1 b1	|
		-----------------
		-----------------
III		||a1-a0||b0-b1|	|
		-----------------
		-----------------
II		|     a0 b0	|
		-----------------
			-----------------
I			|     a0 b0	|
			-----------------
	---------------------------------
	|	    prod		|
	---------------------------------

		|	|	|	|
		n3	n2	n	0

*/


static  PLACE vecsub (/*diff, a, b, k*/);
static  PLACE vecadd4carry (/*sum, a, b, c, d, carry, k*/);
static  int vecadd3subcarry (/*accu, a, b, c, d, carry, k*/);
static  PLACE vecaddPLACE (/*accu, a, d, k*/);
static  PLACE vecaddscarry (/*accu, a, d, k*/);

void karatsuba_mult (prod, a, b, tmp, n2)
	PLACE *prod, *a, *b, *tmp;
	int n2;

/* 	In:	a[n2], b[n2];	n2 == 2^k * n0, with n0 <= KARATSUBA_LIMIT2
	Out:	prod[2*n2] = a[n2] * b[n2];
	Local:	tmp[2*n2] for intermediate results
	for n2>KARATSUBA_LIMIT2:	karatsuba-recursion with k-1
	else:		standard multiplication
*/
{	int sign, i, n, n3;
	PLACE carry;
	int subcarry;

	if (n2<=KARATSUBA_LIMIT2) {
	    /* use vecmuladd */
	    for ( i = 0; i < n2; i++)
                prod[i] = 0;
            for ( i = 0; i < n2; i++) 
                prod[i+n2] = vecmuladd(&prod[i], a, b[i], n2);
	    return;
	}

	n=n2/2;
	n3=n2+n;

	karatsuba_mult(&prod[n2], a, b, prod, n);
	/* prod:	|    a0*b0	|		|	*/

	if (vecgt(a, &a[n], n)) {
		sign=1;
		vecsub(tmp, a, &a[n], n);	/* a0 - a1 */
	} else {
		sign=0;
		vecsub(tmp, &a[n], a, n);	/* a1 - a0 */
	}
	/* tmp:		|	|	|	||a0-a1||	*/
	if (vecgt(&b[n], b, n)) {
		sign^=1;
		vecsub(&tmp[n], &b[n], b, n);	/* b1 - b0 */
	} else {
		vecsub(&tmp[n], b, &b[n], n);	/* b0 - b1 */
	}
	/* tmp:		|	|	||b1-b0|||a0-a1||	*/


	karatsuba_mult(&tmp[n2], tmp, &tmp[n], prod, n);
	/* tmp:		||b1-b0|*|a0-a1|||b1-b0|||a0-a1||	*/

	karatsuba_mult(tmp, &a[n], &b[n], prod, n);
	/* tmp:		||b1-b0|*|a0-a1||    a1*b1	|	*/

	/*
			---------------------------------
	prod		|     a0 b0	|		|
			---------------------------------

			---------------------------------
	tmp		||a1-a0||b0-b1|	|     a1 b1	|
			---------------------------------
	*/

	if (sign==0) {		/* Einfach addieren */
	    for (i=0; i<n; i++)
		prod[i]=prod[n2+i];			/* I */
	    /* I + II + III + IV */
	    carry=vecadd4carry(&prod[n], 
			&prod[n3], &prod[n2], &tmp[n2], tmp, 0, n);
	    /* carry + II + III + IV + V */
	    carry=vecadd4carry(&prod[n2], 
			&prod[n3], &tmp[n3], &tmp[n], tmp, carry, n);
	    /* carry + V */
	    vecaddPLACE(&prod[n3], &tmp[n], carry, n);
	} else {		/* III subtrahieren */
	    for (i=0; i<n; i++)
		prod[i]=prod[n2+i];			/* I */
	    /* I + II + IV - III */
	    subcarry=vecadd3subcarry(&prod[n], 
			&prod[n3], &prod[n2], tmp, &tmp[n2], 0, n);
	    /* carry + II + IV + V - III */
	    subcarry=vecadd3subcarry(&prod[n2], 
			&prod[n3], &tmp[n], tmp, &tmp[n3], subcarry, n);
	    /* subcarry + V */
	    vecaddscarry (&prod[n3], &tmp[n], subcarry, n);
	}
}

static  PLACE vecsub (diff, a, b, k)
        register PLACE *diff, *a, *b; 
        register int k;
        /* diff[k]=a[k]-b[k]; return carry (0 oder 1) */
{       register PLACE carry=0;
        for ( ; k>0; k--)
		carry=PLACEsub(*a++, *b++, carry, diff++);
        return (carry & 1);
}

static  PLACE vecadd4carry (accu, a, b, c, d, carry, k)
	PLACE *accu, *a, *b, *c, *d, carry;
	int k;
	/* accu[k]=a[k]+b[k]+c[k]+d[k]+carry; return carry; */
{	PLACE ac, bc, cc, dc;
	int i;
	if (k==0)
		return;
	ac=PLACEadd(carry, *a, 0, accu);
	bc=PLACEadd(*accu, *b, 0, accu);
	cc=PLACEadd(*accu, *c, 0, accu);
	dc=PLACEadd(*accu, *d, 0, accu);
	for (i=1; i<k; i++) {
		ac=PLACEadd(a[i], b[i], ac, &accu[i]);
		bc=PLACEadd(accu[i], c[i], bc, &accu[i]);
		cc=PLACEadd(accu[i], d[i], cc, &accu[i]);
		dc=PLACEadd(accu[i], 0, dc, &accu[i]);
	}
	return ac+bc+cc+dc;
}


static  int vecadd3subcarry (accu, a, b, c, d, carry, k)
	PLACE *accu, *a, *b, *c, *d;
	int carry, k;
	/* carry >= -1 */
	/* accu[k]=a[k]+b[k]+c[k]-d[k]+carry; return carry; */
{	PLACE ac=0, bc=0, cc=0, subc=0;
	int i;
	if (k==0)
		return;
	if (carry >= 0) {
		ac = PLACEadd(carry, *a, 0, accu);
		bc = PLACEadd(*accu, *b, 0, accu);
		cc = PLACEadd(*accu, *c, 0, accu);
		subc = PLACEsub(*accu, *d, 0, accu);
	} else {
		ac = 0;
		bc = PLACEadd(*a, *b, 0, accu);
		cc = PLACEadd(*accu, *c, 0, accu);
		subc = PLACEsub(*accu, *d, 1, accu);
	}
	for (i=1; i<k; i++) {
		ac=PLACEadd(a[i], b[i], ac, &accu[i]);
		bc=PLACEadd(accu[i], c[i], bc, &accu[i]);
		cc=PLACEadd(accu[i], 0, cc, &accu[i]);
		subc=PLACEsub(accu[i], d[i], subc, &accu[i]);
	}
	return ac+bc+cc-subc;
}

static  PLACE vecaddPLACE (accu, a, d, k)
	PLACE *accu, *a, d;
	int k;
	/* accu[k]=a[k]+d; return carry; */
{	PLACE carry=d;
	for ( ; k>0; k-- )
		carry=PLACEadd(*a++, carry, 0, accu++);
	return carry;
}
/* ACHTUNG:	k==0  ==>  carry==d */

static  PLACE vecaddscarry (accu, a, scarry, k)
	PLACE *accu, *a;
	int scarry, k;
	/* RADIX > scarry>=-1 */
	/* accu[k]=a[k]+scarry; return carry; */
{	PLACE carry;
	if (scarry >= 0) {
	    carry = scarry;
	    for ( ; k>0; k-- )
		    carry=PLACEadd(*a++, carry, 0, accu++);
	    return carry;
	} else {
	    carry = 1;
	    for ( ; k>0; k-- )
		    carry=PLACEsub(*a++, 0, carry, accu++);
	    return carry;
	}
}
/* ACHTUNG:	k==0  ==>  carry==d */

