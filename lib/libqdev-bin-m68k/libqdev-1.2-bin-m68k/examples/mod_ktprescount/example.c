/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_ktprescount()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG count;


  /*
   * This function can quickly determine amount of KTP modules.
  */
  count = mod_ktprescount();

  FPrintf(Output(), "count = %ld\n", count);

  return 0;
}
