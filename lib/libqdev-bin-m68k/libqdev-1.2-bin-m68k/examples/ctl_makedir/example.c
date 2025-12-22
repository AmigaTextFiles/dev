/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_makedir()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  /*
   * Creating directory without the need to free the lock
   * may be very handy,
  */
  if (!(ctl_makedir("mydirectory")))
  {
    FPrintf(Output(),
                "ERROR: Cannot create the directory!\n");
  }

  return 0;
}
