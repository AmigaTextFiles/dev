//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::Matrix()
{
	#ifdef DEBUG
	printf("Initierar en tom matris\n");
	#endif
	koff=NULL;
	n=0;
	m=0;
}
