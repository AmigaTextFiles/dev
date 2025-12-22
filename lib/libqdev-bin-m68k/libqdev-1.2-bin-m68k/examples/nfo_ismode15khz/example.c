/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_ismode15khz()
 *
*/

#include "../gid.h"

#define PALMODEID     0x00029000
#define DBLPALMODEID  0x000A9000



/*
 * Function 'nfo_ismode15khz()' was designed to detect PAL
 * or NTSC screenmodes mainly without the need to query the
 * OS.
*/
int GID_main(void)
{
  if (nfo_ismode15khz(PALMODEID))
  {
    FPrintf(Output(),
               "0x%08lx is 15khz screenmode.\n", PALMODEID);
  }

  if (!nfo_ismode15khz(DBLPALMODEID))
  {
    FPrintf(Output(),
        "0x%08lx is not 15khz screenmode.\n", DBLPALMODEID);
  }

  return 0;
}
