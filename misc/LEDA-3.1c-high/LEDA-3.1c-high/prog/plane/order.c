
// This programs is using dictionaries with keys of type "point" with two 
// different linear orders, the lexicographic ordering on the cartesian 
// coordinates (default ordering) and the lexicographic ordering on the
// polar coordinates.

// must be linked with   libP.a libG.a libL.a -lm   !!!


#include <LEDA/dictionary.h>
#include <LEDA/plane.h>


int pol_cmp(point x, point y) 
{
  // defines lexicographic order of the polar coordinates
  
  point origin(0,0);
  segment sx(origin,x), sy(origin,y);
  int c = compare(sx.angle(), sy.angle());  // predefined compare(double,double)
  if (c) return c;
  return compare(sx.length(),sy.length()); 
  
 }


DEFINE_LINEAR_ORDER(point,pol_cmp,point_pol)

// Now "point_pol" is equivalent to the data type  point
// with the linear order defined by "pol_cmp".





main()
{
  dictionary<point,int>      D;
  dictionary<point_pol,int>  D_pol;

  point x;

  while (cin >> x) 
  { D.insert(x,0);
    D_pol.insert(x,0);
   }

  dic_item it;

  forall_items(it,D) cout << D.key(it)  << "\n";
  newline;

  forall_items(it,D_pol) cout << D_pol.key(it)  << "\n";
  newline;

}
