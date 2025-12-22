/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_swapmpfdrelay()
 *
*/

#include "../gid.h"

#define DEVICENAME  "RELAY2"
#define TERMSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096
#define DELAYTICKS    25
#define FDRCHANNEL  "mychannel"



struct mydata
{
  UBYTE *md_devname;
  ULONG  md_termsig;
  ULONG  md_procup;
  ULONG  md_a4;
};



void mpdetails(LONG fd)
{
  struct FileHandle *fh;


  fh = QDEV_HLP_BADDR(fd);

  FPrintf(Output(), "mp              = 0x%08lx\n"
                    "mp_Node.ln_Succ = 0x%08lx\n"
                    "mp_Flags        = 0x%08lx\n"
                    "mp_SigBit       = 0x%08lx\n"
                    "mp_SigTask      = 0x%08lx\n",
                                       (LONG)fh->fh_Type,
                      (LONG)fh->fh_Type->mp_Node.ln_Succ,
                                   fh->fh_Type->mp_Flags,
                                  fh->fh_Type->mp_SigBit,
                          (LONG)fh->fh_Type->mp_SigTask);
}

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

    Signal(&pr->pr_Task, TERMSIGNAL);

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
  if (nfo_istask((ULONG)pr))
  {
    Signal(&pr->pr_Task, TERMSIGNAL);

    while (md->md_procup)
    {
      Delay(DELAYTICKS);
    }
  }
}

int GID_main(void)
{
  struct Process *pr;
  struct mydata md;
  ULONG flags;
  LONG fd;


  /*
   * Define the function arguments that will be passed to
   * the subprocess and save a4 register!
  */
  md.md_devname = DEVICENAME;

  md.md_termsig = TERMSIGNAL;

  md.md_procup = 1;

  __SAVEA4(md.md_a4);

  /*
   * Launch the File Descriptor Relay.
  */
  if ((pr = runfdrelay(&md)))
  {
    /*
     * Control function should return the FileHandle.
    */
    flags = QDEV_DOS_FDR_RETURNFD;

    if ((fd = dos_ctrlfdrelay(
                          DEVICENAME ":", FDRCHANNEL, NULL,
                                       flags, NULL, NULL)))
    {
      FPrintf(Output(), "--- priv ---\n");

      mpdetails(fd);

      /*
       * Lets now swap the ports so that this 'fd' will
       * reference global port.
      */
      dos_swapmpfdrelay(fd, NULL);

      FPrintf(Output(), "\n--- glob ---\n");

      mpdetails(fd);

      Close(fd);
    }

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
