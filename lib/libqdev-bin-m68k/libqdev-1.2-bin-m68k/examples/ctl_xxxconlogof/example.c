/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_addconlogof()
 * ctl_remconlogof()
 * ctl_setconlogof()
 *
*/

#include "../gid.h"

#define LOGOFILE "jb.logo"



void showsubtask(LONG fd)
{
  /*
   * Got to wait for respawn of the animation subtask.
  */
  mem_cooperate(-128, SIGF_SINGLE);

  nfo_ktm(fd, "(___ctl_animsubtask)",
                QDEV_NFO_KTM_FMASS | QDEV_NFO_KTM_FICHAR, 0);
}

int GID_main(void)
{
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  void *logo;


  /*
   * Lets 0 all structure members first so overall param feed
   * will be sane.
  */
  txt_memfill(&cf, 0, sizeof(cf));

  /*
   * Now lets fetch modeid of current screen.
  */
  nfo_getscparams(IntuitionBase->ActiveScreen,
                                        &cf.cf_modeid, NULL);

  cf.cf_depth = 4;

  /*
   * OK, open the console screen with just one console window.
  */
  cf.cf_backpen = 1;

  cf.cf_numcon = 1;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    /*
     * Lets buffer the first window for the sake of handiness.
    */
    cc = &cd->cd_cc[0];

    /*
     * Start animating the logo right after loading it into
     * memory. And add pseudo transparency.
    */
    cc->cc_lflags |= QDEV_CTL_LFLLOGO_PLAY;

    cc->cc_iflags |= QDEV_MEM_IFLPIC_TRANSP;

    /*
     * Before installing the logo lets increase Y area to fit
     * the image.
    */
    cc->cc_rpylim = 128;

    /*
     * Now we can install the logo from file.
    */
    if ((logo = ctl_addconlogof(cc, LOGOFILE, 0, 0)))
    {
      /*
       * NEW (1.2)! Setting priority is now possible.
      */
      ctl_setconlogof(logo, QDEV_CTL_SETCONLF_ANIMPRI, -10);

      showsubtask(cc->cc_con);

      FPrintf(cc->cc_con, "Press CTRL-C to quit.\n");

      Wait(SIGBREAKF_CTRL_C);

      ctl_remconlogof(logo);
    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
