/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  sortseq.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SORTSEQ_H
#define LEDA_SORTSEQ_H

/*
#include <LEDA/impl/rs_tree.h>
#define SEQ_DEF_IMPL rs_tree
#define SEQ_BASE_IMPL bin_tree
typedef rs_tree_item seq_item;
*/

#include <LEDA/impl/skiplist.h>
#define SEQ_DEF_IMPL skiplist
#define SEQ_BASE_IMPL skiplist
typedef skiplist_item seq_item;


template<class ktype, class itype>

class _CLASSTYPE sortseq : public virtual SEQ_DEF_IMPL {

int  int_type()              const { return INT_TYPE(ktype); }
int  cmp(GenPtr x, GenPtr y) const
                     { return compare(ACCESS(ktype,x),ACCESS(ktype,y)); }
void clear_key(GenPtr& x)   const { Clear(ACCESS(ktype,x)); }
void clear_inf(GenPtr& x)   const { Clear(ACCESS(itype,x)); }
void copy_key(GenPtr& x)    const { x = Copy(ACCESS(ktype,x)); }
void copy_inf(GenPtr& x)    const { x = Copy(ACCESS(itype,x)); }
void print_key(GenPtr x)    const { Print(ACCESS(ktype,x),cout); }
void print_inf(GenPtr x)    const { Print(ACCESS(itype,x),cout); }

public:

virtual ktype  key(seq_item it) const { return ACCESS(ktype,SEQ_DEF_IMPL::key(it)); }
virtual itype  inf(seq_item it) const { return ACCESS(itype,SEQ_DEF_IMPL::inf(it)); } 

virtual seq_item lookup(ktype y) const { return SEQ_DEF_IMPL::lookup(Convert(y)); }
virtual seq_item locate(ktype y) const { return SEQ_DEF_IMPL::locate(Convert(y)); }
virtual seq_item locate_succ(ktype y) const { return SEQ_DEF_IMPL::locate_succ(Convert(y)); }
virtual seq_item locate_pred(ktype y) const { return SEQ_DEF_IMPL::locate_pred(Convert(y)); }

virtual seq_item min() const { return SEQ_DEF_IMPL::min(); }
virtual seq_item max() const { return SEQ_DEF_IMPL::max(); }

virtual seq_item succ(seq_item x) const { return SEQ_DEF_IMPL::succ(x); }
virtual seq_item succ(ktype y) const { return locate_succ(y); }

virtual seq_item pred(seq_item x) const { return SEQ_DEF_IMPL::pred(x); }
virtual seq_item pred(ktype y) const { return locate_pred(y); }

virtual seq_item insert(ktype y,itype x)
                         { return SEQ_DEF_IMPL::insert(Convert(y),Convert(x)); } 

virtual seq_item insert_at(seq_item it,ktype y,itype x)
{ return SEQ_DEF_IMPL::insert_at_item(it,Convert(y),Convert(x)); } 

virtual int      size()  const { return SEQ_DEF_IMPL::size(); }

virtual bool     empty() const { return (size()==0) ? true : false; }

virtual void     clear() { SEQ_DEF_IMPL::clear(); }

virtual void reverse_items(seq_item a, seq_item b) { SEQ_DEF_IMPL::reverse_items(a,b); }
virtual void flip_items(seq_item a, seq_item b)    { reverse_items(a,b); }

virtual void del(ktype y)         { SEQ_DEF_IMPL::del(Convert(y)); } 
virtual void del_item(seq_item it)  { SEQ_DEF_IMPL::del_item(it); } 
virtual void change_inf(seq_item it, itype i) { SEQ_DEF_IMPL::change_inf(it,Convert(i));}
virtual void split(seq_item x,sortseq<ktype,itype>& S1,sortseq<ktype,itype>& S2)
                      { SEQ_DEF_IMPL::split_at_item(x,(SEQ_DEF_IMPL&)S1,(SEQ_DEF_IMPL&)S2); }

virtual sortseq<ktype,itype>& conc(sortseq<ktype,itype>& S) { SEQ_DEF_IMPL::conc((SEQ_DEF_IMPL&)S); return *this; }

sortseq()    {}
sortseq(const sortseq<ktype,itype>& w) : SEQ_BASE_IMPL(w) {}

sortseq<ktype,itype>& operator=(const sortseq<ktype,itype>& w)
{ SEQ_DEF_IMPL::operator=(w); return *this; }

virtual ~sortseq()   { clear(); }
};



//------------------------------------------------------------------------------
//
// Sorted sequences with implementation parameter:
//
//   _sortseq<ktype,itype,seq_impl> 
//
//------------------------------------------------------------------------------

#define _sortseq_class(ktype,itype,impl)\
\
class _CLASSTYPE _sortseq_class_(ktype,itype,impl) : private virtual impl, public sortseq<ktype,itype>\
{\
int int_type() const { return INT_TYPE(ktype); }\
\
int cmp(GenPtr x, GenPtr y) const\
{ return compare(ACCESS(ktype,x),ACCESS(ktype,y)); }\
void clear_key(GenPtr& x) const { Clear(ACCESS(ktype,x)); }\
void clear_inf(GenPtr& x) const { Clear(ACCESS(itype,x)); }\
void copy_key(GenPtr& x) const { x = Copy(ACCESS(ktype,x)); }\
void copy_inf(GenPtr& x) const { x = Copy(ACCESS(itype,x)); }\
void print_key(GenPtr x) const { Print(ACCESS(ktype,x),cout); }\
void print_inf(GenPtr x) const { Print(ACCESS(itype,x),cout); }\
\
public:\
\
ktype key(seq_item it) const { return ACCESS(ktype,impl::key(impl::item(it))); }\
itype inf(seq_item it) const { return ACCESS(itype,impl::inf(impl::item(it))); }\
\
seq_item lookup(ktype y) const { return (seq_item)impl::lookup(Convert(y)); }\
seq_item locate(ktype y) const { return (seq_item)impl::locate(Convert(y)); }\
seq_item locate_succ(ktype y) const { return (seq_item)impl::locate_succ(Convert(y)); }\
seq_item locate_pred(ktype y) const { return (seq_item)impl::locate_pred(Convert(y)); }\
\
seq_item min() const { return (seq_item)impl::min(); }\
seq_item max() const { return (seq_item)impl::max(); }\
\
seq_item succ(seq_item x) const { return (seq_item)impl::succ(impl::item(x)); }\
seq_item succ(ktype y) const { return locate_succ(y); }\
\
seq_item pred(seq_item x) const { return (seq_item)impl::pred(impl::item(x)); }\
seq_item pred(ktype y) const { return locate_pred(y); }\
\
seq_item insert(ktype y,itype x)\
{ return (seq_item)impl::insert(Convert(y),Convert(x));}\
\
seq_item insert_at(seq_item it,ktype y,itype x)\
{ return (seq_item)impl::insert_at_item(impl::item(it),Convert(y),Convert(x));}\
void reverse_items(seq_item a, seq_item b) { impl::reverse_items(impl::item(a),impl::item(b)); }\
void flip_items(seq_item a, seq_item b) { reverse_items(a,b); }\
\
void del(ktype y) { impl::del(Convert(y)); }\
void del_item(seq_item it) { impl::del_item(impl::item(it)); }\
void change_inf(seq_item it, itype i) { impl::change_inf(impl::item(it),Convert(i));}\
\
int      size()  const { return impl::size(); }\
bool     empty() const { return (size()==0) ? true : false; }\
void     clear() { impl::clear(); }\
\
void split(seq_item it,sortseq<ktype,itype>& S1,sortseq<ktype,itype>& S2)\
{ impl::split_at_item(impl::item(it),*(impl*)&S1,*(impl*)&S2); }\
\
sortseq<ktype,itype>& conc(sortseq<ktype,itype>& S)\
{ impl::conc(*(impl*)&S); return *this; }\
\
_sortseq_class_(ktype,itype,impl)() {}\
_sortseq_class_(ktype,itype,impl)(const _sortseq_(ktype,itype,impl)& S) : impl(S) {}\
\
_sortseq_(ktype,itype,impl)& operator=(const _sortseq_(ktype,itype,impl)& S)\
{ impl::operator=(S); return *this; }\
\
~_sortseq_class_(ktype,itype,impl)() { impl::clear(); }

#if defined(__TEMPLATE_ARGS_AS_BASE__)
#define _sortseq_class_(a,b,c) _sortseq
#define _sortseq_(a,b,c) _sortseq<a,b,c>
template <class ktype, class itype, class impl> 
_sortseq_class(ktype,itype,impl)
};
#else
#define _sortseq(a,b,c)         name4(a,b,c,_sortseq)
#define _sortseq_class_(a,b,c)  name4(a,b,c,_sortseq)
#define _sortseq_(a,b,c)        name4(a,b,c,_sortseq)
#define _sortseqdeclare3(_a,_b,_c) _sortseq_class(_a,_b,_c) };
#endif

#endif
