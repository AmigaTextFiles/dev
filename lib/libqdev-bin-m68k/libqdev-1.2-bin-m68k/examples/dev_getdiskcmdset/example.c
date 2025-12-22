/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dev_getdiskcmdset()
 *
*/

#include "../gid.h"

#define DEVICENAME   "scsi.device"
#define DEVICEUNIT   0



int GID_main(void)
{
  struct dev_ddv_data *dd;
  LONG devtype;


  /*
   * It was never so simple to access the TD device. No dreaded
   * message port creation, nor request space nor OpenDevice().
  */
  if ((dd = dev_opendiskdev(DEVICENAME, DEVICEUNIT, 0)))
  {
    /*
     * Now lets query the device to see what it is capabale of.
    */
    devtype = dev_getdiskcmdset(dd);

    if (devtype & QDEV_DEV_DISKCMDSET_NSD64)
    {
      FPrintf(Output(), "Device supports NSD64 extensions.\n");
    }

    if (devtype & QDEV_DEV_DISKCMDSET_TD64)
    {
      FPrintf(Output(), "Device supports TD64 extensions.\n");
    }

    dev_closediskdev(dd);
  }
  else
  {
    FPrintf(Output(), "Error: unable to access the device!\n");
  }

  return 0;
}
