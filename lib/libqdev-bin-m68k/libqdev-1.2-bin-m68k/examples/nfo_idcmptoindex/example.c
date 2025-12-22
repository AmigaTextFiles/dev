/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_idcmptoindex()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG index;


  /*
   * Basically this function translates particular IDCMP messages
   * into index values. This is a must when using console screen
   * ('ctl_xxxconscreen()') handlers who get called from handler
   * array.
  */
  index = nfo_idcmptoindex(IDCMP_REFRESHWINDOW);

  FPrintf(Output(), "index = %ld (IDCMP_REFRESHWINDOW)\n", index);

  return 0;
}
