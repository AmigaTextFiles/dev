/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  line.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_LINE_H
#define LEDA_LINE_H

#include <LEDA/point.h>
#include <LEDA/segment.h>

//------------------------------------------------------------------------------
// straight lines
//------------------------------------------------------------------------------

class line_rep : public handle_rep {

friend line;

  segment  seg; 

public:
   
  line_rep() {}
  line_rep(const segment& s)  { seg = s; }

 ~line_rep() {}

  LEDA_MEMORY(line_rep)
   
};
   

class line   : public handle_base 
{

line_rep* ptr() const { return (line_rep*)PTR; }

public:

 line();
 line(const segment&);
 line(const point&, const point&);
 line(const point&, double);
 line(const line& l) : handle_base(l) {};

~line() { clear(); }

line& operator=(const line& l) { handle_base::operator=(l); return *this; }


bool intersection(const line& l, point& inter) const;
bool intersection(const segment& s, point& inter) const;

bool vertical() const    { return ptr()->seg.vertical();  }
bool horizontal() const  { return ptr()->seg.horizontal();}
double distance() const  { return ptr()->seg.distance();  }
double distance(point p) const { return ptr()->seg.distance(p); }
double angle(const line& l) const { return ptr()->seg.angle(l.ptr()->seg); }
double angle() const     { return ptr()->seg.angle();     }
double direction() const { return angle(); }
double slope() const     { return ptr()->seg.slope();     }
segment seg()  const     { return ptr()->seg; }

segment perpendicular(const point& q) const;

line translate(double alpha, double d) const 
{ return ptr()->seg.translate(alpha,d); }

line translate(const vector& v)  const 
{ return ptr()->seg.translate(v); }

line rotate(const point& o, double alpha) const
{ return ptr()->seg.rotate(o,alpha); }

line rotate(double alpha) const  
{ return rotate(point(0,0),alpha);}

double y_proj(double x) const  { return ptr()->seg.y_proj(x); };
double x_proj(double y) const  { return ptr()->seg.x_proj(y); };
double y_abs() const { return ptr()->seg.y_proj(0); }

bool contains(const point&) const;
bool contains(const segment&) const;

line operator+(const vector& v) const { return translate(v); }

int operator==(const line& l) const { return contains(l.ptr()->seg); }
int operator!=(const line& l) const { return !contains(l.ptr()->seg); };

friend ostream& operator<<(ostream& out, const line& l);
friend istream& operator>>(istream& in, line& l);  

};


inline void Print(const line& l, ostream& out) { out << l; } 
inline void Read(line& l, istream& in)         { in >> l; }

LEDA_HANDLE_TYPE(line)



#endif
