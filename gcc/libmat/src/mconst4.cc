//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::Matrix(const Matrix& A)
{
	#ifdef DEBUG
	puts("Initierar matris från en annan.");
	#endif
	int i,j;
	koff=alloc(A.m+1,A.n+1);
	m=A.m;
	n=A.n;
	for(i=1;i<=m;i++)
		for(j=1;j<=n;j++)
			koff[i][j]=A.koff[i][j];
}
