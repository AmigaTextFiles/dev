/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  plane.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_PLANE_H
#define LEDA_PLANE_H

#include <LEDA/point.h>
#include <LEDA/segment.h>
#include <LEDA/line.h>
#include <LEDA/circle.h>
#include <LEDA/polygon.h>

extern line p_bisector(const point& p, const point& q);

#endif
