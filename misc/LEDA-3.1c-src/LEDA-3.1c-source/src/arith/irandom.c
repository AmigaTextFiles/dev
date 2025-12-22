/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  irandom.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/* 	irandom.c	RD, 26.03.90 */

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

#include <time.h>
#include <sys/types.h>

static PLACE Prandom()
	/* return  random 16/31 bits; */
{	unsigned int x;
        time_t seed;
	static BOOLEAN init=FALSE;

	if (!init) {
		init=TRUE;
		time(&seed);
		srandom((int)seed);
	}
	return random();
}		/* Prandom */

void IasrandomI(a, b)
	Integer *a;
	const Integer *b;
/* waehle a zufaellig mit 0<=|a|<|b|, a->sign=b->sign.
   a und b muessen verschieden sein. */
{	register int i;
	register pPLACE pa;
	register int nl;
	nl=b->length;
	if (nl>a->maxlength) {
		delvec(a->vec, a->maxlength);
		a->maxlength=nl;
		a->vec=newvec(&a->maxlength);
	}
	pa=a->vec;
	pa[nl-1]=Prandom()%(b->vec[nl-1]);
	for (i=nl-2; i>=0; i--)
		pa[i]=Prandom();
	i=nl;
	while (!pa[i-1] && i>0)
		i--;
	a->length=i;
	if (i)
		a->sign=b->sign;
	else
		a->sign=PLUS;
}			/* IasrandomI */
