/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getcmcolors()
 *
*/

#include "../gid.h"



void dumpcolors(struct ColorSpec *cs)
{
  struct ColorSpec *pcs = cs;


  while(pcs->ColorIndex > -1)
  {
    FPrintf(Output(), "%3ld %3ld %3ld %3ld\n",
          pcs->ColorIndex, pcs->Red, pcs->Green, pcs->Blue);

    pcs++;
  }
}

int GID_main(void)
{
  struct Screen *screen;
  struct ColorSpec colors[] =
  {
    { 0, 0, 0, 0}, 
    { 1, 0, 0, 0},
    { 2, 0, 0, 0},
    { 3, 0, 0, 0},
    {-1, 0, 0, 0}     // Table terminator, quite important!
  };


  /*
   * Lock Workbench screen so we can safely inspect this and
   * that.
  */
  if ((screen = ctl_lockscreensafe(NULL)))
  {
    /*
     * Try to fetch Workbench cruicial palette entries. They
     * will be expressed 4 bits per gun!
    */
    nfo_getcmcolors(&colors[0],
                           screen->ViewPort.ColorMap, 0, 4);

    dumpcolors(colors);

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
