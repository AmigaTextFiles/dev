/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_debugprintf()
 *
*/

#include "../gid.h"

#define WRITELIMIT   128



void serialoutput(void)
{
  /*
   * This function is like so famous 'kprintf()', but allows
   * to set write limit and uses 'txt_vcbpsnprintf()'.
  */
  txt_debugprintf(WRITELIMIT,
               "This will be send over the serial port!\n");
}

/*
 * Hacking is also possible though. You can easily convert
 * or redirect the output.
*/
#define _RawPutChar(chr)                 \
({                                       \
  ULONG ichr = (chr << 24);              \
  Write(Output(), &ichr, 1);             \
})
#define _RawIOInit()
#define txt_debugprintf txt_debugprintf2
#define txt_vdebugprintf txt_vdebugprintf2
#include "../../lib/p-txt_debugprintf.c"

void consoleoutput(void)
{
  txt_debugprintf2(WRITELIMIT,
              "This will appear in the current console!\n");
}

int GID_main(void)
{
  serialoutput();

  consoleoutput();

  return 0;
}
