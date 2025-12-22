/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_devbymsgport()
 *
*/

#include "../gid.h"

#define SOURCEFILE   "example.c"



int GID_main(void)
{
  struct DosList *dol;
  struct FileHandle *fh;
  LONG fd;


  /*
   * OK, so we are going to open the source code of this very
   * example, but we have no idea of the device this file sits
   * on. What do we do?
  */
  if ((fd = Open(SOURCEFILE, MODE_OLDFILE)))
  {
    /*
     * Lets get into the message port of this file handler and
     * lets pass it to the magic function.
    */
    fh = QDEV_HLP_BADDR(fd);

    if ((dol = dos_devbymsgport(fh->fh_Type)))
    {
      FPrintf(Output(), "device: %b\n", dol->dol_Name);
    }

    Close(fd);
  }

  return 0;
}
