//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
float det(const Matrix & A)
{
	float x=1;
	Matrix C(A.m);
	C=gauss(A);
	int i;
	for(i=1;i<=A.m;i++)
		x*=C.koff[i][i];
	return(x);
}