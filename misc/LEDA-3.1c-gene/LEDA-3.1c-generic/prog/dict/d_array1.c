#include <LEDA/d_array.h>


main()
{ 
  d_array<string,int> N(0);

  string s;

  while (cin >> s) N[s]++;

  forall_defined (s,N) cout << s << " " << N[s] << "\n";

  return 0;
}

