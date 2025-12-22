/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_remfdrelay()
 *
*/

#include "../gid.h"

#define DEVICENAME  "RELAY2"
#define SYNCSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096
#define DELAYTICKS    25



struct mydata
{
  UBYTE *md_devname;
  ULONG  md_procup;
  ULONG  md_a4;
};



void startup(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  struct mydata *md;


  /*
   * Wait for the signal before inspecting 'tc_UserData'!
  */
  Wait(SYNCSIGNAL);

  if ((md = SysBase->ThisTask->tc_UserData))
  {
    /*
     * Can now boot into relay code, but first gotta fix
     * all globals in case this code is resident.
    */
    __LOADA4(md->md_a4);

    dos_addfdrelay(md->md_devname, NULL);

    /*
     * After the function is complete which may happened
     * for two reasons, either FDR was killed or did not
     * start at all, indicate that in 'tc_UserData'.
    */
    Forbid();

    SysBase->ThisTask->tc_UserData = NULL;

    md->md_procup = 0;
  }
}

struct Process *runfdrelay(struct mydata *md)
{
  struct Process *pr;


  /*
   * When creating new proc. always remember about 'NP_Cli'
   * since FDR makes use of this structure!
  */
  pr = CreateNewProcTags(
                     NP_Entry      , (ULONG)startup,
                     NP_Name       , (ULONG)md->md_devname,
                     NP_CommandName, (ULONG)md->md_devname,
                     NP_StackSize  , STACKSIZE,
                     NP_Cli        , TRUE,
                     TAG_DONE      , NULL);

  if (pr)
  {
    /*
     * Stuff our data in 'tc_UserData' and let the process
     * run.
    */
    pr->pr_Task.tc_UserData = md;

    Signal(&pr->pr_Task, SYNCSIGNAL);

    /*
     * Attempt synchronisation to see if FDR is all up and
     * running.
    */
    mem_dosynctask((ULONG)pr);

    QDEV_HLP_NOINTSEC
    (
      if (!((nfo_istask((ULONG)pr))    &&
          (pr->pr_Task.tc_UserData)))
      {
        pr = NULL;
      }
    );

    mem_dosynctask(NULL);
  }

  return pr;
}

void stopfdrelay(struct mydata *md, struct Process *pr)
{
  dos_remfdrelay(md->md_devname);

  while (md->md_procup)
  {
    Delay(DELAYTICKS);
  }
}

/*
 * If termination signal is to cause some harmful interactions
 * then you can always construct "kill" function using packet
 * called ACTION_DIE. Function 'dos_remfdrelay()' was designed
 * to do this for you.
*/
int GID_main(void)
{
  struct Process *pr;
  struct mydata md;


  /*
   * Define the function arguments that will be passed to
   * the subprocess and save a4 register!
  */
  md.md_devname = DEVICENAME;

  md.md_procup = 1;

  __SAVEA4(md.md_a4);

  /*
   * Launch the File Descriptor Relay.
  */
  if ((pr = runfdrelay(&md)))
  {
    FPrintf(Output(), "Waiting for FDR to stop...\n");

    stopfdrelay(&md, pr);
  }
  else
  {
    FPrintf(Output(),
           "Cannot start File Descriptor Relay = '%s' !\n",
                                      (LONG)md.md_devname);
  }

  return 0;
}
