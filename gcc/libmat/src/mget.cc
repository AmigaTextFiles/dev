#include <matrix.h>
Matrix Matrix::operator [] (int t)
{
	Matrix x(m,1);
	int i;
	for(i=1;i<=m;i++)
		x.koff[i][1]=koff[i][t];
	x.n=m;
	return(x);
}