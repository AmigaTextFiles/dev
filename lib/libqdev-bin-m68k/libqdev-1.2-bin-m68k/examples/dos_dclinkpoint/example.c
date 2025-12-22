/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_dclinkpoint()
 *
*/

#include "../gid.h"

#define DEVICENAME  "LINK2"
#define DIRECTORY   ""
#define SYNCSIGNAL  SIGBREAKF_CTRL_C
#define STACKSIZE   4096
#define SLEEPTICKS     3
#define DELAYTICKS    25
#define EXALLSIZE   2048
#define INFOSIZE    ED_TYPE



struct mydata
{
  UBYTE *md_devname;
  UBYTE *md_dirname;
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
     * Can now boot into linkpoint code, but first gotta
     * fix all globals in case this code is resident.
    */
    __LOADA4(md->md_a4);

    dos_addlinkpoint(
                   md->md_dirname, md->md_devname, NULL);

    /*
     * After the function is complete which may happened
     * for two reasons, either LP was killed or did not
     * start at all, indicate that in 'tc_UserData'.
    */
    Forbid();

    SysBase->ThisTask->tc_UserData = NULL;

    md->md_procup = 0;
  }
}

struct Process *runlinkpoint(struct mydata *md)
{
  struct DosList *dol;
  struct Process *pr;
  void *ptr = NULL;


  /*
   * When creating new proc. always remember about 'NP_Cli'
   * since LP makes use of this structure!
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
     * Check if LP is all up and running. Notice that this
     * is not the same as in FDR! In this particular case
     * we cannot depend on synchronisation, cus of I/O the
     * LP does before device creation.
    */
    QDEV_HLP_NOSWITCH
    (
      while (
           !(dos_checkdevice(md->md_devname, DLT_DEVICE)))
      {
        if (!(md->md_procup))
        {
          break;
        }

        /*
         * Do not replace this with 'mem_cooperate()'! It
         * is not desired to do level-context-switch, not
         * knowing devices that will be queried by the LP!
        */
        Delay(SLEEPTICKS);
      }

      if ((dol =
             dos_checkdevice(md->md_devname, DLT_DEVICE)))
      {
        if ((md->md_procup)                            &&
            (dol->dol_Task->mp_SigTask == (void *)pr))
        {
          ptr = pr;
        }
      }

      /*
       * On failure we will have to wait until subprocess
       * is gone.
      */
      if (!(ptr))
      {
        while (md->md_procup)
        {
          Delay(SLEEPTICKS);
        }
      }
    );
  }

  return ptr;
}

void stoplinkpoint(struct mydata *md, struct Process *pr)
{
  dos_remlinkpoint(md->md_devname);

  while (md->md_procup)
  {
    Delay(DELAYTICKS);
  }
}

void deletefiles(UBYTE **files)
{
  UBYTE **ptr = files;


  while (*ptr)
  {
    DeleteFile(*ptr);

    ptr++;
  }
}

void createfiles(UBYTE **files)
{
  UBYTE **ptr = files;
  LONG fd;


  while (*ptr)
  {
    if ((fd = Open(*ptr, MODE_NEWFILE)))
    {
      Close(fd);
    }

    ptr++;
  }
}

BOOL listfilescb(struct nfo_fsq_cb *fc)
{
  FPrintf(Output(), "%s\n", (LONG)fc->fc_ead->ed_Name);

  return TRUE;
}

void listfiles(UBYTE *dev, UBYTE *text)
{
  FPrintf(Output(), "\n%s\n", (LONG)text);

  nfo_fsquery(0, EXALLSIZE, dev,
                       INFOSIZE, NULL, NULL, listfilescb);
}

/*
 * With 'dos_dclinkpoint()' you can refresh contents of
 * your LP. The function is safe to call from tasks too.
*/
int GID_main(void)
{
  struct Process *pr;
  struct mydata md;
  UBYTE *files[] =
  {
    "___oranges___",
    "___apples___",
    "___plums___",
    NULL
  };


  /*
   * Define the function arguments that will be passed to
   * the subprocess and save a4 register!
  */
  md.md_devname = DEVICENAME;

  md.md_dirname = DIRECTORY;

  md.md_procup = 1;

  __SAVEA4(md.md_a4);

  /*
   * Delete existing demonstration files before entering
   * the LP.
  */
  deletefiles(files);

  /*
   * Run teh Link Point.
  */
  if ((pr = runlinkpoint(&md)))
  {
    listfiles(DEVICENAME ":", "BEFORE (" DEVICENAME ")");

    /*
     * Now create the files and refresh the Link Point.
    */
    createfiles(files);

    dos_dclinkpoint(md.md_devname);

    listfiles(DEVICENAME ":", "AFTER (" DEVICENAME ")");

    FPrintf(Output(), "Waiting for LP to stop...\n");

    stoplinkpoint(&md, pr);
  }
  else
  {
    FPrintf(Output(),
                     "Cannot start Link Point = '%s' !\n",
                                      (LONG)md.md_devname);
  }

  return 0;
}
