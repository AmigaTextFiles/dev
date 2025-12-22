#include <matrix.h>
main()
{
	Matrix A(2);
	Matrix r(2,1);
	A.read();
	r=eigen(A);
	r.print();
}