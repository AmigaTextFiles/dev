/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strcspn()
 *
*/

#include "../gid.h"

#define TEXT  "As long as there is no # we are cool. We are not!"
#define CHRS  "#"



/*
 * This function should return value of 23, which is
 * the byte right before the hash character!
*/
int GID_main(void)
{
  LONG span;


  span = txt_strcspn(TEXT, CHRS);

  FPrintf(Output(), "%ld\n", span);  

  return 0;
}
