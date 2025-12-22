/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SET_H
#define LEDA_SET_H

//------------------------------------------------------------------------------
// set             
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
#include <LEDA/impl/rs_tree.h>


template<class type>

class _CLASSTYPE set : public rs_tree {

rs_tree_item iterator;

int  int_type()              const { return INT_TYPE(type); }
int  cmp(GenPtr x, GenPtr y) const
                           { return compare(ACCESS(type,x),ACCESS(type,y)); }
void clear_key(GenPtr& x)   const { Clear(ACCESS(type,x));   }
void copy_key(GenPtr& x)    const { x = Copy(ACCESS(type,x));}

public:
virtual void insert(type y)       { rs_tree::insert(Convert(y),0); }
virtual void del(type y)          { rs_tree::del(Convert(y)); }
virtual bool member(type y) const { return (rs_tree::lookup(Convert(y))!=nil); }
virtual type choose()       const { return ACCESS(type,rs_tree::key(rs_tree::min())); }


GenPtr first_item()  { return rs_tree::first_item(); }
void loop_to_succ(GenPtr& x) { x=rs_tree::next_item(rs_tree_item(x)); }

GenPtr forall_loop_test(GenPtr it, type& y) const
{ if (it) y = ACCESS(type,rs_tree::key(rs_tree_item(it)));
  return it;
 }

// old-style iteration

void start_iteration()  { iterator = rs_tree::first_item(); }

bool read_iterator(type& x) 
{ if (iterator)
    { x = ACCESS(type,rs_tree::key(iterator));
      return true;
     }
  else
     return false;
 }

void move_to_succ()  { iterator = rs_tree::next_item(iterator); }

set<type>& operator=(const set<type>& S) { rs_tree::operator=(S); return *this;}

 set() {}
 set(const set<type>& S) : rs_tree(S) {}

~set() { clear(); }
};

#endif

