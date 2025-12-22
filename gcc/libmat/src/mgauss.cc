//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix gauss(const Matrix& A)
{


	int o=1,x,y,i,j;
	float v;
	Matrix C(A);

	#ifdef DEBUG 
	printf("Gausseliminerar matris.\n");
	#endif

	for(o=1;o<=A.m-1;o++)
	{
		for(x=o+1;x<=A.m;x++)
		{
			for(y=o;y<=A.n;y++)
			{
				if((y==o)&&(C.koff[o][o]!=0)) 
					v=C.koff[x][o]/C.koff[o][o];
				else if(C.koff[o][o]==0)
				{
					for(i=o+1;i<=A.m;i++)
					{
						if(C.koff[i][o]!=0)
						{
							for(j=o;j<=A.n;j++)
								C.koff[o][j]+=C.koff[i][j];//lägg till rad till rad
							i=A.m;						   // bryt slingan
						}
					}
				}
							
				#ifdef DEBUG
				printf("v=%f o=%d x=%d y=%d\n",v,o,x,y);
				#endif
				
				C.koff[x][y]-=v*C.koff[o][y];
			}
		}
	}
	return(C);
}
