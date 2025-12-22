/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  segment_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SEGMENT_SET_H
#define LEDA_SEGMENT_SET_H

#include <LEDA/impl/seg_tree.h>
#include <LEDA/line.h>

typedef seg_tree_item seg_item;

typedef list<seg_item> list_seg_item_;


//------------------------------------------------------------------------------
// SegmentSet: a dictionary for line segments  with a fixed orientation
//------------------------------------------------------------------------------

class SegmentSet : public segment_tree<double,double,GenPtr> {

double alpha;           // orientation given by an angle

public:
 
segment  key(seg_item);

seg_item insert(segment, GenPtr);
seg_item lookup(segment);
void     del(segment);

list<seg_item>  intersection(segment);
list<seg_item>  intersection(line);

 SegmentSet(double a=0)  { alpha =a; }
~SegmentSet()  {}
};

#define forall_seg_items(i,S) forall_seg_tree_items(i,S)


//------------------------------------------------------------------------------
// class segment_set: generic SegmentSet
//------------------------------------------------------------------------------

 

template<class itype>

class _CLASSTYPE segment_set : public SegmentSet {

public:

itype inf(seg_item it)  { return ACCESS(itype,SegmentSet::inf(it));  }
seg_item insert(segment s, itype i)   { return SegmentSet::insert(s,Copy(i));}
void  change_inf(seg_item it,itype i) { SegmentSet::change_inf(it,Copy(i)); }

 segment_set(double a=0) : SegmentSet(a) {}
~segment_set()  {}
};
 
 
#endif
