/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_findgfxsm()
 *
*/

#include "../gid.h"

/*
 * Lets define the range excluding boot monitor, so that no wierd
 * modeid values will be returned. At this point we do allow all
 * screenmodes.
*/
#define RANGE_LO   0x0000FFFF
#define RANGE_HI   0xFFFFFFFF

/*
 * PAL:High Res Laced
*/
#define MODEID     0x00029004



int GID_main(void)
{
  DisplayInfoHandle dih;


  /*
   * This function can be used to tell if the modeid does exist,
   * and/or the monitor driver does work.
  */
  if ((dih = nfo_findgfxsm(MODEID, 0, RANGE_LO, RANGE_HI)))
  {
    /*
     * You can use GetDisplayInfoData(dih, ...) at this point to
     * obtain more info.
    */
    FPrintf(Output(), "Requested modeid is valid.\n");
  }
  else
  {
    FPrintf(Output(), "Requested modeid is invalid!\n");
  }

  return 0;
}
