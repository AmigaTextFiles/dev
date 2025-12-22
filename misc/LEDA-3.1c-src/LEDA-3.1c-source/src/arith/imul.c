/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  imul.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/* 	imul.c		RD, 29.01.90	*/
/*	bug in IasIsrint fixed, RD, 32.08.91	*/
/*	sign bug in IasImuP fixed, RD, 26.2.92	*/
/*	Karatsuba-Verfahren, RD, 20.7.92	*/
/*	bug in memory usage in do_karatsuba, RD, 14.14.92	*/

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>


#ifdef DO_NOT_USE_KARATSUBA

void IasImuI (accu, a, b)
	pInteger accu;
	const Integer *a, *b;
/* accu=a*b; */
{   	register int i, al, bl, neededlength;
    	register pPLACE paccu, pa, pb;
	if (accu==a) {
		ImuasI(accu, b);
		return;
	}
	if (accu==b) {
		ImuasI(accu, a);
		return;
	}
	al=a->length;
	bl=b->length;
    	if (!al || !bl) {
		Iasint(accu, 0);
		return;
    	}
    	neededlength=al+bl;
	if (neededlength > accu->maxlength) {
		delvec(accu->vec, accu->maxlength);
		accu->maxlength=neededlength;
		paccu=newvec(&accu->maxlength);
		accu->vec=paccu;
	} else
		paccu=accu->vec;
    	pa=a->vec;
	pb=b->vec;
	if (al > bl) {
            for ( i = 0; i < al; i++)
                paccu[i] = 0;
            for ( i = 0; i < bl; i++) 
                paccu[i+al] = 
			vecmuladd(paccu+i, pa, pb[i], al);
        } else {           
            for ( i = 0; i < bl; i++)
                paccu[i] = 0;
            for ( i = 0; i < al; i++) 
                paccu[i+bl] = 
			vecmuladd(paccu+i, pb, pa[i], bl);
        }
        if (paccu[neededlength-1])
            accu->length = neededlength;
        else
            accu->length = neededlength-1;
        accu->sign = a->sign ^ b->sign;
}		/* IasImuI */

void ImuasI(a, b)
	pInteger a;
	const Integer *b;
/* a*=b; */
{   	int maxl;
    	register pPLACE paccu, pa, pb;
    	register int i, al, bl;
	al=a->length;
	bl=b->length;
    	if (!al || !bl) {
		Iasint(a, 0);
		return;
    	}
    	maxl=al+bl;
    	paccu=newvec(&maxl);
    	pa=a->vec;
	pb=b->vec;
	if (al > bl) {
            for ( i = 0; i < al; i++)
                paccu[i] = 0;
            for ( i = 0; i < bl; i++) 
                paccu[i+al] = 
			vecmuladd(paccu+i, pa, pb[i], al);
        } else {           
            for ( i = 0; i < bl; i++)
                paccu[i] = 0;
            for ( i = 0; i < al; i++) 
                paccu[i+bl] = 
			vecmuladd(paccu+i, pb, pa[i], bl);
        }
	al+=bl;
        if (paccu[al-1])
            a->length = al;
        else
            a->length = al-1;
        a->sign ^= b->sign;
	delvec(a->vec, a->maxlength);
	a->vec=paccu;
	a->maxlength=maxl;
}		/* ImuasI */

#else
/* use karatsuba */

/* Prerequisite: enough space in the vectors to increase the length
	appropriately, given with the built-in memory management.
*/

#ifndef KARATSUBA_LIMIT1
#define KARATSUBA_LIMIT1 15
#endif
#ifndef KARATSUBA_LIMIT2
#define KARATSUBA_LIMIT2 KARATSUBA_LIMIT1
#endif

static void do_karatsuba( /* paccu, pa, pb, al, bl */ );

void IasImuI (accu, a, b)
	Integer *accu;
	const Integer *a, *b;
/* accu=a*b; */
/* Karatsuba, verwendet do_karatsuba */
{   	register int i, al, bl, neededlength;
    	register pPLACE paccu, pa, pb;

	if (accu==a) {
		ImuasI(accu, b);
		return;
	}
	if (accu==b) {
		ImuasI(accu, a);
		return;
	}
	al=a->length;
	bl=b->length;
    	if (!al || !bl) {
		Iasint(accu, 0);
		return;
    	}
    	neededlength=al+bl;
	if (neededlength > accu->maxlength) {
		delvec(accu->vec, accu->maxlength);
		accu->maxlength=neededlength;
		paccu=newvec(&accu->maxlength);
		accu->vec=paccu;
	} else
		paccu=accu->vec;
	if (al > bl) {
	    if (bl <= KARATSUBA_LIMIT1) {
	    	/* Standardmultiplikation */
    		pa=a->vec;
		pb=b->vec;
		for ( i = 0; i < al; i++)
		    paccu[i] = 0;
		for ( i = 0; i < bl; i++) 
		    paccu[i+al] = 
			    vecmuladd(paccu+i, pa, pb[i], al);
	    } else
		do_karatsuba(paccu, a->vec, b->vec, al, bl);
        } else {
	    if (al <= KARATSUBA_LIMIT1) {       
	    	/* Standardmultiplikation */
    		pa=a->vec;
		pb=b->vec;
		for ( i = 0; i < bl; i++)
		    paccu[i] = 0;
		for ( i = 0; i < al; i++) 
		    paccu[i+bl] = 
			    vecmuladd(paccu+i, pb, pa[i], bl);
	    } else
		do_karatsuba(paccu, b->vec, a->vec, bl, al);
        }
        if (paccu[neededlength-1])
            accu->length = neededlength;
        else
            accu->length = neededlength-1;
        accu->sign = a->sign ^ b->sign;
}	/* IasImuI, karatsuba	*/

void ImuasI(a, b)
	pInteger a;
	const Integer *b;
/* a*=b; */
/* Karatsuba, verwendet do_karatsuba */
{   	int maxl;
    	register pPLACE paccu, pa, pb;
    	register int i, al, bl;
	al=a->length;
	bl=b->length;
    	if (!al || !bl) {
		Iasint(a, 0);
		return;
    	}
    	maxl=al+bl;
    	paccu=newvec(&maxl);
	if (al > bl) {
	    if (bl <= KARATSUBA_LIMIT1) {
	    	/* Standardmultiplikation */
    		pa=a->vec;
		pb=b->vec;
		for ( i = 0; i < al; i++)
		    paccu[i] = 0;
		for ( i = 0; i < bl; i++) 
		    paccu[i+al] = 
			    vecmuladd(paccu+i, pa, pb[i], al);
	    } else
		do_karatsuba(paccu, a->vec, b->vec, al, bl);
        } else {
	    if (al <= KARATSUBA_LIMIT1) {       
	    	/* Standardmultiplikation */
    		pa=a->vec;
		pb=b->vec;
		for ( i = 0; i < bl; i++)
		    paccu[i] = 0;
		for ( i = 0; i < al; i++) 
		    paccu[i+bl] = 
			    vecmuladd(paccu+i, pb, pa[i], bl);
	    } else
		do_karatsuba(paccu, b->vec, a->vec, bl, al);
        }
	al+=bl;
        if (paccu[al-1])
            a->length = al;
        else
            a->length = al-1;
        a->sign ^= b->sign;
	delvec(a->vec, a->maxlength);
	a->vec=paccu;
	a->maxlength=maxl;
}		/* ImuasI, karatsuba */


static void do_karatsuba(paccu, pa, pb, al, bl)
	PLACE *paccu, *pa, *pb;
	int	al, bl;
	/* now pb is the shorter number */
{    	PLACE *tprod, *tmp, *res;
	int i, tmpl, k, q, r, n, n0, resl;

	/* calculate k minimal with 
		bl <= 2^k*n0 and n0<=KARATSUBA_LIMIT2, n=2^k*n0 */
	n0=bl;
	k=0;
	while (n0>KARATSUBA_LIMIT2) {
	    n0=(n0+1)/2;
	    k++;
	}
	n=n0<<k;
	/* fill a, b with zeroes, maybe al <= n */
	for (i=bl; i<n; i++)
	    pb[i]=0;
	for (i=al; i<n; i++)
	    pa[i]=0;
	/* split a */
	q=al/n;
	r=al%n;
	if (q==0) {	/* case al < n */
	    q=1;
	    r=0;
	}
	/* Now get temporaries for result of karatsuba_mult and tmp */
	tmpl=2*n;
	tmp=newvec(&tmpl);
	tprod=newvec(&tmpl);
	/* Get temporary for result. */
	resl=al+n;
	res=newvec(&resl);
	/* calculate via karatsuba_mult a_i * b, 0<= i <q */
	karatsuba_mult(res, pa, pb, tmp, n);
	for (i=1; i<q; i++) {
	    karatsuba_mult(tprod, &pa[i*n], pb, tmp, n);
	    cvadd(&res[i*n], &res[i*n], tprod, n , 2*n);
	}
	/* calculate a_q * b */
	for (i=q*n; i<al; i++)
	    res[i+bl] = vecmuladd(&res[i], pb, pa[i], bl);
	for (i=0; i<al+bl; i++)
	    paccu[i]=res[i];
	delvec(tmp, tmpl);
	delvec(tprod, tmpl);
	delvec(res, resl);
}		/* do_karatsuba */

#endif
/* DO_NOT_USE_KARATSUBA */

#ifdef __GNUC__
void IasImuP(Integer *accu, const Integer *b, PLACE c)
#else
void IasImuP(accu, b, c)
	register Integer *accu;
	const Integer *b;
	PLACE c;
#endif
{	register int nl;
	register PLACE carry;

	if (accu==b) {
		ImuasP(accu, c);
		return;
	}
	if (!c) {
		Iasint(accu, 0);
		return;
	}
	nl=b->length+1;
	if (nl > accu->maxlength) {
		delvec(accu->vec, accu->maxlength);
		accu->maxlength=nl;
		accu->vec=newvec(&accu->maxlength);
	}
	carry=vecmul(accu->vec, b->vec, c, b->length);
	accu->vec[nl-1]=carry;
	if (carry)
		accu->length = nl;
	else
		accu->length = nl-1;
	accu->sign=b->sign;
}		/* IasImuP */

#ifdef __GNUC__
void ImuasP(Integer *accu, PLACE b)
#else
void ImuasP(accu, b)
	register pInteger accu;
	PLACE b;
#endif
{	register PLACE carry, *paccu;
	register int nl;
	BOOLEAN neednew;
	int maxl;

	if (!b) {
		Iasint(accu, 0);
		return;
	}
	nl=accu->length+1;
	if (nl>accu->maxlength) {
		neednew=TRUE;
		maxl=nl;
		paccu=newvec(&maxl);
	} else {
		paccu=accu->vec;
		neednew=FALSE;
	}
	carry=vecmul(paccu, accu->vec, b, accu->length);
	paccu[nl-1]=carry;
	if (carry)
		accu->length=nl;
	if (neednew) {
		delvec(accu->vec, accu->maxlength);
		accu->vec=paccu;
		accu->maxlength=maxl;
}	}	/* ImuasP */

/****************************************************/

void IasIsrint(a, b, count)
	register pInteger a;
	register const Integer *b;
	unsigned int count;
/* Shift nach rechts */
{	register PLACE accu, help, *pa, *pb;
	register int i;
	int pts, bts, bleft, nl;
	if (a==b) {
		Israsint(a, count);
		return;
	}
	pts=count/LOGPLACE;
	if (pts>=b->length) {
		Ias0(a);
		return;
	}
	bts=count%LOGPLACE;
	bleft=LOGPLACE-bts;
	nl=b->length-pts;
	if (nl>a->maxlength) {
		delvec(a->vec, a->maxlength);
		a->maxlength=nl;
		a->vec=newvec(&a->maxlength);
	}
	pa=a->vec;
	pb=b->vec;
	if ( !bts ) {
		for (i=pts; i<b->length; i++)
			pa[i-pts]=pb[i];
		a->length=nl;
		a->sign=b->sign;
		return;
	}
	accu=pb[pts];
	accu>>=bts;
	for (i=pts+1; i<b->length; i++) {
		help=pb[i];
		accu|=(help<<bleft);
		pa[i-pts-1]=accu;
		accu=help>>bts;
	}
	pa[nl-1]=accu;
	if (accu)
		a->length=nl;
	else
		a->length=nl-1;
	if (a->length)
		a->sign=b->sign;
	else
		a->sign=PLUS;
}		/* IasIsrint */

void Israsint(a, count)
	register pInteger a;
	unsigned int count;
/* Shift nach rechts */
{	register PLACE accu, help, *p;
	register int i;
	int pts, bts, bleft, l;
	pts=count/LOGPLACE;
	if (pts>=a->length) {
		Ias0(a);
		return;
	}
	bts=count%LOGPLACE;
	bleft=LOGPLACE-bts;
	p=a->vec;
	if ( !bts ) {
		for (i=pts; i<a->length; i++)
			p[i-pts]=p[i];
		a->length=a->length-pts;
		return;
	}
	accu=p[pts];
	accu>>=bts;
	for (i=pts+1; i<a->length; i++) {
		help=p[i];
		accu|=(help<<bleft);
		p[i-pts-1]=accu;
		accu=help>>bts;
	}
	l=a->length-pts;
	if (accu) {
		p[l-1]=accu;
		a->length=l;
	} else
		a->length=l-1;
	if (!a->length)
		a->sign=PLUS;
}		/* Israsint */

void IasIslint(a, b, count)
	register pInteger a;
	register const Integer *b;
	unsigned int count;
/* Shift nach links */
{	register PLACE accu, help, *pa, *pb;
	register int i;
	int pts, bts, bleft, nl;
	if (!b->length) {
		Iasint(a, 0);
		return;
	}
	if (a==b) {
		Islasint(a, count);
		return;
	}
	pts=count/LOGPLACE;
	bts=count%LOGPLACE;
	bleft=LOGPLACE-bts;
	nl=b->length+pts+1;
	if (nl>a->maxlength) {
		delvec(a->vec, a->maxlength);
		a->maxlength=nl;
		a->vec=newvec(&a->maxlength);
	}
	a->sign=b->sign;
	pa=a->vec;
	pb=b->vec;
	for (i=0; i<pts; i++) 
		pa[i]=0;
	if ( !bts ) {
		for (i=0; i<b->length; i++)
			pa[i+pts]=pb[i];
		a->length=nl-1;
		return;
	}
	accu=0;
	for (i=0; i<b->length; i++) {
		help=pb[i];
		accu|=(help<<bts);
		pa[i+pts]=accu;
		accu=help>>bleft;
	}
	pa[nl-1]=accu;
	if (accu)
		a->length=nl;
	else
		a->length=nl-1;
}		/* IasIslint */

void Islasint(a, count)
	register pInteger a;
	unsigned int count;
/* Shift nach links */
{	register PLACE accu, help, *pa, *pb;
	register int i;
	int pts, bts, bleft, nl, maxl;
	if (!a->length)
		return;
	pts=count/LOGPLACE;
	nl=a->length+pts+1;
	if (nl>a->maxlength) {
		pb=a->vec;
		maxl=nl;
		pa=newvec(&maxl);
	} else {
		pa=pb=a->vec;
	}
	bts=count%LOGPLACE;
	bleft=LOGPLACE-bts;
	accu=0;
	if ( bts) {
		for (i=a->length-1; i>=0; i--) {
			help=pb[i];
			accu|=(help>>bleft);
			pa[i+pts+1]=accu;
			accu=help<<bts;
		}
		pa[pts]=accu;
	} else {
		pa[nl-1]=0;
		for (i=a->length-1; i>=0; i--)
			pa[i+pts]=pb[i];
	}
	for (i=pts-1; i>=0; i--)
		pa[i]=0;
	if (nl>a->maxlength) {
		delvec(a->vec, a->maxlength);
		a->vec=pa;
		a->maxlength=maxl;
	}
	if (pa[nl-1])
		a->length=nl;
	else
		a->length=nl-1;
}		/* Islasint */

BOOLEAN Isr1(a)
	register pInteger a;
{	register int l;
	register BOOLEAN b;
	l=a->length;
	if (!l)
		return 0;
	b=vecsr1(a->vec, l);
	l--;
	if (!a->vec[l])
		a->length=l;
	return b;
}		/* Isr1 */

BOOLEAN Ieven(a)
	register const Integer *a;
{	return (!((*(a->vec))&1));
}	/* Ieven */
