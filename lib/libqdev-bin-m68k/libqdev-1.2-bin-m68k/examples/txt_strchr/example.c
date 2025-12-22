/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strchr()
 * txt_strichr()
 *
*/

#include "../gid.h"

#define TEXT "DH0:Programs/Internet/Chat/AmIRC/AmIRC"



UBYTE *myfilepart(UBYTE *in)
{
  UBYTE *optr;
  UBYTE *ptr;


  if ((optr = txt_strchr(in, ':')))
  {
    optr++;

    ___check:

    while ((ptr = txt_strchr(optr, '/')))
    {
      optr = ++ptr;
    }

    return optr;
  }
  else
  {
    optr = in;

    goto ___check;
  }

  /*
   * This will not be reached but compiler will do fart
   * a warning if it is not here ;-) .
  */
  return NULL;
}

/*
 * This example demonstrates how to emulate 'FilePart()'
 * with 'txt_strchr()'.
*/
int GID_main(void)
{
  FPrintf(
        Output(), "File: %s\n", (LONG)myfilepart(TEXT));

  return 0;
}
