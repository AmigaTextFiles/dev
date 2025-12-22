/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_stackreport()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct Task *tc;
  LONG badstack;
  LONG freestack;


  /*
   * Report how much stack is yet free. If you were to
   * implement such function using tc_SPReg you would
   * face the problem of it to be invalid since there
   * is no context switch at this point ;-) .
  */
  tc = FindTask(NULL);

  badstack =
          (LONG)tc->tc_SPReg - (LONG)tc->tc_SPLower;

  /*
   * And this little thing shows it right. Why oh why?
   * We enforce atomic context toggle. That is why.
  */
  freestack = nfo_stackreport(NULL);

  FPrintf(Output(), "badstack = %ld\n", badstack);

  FPrintf(Output(), "freestack = %ld\n", freestack);

  return 0;
}
