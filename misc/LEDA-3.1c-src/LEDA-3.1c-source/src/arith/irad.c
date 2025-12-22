/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  irad.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>

EXTERN_FUNCTION(void radaddto, (PLACE *a, PLACE *b, PLACE *carry));
        /* a=a+b+carry, Uebertrag in carry */
EXTERN_FUNCTION(void radsubto, (PLACE *a, PLACE *b, PLACE *carry));
        /* a=a-b-carry, Uebertrag in carry */
EXTERN_FUNCTION(void radmul, (PLACE *a, PLACE *b, PLACE *m, PLACE *carry));
        /* m=m+a*b+carry, Uebertrag in carry */
EXTERN_FUNCTION(void raddiv, (PLACE *h, PLACE *l, PLACE *n, PLACE *q));
        /* h*RADIX+l / n ergibt Quotient q und Rest h */


#ifndef ATARI
void radaddto(a, b, carry)
        PLACE *a, *b, *carry;
        /* Addiere *b und *carry zu *a, Uebertrag in *carry */
{       register DOUBLEPLACE accu = 0;
        accu = *a;
        accu += *b;
        accu += *carry;
        *a = accu;
        /* *carry = accu >> LOGPLACE; */
        *carry = 0;
}
#endif

void radsubto(a, b, carry)
        PLACE *a, *b, *carry;
        /* Subtrahiere *b und *carry von *a, Uebertrag in *carry
              und zwar 0 oder 1                 */
{       register DOUBLEPLACE accu = 0;
        accu = *a;
        accu -= *b;
        accu -= *carry;
        *a = accu;
        /* accu >>= LOGPLACE; */
        accu  &= 1;
        *carry = accu;
}

#ifndef __PARC__
#ifndef ATARI
void radmul(a, b, m, carry)
        PLACE *a, *b, *m, *carry;
        /* Multipliziere und addiere:
              accu   = *a * *b + *m + *carry;
              *m     = accu % RADIX;
              *carry = accu / RADIX;    */
{       register DOUBLEPLACE accu = 0;
        accu = *a;
        accu *= *b;
        accu += *m;
        accu += *carry;
        *m = accu;
        /* *carry = accu >> LOGPLACE; */
        *carry = 0;
}
#endif
#endif

#ifndef __PARC__
#ifndef ATARI
void raddiv(h, l, n, q)
        PLACE *h, *l, *n, *q;
        /* Division mit Rest
              (*h)*RADIX + (*l) == (*n)*(*q) + (*r)
              Voraussetzung:     *h < *n                */
{       register DOUBLEPLACE accu = 0;
        accu = *h; 
        /* accu <<= LOGPLACE; */
        accu += *l;
        *q = accu / *n;
        *h = accu % *n;
}
#endif
#endif

/************************************************************/

#ifdef USE_PLACE_RAD

void radaddto(a, b, carry)
        PLACE *a, *b, *carry;
        /* Addiere *b und *carry zu *a, Uebertrag in *carry */
{       *carry=PLACEadd(*a, *b, *carry, a);
}

void radsubto(a, b, carry)
        PLACE *a, *b, *carry;
        /* Subtrahiere *b und *carry von *a, Uebertrag in *carry
              und zwar 0 oder 1                 */
{       *carry=PLACEsub(*a, *b, *carry, a);
}

void radmul(a, b, m, carry)
        PLACE *a, *b, *m, *carry;
        /* Multipliziere und addiere:
              accu   = *a * *b + *m + *carry;
              *m     = accu % RADIX;
              *carry = accu / RADIX;    */
{       *carry=PLACEmuladd(*a, *b, *carry, m);
}

void raddiv(h, l, n, q)
        PLACE *h, *l, *n, *q;
        /* Division mit Rest
              (*h)*RADIX + (*l) == (*n)*(*q) + (*r)
              Voraussetzung:     *h < *n                */
{       *h=PLACEdiv(*h, *l, *n, q);
}

#endif
