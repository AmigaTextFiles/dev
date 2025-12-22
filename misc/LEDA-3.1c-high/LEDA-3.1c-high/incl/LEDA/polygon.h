/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  polygon.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_POLYGON_H
#define LEDA_POLYGON_H

#include <LEDA/point.h>
#include <LEDA/segment.h>
#include <LEDA/line.h>

//------------------------------------------------------------------------------
// polygons
//------------------------------------------------------------------------------



class polygon_rep : public handle_rep {

friend class polygon;

  list<segment> seg_list;

public:

  polygon_rep() { }
  polygon_rep(const list<segment>& L) { seg_list = L; }

 ~polygon_rep() {}
   
  LEDA_MEMORY(polygon_rep)
   
};


class list_polygon_;


class polygon   : public handle_base 
{

polygon_rep* ptr() const { return (polygon_rep*)PTR; }

bool check();

public:

 polygon();
 polygon(const list<point>&, bool=true);

 polygon(const polygon& P) : handle_base(P) {}

~polygon()                { clear(); }

polygon& operator=(const polygon& P) { handle_base::operator=(P); return *this;}


list<point>   vertices() const;  
list<segment> segments() const { return ptr()->seg_list; }

bool          inside  (const point& p) const;  
bool          outside (const point& p) const; 

list<point>   intersection(const segment& s) const;
list<point>   intersection(const line& l) const;  
list_polygon_ intersection(const polygon& P) const;

polygon       translate(double, double) const;
polygon       translate(const vector&) const;

polygon       rotate(const point&, double) const;
polygon       rotate(double) const;

int         size()   const  { return ptr()->seg_list.size(); }
bool        empty()  const  { return ptr()->seg_list.empty(); }

polygon operator+(const vector& v) const { return translate(v); }

friend ostream& operator<<(ostream& out, const polygon& p);
friend istream& operator>>(istream& in,  polygon& p);

};

inline void Print(const polygon& P, ostream& out) { out << P; } 
inline void Read(polygon& P, istream& in)         { in  >> P; }

LEDA_HANDLE_TYPE(polygon)


struct list_polygon_: public list<polygon>
{
  list_polygon_(const list<polygon>& L) : list<polygon>(L) {}
};


#endif 
