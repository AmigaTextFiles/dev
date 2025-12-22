/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _seg_set.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/segment_set.h>

segment  SegmentSet::key(seg_item it)
{ segment s(x0(it),y(it),x1(it),y(it)); 
  return s.rotate(point(0,0),alpha);
 }

seg_item SegmentSet::insert(segment s, GenPtr p)
{ segment t = s.rotate(point(0,0),-alpha);
  double x0 = t.xcoord1();
  double x1 = t.xcoord2();
  double  y = t.ycoord1();
  return segment_tree<double,double,GenPtr>::insert(x0,x1,y,p);
}

seg_item SegmentSet::lookup(segment s)
{ segment t = s.rotate(point(0,0),-alpha);
  double x0 = t.xcoord1();
  double x1 = t.xcoord2();
  double  y = t.ycoord1();
  return segment_tree<double,double,GenPtr>::lookup(x0,x1,y);
}

void     SegmentSet::del(segment s)
{ segment t = s.rotate(point(0,0),-alpha);
  double x0 = t.xcoord1();
  double x1 = t.xcoord2();
  double  y = t.ycoord1();
  (void)segment_tree<double,double,GenPtr>::del(x0,x1,y); 
}

list<seg_item>  SegmentSet::intersection(segment q)
{ list<seg_tree_item> L;
  segment t = q.rotate(point(0,0),-alpha);
  double  x = t.xcoord1();
  double y0 = t.ycoord1();
  double y1 = t.ycoord2();
  L = segment_tree<double,double,GenPtr>::query(x,y0,y1); 
  return *((list<seg_item>*)&L);
}

list<seg_item>  SegmentSet::intersection(line q)
{ list<seg_tree_item> L;
  line t = q.rotate(-alpha);
  double  x = t.x_proj(0);
  L = segment_tree<double,double,GenPtr>::y_infinity_query(x); 
  return *((list<seg_item>*)&L);
}

