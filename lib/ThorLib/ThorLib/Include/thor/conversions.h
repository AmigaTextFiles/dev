/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 ** $Id: conversions.h,v 1.2 2002/05/12 21:23:09 thor Exp $             **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Conversion between number formats                                   **
 **                                                                     **
 *************************************************************************/

#ifndef CONVERSIONS_H
#define CONVERSIONS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef FIXED_H
#include <thor/fixed.h>
#endif

typedef long            shortfloat;             /* IEEE-single precision */
typedef double          doublefloat;            /* IEEE-double precision */
typedef long            extendedfloat[3];       /* Motorola MC68881 extended precision */
typedef long            packedfloat[3];         /* Motorola MC68881 packed decimal */
typedef long            fastfloat;              /* Motorola MC680xx fast floating point firmware */


/* convert double <-> extended */
void __regargs DToX(doublefloat *in,extendedfloat out);
void __regargs XToD(extendedfloat in,doublefloat *out);

/* convert single <-> extended */
void __regargs SToX(shortfloat *in,extendedfloat out);
void __regargs XToS(extendedfloat in,shortfloat *out);

/* convert packed <-> extended */
void __regargs PToX(packedfloat in,extendedfloat out);
void __regargs XToP(extendedfloat in,packedfloat out);

/* convert to FFP, the other direction is missing */
short __regargs XToFFP(extendedfloat in,fastfloat *out);


/* convert long integer to and from ascii */
#ifdef _SHORTINT
BOOL __regargs AToInt(char *s,long *final);
void __regargs IntToA(char *buffer,long number);
BOOL __regargs AToI(char *s,long *final);
void __regargs IToA(char *buffer,long number);
#else   /* ARRGGH! for backwards-compatibility */
BOOL __regargs AToInt(char *s,int *final);
void __regargs IntToA(char *buffer,int number);
BOOL __regargs AToI(char *s,int *final);
void __regargs IToA(char *buffer,int number);
#endif

/* convert all bases to long */
BOOL __asm StrToL(register __a0 char *in, register __a1 char **np,
                  register __a2 int *result, register __d0 int base);

/* convert long fixed point to and from ascii */
BOOL __regargs AToLixed(char *s,Lixed *final);
void __regargs LixedToA(char *buffer,Lixed number);

/* convert extended float to and from ascii */
BOOL __regargs AToX(char **s,extendedfloat final);
void __regargs XToA(extendedfloat in,char *s);

/*
 * Service routines for numeric conversions.
 */
LONG __asm AToXMain(register __a0 UBYTE **src,register __a1 extendedfloat dest);
BOOL __regargs XPowTen(extendedfloat number,LONG pow);
LONG __asm XToAMain(register __a0 extendedfloat number,register __a1 UBYTE *dst,register __d0 UWORD digits);

/* convert double precision to and from ascii */
BOOL __regargs AToDouble(char *s,double *final);
void __regargs DoubleToA(register char *buffer,double number);

/* C stdlib compatible stupid atof */
#ifdef _OVERLOAD_STDLIB_
double __asm atof(register __a0 char *num);
char __asm *ecvtr(register __a0 int *index,register __a1 int *sign,register __a2 char *output,register __a3 double *in,register __d0 int digits);
#endif
#endif

