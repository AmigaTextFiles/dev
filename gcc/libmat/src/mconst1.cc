//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix::Matrix(float **mat,int x,int y)
{
	#ifdef DEBUG
	printf("Initierar matris från en array.Storlek: %dx%d\n",x,y);
	#endif
	int i,j;
	koff=alloc(x+1,y+1);
	if(koff==NULL)
	{
		printf("Minnet slut\n");
		exit(0);
	}
	m=x;
	n=y;
	for(i=1;i<=x;i++)
		for(j=1;j<=y;j++)
			koff[i][j]=mat[i][j];
}
