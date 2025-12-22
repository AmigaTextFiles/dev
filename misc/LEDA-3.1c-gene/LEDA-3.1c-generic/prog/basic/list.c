#include <LEDA/list.h>
#include <LEDA/stream.h>




int cmp_inv(const string& x, const string& y)    { return compare(y,x); }

int cmp_length(const string& x, const string& y) 
{ return x.length() - y.length(); }

int ord(const string& x)   { return (x.length() > 0) ? int(x[0]) : 0;}

void upper_case(string& x)
{ int d = 'A' - 'a';
  for(int i=0; i<x.length(); i++) 
    if (x[i] >= 'a' && x[i] <= 'z') x[i] += d;
 }


main()
{ 
  string fname = read_string("file: ");

  list<string> L;

  if (fname == "cin")
     L.read("L = ");
  else
     L.read(file_istream(fname));

  L.permute();


// sort lexicographically

  L.sort();   // compare(string,string) used
  L.print("sorted lexicographically:\n",'\n');
  newline;
  newline;

// sort decreasing

  L.sort(cmp_inv);
  L.print("sorted decrasing:\n",'\n');
  newline;
  newline;


// sort by length

  L.sort(cmp_length);
  L.print("sorted by length:\n",'\n');
  newline;
  newline;



// bucket_sort by first character

  L.bucket_sort(0,255,ord);
  L.print("sorted by s[0]:\n",'\n');
  newline;
  newline;


// turn characters to upper case

  L.apply(upper_case);
  L.print("upper case:\n",'\n');
  newline;

  newline;
  cout << "used memory = " << used_memory() << " bytes\n";

  return 0;
}
