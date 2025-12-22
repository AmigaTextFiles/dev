/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  point_set.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_POINT_SET_H
#define LEDA_POINT_SET_H

#include <LEDA/point.h>
#include <LEDA/impl/delaunay_tree.h>

typedef DT_item       ps_item;


class Point_Set : public delaunay_tree {

void* ptr;  // d2_dictionary(double,double,DT_item)*

public:

 Point_Set();
~Point_Set();

ps_item       lookup(point);

list<ps_item> range_search(double, double, double, double);
 
list<point>  all_points();

ps_item      insert(point p, void* i);

ps_item      nearest_neighbor(point p){ return delaunay_tree::neighbor(p); }

void         change_inf(ps_item it, void* i) { delaunay_tree::change_inf(it,i);}

void         del(point);

void         del_item(ps_item it) { del(key(it)); }

list<ps_item> all_items();
list<ps_item> convex_hull();

void          clear();
int           size();
bool          empty()   { return (size()==0) ? true:false; }

};




template<class itype>

class _CLASSTYPE point_set : public Point_Set {

void clear_inf(GenPtr& x) { Clear(ACCESS(itype,x)); }
void copy_inf(GenPtr& x)  { x=Copy(ACCESS(itype,x));  }

public:

void    change_inf(ps_item it, itype i) { Point_Set::change_inf(it,Convert(i));}
itype   inf(ps_item it)          { return ACCESS(itype,Point_Set::inf(it)); }
ps_item insert(point p, itype i) { return Point_Set::insert(p,Convert(i));}

 point_set()   {}
~point_set()   { clear(); }
};

#define forall_ps_items(i,D) forall(i, (D.all_items()) )

#endif

