/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  list.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_LIST_H
#define LEDA_LIST_H

#include <LEDA/impl/dlist.h>


template<class type> 

class _CLASSTYPE list : public dlist 
{

type X;

int  cmp(GenPtr x, GenPtr y) const
                            { return compare(ACCESS(type,x),ACCESS(type,y));}
void print_el(GenPtr& x,ostream& out) const { Print(ACCESS(type,x),out);  }
void read_el(GenPtr& x,istream& in)   { Read(X,in); x = Copy(X); }
void clear_el(GenPtr& x)              const { Clear(ACCESS(type,x)); }
void copy_el(GenPtr& x)               const { x = Copy(ACCESS(type,x)); }

int  int_type() const { return INT_TYPE(type); }

public:

list_item push(type a)   { return dlist::push(Copy(a));}
list_item append(type a) { return dlist::append(Copy(a));}
list_item insert(type a, list_item l, int dir=0)
                         { return dlist::insert(Copy(a),l,dir); }

type  contents(list_item l) const { return ACCESS(type,dlist::contents(l)); }
type  inf(list_item l)      const { return contents(l); }

GenPtr forall_loop_test(GenPtr it, type& x) const
{ if (it) x = contents(list_item(it));
  return it;
 }

type  head()                const { return ACCESS(type,dlist::head()); }
type  tail()                const { return ACCESS(type,dlist::tail()); }


type  pop() { GenPtr x=dlist::pop(); 
              type   y=ACCESS(type,x); 
              Clear(ACCESS(type,x)); 
              return y; }

type  Pop() { GenPtr x=dlist::Pop(); 
              type   y=ACCESS(type,x); 
              Clear(ACCESS(type,x)); 
              return y; }

type  del_item(list_item a) { GenPtr x=dlist::del(a);
                              type   y=ACCESS(type,x);
                              Clear(ACCESS(type,x));
                              return y; }

type  del(list_item a)           { return del_item(a); }

void  assign(list_item p,type a) { dlist::assign(p,Copy(a));}

void  conc(list<type>& l)              { dlist::conc((dlist&)l); }
void  split(list_item p, list<type>& l1, list<type>& l2)
                                 { dlist::split(p,(dlist&)l1,(dlist&)l2);}

list_item search(type a) const   { return dlist::search(Convert(a)); }
int       rank(type a)   const   { return dlist::rank(Convert(a)); }

list_item max()                      { return dlist::max(0); }
list_item min()                      { return dlist::min(0); }
list_item max(int (*f)(const type&,const type&)) 
                                     { return dlist::max(CMP_PTR(f)); }
list_item min(int (*f)(const type&,const type&)) 
                                     { return dlist::min(CMP_PTR(f)); }

void  sort()                         { dlist::sort(0); }
void  sort(int (*f)(const type&,const type&))  { dlist::sort(CMP_PTR(f)); }

void  apply(void (*f)(type&))   { dlist::apply(APP_PTR(f)); }

void  bucket_sort(int i, int j, int (*f)(const type&))
                                     { dlist::bucket_sort(i,j,ORD_PTR(f)); }

list_item read_iterator(type& x) const 
{ GenPtr y; 
  dlink* p=dlist::read_iterator(y);
  if (p) x = ACCESS(type,y); 
  return p; }

bool current_element(type& x) const {GenPtr y; bool b=dlist::current_element(y);
                                     if (b) x = ACCESS(type,y); return b; }
bool next_element(type& x)   const  {GenPtr y; bool b = dlist::next_element(y);
                                     if (b) x = ACCESS(type,y); return b; }
bool prev_element(type& x)   const  {GenPtr y; bool b = dlist::prev_element(y);
                                     if (b) x = ACCESS(type,y); return b; }

 list() {}
 list(type a)        : dlist(Copy(a)){}

 list(const list<type>& a) : dlist(a) {}

virtual ~list() { clear(); }

list<type>& operator=(const list<type>& a) 
{ dlist::operator=(a); return *this;}

#if !defined(__sgi)
list<type>  operator+(const list<type>& a) 
{ dlist L = *(dlist*)this + *(dlist*)&a; return *(list<type>*)&L; }
#endif

list_item operator+=(type x)   { return append(x); }
list_item operator[](int i)    { return get_item(i); }

type&  operator[](list_item p) { return ACCESS(type,dlist::entry(p)); }
type   operator[](list_item p) const { return contents(p); }

}; 


//------------------------------------------------------------------------------
// Iteration Macros
//------------------------------------------------------------------------------

#define forall_list_items(a,L) for( a=(L).first(); a ; a=(L).succ(a) )
#define Forall_list_items(a,L) for( a=(L).last();  a ; a=(L).pred(a) )



#endif
