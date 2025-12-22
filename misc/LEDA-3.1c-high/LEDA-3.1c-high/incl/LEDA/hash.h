/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  hash.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_HASH_H
#define LEDA_HASH_H

//------------------------------------------------------------------------------
// hash dictionary (based on hashing with chaining)
//------------------------------------------------------------------------------

#include <LEDA/impl/ch_hash.h>

typedef ch_hash_item hash_item;


template<class keytype, class inftype> 

class _CLASSTYPE hash : public ch_hash {

int (*hash_ptr)(const keytype&);

int  int_type() const { return INT_TYPE(keytype); }

int  hash_fct(GenPtr x) const
{ return (hash_ptr) ? (*hash_ptr)(ACCESS(keytype,x)) : int(x); }

int  cmp(GenPtr x, GenPtr y) const
                    { return compare(ACCESS(keytype,x),ACCESS(keytype,y)); }
void clear_key(GenPtr& x)   const { Clear(ACCESS(keytype,x)); }
void clear_inf(GenPtr& x)   const { Clear(ACCESS(inftype,x)); }
void copy_key(GenPtr& x)    const { x=Copy(ACCESS(keytype,x)); }
void copy_inf(GenPtr& x)    const { x=Copy(ACCESS(inftype,x)); }
void print_key(GenPtr x)    const { Print(ACCESS(keytype,x),cout); }

public:

hash_item lookup(keytype y)  const { return ch_hash::lookup(Convert(y)); }
int       defined(keytype x) const { return (lookup(x)) ? false : true; }
void      change_inf(hash_item it, inftype i)
                                    { ch_hash::change_inf(it,Convert(i)); }
hash_item insert(keytype y,inftype x)
                                    { return ch_hash::insert(Convert(y),Convert(x));}
void     del(keytype y)            { ch_hash::del(Convert(y)); } 
void     del_item(hash_item it)    { del(key(it)); } 
keytype  key(hash_item it)   const { return ACCESS(keytype,ch_hash::key(it)); }
inftype  inf(hash_item it)   const { return ACCESS(inftype,ch_hash::inf(it)); }

hash()                         { hash_ptr=0;}
hash(int (*f)(const keytype&)) { hash_ptr=f;}

hash(int s)  : ch_hash(s) { hash_ptr=0;}
hash(int s, int (*f)(const keytype&)) : ch_hash(s) { hash_ptr=f;}

~hash() { clear(); }

} ;


#endif
