//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix operator /(const Matrix& A,const float x)
{
	return(1/x*A);
}
