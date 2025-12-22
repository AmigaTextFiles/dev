#include <LEDA/basic.h>
#include <LEDA/stream.h>

main()
{ 

  file_istream IN(read_string("input from file: "));

  string s1 = read_string("replace string :");
  string s2 = read_string("by      string :");
  string s3 = read_char  ("delete  char   :");

  int i=0;
  while (IN)
  { string s;
    s.read_line(IN);
    s = s.replace_all(s1,s2);
    s = s.del_all(s3);
    cout << string("[%2d] ",i++) << s;
    newline;
   }
  newline;

  return 0;
}
