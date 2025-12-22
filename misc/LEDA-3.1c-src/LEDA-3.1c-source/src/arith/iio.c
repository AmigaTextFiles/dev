/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iio.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*	iio.c,		RD, 20.02.90 */

#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>
#include <stdio.h>
#include <ctype.h>

int fscanI(fp, a)
	FILE *fp;
	pInteger a;
{	register int c, count;
	int sign=PLUS;
	Integer help;

	cI(&help);
	count=0;
	do {
		c=getc(fp);
		count++;
	} while (isspace(c));
	if (c=='-') {
		sign=MINUS;
		c=getc(fp);
		count++;
	} else if (c=='+') {
		c=getc(fp);
		count++;
	}
	while (c=='0') {
		c=getc(fp);
		count++;
	}
	Iasint(a, 0);
	while (isdigit(c)) {
		ImuasP(a, 10);
		Iasint(&help, c-'0');
		IplasI(a, &help);
		c=getc(fp);
		count++;
	}
	ungetc(c, fp);
	count--;
	if (!Ieq0(a))
		a->sign=sign;
	dI(&help);
	return count;
}		/* fscanI */

int fprintI(fp, a)
	FILE *fp;
	const Integer *a;
{	char *s;
	int i, sl, count=0;
	Integer help;

	sl=Ilog(a);
	sl=sl/3+2;
	s=(char*)Imalloc(sl*sizeof(char));
	if (!s)
		Ierror("fprintI: no memory available\n");
#ifdef USE_DIRECT_OUTPUT_CONVERSION
	if (sl==-1) {
		putc('0', fp);
		count++;
		return count;
	}
	if (Ilt0(a)) {
		putc('-', fp);
		count++;
	}
	cIasI(&help, a);
	i=0;
	while (!Ieq0(&help)) {
		s[i]='0'+uIdiasP(&help, 10);
		i++;
	}
	dI(&help);
	i--;
	for (; i>=0; i--) {
		putc(s[i], fp);
		count++;
	}
#else
	count=Itoa(a, s);
	for ( i=0; i<count; i++ )
		putc(s[i], fp);
#endif
	Ifree(s);
	return count;
}		/* fprintI */

/******************************************/

char * wIdata1(a, l)
	const Integer * a;
	int * l;
{	*l=sizeof(int) + sizeof(int);
	return (char *) (& a->length);
}

char * wIdata2(a, l)
	const Integer * a;
	int * l;
{	*l=a->length * sizeof(PLACE);
	return (char *) a->vec;
}

char * rIdata1(a, l)
	const Integer * a;
	int * l;
{	*l=sizeof(int) + sizeof(int);
	return (char *) (& a->length);
}

char * rIdata2(a, l)
	Integer * a;
	int * l;
{	int nl=a->length;
	if (nl > a->maxlength) {
		delvec(a->vec, a->maxlength);
		a->maxlength=nl;
		a->vec=newvec(&a->maxlength);
	}
	*l=nl * sizeof(PLACE);
	return (char *) a->vec;
}

/************************************/

#if HALFRADIX > 1000000000
#define DECCONV 1000000000
#define NCONV	9
#else
#define DECCONV 10000
#define NCONV	4
#endif

int Itoa(n, s)
	const Integer *n;
	char s[];
{	int count=0;
	Integer help;
	char *p, *q, c;

	if (Ieq0(n)) {
		s[count]='0';
		count++;
		s[count]='\0';
		return count;
	}
	if (Ilt0(n)) {
		s[count]='-';
		count++;
	}
	cIasI(&help, n);
	while (!Ieq0(&help)) {
		int rem=uIdiasP(&help, DECCONV);
		if (Ieq0(&help)) {	/* skip leading 0 */
			while ( rem ) {
				s[count]='0'+ rem % 10;
				count++;
				rem /= 10;
			}
		} else {		/* print leading 0 */
			int i;
			for (i=0; i<NCONV; i++) {
				s[count]='0'+ rem % 10; 
				count++; 
				rem /= 10; 
			}   
		}
	}
	dI(&help);
	/* Vertausche Stringeintraege, damit hoeherwertige Stellen
		vorne stehen.
	*/
	if (Ilt0(n))
		p=&s[1];
	else
		p=&s[0];
	q=&s[count-1];
	while (p<q) {
		c=*p;
		*p++=*q;
		*q--=c;
	}
	s[count]='\0';
	return count;
}		/* Itoa */

int atoI(s, n)
	char s[];
	Integer *n;
{	register int c, count;
	Integer help;
	int sign=PLUS;

	cI(&help);
	count=0;
	do {
		c=s[count];
		count++;
	} while (isspace(c));
	if (c=='-') {
		sign=MINUS;
		c=s[count];
		count++;
	} else if (c=='+') {
		c=s[count];
		count++;
	}
	while (c=='0') {
		c=s[count];
		count++;
	}
	Iasint(n, 0);
	while (isdigit(c)) {
		ImuasP(n, 10);
		Iasint(&help, c-'0');
		IplasI(n, &help);
		c=s[count];
		count++;
	}
	count--;
	if (!Ieq0(n))
		n->sign=sign;
	dI(&help);
	return count;
}		/* atoI */
