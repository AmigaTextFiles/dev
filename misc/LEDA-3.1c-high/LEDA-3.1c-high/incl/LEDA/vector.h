/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  vector.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_VECTOR_H
#define LEDA_VECTOR_H

//------------------------------------------------------------------------------
//  vectors
//------------------------------------------------------------------------------


#include <LEDA/basic.h>


class vector
{
  friend class matrix;

  double* v;
  int d;

  void check_dimensions(const vector&) const;
 
public:

  vector(int=0); 
  vector(double, double);
  vector(double, double, double);
  vector(const vector&);
 ~vector(); 

  double length() const;
  
  int    dim()    const { return d; }
  vector norm()   const { return *this/length(); }
  
  double angle(const vector&) const; 
  
  vector& operator=(const vector&);
  
  double& operator[](int);
  
  double  operator[](int) const;

  vector& operator+=(const vector&);
  vector& operator-=(const vector&);
  
  vector  operator+(const vector&) const;
  vector  operator-(const vector&) const;
  double  operator*(const vector&) const;
  vector  operator-() const;
  vector  operator*(double)        const;
  vector  operator/(double)        const;
  
  int     operator==(const vector&) const;
  int     operator!=(const vector& w)  const { return !(*this == w); }
  
  /*
  friend vector operator*(double f, const vector& v);
  friend vector operator/(const vector& v, double f);
  */
  
  
  friend ostream& operator<<(ostream& o, const vector& v);
  friend istream& operator>>(istream& i, vector& v);

  friend int  compare(const vector&, const vector&);
 
  LEDA_MEMORY(vector)

};

inline void Print(const vector& v, ostream& out=cout) { out << v; }
inline void Read(vector& v, istream& in=cin)          { in >> v;  }

LEDA_TYPE_PARAMETER(vector)

#endif
