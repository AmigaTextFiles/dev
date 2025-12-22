/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _point.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/segment.h>
#include <math.h>
#include <ctype.h>

static const double eps = 1e-10;


//------------------------------------------------------------------------------
// points 
//------------------------------------------------------------------------------


point_rep::point_rep()  { count=1; x = y = 0.0; }

point_rep::point_rep(double a, double b) 
{ x = a; 
  y = b; 
  count = 1; 
}



point::point()                  { PTR = new point_rep; }
point::point(double x, double y){ PTR = new point_rep(x,y); }
point::point(vector v)          { PTR = new point_rep(v[0], v[1]); }

double point::angle(const point& q, const point& r) const
{
  double cosfi,fi,norm;
  
  double dx  = q.ptr()->x - ptr()->x; 
  double dy  = q.ptr()->y - ptr()->y; 

  double dxs = r.ptr()->x - q.ptr()->x; 
  double dys = r.ptr()->y - q.ptr()->y; 
  
  cosfi=dx*dxs+dy*dys;
  
  norm=(dx*dx+dy*dy)*(dxs*dxs+dys*dys);

  cosfi /= sqrt( norm );

  if (cosfi >=  1.0 ) return 0;
  if (cosfi <= -1.0 ) return M_PI;
  
  fi=acos(cosfi);

  if (dx*dys-dy*dxs>0) return fi;

  return -fi;
}
  

point point::rotate(const point& origin, double alpha) const
{ if (origin == *this) return *this;
  segment s(origin,*this);
  return s.rotate(alpha).end();
}

point point::rotate(double alpha) const
{ return rotate(point(0,0),alpha); }

point point::translate(double alpha, double d) const
{ double dx = cos(alpha) * d;
  double dy = sin(alpha) * d;
  return point(ptr()->x+dx,ptr()->y+dy);
 }

point point::translate(const vector& v) const
{ return point(ptr()->x+v[0],ptr()->y+v[1]);
 }

double point::distance(const point& p)  const
{ return hypot(p.ptr()->x - ptr()->x, p.ptr()->y - ptr()->y); } 

double point::distance() const
{ return distance(point(0,0)); }


int point::operator==(const point& p) const 
{ return (fabs(ptr()->x - p.ptr()->x) < eps && fabs(ptr()->y - p.ptr()->y) < eps); }


ostream& operator<<(ostream& out, const point& p)
{ out << "(" << p.xcoord() << "," << p.ycoord() << ")";
  return out;
 } 

istream& operator>>(istream& in, point& p) 
{ // syntax: {(} x {,} y {)}

  double x,y; 
  char c;

  do in.get(c); while (in && isspace(c));

  if (!in) return in;

  if (c != '(') in.putback(c);

  in >> x;

  do in.get(c); while (isspace(c));
  if (c != ',') in.putback(c);

  in >> y; 

  do in.get(c); while (c == ' ');
  if (c != ')') in.putback(c);

  p = point(x,y); 
  return in; 

 } 

