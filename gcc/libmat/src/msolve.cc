//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix solve(const Matrix& A,const Matrix& b)
{
	#ifdef DEBUG
		puts("Löser ett ekvationssystem.");
	#endif
	
	#ifdef CHECK
		if(A.m!=b.n)
		{
			printf("Felaktiga dimensioner! %d<>%d\n",A.m,b.n);	
			exit(0);
		}
	#endif



	int i,j,o,y;
	float t,p,v;
	Matrix C(A,A.m+1,A.n+1);
	Matrix x(A.m,1);

	C.n+=1;
	for(i=1;i<=C.m;i++)
		C.koff[i][C.n]=b.koff[i][1];

	

	for(o=1;o<=C.m-1;o++)
	{
		for(i=o+1;i<=C.m;i++)
		{
			for(y=o;y<=C.n;y++)
			{
				if((y==o)&&(C.koff[o][o]!=0)) 
					v=C.koff[i][o]/C.koff[o][o];
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
				printf("v=%f o=%d i=%d y=%d\n",v,o,i,y);
				#endif
				C.koff[i][y]-=v*C.koff[o][y];
				
			}
		}
	}

	for(i=C.m;i>=1;i--)
	{
		if(C.koff[i][i]==0)
			t=1;
		else
			t=C.koff[i][i];	
	
		p=0;
		for(j=C.m;j>=i+1;j--)
			p+=x.koff[j][1]*C.koff[i][j];
	
		x.koff[i][1]=(C.koff[i][C.n]-p)/t;
	}
	return(x);
}