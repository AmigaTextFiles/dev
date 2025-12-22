#include <LEDA/vector.h>
#include <LEDA/matrix.h>
#include <LEDA/list.h>



main()

{ 
  int d = read_int("dimension = ");

  matrix       A(d,d);
  vector       b(d);
  vector       x(d);

  list<vector> B;  // List of b-vectors
  list<vector> X;  // List of x-vectors

  printf("give (%d x %d) - matrix A:\n",d,d);

  cin >> A;

  cout << "A = \n";
  cout << A << "\n";
  newline;

  cout << "A.trans() = \n";
  cout << A.trans() << "\n";
  newline;


  cout << "A.inv() = \n";
  cout << A.inv() << "\n";
  newline;

  cout << "A*A.inv() = \n";
  cout << A*A.inv() << "\n";
  newline;
  

  cout << "We solve the system of linear equations A*x = b.\n";
  cout << "Give a list of vectors b (terminated by ctrl-d):\n";

  while (cin >> b) B.append(b);
  newline;

  B.print("b's = ",'\n');
  newline;
  newline;

  forall(b,B)  X.append(A.solve(b));
  
  X.print("x's = ",'\n');
  newline;
  newline;


  cout << "A*x's = \n";
  forall(x,X) cout << A*x << "\n";
  newline;
 
  return 0;
}
