/*
 * The purpose of this file is to demonstrate how to write code that:
 *
 * Loads the binary #?.logo or #?.loco file
 *
*/

#include "../gid.h"

/*
 * We will need to include modular segment macros as well
 * as picture related stuff.
*/
#include "a-pre_xxxseg.h"
#include "a-mem_xxxpicture.h"



int GID_main(void)
{
  struct mem_pak_data *pd;
  LONG *(*animptr)(void);
  struct Image *im;
  struct RDArgs *rda;
  LONG argv[1];
  LONG start;
  LONG end;
  LONG segs;
  LONG *data = NULL;
  LONG error;


  argv[0] = 0;

  error = 1;

  if ((rda = ReadArgs("LOGO/A", argv, NULL)))
  {
    error = 2;

    if (argv[0])
    {
      /*
       * First thing you must do is to 'LoadSeg()' the
       * binary.
      */
      error = 3;

      if ((segs = LoadSeg((UBYTE *)argv[0])))
      {
        /*
         * Then you must locate data segment and magic.
        */
        error = 4;

        if (((data = ___QDEV_SEGINIT_FINDPTR(segs)))     &&
             (data[0] == QDEV_MEM_PRV_NORMALMAGIC))
        {
          /*
           * There are 4 LONGs in the table who hold:
           * data[0] - Magic value  = 'LOGO' in hex
           * data[1] - Frame delay in micros
           * data[2] - Cycle delay also in micros
           * data[3] - Tri-pointer(LONG) table func.
          */
          FPrintf(Output(), "--- %s ---\n"
                            "Frame delay: %ld\n"
                            "Cycle delay: %ld\n"
                            "Tri-pointer: 0x%08lx\n",
                                                   argv[0],
                                                   data[1],
                                                   data[2],
                                                  data[3]);

          /*
           * It is function address, and not table ptr!
          */
          animptr = (void *)data[3];

          data = animptr();

          /*
           * Now we gained access to tri-pointer table:
           * data[0] - Number of frames in the table
           * data[1] - Magic value 'LOGO' or 'LOCO'
           * data[2] - NULL
          */
          FPrintf(Output(), "Tot. frames: %ld\n"
                            "Compressed?: %s\n", data[0],
               (LONG)(data[1] == QDEV_MEM_PRV_PACKEDMAGIC ?
                                            "Yes" : "No"));

          /*
           * Skip number of frames, then check if that is
           * packed binary and skip to NULL.
          */
          data++;

          /*
           * If next value is 'QDEV_MEM_PRV_PACKEDMAGIC'
           * then that is compressed data.
          */
          if (*data++ == QDEV_MEM_PRV_PACKEDMAGIC)
          {
            data++;

            /*
             * Now we point at another tri-pointer node:
             * data[0] - LZW compressed data pointer
             * data[1] - Size of compressed data
             * data[2] - NULL
            */
            FPrintf(Output(), "LZW address: 0x%08lx\n"
                              "LZW length : %ld\n",
                                                   data[0],
                                                  data[1]);

            /*
             * Now we will have to handle LZW compression.
            */
            start = *data++;

            end = *data++;

            data = NULL;

            error = 5;

            if ((pd =
                   mem_lzwdecompress((UBYTE *)start, end)))
            {
              /*
               * We must now free the seglist, so new data
               * can be relocated in place.
              */
              UnLoadSeg(segs);

              segs = NULL;

              error = 6;

              if (pd->pd_size)
              {
                error = 7;

                if ((segs =
                  mem_iloadseg2(pd->pd_data, pd->pd_size)))
                {
                  /*
                   * Pretty much the same as above but we
                   * can be sure it is plain logo now.
                  */
                  error = 8;

                  if (((data =
                         ___QDEV_SEGINIT_FINDPTR(segs))) &&
                  (data[0] == QDEV_MEM_PRV_NORMALMAGIC))
                  {
                    animptr = (void *)data[3];

                    data = animptr();

                    /*
                     * Skip to image and palette data.
                    */
                    data++;

                    data++;

                    data++;

                    error = 0;
                  }
                }
              }

              /*
               * Free the LZW decompression memory block.
              */
              mem_lzwfree(pd);
            }
          }
          else
          {
            /*
             * Skip to image and palette data(not packed).
            */
            data++;

            error = 0;
          }
        }
      }

      if (segs)
      {
        if (data)
        {
          /*
           * Being here means we now point at first frame:
           * data[0] - struct Image address
           * data[1] - RGB4 palette
           * data[2] - RGB32 palette
          */
          start = 1;

          while (*data)
          {
            im = (void *)data[0];

            FPrintf(Output(), "\n(0x%08lx): %ld\n"
                              "LeftEdge   = %ld\n"
                              "TopEdge    = %ld\n"
                              "Width      = %ld\n"
                              "Height     = %ld\n"
                              "Depth      = %ld\n"
                              "ImageData  = 0x%08lx\n"
                              "PlanePick  = 0x%02lx\n"
                              "PlaneOnOff = 0x%02lx\n"
                              "NextImage  = 0x%08lx\n"
                              "RGB4       = 0x%08lx\n"
                              "RGB32      = 0x%08lx\n",
                                                  (LONG)im,
                                                     start,
                                              im->LeftEdge,
                                               im->TopEdge,
                                                 im->Width,
                                                im->Height,
                                                 im->Depth,
                                       (LONG)im->ImageData,
                                             im->PlanePick,
                                            im->PlaneOnOff,
                                       (LONG)im->NextImage,
                                                   data[1],
                                                  data[2]);

            /*
             * Skip to next frame. Note that last tripple
             * is all NULL.
            */
            data++;

            data++;

            data++;

            start++;
          }
        }

        UnLoadSeg(segs);
      }
    }

    FreeArgs(rda);
  }

  FPrintf(Output(), "\nerror = %ld\n", error);

  return 0;
}
