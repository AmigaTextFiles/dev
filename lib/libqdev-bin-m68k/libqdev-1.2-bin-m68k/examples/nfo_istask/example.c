/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_istask()
 *
*/

#include "../gid.h"

#define CONSOLE   "CON:////myprocess/SCREEN*"
#define PIPE      "PIPE:myprocess"
#define SEEKVAR   "_magicvariable_"



struct mydata
{
  ULONG md_a4;
  LONG  md_con;
  LONG  md_in;
  LONG  md_out;
  LONG  md_tc;
};



ULONG findshellcb(struct nfo_sct_cb *_tc)
{
  struct CommandLineInterface *cli;
  struct Process *pr = _tc->tc_itemaddr;
  struct LocalVar *var;


  if (pr->pr_Task.tc_Node.ln_Type == NT_PROCESS)
  {
    if (pr->pr_CLI)
    {
      cli = (void *)QDEV_HLP_BADDR(pr->pr_CLI);

      if (pr != _tc->tc_userdata)
      {
        QDEV_HLP_ITERATE(
               &pr->pr_LocalVars, struct LocalVar *, var)
        {
          if (txt_stricmp(
                     SEEKVAR, var->lv_Node.ln_Name) == 0)
          {
            return (ULONG)pr;
          }
        }
      }
    }
  }

  return 0;
}

ULONG findshell(void *addr)
{
  ULONG tasklist[] =
  {
    (ULONG)&SysBase->TaskReady,
    (ULONG)&SysBase->TaskWait,
    NULL
  };
  ULONG res;

  
  QDEV_HLP_NOINTSEC
  (
    res = nfo_scanlist(tasklist, addr, findshellcb);
  );

  return res;
}

void isprocvalid(UBYTE *name, void *addr)
{
  if (nfo_istask((ULONG)addr))
  {
    FPrintf(Output(),
       "Address of 0x%08lx(%s) points at valid task.\n",
                                (LONG)addr, (LONG)name);
  }
  else
  {
    FPrintf(Output(),
     "Address of 0x%08lx(%s) does not point at task!\n",
                                (LONG)addr, (LONG)name);
  }
}

void myprocess(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  struct mydata *md;


  /*
   * This process will toggle forbidden state whenever
   * there is a need to Wait(). It is important for it
   * to die while task switches are disabled! The exec
   * will normalize this state.
  */
  Forbid();

  Wait(SIGBREAKF_CTRL_C);

  md = SysBase->ThisTask->tc_UserData;

  /*
   * Give us access to the parent's globals if it is
   * resident.
  */
  __LOADA4(md->md_a4);

  /*
   * Lets set a magic variable so we can then locate the
   * shell process.
  */
  SetVar(SEEKVAR, "-1", -1, GVF_LOCAL_ONLY);

  /*
   * Attach shell to this process and wait for cmd. This
   * will break forbidden state.
  */
  Execute("", md->md_in, md->md_con);

  Signal((void *)md->md_tc, SIGBREAKF_CTRL_F);
}

int GID_main(void)
{
  struct mydata md;
  struct Process *pr;
  struct Process *pr2;


  /*
   * Lets save the A4 reg. if we are resident, so that
   * we can fix globals in subprocess.
  */
  __SAVEA4(md.md_a4);

  md.md_tc = (LONG)FindTask(NULL);

  /*
   * Then we will need the con. output to monitor what
   * is going on in the shell process.
  */
  if ((md.md_con = Open(CONSOLE, MODE_OLDFILE)))
  {
    /*
     * We will also need a pipe to demonstrate function
     * behaviour under some circumstances.
    */
    if ((md.md_in = Open(PIPE, MODE_OLDFILE)))
    {
      if ((md.md_out = Open(PIPE, MODE_NEWFILE)))
      {
        /*
         * OK, so lets run a process and synchronise to
         * it.
        */
        pr = CreateNewProcTags(
                      NP_Entry      , (ULONG)myprocess,
                      NP_Name       , (ULONG)"myprocess",
                      NP_CommandName, (ULONG)"myprocess",
                      NP_Cli        , TRUE,
                      TAG_DONE      , NULL);

        if (pr)
        {
          /*
           * Pass our data in tc_UserData and let the
           * 'pr' run, then find the shell process(pr2).
          */
          pr->pr_Task.tc_UserData = &md;

          Signal((void *)pr, SIGBREAKF_CTRL_C);

          while (!(pr2 = (void *)findshell(pr)))
          {
            mem_cooperate(0, SIGF_SINGLE);
          }

          /*
           * Now that we have all in sync we can start
           * the test. First lets see if 'nfo_istask()'
           * can confirm if 'pr' is a valid task.
          */
          isprocvalid("pr", pr);

          /*
           * Then lets see if shell process that does
           * not execute anything is also valid. Should
           * not be!
          */
          isprocvalid("pr2", pr2);

          /*
           * Run something in the shell and check once
           * again.
          */
          FPuts(md.md_out, "echo waiting...\nwait 5\n");

          Close(md.md_out);

          /*
           * Gotta wait for the command to be started.
          */
          while (!(nfo_istask((ULONG)pr2)))
          {
            if (SetSignal(0L, 0L) & SIGBREAKF_CTRL_C)
            {
              SetSignal(0L, SIGBREAKF_CTRL_C);

              break;
            }

            mem_cooperate(0, SIGF_SINGLE);
          }

          isprocvalid("pr2", pr2);

          Wait(SIGBREAKF_CTRL_F);
        }
        else
        {
          Close(md.md_out);
        }
      }

      Close(md.md_in);
    }

    Close(md.md_con);
  }

  return 0;
}
