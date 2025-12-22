//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
int Matrix::operator == (const Matrix& A)
{
	int i,j,ch=1;
	#ifdef DEBUG
	printf("Jämför matriser.\n");
	#endif
	#ifdef CHECK
	if((A.n!=n)||(m!=A.m))
		printf("Felaktiga Dimensioner.%d<>%d eller %d<>%d.",A.n,n,A.m,m);
	#endif
	for(i=1;i<=A.m;i++)
		for(j=1;j<=A.n;j++)
			ch*=fabs(A.koff[i][j]-koff[i][j])<EPS;
	return(ch==1);
}