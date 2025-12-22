//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

Matrix operator * (const Matrix& A,const Matrix& B)
{
	int r,k,q;
	#ifdef DEBUG
		puts("Multiplicerar två matriser.");
	#endif
	if((A.n==1)&&(A.m==1)) return(A.koff[1][1]*B); // Skalär*Matris
	if((B.n==1)&&(B.m==1)) return(B.koff[1][1]*A); // Matris*skalär
	#ifdef CHECK
		if(A.n!=B.m)
		{
			printf("Felaktiga dimensioner! %d<>%d\n",A.n,B.m);	
			exit(0);
		}
	#endif
	Matrix C(A.m,B.n);
	for(r=1;r<=A.m;r++)
	{
		for(k=1;k<=B.n;k++)
		{
		C.koff[r][k]=0;
		for(q=1;q<=B.m;q++)
			C.koff[r][k]+=A.koff[r][q]*B.koff[q][k];
		}
	}
	return(C);
}
