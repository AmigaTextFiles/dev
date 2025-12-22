//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix T(const Matrix & A)
{
	Matrix B(A.n,A.m);
	int i,j;
	for(i=1;i<=A.m;i++)
		for(j=1;j<=A.n;j++)
			B.koff[j][i]=A.koff[i][j];
	return(B);
}