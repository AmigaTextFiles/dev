/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_ischildofproc()
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

  Signal(SysBase->ThisTask->tc_UserData, SIGF_SINGLE);

  Wait(SIGBREAKF_CTRL_C);

  Forbid();

  RemTask(SysBase->ThisTask);
}

/*
 * As for this example usage and behaviour seem really
 * simple and predictible. This function really takes a
 * guess ;-], so typical application is rather gamble,
 * but 'dos_devunmount()' makes use of it and for its
 * needs it does the job almost flawlessly.
*/
int GID_main(void)
{
  struct Task *tc;
  struct Process *pr;


  /*
   * Lets create the child task for the test.
  */
  if ((tc = CreateTask(NEWTASKNAME,
                NEWTASKPRI, mydummytask, NEWTASKSTACK)))
  {
    /*
     * This will be holding pointer to us, the parent.
    */
    pr = (void *)FindTask(NULL);

    /*
     * Lets synchronise the child first, so that PC will
     * settle.
    */
    tc->tc_UserData = pr;

    SetSignal(0, SIGF_SINGLE);

    Signal(tc, SIGBREAKF_CTRL_C);

    Wait(SIGF_SINGLE);

    /*
     * OK, lets see how this magic function works... If
     * works at all =) .
    */
    if (nfo_ischildofproc(tc, pr))
    {
      FPrintf(Output(),
        "'tc' = 0x%08lx is a child of 'pr' = 0x%08lx\n",
                                    (LONG)tc, (LONG)pr);
    }
    else
    {
      FPrintf(Output(),
       "Well, looks like 'tc' is not 'pr's child...\n");
    }

    Signal(tc, SIGBREAKF_CTRL_C);
  }

  return 0;
}
