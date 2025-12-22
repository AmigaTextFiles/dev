/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_lockscreensafe()
 * ctl_unlockscreensafe()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct Screen *screen;


  /*
   * This function pair can easily be used to detect screen
   * presence without forcing it to open.
  */
  if ((screen = ctl_lockscreensafe(NULL)))
  {
    FPrintf(Output(), "The Workbench screen is opened!\n");

    ctl_unlockscreensafe(screen);
  }
  else
  {
    FPrintf(Output(), "Looks like Workbench is closed.\n");
  }

  return 0;
}
