/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_vpsnprintf()
 *
*/

#include "../gid.h"



LONG myprintf(UBYTE *buf, LONG size, const UBYTE *fmt, ...)
{
  va_list ap;
  LONG res;


  va_start(ap, fmt);

  res = txt_vpsnprintf(buf, size, fmt, ap);

  va_end(ap);

  return res;
}

/*
 * If you need to embed variable args and string formating
 * in your own func. then 'txt_vpsnprintf()' will do. See
 * the autodocs or 'txt_psnprintf' directory for fmt. opts.
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
