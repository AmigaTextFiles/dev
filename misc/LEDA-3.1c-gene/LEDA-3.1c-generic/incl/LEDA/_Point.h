/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  Point.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_POINTEXACT_H
#define LEDA_POINTEXACT_H

#include <LEDA/Int.h>

class Point;
class Segment;


//------------------------------------------------------------------------------
// Points
//------------------------------------------------------------------------------

class Point_rep  : public handle_rep {

friend class Point;
friend class Segment;
   
   Int x;
   Int y;
   Int w;

public:
    
   Point_rep();     
   Point_rep(Int a, Int b);
   Point_rep(Int a, Int b, Int c);

  ~Point_rep() {}
   
   
   LEDA_MEMORY(Point_rep)
   
};


class Point  : public handle_base 
{

friend class Segment;
friend class Line;
friend class Circle;


Point_rep* ptr() const { return (Point_rep*)PTR; }   //does type casting

public:

 Point();
 Point(Int, Int);
 Point(Int, Int, Int);
// Point(vector);
 Point(const Point& p) : handle_base(p) {}  //increase reference counter by one
~Point()                  { clear(); }

Point& operator=(const Point& p) { handle_base::operator=(p); return *this; }


//operator vector()         { return vector(ptr()->x,ptr()->y); }

double xcoord() const { return Itodouble(ptr()->x)/Itodouble(ptr()->w);}
double ycoord() const { return Itodouble(ptr()->y)/Itodouble(ptr()->w);}

#if defined(__GNUG__)
Int X() const { return ptr()->x; }
Int Y() const { return ptr()->y; }
Int W() const { return ptr()->w; }
#else
const Int& X() const { return ptr()->x; }
const Int& Y() const { return ptr()->y; }
const Int& W() const { return ptr()->w; }
#endif

double XD() const { return Itodouble(ptr()->x); }
double YD() const { return Itodouble(ptr()->y); }
double WD() const { return Itodouble(ptr()->w); }

//double  angle(const Point&, const Point&) const;

//double  distance(const Point&) const;
//double  distance() const;

//Point   translate(double,double) const;
//Point   translate(const vector&) const;

//Point   rotate(const Point&,double) const;
//Point   rotate(double) const;


//Point operator+(const vector& v) const { return translate(v); }

int operator==(const Point&) const;

int operator!=(const Point& p)  const { return !operator==(p);}

friend ostream& operator<<(ostream& out, const Point& p) ;
friend istream& operator>>(istream& in, Point& p) ;

friend void Print(const Point&, ostream& = cout);
friend void Read(Point&,  istream& = cin);

/*
friend int compare(const Point& a, const Point& b)
{ Int d = a.X() * b.W() - b.X() * a.W();
  if (sign(d) == 0) d = a.Y() * b.W()- b.Y() * a.W();
  return sign(d);
}
*/

};

inline void Print(const Point& p, ostream& out) { out << p; } 
inline void Read(Point& p,  istream& in)        { in >> p; }

LEDA_HANDLE_TYPE(Point)

#endif

