/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _point_set.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/point_set.h>
#include <LEDA/d2_dictionary.h>


typedef d2_dictionary<double,double,DT_item>* d2_dic_ptr;

#define TTT (*d2_dic_ptr(ptr))

ps_item  Point_Set::insert(point p, void* i) 
{ ps_item it = delaunay_tree::insert(p,i);
  TTT.insert(p.xcoord(),p.ycoord(),it);
  return it;
 }

list<point> Point_Set::all_points()
{ list<point> result;
  list<ps_item>  L = all_items();
  ps_item it;
  forall(it,L) result.append(key(it));
  return result;
}


ps_item Point_Set::lookup(point p)
{ double    x  = p.xcoord();
  double    y  = p.ycoord();
  dic2_item it = TTT.lookup(x,y);
  return (it!=nil) ? TTT.inf(it) : nil;
}

list<ps_item> Point_Set::range_search(double x0, double x1, double y0, double y1)
{
  list<dic2_item> Lr = TTT.range_search(x0,x1,y0,y1);

  list<ps_item> Lp;

  dic2_item it;

  forall(it,Lr) Lp.append(TTT.inf(it));

  return Lp;

}


list<ps_item> Point_Set::all_items()          
{ list<DT_item> L; 
  delaunay_tree::all_items(L); 
  return *(list<ps_item>*)&L;
 }


list<ps_item> Point_Set::convex_hull()
{ list<DT_item> L; 
  delaunay_tree::convex_hull(L);
  return *(list<ps_item>*)&L;
 }

void Point_Set::del(point p)
{ delaunay_tree::del(p);
  TTT.del(p.xcoord(),p.ycoord());
 }

void Point_Set::clear() { TTT.clear(); delaunay_tree::clear();  }

int  Point_Set::size()  { return TTT.size(); }

Point_Set::Point_Set()  { ptr = new d2_dictionary<double,double,DT_item>; }

Point_Set::~Point_Set() { delete d2_dic_ptr(ptr); }
