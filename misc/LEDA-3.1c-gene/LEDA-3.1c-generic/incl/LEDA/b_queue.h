/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  b_queue.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BQUEUE_H
#define LEDA_BQUEUE_H

//------------------------------------------------------------------------------
// bounded queues
//------------------------------------------------------------------------------

#include <LEDA/basic.h>


template<class type> 

class _CLASSTYPE b_queue  
{
        type* first;     // first element of array
        type* stop;      // one position behind last element of array
        type* start;     // current start of queue (wraps around)
        type* end;       // one position behind end of queue (wraps around)

public:										

b_queue(int s) 
{
#if !defined(LEDA_CHECKING_OFF)
  if (s<1) error_handler(88,"_b_queue: bad size");
#endif
  first = new type[s];
  if (first==0) error_handler(88,"_b_queue: out of memory");
  stop  = first+s;
  start = end = first; 
}

virtual ~b_queue() { delete [] first; }

int empty() const { return (size()==0) ? true : false; }

int size() const 
{ int s = end-start;
  return (s<0) ?  (stop-first+s) : s;
}

void append(type& a)
{ *end++ = a;
  if (end == stop) end = first;
#if !defined(LEDA_CHECKING_OFF)
  if (start==end) error_handler(88, "_b_queue overflow");
#endif
}

type pop()
{
#if !defined(LEDA_CHECKING_OFF)
 if (start==end) error_handler(88, "_b_queue underflow");
#endif
  type x = *start++;
  if (start == stop) start = first;
  return x;
}

type top() const
{
#if !defined(LEDA_CHECKING_OFF)
  if (start==end) error_handler(88, "_b_queue empty");
#endif
  return *start;
}

void clear() { start = end = first; }

};

#endif
