/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_typeofgfxmem()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct Screen *screen;
  LONG native = 0;
  LONG foreign = 0;
  LONG modeid;


  /*
   * This will check what is the global type of graphics
   * memory. Native chipset can still be enhanced by the
   * almighty 'fblit' though.
  */
  native = nfo_typeofgfxmem(INVALID_ID);

  /*
   * You can also try per screen check, that may be CGX/
   * P96 hosted, so that any memory will do for blitting.
  */
  if ((screen = ctl_lockscreensafe("*")))
  {
    modeid = GetVPModeID(&screen->ViewPort);

    foreign = nfo_typeofgfxmem(modeid);

    ctl_unlockscreensafe(screen);
  }

  FPrintf(Output(), "native = 0x%08lx\n", native);

  FPrintf(Output(), "foreign = 0x%08lx\n", foreign);

  return 0;
}
