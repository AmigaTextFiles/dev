/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  h_array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_H_ARRAY_H
#define LEDA_H_ARRAY_H

//------------------------------------------------------------------------------
// h_array  
//------------------------------------------------------------------------------ 
#include <LEDA/basic.h> 
#include <LEDA/impl/ch_array.h> 


template<class itype, class etype>

class _CLASSTYPE h_array : private ch_array {

 void copy_inf(GenPtr& x)    const { x=Copy(ACCESS(etype,x));  }
 void clear_inf(GenPtr& x)   const { Clear(ACCESS(etype,x)); }

 public:

 etype& operator[](itype y) { return ACCESS(etype,access(Convert(y))); }

 etype operator[](itype y) const { return ACCESS(etype,access(Convert(y))); }

 bool defined(itype y) const { return (lookup(Convert(y)) != nil); }


 void start_iteration()  { }
 bool next_index(itype&) { return false; }
 
 h_array() {}
 h_array(etype i) : ch_array(Copy(i),sizeof(itype)) {}
 h_array(etype i, int sz) : ch_array(Copy(i),sz) {}
 h_array(etype i, int sz, int n) : ch_array(Copy(i),sz,n) {}
 h_array(const h_array<itype,etype>& A): ch_array((ch_array&)A) {}
~h_array() { }

};


#define forall_defined(i,A)  for ((A).start_iteration(); (A).next_index(i); )


#endif
