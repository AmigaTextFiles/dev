//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix operator / (const Matrix& x,const Matrix& A)
{
	return(solve(A,x));
}