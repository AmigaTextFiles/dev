/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isconsole()
 *
*/

#include "../gid.h"

#define TEXT1 "console:"
#define TEXT2 "*"
#define TEXT3 "nil:"



int GID_main(void)
{
  if (nfo_isconsole(TEXT1, sizeof(TEXT1) - 1))
  {
    FPrintf(Output(), "Yes sir!\n");
  }

  if (nfo_isconsole(TEXT2, sizeof(TEXT2) - 1))
  {
    FPrintf(Output(), "Yes sir!\n");
  }

  if (!nfo_isconsole(TEXT3, sizeof(TEXT3) - 1))
  {
    FPrintf(Output(), "No sir!\n");
  }

  return 0;
}
