//				MATRIX LIB
//			TOMMY JOHANSSON 1995

Matrix Householder(const Matrix & x)
{
	return(I(x.n)-2*x*T(x)/(x*T(x)));
}
#include "matrix.h"
void QR(const Matrix & A,Matrix & Q,Matrix & R)
{
	int i,j;
	Matrix h(A.m,1);
	#ifdef DEBUG 
	printf("QR-faktoriserar matris.\n");
	#endif
	
	for(i=1;i<=A.m;i++)
	{
		