/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_getwbstartup()
 *
*/

/*
 * Activate CLI boomerang, so that copy of WBenchMsg will
 * be accessible.
*/
#define ___QDEV_LIBINIT_CLIONLY ___QDEV_LIBINIT_CLISTREAM

#include "../gid.h"



int GID_main(void)
{
  struct WBStartup *sm;


  /*
   * The only valid members of 'sm' here are 'sm_NumArgs'
   * and 'sm_ArgList' !
  */
  if ((sm = mem_getwbstartup(NULL)))
  {
    FPrintf(Output(), "I was started from Workbench!\n");
  }
  else
  {
    FPrintf(Output(), "I was started from plain CLI!\n");
  }

  return 0;
}
