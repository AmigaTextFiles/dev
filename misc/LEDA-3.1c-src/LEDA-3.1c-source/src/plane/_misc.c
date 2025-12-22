/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _misc.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/plane.h>
#include <math.h>

line p_bisector(const point& p, const point& q)
{ line l(p,q);
  double m_x = (p.xcoord() + q.xcoord())/2;
  double m_y = (p.ycoord() + q.ycoord())/2;
  point M(m_x,m_y);

  double alpha = l.angle();

  return line(M,alpha+M_PI_2);

}




  
