/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  slist.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SLIST_H
#define LEDA_SLIST_H

//------------------------------------------------------------------------------
// slist<T>  simply linked lists
//------------------------------------------------------------------------------


#include <LEDA/impl/slist.h>



template <class type>

class _CLASSTYPE slist : public SLIST {

type X;

int  cmp_el(GenPtr x, GenPtr y) const
                             { return compare(ACCESS(type,x),ACCESS(type,y));}
void print_el(GenPtr& x,ostream& out) const { Print(ACCESS(type,x),out);  }
void read_el(GenPtr& x,istream& in)         { Read(X,in); x = Copy(X); }
void clear_el(GenPtr& x)              const { Clear(ACCESS(type,x)); }
void copy_el(GenPtr& x)               const { x = Copy(ACCESS(type,x)); }

int  int_type() const { return INT_TYPE(type); }

public:

slink* push(type a)             { return SLIST::push(Copy(a)); }
slink* append(type a)           { return SLIST::append(Copy(a)); }
slink* insert(type a, slink* l) { return SLIST::insert(Copy(a),l); }

void conc(slist<type>& l)       { SLIST::conc((SLIST&)l); }

slink* read_iterator(type& x) const 
{ GenPtr y; 
  slink* p=SLIST::read_iterator(y);
  if (p) x = ACCESS(type,y); 
  return p; }

bool current_element(type& x) const {GenPtr y; bool b=SLIST::current_element(y);
                                     if (b) x = ACCESS(type,y); return b; }
bool next_element(type& x) const { GenPtr y; bool b = SLIST::next_element(y);
                                   if (b) x = ACCESS(type,y); return b; }

type head()             const { return ACCESS(type,SLIST::head() ); }
type tail()             const { return ACCESS(type,SLIST::tail() ); }

type pop()                    { GenPtr x=SLIST::pop(); 
                                type   y=ACCESS(type,x); 
                                Clear(ACCESS(type,x)); 
                                return y; }

type contents(slink* l) const { return ACCESS(type,SLIST::contents(l)); }
type inf(slink* l)      const { return ACCESS(type,SLIST::contents(l)); }

GenPtr forall_loop_test(GenPtr it, type& x) const
{ if (it) x = contents(slist_item(it));
  return it;
 }

   slist() { }
   slist(const slist<type>& a) : SLIST((SLIST&)a) { }
   slist(type a) : SLIST(Convert(a)) { }
   ~slist() {}

   slist<type>& operator=(const slist<type>& a)
           { SLIST::operator=(a);  return *this; }

   slink* operator+=(type x)  { return append(x); }
   slink* operator&=(type x)  { return push(x); }
   type& operator[](slink* l) { return ACCESS(type,SLIST::entry(l)); }
};


#endif
