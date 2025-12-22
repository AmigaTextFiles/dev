/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iadd.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*      iadd.c          RD, 23.12.89    */

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

void IplasI(a, b)
        register pInteger a;
	register const Integer *b;
/* a+=b; */
{   if (a->sign==b->sign) {
        register int neededlength=a->length;
        if (neededlength<b->length) {
                neededlength=b->length;
        }
        neededlength++;
        if (neededlength>a->maxlength) {
            register pPLACE newv;
	    register int oldlength=a->maxlength;
            a->maxlength=neededlength;
            newv=newvec(&a->maxlength);
            a->length=cvadd(newv, a->vec, b->vec, a->length, b->length);
            delvec(a->vec, oldlength);
            a->vec=newv;
            return;
        } else {
	    a->length=cvadd(a->vec, a->vec, b->vec, a->length, b->length);
            return;
        }
    } else {
        /* Vorzeichen verschieden, subtrahiere betragsmaessig 
                kleineres von groesserem */
        if ((b->length>a->length)||((b->length==a->length)
                        &&vecgt(b->vec, a->vec, a->length))) {
            /* |b|>|a| */
            register int neededlength=b->length;
            if (neededlength<=a->maxlength) {
		a->length=cvsub(a->vec, b->vec, a->vec, 
				b->length, a->length);
                a->sign=b->sign;
                return;
            } else {
                register pPLACE newv;
                register int oldlength=a->maxlength;
                a->maxlength=neededlength;
                newv=newvec(&a->maxlength);
                a->length=cvsub(newv, b->vec, a->vec, 
				b->length, a->length);
                delvec(a->vec, oldlength);
                a->vec=newv;
                a->sign=b->sign;
                return;
            }
        } else {
                /* |b| <= |a| */
		register int l=a->length;
		register PLACE * lp=&(a->vec[l-1]);
                cvecsubto(a->vec, b->vec, b->length);
		while ((l>0)&&(! *lp)) {
			l--; lp--;
		}
		a->length=l;
                if (!l)
                        a->sign = PLUS;
                return;
}   }   }       /* IplasI */

void IasIplI(sum, a, b)
        register pInteger sum;
	register const Integer *a, *b;
/* sum=a+b; */
{   register int neededlength;
    if (sum==a) {
        IplasI(sum, b);
	return;
    }
    if (sum==b) {
        IplasI(sum, a);
	return;
    }
    if (a->sign==b->sign) {     /* Addition */
        neededlength=a->length;
        if (neededlength<b->length)
            neededlength=b->length;
        neededlength++;
        if (neededlength>sum->maxlength) {
            delvec(sum->vec, sum->maxlength);
            sum->maxlength=neededlength;
            sum->vec=newvec(&sum->maxlength);
        }
        sum->length=cvadd(sum->vec, a->vec, b->vec, a->length, b->length);
        sum->sign=a->sign;
        return;
    } else {            /* Subtraktion */
        neededlength=a->length;
        if (neededlength<b->length)
            neededlength=b->length;
        if (neededlength>sum->maxlength) {      
            delvec(sum->vec, sum->maxlength);
            sum->maxlength=neededlength;
            sum->vec=newvec(&sum->maxlength);
        }
        if ((b->length>a->length) || (b->length==a->length)
                && vecgt(b->vec, a->vec, a->length)) {
            /* |b| > |a| */
            sum->length=cvsub(sum->vec, b->vec, a->vec, 
				b->length, a->length);
            sum->sign=b->sign;
	    return;
        } else {
            /*  |b| <= |a| */
            sum->length=cvsub(sum->vec, a->vec, b->vec, 
				a->length, b->length);
	    if (!sum->length)
		sum->sign=PLUS;
	    else
            	sum->sign=a->sign;
	    return;
        }
}   }           /* IasIplI */

void ImiasI(a, b)
        register pInteger a;
	register const Integer *b;
/* a-=b; */
{   if (a->sign!=b->sign) {
        register int neededlength=a->length;
        if (neededlength<b->length) {
                neededlength=b->length;
        }
        neededlength++;
        if (neededlength>a->maxlength) {
            register pPLACE newv;
            register int oldlength=a->maxlength;
            a->maxlength=neededlength;
            newv=newvec(&a->maxlength);
            a->length=cvadd(newv, a->vec, b->vec, a->length, b->length);
            delvec(a->vec, oldlength);
            a->vec=newv;
            return;
        } else {
            a->length=cvadd(a->vec, a->vec, b->vec, a->length, b->length);
            return;
        }
    } else {
        /* Vorzeichen gleich, subtrahiere betragsmaessig 
                kleineres von groesserem */
        if ((b->length>a->length)||((b->length==a->length)
                        &&vecgt(b->vec, a->vec, a->length))) {
            /* |b|>|a| */
            register int neededlength=b->length;
            if (neededlength<=a->maxlength) {
		a->length=cvsub(a->vec, b->vec, a->vec, 
				b->length, a->length);
                a->sign^=MINUS;
                return;
            } else {
                register pPLACE newv;
                register int oldlength=a->maxlength;
                a->maxlength=neededlength;
                newv=newvec(&a->maxlength);
                a->length=cvsub(newv, b->vec, a->vec, 
				b->length, a->length);
                delvec(a->vec, oldlength);
                a->vec=newv;
                a->sign^=MINUS;
                return;
            }
        } else {
                /* |b| <= |a| */
		register int l=a->length;
		register PLACE * lp=&(a->vec[l-1]);
                cvecsubto(a->vec, b->vec, b->length);
		while ((l>0)&&(! *lp)) {
			l--; lp--;
		}
		a->length=l;
                if (!l)
                        a->sign = PLUS;
                return;
}   }   }       /* ImiasI */

void IasImiI(diff, a, b)
        register pInteger diff;
	register const Integer *a, *b;
/* diff=a-b; */
{   register int neededlength;
    if (diff==a) {
        ImiasI(diff, b);
	return;
    }
    if (diff==b) {
        ImiasI(diff, a);
	return;
    }
    if (a->sign!=b->sign) {     /* Addition */
        neededlength=a->length;
        if (neededlength<b->length)
            neededlength=b->length;
        neededlength++;
        if (neededlength>diff->maxlength) {
            delvec(diff->vec, diff->maxlength);
            diff->maxlength=neededlength;
            diff->vec=newvec(&diff->maxlength);
        }
        diff->length=cvadd(diff->vec, a->vec, b->vec, a->length, b->length);
        diff->sign=a->sign;
        return;
    } else {            /* Subtraktion */
        neededlength=a->length;
        if (neededlength<b->length)
            neededlength=b->length;
        if (neededlength>diff->maxlength) {      
            delvec(diff->vec, diff->maxlength);
            diff->maxlength=neededlength;
            diff->vec=newvec(&diff->maxlength);
        }
        if ((b->length>a->length) || (b->length==a->length)
                && vecgt(b->vec, a->vec, a->length)) {
            /*  |b| > |a| */
            diff->length=cvsub(diff->vec, b->vec, a->vec, 
				b->length, a->length);
            diff->sign=a->sign^MINUS;
	    return;
        } else {
            /*  |b| <= |a| */
            diff->length=cvsub(diff->vec, a->vec, b->vec, 
				a->length, b->length);
	    if (!diff->length)
		diff->sign=PLUS;
	    else
            	diff->sign=a->sign;
	    return;
        }
}   }           /* IasImiI */

void Iinc(a)
        register Integer *a;
/* a++; */
{   if (a->sign==PLUS) {
        register int neededlength=a->length+1;
	PLACE b=1;
        if (neededlength>a->maxlength) {
            register pPLACE newv;
	    register int oldlength=a->maxlength;
            a->maxlength=neededlength;
            newv=newvec(&a->maxlength);
            a->length=cvadd(newv, a->vec, &b, a->length, 1);
            delvec(a->vec, oldlength);
            a->vec=newv;
            return;
        } else {
	    a->length=cvadd(a->vec, a->vec, &b, a->length, 1);
            return;
        }
    } else {
        /* Subtrahiere 1 von |a| */
	register int l=a->length;
	register PLACE * lp=&(a->vec[l-1]);
	PLACE b=1;
	cvecsubto(a->vec, &b, 1);
	while ((l>0)&&(! *lp)) {
		l--; lp--;
	}
	a->length=l;
	if (!l)
		a->sign = PLUS;
	return;
}   }       	/* Iinc */

void Idec(a)
        register Integer *a;
/* a--; */
{   if (a->sign==MINUS) {
        register int neededlength=a->length+1;
	PLACE b=1;
        if (neededlength>a->maxlength) {
            register pPLACE newv;
	    register int oldlength=a->maxlength;
            a->maxlength=neededlength;
            newv=newvec(&a->maxlength);
            a->length=cvadd(newv, a->vec, &b, a->length, 1);
            delvec(a->vec, oldlength);
            a->vec=newv;
            return;
        } else {
	    a->length=cvadd(a->vec, a->vec, &b, a->length, 1);
            return;
    }   }
    if (!a->length) {
	a->sign=MINUS;
	a->length=1;
	a->vec[0]=1;
	return;
    } else {
        /* Subtrahiere 1 von |a| */
	register int l=a->length;
	register PLACE * lp=&(a->vec[l-1]);
	PLACE b=1;
	cvecsubto(a->vec, &b, 1);
	while ((l>0)&&(! *lp)) {
		l--; lp--;
	}
	a->length=l;
	return;
}   }       	/* Idec */


BOOLEAN IeqI(a, b)
/* return a==b; */
        register const Integer *a, *b;
{       if ((a->sign==b->sign)&&(a->length==b->length)&&
                veceq(a->vec, b->vec, a->length))
                return TRUE;
        else
                return FALSE;
}

BOOLEAN IgtI(a, b)
/* return a>b; */
        register const Integer *a, *b;
{       if (a->sign==PLUS) {
                if (b->sign==MINUS)
                        return TRUE;
                else {
                        if ((a->length>b->length)||((a->length==b->length)
                                        &&vecgt(a->vec, b->vec, a->length)))
                                return TRUE;
                        else
                                return FALSE;
                }
        } else {
                if (b->sign==PLUS)
                        return FALSE;
                else {
                        if ((a->length>b->length)||((a->length==b->length)
                                    &&!vecgt(b->vec, a->vec, a->length)))
                                return FALSE;
                        else
                                return TRUE;
}       }       }       /* IgtI */

void Ineg(a)
	register pInteger a;
{	if (a->length)
		a->sign^=MINUS;
}

BOOLEAN IneI(a, b)
/* return a!=b; */
        const Integer *a, *b;
{       return !IeqI(a, b);
}

BOOLEAN IgeI(a, b)
/* return a>=b; */
        const Integer *a, *b;
{       return !IgtI(b, a);
}

BOOLEAN IltI(a, b)
/* return a<b; */
        const Integer *a, *b;
{       return IgtI(b, a);
}

BOOLEAN IleI(a, b)
/* return a<=b; */
        const Integer *a, *b;
{       return !IgtI(a, b);
}

BOOLEAN Ige0(a)
	const Integer *a;
{	return (a->sign==PLUS);
}

BOOLEAN Igt0(a)
	const Integer *a;
{	return ((a->sign==PLUS)&&(a->length));
}

BOOLEAN Ile0(a)
	const Integer *a;
{	return (!a->length || (a->sign==MINUS));
}

BOOLEAN Ilt0(a)
	const Integer *a;
{	return (a->sign==MINUS);
}

BOOLEAN Ieq0(a)
	const Integer *a;
{	return (!a->length);
}

BOOLEAN Ieq1(a)
	const Integer *a;
{	if ((*(a->vec)==1)&&(a->length==1)&&(a->sign==PLUS))
		return TRUE;
	else
		return FALSE;
}

int sign(a)
	const Integer *a;
{	if (!a->length) { return 0; }
        else {
          if (a->sign==PLUS) { return 1; }
          else { return -1; }
        }
}
