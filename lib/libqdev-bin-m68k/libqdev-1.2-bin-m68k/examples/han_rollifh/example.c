/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * han_rollifh()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  UBYTE get[64];
  UBYTE buf[44];
  LONG read;
  LONG fd;


  /*
   * Lets access the virtual file using binary handler, which
   * implements circular 'Write()' and EOF 'Read()' and sort
   * of cursor control by using 'Seek()'.
  */
  if ((fd = mem_openifh(buf, sizeof(buf), han_rollifh)))
  {
    /*
     * OK. The very first line of text is exactly 43 bytes
     * long. The next one is 7 bytes long.
    */
    FPuts(fd, "Magic Trick is when file handle allows it!\n");

    FPuts(fd, "Majic!\n");

    /*
     * Initialize read cursor. This does not really work like
     * seek on regular files. Following call will b of effect
     * only when at least one write was performed!
    */
    Seek(fd, 0, OFFSET_BEGINNING);

    /*
     * Now read the contents with just 'Read()' func. so that
     * whole buffer can be grabbed.
    */
    if ((read = Read(fd, get, sizeof(get) - 1)))
    {
      get[read] = '\0';

      /*
       * Get your 3 letters to the shell and see what happens
       * when you run this example.
      */
      FPuts(Output(), get);
    }

    mem_closeifh(fd);
  }

  return 0;
}
