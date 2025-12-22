/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_issegremote()
 *
*/

#include "../gid.h"

#define NEWTASKNAME   "mydummytask"
#define NEWTASKPRI       0
#define NEWTASKSTACK  4096



void checkseg(UBYTE *name, struct Task *tc)
{
  LONG pc;


  if ((pc = nfo_issegremote((void *)tc)))
  {
    FPrintf(Output(),
        "The '%s' is code segment less(pc = 0x%08lx)!\n",
                                         (LONG)name, pc);
  }
  else
  {
    FPrintf(Output(),
       "The '%s' uses own code segment(pc = 0x%08lx).\n",
                                         (LONG)name, pc);
  }
}

void mydummytask(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));


  Wait(SIGBREAKF_CTRL_C);

  Signal(SysBase->ThisTask->tc_UserData, SIGF_SINGLE);

  Wait(SIGBREAKF_CTRL_C);

  Forbid();

  RemTask(SysBase->ThisTask);
}

int GID_main(void)
{
  struct Task *tc;
  struct Task *ttc;


  /*
   * Lets create the child task as a reference.
  */
  if ((tc = CreateTask(NEWTASKNAME,
                NEWTASKPRI, mydummytask, NEWTASKSTACK)))
  {
    /*
     * This will be holding pointer to us, the parent.
    */
    ttc = FindTask(NULL);

    /*
     * Lets synchronise the child first, so that PC will
     * be sane.
    */
    tc->tc_UserData = ttc;

    SetSignal(0, SIGF_SINGLE);

    Signal(tc, SIGBREAKF_CTRL_C);

    Wait(SIGF_SINGLE);

    /*
     * OK, lets see how this magic function works... If
     * works at all =) .
    */
    checkseg("tc", tc);

    checkseg("ttc", ttc);

    Signal(tc, SIGBREAKF_CTRL_C);
  }

  return 0;
}
