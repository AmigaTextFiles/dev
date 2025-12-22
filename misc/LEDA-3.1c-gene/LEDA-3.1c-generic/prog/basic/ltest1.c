#include <LEDA/basic.h>
#include <LEDA/list.h>

typedef int* int_ptr;


int main () 
{
  list<int_ptr>     L;
  list<int_ptr>     L1;

  int i;
  int_ptr p;

  int N = read_int("Number of list entries: "); 

  float T = used_time();

  cout << "allocating    ";
  cout.flush();
  for (i = 0; i < N; i++) L.append((int_ptr)random(1,10000));
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

  cout << "iteration     ";
  cout.flush();
  forall(p,L) {}
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "clear         ";
  cout.flush();
  L.clear();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  return 0;
}
