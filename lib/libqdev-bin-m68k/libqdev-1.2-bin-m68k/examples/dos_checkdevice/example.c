/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dos_checkdevice()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct DosList *dol;


  /*
   * This will allow to locate the device without the need to talk
   * to it.
  */
  QDEV_HLP_NOSWITCH
  (
    dol = dos_checkdevice("RAM:", DLT_DEVICE);
  );

  FPrintf(Output(), "dol = 0x%08lx\n", (LONG)dol);

  return 0;
}
