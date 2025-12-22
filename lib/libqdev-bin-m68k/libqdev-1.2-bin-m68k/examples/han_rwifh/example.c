/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * han_rwifh()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  UBYTE get[128];
  UBYTE buf[128];
  LONG fd;


  /*
   * Read/Write handler makes the  virtual file behave like any
   * other file. Things implemented are 'Write()', 'Read()' &
   * 'Seek()'.
  */
  if ((fd = mem_openifh(buf, sizeof(buf), han_rwifh)))
  {
    /*
     * To read the contents of such a file one will have to
     * provide the contents first. Of course you can do write
     * anything you like, and not just text.
    */
    FPuts(fd,
    "I'm a line of text and i will be put into teh buffer!\n");

    /*
     * Now seek to top of file and read the contents until EOF.
    */
    Seek(fd, 0, OFFSET_BEGINNING);

    while (FGets(fd, get, sizeof(get)))
    {
      FPuts(Output(), get);
    }

    mem_closeifh(fd);
  }

  return 0;
}
