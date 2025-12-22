/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  sweep_segments.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SWEEPSEGMENTS_H
#define LEDA_SWEEPSEGMENTS_H

#include <LEDA/plane_graph.h>

//------------------------------------------------------------------------------
// line sweep for straight line segments
//------------------------------------------------------------------------------

void SWEEP_SEGMENTS(const list<segment>&, const list<segment>&, 
                                          GRAPH<point,int>&);

void SWEEP_SEGMENTS(const list<segment>&, list<point>&);


inline void SWEEP_SEGMENTS(const list<segment>& L, GRAPH<point,int>& G)
{ list<segment> dummy;
  SWEEP_SEGMENTS(L,dummy,G); }

inline void SEGMENT_INTERSECTION(const list<segment>& L, list<point>& P)
{ SWEEP_SEGMENTS(L,P); }

#endif
