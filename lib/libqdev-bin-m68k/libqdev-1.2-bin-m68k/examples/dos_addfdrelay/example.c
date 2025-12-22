/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_addfdrelay()
 *
*/

#include "../gid.h"

#define DEVICENAME  "RELAY0"
#define TERMSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096



struct mydata
{
  UBYTE *md_devname;
  ULONG  md_termsig;
  ULONG  md_a4;
};



void startup(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  struct mydata *md;


  /*
   * Wait for the signal before inspecting 'tc_UserData'!
  */
  Wait(TERMSIGNAL);

  if ((md = SysBase->ThisTask->tc_UserData))
  {
    /*
     * Can now boot into relay code, but first gotta fix
     * all globals in case this code is resident.
    */
    __LOADA4(md->md_a4);

    dos_addfdrelay(md->md_devname, md->md_termsig);

    /*
     * After the function is complete which may happened
     * for two reasons, either FDR was killed or did not
     * start at all, indicate that in 'tc_UserData'.
    */
    Forbid();

    SysBase->ThisTask->tc_UserData = NULL;
  }
}

/*
 * This little example shows how to start the FDR and
 * detach from the shell and have the feedback. There is
 * just one drawback with this approach. On termination
 * signal small memory leak(~216 bytes) will be formed,
 * cus there is no way to call the deinit code anymore
 * in 'startup()'.
*/
int GID_main(void)
{
  struct CommandLineInterface *cli;
  struct Process *pr;
  struct mydata md;
  LONG res = 0;
  LONG *segs;


  /*
   * Define the function arguments that will be passed to
   * the subprocess and save a4 register!
  */
  md.md_devname = DEVICENAME;

  md.md_termsig = TERMSIGNAL;

  __SAVEA4(md.md_a4);

  /*
   * When creating new proc. always remember about 'NP_Cli'
   * since FDR makes use of this structure!
  */
  pr = CreateNewProcTags(
                     NP_Entry      , (ULONG)startup,
                     NP_Name       , (ULONG)md.md_devname,
                     NP_CommandName, (ULONG)md.md_devname,
                     NP_StackSize  , STACKSIZE,
                     NP_Cli        , TRUE,
                     TAG_DONE      , NULL);

  if (pr)
  {
    /*
     * Stuff our data in 'tc_UserData' and let the process
     * run.
    */
    pr->pr_Task.tc_UserData = &md;

    Signal(&pr->pr_Task, TERMSIGNAL);

    /*
     * Attempt synchronisation to see if FDR is all up and
     * running.
    */
    mem_dosynctask((ULONG)pr);

    QDEV_HLP_NOINTSEC
    (
      if ((nfo_istask((ULONG)pr))    &&
          (pr->pr_Task.tc_UserData))
      {
        /*
         * OK. Now pass this seglist to the process we just
         * spawned, so we can quit.
        */
        cli = Cli();

        pr->pr_Flags |= PRF_FREESEGLIST;

        segs = QDEV_HLP_BADDR(pr->pr_SegList);

        segs[3] = cli->cli_Module;

        cli->cli_Module = NULL;

        res = 1;
      }
    );

    mem_dosynctask(NULL);
  }

  if (!(res))
  {
    FPrintf(Output(),
           "Cannot start File Descriptor Relay = '%s' !\n",
                                      (LONG)md.md_devname);
  }
  else
  {
    FPrintf(Output(),
                 "FDR = '%s' is now running at 0x%08lx.\n",
                            (LONG)md.md_devname, (LONG)pr);

    /*
     * All is just fine, so lets transfer us to the final
     * PC thus skipping deinit code.
    */
    pr = (void *)SysBase->ThisTask;

    QDEV_HLP_SETREG(d0, 0);

    QDEV_HLP_PROCEXIT((pr->pr_ReturnAddr - 4));
  }

  return 5;
}
