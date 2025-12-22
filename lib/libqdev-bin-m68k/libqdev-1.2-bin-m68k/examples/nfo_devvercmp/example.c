/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_devvercmp()
 *
*/

#include "../gid.h"

#define DEVICEMINV   43
#define DEVICEUNIT    0
#define DEVICENAME   "scsi.device"
#define DEVICEPATT   "#?IDE-fix#?"



int GID_main(void)
{
  /*
   * This function although simple, gives great possibilities!
  */
  if (nfo_devvercmp(QDEV_NFO_XXXVERCMP_MEM,
                       DEVICENAME, DEVICEUNIT, 0, DEVICEPATT) > -1)
  {
    FPrintf(Output(), "Looks like you are using IDE-fix, good!\n");
  }
  else
  {
    if (nfo_devvercmp(QDEV_NFO_XXXVERCMP_MEM,
                    DEVICENAME, DEVICEUNIT, DEVICEMINV, NULL) > -1)
    {
      FPrintf(
          Output(), "Your scsi.device supports 64bit commands!\n");
    }
    else
    {
      FPrintf(
            Output(), "Sorry, but your scsi.device is too old!\n");
    }
  }

  return 0;
}
