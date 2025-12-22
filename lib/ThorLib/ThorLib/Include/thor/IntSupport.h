/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for ints, tiny math support                       **
 **                                                                     **
 *************************************************************************/

#ifndef INTSUPPORT_H
#define INTSUPPORT_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* calculate upper approximation for binary logarithm */
UWORD __asm lbint(register __d0 ULONG x);


/* calculate lower approximation for square root */
ULONG __asm sqrtlower(register __d0 LONG x);

/* calculate upper approximation for square root */
ULONG __asm sqrtint(register __d0 LONG x);

/* calculate an approximation for p/q with "small" nominator and denominator.
   usefull for scaling graphics on abitrary screen format */
void __asm MakeRational(register __a0 int *p,register __a1 int *q);

/* calculate the greatest common divisor of two integers */
int __asm GCD(register __d0 int a,register __d1 int b);

/* fast random generator with autoseed and timer, set seed below if you
   REALLY want (normally not necessary, does not generate the same numbers
   except you have a time machine (-: */
ULONG __asm FastRand(void);

/* ranged random generator using FastRand */
UWORD __asm RangeRand(register __d0 UWORD limit);

/* random seed. Must be defined somewhere in your program, but need not to
   be set in general */
extern int seed;

#endif
