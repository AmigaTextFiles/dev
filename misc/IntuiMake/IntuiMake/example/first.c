/* first.c
**
**
*/

 #include "headerfile.h"
/* SCAN_END */

void Test1 (char *message, long var)
{
  struct MyStruct mystruct = {1, 2L};

  printf ("%s %d\n%d\n%d\n", message, mystruct.a, mystruct.b, var);
}