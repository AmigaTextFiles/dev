/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_relocdrimap()
 *
*/

#include "../gid.h"

/*
 * This should be the depth of your newly created screen.
 * One good reason to provide it is not only to shift the
 * pens, but also to fix last n screen colors that the
 * 'drimap' can reference! Suppose that the BARBLOCKPEN
 * uses pen number 255 on your 8+ bit Workbench, but your
 * new screen has only 16 colors, so it must be fixed to
 * reference pen number 15.
*/
#define FAKEDEPTH  4



void dumpdrimap(WORD *drimap, UBYTE *name)
{
  FPrintf(Output(), "\n%s\n"
              "%5ld %5ld %5ld %5ld %5ld %5ld %5ld %5ld\n"
              "%5ld %5ld %5ld %5ld %5ld %5ld %5ld %5ld\n",
                                               (LONG)name,
               drimap[0], drimap[1], drimap[2], drimap[3],
               drimap[4], drimap[5], drimap[6], drimap[7],
             drimap[8], drimap[9], drimap[10], drimap[11], 
          drimap[12], drimap[13], drimap[14], drimap[15]);
}

void dumpcmap(struct ColorSpec *cs)
{
  struct ColorSpec *pcs = cs;


  FPrintf(Output(), "CS:\n");

  while (pcs->ColorIndex > -1)
  {
    FPrintf(Output(), " Pen = %3ld {%3ld, %3ld, %3ld}\n",
     pcs->ColorIndex,  pcs->Red,  pcs->Green,  pcs->Blue);

    pcs++;
  }
}

/*
 * Pen mapping relocation is useful when a group of colors
 * (OS hardcoded for instance), needs to be moved to a new
 * location.
*/
int GID_main(void)
{
  struct Screen *screen;
  QDEV_NFO_DRIMAPTYPEI(drimap);
  QDEV_CTL_CS_ANSICMAP(cmap);


  /*
   * Try to l. Workbench screen and copy its first 4 pens
   * into 'cmap' starting at entry QDEV_CTL_CS_ANSIREL.
  */
  if ((screen = ctl_lockscreensafe(NULL)))
  {
    nfo_getcmcolors(&cmap[QDEV_CTL_CS_ANSIREL], 
                         screen->ViewPort.ColorMap, 0, 4);

    dumpcmap(cmap);

    /*
     * Then obtain pen mapping table, and fix it so that
     * typical OS details will be rendered with the very
     * same colors starting at QDEV_CTL_CS_ANSIREL.
    */
    if (nfo_getdrimap(drimap, screen))
    {
      dumpdrimap(drimap, "BEFORE:");

      ctl_relocdrimap(
                  drimap, QDEV_CTL_CS_ANSIREL, FAKEDEPTH);

      dumpdrimap(drimap, "AFTER:");
    }

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
