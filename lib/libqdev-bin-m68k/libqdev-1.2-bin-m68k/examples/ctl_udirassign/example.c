/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_udirassign()
 *
*/

#include "../gid.h"

#define VIRTUALPATH "TheVeryLongVirtualPath:"



int GID_main(void)
{
  LONG lock;


  /*
   * Establish the "shortcut" to this directory. This works just
   * like 'Assign' command.
  */
  ctl_udirassign(VIRTUALPATH, "", 0);

  /*
   * Lets check it out...
  */
  if ((lock = Lock(VIRTUALPATH, SHARED_LOCK)))
  {
    FPrintf(Output(), "Success!\n");

    UnLock(lock);
  }

  return 0;
}
