/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_lzwcompress()
 * mem_lzwdecompress()
 * mem_lzwfree()
 *
*/

#include "../gid.h"

#define FILETOCOMPRESS   "colorful.h"



int GID_main(void)
{
  struct mem_pak_data *pd;
  struct mem_pak_data *upd;
  ULONG chsum1;
  ULONG chsum2;
  UBYTE *ptr;
  LONG size;
  LONG fd;
  LONG error;


  /*
   * Open the file whose contents will be LZW compressed.
  */
  error = 1;

  if ((fd = Open(FILETOCOMPRESS, MODE_OLDFILE)))
  {
    /*
     * Determine size of the file and if it is above zero
     * then continue.
    */
    error = 2;

    Seek(fd, 0, OFFSET_END);

    if ((size = Seek(fd, 0, OFFSET_BEGINNING)))
    {
      /*
       * Get this much memory to load the contents of the
       * file into.
      */
      error = 3;

      if ((ptr = AllocVec(size, MEMF_PUBLIC)))
      {
        /*
         * OK, now load the data into memory and compute
         * its checksum.
        */
        error = 4;

        if (Read(fd, ptr, size) == size)
        {
          chsum1 = mem_csumchs32(ptr, size);

          /*
           * About to compress!
          */
          error = 5;

          if ((pd = mem_lzwcompress(ptr, size)))
          {
            error = 6;

            if (pd->pd_size)
            {
              FPrintf(Output(),
           "Contents of '%s' did shrink to %ld bytes.\n",
                      (LONG)FILETOCOMPRESS, pd->pd_size);

              /*
               * About to decompress!
              */
              error = 7;

              if ((upd = mem_lzwdecompress(
                             pd->pd_data, pd->pd_size)))
              {
                chsum2 = mem_csumchs32(
                            upd->pd_data, upd->pd_size);

                FPrintf(Output(), "chsum1 = 0x%08lx\n"
                                   "chsum2 = 0x%08lx\n",
                                        chsum1, chsum2);

                error = 0;

                mem_lzwfree(upd);
              }
            }

            mem_lzwfree(pd);
          }
        }

        FreeVec(ptr);
      }
    }

    Close(fd);
  }    

  FPrintf(Output(), "error = %ld\n", error);

  return 0;
}
