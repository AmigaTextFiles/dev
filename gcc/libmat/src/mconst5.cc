//					MATRIX LIB
//				TOMMY JOHANSSON
#include "matrix.h"
Matrix::Matrix(const Matrix& A,int x,int y)
{
	#ifdef DEBUG
	puts("Initierar matris från en annan med nya dimensioner.");
	#endif

	int i,j;
	koff=alloc(x+1,y+1);
	m=A.m;
	n=A.n;
	for(i=1;i<=x;i++)
		for(j=1;j<=y;j++)
		{
			if((i<=m)&&(j<=n))
				koff[i][j]=A.koff[i][j];
			else
				koff[i][j]=0;
		}
}		
