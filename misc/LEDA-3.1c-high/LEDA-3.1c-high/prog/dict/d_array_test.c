#include <LEDA/d_array.h>
#include <LEDA/list.h>

#include <LEDA/impl/avl_tree.h>
#include <LEDA/impl/rb_tree.h>
#include <LEDA/impl/skiplist.h>
#include <LEDA/impl/ch_hash.h>


#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_d_array,int,int,avl_tree)
declare3(_d_array,int,int,rb_tree)
declare3(_d_array,int,int,skiplist)
declare3(_d_array,int,int,ch_hash)
#endif

void d_array_test(d_array<int,int>& count, list<int>& L, char* name)
{ 
  int min;
  int max;
  int x;

  cout << string("%-10s",name);
  cout.flush();

  float T = used_time();


  forall(x,L) count[x]++;

  min = max = L.head();

  forall(x,L)
  { if (count[x] > count[max]) max = x;
    if (count[x] < count[min]) min = x;
   }

  cout << "min: " << min << " appears " << count[min] << " times, ";
  cout << "max: " << max << " appears " << count[max] << " times. ";
  cout << string("   (%8.2f sec)",used_time(T));
  newline;
}


main()
{
   d_array<int,int>           RS_ARRAY(0);

#if defined(__TEMPLATE_ARGS_AS_BASE__)
  _d_array<int,int,avl_tree>  AVL_ARRAY(0);
  _d_array<int,int,rb_tree>   RB_ARRAY(0);
  _d_array<int,int,ch_hash>   CH_ARRAY(0);
  _d_array<int,int,skiplist>  SK_ARRAY(0);
#else
  _d_array(int,int,avl_tree)  AVL_ARRAY(0);
  _d_array(int,int,rb_tree)   RB_ARRAY(0);
  _d_array(int,int,ch_hash)   CH_ARRAY(0);
  _d_array(int,int,skiplist)  SK_ARRAY(0);
#endif

  int N = read_int("# keys = ");

  list<int> L;

  while(N--) L.append(random(1,100));

  d_array_test(AVL_ARRAY,L,"avl_tree");
  d_array_test(RS_ARRAY,L,"rs_tree");
  d_array_test(RB_ARRAY,L,"rb_tree");
  d_array_test(CH_ARRAY,L,"ch_hash");
  d_array_test(SK_ARRAY,L,"skiplist");
 
  return 0;
}

