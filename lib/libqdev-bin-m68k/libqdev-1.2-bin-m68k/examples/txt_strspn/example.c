/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strspn()
 *
*/

#include "../gid.h"

#define TEXT  "###This is where the text starts."
#define CHRS  "#"



/*
 * This function should return value of 3, which is
 * the byte right after last hash character!
*/
int GID_main(void)
{
  LONG span;


  span = txt_strspn(TEXT, CHRS);

  FPrintf(Output(), "%ld\n", span);  

  return 0;
}
