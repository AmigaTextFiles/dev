#include <LEDA/matrix.h>

main()

{ 
  int d = read_int("dimension = ");

  matrix       A(d,d);
  matrix       I(d,d);
  double       det;


  init_random();

  for(int i=0;i<d;i++)
    for(int j=0;j<d;j++)
      A(i,j) = double(random(-1000,1000))/100;

  float T = used_time();


  cout << "A.inv():  ";
  cout.flush();
  I =  A.inv();
  cout << string("%5.2f sec\n",used_time(T));

  cout << "A.det():  ";
  cout.flush();
  det = A.det();
  cout << string("%5.2f sec \n",used_time(T));
  newline;

/*
  cout << "A*A.inv() = \n" << A*I << "\n";
  newline;
*/

  while (Yes("A.solve(v) ? "))
  {
    vector v(d), x(d), y(d);

    for(int i=0;i<d;i++) v[i] = double(random(-1000,1000))/100;
    
    used_time(T);
    x = A.solve(v);
    cout << string("time for solve:  %5.2f \n",used_time(T));
    newline;

    cout << "v   = " << v   << "\n";
    cout << "A*x = " << A*x << "\n";
    newline;
  }

  return 0;

}
