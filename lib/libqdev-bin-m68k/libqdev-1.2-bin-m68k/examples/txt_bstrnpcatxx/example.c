/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_bstrnpcat()
 * txt_bstrnpcatlc()
 * txt_bstrnpcatuc()
 *
*/

#include "../gid.h"



/*
 * This function is very different from 'strncat()' in the
 * way that it does not try to locate the NULL terminator at
 * all! This function is considered super fast plus allows
 * exact pointer states to be saved per call!
*/
int GID_main(void)
{
  static UBYTE bstring[] = {6, 'H', 'e', 'l', 'l', 'o', '!'};
  UBYTE string[17 + 1];
  BSTR ptr;
  LONG addr;
  LONG size;
  LONG res;


  ptr = QDEV_HLP_MKBADDR(bstring);

  /*
   * Before using on uninitialized vars, NULL the very first
   * byte!
  */
  string[0] = '\0';

  /*
   * Then load datatypes with some meaningful data and pass
   * their pointers.
  */
  addr = (LONG)string;

  size = sizeof(string);

  res = txt_bstrnpcat(&addr, ptr, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  res = txt_bstrnpcatlc(&addr, ptr, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  /*
   * This one will cause harmless overflow!
  */
  res = txt_bstrnpcatuc(&addr, ptr, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  return 0;
}
