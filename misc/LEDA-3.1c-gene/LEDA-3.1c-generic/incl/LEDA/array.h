/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_ARRAY_H
#define LEDA_ARRAY_H

//------------------------------------------------------------------------------
// arrays
//------------------------------------------------------------------------------

#include <LEDA/impl/gen_array.h>

#if defined(LEDA_CHECKING_OFF)
#define ARRAY_ACCESS(type)\
type& operator[](int x)       { return ACCESS(type,v[x-Low]); }\
type  operator[](int x) const { return ACCESS(type,v[x-Low]); }
#else
#define ARRAY_ACCESS(type)\
type& operator[](int x)       { return ACCESS(type,(GenPtr&)entry(x));}\
type  operator[](int x) const { return ACCESS(type,inf(x));}
#endif



template<class type> 

class _CLASSTYPE array : public gen_array {

type X;

int cmp(GenPtr x, GenPtr y) const
                        { return compare(ACCESS(type,x),ACCESS(type,y)); }
void print_el(GenPtr& x,ostream& out) const { Print(ACCESS(type,x),out);}
void read_el(GenPtr& x,istream& in)         { Read(X,in); x = Copy(X); }
void clear_entry(GenPtr& x)  { Clear(ACCESS(type,x)); }
void copy_entry(GenPtr& x)   { x = Copy(ACCESS(type,x));  }
void init_entry(GenPtr& x)   { Init(X); x = Copy(X); }

int  int_type() const { return INT_TYPE(type); }

public:
array()  {}
array(int n)                : gen_array(n)   { init(); }
array(int a, int b)         : gen_array(a,b) { init(); }
array(const array<type>& A) : gen_array(A)   {}
~array()  { clear(); }

array<type>& operator=(const array<type>& A) 
{ return (array<type>&) gen_array::operator=(A); }

ARRAY_ACCESS(type)

void sort(int (*f)(const type&,const type&)) 
{ gen_array::sort(low(),high(),CMP_PTR(f));}

void sort(int (*f)(const type&,const type&), int l, int h)
{ gen_array::sort(l,h,CMP_PTR(f)); }

void sort()                      { gen_array::sort(low(),high(),0); }
void sort(int l, int h)          { gen_array::sort(l,h,0); }

int binary_search(int (*f)(const type&,const type&), type x)
               { return gen_array::binary_search(Convert(x),CMP_PTR(f));}
int binary_search(type x)   
{ return (int_type()) ? gen_array::int_binary_search(Convert(x))
                      : gen_array::binary_search(Convert(x));
 }

};



/*------------------------------------------------------------------------*/
/* 2 dimensional arrays                                                   */
/*------------------------------------------------------------------------*/


template<class type> 

class _CLASSTYPE array2 : public gen_array2 {

type X;

void clear_entry(GenPtr& x) { Clear(ACCESS(type,x)); }
void copy_entry(GenPtr& x)  { x = Copy(ACCESS(type,x));  }
void init_entry(GenPtr& x)  { Init(X); x = Copy(X); }

public:

type& operator()(int i, int j)       { return ACCESS(type,row(i)->entry(j)); }
/*
type  operator()(int i, int j) const { return ACCESS(type,row(i)->entry(j)); }
*/

 array2(int a,int b,int c,int d) :gen_array2(a,b,c,d){ init(a,b,c,d);}
 array2(int n,int m)             :gen_array2(n,m)    { init(0,n-1,0,m-1);}
~array2() { clear(); }
};


#endif
