
// col2: filter for two-column output

#include <LEDA/list.h>
#include <LEDA/stream.h>


main()
{
  list<string> L;

  cmd_istream in("expand"); // expand tab's

  while (in)  L.append(read_line(in));

  if (L.length() % 2) L.Pop();

  list_item a = L[0];
  list_item b = L[L.length()/2];

  while(b)
  { int n = 38-L[a].length();
    cout << L[a].head(38);
    while (n-- > 0) cout << " ";
    cout << "   " << L[b].head(38);
    newline;
    a = L.succ(a);
    b = L.succ(b);
   }
}
