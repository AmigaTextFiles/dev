
// This programs is using dictionaries with keys of type "string" with two 
// different linear orders, the lexicographic ordering  (default ordering)
// and the reversed lexicographic ordering 


#include <LEDA/dictionary.h>

int cmp_rev(const string& x, const string& y) { return compare(y,x); }

int cmp_length(const string& x, const string& y) 
{ return compare(x.length(),y.length()); }

DEFINE_LINEAR_ORDER(string,cmp_rev,string_r)
DEFINE_LINEAR_ORDER(string,cmp_length,string_l)




main()
{
  dictionary<string,int>    D;
  dictionary<string_r,int>  D_rev;
  dictionary<string_l,int>  D_length;

  string x;

  while (cin >> x) 
  { D.insert(x,0);
    D_rev.insert(x,0);
    D_length.insert(x,0);
   }

  dic_item it;

  forall_items(it,D) cout << D.key(it)  << "\n";
  newline;

  forall_items(it,D_rev) cout << D_rev.key(it)  << "\n";
  newline;

  forall_items(it,D_length) cout << D_length.key(it)  << "\n";
  newline;

  return 0;
}

