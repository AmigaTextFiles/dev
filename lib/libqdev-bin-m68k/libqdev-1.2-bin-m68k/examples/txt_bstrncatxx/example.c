/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_bstrncat()
 * txt_bstrncatlc()
 * txt_bstrncatuc()
 *
*/

#include "../gid.h"



/*
 * Unlike standard C library function 'strncat()' this one
 * allows safe concatenation of BSTR strings. Number of bytes
 * is not exactly how much to copy, but how much can be fit.
 * For demonstraion reasons BSTR is 'static' so that it gets
 * LONG aligned automatically.
*/
int GID_main(void)
{
  static UBYTE bstring[] = {6, 'H', 'e', 'l', 'l', 'o', '!'};
  UBYTE string[17 + 1];
  BSTR ptr;
  LONG res;


  ptr = QDEV_HLP_MKBADDR(bstring);

  /*
   * Before using on uninitialized vars, NULL the very first
   * byte!
  */
  string[0] = '\0';

  res = txt_bstrncat(string, ptr, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  res = txt_bstrncatlc(string, ptr, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  /*
   * This one will cause harmless overflow!
  */
  res = txt_bstrncatuc(string, ptr, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  return 0;
}
