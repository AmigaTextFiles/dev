//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix inv(const Matrix& A)
{
	int i,j;
	Matrix x(A.n,1);
	Matrix C(A.n);
	for(i=1;i<=A.n;i++)
	{
		x=solve(A,e(A.n,i));
		for(j=1;j<=A.n;j++)
			C.koff[j][i]=x.koff[j][1];
	}
	return(C);
}
