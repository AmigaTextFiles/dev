/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isprime()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  FPrintf(Output(), "%ld\n", nfo_isprime(123)); 

  FPrintf(Output(), "%ld\n", nfo_isprime(127)); 

  return 0;
}
