/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  Float.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/basic.h>
#include <LEDA/Int.h>
#include <math.h>

const double eps0 = ldexp(1,-53);  // 2^-53


enum { ZERO = 0, NON_ZERO = 1, NO_IDEA = 2 };


class Float {

  double num;
  double mes;

public:

Float(Int i) 
{ if (i == 0) 
     { num = 0; 
       mes = 0; 
      }
  else 
     { num = Itodouble(i);
       int exp = 1 + lg(i); //Ilog(abs(i) - 1);
       mes = ldexp(1, exp );
      }
}

Float(double d, double m) { num = d; mes = m; }

Float() { num = 0; mes = 0; }


operator double() const { return num; }


friend Float operator+(const Float& a, const Float& b)
{ return Float(a.num + b.num, 2*((a.mes > b.mes) ? a.mes : b.mes)); }

friend Float operator-(const Float& a, const Float& b)
{ return Float(a.num - b.num, 2*((a.mes > b.mes) ? a.mes : b.mes)); }

friend Float operator*(const Float& a, const Float& b)
{ return Float(a.num * b.num, a.mes * b.mes); }


friend int Non_Zero(const Float& f, float i)
{ double eps =  i * f.mes * eps0;

  if (fabs(f.num) > eps)
     return NON_ZERO;
  else
     if (eps < 1)
        return ZERO;
     else
        return NO_IDEA;
 }
 
friend int Sign(const Float& f)        { return (f.num > 0) ? 1 : -1; }
friend double Lmax(const Float& f)     { return f.mes; }
friend double Eps(const Float& f, int i ) { return i * f.mes * eps0; }


};

inline int Sign(const Int& x)        { return sign(x); }
inline double Lmax(const Int& x)     { return 0; }
inline double Eps(const Int& x, int) { return 0; }
inline bool Non_Zero(const Int& x, float=0) 
{ return (Sign(x) != 0) ? NON_ZERO : ZERO; }


inline int Sign(double x)
{ if (x==0) return 0;
  return ( x>0 ? 1 : -1);
 }
inline double Lmax(double)   { return 0; }
inline double Eps(double)    { return 0; }
inline bool Non_Zero(double x, float=0) { return (x != 0) ? NON_ZERO : ZERO; }
