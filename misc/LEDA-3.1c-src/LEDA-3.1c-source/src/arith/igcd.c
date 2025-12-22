/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  igcd.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*	igcd.c		RD, 21.03.90		*/

/*	RD, 11.9.91, neues Ibgcd, Verdopplung der Geschwindigkeit. */

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

void Idgcd(d, a, b)
	Integer *d;
	const Integer *a, *b;
/* d = gcd(a, b);   Euklidischer Algorithmus, Division mit Rest */
{	Integer aa, bb, q, r;
	register pInteger pa, pb, pq, pr, copy;
	if (Ieq0(a)) {
		IasI(d, b);
		d->sign=PLUS;
		return;
	}
	if (Ieq0(b)) {
		IasI(d, a);
		d->sign=PLUS;
		return;
	}
	pa=&aa; pb=&bb; pq=&q; pr=&r;
	cIasI(pa, a);
	cIasI(pb, b);
	cI(pq);
	cI(pr);
	pa->sign=PLUS;
	pb->sign=PLUS;
	while (TRUE) {
		uIdiv(pq, pr, pa, pb);
		if (Ieq0(pr))
			break;
		copy=pa; pa=pb; pb=pr; pr=copy;
	}
	IasI(d, pb);
	dI(pa); dI(pb); dI(pq); dI(pr); 
}		/* Idgcd */

#ifdef USE_OLD_BGCD

void Ibgcd(d, a, b)
	pInteger d, a, b;
/* d = gcd(a, b);   binaerer Algorithmus */
{	register int toshift=0;
	Integer aa, bb;
	register pInteger pa, pb, swap;
	if (Ieq0(a)) {
		IasI(d, b);
		d->sign=PLUS;
		return;
	}
	if (Ieq0(b)) {
		IasI(d, a);
		d->sign=PLUS;
		return;
	}
	pa=&aa; pb=&bb;
	cIasI(pa, a);
	cIasI(pb, b);
	pa->sign=PLUS;
	pb->sign=PLUS;
	while (Ieven(pa) && Ieven(pb)) {
		toshift++;
		Isr1(pa);
		Isr1(pb);
	}
	while (Ieven(pa)) {
		Isr1(pa);
	}
	while (Ieven(pb)) {
		Isr1(pb);
	}
	while (TRUE) {
		if (IgtI(pb, pa)) {
			swap=pa; pa=pb; pb=swap;
		} else {
			ImiasI(pa, pb);
			if (!Ieq0(pa))
				while (Ieven(pa))
					Isr1(pa);
			else
				break;
	}	}
	IasIslint(d, pb, toshift);
	dI(pa);
	dI(pb);
}		/* Ibgcd */

#else

void Ibgcd(d, a, b)
	Integer *d;
	const Integer *a, *b;
/*
 * d = gcd(a, b);   binaerer Algorithmus, 
 * direkt auf irv.c aufgesetzt.
 * Achtung:
 * Sind die Zahlen a, b sehr unterschiedlich gross, so ist
 * Ibgcd relativ langsam. Deshalb ist es sinnvoll, vorher
 * eine Division mit Rest durchzuf"uhren.
 *
 */
{	register int l, al, bl;
	int toshift=0;
	Integer aa, bb;
	register PLACE *lp, *avec, *bvec;
	if (!a->length) {
		IasI(d, b);
		d->sign=PLUS;
		return;
	}
	if (!b->length) {
		IasI(d, a);
		d->sign=PLUS;
		return;
	}
	cI(&aa);
	cI(&bb);
	/* Nun zuerst eine Division mit Rest */
	if (IgtI(a, b)) {
		IasIreI(&aa, a, b);
		if (!aa.length) {
			IasI(d, b);
			d->sign=PLUS;
			dI(&aa);
			dI(&bb);
			return;
		}
		IasI(&bb, b);
	} else {
		IasIreI(&bb, b, a);
		if (!bb.length) {
			IasI(d, a);
			d->sign=PLUS;
			dI(&aa);
			dI(&bb);
			return;
		}
		IasI(&aa, a);
	}
	avec=aa.vec;
	bvec=bb.vec;
	al=aa.length;
	bl=bb.length;
	while (!(*avec & 1) && !(*bvec & 1)) {
		toshift++;
		vecsr1(avec, al);
		if (!avec[al-1])
			al--;
		vecsr1(bvec, bl);
		if (!bvec[bl-1])
			bl--;
	}
	while (!(*avec & 1)) {
		vecsr1(avec, al);
		if (!avec[al-1])
			al--;
	}
	while (!(*bvec & 1)) {
		vecsr1(bvec, bl);
		if (!bvec[bl-1])
			bl--;
	}
	while (TRUE) {
		if (bl>al || ((al==bl)&& vecgt(bvec, avec, bl))) {
			lp=avec; avec=bvec; bvec=lp;
			l=al; al=bl; bl=l;
		} else {
			lp=&(avec[al-1]);
                	cvecsubto(avec, bvec, bl);
			while ((al>0)&&(! *lp)) {
				al--; lp--;
			}
			if (al) 
			    while (!(*avec & 1)) {
				register PLACE low;
				l=1;
				low=*avec>>1;
				while ( !(low & 1) && l<LOGRADIX-1 ) {
				    l++;
				    low>>=1;
				}
				vecsri(avec, al, l);
				if (!avec[al-1])
					al--;
			    }
			else
				break;
	}	}
	if (avec==aa.vec) {
		bb.length=bl;
		bb.sign=PLUS;
		IasIslint(d, &bb, toshift);
		dI(&aa);
		dI(&bb);
		return;
	} else {
		aa.length=bl;
		aa.sign=PLUS;
		IasIslint(d, &aa, toshift);
		dI(&aa);
		dI(&bb);
		return;
	}
}		/* Ibgcd */

#endif

/*************************************************/

void Ielba(d, u, v, a, b)
	Integer *d, *u, *v;
	const Integer *a, *b;
/* d = gcd(a, b) = ua + vb;   Euklid-Lenstra-Berlekamp */
{	Integer aa, bb, wua, wva, wub, wvb, q, r;
	register pInteger pa, pb, pq, pr, ua, va, ub, vb, copy;
	if (Ieq0(a)) {
		IasI(d, b);
		Ias0(u);
		Ias1(v);
		v->sign=b->sign;
		d->sign=PLUS;
		return;
	}
	if (Ieq0(b)) {
		IasI(d, a);
		Ias1(u);
		Ias0(v);
		u->sign=a->sign;
		d->sign=PLUS;
		return;
	}
	pa=&aa; pb=&bb; pq=&q; pr=&r;
	ua=&wua; va=&wva; ub=&wub; vb=&wvb;
	cIasI(pa, a);
	cIasI(pb, b);
	cI(pq);
	cI(pr);
	pa->sign=PLUS;
	pb->sign=PLUS;
	cIasint(ua, 1);
	ua->sign=a->sign;
	cIasint(va, 0);		/* pa == ua*a + va*b */
	cIasint(ub, 0);
	cIasint(vb, 1);
	vb->sign=b->sign;	/* pb == ub*a + vb*b */
	while (TRUE) {
		uIdiv(pq, pr, pa, pb);
		if (Ieq0(pr))
			break;
		copy=pa; pa=pb; pb=pr; pr=copy;
		IasImuI(pr, pq, ub);
		copy=ua; ua=ub; ub=copy;
		ImiasI(ub, pr);
		IasImuI(pr, pq, vb);
		copy=va; va=vb; vb=copy;
		ImiasI(vb, pr);
	}
	IasI(d, pb);
	IasI(u, ub);
	IasI(v, vb);
	dI(pa); dI(pb); dI(pq); dI(pr);
	dI(ua); dI(ub); dI(va); dI(vb); 
}		/* Ielba */

void Ibelba(d, u, v, a, b)
	Integer *d, *u, *v;
	const Integer *a, *b;
/* d = gcd(a, b) = u*a + v*b;   binaerer Algorithmus */
{	register int toshift=0;
	Integer aa, bb, A, B, wxa, wxb, wya, wyb;
	register pInteger pa, pb, pA, pB, xa, xb, ya, yb, swap;
	if (Ieq0(a)) {
		IasI(d, b);
		Ias0(u);
		Ias1(v);
		v->sign=b->sign;
		d->sign=PLUS;
		return;
	}
	if (Ieq0(b)) {
		IasI(d, a);
		Ias1(u);
		Ias0(v);
		u->sign=a->sign;
		d->sign=PLUS;
		return;
	}
	pa=&aa; pb=&bb; xa=&wxa; xb=&wxb; ya=&wya; yb=&wyb;
	pA=&A; pB=&B;
	cIasI(pa, a);
	cIasI(pb, b);
	while (Ieven(pa) && Ieven(pb)) {
		toshift++;
		Isr1(pa);
		Isr1(pb);
	}
	cIasI(pA, pa);
	cIasI(pB, pb);
	pa->sign=PLUS;
	pb->sign=PLUS;
	cIasint(xa, 1);
	xa->sign=a->sign;
	cIasint(ya, 0);		/* pa == xa*pA + ya*pB */
	cIasint(xb, 0);
	cIasint(yb, 1);
	yb->sign=b->sign;	/* pb == xb*pA + yb*pB */
	while (Ieven(pa)) {
		Isr1(pa);
		if (Ieven(xa) && Ieven(ya)) {
			Isr1(xa);
			Isr1(ya);
		} else {
			IplasI(xa, pB);
			Isr1(xa);
			ImiasI(ya, pA);
			Isr1(ya);
	}	}
	while (Ieven(pb)) {
		Isr1(pb);
		if (Ieven(xb) && Ieven(yb)) {
			Isr1(xb);
			Isr1(yb);
		} else {
			IplasI(xb, pB);
			Isr1(xb);
			ImiasI(yb, pA);
			Isr1(yb);
	}	}
	while (TRUE) {
		if (IgtI(pb, pa)) {
			swap=pa; pa=pb; pb=swap;
			swap=xa; xa=xb; xb=swap;
			swap=ya; ya=yb; yb=swap;
		} else {
			ImiasI(pa, pb);
			ImiasI(xa, xb);
			ImiasI(ya, yb);
			if (!Ieq0(pa))
			    while (Ieven(pa)) {
				Isr1(pa);
				if (Ieven(xa) && Ieven(ya)) {
					Isr1(xa);
					Isr1(ya);
				} else {
					IplasI(xa, pB);
					Isr1(xa);
					ImiasI(ya, pA);
					Isr1(ya);
			    }	}
			else
			    break;
	}	}
	IasIslint(d, pb, toshift);
	IasI(u, xb); IasI(v, yb);
	dI(pa);	dI(pb);	dI(pA);	dI(pB);
	dI(xa);	dI(xb);	dI(ya);	dI(yb);
}		/* Ibelba */

/***********************************************/

void Ireduce(a, b)
	pInteger a, b;
/* Kuerze gcd von a und b */
{	Integer d, r;
	cI(&d);
	cI(&r);
	Ibgcd(&d, a, b);
	Idiv(a, &r, a, &d);
	Idiv(b, &r, b, &d);
	dI(&d);
	dI(&r);
}
