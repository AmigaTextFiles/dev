/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  circle.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_CIRCLE_H
#define LEDA_CIRCLE_H

#include <LEDA/point.h>
#include <LEDA/segment.h>
#include <LEDA/line.h>

//------------------------------------------------------------------------------
// circles
//------------------------------------------------------------------------------


class circle_rep : public handle_rep {

friend class circle;

  double  radius;
  point   center; 
  
public:

  circle_rep() {}
  circle_rep(const point& p, double r)  { center = p; radius = r; }

 ~circle_rep() {}

  LEDA_MEMORY(circle_rep)
  
};


class circle   : public handle_base 
{

circle_rep* ptr() const { return (circle_rep*)PTR; }

public:

 circle();
 circle(const point& c, double r);
 circle(double x, double y, double r);
 circle(const circle& c) : handle_base(c) {}

~circle()                { clear(); }

circle& operator=(const circle& C) { handle_base::operator=(C); return *this; }



int operator==(const circle&) const;

int operator!=(const circle& c) const { return !operator==(c); };

point center()  const { return ptr()->center; } 
double radius() const { return ptr()->radius; }

double  distance(const point&) const;
double  distance(const line&) const;
double  distance(const circle&) const;

bool    inside(const point&) const;
bool    outside(const point& p) const { return !inside(p); };

segment left_tangent(const point&) const;
segment right_tangent(const point&) const;

circle  translate(double,double) const;
circle  translate(const vector&) const; 
circle  operator+(const vector& v) const { return translate(v); }

circle  rotate(const point&, double) const;
circle  rotate(double) const;

list<point> intersection(const circle&) const;
list<point> intersection(const line&) const;
list<point> intersection(const segment&) const;

friend ostream& operator<<(ostream& out, const circle& c);
friend istream& operator>>(istream& in, circle& c);  

};

inline void Print(const circle& c, ostream& out) { out << c; } 
inline void Read(circle& c,  istream& in)        { in >> c; }

LEDA_HANDLE_TYPE(circle)



#endif
