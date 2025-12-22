#include <LEDA/p_dictionary.h>
#include <LEDA/list.h>
#include <math.h>


typedef p_dictionary<float,string> PDIC;


main()
{
  p_dictionary<float,string> Dic;

  list<PDIC>  L;

  int n = read_int("n = ");


  for(int i = 1; i<n; i++) 
  {  Dic = Dic.insert(sqrt(i),string("sqrt(%d)",i));
     L.append(Dic);
   }


  forall(Dic,L) 
  { p_dic_item it;
    forall_items(it,Dic)  cout << Dic.inf(it) << "=" <<  Dic.key(it) << " ";
    newline;
   }

  return 0;
}
