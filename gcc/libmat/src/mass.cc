//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix& Matrix::operator = (const Matrix& A)
{
	int i,j;
	dealloc(koff,n);
	m=A.m;
	n=A.n;
	koff=alloc(m+1,n+1);
	#ifdef DEBUG
	puts("Kopierar matris.");
	#endif
	for(i=1;i<=m;i++)
		for(j=1;j<=n;j++)
			koff[i][j]=A.koff[i][j];
	return(*this);
}	
