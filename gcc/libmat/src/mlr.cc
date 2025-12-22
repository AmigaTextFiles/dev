//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
void LR(const Matrix & A,Matrix & L,Matrix & R)
{
	
	int o=1,x,y,i,j;
	float v;

	#ifdef DEBUG 
	printf("LR-faktoriserar matris.\n");
	#endif
	R=A;
	L=I(A.m);
	for(o=1;o<=A.m-1;o++)
	{
		for(x=o+1;x<=A.m;x++)
		{
			for(y=o;y<=A.n;y++)
			{
				if((y==o)&&(R.koff[o][o]!=0)) 
					v=R.koff[x][o]/R.koff[o][o];
				else if(R.koff[o][o]==0)
				{
					for(i=o+1;i<=A.m;i++)
					{
						if(R.koff[i][o]!=0)
						{
							for(j=o;j<=A.n;j++)
								R.koff[o][j]+=R.koff[i][j];//lägg till rad till rad
							i=A.m;						   // bryt slingan
						}
					}
				}
				#ifdef DEBUG
				printf("v=%f o=%d x=%d y=%d\n",v,o,x,y);
				#endif
				R.koff[x][y]-=v*R.koff[o][y];
				L.koff[x][o]=v;

			}
		}
	}
}


