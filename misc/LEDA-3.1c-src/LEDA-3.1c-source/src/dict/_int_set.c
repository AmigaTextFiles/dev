/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _int_set.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/int_set.h>

typedef unsigned long  word;

int_set::int_set(int n)
{ size = n; 
  low = 0;
  register int i = 1+size/32;
  if ((V=new word[i]) == 0) error_handler(1,"int_set: out of memory"); 
  while (i--) V[i]=0;
 } 

int_set::int_set(int a, int b)
{ size = b-a+1; 
  low = a;
  register int i = 1+size/32;
  if ((V=new word[i]) == 0) error_handler(1,"int_set: out of memory"); 
  while (i--) V[i]=0;
 } 

int_set::int_set(const int_set& b)
{ size = b.size;
  low  = b.low;
  register int n = 1+size/32;
  V = new word[n];
  while (n--) V[n] = b.V[n];
}

int_set& int_set::operator=(const int_set& b)
{ if (this == &b) return *this;
  delete V;
  size = b.size;
  low  = b.low;
  register int n = 1+size/32;
  V = new word[n];
  while (n--) V[n] = b.V[n];
  return *this;
}

void int_set::clear()
{ register int i = 1+size/32;
  while (i--) V[i]=0;
 }
  

int_set& int_set::join(const int_set& b) 
{ word* stop = V+size/32 +1;
  word* p;
  word* q;
  for(p = V, q = b.V; p<stop; p++, q++) *p |= *q;
  return *this;
 }

int_set& int_set::intersect(const int_set& b) 
{ word* stop = V+size/32 +1;
  word* p;
  word* q;
  for(p = V, q = b.V; p<stop; p++, q++) *p &= *q;
  return *this;
 }

int_set& int_set::complement() 
{ word* stop = V+size/32 +1;
  for(word* p = V; p<stop; p++) *p = ~(*p);
  return *this;
 }

int_set  int_set::operator|(const int_set& b) 
{ int_set res(*this); 
  return res.join(b); 
 }

int_set  int_set::operator&(const int_set& b) 
{ int_set res(*this); 
  return res.intersect(b); 
 }

int_set  int_set::operator~()   
{ int_set res(*this); 
  return res.complement(); 
 }

