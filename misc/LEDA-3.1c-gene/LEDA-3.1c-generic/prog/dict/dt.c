
#include <LEDA/dictionary.h>

#include <LEDA/impl/ch_hash.h>
#include <LEDA/impl/ch_hash1.h>


void dic_test(dictionary<int,int>& D, int N, int* A, char* name)
{ 
  cout << string("%-12s",name);
  cout.flush();

  float T;
  float T0 = T = used_time();

  for(int i=0; i<N; i++)  D.insert(A[i],0);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  
  { dic_item it = D.lookup(A[i]);
    if (it == nil || D.key(it) != A[i]) error_handler(1,"error in lookup");
   }

  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.del(A[i]);
  cout << string("%10.2f",used_time(T));

  cout << string("%10.2f",used_time(T0));

  if (!D.empty()) cout << " NOT EMPTY !!\n";	

  newline;

  //memory_clear();

}


void dic_test(dictionary<float,float>& D, int N, float* A, char* name)
{ 
  cout << string("%-12s",name);
  cout.flush();

  D.clear();

  float T;
  float T0 = T = used_time();


  for(int i=0; i<N; i++)  D.insert(A[i],0);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.lookup(A[i]);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.del(A[i]);
  cout << string("%10.2f",used_time(T));

  cout << string("%10.2f",used_time(T0));
  newline;

  //memory_clear();
}



main()
{

  _dictionary<int,int,ch_hash> CHH_DIC;
  _dictionary<int,int,ch_hash1> CH1_DIC;

  int    N     = read_int("# keys = ");
  int*   Int   = new int[N];
  int*   Int1  = new int[N];

  //init_random(N);

  float T = used_time();
  for(int i=0; i<N; i++) Int[i] = random(1,10000000);
  cout << string(" init time1 = %.2f sec",used_time(T)) << endl;

  for(i=0; i<N; i++) Int1[i] = i;
  cout << string(" init time2 = %.2f sec",used_time(T)) << endl;


  newline;
  cout << "                insert    lookup    delete     total\n";
  newline;


  dic_test(CHH_DIC,N,Int,"ch_hash");
  dic_test(CH1_DIC,N,Int,"ch_hash1");
 
  return 0;
}


