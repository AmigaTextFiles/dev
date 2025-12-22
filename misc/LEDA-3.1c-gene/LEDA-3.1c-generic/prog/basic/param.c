#include <LEDA/list.h>
#include <LEDA/array.h>


// Any built-in, pointer, item, or user-defined class type can be used 
// as actual type parameter for a parameterized data type. Class types T
// have to provide the following operations:
// 
// a constructor taking no arguments   T::T()
// a copy constructor                  T::T(const T&)
// a Read function                void Read(T&, istream&)
// a Print function               void Print(const T&, ostream&)
// 
// A compare function  "int compare(const T&, const T&)" has to be defined 
// if required by the data type.


class d3_point
{
   float x;
   float y;
   float z;


   public:

   d3_point(float a=0, float b=0, float c=0) { x = a;   y = b;   z = c; }
   d3_point(const d3_point& p)                  { x = p.x; y = p.y; z = p.z; }


   LEDA_MEMORY(d3_point);

   friend istream& operator>>(istream& I, d3_point& p);
   friend ostream& operator<<(ostream& O, const d3_point& p);
   friend int      compare(const d3_point& p, const d3_point& q);

};

istream& operator>>(istream& I, d3_point& p) 
{ return I >> p.x >> p.y >> p.z;}

ostream& operator<<(ostream& O, const d3_point& p)
{ return O << "(" << p.x << "," << p.y << "," << p.z << ")"; }


void Read(d3_point& p, istream& I)        { I >> p; }

void Print(const d3_point& p, ostream& O) { O << p; }

int compare(const d3_point& p, const d3_point& q)  // lexicograph.
{ int b;
  if (b=compare(p.x,q.x)) 
     return b;
  else 
     if (b=compare(p.y,q.y)) 
        return b;
     else 
        return compare(p.z,q.z); 
}


#if !defined(__TEMPLATE_FUNCTIONS__)
LEDA_TYPE_PARAMETER(d3_point)
LEDA_TYPE_PARAMETER(list<d3_point>)
#endif

void Print(const list<d3_point>& L, ostream& O) { L.print(O); }

typedef list<d3_point> LLL;

main()
{
  array<list<d3_point> > A(1,5);

  // array<LLL>  A(1,5);


  for(int i=1;i<=5;i++) A[i].read(string("List[%d]: ",i));
  newline;

  A.print("input:",'\n');
  newline;
  newline;

  for(i=1;i<=5;i++) A[i].permute();
  A.permute();

  A.print("permuted:",'\n');
  newline;
  newline;

  for(i=1;i<=5;i++) A[i].sort();

  A.print("sorted:",'\n');
  newline;
  newline;

  return 0;
 }
