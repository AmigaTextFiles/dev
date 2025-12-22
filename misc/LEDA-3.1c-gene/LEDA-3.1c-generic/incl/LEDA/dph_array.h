/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  dph_array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_DPHARRAY_H
#define LEDA_DPHARRAY_H

//------------------------------------------------------------------------------
// dph_array  
//------------------------------------------------------------------------------ 
#include <LEDA/basic.h> 
#include <LEDA/impl/slist.h> 
#include <LEDA/impl/dp_hash.h> 


template<class itype, class etype>

class _CLASSTYPE dph_array : public dp_hash {

void clear_key(GenPtr& x)   const { Clear(ACCESS(itype,x)); }
void clear_inf(GenPtr& x)   const { Clear(ACCESS(etype,x)); }
void copy_key(GenPtr& x)    const { x=Copy(ACCESS(itype,x));  }
void copy_inf(GenPtr& x)    const { x=Copy(ACCESS(etype,x));  }

int  int_type() const { return 1; }

etype init;
SLIST def_list;

public:

etype& operator[](itype y) { stp i=lookup(Convert(y));
                             if (i==nil) { i=insert(Convert(y),Convert(init));
                                           def_list.append(Convert(y));  }
                             return ACCESS(etype,info(i)); }

etype  operator[](itype y) const
                           { stp i=lookup(Convert(y));
                             if (i==nil) return init;
                             else return ACCESS(etype,info(i)); }

bool defined(itype y) const { return (lookup(Convert(y)) != nil); }

void start_iteration()     { def_list.start_iteration(); }
bool next_index(itype& y){ GenPtr p; bool b=def_list.next_element(p);
                           y = ACCESS(itype,p); return b; }

 dph_array() { }
 dph_array(int n,itype* I,etype* E): dp_hash(n,(GenPtr*)I,(GenPtr*)E) { }
 dph_array(etype i) { init=i; }

 dph_array(const dph_array<itype,etype>& A): dp_hash((dp_hash&)A) { init = A.init; }

virtual ~dph_array() { def_list.clear(); }
};


#define forall_defined(i,A)  for ((A).start_iteration(); (A).next_index(i); )


#endif
