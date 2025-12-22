/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_bcopydevice()
 *
*/

#include "../gid.h"

#define MYDEVICE   "MyDevice0:"
#define BUFSIZE    32



int GID_main(void)
{
  UBYTE *mem;
  BSTR ptr;


  if ((mem = AllocVec(BUFSIZE, MEMF_PUBLIC | MEMF_CLEAR)))
  {
    /*
     * This function will produce unscrambled BSTR, so we
     * will have to do the rest.
    */
    ptr = QDEV_HLP_MKBADDR(
                 dos_bcopydevice(mem, MYDEVICE, BUFSIZE));

    FPrintf(Output(), "%b\n", ptr);

    FreeVec(mem);
  }

  return 0;
}
