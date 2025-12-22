/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _rational.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/basic.h>
#include <LEDA/rational.h>
#include <math.h>
#include <ctype.h>



// hidden functions

LedaRational& LedaRational::normalize()
// divide numerator and denominator by their greatest common divisor
  { // den is assumed to be nonzero and positive
    if (num == den) { num = den = 1; return (*this); }
    if (-num == den) { num = -1; den = 1; return (*this); }
    Int ggt = bgcd(num, den);
    if (!Ieq1(ggt)) {
      num /= ggt;
      den /= ggt;
    };
    return (*this);
  };



// Constructors

LedaRational::LedaRational(double x)
// from the GNU-C++ library (MACHINE-DEPENDENT)
  { num = 0; den = 1;

    if (x != 0.0)
    { int neg = (x < 0);
      if (neg) x = -x;

      const unsigned shift = 15;     // a safe shift per step
      const double width = 32768;    // = 2^shift
      const int maxiter = 20;        // ought not be necessary, but just in case,
                                     // max 300 bits of precision
      int expt;
      double mantissa = frexp(x, &expt);
      long exponent = expt;
      double intpart;
      int k = 0;
      while (mantissa != 0.0 && k++ < maxiter) {
        mantissa *= width; // shift double mantissa
        mantissa = modf(mantissa, &intpart);
        num <<= shift;
        num += (long)intpart;
        exponent -= shift;
      }
      if (exponent > 0)
        num <<= (unsigned)exponent;
      else if (exponent < 0)
        den <<= (unsigned)(-exponent);
      if (neg)
        num.negate();
    } // if (x != 0) then
    (*this).normalize();
  };


LedaRational::LedaRational(int n, int d)
  { if (d == 0) {
      error_handler(1,"Zero denominator!");
    }
    else {
      num = Int(n);
      den = Int(d);
      if (d < 0) {
        num.negate();
        den.negate();
      }
      (*this).normalize();
    }
  };


LedaRational::LedaRational(const Int& n, const Int& d)
  { if (Ieq0(d)) {
      // d == 0
      error_handler(1,"Zero denominator!");
    }
    else {
      num = n;
      den = d;
      if (Ilt0(d)) {
        // d < 0
        num.negate();
        den.negate();
      }
      (*this).normalize();
    }
  };



// Arithmetic Operators

LedaRational& LedaRational::operator+= (const LedaRational& r)
  { num = num * r.den + r.num * den;
    den *= r.den;
    return (*this).normalize();
  };

LedaRational& LedaRational::operator-= (const LedaRational& r)
  { num = num * r.den - r.num * den;
    den *= r.den;
    return (*this).normalize();
  };

LedaRational& LedaRational::operator*= (const LedaRational& r)
  { num *= r.num;
    den *= r.den;
    return (*this).normalize();
  };

LedaRational& LedaRational::operator/= (const LedaRational& r)
  { if (Ieq0(r.num)) {
      // r == 0
      error_handler(1,"Division by 0!");
    }
    else {
      // r.num != 0
      num *= r.den;
      den *= r.num;
      if (Ilt0(den)) {
        num.negate();
        den.negate();
      }
    }
    return (*this).normalize();
  };



// Assignment Operator

LedaRational& LedaRational::operator= (const LedaRational& r)
  { if (this == &r) return *this; // to handle r = r correctly
    num = r.num;
    den = r.den;
    return *this;
  };




// some useful member-functions

void LedaRational::invert()
  { if (Ieq0(num)) {
      error_handler(1,"Zero denominator!");
    }
    else {
      Int tmp = num;
      num = den;
      den = tmp;
      if (Ilt0(den)) {
        num.negate();
        den.negate();
      }
    }
  };

LedaRational LedaRational::inverse()
  { if (Ieq0(num)) {
      error_handler(1,"Zero denominator!");
      return (*this);
    }
    else {
      LedaRational tmp(den,num);
      if (Ilt0(num)) {
        (tmp.num).negate();
        (tmp.den).negate();
      }
      return tmp;
    }
  };



// friend functions

int compare(const LedaRational& x, int y)
  { int
      xsign = sign(x.num),
      ysign;
    if (y == 0) ysign = 0;
    else ysign = (y > 0) ? 1 : -1;
    if (xsign == 0) { return -ysign; }
    if (ysign == 0) { return xsign; }
    // now (x != 0) && (y != 0)
    int
      diff = xsign - ysign;
    if (diff == 0) {
      Int
        leftop = x.num,
        rightop = Int(y) * x.den;
      if (leftop < rightop) { return -1; }
      else { return (leftop > rightop); }
    }
    else return diff;
  };


int compare(int x, const LedaRational& y)
  { int
      ysign = sign(y.num),
      xsign;
    if (x == 0) xsign = 0;
    else xsign = (x > 0) ? 1 : -1;
    if (xsign == 0) { return -ysign; }
    if (ysign == 0) { return xsign; }
    // now (x != 0) && (y != 0)
    int
      diff = xsign - ysign;
    if (diff == 0) {
      Int
        leftop = Int(x) * y.den,
        rightop = y.num;
      if (leftop < rightop) { return -1; }
      else { return (leftop > rightop); }
    }
    else return diff;
  };


// other useful friend functions

LedaRational pow(const LedaRational& r, int l)
// no need to normalize since num and den are relatively prime
  { LedaRational mul(r), result(1,1);
    if (l < 0) {
      mul = mul.inverse();
      l = -l;
    }
    for (int i = 1; i <= l; i++) {
      result.num *= mul.num;
      result.den *= mul.den;
    }
    return result;
  };

LedaRational pow(const LedaRational& r, Int I)
// no need to normalize since num and den are relatively prime
  { LedaRational mul(r), result(1,1);
    if (Ilt0(I)) {
      mul = mul.inverse();
      I.negate();
    }
    for (Int i = 1; i < I; i++) {
      result.num *= mul.num;
      result.den *= mul.den;
    }
    return result;
  };

LedaRational::operator double() const
  { Int
      numvar = num,
      denvar = den;

    if (numvar == Int(0)) { return 0; }
    
    const Int MDP = 1000000;    // my_double_precision
    long s = 0;
    Int quot = (numvar / denvar); // integer quotient

    while (abs(quot) < MDP) {
      numvar *= 10;
      s++;
      quot = (numvar / denvar);
    }
    // |quot| > MDP
    // num_new == 10^s * num_old

    while (abs(quot) > MDP) {
      quot /= 10;
      s--;
    }
    // MDP/10 < |quot| < MDP
    // num_old/den_old == quot * 10^{-s}

    double result = (double)longasI(quot);
    // transform Int into double via long

    if (s >= 0) {
      for (int i = 0; i < s; i++) { result /= 10; };
    }
    else {
      for (int i = 0; i > s; i--) { result *= 10; };
    }
    return result;
  }; 

Int floor(const LedaRational& r)
  { Int x, y;
    Idiv (x, y, r.num, r.den);
    if ((Ilt0(r.num)) && (!Ieq0(y))) x--;
    return x;
  };

Int ceil(const LedaRational& r)
  { Int x, y;
    Idiv (x, y, r.num, r.den);
    if ((Ige0(r.num)) && (!Ieq0(y))) x++;
    return x;
  };

Int round(const LedaRational& r)
  { Int rem, quot;
    Idiv(quot, rem, r.num, r.den);
    rem <<= 1;
    if (rem >= r.den) {
      if (sign(r.num) >= 0) { quot++; }
      else { quot--; }
    }
    return quot;
  }

istream& operator>> (istream& in, LedaRational& r)
  { // Format: "r.num / r.den"
    Int rx, ry;
    char c;
    do in.get(c); while (isspace(c));
    in.putback(c);

    in >> rx;
   
    do in.get(c); while (isspace(c));
    if (c != '/') { error_handler(1,"/ expected"); }

    do in.get(c); while (isspace(c));
    in.putback(c);
   
    in >> ry;
    r = LedaRational(rx,ry);
    // to guarantee the value is normalized, denominator is nonzero ...
    return in;
  };
