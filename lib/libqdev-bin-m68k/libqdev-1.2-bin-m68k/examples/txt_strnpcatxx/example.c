/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strnpcat()
 * txt_strnpcatlc()
 * txt_strnpcatuc()
 *
*/

#include "../gid.h"

#define TEXT   "Hello!"



/*
 * This function is very different from 'strncat()' in the
 * way that it does not try to locate the NULL terminator at
 * all! This function is considered super fast plus allows
 * exact pointer states to be saved per call!
*/
int GID_main(void)
{
  UBYTE *text = TEXT;
  UBYTE string[17 + 1];
  LONG addr;
  LONG size;
  LONG res;


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

  res = txt_strnpcat(&addr, text, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  res = txt_strnpcatlc(&addr, text, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  /*
   * This one will cause harmless overflow!
  */
  res = txt_strnpcatuc(&addr, text, &size);

  FPrintf(Output(),
      "res = %ld, addr = 0x%08lx, size = %ld, string = %s\n",
                              res, addr, size, (LONG)string);

  return 0;
}
