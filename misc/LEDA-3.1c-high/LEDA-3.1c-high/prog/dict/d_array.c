#include <LEDA/d_array.h>



void print(d_array<string,string>& A)
{ string s;
  forall_defined(s,A) cout << s << "  " << A[s] << "\n";
 }

main()
{ 
  d_array<string,string> trans, D;

  trans["hello"]  = "hallo";
  trans["world"]  = "Welt";
  trans["book"]   = "Buch";
  trans["coffee"] = "Kaffee";
  trans["hello"]  = "xyz";


  D = trans;  // makes a copy

  print(D);
  newline;

  return 0;
}
