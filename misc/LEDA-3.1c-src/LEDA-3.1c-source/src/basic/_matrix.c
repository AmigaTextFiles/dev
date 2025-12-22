/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _matrix.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/matrix.h>

#include <math.h>

#define EPSILON 1e-12

//------------------------------------------------------------------------------
//  matrix member functions
//------------------------------------------------------------------------------


void matrix::flip_rows(int i,int j)
{ vector* p = v[i];
  v[i] = v[j];
  v[j] = p;
 }


matrix::matrix(int dim1, int dim2)  
{
  if (dim1<0 || dim2<0) 
  error_handler(1,"matrix: negative dimension."); 

  d1=dim1; 
  d2=dim2; 

  if (d1 > 0) 
  { v = new vector*[d1];
    for (int i=0;i<d1;i++) v[i] = new vector(d2); 
   }
  else v = nil;
}


matrix::matrix(const matrix& p)  
{ 
  d1 = p.d1;
  d2 = p.d2;
    
  if (d1 > 0) 
  { v = new vector*[d1];
    for (int i=0;i<d1;i++) v[i] = new vector(*p.v[i]); 
   }
  else v = nil;
}

matrix::matrix(int dim1, int dim2, double** p)  
{ d1=dim1; 
  d2=dim2; 
  v = new vector*[d1];
  for(int i=0;i<d1;i++) 
  { v[i] = new vector(d2); 
    for(int j=0;j<d2;j++) elem(i,j) = p[i][j];
   }

 }

matrix::~matrix()  
{ if (v) 
  { while(d1--) delete v[d1]; 
    delete v;
   }
}


void matrix::check_dimensions(const matrix& mat) const
{ if (d1 != mat.d1 || d2 != mat.d2)
   error_handler(1,"incompatible matrix types.");
 }

matrix::matrix(const vector& vec)
{ d1 = vec.d;
  d2 = 1;
  v = new vector*[d1];
  for(int i=0; i<d1; i++)
  { v[i] = new vector(1);
    elem(i,0) = vec[i];
   }
    
}

matrix& matrix::operator=(const matrix& mat)
{ register int i,j;

  if (d1 != mat.d1 || d2 != mat.d2)
  { for(i=0;i<d1;i++) delete v[i];
    delete v;
    d1 = mat.d1;
    d2 = mat.d2;
    v = new vector*[d1];
    for(i=0;i<d1;i++) v[i] = new vector(d2);
   }

  for(i=0;i<d1;i++)
    for(j=0;j<d2;j++) elem(i,j) = mat.elem(i,j);

  return *this;
}

int matrix::operator==(const matrix& x) const
{ register int i,j;
  if (d1 != x.d1 || d2 != x.d2) return false;

  for(i=0;i<d1;i++)
    for(j=0;j<d2;j++)
      if (elem(i,j) != x.elem(i,j)) return false;

  return true;
 }


vector& matrix::row(int i) const
{ if ( i<0 || i>=d1 )  error_handler(1,"matrix: row index out of range");
   return *v[i];
}


double& matrix::operator()(int i, int j)
{ if ( i<0 || i>=d1 )  error_handler(1,"matrix: row index out of range");
  if ( j<0 || j>=d2 )  error_handler(1,"matrix: col index out of range");
  return elem(i,j);
}

double matrix::operator()(int i, int j) const
{ if ( i<0 || i>=d1 )  error_handler(1,"matrix: row index out of range");
  if ( j<0 || j>=d2 )  error_handler(1,"matrix: col index out of range");
  return elem(i,j);
}

vector matrix::col(int i)  const
{ if ( i<0 || i>=d2 )  error_handler(1,"matrix: col index out of range");
  vector result(d1);
  int j = d1;
  while (j--) result.v[j] = elem(j,i);
  return result;
}

matrix::operator vector() const
{ if (d2!=1) 
   error_handler(1,"error: cannot make vector from matrix\n");
  return col(0);
}

matrix matrix::operator+(const matrix& mat)
{ register int i,j;
  check_dimensions(mat);
  matrix result(d1,d2);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      result.elem(i,j) = elem(i,j) + mat.elem(i,j);
  return result;
}

matrix& matrix::operator+=(const matrix& mat) 
{ register int i,j;
  check_dimensions(mat);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      elem(i,j) += mat.elem(i,j);
  return *this;
}

matrix& matrix::operator-=(const matrix& mat) 
{ register int i,j;
  check_dimensions(mat);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      elem(i,j) -= mat.elem(i,j);
  return *this;
}


matrix matrix::operator-(const matrix& mat)
{ register int i,j;
  check_dimensions(mat);
  matrix result(d1,d2);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      result.elem(i,j) = elem(i,j) - mat.elem(i,j);
  return result;
}


matrix matrix::operator-()  // unary
{ register int i,j;
  matrix result(d1,d2);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      result.elem(i,j) = -elem(i,j);
  return result;
}


matrix matrix::operator*(double f)
{ register int i,j;
  matrix result(d1,d2);
  for(i=0;i<d1;i++)
   for(j=0;j<d2;j++)
      result.elem(i,j) = elem(i,j) *f;
  return result;
}

matrix matrix::operator*(const matrix& mat)
{ if (d2!=mat.d1)
     error_handler(1,"matrix multiplication: incompatible matrix types\n");
  
  matrix result(d1, mat.d2);
  register int i,j;

  for (i=0;i<mat.d2;i++)
  for (j=0;j<d1;j++) result.elem(j,i) = *v[j] * mat.col(i);

 return result;

}

double matrix::det() const
{
 if (d1!=d2)  
   error_handler(1,"matrix::det: matrix not quadratic.\n");

 int n = d1;

 matrix M(n,1);

 int flips;

 double** A = triang(M,flips);

 if (A == NULL)  return 0;

 double Det = 1;

 for(int i=0;i<n;i++) Det *= A[i][i];

 for(i=0;i<n;i++) delete A[i];
 delete A;

 return (flips % 2) ? -Det : Det;

}


double** matrix::triang(const matrix& M, int& flips)  const
{
 register double **p, **q;
 register double *l, *r, *s;

 register double pivot_el,tmp;

 register int i,j, col, row;

 int n = d1;
 int d = M.d2;
 int m = n+d;

 double** A = new double*[n];

 p = A;

 for(i=0;i<n;i++) 
 { *p = new double[m];
   l = *p++;
   for(j=0;j<n;j++) *l++ = elem(i,j);
   for(j=0;j<d;j++) *l++ = M.elem(i,j);
  }

 flips = 0;

 for (col=0, row=0; row<n; row++, col++)
 { 
   // search for row j with maximal absolute entry in current col
   j = row;
   for (i=row+1; i<n; i++)
     if (fabs(A[j][col]) < fabs(A[i][col])) j = i;

   if ( n > j && j > row) 
   { double* p = A[j];
     A[j] = A[row];
     A[row] = p;
     flips++;
    }

   tmp = A[row][col];
   q  = &A[row];

   if (fabs(tmp) < EPSILON) // matrix has not full rank
   { p = A;
     for(i=0;i<n;i++) delete *p;
     delete A;
     return NULL;
    }

   for (p = &A[n-1]; p != q; p--)
   { 
     l = *p+col;
     s = *p+m;	
     r = *q+col;

     if (*l != 0.0)
     { pivot_el = *l/tmp;
        while(l < s) *l++ -= *r++ * pivot_el;
      }

    }

  }

 return A;
}

matrix matrix::inv() const
{
 if (d1!=d2)  
     error_handler(1,"matrix::inv: matrix not quadratic.\n");
 int n = d1;
 matrix I(n,n);
 for(int i=0; i<n; i++) I(i,i) = 1;
 return solve(I);
}



matrix matrix::solve(const matrix& M) const
{

if (d1 != d2 || d1 != M.d1)
     error_handler(1, "Solve: wrong dimensions\n");

 register double **p, ** q;
 register double *l, *r, *s;

 int      n = d1;
 int      d = M.d2;
 int      m = n+d;
 int      row, col,i;


 double** A = triang(M,i);

 if (A == NULL) 
   error_handler(1,"matrix::solve: matrix has not full rank.");

 for (col = n-1, p = &A[n-1]; col>=0; p--, col--)
 { 
   s = *p+m;

   double tmp = (*p)[col];

   for(l=*p+n; l < s; l++) *l /=tmp;

   for(q = A; q != p; q++ )
   { tmp = (*q)[col];
     l = *q+n;
     r = *p+n;
     while(r < s)  *l++ -= *r++ * tmp;
    }
                 
  } 

  matrix result(n,d);

  for(row=0; row<n; row++)
  { l = A[row]+n;
    for(col=0; col<d; col++) result.elem(row,col) = *l++;
    delete A[row];
   }

  delete A;

  return result;
}




matrix matrix::trans() const
{ matrix result(d2,d1);
  for(int i = 0; i < d2; i++)
    for(int j = 0; j < d1; j++)
      result.elem(i,j) = elem(j,i);
  return result;
}
     

ostream& operator<<(ostream& s, const matrix& M)
{ int i;
  s <<"\n";
  for (i=0;i<M.d1;i++) s << M[i] << "\n"; 
  return s;
}

istream& operator>>(istream& s, matrix& M)
{ int i=0;
  while (i<M.d1 && s >> M[i++]);
  return s;
}


