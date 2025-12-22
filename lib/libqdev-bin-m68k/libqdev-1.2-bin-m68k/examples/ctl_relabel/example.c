/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_relabel()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  /*
   * As trivial as can be.
  */
  ctl_relabel("RAM:", "rAM dISK");

  return 0;
}
