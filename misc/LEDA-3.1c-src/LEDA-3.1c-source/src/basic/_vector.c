/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _vector.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/vector.h>

#include <math.h>

void vector::check_dimensions(const vector& vec) const
{ if (d!=vec.d)
   error_handler(1,"vector arguments have different dimensions.");
 }


vector::vector(int n) 
{ 
 if (n<0) error_handler(1,"vector: negative dimension."); 
 d = n; 
 v = nil;
 if (d > 0)
 { if (d < 32)
       v = (double*)allocate_bytes(d*sizeof(double));
   else
       v = new double[d];

   while (n--) v[n] = 0.0;
  }
}

vector::~vector() 
{ if (v) 
    if (d < 32) 
       deallocate_bytes(v,d*sizeof(double));
    else
       delete v;
}


vector::vector(const vector& p) 
{ d = p.d; 
  v = nil;
  if (d > 0) 
  { if (d < 32)
        v = (double*)allocate_bytes(d*sizeof(double));
    else
        v = new double[d];
    for(int i=0; i<d; i++) v[i] = p.v[i];
   }
}



vector::vector(double x, double y) 
{ v = (double*)allocate_bytes(2*sizeof(double));
  d = 2;
  v[0] = x;
  v[1] = y;
 }

vector::vector(double x, double y, double z) 
{ v = (double*)allocate_bytes(3*sizeof(double));
  d = 3;
  v[0] = x;
  v[1] = y;
  v[2] = z;
 }

double  vector::operator[](int i) const
{ if (i<0 || i>=d)  error_handler(1,"vector: index out of range ");
  return v[i]; 
}

double& vector::operator[](int i)
{ if (i<0 || i>=d)  error_handler(1,"vector: index out of range ");
  return v[i]; 
}


vector& vector::operator+=(const vector& vec)
{ check_dimensions(vec);
  register int n = d;
  while (n--) v[n] += vec.v[n];
  return *this;
}

vector& vector::operator-=(const vector& vec)
{ check_dimensions(vec);
  register int n = d;
  while (n--) v[n] -= vec.v[n];
  return *this;
}

vector vector::operator+(const vector& vec) const
{ check_dimensions(vec);
  register int n = d;
  vector result(n);
  while (n--) result.v[n] = v[n]+vec.v[n];
  return result;
}

vector vector::operator-(const vector& vec) const
{ check_dimensions(vec);
  register int n = d;
  vector result(n);
  while (n--) result.v[n] = v[n]-vec.v[n];
  return result;
}

vector vector::operator-() const  // unary minus
{ register int n = d;
  vector result(n);
  while (n--) result.v[n] = -v[n];
  return result;
}


vector vector::operator*(double x) const
{ int n = d;
  vector result(n);
  while (n--) result.v[n] = v[n] * x;
  return result;
}

vector vector::operator/(double x) const
{ int n = d;
  vector result(n);
  while (n--) result.v[n] = v[n] / x;
  return result;
}

//friend
vector operator*(double f, const vector& v) { return v*f;     } 

double vector::operator*(const vector& vec) const
{ check_dimensions(vec);
  double result=0;
  register int n = d;
  while (n--) result = result+v[n]*vec.v[n];
  return result;
}

vector& vector::operator=(const vector& vec)
{ register int n = vec.d;

  if (n != d)
  { 
    if (v)
    { if (n < 32)
          deallocate_bytes(v,d*sizeof(double));
      else
          delete v;
     }

    if (d < 32)
         v = (double*)allocate_bytes(n*sizeof(double));
    else
         v = new double[n];
    d = n;
   }

  while (n--) v[n] = vec.v[n];

  return *this;
}


int vector::operator==(const vector& vec)  const
{ if (vec.d != d) return false;
  int i = 0;
  while ((i<d) && (v[i]==vec.v[i])) i++;
  return (i==d) ? true : false;
 }


ostream& operator<<(ostream& s, const vector& v)
{ int i;
  char buf[16];
  for (i=0;i<v.d;i++) 
  { sprintf(buf,"%7.2f ",v[i]);
    s << buf;
   }
  return s;
}

istream& operator>>(istream& s, vector& x)
{ int i=0;
  while (i<x.d && s >> x.v[i++]);
  return s;
}

double vector::length() const { return sqrt(*this * *this); }

double vector::angle(const vector& y)  const
{ double l = length();
  double yl = y.length();

  if ( l==0 || yl==0)
    error_handler(1,"angle: zero argument\n");

  return  acos((*this)*y/(l*yl));  
}



int compare(const vector& v1, const vector& v2)
{ register int i;

  if (v1.dim() != v2.dim())
    error_handler(1,"compare(vector,vector): different dimensions\n");

  for(i=0; i < v1.dim() && v1[i]==v2[i]; i++);

  if (i == v1.dim()) return 0;
   
  return (v1[i] < v2[i]) ?  -1 : 1;
}

