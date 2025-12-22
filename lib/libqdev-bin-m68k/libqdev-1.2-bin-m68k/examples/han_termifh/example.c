/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * han_termifh()
 *
*/

#include "../gid.h"



/*
 * Be aware that this packet handler is quite newcomer
 * and as i do not have the time to work on it, it may
 * contain a lot of bugs. Especially color handling is
 * broken! This memo written 09-Oct-2012, handler code
 * last altered 14-Sep-2012.
*/
int GID_main(void)
{
  void *term;
  UBYTE buf[128];
  LONG read;
  LONG fd;


  /*
   * This handler is very different from other handlers!
   * First most important thing is to allocate terminal
   * area.
  */
  if ((term = mem_allocterm(80, 25, -1)))
  {
    /*
     * And then we can obtain the filehandle through ifh
     * subsystem.
    */
    if ((fd = mem_openifh(term, 0, han_termifh)))
    {
      /*
       * Lets output something to the virtual terminal.
      */
      FPuts(fd, "\x1B[10;10H\x1B[32;43m"
                "Hello World!"
                "\x1B[m");

      /*
       * Clear real terminal before reading virtual one.
      */
      Write(Output(), "\x1B" "c", 2);

      /*
       * Request term. area access. Normally this is DSR
       * feedback.
      */
      SetMode(fd, QDEV_HAN_SMTERM_TERM);

      /*
       * Request positional dump. Data will be somewhat
       * similar.
      */
      Seek(fd, 0, 0);

      while ((read = Read(fd, buf, sizeof(buf))) > 0)
      {
        Write(Output(), buf, read);
      }

      Write(Output(), "\n", 1);

      mem_closeifh(fd);
    }

    mem_freeterm(term);
  }

  return 0;
}
