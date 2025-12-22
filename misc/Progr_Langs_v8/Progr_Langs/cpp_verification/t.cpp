#include <iostream.h>

// Template verification

template<class T> void swap(T &a, T &b)
{
  T c;
  c = a;
  a = b;
  b = c;
}

void main()
{
  int a, b;
  a = 2;
  b = 5;
  cout << "before swap(): " << a << ":" << b << endl;
  swap(a, b);
  cout << "after swap(): " << a << ":" << b << endl;
}
