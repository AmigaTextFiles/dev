//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
int Matrix::operator != (const Matrix& A)
{
	return(!(*this==A));
}