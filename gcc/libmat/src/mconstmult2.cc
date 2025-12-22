//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

Matrix operator * (const Matrix& A,float x)
{
	int i,j;
	Matrix C(A.m,A.n);
	for(i=1;i<=A.m;i++)
		for(j=1;j<=A.n;j++)
			C.koff[i][j]=x*A.koff[i][j];
	return(C);
}