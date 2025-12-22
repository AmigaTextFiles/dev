#include <LEDA/int_set.h>
#include <LEDA/list.h>


void print(const int_set& S , int a, int b)
{ for(int i=a;i<=b;i++)
    if (S.member(i)) cout << i << " ";
  newline;
 }


main()

{  

int a = read_int("a = ");
int b = read_int("b = ");

int_set S(a,b);

list<int> L;

L.read("L = ");

int i;
forall(i,L) S.insert(i);

print(S,a,b);

forall(i,L) 
{ S.del(i);
  print(S,a,b);
 }

 return 0;
}
