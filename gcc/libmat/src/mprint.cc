//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

void Matrix::print()
{
	int i,j;
	#ifdef DEBUG
	puts("Skriver ut matris.");
	printf("Storlek:%d X %d\n",m,n);
	#endif
	for(i=1;i<=m;i++)
	{
		for(j=1;j<=n;j++)
		{
			printf("%g ",koff[i][j]);
		}
		printf("\n");
	}
}	
