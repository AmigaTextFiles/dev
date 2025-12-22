#include <LEDA/list.h>

class pair {

 double  x;
 double  y;

public:

pair() { x = y = 0; }
pair(const pair& p) { x = p.x; y = p.y; }

friend istream& operator>>(istream& is, pair& p)
{ return is >> p.x >> p.y; }

friend ostream& operator<<(ostream& os, const pair& p)
{ return os << p.x << " " << p.y; }

friend int compare(const pair&, const pair&);

};

void Print(const pair& p, ostream& out)  { out << p; } 
void Read(pair& p, istream& in)  { in >> p; } 


int    compare(const pair& p, const pair& q)
{  if (p.x < q.x) return -1; 
   if (p.x > q.x) return  1; 
   if (p.y < q.y) return -1; 
   if (p.y > q.y) return  1; 
   return 0;  
}


#if !defined(__TEMPLATE_FUNCTIONS__)
LEDA_TYPE_PARAMETER(pair)
#endif


main()
{
   list<pair> L;

   L.read("list of pairs: ");
   L.sort();
   L.print("sorted:\n",'\n');

 }


