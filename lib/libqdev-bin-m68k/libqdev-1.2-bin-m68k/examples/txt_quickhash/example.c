/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_quickhash()
 * txt_quickihash()
 *
*/

#include "../gid.h"

#define TEXT   "The quick brown fox jumps over the lazy dog"



/*
 * This routine is very weak. Use it where high collission
 * rate does not matter that much. One can use this routine
 * to encode symbolic passwords for instance.
*/
int GID_main(void)
{
  ULONG hash;


  hash = txt_quickhash(TEXT);

  FPrintf(Output(), "0x%08lx\n", hash);

  hash = txt_quickihash(TEXT);

  FPrintf(Output(), "0x%08lx\n", hash);

  return 0;
}
