/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_zoomifycon()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;


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
   * OK, open the console screen with maximum possible windows.
  */
  cf.cf_backpen = 1;

  cf.cf_numcon = QDEV_CTL_CSN_MAXWINDOWS;

  if ((cd = ctl_openconscreen(&cf)))
  {
    /*
     * How about tiled windows?
    */
    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_TILED | QDEV_CTL_RECON_CROSS);

    Delay(50);

    /*
     * Lets expand the first window by 8 % of the screen size.
    */
    ctl_zoomifycon(&cd->cd_cc[0], 8);

    FPrintf(cd->cd_cc[0].cc_con, "8 %% more\n");

    Delay(50);

    /*
     * The second will now go -20 % of the screen size.
    */
    ctl_zoomifycon(&cd->cd_cc[1], -20);

    FPrintf(cd->cd_cc[1].cc_con, "20 %% less\n");

    Delay(50);

    /*
     * The third will now gain 10 % of the screen size.
    */
    ctl_zoomifycon(&cd->cd_cc[2], 10);

    FPrintf(cd->cd_cc[2].cc_con, "10 %% more\n");

    Delay(50);

    /*
     * And the fourth will be now -100 % acc. to screen size.
    */
    ctl_zoomifycon(&cd->cd_cc[3], -100);

    FPrintf(cd->cd_cc[3].cc_con, "100 %% less\n");

    Delay(100);

    ctl_closeconscreen(cd);
  }

  return 0;
}
