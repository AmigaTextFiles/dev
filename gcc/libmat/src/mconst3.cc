//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::Matrix(int x)
{
	int i,j;
	#ifdef DEBUG
	printf("Initierar %dx%d nollmatris.\n",x,x);
	#endif
	koff=alloc(x+1,x+1);
	if(koff==NULL)
	{
		puts("Minnet slut");
		exit(0);
	}
	m=x;
	n=x;
	for(i=1;i<=x;i++)
		for(j=1;j<=x;j++)
			koff[i][j]=0.0;
}
