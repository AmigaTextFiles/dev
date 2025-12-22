/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  segment.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SEGMENT_H
#define LEDA_SEGMENT_H

#include <LEDA/point.h>

//------------------------------------------------------------------------------
// segments
//------------------------------------------------------------------------------


class segment_rep : public handle_rep {

friend class segment;
friend class line;
friend class circle;
   
   point start;
   point end;

   double slope;
   double y_abs;
   double angle;

public:
   
   segment_rep(const point&, const point&);
   segment_rep();  

  ~segment_rep() {}

   
   LEDA_MEMORY(segment_rep)
   
};


class segment  : public handle_base 
{

friend class line;
friend class circle;

segment_rep* ptr() const { return (segment_rep*)PTR; }

public:

 segment();                 
 segment(const point&, const point&); 
 segment(double, double, double, double) ;
 segment(const point&, double dir, double length);
 segment(const segment& s) : handle_base(s) {}     
~segment()                { clear(); }

segment& operator=(const segment& s) { handle_base::operator=(s); return *this;}

operator vector()  { return vector(xcoord2()-xcoord1(), ycoord2()-ycoord1()); }

bool intersection(const segment& s, point& inter) const;

point start()  const      { return ptr()->start; }
point end()    const      { return ptr()->end; }

double xcoord1() const    { return ptr()->start.ptr()->x; }
double xcoord2() const    { return ptr()->end.ptr()->x;   }
double ycoord1() const    { return ptr()->start.ptr()->y; }
double ycoord2() const    { return ptr()->end.ptr()->y;   }

double slope() const { return ptr()->slope; }
double y_abs() const { return ptr()->y_abs; }

double angle()     const { return ptr()->angle; }
double direction() const { return angle(); }

bool vertical()   const { return xcoord1() == xcoord2(); }
bool horizontal() const { return ycoord1() == ycoord2(); }
 
double length() const { return start().distance(end()); }

segment translate(double,double) const;
segment translate(const vector&) const;

double  angle(const segment&) const;

double  distance(const segment&) const;
double  distance(const point&) const;
double  distance() const;
double  x_proj(double) const;
double  y_proj(double) const;

double operator()(double x) { return y_proj(x); }

segment rotate(const point&,double) const;
segment rotate(double) const;

bool  right()  const     { return ptr()->start.ptr()->x < ptr()->end.ptr()->x; }
bool  left()   const     { return ptr()->start.ptr()->x > ptr()->end.ptr()->x; }
bool  up()     const     { return ptr()->start.ptr()->y < ptr()->end.ptr()->y; }
bool  down()   const     { return ptr()->start.ptr()->y > ptr()->end.ptr()->y; }

segment operator+(const vector& v) const { return translate(v); }

int operator==(const segment& s) const
{ return (ptr()->start == s.ptr()->start && ptr()->end == s.ptr()->end); }

int operator!=(const segment& s) const { return !operator==(s);}

friend ostream& operator<<(ostream& out, const segment& s);
friend istream& operator>>(istream& in, segment& s);

};

inline void Print(const segment& s, ostream& out) { out << s; } 
inline void Read(segment& s,  istream& in)        { in >> s; }

LEDA_HANDLE_TYPE(segment)


#endif
