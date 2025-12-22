/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_ispdev64bit()
 *
*/

#include "../gid.h"

#define DEVICENAME   "SYS:"



int GID_main(void)
{
  LONG state;


  /*
   * Even simplier than 'nfo_isdev64bit()' as you just need to
   * pass handler name. Needless to say that this can be used
   * to query devices that are in use.
  */
  state = nfo_ispdev64bit(DEVICENAME);

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
