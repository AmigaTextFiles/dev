/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  voronoi.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_VORONOI_H
#define LEDA_VORONOI_H

#include <LEDA/plane_graph.h>

void VORONOI(list<point>& sites, double R, GRAPH<point,point>& VD);

#endif
