/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  iint.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*              iint.h          RD, 18.12.89 */
/* 	Modified for usage of c_varieties.h to provide
	better portability between vanilla C, ANSI C and C++.
			RD, 07.12.90.
	Incorporated the definitions of c_varieties.h
	as some compilers for Transputers aren't that
	happy with c_varieties.h. Placed the compiler dependencies
	in iint.h.
			RD, 12.04.91.
	Added special definitions for sparc, RD, 10/91.
	Added "const" specifier for parameters, RD, 04.11.91.
	Added functions cIasuint, cIaslong, cIasulong,
		Iisint, Iisuint, Iislong, Iisulong,
		intasI, uintasI, longasI, ulongasI, RD, 16.12.91
	Put definition of INTTOPLACE into iutil.c, RD, 16.12.91
*/

#ifndef _IINT_H
#define _IINT_H

/* 	stdio.h is needed for the definition of FILE 	*/

#ifndef __PARC__
#include <stdio.h>
#endif

/*	Here are the compiler dependencies	*/

#ifdef ATARI
#define UNSIGNED16	unsigned int
#define UNSIGNED32	unsigned long
#define SIGNED32	long
#include <malloc.h>
#define MYMALLOC	malloc
#define MYFREE	free
#endif

#ifdef sun
#ifdef sparc
#define UNSIGNED16	unsigned short
#define UNSIGNED32	unsigned long
#define SIGNED32	long
#define UNSIGNED64	unsigned long
#define SIGNED64	long
/* Wrong definition, but never used */
#define USE_64_BIT_INTEGERS
#define USE_SPARC_ASM
#else
#define UNSIGNED16	unsigned short
#define UNSIGNED32	unsigned long
#define SIGNED32	long
#define USE_DOUBLEPLACE
#endif
/*
#include <malloc.h>
*/
#define MYMALLOC	malloc
#define MYFREE	free
#endif

#ifdef HELIOS
#define USE_DOUBLEPLACE
#define UNSIGNED16	unsigned short
#define UNSIGNED32	unsigned long
#define SIGNED32	long
#include <stdlib.h>
#define MYMALLOC	malloc
#define MYFREE	free
#endif

#ifdef __PARC__
#define USE_64_BIT_INTEGERS
#define USE_DOUBLEPLACE
#define UNSIGNED16	unsigned short
#define UNSIGNED32	unsigned int
#define SIGNED32	int
#define UNSIGNED64	unsigned long
#define SIGNED64	long
#include <stdlib.h>
#define MYMALLOC	malloc
#define MYFREE	free
#endif

#ifdef NeXT
#define USE_DOUBLEPLACE
#define UNSIGNED16	unsigned short
#define UNSIGNED32      unsigned long
#define SIGNED32        long
#include <stdlib.h>
#define MYMALLOC        malloc
#define MYFREE		free
#endif

#ifndef UNSIGNED16
#define USE_DOUBLEPLACE
#define UNSIGNED16	unsigned short
#define UNSIGNED32      unsigned long
#define SIGNED32        long
/*
#include <malloc.h>
*/
#define MYMALLOC        malloc
#define MYFREE		free
#endif

/*	Now let us see what are the biggest integers to use	*/

#ifndef USE_64_BIT_INTEGERS
    typedef	UNSIGNED16	PLACE, *pPLACE;
#define LOGPLACE 16
#else
    typedef	UNSIGNED32	PLACE, *pPLACE;
#define LOGPLACE 32
#endif

/*	Here is the part of c_varieties.h we shall use	*/

#ifndef C_VARIETIES_H

#ifdef __cplusplus
#define EXTERN_FUNCTION( rtn, args ) extern "C" { rtn args; }
#define _VOID_ /* anachronism */
#else
#ifdef __STDC__
#ifdef __PARC__
#define EXTERN_FUNCTION( rtn, args ) rtn()
#define _VOID_
#define const
#else
#define EXTERN_FUNCTION( rtn, args ) rtn args
#define _VOID_ void
#endif
#else
#define EXTERN_FUNCTION( rtn, args ) rtn()
#define _VOID_
#define const
#endif
#endif

#endif

/*	And now come some basic definitions	*/

#ifndef BOOLEANDEF
#define BOOLEANDEF
    typedef int     BOOLEAN;
#endif
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
#ifndef NULL
#define NULL 0
#endif

#define PLUS 0
#define MINUS 1

/*	This is the main data type	*/

typedef struct {
    PLACE          *vec;
    int             maxlength, length, sign;
}               Integer, *pInteger;

/*      Meaning of the function names:
        I:      Integer
        int:    int
        as:     assign
        pl:     plus
        mi:     minus
	eq:	equal
	gt:	greater than
	mu:	multiply
	sl:	shift left
	sr:	shift right
*/

EXTERN_FUNCTION(void cI, (Integer *));			/* Creator */
EXTERN_FUNCTION(void cIasint, (Integer *, int));	/* Creator + Init int */
EXTERN_FUNCTION(void cIasuint, (Integer *, unsigned int));
	/* Creator + Init unsigned int */
EXTERN_FUNCTION(void cIaslong, (Integer *, long));
	/* Creator + Init long */
EXTERN_FUNCTION(void cIasulong, (Integer *, unsigned long));
	/* Creator + Init unsigned long */
EXTERN_FUNCTION(void cIasI, (Integer *, const Integer *));
	/* Creator + Init Int */
EXTERN_FUNCTION(void cImaxlength, (Integer *, int));
 	/* maxlength wird vorgegeben */
EXTERN_FUNCTION(void dI, (Integer *));			/* Destructor */

EXTERN_FUNCTION(Integer * ncI, (_VOID_));		/* new Integer + cI */
EXTERN_FUNCTION(Integer * ncIasint, (int));	/* new Integer + cIasint */
EXTERN_FUNCTION(Integer * ncIasI, (Integer *));	/* new Integer + cIasI */
EXTERN_FUNCTION(Integer * ncImaxlength, (int));	/* new Integer + cImaxlength */
EXTERN_FUNCTION(void ddI, (Integer *));		/* dI + delete Integer */

EXTERN_FUNCTION(void Ierror, (const char *));	/* Fehlermeldung */
EXTERN_FUNCTION(char *Imalloc, (int));	/* Systemunabhaengiges malloc */
EXTERN_FUNCTION(void Ifree, (char *));	/* 	"	free */

EXTERN_FUNCTION(void IasI, (Integer *, const Integer *));	/* Zuweisung */
EXTERN_FUNCTION(void Iasint, (Integer *, int));	    /* Zuweisung einer int */
EXTERN_FUNCTION(void Ias0, (Integer *));
EXTERN_FUNCTION(void Ias1, (Integer *));
#ifdef USE_THIS_LOT_OF_MACROS
#define IAS0(A) ((A)->length=0, (A)->sign=PLUS)
#define IAS1(A) ((A)->length=1, *((A)->vec)=1, (A)->sign=PLUS)
#endif
EXTERN_FUNCTION(BOOLEAN Iisint, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Iisuint, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Iislong, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Iisulong, (const Integer *));
EXTERN_FUNCTION(int intasI, (const Integer *));
EXTERN_FUNCTION(unsigned int uintasI, (const Integer *));
EXTERN_FUNCTION(long longasI, (const Integer *));
EXTERN_FUNCTION(unsigned long ulongasI, (const Integer *));

EXTERN_FUNCTION(int Ilog, (const Integer *));	/* Zweier Logarithmus */
EXTERN_FUNCTION(int intlog, (int));	/* Zweier Logarithmus */

EXTERN_FUNCTION(void IasIplI, (Integer *, const Integer *, const Integer *));
	/* Addition + */
EXTERN_FUNCTION(void IasImiI, (Integer *, const Integer *, const Integer *));
	/* Subtraktion - */
EXTERN_FUNCTION(void IplasI, (Integer *, const Integer *));
	/* Addition += */
EXTERN_FUNCTION(void ImiasI, (Integer *, const Integer *));
	/* Subtraktion -= */
EXTERN_FUNCTION(void Ineg, (Integer *));
	/* aendere das Vorzeichen */
EXTERN_FUNCTION(void Iinc, (Integer *));		/* ++ */
EXTERN_FUNCTION(void Idec, (Integer *));		/* -- */

EXTERN_FUNCTION(BOOLEAN IeqI, (const Integer *, const Integer *));
	/* Vergleich == */
EXTERN_FUNCTION(BOOLEAN IgtI, (const Integer *, const Integer *));
	/* Groesser > */
EXTERN_FUNCTION(BOOLEAN IneI, (const Integer *, const Integer *));
EXTERN_FUNCTION(BOOLEAN IgeI, (const Integer *, const Integer *));
EXTERN_FUNCTION(BOOLEAN IltI, (const Integer *, const Integer *));
EXTERN_FUNCTION(BOOLEAN IleI, (const Integer *, const Integer *));
EXTERN_FUNCTION(BOOLEAN Ige0, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Igt0, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Ile0, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Ilt0, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Ieq0, (const Integer *));
EXTERN_FUNCTION(BOOLEAN Ieq1, (const Integer *));
EXTERN_FUNCTION(int sign, (const Integer *)); /* returns +1, 0, -1 */

#ifdef USE_THIS_LOT_OF_MACROS
#define INEI(A, B)	(!IeqI((A), (B)))
#define IGEI(A, B)	(!IgtI((B), (A)))
#define ILTI(A, B)	(IgtI((B), (A)))
#define ILEI(A, B)	(!IgtI((A), (B)))
#define IGE0(A)		((A)->sign==PLUS)
#define IGT0(A)		(((A)->sign==PLUS)&&((A)->length))
#define ILE0(A)		(!(A)->length || ((A)->sign==MINUS))
#define ILT0(A)		((A)->sign==MINUS)
#define IEQ0(A)		(!(A)->length)
#define IEQ1(A)	((*((A)->vec)==1)&&((A)->length==1)&&((A)->sign==PLUS))
#endif

EXTERN_FUNCTION(void IasImuI, (Integer *, const Integer *, const Integer *));
	/* Multiplikation * */
EXTERN_FUNCTION(void ImuasI, (Integer *, const Integer *));
	/* Multiplikation *= */
EXTERN_FUNCTION(void IasImuP, (Integer *, const Integer *, PLACE));
	/* Multiplikation mit PLACE */
EXTERN_FUNCTION(void ImuasP, (Integer *, PLACE));

EXTERN_FUNCTION(void IasIsrint, (Integer *, const Integer *, unsigned int));
	/* Shift nach rechts */
EXTERN_FUNCTION(void Israsint, (Integer *, unsigned int));
	/* Shift nach rechts */
EXTERN_FUNCTION(void IasIslint, (Integer *, const Integer *, unsigned int));
	/* Shift nach links */
EXTERN_FUNCTION(void Islasint, (Integer *, unsigned int));
	/* Shift nach links */
EXTERN_FUNCTION(BOOLEAN Isr1, (Integer *));	/* Shift um eine Stelle */
EXTERN_FUNCTION(BOOLEAN Ieven, (const Integer *));	/* ist a gerade? */
#ifdef USE_THIS_LOT_OF_MACROS
#define IEVEN(A)	(!(*((A)->vec) & 1))
#endif

EXTERN_FUNCTION(PLACE uIdiasP, (Integer *, PLACE));
	/* Division durch PLACE, kein Vorzeichen, Rest wird zurueckgegeben. */
EXTERN_FUNCTION(PLACE IdiasP, (Integer *, PLACE));
	/* Division durch PLACE, mit Vorzeichen, Rest wird zurueckgegeben. */
EXTERN_FUNCTION(PLACE uIasIdiP, (Integer *, const Integer *, PLACE));
	/* Division durch PLACE, kein Vorzeichen, Rest wird zurueckgegeben. */
EXTERN_FUNCTION(PLACE IasIdiP, (Integer *, const Integer *, PLACE));
	/* Division durch PLACE, mit Vorzeichen, Rest wird zurueckgegeben. */
EXTERN_FUNCTION(void uIdiv, (Integer *q, Integer *r, const Integer *a, const Integer *b));
	/* Division mit Rest a=bq+r, kein Vorzeichen */
EXTERN_FUNCTION(void Idiv, (Integer *q, Integer *r, const Integer *a, const Integer *b));
	/* Division mit Rest a=bq+r, mit Vorzeichen */
EXTERN_FUNCTION(void IasIdiI, (Integer *, const Integer *, const Integer *));
	/* Division, Quotient */
EXTERN_FUNCTION(void IasIreI, (Integer *, const Integer *, const Integer *));
	/* Division, Rest */
EXTERN_FUNCTION(void IdiasI, (Integer *, const Integer *));
	/* Division, Quotient */
EXTERN_FUNCTION(void IreasI, (Integer *, const Integer *));
	/* Division, Rest */

EXTERN_FUNCTION(int fscanI, (FILE *, Integer *));	/* Eingabe von Datei */
EXTERN_FUNCTION(int fprintI, (FILE *, const Integer *));
	/* Ausgabe auf Datei */

EXTERN_FUNCTION(void Idgcd, (Integer *d, const Integer *a, const Integer *b));
	/* Euklidscher Algorithmus (Division)  d=gcd(a, b); */
EXTERN_FUNCTION(void Ibgcd, (Integer *d, const Integer *a, const Integer *b));
	/* binaerer gcd */
#define Igcd	Ibgcd
	/* Standard gcd	*/
EXTERN_FUNCTION(void Ielba,(Integer*d,Integer*u,Integer*v,const Integer*a,const Integer*b));
	/* Euklid-Lenstra-Berlekamp  d=gcd(a, b)==ua+vb; */
EXTERN_FUNCTION(void Ibelba,(Integer*d,Integer*u,Integer*v,const Integer*a,const Integer*b));
	/* binaerer ELBA */
EXTERN_FUNCTION(void Ireduce, (Integer *a, Integer *b));	/* Kuerze gcd */

EXTERN_FUNCTION(void IasrandomI, (Integer * a, const Integer * b));
 /*
  * Zufallsgenerator: waehle a zufaellig mit 0<=|a|<|b|, a->sign=b->sign.
  * a und b muessen verschieden sein.
  */

EXTERN_FUNCTION(char *wIdata1, (const Integer * a, int *l));
 /*
  * Erster Teil der Daten zum schnellen Speichern oder Verschicken einer
  * Integer a: l = Anzahl der bytes; return Basisadresse.
  */
EXTERN_FUNCTION(char *wIdata2, (const Integer * a, int *l));
 /* Zweiter Teil der Daten. */
EXTERN_FUNCTION(char *rIdata1, (const Integer * a, int *l));
 /*
  * Zieladresse und Laenge fuer das Lesen oder Empfangen einer Integer,
  * erster Teil.
  */
EXTERN_FUNCTION(char *rIdata2, (Integer * a, int *l));
 /*
  * Zweiter Teil zum Empfangen oder Lesen. Vor Aufruf dieser Funktion muss
  * der erste Teil der Integer an die Adresse aus dem rIdata1-Aufruf
  * geschrieben sein.
  */

EXTERN_FUNCTION(int Itoa, (const Integer * n, char s[]));
EXTERN_FUNCTION(int atoI, (char s[], Integer * n));

/*
EXTERN_FUNCTION(_VOID_ Iprint_statistics, (_VOID_));
*/

EXTERN_FUNCTION(double Itodouble, (const Integer *));

#endif
