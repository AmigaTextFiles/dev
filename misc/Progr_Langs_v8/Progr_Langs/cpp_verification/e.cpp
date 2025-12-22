#include <iostream.h>

// Exceptions verification

void main()
{
  float a = 3;
  float b = 0;
  float c;
  try
  {
    if(b == 0) throw "division by zero\n";
    c = a / b;
    cout << c << endl;
  }
  catch(...)
  {
    cout << "Exception ocurred." << endl;
  }
}
