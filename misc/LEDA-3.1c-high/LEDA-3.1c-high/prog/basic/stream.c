#include <LEDA/basic.h>
#include <LEDA/stream.h>
#include <LEDA/list.h>


main(int argc, char* argv[])
{
  string_istream args(argc,argv);

  list<string> L;

  string s;

  while(args >> s) cout << s << "\n";
  newline;

  cmd_istream IN(read_string("cmd = "));

  while (IN) L.append(read_line(IN));

  L.print('\n');
  newline;

  cmd_ostream OUT("more");

  L.print(OUT,'\n');
  OUT.flush();

  return 0;
}


    
