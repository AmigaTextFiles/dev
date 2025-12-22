/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_codereloc()
 * mod_codefree()
 * mod_codefind()
 *
*/

#include "../gid.h"

#define CODE_MEMTYPE  MEMF_LOCAL
#define CODE_LOWER    QDEV_MOD_ADE_24BITLOWER
#define CODE_UPPER    QDEV_MOD_ADE_32BITUPPER



int GID_main(void)
{
  struct RDArgs *rda;
  struct MemList *ml;
  struct Resident *rt;
  struct mod_ktl_head *kh;
  LONG argv[1];
  LONG size;
  LONG fd;
  LONG error;


  /*
   * The user has to provide a binary to be loaded. This
   * can be libraries, devices and certain resources.
  */
  error = 1;

  argv[0] = 0;

  if ((rda = ReadArgs("BINARY/A", argv, NULL)))
  {
    if (argv[0])
    {
      /*
       * In this example we will allow code only binaries
       * to be loaded thus we will expand the MemList by
       * one MemEntry.
      */
      size = QDEV_MEM_REGALIGN(sizeof(struct mod_ktl_head)
                                 + sizeof(struct MemEntry));

      /*
       * Gotta open the file.
      */
      error = 2;

      if ((fd = Open((UBYTE *)argv[0], MODE_OLDFILE)))
      {
        /*
         * Now let this tiny routine do the hard work for
         * us.
        */
        error = 3;

        if ((ml = mod_codereloc(fd, CODE_MEMTYPE,
                                   CODE_LOWER, CODE_UPPER)))
        {
          /*
           * Seems this is a valid Amiga hunked file, good!
           * As said few lines earlier we only care for the
           * code segment.
          */
          error = 4;

          if (ml->ml_NumEntries == 1)
          {
            /*
             * Lets now locate the ROMTAG...
            */
            error = 5;

            if ((rt = mod_codefind(&ml->ml_ME[0])))
            {
              /*
               * It is time to allocate the mem. for module
               * header.
              */
              error = 6;

              if ((kh = mem_allocmemregion(
                                         size, CODE_MEMTYPE,
                                   CODE_LOWER, CODE_UPPER)))
              {
                /*
                 * Success! And now we will have to fiddle
                 * with some pointers and such. Gotta move
                 * contents pointed to by 'rt' to the 'kh'
                 * and fix it up.
                */
                kh->kh_rt = *rt;

                kh->kh_rt.rt_MatchTag = &kh->kh_rt;

                kh->kh_rt.rt_EndSkip =
                                 (UBYTE *)((LONG)kh + size);

                /*
                 * NULL out the Resident block in the code
                 * segment. You must do it so that ROMTAG
                 * scanners wont go crazy!
                */
                txt_memfill(rt, 0, sizeof(struct Resident));

                /*
                 * Second major step is to prepare MemList
                 * that will be allocated by the bootstrap.
                 * The 'kh' goes into [0] MemEntry.
                */
                kh->kh_ml.ml_NumEntries = 2;

                kh->kh_ml.ml_ME[0].me_Addr = kh;

                kh->kh_ml.ml_ME[0].me_Length = size;

                /*
                 * And the resident code into [1] MemEntry.
                */
                kh->kh_ml.ml_ME[1] = ml->ml_ME[0];

                /*
                 * Last thing to do is to link into the OS.
                */
                error = 7;

                if ((mod_kicktaglink(kh)))
                {
                  /*
                   * Total success! 
                  */
                  FPrintf(Output(),
                      "Your binary = '%s' has been loaded."
                      " Reboot or press CTRL+C to abort\n",
                                                  argv[0]);

                  Wait(SIGBREAKF_CTRL_C);

                  mod_kicktagunlink(kh);

                  error = 0;
                }

                mem_freememregion(kh, size);
              }
            }
          }

          mod_codefree(ml);
        }

        Close(fd);
      }
    }

    FreeArgs(rda);
  }

  FPrintf(Output(), "error = %ld\n", error);

  return 0;
}
