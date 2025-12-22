/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  matrix.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_MATRIX_H
#define LEDA_MATRIX_H

//------------------------------------------------------------------------------
//  matrices
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
#include <LEDA/vector.h>


class matrix
{
  vector** v;
  int  d1;
  int  d2;

  void     flip_rows(int,int);
  void     check_dimensions(const matrix&) const; 
  double&  elem(int i, int j) const { return v[i]->v[j]; }
  double** triang(const matrix&, int&) const;
    
public:

  matrix(int=0, int=0);
  matrix(const matrix&);
  matrix(const vector&);
  matrix(int,int,double**);

  matrix& operator=(const matrix&);

 ~matrix();

  LEDA_MEMORY(matrix)


int     dim1()  const  {  return d1; }
int     dim2()  const  {  return d2; }

vector& row(int) const;
vector  col(int i) const;
matrix  trans() const;

matrix  inv()   const;
double  det()   const;

matrix solve(const matrix&) const;
vector solve(const vector& b) const { return vector(solve(matrix(b))); }

operator vector() const; 

int     operator==(const matrix&)    const;
int     operator!=(const matrix& x)  const { return !(*this == x); }

vector& operator[](int i)    const { return row(i); }

double& operator()(int,int);
double  operator()(int,int) const;

matrix operator+(const matrix&);
matrix operator-(const matrix&);
matrix operator-(); // unary

matrix& operator-=(const matrix&);
matrix& operator+=(const matrix&);

matrix operator*(double);
matrix operator*(const matrix&);
vector operator*(const vector& v) { return vector(*this * matrix(v)); }

friend ostream& operator<<(ostream&, const matrix&);
friend istream& operator>>(istream&, matrix&);

};

inline void Print(const matrix& m, ostream& out=cout) { out << m; }
inline void Read(matrix& m, istream& in=cin)          { in >> m;  }

inline int compare(const matrix&, const matrix&) 
{ error_handler(1,"compare not defined for type `matrix`"); 
  return 0;
 }


LEDA_TYPE_PARAMETER(matrix)

#endif
