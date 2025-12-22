/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_clirun()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  /*
   * This function wraps 'SystemTags' but the argument input
   * is greatly reduced.
  */
  ctl_clirun("avail", NULL, FALSE);

  return 0;
}
