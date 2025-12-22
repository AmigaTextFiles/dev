/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_adddiskmodule()
 * mod_deldiskmodule()
 *
*/

#include "../gid.h"

#define MODULE_MEMTYPE  MEMF_LOCAL
#define MODULE_LOWER    QDEV_MOD_ADE_24BITLOWER
#define MODULE_UPPER    QDEV_MOD_ADE_32BITUPPER



int GID_main(void)
{
  struct mod_adi_feed af;
  struct mod_ktl_head *kh;
  struct RDArgs *rda;
  LONG argv[1];
  LONG fd;


  /*
   * Setup memory type and range. Use MEMF_LOCAL at all
   * times, so that fast memory can be utilised where
   * possible.
  */
  af.af_memflags = MODULE_MEMTYPE;
  
  af.af_memstart = MODULE_LOWER;
  
  af.af_memend = MODULE_UPPER;

  /*
   * In this example we will allow code/data segments to
   * be loaded.
  */
  af.af_flags = QDEV_MOD_DISKMOD_FLOADALL;

  af.af_error = 0;

  /*
   * The user has to provide a binary to be loaded. This
   * can be libraries, devices and certain resources.
  */
  argv[0] = 0;

  if ((rda = ReadArgs("BINARY/A", argv, NULL)))
  {
    if (argv[0])
    {
      /*
       * Gotta open the file.
      */
      if ((fd = Open((UBYTE *)argv[0], MODE_OLDFILE)))
      {
        if ((kh = mod_adddiskmodule(fd, &af)))
        {
          /* 
           * Pressing Ctrl-C unloads the module.
          */
          Wait(SIGBREAKF_CTRL_C); 

          mod_deldiskmodule(kh);
        }

        Close(fd);
      }
    }

    FreeArgs(rda);
  }

  FPrintf(Output(), "af_error = %ld\n", af.af_error);

  return 0;
}
