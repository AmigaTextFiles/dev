//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix operator /(const float x,const Matrix& A)
{
	return(x*inv(A));
}
