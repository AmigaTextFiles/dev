#include <LEDA/hash.h>


int hash_fun(const string& x) { return int(x[0]); }

main()
{
  hash<string,int> D(hash_fun);

  hash_item it;
  string r;

  while (cin >> r)
    { it = D.lookup(r);
      if (it==nil) D.insert(r,1);
      else D.change_inf(it,D.inf(it)+1);
     }

  forall_items(it,D) cout <<  D.inf(it) << " " << D.key(it) << "\n";

  return 0;
}

