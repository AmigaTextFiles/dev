/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_findscreensafe()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  UBYTE buf[128];


  /*
   * This function is useful when one wants to find out the name
   * (not title!) of the current public screen.
  */
  if (ctl_findscreensafe("*", buf, sizeof(buf)))
  {
    FPrintf(Output(), "current screen: %s\n", (LONG)buf);
  }

  return 0;
}
