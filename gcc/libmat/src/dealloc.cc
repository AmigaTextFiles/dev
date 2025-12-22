//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
void dealloc(float **temp,int col)
{
	int i,j;
	for(i=0;i<=col-1;i++)
		delete [] *(temp+i);
	delete [] temp;
}