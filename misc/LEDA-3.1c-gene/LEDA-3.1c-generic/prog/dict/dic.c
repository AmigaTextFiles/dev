#include <LEDA/dictionary.h>


main()
{
  dictionary<string,int> D;

  dic_item it;
  string s;

  while (cin >> s)
  { it = D.lookup(s);
    if (it==nil) D.insert(s,1);
    else D.change_inf(it,D.inf(it)+1);
   }

  forall_items(it,D) 
    cout <<  D.key(it) << " : " << D.inf(it) << "\n";


  return 0;
}

