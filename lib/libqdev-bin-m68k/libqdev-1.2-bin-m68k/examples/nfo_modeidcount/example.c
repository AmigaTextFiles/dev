/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_modeidcount()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG idcount;


  /*
   * Counting screenmodes may be pointless at first but this
   * is the best way to detect if certain monitor driver did
   * not init.
  */
  idcount = nfo_modeidcount();

  FPrintf(Output(), "idcount = %ld\n", idcount);

  return 0;
}
