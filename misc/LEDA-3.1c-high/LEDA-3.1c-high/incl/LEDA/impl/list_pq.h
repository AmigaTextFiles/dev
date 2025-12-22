/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  list_pq.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/basic.h>


class list_pq_elem
{
  friend class list_pq;

  GenPtr key;
  GenPtr inf;

  list_pq_elem* succ;
  list_pq_elem* pred;

  list_pq_elem(GenPtr k, GenPtr i, list_pq_elem* p, list_pq_elem* s) 
  { key = k; 
    inf = i; 
    pred = p;
    succ = s;
   }

  LEDA_MEMORY(list_pq_elem)

};


#define PRIO_IMPL      list_pq
#define PRIO_IMPL_ITEM list_pq_item

typedef list_pq_elem* list_pq_item;


#define PRIO_IMPL_DATA list_pq_item head;\
                       int          count;


#include <LEDA/impl/prio_impl.h>



inline list_pq::list_pq()    { head = nil; count = 0; }
inline list_pq::list_pq(int) { error_handler(1,"no list_pq(int) constructor");}
inline list_pq::list_pq(int,int) { error_handler(1,"no list_pq(int,int) constructor");}
inline list_pq::~list_pq() { clear(); }

inline list_pq_item list_pq::first_item()              const { return head;   }
inline list_pq_item list_pq::next_item(list_pq_item x) const { return x->succ;}

inline GenPtr list_pq::key(list_pq_item it) const { return it->key; }
inline GenPtr list_pq::inf(list_pq_item it) const { return it->inf; }

inline void list_pq::del_min()  { del_item(find_min());   }

inline void list_pq::decrease_key(list_pq_item it, GenPtr x)  
{ copy_key(x);
  clear_key(it->key);
  it->key = x; 
 }

inline void list_pq::change_inf(list_pq_item it, GenPtr y)
{ copy_inf(y);
  clear_inf(it->inf);
  it->inf = y; 
 }

inline int  list_pq::size()  const  { return count; }

