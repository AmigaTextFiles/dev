/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isinstack()
 *
*/

#include "../gid.h"



LONG addr1 = 0;



void tellstack(UBYTE *name, void *addr)
{
  if (nfo_isinstack(FindTask(NULL), addr))
  {
    FPrintf(Output(),
      "Var = %s is in stack of this task.\n", (LONG)name);
  }
  else
  {
    FPrintf(Output(),
     "Var = %s not in stack of this task.\n", (LONG)name);
  }
}

/*
 * I know this example is not very sophisticated, but at
 * least shows what can be expected. You can use this func.
 * to detect numerous things of other tasks, but do not
 * forget to Disable() and then Enable() so that the check
 * will be accurate!
 * 
*/
int GID_main(void)
{
  LONG addr2 = 0;


  tellstack("addr1", &addr1);

  tellstack("addr2", &addr2);

  return 0;
}
