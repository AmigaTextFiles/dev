/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_findgfxrange()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  ULONG rlo;
  ULONG rhi;


  /*
   * Firstly you will have to tell the function what range it is
   * allowed to seek within. Let it be native monitor area, but
   * with the exclusion of boot monitor!
  */
  rlo = 0xFFFF;

  rhi = 0xAFFFF;

  /*
   * Now lets try to determine effective PAL monitor modeid range.
  */
  if (nfo_findgfxrange("PAL", &rlo, &rhi))
  {
    FPrintf(Output(),
             "PAL monitor range: 0x%08lx - 0x%08lx\n", rlo, rhi);
  }

  return 0;
}
