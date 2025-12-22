/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  Int.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_INTEGER_H
#define LEDA_INTEGER_H

#include <Integer.h>

inline double Itodouble(const Integer& i) { return i.as_double(); }


typedef Integer Int;

#endif
