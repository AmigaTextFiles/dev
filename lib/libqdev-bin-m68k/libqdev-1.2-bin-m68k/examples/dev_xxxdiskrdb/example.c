/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dev_getdiskrdb()
 * dev_freediskrdb()
 *
*/

#include "../gid.h"

#define DEVICENAME   "scsi.device"
#define DEVICEUNIT   0



int GID_main(void)
{
  struct dev_ddv_data *dd;
  struct RigidDiskBlock *rdb;


  /*
   * OK, firstly try to access the device driver. This is as
   * simple as can be.
  */
  if ((dd = dev_opendiskdev(DEVICENAME, DEVICEUNIT, 0)))
  {
    /*
     * Then read the RDB off the disk and show some of the p.
     * to the user in human readable form.
    */
    if ((rdb = dev_getdiskrdb(dd)))
    {
      FPrintf(Output(), "rdb_SummedLongs   = %ld\n"
                        "rdb_BlockBytes    = %ld\n"
                        "rdb_Flags         = 0x%08lx\n"
                        "rdb_Cylinders     = %ld\n"
                        "rdb_Sectors       = %ld\n"
                        "rdb_Heads         = %ld\n"
                        "rdb_LoCylinder    = %ld\n"
                        "rdb_HiCylinder    = %ld\n"
                        "rdb_HighRDSKBlock = %ld\n",
                               rdb->rdb_SummedLongs,
                                rdb->rdb_BlockBytes,
                                     rdb->rdb_Flags,
                                 rdb->rdb_Cylinders,
                                   rdb->rdb_Sectors,
                                     rdb->rdb_Heads,
                                rdb->rdb_LoCylinder,
                                rdb->rdb_HiCylinder,
                            rdb->rdb_HighRDSKBlock);

      dev_freediskrdb(rdb);
    }

    dev_closediskdev(dd);
  }
  else
  {
    FPrintf(Output(), "Error: unable to access the device!\n");
  }

  return 0;
}
  