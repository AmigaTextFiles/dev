/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_setclistack()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG stack;


  /*
   * By setting new CLI stack one assumes that all lately started
   * proggies will be having this kind of stack. Verify with the
   * 'stack' command.
  */
  stack = 6128;

  ctl_setclistack(stack);

  FPrintf(Output(), "Stack set to %ld bytes\n", stack);

  return 0;
}
