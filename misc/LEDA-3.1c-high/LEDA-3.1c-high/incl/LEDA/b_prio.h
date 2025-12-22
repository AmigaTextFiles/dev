/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  b_prio.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BPRIO_H
#define LEDA_BPRIO_H

//------------------------------------------------------------------------------
// b_priority_queues: bounded priority queues implemented by b_heaps 
//------------------------------------------------------------------------------

#include <LEDA/impl/b_heap.h>

typedef b_heap_item b_pq_item;


template<class keytype> 

class _CLASSTYPE b_priority_queue : public b_heap 
{
public:

         b_priority_queue(int a, int b): (a,b)  {}
virtual ~b_priority_queue()  { }

  b_pq_item insert(keytype k,int info)
                             { return b_heap::insert(info,Convert(k)); }
  void decrease_inf(b_pq_item it,int newinf)
                             { b_heap::decrease_key(it,newinf); }
  void del_item(b_pq_item x) { b_heap::delete_item(x); }
  int      inf(b_pq_item x)  { return b_heap::key(x); }
  keytype  key(b_pq_item x)  { return ACCESS(keytype,b_heap::info(x)); }
  keytype  del_min()         { return ACCESS(keytype,b_heap::del_min()); }
  b_pq_item find_min()       { return b_heap::find_min(); }
  void clear()               { b_heap::clear(); }
  int empty()                { return (find_min()==0) ? true : false; }
 };

 
#endif

