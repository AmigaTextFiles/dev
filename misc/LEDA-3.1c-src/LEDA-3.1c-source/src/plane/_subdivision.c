/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _subdivision.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/segment.h>
#include <LEDA/subdivision.h>
#include <LEDA/p_dictionary.h>
#include <LEDA/sortseq.h>
#include <LEDA/prio.h>

static int compare(segment& s1, segment& s2);

typedef p_dictionary<segment,face> strip;

typedef p_dictionary<segment,face>* Strip_Ptr;

typedef sortseq<double,Strip_Ptr> strip_list;

typedef priority_queue<edge,point> X_structure;



static double x_sweep;

int compare(segment& s1,segment& s2)
{
  if (s1 == s2) return 0;

  double sl1 = s1.slope();
  double sl2 = s2.slope();

  if (s1.start() == s2.start()) return compare(sl1,sl2);

  if (s1.end() == s2.end()) return compare(sl2,sl1);

  double y1 = sl1*x_sweep+s1.y_abs();
  double y2 = sl2*x_sweep+s2.y_abs();

  return (y1 > y2) ? 1 : -1;

}

SubDivision::SubDivision(const graph& G) : planar_map(G)
{ 
  edge e;
  segment s;
  point p;
  strip sp;
  int count = 0;

  // compute strips

  strip_list* strips = new strip_list;

  strip_ptr = (void*)strips;

  X_structure X;

  // initialize X-structure

  forall_edges(e,*this) 
  { point p = position(source(e));
    point q = position(target(e));

    if (p.xcoord() < q.xcoord()) 
    { X.insert(e,p);
      X.insert(e,q);
     }
   }




  // sweep

  strip Y;

  x_sweep = -MAXDOUBLE;

  strips->insert(x_sweep, new strip(Y));    

  while( !X.empty() )
  { point    p = X.inf(X.find_min());
    list<edge> L,R;

    while ( !X.empty() )
    { pq_item it = X.find_min();
      point    q = X.inf(it);
      edge     e = X.key(it);

      if (q != p) break;

      if (q == position(source(e)))  // left  end
          L.append(e);    
      else                           // right end
          R.append(e);    

      X.del_item(it);
     }


    // Insert new strip into version List

    x_sweep = p.xcoord();

    edge e;
    forall(e,R) Y = Y.del(segment(position(source(e)),position(target(e))));
    forall(e,L) Y = Y.insert(segment(position(source(e)),
                                     position(target(e))), adj_face(e));

    L.clear();
    R.clear();

    strips->insert(x_sweep, new strip(Y));    

    }

   strips->insert(MAXDOUBLE, new strip(Y));    


   // compute outer face

   seq_item sit = strips->min();
   sit = strips->succ(sit);

   outer_face = Y.inf(strips->inf(sit)->min());

}



face SubDivision::locate_point(point p) const
{
  strip_list* strips = (strip_list*)strip_ptr;

  seq_item sit = strips->locate(p.xcoord()); 
  Strip_Ptr Y = strips->inf(strips->pred(sit));
  x_sweep = p.xcoord();
  p_dic_item it = Y->locate(segment(p,0,1));
  return (it == nil) ? outer_face : Y->inf(it);
 }


void SubDivision::print_stripes() const
{ seq_item it1;
  p_dic_item it2;
  strip_list* strips = (strip_list*)strip_ptr;

  forall_items(it1,*strips)
  { Strip_Ptr sp = strips->inf(it1);
    forall_items(it2,*sp) 
      cout << sp->key(it2) << " f = " << int(sp->inf(it2)) << "\n";
    newline;
  }
  newline;
 }

SubDivision::~SubDivision() 
{ strip_list* strips = (strip_list*)strip_ptr;
  seq_item it;
  forall_items(it,*strips) delete strips->inf(it);
  delete strips; 
}


