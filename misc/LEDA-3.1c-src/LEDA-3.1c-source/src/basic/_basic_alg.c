/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _basic_alg.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/basic_alg.h>

#define SWAP(a,b) { help = *a; *a = *b; *b = help; }


int SELECT(int* l, int* r, int pos)
{ 
  // compute element at position "pos" in sequence *l,...,*r
  // expected running time: O(r-l)

  register int* i;
  register int* k;
  register int s;
  register int help;

  while (l < r) 
  { i = l+(r-l)/2;
    if (*i > *r) SWAP(i,r);
    SWAP(l,i);

    i = l;
    k = r;
    s = *l;

    for(;;)
    { while (*(++i) < s);
      while (*(--k) > s);
      if (i<k) SWAP(i,k) else break;
     }
  
    SWAP(l,k);
  
    int j =  k-l+1;
    if (pos <= j) 
       r = k;
    else 
       { l = k+1;
         pos -= j;
        }
  }

  return *l;
}



double SELECT(double* l, double* r, int pos)
{ 
  register double* i;
  register double* k;
  register double s;
  register double help;

  while (l < r) 
  { i = l+(r-l)/2;
    if (*i > *r) SWAP(i,r);
    SWAP(l,i);

    i = l;
    k = r;
    s = *l;

    for(;;)
    { while (*(++i) < s);
      while (*(--k) > s);
      if (i<k) SWAP(i,k) else break;
     }
  
    SWAP(l,k);
  
    int j =  k-l+1;
    if (pos <= j) 
       r = k;
    else 
       { l = k+1;
         pos -= j;
        }
  }

  return *l;
}

