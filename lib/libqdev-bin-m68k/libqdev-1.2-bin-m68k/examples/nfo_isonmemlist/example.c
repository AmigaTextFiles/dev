/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isonmemlist()
 * nfo_isonlistofml()
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

/*
 * The routines presented in this example allow to find 
 * the address that is within particular MemEntry on a
 * MemList or on list of MemList's.
 *
*/
int GID_main(void)
{
  struct MemEntry *me;
  struct Task *tc;


  if ((tc = CreateTask(NEWTASKNAME,
                NEWTASKPRI, mydummytask, NEWTASKSTACK)))
  {
    /*
     * Locate TCB.
    */
    if ((me = nfo_isonlistofml(&tc->tc_MemEntry, tc)))
    {
      FPrintf(Output(), "me_Addr = 0x%08lx\n"
                        "me_Length = %ld\n\n",
                           (LONG)me->me_Addr,
                              me->me_Length);
    }

    /*
     * Locate stack.
    */
    if ((me = nfo_isonlistofml(
                     &tc->tc_MemEntry, tc->tc_SPLower)))
    {
      FPrintf(Output(), "me_Addr = 0x%08lx\n"
                        "me_Length = %ld\n",
                           (LONG)me->me_Addr,
                              me->me_Length);
    }

    Signal(tc, SIGBREAKF_CTRL_C);
  }

  return 0;
}
