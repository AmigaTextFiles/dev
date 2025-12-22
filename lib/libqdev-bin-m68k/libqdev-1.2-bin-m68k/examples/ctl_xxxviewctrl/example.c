/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_addviewctrl()
 * ctl_remviewctrl()
 *
*/

#include "../gid.h"

#define SCALEFACTOR 15



int GID_main(void)
{
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  void *vc;


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

  cf.cf_ibgpen = 1;

  cf.cf_ifgpen = 2;

  cf.cf_numcon = QDEV_CTL_CSN_MAXWINDOWS;

  if ((cd = ctl_openconscreen(&cf)))
  {
    /*
     * How about tiled windows?
    */
    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_TILED | QDEV_CTL_RECON_CROSS);

    FPrintf(cd->cd_cc[0].cc_con,
    "Pick window, make it active and put mouse pointer near\n"
                                      "bottom-right corner.\n"
    "Little OSD shoud showup, now use these keys to poke:\n\n"
    " '/' - Switches window arrangement(horiz, vert, tiled)\n"
    " '*' - Scales all windows equally\n"
    " '-' - Scales active window down, and others up\n"
    " '+' - Scales active window up, and other down\n"
    " '.' - Toggles cross/commodore window separator\n"
    " RET - Transfers keyboard back to the console\n\n"
    "After youre done press Return key or put mouse pointer\n"
                        "over the toggle area once again.\n");

    /*
     * And now install the view control, so that user can
     * have some power over the windows.
    */
    if ((vc = ctl_addviewctrl(cd, SCALEFACTOR)))
    {
      FPrintf(cd->cd_cc[0].cc_con, "Press CTRL-C to quit.\n");

      Wait(SIGBREAKF_CTRL_C);

      ctl_remviewctrl(vc);
    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
