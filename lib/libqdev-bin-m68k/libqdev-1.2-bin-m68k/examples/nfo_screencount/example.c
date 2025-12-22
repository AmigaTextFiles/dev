/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_screencount()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG scrcount;


  /*
   * Counting screens may be pointless at first but this
   * can be handy when trying to detect whether screen that
   * was ought to open did not open.
  */
  scrcount = nfo_screencount();

  FPrintf(Output(), "scrcount = %ld\n", scrcount);

  return 0;
}
