//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix I(int n)
{
	Matrix A(n);
	int i,j;
	for(i=1;i<=n;i++)
		for(j=1;j<=n;j++)
		{
			A.koff[i][j]=0;
			if(i==j) A.koff[i][j]=1;
		}
	return(A);
}
