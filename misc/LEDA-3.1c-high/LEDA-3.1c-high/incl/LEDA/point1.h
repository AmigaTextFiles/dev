/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  point1.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_POINT1_H
#define LEDA_POINT1_H

#include <LEDA/list.h>
#include <LEDA/vector.h>

class point1 {

friend class line;
friend class circle;
   
   double x;
   double y;

public:
    
   point1(double a=0, double b=0) { x = a; y = b; }
   point1(vector v) { x = v[0]; y = v[1]; }
   

 LEDA_MEMORY(point1)

operator vector()         { return vector(x,y); }

double  xcoord()  const   { return x; }
double  ycoord()  const   { return y; }

double  angle(const point1&, const point1&) const;

double  distance(const point1&) const;
double  distance() const;

point1   translate(double,double) const;
point1   translate(const vector&) const;

point1   rotate(const point1&,double) const;
point1   rotate(double) const;


point1 operator+(const vector& v) const { return translate(v); }

int operator==(const point1&) const;

int operator!=(const point1& p)  const { return !operator==(p);}

friend ostream& operator<<(ostream& out, const point1& p) ;
friend istream& operator>>(istream& in, point1& p) ;

friend int  compare(const point1&, const point1&);

};

inline void Print(const point1& p, ostream& out) { out << p; } 
inline void Read(point1& p,  istream& in)        { in >> p; }

LEDA_TYPE_PARAMETER(point1)


#endif

