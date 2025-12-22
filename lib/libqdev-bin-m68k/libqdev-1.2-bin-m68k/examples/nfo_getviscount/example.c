/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getviscount()
 *
*/

#include "../gid.h"

#define CONSOLEWIN   "CON:////Console/SCREEN*"



int GID_main(void)
{
  struct Screen *screen;
  LONG viscount1 = 0;
  LONG viscount2 = 0;
  LONG fd;


  /*
   * Lets lock current public screen and get the visitor count.
   * Notice that we are also considered visitor!
  */
  if ((screen = ctl_lockscreensafe("*")))
  {
    viscount1 = nfo_getviscount(screen);

    /*
     * Now lets open the console window on this very pubscreen.
    */
    if ((fd = Open(CONSOLEWIN, MODE_OLDFILE)))
    {
      /*
       * In this example we do not check against negative count
       * but you should really watch for this as some programs
       * are broken...
      */
      viscount2 = nfo_getviscount(screen);

      Close(fd);
    }

    FPrintf(Output(),
            "Before: %ld, After: %ld\n", viscount1, viscount2);

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
