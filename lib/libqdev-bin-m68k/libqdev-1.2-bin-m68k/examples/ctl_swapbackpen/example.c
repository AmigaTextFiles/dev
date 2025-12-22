/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_swapbackpen()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  QDEV_CTL_CS_ANSIDMAP(adm);
  QDEV_CTL_CS_ANSICMAP(acm);
  QDEV_NFO_DRIMAPTYPEI(drimap);
  struct Screen *screen;
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  LONG colors;
  LONG pen;
  LONG curr;


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
   * OK, open the console screen with four console windows.
  */
  cf.cf_title = "New Console Screen";

  cf.cf_backpen = 1;

  cf.cf_numcon = 4;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    ShowTitle(cd->cd_screen, 1);

    /*
     * Set cross thickness to 2 pixels.
    */
    ctl_rearrangecon(cd,
             QDEV_CTL_RECON_TILED | QDEV_CTL_RECON_CROSS | 2);

    FPrintf(
          cd->cd_cc[0].cc_con, "\n\nPress CTRL-C to quit.\n");

    pen = 0;

    colors = (1L << GetBitMapAttr(
                  cd->cd_screen->RastPort.BitMap, BMA_DEPTH));

    while (1)
    {
      curr = (pen++ % colors);

      ctl_swapbackpen(cd, curr);

      FPrintf(cd->cd_cc[1].cc_con, "%ld\n", curr);

      if (SetSignal(0L, 0L) & SIGBREAKF_CTRL_C)
      {
        SetSignal(0L, SIGBREAKF_CTRL_C);

        break;
      }

      Delay(5);
    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
