/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_rearrangecon()
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
     * Time for small rearrange. Lets go for horizontal scheme
     * first.
    */
    Delay(50);

    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_HORIZ | QDEV_CTL_RECON_CROSS);

    FPrintf(cd->cd_cc[0].cc_con, "Horizontal arrangement.\n");

    /*
     * Now lets see how the vertical arrangement looks like.
    */
    Delay(50);

    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_VERTI | QDEV_CTL_RECON_CROSS);

    FPrintf(cd->cd_cc[1].cc_con, "Vertical arrangement.\n");

    /*
     * How about tiled windows?
    */
    Delay(50);

    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_TILED | QDEV_CTL_RECON_CROSS);

    FPrintf(cd->cd_cc[2].cc_con, "Tiled arrangement.\n");

    /*
     * Enough is enough ;-) .
    */
    Delay(50);

    FPrintf(cd->cd_cc[3].cc_con, "Oops!\n");

    Delay(25);

    ctl_closeconscreen(cd);
  }

  return 0;
}
