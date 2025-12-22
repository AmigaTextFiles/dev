/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  int_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_INTSET_H
#define LEDA_INTSET_H

//------------------------------------------------------------------------------
/* int_set: integer sets implemented by bit vectors                           */
//------------------------------------------------------------------------------

#include <LEDA/basic.h>

class int_set {

unsigned long*  V;
int size;
int low;

public:

 int_set(int n); 
 int_set(int,int); 
 int_set(const int_set&);
~int_set() { delete V; } 


void clear();
void insert(int);
void del(int);

int  member(int) const;

int_set& join(const int_set&);
int_set& intersect(const int_set&);
int_set& complement();

int_set& operator=(const int_set&);

int_set& operator|=(const int_set&);
int_set& operator&=(const int_set&);

int_set  operator|(const int_set&);
int_set  operator&(const int_set&);
int_set  operator~();

};

inline int  int_set::member(int x)  const
{ int i = x-low; 
  return V[i/32] & (1 << (i%32)); 
 }

inline void int_set::insert(int x) 
{ int i  =  x-low; 
  V[i/32] |= (1 << (i%32)); 
 }

inline void int_set::del(int x)    
{ int i   = x-low; 
  V[i/32] &= ~(1 << (i%32)); 
 }

inline int_set& int_set::operator|=(const int_set& s) { return join(s); }

inline int_set& int_set::operator&=(const int_set& s) { return intersect(s); }


#endif
