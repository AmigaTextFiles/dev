/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  queue.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_QUEUE_H
#define LEDA_QUEUE_H

//------------------------------------------------------------------------------
// queue                                                                
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
#include <LEDA/impl/slist.h>



template<class type>

class _CLASSTYPE queue : private SLIST
{
  void copy_el(GenPtr& x)  const { x=Copy(ACCESS(type,x)); }
  void clear_el(GenPtr& x) const { Clear(ACCESS(type,x)); }

public:

  queue() {}
  queue(const queue<type>& Q) : SLIST(Q) {}
 ~queue() { clear(); }

  void append(type x) { SLIST::append(Copy(x)); }
  type top()   const  { return ACCESS(type,SLIST::head()); }
  type pop()          { type x=top(); SLIST::pop(); return x; }
  int  size()  const  { return SLIST::length(); }
  int  empty() const  { return SLIST::empty(); }
  void clear()        { SLIST::clear(); }

  queue<type>& operator=(const queue<type>& Q) 
                      { return (queue<type>&)SLIST::operator=(Q); }
};

#endif
