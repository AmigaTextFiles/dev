/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _voronoi.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/voronoi.h>
#include <LEDA/segment.h>
#include <LEDA/impl/delaunay_tree.h>
#include <LEDA/d_array.h>



static d_array<point,node>* VP;

static GRAPH<point,point>*  G;

static double infi_length;

static point* XP;


static void trace_segment(double x1, double y1, double x2, double y2, 
                   double sx0, double sy0)
{
  point p(x1,y1);
  point q(x2,y2);
  point s(sx0,sy0);

  node v,w;

  if ((v = (*VP)[p]) == nil) (*VP)[p] = v = G->new_node(p);
    
  if ((w = (*VP)[q]) == nil) (*VP)[q] = w = G->new_node(q);

  G->new_edge(v,w,s);


}


static void infi_point(double x1, double y1, double x2, double y2, double* x, double* y)
{
  vector v(x2,y2);

  v = v.norm();

  *x = x1 + infi_length * v[0];
  *y = y1 + infi_length * v[1];

}


static int cmp_infi_pts(const point& p, const point& q)
{ // used to sort infi points clockwise around XP
  segment  s1(*XP,p);
  segment  s2(*XP,q);
  return compare(s2.angle(),s1.angle());
}


void VORONOI(list<point>& site_list, double R, GRAPH<point,point>& VD)
{ 
   if (site_list.empty()) return;

   d_array<point,node> V(nil);

   point X = site_list.head();

   VP = &V;
   XP = &X;

   delaunay_tree DT;

   point p,q;
   node v;

   list<point> infi_list;

   forall(p,site_list) DT.insert(p,0);

   infi_length = R;

   G = &VD;

   DT.trace_voronoi_edges(trace_segment, infi_point, 1);


   // sort & link infinite points

   forall_nodes(v,VD) 
     if (VD.outdeg(v) == 1) infi_list.append(VD[v]);

   infi_list.sort(cmp_infi_pts);

   point INFI(MAXDOUBLE,MAXDOUBLE);  

   list_item it;

   forall_items(it,infi_list)
   {  node p = V[infi_list[it]];
      node q = V[infi_list[infi_list.cyclic_succ(it)]];
      point s = VD[VD.first_adj_edge(q)];
      VD.new_edge(p,q,s); 
    }

   forall_items(it,infi_list)
   {  node p = V[infi_list[it]];
      node q = V[infi_list[infi_list.cyclic_pred(it)]];
      VD.new_edge(p,q,INFI);  
    }

   V.clear();

}

