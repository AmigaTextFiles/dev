/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  point.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_POINT_H
#define LEDA_POINT_H

#include <LEDA/list.h>
#include <LEDA/vector.h>

class point;
class segment;

//------------------------------------------------------------------------------
// points
//------------------------------------------------------------------------------

class point_rep  : public handle_rep {

friend class point;
friend class segment;
friend class line;
friend class circle;
   
   double x;
   double y;

public:
    
   point_rep();     
   point_rep(double a, double b);

  ~point_rep() {}
   
   
   LEDA_MEMORY(point_rep)
   
};


class point  : public handle_base 
{

friend class segment;
friend class line;
friend class circle;


point_rep* ptr() const { return (point_rep*)PTR; }

public:

 point();
 point(double, double);
 point(vector);
 point(const point& p) : handle_base(p) {}
~point()                  { clear(); }

point& operator=(const point& p) { handle_base::operator=(p); return *this; }


operator vector()         { return vector(ptr()->x,ptr()->y); }

double  xcoord()  const   { return ptr()->x; }
double  ycoord()  const   { return ptr()->y; }

double  angle(const point&, const point&) const;

double  distance(const point&) const;
double  distance() const;

point   translate(double,double) const;
point   translate(const vector&) const;

point   rotate(const point&,double) const;
point   rotate(double) const;


point operator+(const vector& v) const { return translate(v); }

int operator==(const point&) const;

int operator!=(const point& p)  const { return !operator==(p);}

friend ostream& operator<<(ostream& out, const point& p) ;
friend istream& operator>>(istream& in, point& p) ;

friend int compare(const point& a, const point& b)
{ int r = compare(a.xcoord(),b.xcoord());
  return (r!=0) ? r : compare(a.ycoord(),b.ycoord());
 }


};

inline void Print(const point& p, ostream& out) { out << p; } 
inline void Read(point& p,  istream& in)        { in >> p; }

LEDA_HANDLE_TYPE(point)



// geometric primitives


inline bool right_turn(const point& a, const point& b, const point& c)
{ return (a.ycoord()-b.ycoord()) * (a.xcoord()-c.xcoord())
          + (b.xcoord()-a.xcoord()) * (a.ycoord()-c.ycoord()) > 0;
 }

inline bool left_turn(const point& a, const point& b, const point& c)
{ return (a.ycoord()-b.ycoord()) * (a.xcoord()-c.xcoord())
          + (b.xcoord()-a.xcoord()) * (a.ycoord()-c.ycoord()) < 0;
 }



#endif

