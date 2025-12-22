/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  b_stack.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BSTACK_H
#define LEDA_BSTACK_H

//------------------------------------------------------------------------------
// bounded stacks 
//------------------------------------------------------------------------------

#include <LEDA/basic.h>



template<class type> 

class _CLASSTYPE b_stack
{
	type* first;  // start of array
	type* stop;   // one position behind last element
        type* free;   // pointer to first free element

public:

b_stack(int n)
{
#if !defined(LEDA_CHECKING_OFF)
  if (n<1) error_handler(99,"b_stack: bad size");
#endif
  free = first = new type[n];
  stop = first + n;
  if (first==0) error_handler(99,"b_stack: out of memory");
 }

virtual ~b_stack() { delete [] first; }

int   size()  const { return free - first; }

int   empty() const { return (free==first) ? true : false; }

void push(const type& a)
{
#if !defined(LEDA_CHECKING_OFF)
  if (free==stop) error_handler(99,"b_stack overflow");
#endif
  *free++ = a;
}

type pop()
{
#if !defined(LEDA_CHECKING_OFF)
  if (free==first) error_handler(99,"b_stack underflow");
#endif
  return *--free;
}

type top() const 
{
#if !defined(LEDA_CHECKING_OFF)
  if (free==first) error_handler(99,"b_stack empty");
#endif
  return *(free-1);
}

void clear() { free = first; }

};

#endif
