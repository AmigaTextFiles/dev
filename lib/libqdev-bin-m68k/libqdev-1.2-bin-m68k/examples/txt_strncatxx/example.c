/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strncat()
 * txt_strncatlc()
 * txt_strncatuc()
 *
*/

#include "../gid.h"

#define TEXT   "Hello!"



/*
 * Unlike standard C library function 'strncat()' this one
 * allows safe concatenation of NULL terminated strings.
 * Number of bytes is not exactly how much to copy, but how
 * much can be fit.
*/
int GID_main(void)
{
  UBYTE *text = TEXT;
  UBYTE string[17 + 1];
  LONG res;


  /*
   * Before using on uninitialized vars, NULL the very first
   * byte!
  */
  string[0] = '\0';

  res = txt_strncat(string, text, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  res = txt_strncatlc(string, text, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  /*
   * This one will cause harmless overflow!
  */
  res = txt_strncatuc(string, text, sizeof(string));

  FPrintf(Output(),
              "res = %ld, string = %s\n", res, (LONG)string);

  return 0;
}
