/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_findgfxentry()
 *
*/

#include "../gid.h"

#define NEWDEFDEPTH   8
#define RESOLUTION    "640x512x3 similar"



/*
 * I urge you to see the documentation regarding this func.
 * as it is way powerful! This example is just a stub.
*/
int GID_main(void)
{
  ULONG depth;
  ULONG modeid;

  
  /*
   * If you need to set new default depth then put it in the
   * high 16 bits of the datatype.
  */
  depth = (NEWDEFDEPTH << 16);

  modeid = nfo_findgfxentry(RESOLUTION, &depth);

  /*
   * After the function call is complete you can inspect the
   * lower 16 bits to see what user did specify.
  */
  depth &= ~0xFFFF0000;

  FPrintf(Output(),
          "modeid = 0x%08lx, depth = %ld\n", modeid, depth);

  return 0;
}
