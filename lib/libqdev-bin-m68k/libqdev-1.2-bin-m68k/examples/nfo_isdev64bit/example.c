/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isdev64bit()
 *
*/

#include "../gid.h"

#define DEVICENAME   "scsi.device"
#define DEVICEUNIT   0



int GID_main(void)
{
  LONG state;


  state = nfo_isdev64bit(DEVICENAME, DEVICEUNIT);

  if (state != QDEV_NFO_ISDEV64BIT_ERR)
  {
    if (state == QDEV_NFO_ISDEV64BIT_NOPE)
    {
      FPrintf(Output(),
                 "This device does not support 64bit commands!\n");
    }
    else
    {
      if (state & QDEV_NFO_ISDEV64BIT_NSD64)
      {
        FPrintf(Output(), "This device accepts NSD64 commands.\n");
      }

      if (state & QDEV_NFO_ISDEV64BIT_TD64)
      {
        FPrintf(Output(), "This device accepts TD64 commands.\n");
      }
    }
  }
  else
  {
    FPrintf(Output(), "Error! Cannot access the device!\n");
  }

  return 0;
}
