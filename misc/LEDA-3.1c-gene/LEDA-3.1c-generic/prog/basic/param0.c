#include <LEDA/list.h>



class D3_POINT
{
   double x;
   double y;
   double z;

   public:

   D3_POINT() { x = y = z = 0; }

   friend istream& operator>>(istream& I, D3_POINT*& p)
   { p = new D3_POINT; 
     I >> p->x >> p->y >> p->z; 
     return I; 
    }

   friend ostream& operator<<(ostream& O, D3_POINT* p)
   { O << "(" << p->x << "," << p->y << "," << p->z << ")"; 
     return O; 
    }

   friend int compare(D3_POINT*, D3_POINT*);


 };


int compare(D3_POINT* p, D3_POINT* q) 
{ int b;
  if (b=compare(p->x,q->x)) 
     return b;
  else 
     if (b=compare(p->y,q->y)) 
        return b;
     else 
        if (b=compare(p->z,q->z)) 
           return b;
        else 
           return 0;
 }



typedef D3_POINT* d3_point;



main()
{
  list<d3_point> L;

  L.read("L: ");
  newline;

  L.print("input:");
  newline;

  L.permute();
  L.print("permuted:");
  newline;

  L.sort();
  L.print("sorted:");
  newline;

  return 0;
}
