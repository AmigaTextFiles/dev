//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix e(int n,int x)
{
	Matrix y(n,1);
	y.koff[x][1]=1;
	return(y);
}