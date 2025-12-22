/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  idiv.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*	Umstellung auf PLACEadd etc., RD, 24.9.91	*/
/*	Normalisieren fuer die Division durch Shifts.	*/
/*	31.8.92, RD, Fehler in Idiv korrigiert: bb, one nicht
		zerstoert (Hinweis von H.B. Eggenstein vom 10.8.92)
*/

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

static void normdiv(u, v, q, ul, vl)
	register pPLACE u, v;
	pPLACE q;
	int ul;
	register int vl;
/* u, v sind verschiedene Integer.vec der Laengen ul, vl >=2, die fuer 
   die Division u/v normiert sind. Das heisst auch, dass 
   v[vl-1] > u[ul-1] ist. u[ul-1]=0 ist zugelassen. v ist nicht 0. 
   Zurueckgegeben wird der Rest in u und der Quotient in q, die Laenge
   von q muss groesser oder gleich ul-vl+1 sein. */
{   register int j;
    for (j=ul-1; j>=vl; j--) {
	PLACE qdach, h, l, carry, help;
	if (u[j]==v[vl-1]) {
	    qdach=RADIXMINUSONE;
	    /* (h, l) = (v[vl-2] - u[j-1])*RADIX - u[j-2] - 1 */
	    carry=PLACEsub(0, u[j-2], 1, &l);
	    carry=PLACEsub(v[vl-2], u[j-1], carry, &h);
	    if (!carry) {
		/* (h, l) -= (v[vl-1]*RADIX + v[vl-2]) */
		carry=PLACEsub(l, v[vl-2], carry, &l);
		carry=PLACEsub(h, v[vl-1], carry, &h);
		while (!carry) {
		    qdach-=1;
		    carry=PLACEsub(l, v[vl-2], carry, &l);
		    carry=PLACEsub(h, v[vl-1], carry, &h);
		}
	    }
	} else {
	    help=PLACEdiv(u[j], u[j-1], v[vl-1], &qdach);
	    /* (h, l) = v[vl-2]*qdach - help*RADIX - u[j-2] - 1; */
	    h=PLACEmul(qdach, v[vl-2], 0, &l);
	    carry=PLACEsub(l, u[j-2], 1, &l);
	    carry=PLACEsub(h, help, carry, &h);
	    while (!carry) {
		qdach-=1;
	    	carry=PLACEsub(l, v[vl-2], carry, &l);
	    	carry=PLACEsub(h, v[vl-1], carry, &h);
	    }
	}
	/* Nun ist qdach bestimmt, und hoechstens 1 zu gross */
	carry=vecmulsub(u+j-vl, v, qdach, vl);
	if (carry) {		/* Addiere v zurueck */
	    qdach-=1;
	    carry=vecaddto(u+j-vl, v, vl);
	    PLACEadd(u[j], 0, carry, &u[j]);	/* Ignoriere carry */
	}
	q[j-vl]=qdach;
    }		/* j-Schleife */
    return;
}		/* normdiv */

static PLACE norm_vecsli(u, a, toshift, count)
	PLACE *u, *a;
	int toshift, count;
/* 0<=toshift<=LOGPLACE-1; */
{	PLACE accu, help;
	int i, bleft = LOGPLACE - toshift;

	if ( ! toshift ) {
		for (i=0; i<count; i++)
			u[i]=a[i];
		return 0;
	}
	accu = 0;
	for ( i=0; i<count; i++ ) {
		help = a[i];
		accu |= (help<<toshift);
		u[i]=accu;
		accu=help>>bleft;
	}
	return accu;
}		/* norm_vecsli */

static void norm_vecsri(a, u, toshift, count)
	PLACE *a, *u;
	int toshift, count;
/* 0<=toshift<=LOGPLACE-1; */
{	PLACE accu, help;
	int i, bleft=LOGPLACE-toshift;

	if ( ! toshift ) {
		for (i=0; i<count; i++)
			a[i]=u[i];
		return;
	}
	accu=u[0];
	accu>>=toshift;
	for ( i=1; i<count; i++ ) {
		help=u[i];
		accu|=(help<<bleft);
		a[i-1]=accu;
		accu=help>>toshift;
	}
	a[count-1]=accu;
}		/* norm_vecsri  */


/*******************************************************/

#ifdef __GNUC__
PLACE uIdiasP(Integer *a, PLACE b)
#else
PLACE uIdiasP(a, b)
	register pInteger a;
	register PLACE b;
#endif
{	register PLACE rem;
	if (!a->length)
		return 0;
	rem=vecdiv(a->vec, a->vec, b, a->length);
	if (!a->vec[a->length-1])
		a->length--;
	return rem;
}	/* uIdiasP */

#ifdef __GNUC__
PLACE IdiasP(Integer *a, PLACE b)
#else
PLACE IdiasP(a, b)
	register pInteger a;
	register PLACE b;
#endif
{	register PLACE rem;
	Integer one;
	if (!a->length)
		return 0;
	rem=vecdiv(a->vec, a->vec, b, a->length);
	if (!a->vec[a->length-1])
		a->length--;
	if (a->sign==PLUS)
		return rem;
	if (!rem)
		return rem;
	cIasint(&one, 1);
	ImiasI(a, &one);
	dI(&one);
	return b-rem;
}	/* IdiasP */

#ifdef __GNUC__
PLACE uIasIdiP(Integer *q, const Integer *a, PLACE b)
#else
PLACE uIasIdiP(q, a, b)
	register pInteger q;
	register const Integer *a;
	register PLACE b;
#endif
{	register PLACE rem;
	register int nl;
	if (q==a)
		return uIdiasP(q, b);
	if (!a->length) {
		Iasint(q, 0);
		return 0;
	}
	nl=a->length;
	if (nl>q->maxlength) {
		delvec(q->vec, q->maxlength);
		q->maxlength=nl;
		q->vec=newvec(&q->maxlength);
	}
	rem=vecdiv(q->vec, a->vec, b, a->length);
	if (q->vec[a->length-1])
		q->length=a->length;
	else
		q->length=a->length-1;
	q->sign=PLUS;
	return rem;
}	/* uIasIdiP */

#ifdef __GNUC__
PLACE IasIdiP(Integer *q, const Integer *a, PLACE b)
#else
PLACE IasIdiP(q, a, b)
	register pInteger q;
	register const Integer *a;
	register PLACE b;
#endif
{	register PLACE rem;
	register int nl;
	Integer one;
	if (q==a)
		return IdiasP(q, b);
	if (!a->length) {
		Iasint(q, 0);
		return 0;
	}
	nl=a->length;
	if (nl>q->maxlength) {
		delvec(q->vec, q->maxlength);
		q->maxlength=nl;
		q->vec=newvec(&q->maxlength);
	}
	rem=vecdiv(q->vec, a->vec, b, a->length);
	if (q->vec[a->length-1])
		q->length=a->length;
	else
		q->length=a->length-1;
	if (a->sign==PLUS) {
		q->sign=PLUS;
		return rem;
	}
	q->sign=MINUS;
	if (!rem)
		return rem;
	cIasint(&one, 1);
	ImiasI(q, &one);
	dI(&one);
	return b-rem;
}	/* IasIdiP */

/*************************************************/

void uIdiv(q, r, a, b)
	pInteger q, r;
	const Integer *a, *b;
/* Division mit Rest, a=bq+r. */
{   register pPLACE u, v;
    register int ul, vl;
    int unl, vnl, toshift;
    register int m;
    register int i;
    PLACE help, carry;

    vl=b->length;
    m=a->length-vl;
    if (m<0) {
	IasI(r, a);
	r->sign=PLUS;
	Iasint(q, 0);
	return;
    }
    if (vl<=1) {
	register PLACE rem;
	if (!vl)
		Ierror("uIdiv: division by zero");
	rem=uIasIdiP(q, a, b->vec[0]);
	*(r->vec)=rem;
	if (rem)
	    r->length=1;
	else
	    r->length=0;
	r->sign=PLUS;
	return;
    }
	/* Hilfsvariablen bereitstellen */
    ul=a->length+1;
    unl=ul;
    u=newvec(&unl);
    vnl=vl;
    v=newvec(&vnl);
	/* a, b normalisieren */
    help=b->vec[vl-1];
    toshift=0;
    while ( !( help >> (LOGPLACE-1)) ) {
	help<<=1;
	toshift++;
    }
    u[ul-1]=norm_vecsli(u, a->vec, toshift, ul-1);
    norm_vecsli(v, b->vec, toshift, vl);
	/* eigentliche Division */
    if (m+1>q->maxlength) {
	delvec(q->vec, q->maxlength);
	q->maxlength=m+1;
	q->vec=newvec(&q->maxlength);
    }
    normdiv(u, v, q->vec, ul, vl);
	/* Rest zurueckgewinnen */
    if (vl>r->maxlength) {
	delvec(r->vec, r->maxlength);
	r->maxlength=vl;
	r->vec=newvec(&r->maxlength);
    }
    norm_vecsri(r->vec, u, toshift, vl);
    delvec(u, unl);
    i=vl-1; 
    u=r->vec;
    while(!u[i] && i>=0)
	i--;
    r->length=i+1;
    r->sign=PLUS;
	/* Quotient auf Standardform */
    if (q->vec[m])
	q->length=m+1;
    else
	q->length=m;
    q->sign=PLUS;
    delvec(v, vnl);
}		/* uIdiv */

/*************************************************/

void Idiv(q, r, a, b)
	pInteger q, r;
	const Integer *a, *b;
/* Division mit Rest, a=bq+r. */
{   register pPLACE u, v;
    register int ul, vl;
    int unl, vnl, toshift;
    register int m;
    register int i;
    PLACE help, carry;
    BOOLEAN usebb=FALSE;
    Integer bb, one;

    vl=b->length;
    m=a->length-vl;
    if (m<0) { /* dann sind a, b verschiedene Variablen */
	if (a->sign==PLUS) {
	    IasI(r, a);
	    Iasint(q, 0);
	    return;
	}
	if (b->sign==PLUS) {
	    IasIplI(r, a, b);
	    Iasint(q, -1);
	    return;
	} else {
	    IasImiI(r, a, b);
	    Iasint(q, 1);
	    return;
	}	
    }		/* m<0 */
	/* Sonderfall: Divisor einstellig */
    if (vl<=1) {
	register PLACE rem;
	if (!vl)
		Ierror("Idiv: Division by zero");
	rem=IasIdiP(q, a, b->vec[0]);
	*(r->vec)=rem;
	if (rem)
	    r->length=1;
	else
	    r->length=0;
	r->sign=PLUS;
	q->sign^=b->sign;
	return;
    }
	/* Hilfsvariablen bereitstellen */
    ul=a->length+1;
    unl=ul;
    u=newvec(&unl);
    vnl=vl;
    v=newvec(&vnl);
	/* a zu u, b zu v normalisieren */
    help=b->vec[vl-1];
    toshift=0;
    while ( !( help >> (LOGPLACE-1)) ) {
	help<<=1;
	toshift++;
    }
    u[ul-1]=norm_vecsli(u, a->vec, toshift, ul-1);
    norm_vecsli(v, b->vec, toshift, vl);
	/* eigentliche Division */
    if (a->sign==MINUS) {
	if ((b==r)||(b==q)) {
	    usebb=TRUE;
	    cIasI(&bb, b);
	}
    }
    if (m+1>q->maxlength) {
	delvec(q->vec, q->maxlength);
	q->maxlength=m+1;
	q->vec=newvec(&q->maxlength);
    }
    normdiv(u, v, q->vec, ul, vl);
	/* Rest zurueckgewinnen */
    if (vl>r->maxlength) {
	delvec(r->vec, r->maxlength);
	r->maxlength=vl;
	r->vec=newvec(&r->maxlength);
    }
    norm_vecsri(r->vec, u, toshift, vl);
    delvec(u, unl);
    i=vl-1; 
    u=r->vec;
    while(!u[i] && i>=0)
	i--;
    r->length=i+1;
	/* Quotient auf Standardform */
    if (q->vec[m])
	q->length=m+1;
    else
	q->length=m;
    delvec(v, vnl);
	/* Rest positiv, auf a==bq+r normalisieren. */
    if (a->sign==PLUS) {
	if (!(q->length))
	    q->sign=PLUS;
	else
	    q->sign=b->sign;
    	r->sign=PLUS;
        if (usebb)
         {dI(&bb);}
	return;
    }
    if (!r->length) {
	if (!q->length)
	    q->sign=PLUS;
	else
	    q->sign=a->sign^b->sign;
	r->sign=PLUS;
        if (usebb)
         {dI(&bb);}
	return;
    }
    cIasint(&one, 1);
    if (!usebb) {
    	if (b->sign==PLUS) {
	    r->sign=MINUS;
	    IplasI(r, b);
	    q->sign=PLUS;
	    IplasI(q, &one);
	    q->sign=MINUS;
            dI(&one);
	    return;
	} else {
	    r->sign=MINUS;
	    ImiasI(r, b);
	    q->sign=PLUS;
	    IplasI(q, &one);
            dI(&one);
	    return;
	}
    } else {
    	if (bb.sign==PLUS) {
	    r->sign=MINUS;
	    IplasI(r, &bb);
	    q->sign=PLUS;
	    IplasI(q, &one);
	    q->sign=MINUS;
            dI(&bb); 
            dI(&one);
	    return;
	} else {
	    r->sign=MINUS;
	    ImiasI(r, &bb);
	    q->sign=PLUS;
	    IplasI(q, &one);
            dI(&bb); 
            dI(&one);
	    return;
}   }   }	/* Idiv */

/*****************************************/

void IasIdiI(q, a, b)
	pInteger q;
	const Integer *a, *b;
/* Division, Quotient */
{	Integer r;
	cI(&r);
	Idiv(q, &r, a, b);
	dI(&r);
}

void IdiasI(q, b)
	pInteger q;
	const Integer *b;
/* Division, Quotient */
{	Integer r;
	cI(&r);
	Idiv(q, &r, q, b);
	dI(&r);
}

void IasIreI(r, a, b)
	pInteger r;
	const Integer *a, *b;
/* Division, Rest */
{	Integer q;
	cI(&q);
	Idiv(&q, r, a, b);
	dI(&q);
}

void IreasI(r, b)
	pInteger r;
	const Integer *b;
/* Division, Rest */
{	Integer q;
	cI(&q);
	Idiv(&q, r, r, b);
	dI(&q);
}
