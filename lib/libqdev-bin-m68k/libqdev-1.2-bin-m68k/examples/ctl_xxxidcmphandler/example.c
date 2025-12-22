/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_addidcmphandler()
 * ctl_remidcmphandler()
 *
*/

#include "../gid.h"



struct mydata
{
  struct ctl_csn_ient  md_ci;           /* IDCMP handler carry              */
  struct ctl_csn_data *md_cd;           /* Console screen pointer           */
  struct Task         *md_tc;           /* Subtask address                  */
  LONG                 md_xchr;         /* Char mouse is curr. at X         */
  LONG                 md_ychr;         /* Char mouse is curr. at Y         */
  LONG                 md_xold;         /* Char mouse was last at X         */
  LONG                 md_yold;         /* Char mouse was last at Y         */
};



__interrupt void mousemoveidcmp(
                     struct ctl_csn_cwin *cc, void *userdata)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  struct mydata *md = userdata;


  /*
   * Compute what character the mouse is currently at.
  */
  md->md_xchr = cc->cc_imsg->MouseX;

  md->md_ychr = cc->cc_imsg->MouseY;

  md->md_xchr /= cc->cc_mainwin->RPort->Font->tf_XSize;

  md->md_ychr /= cc->cc_mainwin->RPort->Font->tf_YSize;

  /*
   * If mouse approached new char then send the signal
   * to renderer. Using double variables is better than
   * using modulo!
  */
  if ((md->md_xchr != md->md_xold)  ||
      (md->md_ychr != md->md_yold))
  {
    if (md->md_tc)
    {
      Signal(md->md_tc, SIGBREAKF_CTRL_D);
    }
  }

  md->md_xold = md->md_xchr;

  md->md_yold = md->md_ychr;
}

void mousemoverender(void)
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));
  struct mydata *md;
  struct FileHandle *fh;
  REGISTER ULONG sigs;
  UBYTE buf[64];
  LONG buflen;


  /*
   * Wait until parent sends us synchronisation signal.
  */
  Wait(SIGBREAKF_CTRL_C);

  if ((md = SysBase->ThisTask->tc_UserData))
  {
    /*
     * As we cannot use DOS functions here we will do
     * the 'Write()' low-level.
    */
    fh = QDEV_HLP_BADDR(md->md_cd->cd_cc[0].cc_con);

    /*
     * Enter the loop that allows to leave upon C sig.
     * The other signal is used to trigger refreshes.
    */
    while (1)
    {
      sigs = Wait(SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D);

      if (sigs & SIGBREAKF_CTRL_C)
      {
        Forbid();

        md->md_tc = NULL;

        break;
      }

      /*
       * Create the position report and send it to the
       * handler.
      */
      buflen = txt_psnprintf(buf, sizeof(buf),
                                   "\x1B" "[1;1H" "\x1B" "[7m"
                                "Mouse position: %03ld:%03ld", 
                            md->md_xchr + 1, md->md_ychr + 1);

      if (buflen > 0)
      {
        dos_dopacket(fh->fh_Type, ACTION_WRITE,
                        fh->fh_Arg1, (LONG)buf, buflen, 0, 0);
      }
    }
  }

  RemTask(SysBase->ThisTask);
}

int GID_main(void)
{
  struct IntuiMessage imsg;
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  struct mydata *md;


  /*
   * Lets 0 all structure members first so overall param feed
   * will be sane.
  */
  txt_memfill(&cf, 0, sizeof(cf));

  /*
   * Now lets fetch modeid of current screen.
  */
  nfo_getscparams(IntuitionBase->ActiveScreen,
                        &cf.cf_modeid, (UWORD *)&cf.cf_depth);

  /*
   * OK, open the console screen with one console window.
  */
  cf.cf_numcon = 1;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    FPrintf(cd->cd_cc[0].cc_con, "\x1B" "[2;1H"
        "Move the mouse cursor or press CTRL + C to quit.\n");

    /*
     * Gotta allocate some memory for our handler carry and
     * mouse pointer coords data.
    */
    if ((md = AllocVec(
            sizeof(struct mydata), MEMF_PUBLIC | MEMF_CLEAR)))
    {
      md->md_cd = cd;

      /*
       * Then create the renderer task and supply with the
       * data.
      */
      if ((md->md_tc = CreateTask(
         "mousemoverender", SysBase->ThisTask->tc_Node.ln_Pri,
                                      mousemoverender, 4096)))
      {
        md->md_tc->tc_UserData = md;

        Signal(md->md_tc, SIGBREAKF_CTRL_C);

        /*
         * Force report current position. Do not care about
         * garbage in the imsg nor about assignment as the
         * pointer will be fixed on new message.
        */
        cd->cd_cc[0].cc_imsg = &imsg;

        cd->cd_cc[0].cc_imsg->MouseX =
                              cd->cd_cc[0].cc_mainwin->MouseX;

        cd->cd_cc[0].cc_imsg->MouseY =
                              cd->cd_cc[0].cc_mainwin->MouseY;

        mousemoveidcmp(&cd->cd_cc[0], md);

        /*
         * We can now fill the ient structure and attach the
         * handler to window 0.
        */
        md->md_ci.ci_idcmpev = IDCMP_MOUSEMOVE;

        md->md_ci.ci_idcmpcode = mousemoveidcmp;

        md->md_ci.ci_idcmpdata = md;

        ctl_addidcmphandler(&cd->cd_cc[0], &md->md_ci);

        /*
         * Wait for termination signal and if caught resend
         * it to the subtask. You can of course put your own
         * code in here that does something. Kinda supperior
         * compared to classic message handling aint it?
        */
        Wait(SIGBREAKF_CTRL_C);

        /*
         * Must now detach the handler.
        */
        ctl_remidcmphandler(&cd->cd_cc[0], &md->md_ci);

        /*
         * Send a subtask termination signal and wait until
         * it is gone.
        */
        if (md->md_tc)
        {
          Signal(md->md_tc, SIGBREAKF_CTRL_C);

          while (md->md_tc)
          {
            mem_cooperate(0, SIGF_SINGLE);
          }
        }
      }

      FreeVec(md);
    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
