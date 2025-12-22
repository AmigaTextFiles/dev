#include <matrix.h>
main()
{
	Matrix A(4);
	Matrix B(4);
	A.read();
	printf("det=%g\n",det(A));
	B=gauss(A);
	printf("det=%g\n",det(B));
	B.print();
}
