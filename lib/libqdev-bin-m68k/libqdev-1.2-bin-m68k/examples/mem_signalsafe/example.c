/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_signalsafe()
 *
*/

#include "../gid.h"



void mytask(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));  


  Forbid();

  /*
   * This is to show the potential of 'mem_signalsafe()'.
  */
  Wait(SIGBREAKF_CTRL_C);

  Wait(SIGBREAKF_CTRL_C);

  Wait(SIGBREAKF_CTRL_C);

  Wait(SIGBREAKF_CTRL_C);

  Wait(SIGBREAKF_CTRL_C);

  RemTask(SysBase->ThisTask);
}

int GID_main(void)
{
  struct Task *tc;


  tc = CreateTask("mytask", 0, mytask, 4096);

  /*
   * No need to worry whether 'tc' is valid or not. If it
   * does not exist then no loop. This way also no special
   * synchronisation is necessary since 'mem_signalsafe()'
   * will give up only when the task is gone for sure.
   *
   * Warning! This trick will not work for processes that
   * were started from shell which is still up!
  */
  FPrintf(Output(), "tc = 0x%08lx\nWaiting ", (LONG)tc);

  while (mem_signalsafe(tc, SIGBREAKF_CTRL_C))
  {
    /*
     * Prevent OS from being unusable during signal flood.
    */
    mem_cooperate(0, SIGF_SINGLE);

    FPuts(Output(), ".");

    Flush(Output());
  }

  FPuts(Output(), "\nThe task is gone.\n");

  return 0;
}
