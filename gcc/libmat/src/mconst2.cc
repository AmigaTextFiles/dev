//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::Matrix(int x,int y)
{
	int i,j;
	#ifdef DEBUG
	printf("Initierar %dx%d nollmatris.\n",x,y);
	#endif
	koff=alloc(x+1,y+1);
	if(koff==NULL)
	{
		puts("Minnet slut");
		exit(0);
	}
	m=x;
	n=y;
	for(i=1;i<=x;i++)
		for(j=1;j<=y;j++)
			koff[i][j]=0.0;
}
