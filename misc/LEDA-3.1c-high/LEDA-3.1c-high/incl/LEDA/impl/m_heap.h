/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  m_heap.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_M_HEAP_H
#define LEDA_M_HEAP_H

//------------------------------------------------------------------------------
// m_heap : monotonic heaps 
//
// a) the sequence of minimum keys (over time) is monotonic (non-decreasing)
// b) the difference of minimum and maximum key is bounded by a constant M
//
// Implementation: cyclic array of lists
//
// Stefan Naeher  (1991)
//------------------------------------------------------------------------------


#include <LEDA/basic.h>
#include <LEDA/list.h>


typedef list_item m_heap_item;

class m_heap {

    int start;
    int offset;
    int M;
    int count;
    list<GenPtr> L;

    list_item*   T;

virtual void copy_inf(GenPtr&)  const {}
virtual void clear_inf(GenPtr&) const {}
virtual void print_inf(GenPtr x) const { cout << x; }

protected:

m_heap_item item(void* p) const { return (m_heap_item)p; }

public:

m_heap_item insert(GenPtr,GenPtr);
m_heap_item find_min() const;
m_heap_item first_item() const;
m_heap_item next_item(m_heap_item) const;

GenPtr       del_min();

void change_key(m_heap_item,GenPtr);
void decrease_key(m_heap_item it,GenPtr x) { change_key(it,x); }
void change_inf(m_heap_item it, GenPtr x)  { copy_inf(x); L[it] = x; };
void del_item(m_heap_item);
void clear();

GenPtr inf(m_heap_item it) const { return L.inf(it); }

GenPtr key(m_heap_item) const
{ error_handler(1,"m_heap::key not implemented");
  return 0; 
 }

int    size()   const     { return count; }
int    empty()  const     { return count==0; }

void   print() const;

 m_heap(int M=1024);         
 m_heap(int,int) { error_handler(1,"illegal constuctor"); }

virtual ~m_heap() { delete T; }


// still to do: copy operations

 m_heap& operator=(const m_heap&) { return *this; }
 m_heap(const m_heap&) {}

};

#endif

