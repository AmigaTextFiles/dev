/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  rational.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_RATIONAL_H
#define LEDA_RATIONAL_H

#include <LEDA/Int0.h>

class LedaRational;

typedef LedaRational rational;


class LedaRational
{

protected:
  Int num; // numerator
  Int den; // denominator, always nonzero and positive

  LedaRational& normalize();

public:
  LedaRational();
  LedaRational(double);
  LedaRational(int);
  LedaRational(int, int);
  LedaRational(const Int&);
  LedaRational(const Int&, const Int&);
  LedaRational(const LedaRational&);

  ~LedaRational();

  LedaRational& operator= (const LedaRational&);

  LedaRational& operator+= (const LedaRational&);
  LedaRational& operator-= (const LedaRational&);
  LedaRational& operator*= (const LedaRational&);
  LedaRational& operator/= (const LedaRational&);

  LedaRational& operator++ ();
  LedaRational& operator-- ();

  const Int& numerator() const;
  const Int& denominator() const;

  void negate(); // negate in place
  void invert(); // invert in place
  LedaRational inverse();  // returns the inverse



// friend functions, first arithmetic operators

  friend LedaRational operator+ (LedaRational, const LedaRational&);
  friend LedaRational operator- (LedaRational, const LedaRational&);
  friend LedaRational operator* (LedaRational, const LedaRational&);
  friend LedaRational operator/ (LedaRational, const LedaRational&);


// unary minus 

  friend LedaRational operator- (const LedaRational&);


// comparison operators

friend int compare(const LedaRational& x, const LedaRational& y)
  { int xsign = sign(x.num);
    int ysign = sign(y.num);
    if (xsign == 0) return -ysign;
    if (ysign == 0) return xsign;
    // now (x != 0) && (y != 0)
    int diff = xsign - ysign;
    if (diff == 0) 
    { Int leftop  = x.num * y.den;
      Int rightop = y.num * x.den;
      if (leftop < rightop) return -1;
      else return leftop > rightop;
     }
    else return diff;
  }

  friend int compare(const LedaRational&, int);
  friend int compare(int, const LedaRational&);

  friend bool operator== (const LedaRational&, const LedaRational&);
  friend bool operator== (const LedaRational&, int);
  friend bool operator== (int, const LedaRational&);
  friend bool operator!= (const LedaRational&, const LedaRational&);
  friend bool operator!= (const LedaRational&, int);
  friend bool operator!= (int, const LedaRational&);
  friend bool operator< (const LedaRational&, const LedaRational&);
  friend bool operator< (const LedaRational&, int);
  friend bool operator< (int, const LedaRational&);
  friend bool operator<= (const LedaRational&, const LedaRational&);
  friend bool operator<= (const LedaRational&, int);
  friend bool operator<= (int, const LedaRational&);
  friend bool operator> (const LedaRational&, const LedaRational&);
  friend bool operator> (const LedaRational&, int);
  friend bool operator> (int, const LedaRational&);
  friend bool operator>= (const LedaRational&, const LedaRational&);
  friend bool operator>= (const LedaRational&, int);
  friend bool operator>= (int, const LedaRational&);


// other friend functions

  friend int sign(const LedaRational&);
  friend LedaRational abs(const LedaRational&);
  friend LedaRational sqr(LedaRational);
  friend LedaRational pow(const LedaRational&, int); 
  friend LedaRational pow(const LedaRational&, Int); 
  friend Int trunc(const LedaRational&);
  friend Int floor(const LedaRational&);
  friend Int ceil(const LedaRational&);
  friend Int round(const LedaRational&);


// comparison functions

  friend bool LRge0(const LedaRational&);
  friend bool LRgt0(const LedaRational&);
  friend bool LRle0(const LedaRational&);
  friend bool LRlt0(const LedaRational&);
  friend bool LReq0(const LedaRational&);
  friend bool LReq1(const LedaRational&);


// conversion

  operator double () const; // LedaRational to double


// input/output

  friend istream& operator>> (istream&, LedaRational&);

  friend ostream& operator<< (ostream&, const LedaRational&);
};


  inline LedaRational::LedaRational()
    { num = 0; den = 1; };
  inline LedaRational::LedaRational(int n)
    { num = Int(n); den = 1; };
  inline LedaRational::LedaRational(const Int& i)
    { num = i; den = 1; };
  inline LedaRational::LedaRational(const LedaRational& r)
    { num = r.num; den = r.den; };

  inline LedaRational::~LedaRational()
    {};

  inline LedaRational& LedaRational::operator++ ()
    { num += den; return (*this).normalize(); };
  inline LedaRational& LedaRational::operator-- ()
    { num -= den; return (*this).normalize(); };

  inline const Int& LedaRational::numerator() const
    { return num; };
  inline const Int& LedaRational::denominator() const
    { return den; };


  inline void LedaRational::negate()
    { num.negate(); };

  inline LedaRational operator+ (LedaRational x, const LedaRational& y)
    { return x += y; };
  inline LedaRational operator- (LedaRational x, const LedaRational& y)
    { return x -= y; };
  inline LedaRational operator* (LedaRational x, const LedaRational& y)
    { return x *= y; };
  inline LedaRational operator/ (LedaRational x, const LedaRational& y)
    { return x /= y; };

  inline LedaRational operator- (const LedaRational& x)
    { return LedaRational(-x.num,x.den); };

  inline int sign(const LedaRational& r)
    { return sign(r.num); };
  inline LedaRational abs(const LedaRational& r)
    { if (Ige0(r.num)) { return r; } else { return -r; } };
  inline LedaRational sqr(LedaRational r)
  // no need to normalize since num and den are relatively prime
    { r.num *= r.num; r.den *= r.den; return r; };
  inline Int trunc(const LedaRational& r)
    { return (r.num / r.den); };

  inline bool LRge0(const LedaRational& r)
    { return (Ige0(r.num)); };
  inline bool LRgt0(const LedaRational& r)
    { return (Igt0(r.num)); };
  inline bool LRle0(const LedaRational& r)
    { return (Ile0(r.num)); };
  inline bool LRlt0(const LedaRational& r)
    { return (Ilt0(r.num)); };
  inline bool LReq0(const LedaRational& r)
    { return (Ieq0(r.num)); };
  inline bool LReq1(const LedaRational& r)
    { return (Ieq1(r.num)); };

  inline ostream& operator<< (ostream& s, const LedaRational& r)
    {  s << r.num << "/" << r.den; return s; };


  inline bool operator== (const LedaRational& x, const LedaRational& y)
    { return ((x.num == y.num) && (x.den == y.den)); };

  inline bool operator== (const LedaRational& x, int y)
    { return (Ieq1(x.den) && (x.num == Int(y))); };

  inline bool operator== (int x, const LedaRational& y)
    { return (Ieq1(y.den) && (y.num == Int(x))); };

  inline bool operator!= (const LedaRational& x, const LedaRational& y)
    { return ((x.num != y.num) || (x.den != y.den)); };

  inline bool operator!= (const LedaRational& x, int y)
    { return (!Ieq1(x.den) || (x.num != Int(y))); };

  inline bool operator!= (int x, const LedaRational& y)
    { return (!Ieq1(y.den) || (y.num != Int(x))); };

  inline bool operator< (const LedaRational& x, const LedaRational& y)
    { return compare(x,y) < 0; };

  inline bool operator< (const LedaRational& x, int y)
    { return compare(x,y) < 0; };

  inline bool operator< (int x,  const LedaRational& y)
    { return compare(x,y) < 0; };

  inline bool operator<= (const LedaRational& x, const LedaRational& y)
    { return compare(x,y) <= 0; };

  inline bool operator<= (const LedaRational& x, int y)
    { return compare(x,y) <= 0; };

  inline bool operator<= (int x, const LedaRational& y)
    { return compare(x,y) <= 0; };

  inline bool operator> (const LedaRational& x, const LedaRational& y)
    { return compare(x,y) > 0; };

  inline bool operator> (const LedaRational& x, int y)
    { return compare(x,y) > 0; };

  inline bool operator> (int x, const LedaRational& y)
    { return compare(x,y) > 0; };

  inline bool operator>= (const LedaRational& x, const LedaRational& y)
    { return compare(x,y) >= 0; };

  inline bool operator>= (const LedaRational& x, int y)
    { return compare(x,y) >= 0; };

  inline bool operator>= (int x, const LedaRational& y)
    { return compare(x,y) >= 0; };

#endif
