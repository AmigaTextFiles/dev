/*
 *
 *	Math Funktions 
 *	Frank Pagels Defect Softworks 2001
 *
 *
 */

#include <stdio.h>
#include <math.h>
#include <string.h>
#include "mathutil.h"
#include <stdlib.h>

#ifndef PI
	#ifdef M_PI
	#define PI M_PI
	#else
	#define PI 3.1415927
	#endif
#endif

#define CM_0 OF_11
#define CM_1 OF_12
#define CM_2 OF_13
#define CM_3 OF_21
#define CM_4 OF_22
#define CM_5 OF_23
#define CM_6 OF_31
#define CM_7 OF_32
#define CM_8 OF_33


/*
** Computes the determinant of the upper 3x3 submatrix block
** of the supplied matrix
*/
TFLOAT Determinant(Matrix *pA)
{
	#define a(x) (pA->v[CM_##x])
	 return ( a(0)*a(4)*a(8)  +  a(1)*a(5)*a(6)  + a(2)*a(3)*a(7)
	   -  a(0)*a(5)*a(7)  -  a(1)*a(3)*a(8)  - a(2)*a(4)*a(6));
	#undef a
}

/*
** Builds the inverse of the upper 3x3 submatrix block of the
** supplied matrix for the backtransformation of the normals
*/
void DoInvert(Matrix *pA, Matrix *pB)
{
	TFLOAT det = 1.0 / Determinant(pA);

	#define a(x) (pA->v[CM_##x])
	#define b(x) (pB->v[CM_##x])

	b(0) = (TFLOAT)(a(4)*a(8) - a(5)*a(7))*det;
	b(1) = (TFLOAT)(a(2)*a(7) - a(1)*a(8))*det;
	b(2) = (TFLOAT)(a(1)*a(5) - a(2)*a(4))*det;

	b(3) = (TFLOAT)(a(5)*a(6) - a(3)*a(8))*det;
	b(4) = (TFLOAT)(a(0)*a(8) - a(2)*a(6))*det;
	b(5) = (TFLOAT)(a(2)*a(3) - a(0)*a(5))*det;
	
	b(6) = (TFLOAT)(a(3)*a(7) - a(4)*a(6))*det;
	b(7) = (TFLOAT)(a(1)*a(6) - a(0)*a(7))*det;
	b(8) = (TFLOAT)(a(0)*a(4) - a(1)*a(3))*det;

	#undef a
	#undef b

}

/*
**
**	Simple Matrixmultiplikation
**  A * B = C
**
*/

void MatMultGeneral(Matrix *pA, Matrix *pB, Matrix *pC)
{
	#define a(x) (pA->v[OF_##x])
	#define b(x) (pB->v[OF_##x])
	#define c(x) (pC->v[OF_##x])


	c(11) = a(11)*b(11)+a(12)*b(21)+a(13)*b(31)+a(14)*b(41);
	c(12) = a(11)*b(12)+a(12)*b(22)+a(13)*b(32)+a(14)*b(42);	
	c(13) = a(11)*b(13)+a(12)*b(23)+a(13)*b(33)+a(14)*b(43);	
	c(14) = a(11)*b(14)+a(12)*b(24)+a(13)*b(34)+a(14)*b(44);	

	c(21) = a(21)*b(11)+a(22)*b(21)+a(23)*b(31)+a(24)*b(41);
	c(22) = a(21)*b(12)+a(22)*b(22)+a(23)*b(32)+a(24)*b(42);	
	c(23) = a(21)*b(13)+a(22)*b(23)+a(23)*b(33)+a(24)*b(43);	
	c(24) = a(21)*b(14)+a(22)*b(24)+a(23)*b(34)+a(24)*b(44);	

	c(31) = a(31)*b(11)+a(32)*b(21)+a(33)*b(31)+a(34)*b(41);
	c(32) = a(31)*b(12)+a(32)*b(22)+a(33)*b(32)+a(34)*b(42);	
	c(33) = a(31)*b(13)+a(32)*b(23)+a(33)*b(33)+a(34)*b(43);	
	c(34) = a(31)*b(14)+a(32)*b(24)+a(33)*b(34)+a(34)*b(44);	

	c(41) = a(41)*b(11)+a(42)*b(21)+a(43)*b(31)+a(44)*b(41);
	c(42) = a(41)*b(12)+a(42)*b(22)+a(43)*b(32)+a(44)*b(42);	
	c(43) = a(41)*b(13)+a(42)*b(23)+a(43)*b(33)+a(44)*b(43);	
	c(44) = a(41)*b(14)+a(42)*b(24)+a(43)*b(34)+a(44)*b(44);	

	#undef a
	#undef b
	#undef c
}

/*
**	A * B , A=4x4 , B = 1x4
**
*/

void MatMultPoint(Matrix *pA, TFLOAT *v, TFLOAT *tmp)
{
	#define a(x) (pA->v[OF_##x])

	tmp[0] = a(11) * v[0] + a(12) * v[1] + a(13) * v[2] + a(14) * v[3];
	tmp[1] = a(21) * v[0] + a(22) * v[1] + a(23) * v[2] + a(24) * v[3];
	tmp[2] = a(31) * v[0] + a(32) * v[1] + a(33) * v[2] + a(34) * v[3];
	tmp[3] = a(41) * v[0] + a(42) * v[1] + a(43) * v[2] + a(44) * v[3];

	#undef a
}


/*
** Copy matrix B to matrix A
** A = B
*/
void MatCopy(Matrix *pA, Matrix *pB)
{
	int i;

	for (i=0; i<16; i++) pA->v[i] = pB->v[i];
	pA->flags = pB->flags;
	pA->Inverse = pB->Inverse;
}


void LoadMatrix(Matrix *pA, const TFLOAT *v)
{
	#define a(x) pA->v[OF_##x] = *v++

	a(11); a(21); a(31); a(41);
	a(12); a(22); a(32); a(42);
	a(13); a(23); a(33); a(43);
	a(14); a(24); a(34); a(44);

	//if (*(v-4) == 0.f && *(v-3) == 0.f && *(v-2) == 0.f && *(v-1) == 1.f)
	//	pA->flags = MGLMAT_0001;

	#undef a
}

void LoadIdentity(Matrix *pA)
{
	#define a(x) pA->v[OF_##x] = 0.f;
	#define b(x) pA->v[OF_##x] = 1.f;

	b(11); a(21); a(31); a(41);
	a(12); b(22); a(32); a(42);
	a(13); a(23); b(33); a(43);
	a(14); a(24); a(34); b(44);

	//pA->flags = MGLMAT_IDENTITY;

	#undef a
	#undef b
}


void PrintMatrix(Matrix *pA)
{
	#define a(x) (pA->v[OF_##x])
	printf("Matrix at 0x%lX\n", (TUINT)pA);
	printf("    | %6.3f %6.3f %6.3f %6.3f |\n",
		a(11), a(12), a(13), a(14));
	printf("    | %6.3f %6.3f %6.3f %6.3f |\n",
		a(21), a(22), a(23), a(24));
	printf("A = | %6.3f %6.3f %6.3f %6.3f |\n",
		a(31), a(32), a(33), a(34));
	printf("    | %6.3f %6.3f %6.3f %6.3f |\n",
		a(41), a(42), a(43), a(44));
	#undef a
}

/*
**	Get Hartenberg Matrix for
**	Theta, d, a, alpha
**
*/
void GetHartenberg(joint *j, Matrix *pA)
{
	TFLOAT ct,st,cal,sal,th,al;
	
	#define a(x) (pA->v[OF_##x])

	th = j->theta; 	/* * PI / 180; */
	al = j->alpha; 	/* * PI / 180; */

	ct = cos(th);
	st = sin(th);
	cal = cos(al);
	sal = sin(al);	

	a(11) = ct;
	a(12) = -cal*st;
	a(13) = sal*st;
	a(14) = j->a*ct;
	
	a(21) = st;
	a(22) = cal*ct;
	a(23) = -sal*ct;
	a(24) = j->a*st;
	
	a(31) = 0;
	a(32) = sal;
	a(33) = cal;
	a(34) = j->d;
	
	a(41) = 0;
	a(42) = 0;
	a(43) = 0;
	a(44) = 1;
	
	#undef a	

}

/*
**
**	Subtract C = A - B
**
*/
void GenMatSub(GenMatrix *A,GenMatrix *B, GenMatrix *C)
{
	TINT i,j;
	
	for(i=0;i < A->rows;i++)
	{
		for(j=0;j < A->colum;j++)
		{
			C->m[i][j] = A->m[i][j] - B->m[i][j];
		}
	}

}

/*
**
**	Add A + B = C
**
*/
void GenMatAdd(GenMatrix *A, GenMatrix *B, GenMatrix *C)
{
	TINT i,j;
	
	for(i=0;i < A->rows;i++)
	{
		for(j=0;j < A->colum;j++)
		{
			C->m[i][j] = A->m[i][j] + B->m[i][j];
		}
	}

}

/*
**
**	Multiply Matrix A,B to C
**
*/

void GenMatMultiply(GenMatrix *A, GenMatrix *B, GenMatrix *C)
{
	TINT i,j,k;
	TFLOAT sum;
	
	if(A->colum == B->rows)
	{
		for(i=0;i < A->rows;i++)
		{
			for(k=0; k < B->colum;k++)
			{
				C->m[i][k] = 0;			
				for(j=0;j < A->colum;j++)
				{
					C->m[i][k] += A->m[i][j] * B->m[j][k];
				}
			}
		}
	}
}


/*
**
**	Transpose Matrix A to B
**
*/
void GenMatTranspose(GenMatrix *A, GenMatrix *B)
{
	TINT i,j;
	
	if(A->colum == B->rows)
	{
		if(A->rows == B->colum)
		{
			for(i=0;i < A->rows;i++)
			{
				for(j=0;j < A->colum;j++)
				{
					B->m[j][i] = A->m[i][j];
				}
			}
		}
	}	

}


/*
**
**	GenLoadIndentity
**
*/
void GenMatLoadIdentity(GenMatrix *A, TFLOAT a)
{
	TINT i,j;
	
	memset(A->m,0,A->rows*A->colum*sizeof(TFLOAT));
		
	if(A->colum == A->rows)
	{
		for(i=0;i < A->rows;i++)
		{
			for(j=0;j < A->colum;j++)
			{
				if(i==j)
				A->m[i][j] = a;
				else
				A->m[i][j] = 0;
			}
		}
	}
}


/*
**
**	Invers Matrix with Crout's Method
**
*/

void GenMatInvers1(GenMatrix *A)
{
	TINT i,j,k;	
	TINT N = A->rows;
	TFLOAT a,sum;
	
	
	/* LU Decomposing with Crout's Method */
	
	a = 1.0 / A->m[0][0];
	
	for(j=1;j < N ;j++)
	{
		A->m[0][j]  = A->m[0][j] * a;
	}

	for(j=1;j<N-1;j++)
	{
		i = j;
		for(i;i<N ;i++)
		{
			sum = 0;	
			for(k=0;k < j;k++)
			{
				sum += A->m[i][k] * A->m[k][j];
			}
			
			A->m[i][j] -= sum;
		}

		k=j+1;
		for(k;k < N;k++)
		{
			sum = 0;
			for(i=0;i < j;i++)
			{
				sum += A->m[j][i] * A->m[i][k];
			}

			A->m[j][k] -= sum;
			A->m[j][k] /= A->m[j][j];
		}
	}
		

	for(k=0;k < N-1;k++)
	{
		sum += A->m[N-1][k] * A->m[k][N-1];
	}
	
	A->m[N-1][N-1] -= sum; 

	/* */
	/*
	for(i=1;j<=N;j++)
	{
		for(i=1;i<=N;i++) col[i]=0.0;
		col[j]=1.0;
		lubks(&A,N,indx,col);
		for(i=1;i<=N,j++)
	}
	*/

}

/*
**
** Invert Matrix nach GemsII Rod G. Bogart
**
*/
void GenMatInvers(GenMatrix *A)
{
    TINT i,j,k;
					/* Locations of pivot elements */
    TINT *pvt_i, *pvt_j;
    TFLOAT pvt_val;                     /* Value of current pivot element */
    TFLOAT hold;                        /* Temporary storage */
    TFLOAT determ;                      /* Determinant */

    determ = 1.0;

    //pvt_i = (TINT *) malloc(A->rows * sizeof(TINT));
    //pvt_j = (TINT *) malloc(A->rows * sizeof(TINT));
	pvt_i = A->pvt_i;
	pvt_j = A->pvt_j;
	
    for (k = 0; k < A->rows; k++)
    {
        /* Locate k'th pivot element */
        pvt_val = A->m[k][k];            /* Initialize for search */
        pvt_i[k] = k;
        pvt_j[k] = k;
        for (i = k; i < A->rows; i++)
          for (j = k; j < A->rows; j++)
            if (fabs(A->m[i][j]) > fabs(pvt_val))
            {
                pvt_i[k] = i;
                pvt_j[k] = j;
                pvt_val = A->m[i][j];
            }
        /* Product of pivots, gives determinant when finished */
        determ *= pvt_val;
        if (determ == 0.0) {    
         /* Matrix is singular (zero determinant). */
	    free(pvt_i);
	    free(pvt_j);
            return;
	}

        /* "Interchange" rows (with sign change stuff) */
        i = pvt_i[k];
        if (i != k)                     /* If rows are different */
          for (j = 0; j < A->rows; j++)
          {
            hold = -A->m[k][j];
            A->m[k][j] = A->m[i][j];
            A->m[i][j] = hold;
          }

        /* "Interchange" columns */
        j = pvt_j[k];
        if (j != k)                     /* If columns are different */
          for (i = 0; i < A->rows; i++)
          {
            hold = -A->m[i][k];
            A->m[i][k] = A->m[i][j];
            A->m[i][j] = hold;
          }
        /* Divide column by minus pivot value */
        for (i = 0; i < A->rows; i++)
          if (i != k)                   /* Don't touch the pivot entry */
            A->m[i][k] /= ( -pvt_val) ;  /* (Tricky C syntax for division) */

        /* Reduce the matrix */
        for (i = 0; i < A->rows; i++)
        {
            hold = A->m[i][k];
            for (j = 0; j < A->rows; j++)
              if ( i != k && j != k )   /* Don't touch pivot. */
                A->m[i][j] += hold * A->m[k][j];
        }

        /* Divide row by pivot */
        for (j = 0; j < A->rows; j++)
          if (j != k)                   /* Don't touch the pivot! */
            A->m[k][j] /= pvt_val;

        /* Replace pivot by reciprocal (at last we can touch it). */
        A->m[k][k] = 1.0/pvt_val;
    }

    /* That was most of the work, one final pass of row/column interchange */
    /* to finish */
    for (k = A->rows-2; k >= 0; k--)  /* Don't need to work with 1 by 1 */
                                        /* corner */
    {
        i = pvt_j[k];		 /* Rows to swap correspond to pivot COLUMN */
        if (i != k)                     /* If rows are different */
          for(j = 0; j < A->rows; j++)
          {
            hold = A->m[k][j];
            A->m[k][j] = -A->m[i][j];
            A->m[i][j] = hold;
          }

        j = pvt_i[k];           /* Columns to swap correspond to pivot ROW */
        if (j != k)                     /* If columns are different */
          for (i = 0; i < A->rows; i++)
          {
            hold = A->m[i][k];
            A->m[i][k] = -A->m[i][j];
            A->m[i][j] = hold;
          }
    }

    //free(pvt_i);
    //free(pvt_j);
    //return(determ);
}


/*
**
**	Copy GenMatrix A to B
**
*/
void GenMatCopy(GenMatrix *A,GenMatrix *B)
{
	TINT i,j;
	
	for(i=0;i<A->rows;i++)
	{
		for(j=0;j<A->colum;j++)
		{
			B->m[i][j] = A->m[i][j];
		}
	}
}

/*
**
**	Get Pseudoinverse of A
**
*/
void GenMatPseudoInvers(GenMatrix *A, GenMatrix *B, GenMatrix *C)
{
	
	if(A->rows > A->colum)
	{
		GenMatTranspose(A,B);
		GenMatMultiply(B,A,C);
		GenMatInvers(C);
		GenMatMultiply(A,C,B);
		GenMatTranspose(B,A);
	}
	else
	{
		GenMatTranspose(A,B);
		GenMatMultiply(A,B,C);
		GenMatInvers(C);
		A->rows = B->rows;
		A->colum = B->colum;
		GenMatMultiply(B,C,A);
	}
}		

		
/*		
	A = M;
  if ( ROWS(M) > COLUMNS(M) ) 
    A = TRANSPOSE(A);

  B = TRANSPOSE(A) * INV( A * TRANSPOSE(A) );

  if ( ROWS(M) > COLUMNS(M) )
    B = TRANSPOSE(B);
*/


/*
**
**	Print Matrix
**
*/
void GenPrintMatrix(GenMatrix *A)
{
	TINT i,j;
	
	for(i=0;i < A->rows;i++)
	{
		printf("   |");
		for(j=0;j < A->colum;j++)
		{
			printf("  %6.3f",A->m[i][j]);
		}
		printf("|\n");
	}
	printf("\n\n");
}

void InitGenMatrix(GenMatrix *A, TINT row, TINT colum)
{
	
	//memset(A->m,0,row*colum*sizeof(TFLOAT));
	A->rows=row;
	A->colum=colum;
	
}

void DestroyGenMatrix(GenMatrix *A)
{
	A->rows = 0;
	A->colum = 0;
}

void GenLoadMatrix(Matrix *pA, const TFLOAT *v)
{
	
}






