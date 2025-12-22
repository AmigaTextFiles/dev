/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  node_pq.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_NODE_PQ_H
#define LEDA_NODE_PQ_H

//------------------------------------------------------------------------------
// node priority queues
//------------------------------------------------------------------------------

#include <LEDA/graph.h>
#include <LEDA/impl/bin_heap.h>


#define PRIO_IMPL bin_heap
#define PRIO_ITEM bin_heap_item

template <class itype>

class _CLASSTYPE node_pq : private PRIO_IMPL
{

int cmp(GenPtr x, GenPtr y)  const
                         { return compare(ACCESS(itype,x),ACCESS(itype,y)); }
void print_key(GenPtr x)    const { Print(ACCESS(itype,x)); }
void print_inf(GenPtr x)    const { Print(GenPtr(x));  }
void clear_key(GenPtr& x)   const { Clear(ACCESS(itype,x)); }
void copy_key(GenPtr& x)    const { x=Copy(ACCESS(itype,x));  }

int  int_type()             const { return INT_TYPE(itype); }

public:
 node_pq(const graph&) { }
~node_pq()             { clear(); }

void decrease_inf(node v, itype i)
{ PRIO_IMPL::decrease_key(PRIO_ITEM(v->data[1]),Convert(i)); }

void insert(node v,itype i)
{ v->data[1] = PRIO_IMPL::insert(Convert(i),v);}

itype inf(node v) const
{ return ACCESS(itype,PRIO_IMPL::key((PRIO_ITEM)v->data[1])); }

void del(node v) 
{ PRIO_IMPL::del_item(PRIO_ITEM(v->data[1])); }

node find_min() const  
{ return (node)PRIO_IMPL::inf(PRIO_IMPL::find_min());   }

node del_min()   
{ node v = find_min(); PRIO_IMPL::del_min(); return v; }

void clear()     { PRIO_IMPL::clear(); }

int size()   const { return PRIO_IMPL::size(); }
int empty()  const { return PRIO_IMPL::empty(); }

};


#endif
