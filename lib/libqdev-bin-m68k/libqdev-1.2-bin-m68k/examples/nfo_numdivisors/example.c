/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_numdivisors()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  FPrintf(Output(), "%ld\n", nfo_numdivisors(1456));

  FPrintf(Output(), "%ld\n", nfo_numdivisors(65124));

  FPrintf(Output(), "%ld\n", nfo_numdivisors(872312));

  return 0;
}
