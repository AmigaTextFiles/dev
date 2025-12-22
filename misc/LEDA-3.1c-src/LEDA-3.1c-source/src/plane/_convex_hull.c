/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _convex_hull.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/convex_hull.h>
#include <LEDA/plane.h>

list<point> CONVEX_HULL(list<point> L)
{ 
  if (L.length() < 3) return L;

  list<point> CH;
  list_item last;
  point p;

  L.sort();  // sort points lexicographically


  // initialize convex hull with first two points

  p = L.pop();
  CH.append(p);
  while (L.head() == p) L.pop();
  last = CH.append(L.pop());


  // scan remaining points

  forall(p,L)
  {
    if (p == CH[last]) continue;  // multiple point

    // compute upper tangent (p,up)

    list_item up = last;
    list_item it = CH.cyclic_succ(up);

    while (left_turn(CH[it],CH[up],p))
    { up = it;
      it = CH.cyclic_succ(up);
     }


    // compute lower tangent (p,low)

    list_item low = last;
    it = CH.cyclic_pred(low);

    while (right_turn(CH[it],CH[low],p))
    { low = it;
      it = CH.cyclic_pred(low);
     }


    // remove all points between up and low

    if (up != low)
    { it = CH.cyclic_succ(low);

      while (it != up)
      { CH.del(it);
        it = CH.cyclic_succ(low);
       }
     }

    // insert new point

    last = CH.insert(p,low);

   }

  return CH;
}
