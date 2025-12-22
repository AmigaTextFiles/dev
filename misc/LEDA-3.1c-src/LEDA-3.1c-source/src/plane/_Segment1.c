/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _Segment1.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



//#include <LEDA/line.h>

#ifdef AMIGA
#	include <LEDA/_Segment1.h>
#else
#	include <LEDA/Segment1.h>
#endif
#include <math.h>
#include <ctype.h>

//static const double eps = 1e-10;


//------------------------------------------------------------------------------
// Segments 
//------------------------------------------------------------------------------

Segment_rep::Segment_rep()  { count = 1; }

Segment_rep::Segment_rep(const Point& p, const Point& q) 
{ start = p;
  end   = q;
  dx = q.X()*p.W() - p.X()*q.W();
  dy = q.Y()*p.W() - p.Y()*q.W();
  count = 1; 
    
}
  


Segment::Segment() { PTR = new Segment_rep; }

Segment::Segment(const Point& x, const Point& y) 
{ PTR = new Segment_rep(x,y); }

Segment::Segment(const Int& x1, const Int& y1, const Int& x2, const Int& y2) 
{ PTR = new Segment_rep(Point(x1,y1), Point(x2,y2)); }


/*
Segment::Segment(const Point& p, double alpha, double length)
{ Point q = p.translate(alpha,length);
  PTR  = new Segment_rep(p,q); 
 }
  
Segment Segment::translate(double alpha, double d) const
{ Point p = ptr()->start.translate(alpha,d);
  Point q = ptr()->end.translate(alpha,d);
  return Segment(p,q);
 }

Segment Segment::translate(const vector& v) const
{ Point p = ptr()->start.translate(v);
  Point q = ptr()->end.translate(v);
  return Segment(p,q);
 }

*/


ostream& operator<<(ostream& out, const Segment& s) 
{ out << "[" << s.start() << "===" << s.end() << "]"; 
  return out;
 } 

/*
istream& operator>>(istream& in, Segment& s) 
{ int x1,x2,y1,y2; 
  in >> x1 >> y1 >> x2 >> y2; 
  s = Segment(Point(x1,y1),Point(x2,y2)); 
  return in; 
 } 
*/

istream& operator>>(istream& in, Segment& s) 
{ // syntax: {[} p {===} q {]}

  Point p,q; 
  char c;

  do in.get(c); while (isspace(c));
  if (c != '[') in.putback(c);

  in >> p;

  do in.get(c); while (isspace(c));
  while (c== '=') in.get(c);
  while (isspace(c)) in.get(c);
  in.putback(c);

  in >> q; 

  do in.get(c); while (c == ' ');
  if (c != ']') in.putback(c);

  s = Segment(p,q); 
  return in; 

 } 


/*
double Segment::angle(const Segment& s) const
{
  double cosfi,fi,norm;
  
  double dx  = ptr()->end.ptr()->x - ptr()->start.ptr()->x; 
  double dy  = ptr()->end.ptr()->y - ptr()->start.ptr()->y; 

  double dxs = s.ptr()->end.ptr()->x - s.ptr()->start.ptr()->x; 
  double dys = s.ptr()->end.ptr()->y - s.ptr()->start.ptr()->y; 
  
  cosfi=dx*dxs+dy*dys;
  
  norm=(dx*dx+dy*dy)*(dxs*dxs+dys*dys);

  if (norm == 0) return 0;

  cosfi /= sqrt( norm );

  if (cosfi >=  1.0 ) return 0;
  if (cosfi <= -1.0 ) return M_PI;
  
  fi=acos(cosfi);

  if (dx*dys-dy*dxs>0) return fi;

  return -fi;

}


double Segment::distance(const Segment& s) const
{ if (angle(s)!=0) return 0;
  return distance(s.ptr()->start);
 }

double  Segment::distance() const
{ return distance(Point(0,0)); }

double Segment::distance(const Point& p) const
{ Segment s(ptr()->start,p);
  double l = s.length();
  if (l==0) return 0;
  else return l*sin(angle(s));
 }


double  Segment::y_proj(double x)  const
{ return  ptr()->start.ptr()->y - ptr()->slope * (ptr()->start.ptr()->x - x); }

double  Segment::x_proj(double y)  const
{ if (vertical())  return  ptr()->start.ptr()->x;
  return  ptr()->start.ptr()->x - (ptr()->start.ptr()->y - y)/ptr()->slope; }

*/

bool Segment::intersection(const Segment& s, Point& inter) const
/* decides whether |s| and |this| segment intersect and, if so, returns the
intersection in |r|. It is assumed that both segments have non-zero length */
{ 
Int px = ptr()->start.X();
Int py = ptr()->start.Y();
Int pw = ptr()->start.W();

Int qx = ptr()->end.X();
Int qy = ptr()->end.Y();
Int qw = ptr()->end.W();

Int spx = s.start().X();
Int spy = s.start().Y();
Int spw = s.start().W();

Int sqx = s.end().X();
Int sqy = s.end().Y();
Int sqw = s.end().W();

Int A = -(py*qw - qy*pw);
Int B =   px*qw - qx*pw;
Int C = -(px*qy - qx*py);


Int Aprime = -(spy*sqw - sqy*spw);
Int Bprime =   spx*sqw - sqx*spw;
Int Cprime = -(spx*sqy - sqx*spy);

Int cx = -(B*Cprime - C*Bprime);
Int cy =   A*Cprime - C*Aprime ;
Int cw = -(A*Bprime - B*Aprime);

if (cw == 0) return false;   //same slope

inter = Point(cx,cy,cw);


/* cw is non-zero. Its sign does not matter for the test to follow.

  
  if (pX*cw < cx &&  qX*cw < cx ||  pX*cw > cx  && qX*cw > cx ||
   spX*cw< cx && sqX*cw < cx || spX*cw > cx && sqX*cw > cx ||
   pY*cw < cy &&  qY*cw < cy ||  pY*cw > cy  && qY*cw > cy ||
   spY*cw< cy && sqY*cw < cy || spY*cw > cy && sqY*cw > cy)
  return false;
*/

/* we still need to test whether inter lies on both segments. A point lies on a segment if it compares diffently with the two endpoints of the segment */

if ((compare(start(),inter) == compare(end(),inter)) ||
 (compare(s.start(),inter) == compare(s.end(),inter)))
return false;

return true;
}


bool Segment::intersection_of_lines(const Segment& s, Point& inter) const
{ 
  /* decides whether the lines induced by |s| and |this| segment 
     intersect and, if so, returns the intersection in |inter|. 
     It is assumed that both segments have non-zero length
   */
  
  Int w = dy()*s.dx() - dx()*s.dy();

  if (w == 0) return false;   //same slope

  Int c1 = X2()*Y1() - X1()*Y2();
  Int c2 = s.X2()*s.Y1() - s.X1()*s.Y2();

  inter = Point(dx()*c2 - s.dx()*c1, dy()*c2 - s.dy()*c1, w);

  return true;
}

/*
Segment Segment::rotate(double alpha) const
{  double  l = length();
   Point p = start();
   double beta = alpha + angle();
   return Segment(p,beta,l);
}

Segment Segment::rotate(const Point& origin, double alpha) const
{  Point p = start().rotate(origin,alpha);
   Point q = end().rotate(origin,alpha);
   return Segment(p,q);
}
*/

