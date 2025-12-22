/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  template.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_TEMPLATE_H
#define LEDA_TEMPLATE_H


// g++, bcc, and ztc allow to use template arguments as base classes,
// cfront does not !
// If template arguments cannot be used as base classes the old 
// macro-based declare mechanism has to be used for data types 
// with implementation parameters

#if defined(__GNUG__) || defined(__TURBOC__) || defined(__ZTC__) 
#define __TEMPLATE_ARGS_AS_BASE__
#else
// cfront 
#include <generic.h>
#define declare3(_a,t1,t2,t3)    name2(_a,declare3)(t1,t2,t3)
#endif



// g++ (version < 2.6), bcc, and ztc cannot handle template functions correctly
// and we have to use the LEDA_TYPE_PARAMETER macro for class type arguments
// to generate Copy, Clear, Access, ... functions.

#if (defined(__GNUG__) && __GNUC_MINOR__ < 6) || defined(__TURBOC__) || defined(__ZTC__) 
#undef __TEMPLATE_FUNCTIONS__

#else
#define __TEMPLATE_FUNCTIONS__

// function templates (default implementations) for Convert, Copy, Clear,
// Access, Init, Int_Type, Type_Name, Print, Read, compare, ...
// (to be used if there are no special versions defined in basic.h)


template <class T>
inline GenPtr Convert(const T& x) 
{ if (sizeof(T) == sizeof(GenPtr)) 
     return *(GenPtr*)&x;
  else 
     return GenPtr(&x);
}


template <class T>
inline GenPtr Copy(const T& x) 
{ if (sizeof(T) == sizeof(GenPtr)) 
     return *(GenPtr*)&x;
  else 
     return new T(x);
 }


template <class T>
inline void Clear(T& x) 
{ T* p = &x;
  if (sizeof(T) > sizeof(GenPtr)) delete p; 
 }


template <class T>
inline T& Access(T*, const GenPtr& p) 
{ if (sizeof(T) <= sizeof(GenPtr)) 
     return *(T*)&p;
  else 
     return *(T*)p;
}

template <class T> inline void  Init(T&) {}

template <class T> inline int   Int_Type(T*)  { return 0; }

template <class T> inline char* Type_Name(T*) { return "unknown"; }


/*
template <class T> inline void Print(const T&, ostream&) {}
template <class T> inline void Read(T&, istream&) {}

template <class T>
inline int compare(const T&, const T&)  
{ error_handler(1,string("compare for type `%s' undefined",Type_Name((T*)0)));  
  return 0;
 }
*/

#endif

#endif
