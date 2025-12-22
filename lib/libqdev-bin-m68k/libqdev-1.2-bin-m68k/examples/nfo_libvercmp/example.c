/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_libvercmp()
 *
*/

#include "../gid.h"

#define LIBRARYMINV   0
#define LIBRARYNAME   "graphics.library"
#define LIBRARYPATT   "#?(18.5.93)#?"



int GID_main(void)
{
  /*
   * This function although simple, gives great possibilities!
  */
  if (nfo_libvercmp(QDEV_NFO_XXXVERCMP_MEM,
                       LIBRARYNAME, LIBRARYMINV, LIBRARYPATT) > -1)
  {
    FPrintf(Output(), "Looks like you are using ROM 3.1, good!\n");
  }
  else
  {
    FPrintf(Output(),
                 "Humm, what kind of graphics.library is that?\n");
  }

  return 0;
}
