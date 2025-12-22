/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  interval_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_INTERVAL_SET_H
#define LEDA_INTERVAL_SET_H

#include <LEDA/d2_dictionary.h>

typedef dic2_item is_item;





class Interval_Set : public d2_dictionary<double,double,GenPtr> {

public:

double    left(is_item it) { return key1(it); }
double    right(is_item it){ return key2(it); }

list<is_item>  intersection(double x, double y)
{ list<dic2_item> L = range_search(-MAXFLOAT,y,x,MAXFLOAT);
  return *((list<is_item>*)&L);
}

 Interval_Set()  {}
~Interval_Set()  {}
};





template <class itype>

class _CLASSTYPE interval_set : public Interval_Set{

public:

itype   inf(is_item it)  { return ACCESS(itype,Interval_Set::inf(it)); }

is_item insert(double x, double y, itype i)
                      { return Interval_Set::insert(x,y,Copy(i)); }

void    change_inf(is_item it, itype i)
                      { Interval_Set::change_inf(it,Copy(i)); }

list<is_item>  intersection(double x, double y)
                         { return Interval_Set::intersection(x,y); }

 interval_set()  {}
~interval_set()  {}
};

#define forall_is_items(i,D) forall_dic2_items(i,D)

#endif

