//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"

void Matrix::read()
{
	int i,j;
	#ifdef DEBUG
	puts("Läser in matris.");
	#endif
	for(i=1;i<=m;i++)
	{
		for(j=1;j<=n;j++)
		{
			scanf("%f",&(koff[i][j]));
		}
	}
}
