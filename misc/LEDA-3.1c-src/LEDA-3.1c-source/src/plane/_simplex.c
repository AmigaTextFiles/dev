/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _simplex.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/****************************************************************************
*                                                                           *
*    simplex.c                                                              *
*    *********                                                              *
*    ist ein Programm zur Loesung linearer Programme !                      *
*    *************************************************                      *
*                                                                           *
*    Die Implementierung basiert auf dem Zweiphasen-Simplex-Verfahren       *
*    aus Dinkelbach, Operations Research, Kapitel 1.                        *
*                                                                           *
*    Kommentare und die Wahl der Bezeichnernamen beziehen sich in der       *
*    Regel auf die entsprechenden Stellen im Buch.                          *
*                                                                           *
*    29.06.1992                                                             *
*                                                                           *
*    Sascha Portz und Johannes Helders                                      *
*                                                                           *
****************************************************************************/


#include <LEDA/simplex.h>


static void Init_Tableau (matrix A, matrix& M, vector c, vector b,int kl,int gr,
		   int gl, int *&B, int *&NB, int zeilen, int spalten, int n)
{
   int nb = n;                      // Zaehler zur Initialisierung der Menge NB

   for ( int s=0 ; s<n; s++ )
      M(0,s+1) = -c[s];

   for (int z=0; z<kl; z++ )
   {
      for ( int s=0; s < n; s++ )
	 M(z+1,s+1) = A(z,s);
      M(z+1,n+z+1) = 1;              // Schlupfvariablen setzen
      B[z] = n+z+1;                  // der z.te Basisvektor
   }

   for ( z=0; z<gr; z++ )
   {
      for ( int s=0; s < n; s++ )
	 M(kl+z+1,s+1) = A(kl+z,s);
      M(z+kl+1,n+z+kl+1) = -1;        // bei >= Nebenbedingungen neg. Schlupf
      M(z+kl+1,n+kl+gr+z+1) = 1;      // kuenstliche Variable
      B[kl+z] = n+kl+gr+z+1;          // der kl+gr+z.te Basisvektor
      NB[nb] = n+kl+z+1; nb++;        // n+kl+gr+z ist Nichtbasisvaiable
      M(zeilen-1,n+kl+gr+z+1) = 1;    // Initialisieren der Hilfszielfunktion
   }

   for ( z=0; z<gl; z++ )
   {
      for ( int s=0; s<n; s++ )
	 M(z+kl+gr+1,s+1) = A(z+kl+gr,s);
      M(z+kl+gr+1,n+kl+2*gr+z+1) = 1;  // kuenstliche Variable
      B[kl+gr+z] = kl+2*gr+n+z+1;      // der z.te Basisvektor
      M(zeilen-1,n+kl+2*gr+z+1) = 1;   //Initialisieren der Hilfszielfunktion
   }

   for ( z=0; z<b.dim(); z++)
      M(z+1,0) = b[z];

   for( s=0; s < n ; s++)               // 1,...,n sind Nichtbasisvariablen
      NB[s] = s+1;

   for ( z=kl+1; z<=kl+gr+gl; z++)      // Subtrahieren der Zeilen mit kuenstl.
      for ( s=0; s<spalten; s++)   	// Variablen von der letzten Zeile
	 M(zeilen-1,s) = M(zeilen-1,s) - M(z,s);

}


static void InitIntArray (int *&A, int *B, int l)

// Initialisiert das int-Array A der Laenge l mit dem int-Array B

{
   for (int i=0; i<l; i++)
      A[i] = B[i];
}


static void InitMatrix (matrix &A, matrix B, int dim1, int dim2)

// Initialisierung der Matrix A mit der Matrix B

{
   for (int l=0; l<dim1; l++)
      for (int m=0; m<dim2; m++)
	 A(l,m) = B(l,m);
}


static int PivotSpalte (matrix M, int *&NB, int z, int l, int m)

// in der Zeile z (z=0 oder z = m+1) wird die Pivotspalte gesucht

// l ist die Groesse der Menge der Nichtbasisvariablen

// accept = 1 impliziert die Gueltigkeit der gefundenen Pivotspalte, d.h.
// es gibt in dieser Zeile ein Element, das > 0 ist,
// ist dies nicht der Fall so wird nach einer neuen Pivotspalte gesucht
// iter zaehlt die Anzahl der Iterationen

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   double min=-eps;
   double minmin=-10000;
   int mins = 0;
   int p, accept = 0;
   int iter = 1;

   while ( (accept == 0) && (iter <= l) )
   {
      for (int q=0; q<l; q++)
	 if ( ( M(z,NB[q]) <= min ) && ( M(z,NB[q]) > minmin ) )
	 {
	    min = M(z,NB[q]);
	    mins = NB[q];
	 }

      p = 1;                                // Test ob die gefundene Spalte
      while ( (p <= m) && (accept == 0) )   // als Pivotspalte akzeptiert
      {                                     // wird
	 if ( M(p,mins) > eps )
	    accept = 1;
	 p++;
      }

      if (accept == 0)                      // falls nicht
      {                                     // -> Suche nach der naechst-
	 minmin = min; 		            // besten Pivotspalte
	 min = -eps;
	 q = 0;
	 mins = 0;
      }
      iter++;
   }

   return mins;
}


static int D_PivotSpalte (matrix M, int *&NB, int z,int n,int kl,int gr)

// Liefert die Pivotspalte fuer einen Dualsimplexschritt in der Zeile z

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   double min = 1000;
   int mins = 0;

   for(int q=0; q<n+gr; q++)
      if ( ( M(z,NB[q]) < -eps ) && ( NB[q] <= n+kl+gr ) )
	 if ( min >= -M(0,NB[q]) / M(z,NB[q]) )
	 {
	    min = -M(0,NB[q]) / M(z,NB[q]);
	    mins = NB[q];
	 }
   return mins;
}


static int PivotZeile (matrix M, int s, int m)

// Liefert die Pivotzeile fuer einen Primalsimplexschritt in der Spalte s

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   int minz = 0;
   double min = 1000;

   for (int p=1; p<=m; p++)
      if ( M(p,s) > eps )
	  if (min > M(p,0)/M(p,s) )
	  {
	     min = M(p,0)/M(p,s);
	     minz = p;
	  }
   return minz;
}


static void Basiswechsel (matrix &M, int p, int q, int n,int kl, int gr, int gl)

// Basiswechsel : siehe Dinkelbach

{
   double pivot = M(p,q);
   double pivot2;
   int spalten = n+kl+2*gr+gl;
   int zeilen = kl+gr+gl;

   for (int s=0; s<=spalten; s++)
      M(p,s)= M(p,s)/pivot;
   for (int z=0; z<p; z++)
   {
      pivot2 = M(z,q);
      for (int s=0; s<=spalten; s++)
	 M(z,s) = M(z,s)-M(p,s)*pivot2;
   }
   for (z=p+1; z<=zeilen+1; z++)
   {
      pivot2 = M(z,q);
      for (int s=0; s<=spalten; s++)
	 M(z,s) = M(z,s)-M(p,s)*pivot2;
   }
}


static void NB_NNB_Update (int *&B, int *&NB, int p, int q, int l)

// Nach jedem Simplex-Schritt werden die Mengen der Basis- ( B ) und
// Nichtbasisvariablen ( NB ) neu berechnet

// p und q bezeichnen die Pivotzeile bzw die Pivotspalte

// l ist die Groesse der Menge der Nichtbasisvariablen (diese aendert
// sich im Laufe des Verfahrens)

{
   int h1, h2;

   for (int x=0; x<l; x++)
      if (NB[x] == q)
	 h1 = x;
   h2 = B[p-1];
   B [p-1] = q;
   NB [h1] = h2;
}


static void NNB_Update (int *&NB, int n, int kl, int gr, int gl)

// Veringerung der Menge der Nichtbasisvariablen um die k’nstlichen Variablen

{
   int *nnb = new int[n-gl];
   int m = 0;

   for (int l=0; l<n+gr; l++)
      if ( NB[l] <= n+kl+gr )
      {
	 nnb[m] = NB[l];
	 m++;
      }
   delete NB;
   NB = nnb;
}


static int nicht_optimal (matrix &M, int n, int kl, int gr)

// returniert 1, wenn das Simplextableau nicht optimal ist, sonst 0

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   int not_opt = 0;
   for (int i=1; i<=n+gr+kl; i++)
      if ( M(0,i) < -eps )
	 not_opt = 1;
   return not_opt;
}


static void Eliminiere_kuenstl_Var (matrix M, int *&B, int *&NB, int &error,
			     int m, int n, int kl, int gr, int gl)

// die kuenstlichen Variablen, die noch Basisvariablen sind, werden zu
// Nichtbasisvariablen "pivotiert"

{
   int q;

   int l=0;
   while ( (l<m) && nicht_optimal(M,n,kl,gr) )
   {
      if (B[l] > n+kl+gr)
      {
	 q = D_PivotSpalte (M,NB,l+1,n,kl,gr);
         if ( (q != 0) && ( error == 0 ) )
	 {
	    Basiswechsel (M,l+1,q,n,kl,gr,gl);
	    NB_NNB_Update (B,NB,l+1,q,n+gr);
	 }
	 else
	    error = 1;
      }
      l++;
   }
   if ( (error==0) && nicht_optimal(M,n,kl,gr) )
      NNB_Update (NB,n,kl,gr,gl);
}


static vector Basisloesung (matrix M, int *B, int m, int n)

// returniert eine optimale Basisloesung

{
   vector X(n);

   for (int l=0; l<m; l++)
      if ( B[l] <= n )
	 X[B[l]-1] = M(l+1,0);

   return X;
}


static vector Extremalstrahl (matrix M, int *&B, int *&MF, int l, int m, int n)

// returniert die Steigung des Extremalstrahls

{
   vector s(n);

   for (int j=0; j<m; j++)
      if ( B[j] <= n )
	s[B[j]-1] = -M(j+1,MF[l]);

   if ( MF[l] <= n )
      s[MF[l]-1]=1;

   return s;
}


static int ZERO (vector v,int n)

// returniert 1, falls v gleich dem Nullvektor ist, sonst 0

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   int zero = 1;

   for (int i=0; i<n; i++)
      if ( (v[i] < -eps) || (v[i] > eps) )
         zero = 0;

   return zero;
}


static void Init_Matrix (matrix &A, vector x, int n)

// initialisiert die (1xn)-Matrix mit dem Vektor x

{
   for (int i=0; i<n; i++)
      A(0,i) = x[i];
}


static void Enlarge_Matrix (matrix &A, vector v, int n)

// vergroessert die Matrix A um den Zeilenvektor v

{
   int dim1 = A.dim1();
   matrix B(dim1+1,A.dim2());

   InitMatrix (B,A,dim1,A.dim2());

   for (int i=0; i<n; i++)
      B(dim1,i) = v[i];

   A = B;
}


static void Test_auf_Extremalstrahl (matrix &M,int *&B,int *&NB,list<matrix>& L,
			      int *&MF, int *&PZ, int i, vector x, int m, 
                              int n, int kl, int gr)

// Berechnung und Ausgabe eines optimalen Extremalstrahls
// Aufbau der Liste L der optimalen Loesungen

{
   vector s(n);
   matrix A (1,n);

   Init_Matrix (A,x,n);

   for (int l=0; l<i; l++)
      if ( NB[l] <= n+gr+kl )             // Test ob im optimalen Tableau ein
	 if ( M(0,NB[l]) == 0 )        // Zielfunktionskoeffient einer Nicht-
	    MF[l] = NB[l];                // basisvariable = 0 ist
	 else
	    MF[l] = 0;
      else
         MF[l] = 0;

   for ( l=0; l<i; l++)
   {
      if ( MF[l] > 0 )
      {
	 PZ[l] = PivotZeile (M,MF[l],m);
	 if ( PZ[l] == 0 )
	 {
	    s = Extremalstrahl (M,B,MF,l,m,n);
	    if ( !ZERO(s,n) )
	       Enlarge_Matrix (A,s,n);
	 }
      }
   }

   L.append (A);
}


static
void Test_auf_Mehrfachloesungen(matrix &M,int *&B,int *&NB,list<matrix> &L,
				int x, vector v,int zeilen, int spalten,
				int m, int n, int kl, int gr, int gl)

// Berechnung von eventuell existierenden weiteren optimalen Basisloesungen
// x ist die Groesse der Menge der Nichtbasisvariablen

{
				    // Hilfsmatrix zur Berechnung weiterer
   matrix A (m+2,n+kl+2*gr+gl+1);   // optimaler Simplextableaus

   int *MF = new int[x];              // fuer die Indizes der Spalten in
				      // denen die 0.te Zeile =0 ist
   int *PZ = new int[x];              // die zugehoerigen Pivotzeilen

   int *H1 = new int[x];              // Hilfsarrays
   int *H2 = new int[x];

   int *b = new int [m];              // Hilfsarrays fuer B
   int *nb = new int [x];             // und NB


   Test_auf_Extremalstrahl (M,B,NB,L,MF,PZ,x,v,m,n,kl,gr);

   for (int l=0; l<x; l++)
   {
      if ( MF[l] > 0 )
	 if ( PZ[l] > 0 )
	 {
	    InitMatrix (A,M,zeilen,spalten);
	    InitIntArray (b,B,m);
	    InitIntArray (nb,NB,x);
	    Basiswechsel (A,PZ[l],MF[l],n,kl,gr,gl);
	    NB_NNB_Update (b,nb,PZ[l],MF[l],x);
	    v = Basisloesung (A,b,m,n);
	    Test_auf_Extremalstrahl (A,b,nb,L,H1,H2,x,v,m,n,kl,gr);
						 // H1, H2 sind Hilfsarrays
	 }
   }
   delete MF; delete PZ; delete H1;
   delete H2; delete b; delete nb;
}


static
void Run (matrix &M, int *&B, int *&NB, list<matrix> &L, int zeilen, 
          int spalten, int m, int n, int kl, int gr, int gl)

// Hauptprozedur

{
   double eps = 0.00001;	// das Intervall [-eps..eps] entspricht NULL

   int p, q;
   int error=0;
   vector x;

   q = PivotSpalte (M,NB,m+1,n+gr,m);
   while (q != 0)
   {
      p = PivotZeile (M,q,m);
      if (p != 0)
      {
	 Basiswechsel (M,p,q,n,kl,gr,gl);
	 NB_NNB_Update (B,NB,p,q,n+gr);
      }
      q = PivotSpalte (M,NB,m+1,n+gr,m);
   }

   if ( ( M(m+1,0) > -eps ) && ( M(m+1,0) < eps ) )
   {

      Eliminiere_kuenstl_Var (M,B,NB,error,m,n,kl,gr,gl);
      if ( nicht_optimal (M,n,kl,gr) )
      {

// falls error = 1 so konnte ein notwendiger Dualsimplexschritt nicht
// durchgefuehrt werden

	 if ( error == 0 )
	 {
	    q = PivotSpalte (M,NB,0,n-gl,m);
	    while (q != 0)
	    {
	       p = PivotZeile (M,q,m);
	       if (p != 0)
	       {
		  Basiswechsel (M,p,q,n,kl,gr,gl);
		  NB_NNB_Update (B,NB,p,q,n-gl);
	       }
	       q = PivotSpalte (M,NB,0,n-gl,m);
	    }
	    x = Basisloesung(M,B,m,n);
	    Test_auf_Mehrfachloesungen(M,B,NB,L,n-gl,x,zeilen,
				       spalten,m,n,kl,gr,gl);
	 }
      }
      else                              // das Tableau war schon optimal
      {
	  x = Basisloesung(M,B,m,n);
	  Test_auf_Mehrfachloesungen (M,B,NB,L,n+gr,x,zeilen,
				      spalten,m,n,kl,gr,gl);
      }
   }
}


list<matrix> SIMPLEX(matrix A, int i, int j, int k, vector b, vector c)
{
   int *B; int *NB;
 
   list<matrix> L;

   int kl =i,  gr=j, gl=k;
   int n = A.dim2(),m = A.dim1();		// setzen der globalen Variablen
   int zeilen = m+2, spalten = n+m+gr+1;

   matrix M(zeilen,spalten);
   B  = new int[m];
   NB = new int[n+gr];

   Init_Tableau(A,M,c,b,i,j,k,B,NB,zeilen,spalten,n);

   Run (M,B,NB,L,zeilen,spalten,m,n,kl,gr,gl);

   delete B; delete NB;

   return L;
}

