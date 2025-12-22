/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_noansi()
 *
*/

#include "../gid.h"

#define INFILE   "DRM-SS.ANSI"
#define OUTFILE  "DRM-SS.ASCII"



/*
 * Since there is 'txt_noansi()', it is very easy to filter
 * out all ANSI sequences. Of course this example serves as
 * a learning point, so no big philosophy here. But this
 * function is really powerful! You can even create ANSI
 * color remapper based upon it!
*/
int GID_main(void)
{
  UBYTE bufi[256];
  UBYTE bufo[256];
  UBYTE *out;
  UBYTE *ptr;
  UBYTE *end;
  LONG read;
  ULONG flags;
  LONG seqs = 0;
  LONG fdi;
  LONG fdo;


  /*
   * Access input and output files first.
  */
  if ((fdi = Open(INFILE, MODE_OLDFILE)))
  {
    if ((fdo = Open(OUTFILE, MODE_NEWFILE)))
    {
      /*
       * Setup filtering scheme. We want all sequences
       * to be detected and removed.
      */
      flags = QDEV_TXT_NA_ALL;

      /*
       * Enter the read loop and setup pointer needed
       * to filter the ANSI out.
      */
      while ((read = Read(fdi, bufi, sizeof(bufi))) > 0)
      {
        ptr = bufi;

        end = bufi;

        end += read;

        out = bufo;

        /*
         * Enter the filtering loop and seek for plain
         * text.
        */
        while (ptr < end)
        {
          if (txt_noansi(*ptr,  &flags))
          {
            *out++ = *ptr;
          }

          if (flags & QDEV_TXT_NA_FSEQEND)
          {
            seqs++;
          }

          ptr++;
        }

        /*
         * Dump chunk of clear text.
        */
        if (Write(fdo, bufo, (LONG)out - (LONG)bufo) < 0)
        {
          break;
        }
      }

      Close(fdo);
    }

    Close(fdi);
  }

  FPrintf(Output(),
         "Found and killed %ld ANSI sequences!\n", seqs);

  return 0;
}
