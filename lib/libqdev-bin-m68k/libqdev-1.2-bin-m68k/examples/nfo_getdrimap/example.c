/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getdrimap()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  QDEV_NFO_DRIMAPTYPEI(drimap);
  struct Screen *screen;


  /*
   * Lock Workbench screen so we can safely inspect this and
   * that.
  */
  if ((screen = ctl_lockscreensafe(NULL)))
  {
    /*
     * Try to import Workbench pen mapping table that is used
     * to describe UI related details.
    */
    if (nfo_getdrimap(drimap, screen))
    {
      FPrintf(Output(), "DETAILPEN        = %ld\n"
                        "BLOCKPEN         = %ld\n"
                        "TEXTPEN          = %ld\n"
                        "SHINEPEN         = %ld\n"
                        "SHADOWPEN        = %ld\n"
                        "FILLPEN          = %ld\n"
                        "FILLTEXTPEN      = %ld\n"
                        "BACKGROUNDPEN    = %ld\n"
                        "HIGHLIGHTTEXTPEN = %ld\n"
                        "BARDETAILPEN     = %ld\n"
                        "BARBLOCKPEN      = %ld\n"
                        "BARTRIMPEN       = %ld\n",
                                 drimap[DETAILPEN],
                                  drimap[BLOCKPEN],
                                   drimap[TEXTPEN],
                                  drimap[SHINEPEN],
                                 drimap[SHADOWPEN],
                                   drimap[FILLPEN],
                               drimap[FILLTEXTPEN],
                             drimap[BACKGROUNDPEN],
                          drimap[HIGHLIGHTTEXTPEN],
                              drimap[BARDETAILPEN],
                               drimap[BARBLOCKPEN],
                               drimap[BARTRIMPEN]);
    }

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
 