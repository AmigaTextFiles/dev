#include "LEDA/d2_dictionary.h"



main()
{
  double k1, l1, r1;
  string k2("....."), l2, r2;
  int i, j;
  dic2_item it;

  d2_dictionary<double,string,int> t;

  int MAX = read_int("number of elements = ");
  dic2_item* items = new dic2_item[MAX];

  for (i=0; i<MAX; i++) {
    k1 = 1+random(0,9899)/100.0;
    for( j=0; j<k2.length(); j++ )
      k2[j] = random(97,122);
    items[i] = t.insert( k1, k2, i );
  }

// t.print();

  forall_dic2_items( it, t )
    cout << t.inf(it) << ": (" << t.key1(it) << "," 
         << t.key2(it) << ")" << endl;

  newline;
  cout << "Enter 0 to stop queries!";
  newline;

  while( (l1=read_real(" left(1) = ")) && 
         (r1=read_real("right(1) = ")) ) {
    l2 = read_string(" left(2) = "); r2 = read_string("right(2) = ");

    list<dic2_item> res = t.range_search( l1, r1, l2, r2 );
    forall( it, res )
      cout << t.inf(it) << ": (" << t.key1(it) << "," 
      				 << t.key2(it) << ")" << endl;
  }
  newline;

  cout << "min_key1: " << t.inf(t.min_key1()) << " (" 
       << t.key1(t.min_key1()) << "," << t.key2(t.min_key1()) 
       << ")" << endl;
  cout << "min_key2: " << t.inf(t.min_key2()) << " (" 
       << t.key1(t.min_key2()) << "," << t.key2(t.min_key2()) 
       << ")" << endl;

  cout << "max_key1: " << t.inf(t.max_key1()) << " (" 
       << t.key1(t.max_key1()) << "," << t.key2(t.max_key1()) 
       << ")" << endl;
  cout << "max_key2: " << t.inf(t.max_key2()) << " (" 
       << t.key1(t.max_key2()) << "," << t.key2(t.max_key2()) 
       << ")" << endl;

  print_statistics();

  for (i = 0; i < MAX; i++) {
    t.del( t.key1(items[i]), t.key2(items[i]) );
  }

  delete items;

  return 0;
}
