/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_addbartrigger()
 * ctl_pokebartrigger()
 * ctl_rembartrigger()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  void *bt;


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
   * OK, open the console screen with just one console window.
  */
  cf.cf_backpen = 1;

  cf.cf_numcon = 1;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    /*
     * Lets now install the damn thing, the title bar trigger.
    */
    if ((bt = ctl_addbartrigger(cd)))
    {
      FPrintf(cd->cd_cc[0].cc_con, "Now you see me...\n");

      ctl_pokebartrigger(bt, NULL);

      Delay(50);

      FPrintf(cd->cd_cc[0].cc_con, "Now you dont ;-) .\n");

      ctl_pokebartrigger(bt, NULL);

      FPrintf(cd->cd_cc[0].cc_con,
       "Try it out, click top-left corner of the screen!\n");

      FPrintf(cd->cd_cc[0].cc_con, "Press CTRL-C to quit.\n");

      Wait(SIGBREAKF_CTRL_C);

      ctl_rembartrigger(bt);
    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
