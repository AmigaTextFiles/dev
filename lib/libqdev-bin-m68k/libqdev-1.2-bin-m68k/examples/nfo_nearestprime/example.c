/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_nearestprime()
 *
*/

#include "../gid.h"



/*
 * This function sucks when it comes to time critial ops,
 * it is slow...
*/
int GID_main(void)
{
  FPrintf(Output(), "%ld\n", nfo_nearestprime(60000)); 

  FPrintf(Output(), "%ld\n", nfo_nearestprime(980000)); 

  FPrintf(Output(), "%ld\n", nfo_nearestprime(3800000)); 

  return 0;
}
