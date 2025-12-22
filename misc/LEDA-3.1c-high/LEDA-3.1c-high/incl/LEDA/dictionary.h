/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  dictionary.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_DICTIONARY_H
#define LEDA_DICTIONARY_H

#include <LEDA/basic.h>    


#define DIC_DEF_IMPL skiplist
#include <LEDA/impl/skiplist.h> 
typedef skiplist_item dic_item;



template <class ktype, class itype> 

class _CLASSTYPE dictionary : public virtual DIC_DEF_IMPL 
{

int  int_type()              const { return INT_TYPE(ktype); }
int  cmp(GenPtr x, GenPtr y) const
                          { return compare(ACCESS(ktype,x),ACCESS(ktype,y)); }
void clear_key(GenPtr& x) const { Clear(ACCESS(ktype,x)); }
void clear_inf(GenPtr& x) const { Clear(ACCESS(itype,x)); }
void copy_key(GenPtr& x)  const { x=Copy(ACCESS(ktype,x)); }
void copy_inf(GenPtr& x)  const { x=Copy(ACCESS(itype,x)); }

public:

virtual dic_item lookup(ktype x) const
{ return DIC_DEF_IMPL::lookup(Convert(x));}

virtual int  defined(ktype x) const 
{ return (lookup(x) == nil) ? false : true; }

virtual void change_inf(dic_item it, itype i)
{ DIC_DEF_IMPL::change_inf(it,Convert(i)); }

virtual dic_item insert(ktype x,itype y)
{ return DIC_DEF_IMPL::insert(Convert(x),Convert(y)); } 

virtual void  del(ktype x)          { DIC_DEF_IMPL::del(Convert(x)); } 
virtual void  del_item(dic_item it) { DIC_DEF_IMPL::del_item(it); } 

virtual ktype key(dic_item it) const { return ACCESS(ktype,DIC_DEF_IMPL::key(it));}
virtual itype inf(dic_item it) const { return ACCESS(itype,DIC_DEF_IMPL::inf(it));}
virtual itype access(ktype k)  const { return inf(lookup(k));}

virtual int      size()  const { return DIC_DEF_IMPL::size(); }
virtual bool     empty() const { return (size()==0) ? true : false; }
virtual void     clear() { DIC_DEF_IMPL::clear(); }
virtual dic_item first_item() const { return DIC_DEF_IMPL::first_item(); }
virtual dic_item next_item(dic_item it) const { return DIC_DEF_IMPL::next_item(it);}

dictionary<ktype,itype>& operator=(const dictionary<ktype,itype>& D)
{ DIC_DEF_IMPL::operator=(D); return *this; }
         
dictionary() {}

dictionary(const dictionary<ktype,itype>& D) : DIC_DEF_IMPL(D) {}

virtual ~dictionary()   { DIC_DEF_IMPL::clear(); }
};


//------------------------------------------------------------------------------
//
// Dictionaries with implementation parameter:
//
//   _dictionary<keytype,inftype,dic_impl> 
//
//------------------------------------------------------------------------------

#define _dictionary_class(ktype,itype,impl)\
\
class _CLASSTYPE _dict_class_(ktype,itype,impl) :private virtual impl,\
                                                 public dictionary<ktype,itype>\
{\
\
int int_type() const { return INT_TYPE(ktype); }\
\
int cmp(GenPtr x, GenPtr y) const\
{ return compare(ACCESS(ktype,x),ACCESS(ktype,y)); }\
void clear_key(GenPtr& x) const { Clear(ACCESS(ktype,x)); }\
void clear_inf(GenPtr& x) const { Clear(ACCESS(itype,x)); }\
void copy_key(GenPtr& x) const { x=Copy(ACCESS(ktype,x)); }\
void copy_inf(GenPtr& x) const { x=Copy(ACCESS(itype,x)); }\
void print_key(GenPtr x) const { Print(ACCESS(ktype,x),cout); }\
void print_inf(GenPtr x) const { Print(ACCESS(itype,x),cout); }\
\
public:\
\
dic_item lookup(ktype x) const { return dic_item(impl::lookup(Convert(x))); }\
\
int defined(ktype x) const { return (lookup(x)==nil) ? false : true; }\
\
void change_inf(dic_item it, itype i)\
{ impl::change_inf(impl::item(it),Convert(i));}\
\
dic_item insert(ktype x,itype y)\
{ return dic_item(impl::insert(Convert(x),Convert(y))); }\
\
void del(ktype x) { impl::del(Convert(x)); }\
void del_item(dic_item it) { impl::del_item(impl::item(it)); }\
ktype key(dic_item it) const { return ACCESS(ktype,impl::key(impl::item(it))); }\
itype inf(dic_item it) const { return ACCESS(itype,impl::inf(impl::item(it)));}\
\
int size() const { return impl::size(); }\
bool empty() const { return (size()==0) ? true : false; }\
void clear() { impl::clear(); }\
dic_item first_item() const { return dic_item(impl::first_item()); }\
dic_item next_item(dic_item it) const { return dic_item(impl::next_item(impl::item(it))); }\
\
_dict_(ktype,itype,impl)& operator=(const _dict_(ktype,itype,impl)& D)\
{ impl::operator=(D); return *this; }\
\
_dict_class_(ktype,itype,impl)() {}\
_dict_class_(ktype,itype,impl)(const _dict_(ktype,itype,impl)& D) : impl(D)\
{}\
~_dict_class_(ktype,itype,impl)() { impl::clear(); }

#if defined(__TEMPLATE_ARGS_AS_BASE__)
#define _dict_class_(a,b,c) _dictionary
#define _dict_(a,b,c) _dictionary<a,b,c>
template <class ktype, class itype, class impl> 
_dictionary_class(ktype,itype,impl)
};
#else
#define _dictionary(a,b,c)         name4(a,b,c,_dictionary)
#define _dict_class_(a,b,c)        name4(a,b,c,_dictionary)
#define _dict_(a,b,c)              name4(a,b,c,_dictionary)
#define _dictionarydeclare3(_a,_b,_c) _dictionary_class(_a,_b,_c) };
#endif


#endif
