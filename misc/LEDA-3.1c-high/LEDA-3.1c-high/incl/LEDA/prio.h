/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  prio.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_PRIORITY_QUEUE_H
#define LEDA_PRIORITY_QUEUE_H

#include <LEDA/impl/f_heap.h>

typedef f_heap_item pq_item;


template<class ktype, class itype> 

class _CLASSTYPE priority_queue: public f_heap
{

int  int_type()              const { return INT_TYPE(itype); }
int  cmp(GenPtr x, GenPtr y) const
                     { return compare(ACCESS(itype,x),ACCESS(itype,y)); }
void clear_key(GenPtr& x)   const { Clear(ACCESS(itype,x)); }
void clear_inf(GenPtr& x)   const { Clear(ACCESS(ktype,x)); }
void copy_key(GenPtr& x)    const { x=Copy(ACCESS(itype,x)); }
void copy_inf(GenPtr& x)    const { x=Copy(ACCESS(ktype,x)); }
void print_key(GenPtr x)    const { Print(ACCESS(itype,x),cout); }
void print_inf(GenPtr x)    const { Print(ACCESS(ktype,x),cout); }

public:

virtual pq_item insert(ktype k,itype i) 
                              { return f_heap::insert(Convert(i),Convert(k)); }

virtual pq_item find_min()       const { return f_heap::find_min();}

virtual ktype   del_min()              { ktype x = key(find_min()); 
                                         f_heap::del_min(); 
                                         return x; }

virtual ktype key(pq_item x)     const { return ACCESS(ktype,f_heap::inf(x)); }
virtual itype inf(pq_item x)     const { return ACCESS(itype,f_heap::key(x)); }

virtual void change_key(pq_item x,ktype k) 
                                       { f_heap::change_inf(x,Convert(k)); }
virtual void decrease_inf(pq_item x,itype i)
                                       { f_heap::decrease_key(x,Convert(i)); }

virtual void del_item(pq_item x)       { f_heap::del_item(x); }

virtual int  size()    const { return f_heap::size(); }
virtual bool empty()   const { return (size()==0) ? true : false; }

virtual pq_item first_item()          const { return f_heap::first_item(); }
virtual pq_item next_item(pq_item it) const { return f_heap::next_item(it); }

priority_queue<ktype,itype>& operator=(const priority_queue<ktype,itype>& Q) 
{ return (priority_queue<ktype,itype>&)f_heap::operator=(Q); }

 priority_queue()  {}
 priority_queue(const priority_queue<ktype,itype>& Q):f_heap(Q) {}
~priority_queue()  { f_heap::clear(); }
};


//------------------------------------------------------------------------------
//
// Priority queues with implementation parameter:
//
//   _priority_queue<keytype,inftype,prio_impl> 
//
//------------------------------------------------------------------------------

#define _priority_queue_class(ktype,itype,impl)\
\
class _CLASSTYPE _prio_class_(ktype,itype,impl) : private impl, public priority_queue<ktype,itype>\
{\
int int_type() const { return INT_TYPE(itype); }\
\
int cmp(GenPtr x, GenPtr y) const\
                         { return compare(ACCESS(itype,x),ACCESS(itype,y)); }\
void clear_key(GenPtr& x) const { Clear(ACCESS(itype,x)); }\
void clear_inf(GenPtr& x) const { Clear(ACCESS(ktype,x)); }\
void copy_key(GenPtr& x) const { x=Copy(ACCESS(itype,x)); }\
void copy_inf(GenPtr& x) const { x=Copy(ACCESS(ktype,x)); }\
void print_key(GenPtr x) const { Print(ACCESS(itype,x),cout); }\
void print_inf(GenPtr x) const { Print(ACCESS(ktype,x),cout); }\
\
public:\
\
pq_item insert(ktype k,itype i) { return pq_item(impl::insert(Convert(i),Convert(k)));}\
\
pq_item find_min() const { return pq_item(impl::find_min());}\
\
ktype del_min() { pq_item it = find_min();\
                  ktype    x = key(it);\
                  del_item(it);\
                  return x; }\
\
ktype key(pq_item x) const { return ACCESS(ktype,impl::inf(impl::item(x)));}\
itype inf(pq_item x) const { return ACCESS(itype,impl::key(impl::item(x)));}\
\
void change_key(pq_item x, ktype k)\
{ impl::change_inf(impl::item(x),Convert(k)); }\
\
void decrease_inf(pq_item x,itype i)\
{ impl::decrease_key(impl::item(x),Convert(i));}\
\
void del_item(pq_item x) { impl::del_item(impl::item(x)); }\
\
int size() const { return impl::size(); }\
bool empty() const { return (size()==0) ? true : false; }\
\
pq_item first_item() const { return pq_item(impl::first_item()); }\
pq_item next_item(pq_item it) const { return pq_item(impl::next_item(impl::item(it))); }\
\
_prio_(ktype,itype,impl)& operator=(const _prio_(ktype,itype,impl)& Q) { return (_prio_(ktype,itype,impl)&)impl::operator=(Q); }\
\
_prio_class_(ktype,itype,impl)() {}\
_prio_class_(ktype,itype,impl)(int n) : impl(n) {}\
_prio_class_(ktype,itype,impl)(const _prio_(ktype,itype,impl)& Q)\
: impl(Q) {}\
\
~_prio_class_(ktype,itype,impl)() { impl::clear(); }


#if defined(__TEMPLATE_ARGS_AS_BASE__)
#define _prio_class_(a,b,c) _priority_queue
#define _prio_(a,b,c) _priority_queue<a,b,c>
template <class ktype, class itype, class impl> 
_priority_queue_class(ktype,itype,impl)
};
#else
#define _priority_queue(a,b,c)         name4(a,b,c,_priority_queue)
#define _prio_class_(a,b,c)            name4(a,b,c,_priority_queue)
#define _prio_(a,b,c)                  name4(a,b,c,_priority_queue)
#define _priority_queuedeclare3(_a,_b,_c) _priority_queue_class(_a,_b,_c) };
#endif

#endif
