/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_dopacket()
 *
*/

#include "../gid.h"

#define TESTFILE "example.c"



int GID_main(void)
{
  struct FileHandle *fh;
  UBYTE buf[118];
  LONG read;
  LONG fd;


  /*
   * Lets open this file the standard way and extract FileHandle
   * stuff.
  */
  if ((fd = Open(TESTFILE, MODE_OLDFILE)))
  {
    fh = QDEV_HLP_BADDR(fd);

    /*
     * Lets now emulate 'Read()' function with 'dos_dopacket()'.
    */
    read = dos_dopacket(fh->fh_Type, ACTION_READ,
                     fh->fh_Arg1, (LONG)buf, sizeof(buf), 0, 0);

    if (read > 0)
    {
      buf[read - 1] = '\0';

      FPuts(Output(), buf);
    }

    Close(fd);
  }

  return 0;
}
