/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  Int0.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/* 		Int.h			 */

/**************************************************************************
	Headerfile for Int arithmetic in C++,

	RD, IWR Uni Heidelberg, 30.11.90

16.12.91, RD	Redesigned the class Int to enable all operations between
		Int and any of char, short, int, long or these unsigned.
		To convert from Int to int, unsigned int ... the
		functions Iisint, Iisuint, ... and intasI, uintasI, ...
		are provided. All PLACE operators were removed.

june/juli 93    some changes for LEDA by S. Meiser & S. Naeher

*****************************************************************************/


#ifndef _INT_H
#define _INT_H

#include <LEDA/basic.h>
#include <LEDA/impl/iint.h>

class Int {
	Integer	I;
public:
	Int();
	Int(int);
	Int(unsigned int);
	Int(long);
	Int(unsigned long);
	Int(const Int&);
	~Int();

	Int& operator=(const Int&);
	int operator=(int);
	
	friend BOOLEAN Iisint(const Int&);
	friend BOOLEAN Iisuint(const Int&);
	friend BOOLEAN Iislong(const Int&);
	friend BOOLEAN Iisulong(const Int&);
	friend int intasI(const Int&);
	friend unsigned int uintasI(const Int&);
	friend long longasI(const Int&);
	friend unsigned long ulongasI(const Int&);
	friend double Itodouble(const Int&);

	friend int Ilog(const Int&);

	friend Int operator+(const Int&, const Int&);
	friend Int operator-(const Int&, const Int&);
	Int& operator+=(const Int&);
	Int& operator-=(const Int&);
	Int& operator++();
	Int& operator--();

	/* Ergaenzung 07.05.92 SD */
	friend Int operator-(const Int&);
        
        void negate();

	BOOLEAN operator!();
	friend BOOLEAN operator==(const Int&, const Int&);
	friend BOOLEAN operator>(const Int&, const Int&);
	friend BOOLEAN operator!=(const Int&, const Int&);
	friend BOOLEAN operator>=(const Int&, const Int&);
	friend BOOLEAN operator<(const Int&, const Int&);
	friend BOOLEAN operator<=(const Int&, const Int&);
	friend Int operator*(const Int&, const Int&);
	Int& operator*=(const Int&);
	friend Int operator>>(const Int&, unsigned int);
	friend Int operator<<(const Int&, unsigned int);
	Int& operator>>=(unsigned int);
	Int& operator<<=(unsigned int);
	friend BOOLEAN Isr1(Int&);
	friend BOOLEAN Ieven(const Int&);

	friend BOOLEAN Ige0(const Int&);
	friend BOOLEAN Igt0(const Int&);
	friend BOOLEAN Ile0(const Int&);
	friend BOOLEAN Ilt0(const Int&);
	friend BOOLEAN Ieq0(const Int&);
	friend BOOLEAN Ieq1(const Int&);
	friend int sign(const Int&); // returns +1, 0, -1
	friend Int abs(const Int&);

	friend void Idiv(Int&, Int&, const Int&, const Int&);
	friend void uIdiv(Int&, Int&, const Int&, const Int&);
	friend Int operator/(const Int&, const Int&);
	Int& operator/=(const Int&);
	friend Int operator%(const Int&, const Int&);
	Int& operator%=(const Int&);

	friend int fscanI(FILE*, Int&);
	friend int fprintI(FILE*, const Int&);

	friend int Itoa(const Int&, char*);
	friend int atoI(char*, Int&);

	friend Int gcd(const Int&, const Int&);		// "bester gcd" 
	friend Int bgcd(const Int&, const Int&);	// binaerer gcd
	friend Int dgcd(const Int&, const Int&);	// naiver gcd
	friend Int elba(Int&, Int&, const Int&, const Int&);
	friend Int belba(Int&, Int&, const Int&, const Int&);

	friend Int random(const Int&); // Zufallsgenerator

};

inline Int::Int()			{ cI(&I); }
inline Int::Int(int i)			{ cIasint(&I, i); }
inline Int::Int(unsigned int i)		{ cIasuint(&I, i); }
inline Int::Int(long i)			{ cIaslong(&I, i); }
inline Int::Int(unsigned long i)	{ cIasulong(&I, i); }
inline Int::Int(const Int &a)		{ cIasI(&I, &a.I); }
inline Int::~Int()			{ dI(&I); }

inline Int& Int::operator=(const Int &a)
  { IasI(&I, &a.I); return *this; }
inline int Int::operator=(int i)
  { Iasint(&I, i); return i; }
	
inline BOOLEAN Iisint(const Int &a)
  { return Iisint(&a.I); }
inline BOOLEAN Iisuint(const Int &a)
  { return Iisuint(&a.I); }
inline BOOLEAN Iislong(const Int &a)
  { return Iislong(&a.I); }
inline BOOLEAN Iisulong(const Int &a)
  { return Iisulong(&a.I); }
inline int intasI(const Int &a)
  { return intasI(&a.I); }
inline unsigned int uintasI(const Int &a)
  { return uintasI(&a.I); }
inline long longasI(const Int &a)
  { return longasI(&a.I); }
inline unsigned long ulongasI(const Int &a)
  { return ulongasI(&a.I); }
inline double Itodouble(const Int &a)
  { return Itodouble(&a.I); }

inline Int& Int::operator+=(const Int& a)
  { IplasI(&I, &a.I); return *this; }
inline Int& Int::operator-=(const Int &a)
  { ImiasI(&I, &a.I); return *this; }
inline Int& Int::operator++()
  { Iinc(&I); return *this; }
inline Int& Int::operator--()
  { Idec(&I); return *this; }

inline Int operator-(const Int &a)
  { Int b(a); Ineg(&b.I); return b; }

inline void Int::negate()
  { Ineg(&I); }

inline BOOLEAN Int::operator!()
  { return Ieq0(&I); }
inline BOOLEAN operator==(const Int &a, const Int &b) 
  { return IeqI(&a.I, &b.I); }
inline BOOLEAN operator>(const Int &a, const Int &b) 
  { return IgtI(&a.I, &b.I); }
inline BOOLEAN operator!=(const Int &a, const Int &b) 
  { return IneI(&a.I, &b.I); }
inline BOOLEAN operator>=(const Int &a, const Int &b) 
  { return IgeI(&a.I, &b.I); }
inline BOOLEAN operator<(const Int &a, const Int &b) 
  { return IltI(&a.I, &b.I); }
inline BOOLEAN operator<=(const Int &a, const Int &b) 
  { return IleI(&a.I, &b.I); }
inline Int& Int::operator*=(const Int &a)
  { ImuasI(&I, &a.I); return *this; }
inline Int& Int::operator>>=(unsigned int u)
  { Israsint(&I, u); return *this; }
inline Int& Int::operator<<=(unsigned int u)
  { Islasint(&I, u); return *this; }
inline BOOLEAN Isr1(Int &a)
  { return Isr1(&a.I); }
inline BOOLEAN Ieven(const Int &a) 
  { return Ieven(&a.I); }

inline BOOLEAN Ige0(const Int &a)
  { return Ige0(&a.I); }
inline BOOLEAN Igt0(const Int &a)
  { return Igt0(&a.I); }
inline BOOLEAN Ile0(const Int &a)
  { return Ile0(&a.I); }
inline BOOLEAN Ilt0(const Int &a)
  { return Ilt0(&a.I); }
inline BOOLEAN Ieq0(const Int &a)
  { return Ieq0(&a.I); }
inline BOOLEAN Ieq1(const Int &a)
  { return Ieq1(&a.I); }
inline int sign(const Int &a)
  { return sign(&a.I); } // returns +1, 0, -1
inline Int abs(const Int &a)
  { if (Ige0(&a.I)) { return a; } else { return -a; } }

inline void Idiv(Int &q, Int &r, const Int &a, const Int &b)
  { Idiv(&q.I, &r.I, &a.I, &b.I); }
inline void uIdiv(Int &q, Int &r, const Int &a, const Int &b)
  { uIdiv(&q.I, &r.I, &a.I, &b.I); }
inline Int& Int::operator/=(const Int &a)
  { IdiasI(&I, &a.I); return *this; }
inline Int& Int::operator%=(const Int &a)
  { IreasI(&I, &a.I); return *this; }

inline int Ilog(const Int &a)	
	{ return Ilog(&a.I); }
	
inline Int operator+(const Int &a, const Int &b)
	{ Int c; IasIplI(&c.I, &a.I, &b.I); return c; }
inline Int operator-(const Int &a, const Int &b)
	{ Int c; IasImiI(&c.I, &a.I, &b.I); return c; }

inline Int operator*(const Int &a, const Int &b)
	{ Int c; IasImuI(&c.I, &a.I, &b.I); return c; }

inline Int operator>>(const Int &a, unsigned int u)
	{ Int c; IasIsrint(&c.I, &a.I, u); return c; }
inline Int operator<<(const Int &a, unsigned int u)
	{ Int c; IasIslint(&c.I, &a.I, u); return c; }

inline Int operator/(const Int &a, const Int &b)
	{ Int c; IasIdiI(&c.I, &a.I, &b.I); return c; }
inline Int operator%(const Int &a, const Int &b)
	{ Int c; IasIreI(&c.I, &a.I, &b.I); return c; }

inline int fscanI(FILE * f, Int &a)
	{ return fscanI(f, &a.I); }
inline int fprintI(FILE * f, const Int &a)
	{ return fprintI(f, &a.I); }

inline int Itoa(const Int &a, char s[])
	{ return Itoa(&a.I, s); }
inline int atoI(char s[], Int &a)
	{ return atoI(s, &a.I); }

inline Int gcd(const Int &a, const Int &b)
	{ Int d; Igcd(&d.I, &a.I, &b.I); return d; }
inline Int bgcd(const Int &a, const Int &b)
	{ Int d; Ibgcd(&d.I, &a.I, &b.I); return d; }
inline Int dgcd(const Int &a, const Int &b)
	{ Int d; Idgcd(&d.I, &a.I, &b.I); return d; }
inline Int elba(Int &u, Int &v, const Int &a, const Int &b)
	{ Int d; Ielba(&d.I, &u.I, &v.I, &a.I, &b.I); return d; }
inline Int belba(Int &u, Int &v, const Int &a, const Int &b)
	{ Int d; Ibelba(&d.I, &u.I, &v.I, &a.I, &b.I); return d; }

inline Int random(const Int &b)
	{ Int a; IasrandomI(&a.I, &b.I); return a; }
        
ostream& operator<<(ostream &out, const Int &a);
istream& operator>>(istream &in, Int &a);

const IN_INT_BUF_LENGTH=10000;

#endif
