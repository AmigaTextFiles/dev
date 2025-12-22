/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  d_array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_D_ARRAY_H
#define LEDA_D_ARRAY_H

//------------------------------------------------------------------------------
// d_array 
//------------------------------------------------------------------------------ 
#include <LEDA/impl/skiplist.h> 
#define DA_DEF_IMPL skiplist
typedef skiplist_item d_array_item;


template<class itype, class etype> 

class _CLASSTYPE d_array : public virtual DA_DEF_IMPL 
{

etype init;
d_array_item iterator;

int  cmp(GenPtr x, GenPtr y) const
                          { return compare(ACCESS(itype,x),ACCESS(itype,y)); }
void clear_key(GenPtr& x)   const { Clear(ACCESS(itype,x)); }
void clear_inf(GenPtr& x)   const { Clear(ACCESS(etype,x)); }
void copy_key(GenPtr& x)    const { x=Copy(ACCESS(itype,x));  }
void copy_inf(GenPtr& x)    const { x=Copy(ACCESS(etype,x));  }
int  int_type()             const { return INT_TYPE(itype); }

public:

virtual etype&  operator[](itype y) 
{ d_array_item i=DA_DEF_IMPL::lookup(Convert(y));
  if (i==nil) i=DA_DEF_IMPL::insert(Convert(y),Convert(init));
  return ACCESS(etype,info(i)); 
}

virtual bool defined(itype y)  const 
{ return (DA_DEF_IMPL::lookup(Convert(y))!=nil); }

virtual void start_iteration() const 
{ (d_array_item&)iterator = DA_DEF_IMPL::first_item(); }

virtual bool next_index(itype& y) const    
{ if (iterator==0) return false;
  else { y = ACCESS(itype,key(iterator));
         (d_array_item&)iterator = DA_DEF_IMPL::next_item(iterator);
         return true; 
        } 
}

d_array<itype,etype>& operator=(const d_array<itype,etype>& A)
{ DA_DEF_IMPL::operator=(A); init=A.init; return *this; }


d_array()        { Init(init); }
d_array(etype i) { init=i; }

d_array(const d_array<itype,etype>& A) : DA_DEF_IMPL(A) {init=A.init;}

virtual ~d_array() { clear(); }

};

#define forall_defined(i,A)  for ((A).start_iteration(); (A).next_index(i); )



//------------------------------------------------------------------------------
//
// Dictionary arrays with implementation parameter:
//
//   _d_array<itype,etype,impl> 
//
//------------------------------------------------------------------------------


#define _d_array_class(itype,etype,impl)\
\
class _CLASSTYPE _d_array_class_(itype,etype,impl):private virtual impl,\
                                                   public d_array<itype,etype>\
{\
\
etype init; /* because of a bug in g++ I use "this->init" for accessing it*/\
d_array_item iterator;\
\
int cmp(GenPtr x, GenPtr y) const\
{ return compare(ACCESS(itype,x),ACCESS(itype,y)); }\
void clear_key(GenPtr& x) const { Clear(ACCESS(itype,x)); }\
void clear_inf(GenPtr& x) const { Clear(ACCESS(etype,x)); }\
void copy_key(GenPtr& x) const { x=Copy(ACCESS(itype,x)); }\
void copy_inf(GenPtr& x) const { x=Copy(ACCESS(etype,x)); }\
void print_key(GenPtr x) const { Print(ACCESS(itype,x),cout); }\
void print_inf(GenPtr x) const { Print(ACCESS(etype,x),cout); }\
\
int int_type() const { return INT_TYPE(itype); }\
\
public:\
\
virtual etype& operator[](itype y)\
{ d_array_item i=(d_array_item)impl::lookup(Convert(y));\
  if (i==nil) i=(d_array_item)impl::insert(Convert(y),Convert(this->init));\
  return ACCESS(etype,impl::info(impl::item(i)));\
}\
\
virtual bool defined(itype y) const\
{ return (impl::lookup(Convert(y))!=nil); }\
\
virtual void start_iteration() const\
{ (d_array_item&)iterator = (d_array_item)impl::first_item(); }\
\
virtual bool next_index(itype& y) const    \
{ if (iterator==0) return false;\
  else\
  {y = ACCESS(itype,impl::key(impl::item(iterator)));\
   (d_array_item&)iterator=(d_array_item)impl::next_item(impl::item(iterator));\
   return true;\
  }\
}\
\
_d_array_(itype,etype,impl)& operator=(const _d_array_(itype,etype,impl)& A)\
{ impl::operator=(A); this->init=A.init; return *this; }\
\
_d_array_class_(itype,etype,impl)()        { Init(this->init); }\
_d_array_class_(itype,etype,impl)(etype i) { this->init=i; }\
\
_d_array_class_(itype,etype,impl)(const _d_array_(itype,etype,impl)& A) : impl(A)\
{ this->init=A.init; }\
\
virtual ~_d_array_class_(itype,etype,impl)() { impl::clear(); }

#if defined(__TEMPLATE_ARGS_AS_BASE__)
#define _d_array_class_(a,b,c) _d_array
#define _d_array_(a,b,c) _d_array<a,b,c>
template <class itype, class etype, class impl> 
_d_array_class(itype,etype,impl)
};
#else
#define _d_array(a,b,c)         name4(a,b,c,_d_array)
#define _d_array_class_(a,b,c)  name4(a,b,c,_d_array)
#define _d_array_(a,b,c)        name4(a,b,c,_d_array)
#define _d_arraydeclare3(_a,_b,_c) _d_array_class(_a,_b,_c) };
#endif

#endif
