//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::~Matrix()
{
	#ifdef DEBUG
	printf("Raderar matris.Storlek %dx%d\n",m,n);
	#endif
	dealloc(koff,n);	
};