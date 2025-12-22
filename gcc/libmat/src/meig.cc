//				MATRIX LIB
//			TOMMY JOHANSSON 1995

#include "matrix.h"
Matrix eigen(const Matrix & A)
{
	Matrix C(A);
	Matrix L(A.m);
	Matrix R(A.m);
	Matrix temp(A.m,1);
	int i,ch=A.m;
	while(ch>1)
	{
		if(fabs(C.koff[ch][1])<EPS) ch--;
		LR(C,L,R);
		C=R*L;
	}
	for(i=1;i<=A.m;i++)
		temp.koff[i][1]=C.koff[i][i];
	return(temp);
}
	