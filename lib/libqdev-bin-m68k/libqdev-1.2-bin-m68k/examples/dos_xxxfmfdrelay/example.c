/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_getfmfdrelay()
 * dos_freefmfdrelay()
 *
*/

#include "../gid.h"

/*
 * Include this header when you need to access FDR stuff.
*/
#include "a-dos_addfdrelay.h"

#define DEVICENAME  "RELAY3"
#define SYNCSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096
#define DELAYTICKS    25
#define MINCHUNKS     16



struct mydata
{
  UBYTE *md_devname;
  ULONG  md_procup;
  ULONG  md_a4;
};

struct mychan
{
  struct Node mc_node;
  UBYTE       mc_name[QDEV_DOS_PRV_CHNAMLEN];
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

int GID_main(void)
{
  struct dos_fdr_main *fm;
  struct dos_fdr_chan *fc;
  struct List lh;
  struct Process *pr;
  struct mydata md;
  struct mychan *mc;
  void *clu;


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
    /*
     * And access its internals. Thanks to this there is
     * maximum control over the handler!
    */
    if ((fm = dos_getfmfdrelay(md.md_devname)))
    {
      /*
       * Create some channels.
      */
      dos_ctrlfdrelay(DEVICENAME ":", "moody", NULL,
                                         NULL, NULL, NULL);

      dos_ctrlfdrelay(DEVICENAME ":", "hallow", NULL,
                                         NULL, NULL, NULL);

      dos_ctrlfdrelay(DEVICENAME ":", "skippy", NULL,
                                         NULL, NULL, NULL);

      /*
       * One thing you may want to do with your own FDR
       * is to allow all FileHandle to be accepted. This
       * trick essentially allows to pass 'Output()' to
       * the 'dos_ctrlfdrelay()'. Normally it is illegal!
      */
      fm->fm_fdcheck = NULL;

      /*
       * You can also read some vars without arbitration.
      */
      FPrintf(Output(), "fm_chancount = %ld\n"
                        "fm_fdtotal   = %ld\n"
                        "fm_clitotal  = %ld\n",
                                          fm->fm_chancount,
                                            fm->fm_fdtotal,
                                          fm->fm_clitotal);

      /*
       * And of course immediate list access. Keep in
       * mind though that you will need to arbitrate
       * in most cases when reading lists.
      */
      NewList((struct List *)&lh);

      /*
       * For the sake of example we will dump all the
       * channels that were formed.
       * 
      */
      if ((clu = mem_alloccluster(
                          sizeof(struct mychan), MINCHUNKS,
                              MEMF_PUBLIC | MEMF_LARGEST)))
      {
        /*
         * Collect.
        */
        QDEV_HLP_NOSWITCH
        (
          QDEV_HLP_ITERATE(&fm->fm_chanlist,
                                 struct dos_fdr_chan *, fc)
          {
            if (fc->fc_status == QDEV_DOS_PRV_CHANSTAT)
            {
              if ((mc = mem_getmemcluster(clu)))
              {
                mc->mc_name[0] = '\0';

                txt_strncat(mc->mc_name,
                     fc->fc_channame, sizeof(mc->mc_name));

                AddTail(&lh, (struct Node *)mc);
              }
            }
          }
        );

        /*
         * Dump.
        */
        QDEV_HLP_ITERATE(&lh, struct mychan *, mc)
        {
          FPrintf(Output(), "%s\n", (LONG)mc->mc_name);
        }

        mem_freecluster(clu);
      }

      dos_freefmfdrelay(fm);
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
