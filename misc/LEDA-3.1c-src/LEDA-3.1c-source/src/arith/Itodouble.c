/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  Itodouble.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/impl/iint.h>
#include <LEDA/impl/iloc.h>


/* S. Naeher   (Feb. 1994) */


double Itodouble (a)
	const Integer * a;
{ register double d=0.0;
  register int i;

  for (i=a->length-1; i>=0; i--)
  { unsigned long w = a->vec[i];
    unsigned long b;
    for(b = 1<<(LOGPLACE-1); b != 0; b>>=1)
    { d *= 2.0;
      if (w & b) d += 1.0;
     }
   }
  if (a->sign==PLUS)
     return(d);
  else
     return(-d);
}

