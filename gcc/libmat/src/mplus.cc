//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

Matrix operator + (const Matrix& A,const Matrix& B)
{
	int i,j;
	#ifdef DEBUG
		puts("Adderar matris.");
	#endif

	#ifdef CHECK
		if((A.m!=B.m)&&(A.n!=B.n))	
		{
			printf("Felaktiga dimensioner %d<>%d eller %d<>%d!\n",A.m,B.m,A.n,B.n);	
			exit(0);
		}
	#endif
	Matrix C(A.m,A.n);
	for(i=1;i<=A.m;i++)
		for(j=1;j<=A.n;j++)
			C.koff[i][j]=A.koff[i][j]+B.koff[i][j];
	return(C);
}
