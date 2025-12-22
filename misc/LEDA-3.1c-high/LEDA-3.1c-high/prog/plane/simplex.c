
#include <LEDA/simplex.h>



main()
{
  cout << "Maximize               \n";
  cout << "                  |x1| \n";
  cout << "                  |x2| \n";
  cout << "                  |. | \n";
  cout << "(c1 c2 ...  cn) x |. | \n";
  cout << "                  |. | \n";
  cout << "                  |. | \n";
  cout << "                  |xn| \n";
  newline;

  cout << "constraints:\n";
  newline;

  cout << "     <-------  n  -------->                    \n";
  cout << "                                               \n";
  cout << "    |.......................|   |x1|       |b1|\n";
  cout << "    |.......................|   |x2|       |b2|\n";
  cout << "  i |.......         .......|   |. |  <=   |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "                                               \n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "  j |.......    A    .......| x |. |  >=   |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "                                               \n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "    |.......         .......|   |. |       |. |\n";
  cout << "  k |.......         .......|   |. |  ==   |. |\n";
  cout << "    |.......................|   |. |       |. |\n";
  cout << "    |.......................|   |xm|       |bm|\n";
  newline;
  newline;

  int n = read_int("number of variables n = ");
  newline;

  int i = read_int("number of <= relations i = ");
  int j = read_int("number of >= relations j = ");
  int k = read_int("number of == equations k = ");

  int m = i+j+k;

  matrix A(m,n);
  vector b(m);
  vector c(n);

  cout << string("(%d x %d) - Matrix A:\n",m,n);

  for (int z = 0 ; z<m ; z++ )
  { if (z < i) 
       cout << string("<= row %d : ",z);
    else 
       if (z < i+j) 
          cout << string(">= row %d : ",z);
       else 
          cout << string("== row %d : ",z);

   	for (int s = 0 ; s<n ; s++ ) cin >> A(z,s);
   }
  newline;


  cout << string("%d-vector b: ",m);
  cin >> b;
  newline;

  cout << string("%d-vector c: ",n);
  cin >> c;
  newline;


  list<matrix> S = SIMPLEX(A,i,j,k,b,c);


  if (!S.empty())
    S.print ();
  else
    cout << "Keine Loesung !";

}
