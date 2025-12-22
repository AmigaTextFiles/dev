/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _Point1.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <math.h>
#include <ctype.h>
#ifdef AMIGA
#	include <LEDA/_Point1.h>
#else
#	include <LEDA/Point1.h>
#endif

//------------------------------------------------------------------------------
// Points 
//------------------------------------------------------------------------------


Point_rep::Point_rep()  { count=1; x = y = 0; w = 1;}

Point_rep::Point_rep(Int a, Int b) 
{ x = a; 
  y = b;
  w = 1; 
  count = 1; 
}


Point_rep::Point_rep(Int a, Int b, Int c) 
{ x = a; 
  y = b;
  w = c; 
  count = 1; 
}

Point::Point()                  { PTR = new Point_rep; }
Point::Point(Int x, Int y){ PTR = new Point_rep(x,y); }
Point::Point(Int x, Int y, Int w){ PTR = new Point_rep(x,y,w); }

//Point::Point(vector v)          { PTR = new Point_rep(v[0], v[1]); }

/*
double Point::angle(const Point& q, const Point& r) const
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
  

Point Point::rotate(const Point& origin, double alpha) const
{ if (origin == *this) return *this;
  segment s(origin,*this);
  return s.rotate(alpha).end();
}

Point Point::rotate(double alpha) const
{ return rotate(Point(0,0),alpha); }

Point Point::translate(double alpha, double d) const
{ double dx = cos(alpha) * d;
  double dy = sin(alpha) * d;
  return Point(ptr()->x+dx,ptr()->y+dy);
 }

Point Point::translate(const vector& v) const
{ return Point(ptr()->x+v[0],ptr()->y+v[1]);
 }

double Point::distance(const Point& p)  const
{ return hypot(p.ptr()->x - ptr()->x, p.ptr()->y - ptr()->y); } 

double Point::distance() const
{ return distance(Point(0,0)); }
*/


int Point::operator==(const Point& p) const 
{ return ( (((ptr()->x) * (p.ptr()->w) - (p.ptr()->x) * (ptr()->w)) == 0) && 
(((ptr()->y) * (p.ptr()->w) - (p.ptr()->y) * (ptr()->w)) == 0)); }


ostream& operator<<(ostream& out, const Point& p)
{ out << "(" << p.X() << "," << p.Y() << "," << p.W() << ")";
  return out;
 } 

istream& operator>>(istream& in, Point& p) 
{ // syntax: {(} x {,} y {,} w {)}   

  int x,y,w;
  char c;

  do in.get(c); while (in && isspace(c));

  if (!in) return in;

  if (c != '(') in.putback(c);

  in >> x;

  do in.get(c); while (isspace(c));
  if (c != ',') in.putback(c);

  in >> y; 

  do in.get(c); while (isspace(c));
  if (c != ',') in.putback(c);

  in >> w; 

  do in.get(c); while (c == ' ');
  if (c != ')') in.putback(c);

  p = Point(x,y,w ); 
  return in; 

 } 

/*
int compare(const Point& a, const Point& b)
{ Int x = a.X() * b.W();
  Int y = b.X() * a.W();
  int s = sign(a.W()) * sign(b.W());
  if (x == y) 
  { x = a.Y() * b.W();
    y = b.Y() * a.W();
    if (x == y) return 0;
   }
  return (x < y) ? -s : s;
}
*/


