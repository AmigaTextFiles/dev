/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _line.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/line.h>
#include <math.h>

static const double eps = 1e-10;

//------------------------------------------------------------------------------
// lines 
//------------------------------------------------------------------------------



line::line()
{ PTR = new line_rep; }

line::line(const segment& s) 
{ PTR = new line_rep(s); }

line::line(const point& x, const point& y)    
{ PTR = new line_rep(segment(x,y)); }

line::line(const point& p, double alpha) 
{ PTR = new line_rep(segment(p,alpha,1)); }
  


bool line::contains(const point& p)   const
{ if (vertical())
      return p.xcoord() == ptr()->seg.xcoord1(); 
  else
      return p.ycoord() == y_proj(p.xcoord());
 }

bool line::contains(const segment& s) const
{ point p = s.start(); 
  point q = s.end();
  if (contains(p))
    if (contains(q)) return true; 
  return false;
 }


ostream& operator<<(ostream& out, const line& l) 
{ return out << l.seg(); }

istream& operator>>(istream& in, line& l)  
{ segment s; 
  in >> s; 
  l = line(s); 
  return in; 
 }


bool line::intersection(const line& s, point& inter) const
{ double cx,cy;

  if (slope() == s.slope()) return false;

  if (vertical())
     cx = ptr()->seg.xcoord1();
  else
     if (s.vertical())
        cx = s.ptr()->seg.xcoord1();
     else
        cx = (s.y_abs()-y_abs())/(slope()-s.slope());
 
  if (vertical())
     cy = slope() * cx + y_abs();
  else
     cy = s.slope() * cx + s.y_abs();

  inter = point(cx,cy);

  return true;
}


bool line::intersection(const segment& s, point& inter) const
{ if (intersection(line(s),inter))
  { double d1  = inter.distance(s.ptr()->start);
    double d2  = inter.distance(s.ptr()->end);
    double l   = s.length();
    if ( d1<=l && d2 <=l) return true;
   }
   return false;
}


segment line::perpendicular(const point& q) const
{ segment s = ptr()->seg;
  point r = q.translate(s.angle()+M_PI_2,-distance(q));
  return segment(q,r);
 }


