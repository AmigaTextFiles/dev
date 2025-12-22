//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

float **alloc(int col,int row)
{
	int i,j;
	float **temp;
	temp=new (float *)[col];
	for(i=0;i<=col-1;i++)
		*(temp+i)=new float [row];
	return(temp);
}