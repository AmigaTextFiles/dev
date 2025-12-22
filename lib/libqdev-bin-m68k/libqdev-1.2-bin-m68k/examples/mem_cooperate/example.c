/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_cooperate()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  FPrintf(Output(),
  "Amazingly we are utilising 100%% of the CPU time, but "
   "other progs run as if there were no load at all!\n");

  FPrintf(Output(), "Press CTRL+C to quit.\n");

  /*
   * As you can see this program really does busy-loop.
   * Run it however and try to do regular stuff in the OS.
  */
  while (1)
  {
    if (SetSignal(0L, 0L) & SIGBREAKF_CTRL_C)
    {
      SetSignal(0L, SIGBREAKF_CTRL_C);

      break;
    }

    mem_cooperate(0, SIGF_SINGLE);    
  }

  return 0;
}
