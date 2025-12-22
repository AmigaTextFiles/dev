/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  stack.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_STACK_H
#define LEDA_STACK_H

#include <LEDA/basic.h>
#include <LEDA/impl/slist.h>

//------------------------------------------------------------------------------
// stacks                                                                
//------------------------------------------------------------------------------


template<class type>

class _CLASSTYPE stack : private SLIST
{
  void copy_el(GenPtr& x)  const { x=Copy(ACCESS(type,x)); }
  void clear_el(GenPtr& x) const { Clear(ACCESS(type,x)); }

public:

  stack() {}
  stack(const stack<type>& S) : SLIST(S) {}
 ~stack() { clear(); }

  void push(type x)  { SLIST::push(Copy(x)); }
  type top()   const { return ACCESS(type,SLIST::head());}
  type pop()         { type x=top(); SLIST::pop(); return x; }
  int  size()  const { return SLIST::length(); }
  int  empty() const { return SLIST::empty(); }
  void clear()       { SLIST::clear(); }

  stack<type>& operator=(const stack<type>& S) 
                     { return (stack<type>&)SLIST::operator=(S); }
};

#endif
