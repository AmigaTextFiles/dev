/* second.c
**
**
*/

#include "headerfile.h"
/* SCAN_END */

void Test2 (char *message)
{
  struct MyStruct mystruct = {3, 4L};

  printf ("%s %d\n%d\n", message, mystruct.a, mystruct.b);
}