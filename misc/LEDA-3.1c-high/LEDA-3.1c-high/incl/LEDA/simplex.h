/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  simplex.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SIMPLEX_H
#define LEDA_SIMPLEX_H

#include <LEDA/matrix.h>
#include <LEDA/list.h>


list<matrix> SIMPLEX(matrix A, int i, int j, int k, vector b, vector c);


#endif

