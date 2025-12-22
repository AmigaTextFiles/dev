/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_dosynctask()
 *
*/

#include "../gid.h"

#define NEWTASKNAME   "mydummytask"
#define NEWTASKPRI       0
#define NEWTASKSTACK  4096



void mydummytask(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));


  Wait(SIGBREAKF_CTRL_C);

  Forbid();

  RemTask(SysBase->ThisTask);
}

int GID_main(void)
{
  struct Task *tc;
  LONG sigwait;


  /*
   * 1. Lets create the child task and lets see if we 
   * can get the tc_SigWait immediately. We will have
   * to buffer it not to cause accidental task switch
   * by using 'FPrintf()'.
  */
  if ((tc = CreateTask(NEWTASKNAME,
                 NEWTASKPRI, mydummytask, NEWTASKSTACK)))
  {
    sigwait = tc->tc_SigWait;

    FPrintf(Output(),
                  "1. tc_SigWait = 0x%08lx ?= 0x%08lx\n",
                              sigwait, SIGBREAKF_CTRL_C);

    Signal(tc, SIGBREAKF_CTRL_C);
  }


  /*
   * 2. And now lets try again with 'mem_dosynctask()'.
  */
  if ((tc = CreateTask(NEWTASKNAME,
                 NEWTASKPRI, mydummytask, NEWTASKSTACK)))
  {
    /*
     * Attempt synchronisation. Basically we will resume
     * as soon as the 'tc' calls 'Wait()'.
    */
    mem_dosynctask((ULONG)tc);

    /*
     * Now you should really disable interrupts, so the
     * task will be frozen.
    */
    QDEV_HLP_NOINTSEC
    (
      sigwait = tc->tc_SigWait;
    );

    /*
     * Allow others to function normally. This has to be
     * called!
    */
    mem_dosynctask(NULL);

    FPrintf(Output(),
                  "2. tc_SigWait = 0x%08lx ?= 0x%08lx\n",
                              sigwait, SIGBREAKF_CTRL_C);

    Signal(tc, SIGBREAKF_CTRL_C);
  }

  return 0;
}
