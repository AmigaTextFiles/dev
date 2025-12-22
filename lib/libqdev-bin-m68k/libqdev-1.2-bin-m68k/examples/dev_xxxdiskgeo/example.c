/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dev_getdiskgeo()
 * dev_freediskgeo()
 *
*/

#include "../gid.h"

#define DEVICENAME   "scsi.device"
#define DEVICEUNIT   0



int GID_main(void)
{
  struct dev_ddv_data *dd;
  struct DriveGeometry *dg;


  /*
   * OK, firstly try to access the device driver. This is as
   * simple as can be.
  */
  if ((dd = dev_opendiskdev(DEVICENAME, DEVICEUNIT, 0)))
  {
    /*
     * Then take its parameters and show them to the user in
     * human readable form.
    */
    if ((dg = dev_getdiskgeo(dd)))
    {
      FPrintf(Output(), "dg_SectorSize   = %ld\n"
                        "dg_TotalSectors = %ld\n"
                        "dg_Cylinders    = %ld\n"
                        "dg_CylSectors   = %ld\n"
                        "dg_Heads        = %ld\n"
                        "dg_TrackSectors = %ld\n"
                        "dg_BufMemType   = 0x%08lx\n"
                        "dg_DeviceType   = 0x%08lx\n"
                        "dg_Flags        = 0x%08lx\n",
                                    dg->dg_SectorSize,
                                  dg->dg_TotalSectors,
                                     dg->dg_Cylinders,
                                    dg->dg_CylSectors,
                                         dg->dg_Heads,
                                  dg->dg_TrackSectors,
                                    dg->dg_BufMemType,
                                    dg->dg_DeviceType,
                                        dg->dg_Flags);

      dev_freediskgeo(dg);
    }

    dev_closediskdev(dd);
  }
  else
  {
    FPrintf(Output(), "Error: unable to access the device!\n");
  }

  return 0;
}
  