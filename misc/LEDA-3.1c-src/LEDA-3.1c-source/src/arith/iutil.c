/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iutil.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*      iutil.c         RD, 22.12.89    */
/*	Added functions cIasuint, cIaslong, cIasulong,
		Iisint, Iisuint, Iislong, Iisulong,
		intasI, uintasI, longasI, ulongasI, RD, 16.12.91
	Put definition of INTTOPLACE into iutil.c, RD, 16.12.91
*/

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>
#include <stdio.h>

#define INTTOPLACE  ((sizeof(int)+sizeof(PLACE)-1)/sizeof(PLACE))
#define LONGTOPLACE ((sizeof(long)+sizeof(PLACE)-1)/sizeof(PLACE))

void cI(a)
        register Integer * a;
{       a->sign=PLUS;
        a->length=0;
        a->maxlength=INITLENGTH;
        a->vec=newvec(&a->maxlength);
}       /* cI */

void cIasint(a, i)
        register Integer * a; register int i;
{       register int j;
        if (i<0) {
                a->sign=MINUS;
                i=-i;
        } else 
                a->sign=PLUS;
        a->maxlength=INTTOPLACE;
        a->vec=newvec(&a->maxlength);
	if ( INTTOPLACE == 1 ) {
		a->vec[0]=i;
		if ( i )
			a->length=1;
		else
			a->length=0;
		return;
	}
        j=0;
        while (i) {
                a->vec[j]=i;
                i>>=LOGPLACE;
		j++;
        }
	a->length=j;
}               /* cIasint */

void cIasuint(a, i)
        register Integer * a; register unsigned int i;
{       register int j;
        a->sign=PLUS;
        a->maxlength=INTTOPLACE;
        a->vec=newvec(&a->maxlength);
	if ( INTTOPLACE == 1 ) {
		a->vec[0]=i;
		if ( i )
			a->length=1;
		else
			a->length=0;
		return;
	}
        j=0;
        while (i) {
                a->vec[j]=i;
                i>>=LOGPLACE;
		j++;
        }
	a->length=j;
}               /* cIasuint */

void cIaslong(a, i)
        register Integer * a; register long i;
{       register int j;
        if (i<0) {
                a->sign=MINUS;
                i=-i;
        } else 
                a->sign=PLUS;
        a->maxlength=LONGTOPLACE;
        a->vec=newvec(&a->maxlength);
	if ( LONGTOPLACE == 1 ) {
		a->vec[0]=i;
		if ( i )
			a->length=1;
		else
			a->length=0;
		return;
	}
        j=0;
        while (i) {
                a->vec[j]=i;
                i>>=LOGPLACE;
		j++;
        }
	a->length=j;
}               /* cIaslong */

void cIasulong(a, i)
        register Integer * a; register unsigned long i;
{       register int j;
        a->sign=PLUS;
        a->maxlength=LONGTOPLACE;
        a->vec=newvec(&a->maxlength);
	if ( LONGTOPLACE == 1 ) {
		a->vec[0]=i;
		if ( i )
			a->length=1;
		else
			a->length=0;
		return;
	}
        j=0;
        while (i) {
                a->vec[j]=i;
                i>>=LOGPLACE;
		j++;
        }
	a->length=j;
}               /* cIasulong */

void cIasI(a, b)
/* create a from b */
        register Integer *a;
	register const Integer *b;
{       register int i;
        a->sign=b->sign;
        a->length=b->length;
        a->maxlength=b->length;
        a->vec=newvec(&a->maxlength);
        for (i=0; i<b->length; i++)
                a->vec[i]=b->vec[i];
}           	/* cIasI */

void cImaxlength(a, l)
        register Integer * a;
	int l;
{       a->sign=PLUS;
        a->length=0;
        a->maxlength=l;
        a->vec=newvec(&a->maxlength);
}       /* cI */

void dI(a)
        register Integer * a;
{       delvec(a->vec, a->maxlength);
        a->vec=NULL;
}

Integer *  ncI()
{	register Integer *a;
	a=newInteger();
	cI(a);
	return a;
}

Integer *  ncIasint(i)
	int i;
{	register Integer *a;
	a=newInteger();
	cIasint(a, i);
	return a;
}

Integer *  ncIasI(b)
	Integer *b;
{	register Integer *a;
	a=newInteger();
	cIasI(a, b);
	return a;
}

Integer *  ncImaxlength(l)
	int l;
{	register Integer *a;
	a=newInteger();
	cImaxlength(a, l);
	return a;
}

void ddI(a)
	Integer *a;
{	dI(a);
	delInteger(a);
}

/************************************/

void IasI(a, b)
        register Integer *a;
	register const Integer *b;
{       register int i;
        register int neededlength;
	a->sign=b->sign;
	neededlength=b->length;
	if (a->maxlength < neededlength) {
		delvec(a->vec, a->maxlength);
		a->maxlength=neededlength;
		a->vec=newvec(&a->maxlength);
	}
        a->length=neededlength;
        for (i=b->length-1; i>=0; i--)
                a->vec[i]=b->vec[i];
}               /* IasI */

void Iasint(a, i)
	register Integer * a; register int i;
{       register int j;
        if (i<0) {
                a->sign=MINUS;
                i=-i;
        } else 
                a->sign=PLUS;
	if ( INTTOPLACE == 1 ) {
		a->vec[0]=i;
		if ( i )
			a->length=1;
		else
			a->length=0;
		return;
	}
        j=0;
        while (i) {
                a->vec[j]=i;
                i>>=LOGPLACE;
		j++;
        }
	a->length=j;
}               /* Iasint */

void Ias0(a)
	register Integer * a;
{	a->length=0;
	a->sign=PLUS;
}

void Ias1(a)
	register Integer * a;
{	a->length=1;
	a->sign=PLUS;
	*(a->vec)=1;
}

/************************************/

int Ilog(a)
	const Integer * a;
/* return (groesste Ganze von log_2(|a|), bzw -1 falls a==0); */
{	register PLACE m;
	register int i, j;

	i=a->length;
	if (!i)
		return -1;
	j=0;
	m=a->vec[i-1];
	m>>=1;
	while(m) {
		m>>=1;
		j++;
	}
	return j+(i-1)*LOGPLACE;
}

int intlog(i)
	register int i;
/* return (groesste Ganze von log_2(|i|), bzw -1 falls a==0); */
{	register int j;

	if (!i)
		return -1;
	j=0;
	i>>=1;
	while(i) {
		i>>=1;
		j++;
	}
	return j;
}	/* intlog */

void Ierror(s)
	const char * s;
{	fprintf(stderr, "I: %s\n", s);
	exit(-1);
}		/* Ierror */

/******************************************************************/

static unsigned long maxint=(1<<sizeof(int)*8-1)-1;
static unsigned long maxnegint=(1<<sizeof(int)*8-1);
static unsigned long maxuint=1<<sizeof(int)*8;
static unsigned long maxlong=(1<<sizeof(long)*8-1)-1;
static unsigned long maxneglong=(1<<sizeof(long)*8-1);

BOOLEAN Iisint (a)
	const Integer * a;
{	register unsigned int u;
	register int i;
	if (!a->length)
		return TRUE;
	if (a->length>INTTOPLACE)
		return FALSE;
/* Maybe sizeof(int)<sizeof(PLACE), then INTTOPLACE==1 */
/* We assume that sizeof(long)>=sizeof(PLACE) */
	if (sizeof(int)<sizeof(PLACE))
		if (a->sign==PLUS)
			return a->vec[0] <= maxint;
		else
			return a->vec[0] <= maxnegint;
/* Now we assume that sizeof(PLACE) divides sizeof(int) ! */
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	if (a->sign==PLUS)
		return u <= maxint;
	else
		return u <= maxnegint;
}	/* Iisint */

BOOLEAN Iisuint (a)
	const Integer * a;
{	if (a->sign==MINUS)
		return FALSE;
	if (!a->length)
		return TRUE;
	if (a->length>INTTOPLACE)
		return FALSE;
/* Maybe sizeof(int)<sizeof(PLACE), then INTTOPLACE==1 */
/* We assume, that sizeof(long)>=sizeof(PLACE) */
	if (sizeof(int)<sizeof(PLACE))
		return a->vec[0] <= maxuint;
/* Now we assume, that sizeof(PLACE) divides sizeof(int) ! */
	return TRUE;
}	/* Iisuint */

BOOLEAN Iislong (a)
	const Integer * a;
{
/* We assume that sizeof(long)>=sizeof(PLACE) and
   that sizeof(PLACE) divides sizeof(long) ! */
	register unsigned long u;
	register int i;
	if (!a->length)
		return TRUE;
	if (a->length>LONGTOPLACE)
		return FALSE;
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	if (a->sign==PLUS)
		return u <= maxlong;
	else
		return u <= maxneglong;
}	/* Iislong */

BOOLEAN Iisulong (a)
	const Integer * a;
{	if (a->sign==MINUS)
		return FALSE;
/* We assume, that sizeof(PLACE) divides sizeof(long) ! */
	if (a->length<=LONGTOPLACE)
		return TRUE;
	else
		return FALSE;
}	/* Iisulong */


int intasI (a)
	const Integer * a;
/* We assume Iisint(a) to be true ! */
{	register unsigned int u;
	register int i;
	if (!a->length)
		return 0;
/* Maybe sizeof(int)<sizeof(PLACE), then INTTOPLACE==1 */
/* We assume that sizeof(long)>=sizeof(PLACE) */
	if (sizeof(int)<sizeof(PLACE))
		if (a->sign==PLUS)
			return a->vec[0];
		else
			return - a->vec[0];
/* Now we assume that sizeof(PLACE) divides sizeof(int) ! */
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	if (a->sign==PLUS)
		return u;
	else
		return -u;
}	/* intasI */

unsigned int uintasI (a)
	const Integer * a;
/* We assume Iisuint(a) to be true ! */
{	register unsigned int u;
	register int i;
	if (!a->length)
		return 0;
/* Maybe sizeof(int)<sizeof(PLACE), then INTTOPLACE==1 */
/* We assume that sizeof(long)>=sizeof(PLACE) */
	if (sizeof(int)<sizeof(PLACE))
		return a->vec[0];
/* Now we assume that sizeof(PLACE) divides sizeof(int) ! */
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	return u;
}	/* uintasI */

long longasI (a)
	const Integer * a;
/* We assume Iislong(a) to be true ! */
{
/* We assume that sizeof(long)>=sizeof(PLACE) and
   that sizeof(PLACE) divides sizeof(long) ! */
	register unsigned long u;
	register int i;
	if (!a->length)
		return 0;
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	if (a->sign==PLUS)
		return u;
	else
		return -u;
}	/* longasI */

unsigned long ulongasI (a)
	const Integer * a;
/* We assume Iisulong(a) to be true ! */
{
/* We assume, that sizeof(PLACE) divides sizeof(long) ! */
	register unsigned long u;
	register int i;
	if (!a->length)
		return 0;
	u=0;
	for (i=a->length-1; i>=0; i--) {
		u<<=LOGPLACE;
		u+=a->vec[i];
	}
	return u;
}	/* ulongasI */



