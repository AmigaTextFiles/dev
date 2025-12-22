/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_ktm()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  ULONG addr;
  ULONG flags;


  /*
   * KTM makes it all easy to fiddle with the tasks. All basic
   * ops make life easier. The function can even replace the
   * 'FindTask()' with much better functionality as it can also
   * search in processes! Not much of an example here, so you
   * will have to discover most of the features ;-) .
  */
  flags = QDEV_NFO_KTM_FMASS;

  addr = nfo_ktm(Output(), "-2,-3,-4", flags, 0);

  FPrintf(Output(), "addr = 0x%08lx\n", addr);

  return 0;
}
