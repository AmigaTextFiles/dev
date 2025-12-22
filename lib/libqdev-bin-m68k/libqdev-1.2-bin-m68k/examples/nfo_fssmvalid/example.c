/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_fssmvalid()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct DosList *dol;
  struct FileSysStartupMsg *fssm;


  /*
   * Suppose that you need to know what kind of device
   * DF0 is using. Of course its 'trackdisk.device', but
   * is it safe to peek the startup message?
  */
  if ((dol = LockDosList(
                 LDF_READ | LDF_DEVICES | LDF_VOLUMES)))
  {  
    if ((dol = FindDosEntry(
                dol, "DF0", LDF_DEVICES | LDF_VOLUMES)))
    {
      if ((fssm = nfo_fssmvalid(QDEV_HLP_BADDR(
               dol->dol_misc.dol_handler.dol_Startup))))
      {
        /*
         * Looks like FSSM is all valid!
        */
        FPrintf(Output(), "DF0 = %b %ld\n",
                    fssm->fssm_Device, fssm->fssm_Unit);
      }
    }

    UnLockDosList(LDF_READ | LDF_DEVICES | LDF_VOLUMES);
  }

  return 0;
}
