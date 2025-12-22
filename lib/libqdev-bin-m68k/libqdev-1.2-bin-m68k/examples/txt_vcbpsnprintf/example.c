/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_vcbpsnprintf()
 *
*/

#include "../gid.h"



__interrupt void mycharput(
              REGARG(UBYTE *ptr, a0), REGARG(LONG chr, d0))
{
  /*
   * A 'ptr' is the pointer within 'buf', a 'chr' is curr.
   * character to be put somewhere.
  */
  *ptr = chr;
}

LONG myprintf(UBYTE *buf, LONG size, const UBYTE *fmt, ...)
{
  va_list ap;
  LONG res;


  va_start(ap, fmt);

  res = txt_vcbpsnprintf(mycharput, buf, size, fmt, ap);

  va_end(ap);

  return res;
}

/*
 * If you need to construct printf-alike function that does
 * output in a specific memory region, then just modify the
 * 'mycharput()' and you are done. The 'txt_vcbpsnprintf()'
 * is pseudo/soft-interrupt safe and does not generate the
 * debug messages under any circumstances!
*/
int GID_main(void)
{
  UBYTE buf[128];
  LONG size;


  buf[0] = '\0';

  size = myprintf(
           buf, sizeof(buf), "Output? %s", "What output?");

  FPrintf(Output(), "%ld = %s\n", size, (LONG)buf);

  return 0;
}
