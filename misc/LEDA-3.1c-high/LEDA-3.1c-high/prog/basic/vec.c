#include <LEDA/matrix.h>
#include <LEDA/array.h>



main()
{

  array<vector> A(5);
  array<matrix> B(5);

  A.print("A = ",'\n');
  newline;
  newline;

  B.print("B = ");
  newline;

  int i;
  for(i = 0; i < 5; i++) A[i] = vector(i);
  for(i = 0; i < 5; i++) B[i] = matrix(i,i);

  A.print("A = ",'\n');
  newline;
  newline;

  B.print("B = ");
  newline;

  return 0;
}
