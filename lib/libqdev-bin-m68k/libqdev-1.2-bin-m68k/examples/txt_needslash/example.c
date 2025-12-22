/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_needslash()
 *
*/

#include "../gid.h"

#define PATH1   "parent:"
#define PATH2   "parent:subdir/"
#define PATH3   "parent:subdir"
#define PATH4   "subdir"
#define PATH5   "subdir/subdir/"
#define PATH6   "subdir/subdir"
#define PATH7   ""
#define FILE    "file"



int GID_main(void)
{
  UBYTE *paths[] =
  {
    PATH1,
    PATH2,
    PATH3,
    PATH4,
    PATH5,
    PATH6,
    PATH7,
    NULL
  };
  UBYTE slash[2] = {NULL, NULL};
  UBYTE **array = paths;


  while(*array)
  {
    slash[0] = txt_needslash(*array);

    FPrintf(Output(), "%s%s%s\n",
                 (LONG)*array, (LONG)slash, (LONG)FILE);

    array++;
  }

  return 0;
}
