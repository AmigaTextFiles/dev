/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_openconscreen()
 * ctl_closeconscreen()
 *
*/

#include "../gid.h"



void runinwindow(struct ctl_csn_cwin *cc, UBYTE *cmd)
{
  struct ctl_csh_data ct = {0, 0, 0};


  ctl_doconswitch(&ct, cc->cc_con);

  ctl_clirun(cmd, "CONSOLE:", FALSE);

  ctl_undoconswitch(&ct);
}

int GID_main(void)
{
  QDEV_CTL_CS_ANSIDMAP(adm);
  QDEV_CTL_CS_ANSICMAP(acm);
  QDEV_NFO_DRIMAPTYPEI(drimap);
  struct Screen *screen;
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
   * Limit the depth purposely so the relocator will not go
   * crazy. This will not hurt the RGB modes!
  */
  if (cf.cf_depth > 8)
  {
    cf.cf_depth = 8;
  }

  /*
   * Try to fetch Workbench cruicial palette entries and its
   * pen mapping table.
  */
  if ((screen = ctl_lockscreensafe(NULL)))
  {
    /*
     * We are going to  redefine colors in our ANSI table!
    */
    nfo_getcmcolors(&acm[QDEV_CTL_CS_ANSIREL], 
                             screen->ViewPort.ColorMap, 0, 4);

    if (nfo_getdrimap(drimap, screen))
    {
      ctl_relocdrimap(drimap, 
                            QDEV_CTL_CS_ANSIREL, cf.cf_depth);

      cf.cf_drimap = drimap;
    }

    ctl_unlockscreensafe(screen);
  }
  else
  {
    /*
     * Looks like Workbench is not there, so lets use the def.
     * pen layout.
    */
    cf.cf_drimap = adm;
  }

  cf.cf_cs = acm;

  /*
   * Lets lock some pens, so visitors cannot redefine them.
  */
  cf.cf_lfirst = 12;

  cf.cf_llast = 4;

  /*
   * How about some bigger font?
  */
  cf.cf_ta.ta_YSize = 11;

  cf.cf_ta.ta_Name = "topaz.font";
  
  cf.cf_ta.ta_Style = 0;
  
  cf.cf_ta.ta_Flags = 1;

  /*
   * OK, open the console screen with two console windows.
  */
  cf.cf_title = "New Console Screen";

  cf.cf_backpen = 5;

  cf.cf_numcon = 2;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    ShowTitle(cd->cd_screen, 1);

    ctl_rearrangecon(cd,
                 QDEV_CTL_RECON_HORIZ | QDEV_CTL_RECON_CROSS);

    /*
     * Changing font color is as easy as can be.
    */
    FPrintf(cd->cd_cc[0].cc_con, "\x1B[32m\r");

    FPrintf(cd->cd_cc[1].cc_con, "\x1B[33m\r");

    /*
     * So... Lets fill the consoles with something.
    */
    runinwindow(&cd->cd_cc[0], "avail");

    runinwindow(&cd->cd_cc[1], "info");

    FPrintf(cd->cd_cc[0].cc_con, "\x1B[39m\r");

    FPrintf(cd->cd_cc[0].cc_con, "Press CTRL-C to quit.\n");

    Wait(SIGBREAKF_CTRL_C);

    ctl_closeconscreen(cd);
  }

  return 0;
}
