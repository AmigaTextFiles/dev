#include <LEDA/basic.h>
#include <LEDA/list.h>


int ord(const int& x) { return x%1000; }

int main () 
{
  list<int>     L;
  list<int>     L1;
  list<double>   L2;

  int i;

  int N = read_int("Number of list entries: "); 

  float T = used_time();

  cout << "allocating    ";
  cout.flush();
  for (i = 0; i < N; i++) L.append(random(1,10000));
  cout << string("  %5.3f sec",used_time(T));
  newline;


  cout << "reversing     ";
  cout.flush();
  while (!L.empty()) L1.push(L.pop());
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "assignment    ";
  cout.flush();
  L = L1;
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting(int)  ";
  cout.flush();
  L.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting again ";
  cout.flush();
  L.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;


  cout << "iteration     ";
  cout.flush();
  forall(i,L) {}
  cout << string("  %5.3f sec",used_time(T));
  newline;

  forall(i,L) L2.append(i);

  cout << "sorting(double)";
  cout.flush();
  L2.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;


  cout << "sorting again ";
  cout.flush();
  L2.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;



  cout << "test sorting  ";
  cout.flush();
  forall(i,L)
  { double f = L2.pop();
    if (i != f)  cout << string("%d  != %f\n",i,f);
   }
  cout << string("  %5.3f sec",used_time(T));
  newline;
  
  cout << "bucket sort   ";
  cout.flush();
  L.bucket_sort(0,1000,ord);
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "clear         ";
  cout.flush();
  L.clear();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  newline;
  cout << "used memory = " << used_memory()/1024.0 << " kb\n";

  return 0;
}
