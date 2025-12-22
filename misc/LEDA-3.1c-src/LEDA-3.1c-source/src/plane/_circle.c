/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _circle.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/circle.h>
#include <math.h>

static const double eps = 1e-10;

//------------------------------------------------------------------------------
// circles
//------------------------------------------------------------------------------


circle::circle()                        { PTR = new circle_rep; }
circle::circle(const point& c, double r)       { PTR = new circle_rep(c,r); }
circle::circle(double x, double y, double r)  
                                        { PTR = new circle_rep(point(x,y),r); }
  

int circle::operator==(const circle& c)  const
{ double dr =  fabs(ptr()->radius - c.ptr()->radius);
  return (ptr()->center == c.ptr()->center && dr < eps);
 }


double circle::distance(const point& p) const
{ double d = p.distance(ptr()->center);
  return (d - ptr()->radius);
 }

double circle::distance(const line& l) const
{ double d = l.distance(ptr()->center);
  return (d - ptr()->radius);
 }

double circle::distance(const circle& c) const
{ double d = ptr()->center.distance(c.ptr()->center);
  return (d - ptr()->radius - c.ptr()->radius);
 }

bool circle::inside(const point& p) const 
{ return distance(p)<=0; }


circle circle::translate(double alpha, double d) const
{ point p = ptr()->center.translate(alpha,d);
  return circle(p,ptr()->radius);
 }

circle circle::translate(const vector& v) const
{ point p = ptr()->center.translate(v);
  return circle(p,ptr()->radius);
 }

circle  circle::rotate(const point& o, double alpha) const
{ return circle(ptr()->center.rotate(o,alpha),ptr()->radius); 
 }

circle  circle::rotate(double alpha)          const
{ return rotate(point(0,0),alpha);
 }

list<point> circle::intersection(const line& l) const
{ list<point> result;
  segment s = l.perpendicular(ptr()->center);
  double  d = s.length();
  double  r = ptr()->radius;
  point   F = s.end();

  if (d==r) result.append(F);
  
  if (d < r)
  { double alpha = l.angle();
    double x = sqrt(r*r - d*d);
    point  p = F.translate(alpha,x);
    point  q = F.translate(alpha,-x);
    result.append(q);
    result.append(p);
  }

  return result;
}


list<point> circle::intersection(const segment& s) const
{ list<point> result,L;

  L = intersection(line(s));

  point p;
  double  d  = s.length();

  forall(p,L)
  { double d1 = s.ptr()->start.distance(p);
    double d2 = s.ptr()->end.distance(p);
    if (d1 <= d && d2 <= d) result.append(p);
   }

  return result;
}

list<point> circle::intersection(const circle& c) const
{ list<point> result;
  segment s(ptr()->center, c.ptr()->center);
  double d  = s.length();
  double r1 = ptr()->radius;
  double r2 = c.ptr()->radius;

  if (d > (r1+r2) || (d+r2) < r1 || (d+r1) < r2) return result;


  double x = (d*d + r1*r1 - r2*r2)/(2*d);
  double alpha = acos(x/r1);
  double beta  = s.angle() + alpha;
  double gamma = s.angle() - alpha;

  result.append(ptr()->center.translate(beta,r1));
  if (alpha!=0) result.append(ptr()->center.translate(gamma,r1));

  return result;
 }


segment circle::left_tangent(const point& p) const
{ if (inside(p)) error_handler(1,"left_tangent:: point inside circle");
  segment s(p,ptr()->center);
  double d = s.length();
  double alpha = asin(ptr()->radius/d) + s.angle();
  point touch = p.translate(alpha,sqrt(d*d - ptr()->radius*ptr()->radius));
  return segment(p,touch);
}

segment circle::right_tangent(const point& p) const
{ if (inside(p)) error_handler(1,"right_tangent:: point inside circle");
  segment s(p,ptr()->center);
  double d = s.length();
  double alpha = s.angle() - asin(ptr()->radius/d);
  point touch = p.translate(alpha,sqrt(d*d - ptr()->radius*ptr()->radius));
  return segment(p,touch);
}

ostream& operator<<(ostream& out, const circle& c) 
{ out << c.center() << " "<< c.radius(); 
  return out;
 } 

istream& operator>>(istream& in,  circle& c) 
{ point cent;
  double rad;
  if (in) in >> cent;
  if (in) in >> rad;
  c = circle(cent,rad);
  return in;
}


