/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_memcmp()
 * txt_memicmp()
 *
*/

#include "../gid.h"

/*
 * This example uses just text, but only to show that case
 * insensitive memory compare is also useful!
*/
#define TEXT1   "Hey! Guess what, the other line is the same?"
#define TEXT2   "Hey! Guess what, The other line is the same"



int GID_main(void)
{
  LONG min;
  UBYTE *ptr1 = TEXT1;
  UBYTE *ptr2 = TEXT2;


  min = QDEV_HLP_MIN(sizeof(TEXT1) - 1, sizeof(TEXT2) - 1);

  if (txt_memcmp(ptr1, ptr2, min))
  {
    FPrintf(Output(), "txt_memcmp(): Not!\n");
  }

  if (txt_memicmp(ptr1, ptr2, min) == 0)
  {
    /*
     * In fact strings are different in size, but we are not
     * comparing strings but memory regions!
    */
    FPrintf(Output(), "txt_memicmp(): Indeed!\n");
  }

  return 0;
}
