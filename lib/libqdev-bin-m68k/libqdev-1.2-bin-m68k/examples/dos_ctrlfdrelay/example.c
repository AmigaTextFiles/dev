/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_ctrlfdrelay()
 *
*/

#include "../gid.h"

#define DEVICENAME  "RELAY1"
#define TERMSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096
#define DELAYTICKS    25
#define FDRCHANNEL  "mychannel"
#define AUXCONSOLE "CON:50/50/400/200/Con/SCREEN*/CLOSE"
#define LINEFORMAT "At %t UFO said: "



struct mydata
{
  UBYTE *md_devname;
  ULONG  md_termsig;
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
  struct ctl_csh_data ct = {0, 0, 0};
  struct Process *pr;
  struct mydata md;
  ULONG flags;
  LONG auxfd;
  LONG confd;
  LONG fdrfd;


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

    /*
     * Lets also make the channel the default one.
    */
    flags |= QDEV_DOS_FDR_CHANISDEFAULT;

    /*
     * Files should be terminated upon quit.
    */
    flags |= QDEV_DOS_FDR_TERMFILES;

    /*
     * Each file linked in will be closed by the FDR.
    */
    flags |= QDEV_DOS_FDR_CLOSEFILE;

    /*
     * Lets open the auxiliary console and clone the
     * current stream.
    */
    if ((auxfd = Open(AUXCONSOLE, MODE_OLDFILE)))
    {
      if ((confd = Open("CONSOLE:", MODE_OLDFILE)))
      {
        /*
         * Now lets create the channel and add the
         * 'auxfd'.
        */
        if ((fdrfd = dos_ctrlfdrelay(
                          DEVICENAME ":", FDRCHANNEL, NULL,
            flags | QDEV_DOS_FDR_FILEISADDR, auxfd, NULL)))
        {
          /*
           * We have obtained the fd already, so kill
           * the flag.
          */
          flags &= ~QDEV_DOS_FDR_RETURNFD;

          if (dos_ctrlfdrelay(
                          DEVICENAME ":", FDRCHANNEL, NULL,
             flags | QDEV_DOS_FDR_FILEISADDR, confd, NULL))
          {
            /*
             * We can prefix each new line with some text.
            */
            dos_ctrlfdrelay(DEVICENAME ":", FDRCHANNEL,
                    NULL, QDEV_DOS_FDR_SETLINEFORMAT, NULL,
                                         (LONG)LINEFORMAT);

            /*
             * Switch all output to FDR where this con
             * and the auxiliary one are connected.
            */
            ctl_doconswitch(&ct, fdrfd);

            /*
             * Now everything this process outputs will
             * be splitted across two windows.
            */
            FPrintf(Output(), "Hello Mars!\n");

            FPrintf(Output(), "Hello Venus!\n");

            FPrintf(Output(), "Hello Earth!\n");

            Flush(Output());

            Delay(50);

            ctl_undoconswitch(&ct);
          }

          Close(fdrfd);
        }
        else
        {
          /*
           * This will be executed when FDR will refuse
           * to accept the request.
          */
          Close(auxfd);

          Close(confd);
        }
      }
      else
      {
        /*
         * This will be executed in case second console
         * will not open.
        */
        Close(auxfd);
      }
    }

    FPrintf(Output(), "Waiting for FDR to stop...\n");

    /*
     * Unless FileHandles were QDEV_DOS_FDR_CLOSEFILE
     * assisted the FDR will close them.
    */
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
