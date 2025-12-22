/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getscparams()
 *
*/

#include "../gid.h"

/*
 * Lets define the range in full since that is a check!
*/
#define RANGE_LO   0x00000000
#define RANGE_HI   0xFFFFFFFF



int GID_main(void)
{
  ULONG modeid;
  UWORD depth;


  /*
   * This function allows to obtain modeid and the depth of
   * particular screen. NULL means Workbench, even if it is
   * closed this function will try to obtain its parameters
   * from 'screenmode.prefs' file.
  */
  if (nfo_getscparams(NULL, &modeid, &depth))
  {
    /*
     * If you were requesting Workbench parameters you must
     * verify the modeid!
    */
    if (nfo_findgfxsm(modeid, 0, RANGE_LO, RANGE_HI))
    {
      /*
       * Happily all is OK.
      */
      FPrintf(Output(),
         "modeid = 0x%08lx, depth = %ld\n", modeid, depth);
    }
  }

  return 0;
}
