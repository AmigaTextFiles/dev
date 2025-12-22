#include <matrix.h>
main()
{
	Matrix f(2,1);
	Matrix x(2,1);
	x.print();
	Matrix A(2);
	A.read();
	x.read();
	x.print();
	(x/A).print();
}