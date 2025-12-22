/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_lzwdecompress()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'LZW'    is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'LZW'    is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: p-mem_lzwdecompress.c 1.03 (31/03/2011) LZW
 * AUTH: Mark R. Nelson, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Code  below is a remake of Mark R. Nelson LZW compressor. It is most
 * probably the smallest and yet quite efficient data compressor mainly
 * for text files and bitmaps that can operate on memory directly.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qsupp.h"

#ifdef __amigaos__
#include <proto/exec.h>
#else
#include "qport.h"
#endif

#include "qdev.h"

#include "p-mem_lzwxxx.h"



struct mem_pak_data *mem_lzwdecompress(UBYTE *ptr, ULONG size)
{
  struct mem_lzw_data *ld;
  REGISTER UBYTE *ptrreg;
  REGISTER UBYTE *pendreg;
  REGISTER UBYTE *dstreg;
  REGISTER UBYTE *dendreg;
  REGISTER LONG *stkreg;
  REGISTER LONG *sendreg;
  REGISTER ULONG *data;
  REGISTER ULONG ncode;
  REGISTER ULONG scode;
  REGISTER ULONG pcode;
  REGISTER ULONG tcode;
  REGISTER ULONG ibits;
  REGISTER LONG icnt;
  REGISTER LONG init;


  QDEVDEBUG(QDEVDBFARGS "(ptr = 0x%08lx, size = %lu)\n",
                                                     ptr, size);

  /*
   * Check if this is the type of data we can handle.
  */
  data = (ULONG *)ptr;

  if ((size > QDEV_MEM_PRV_HEADSIZE)                          &&
      (data[0] ==
           (QDEV_MEM_PRV_MAGICHEAD | QDEV_MEM_PRV_COMPBITS)))
  {
    if ((ld = AllocVec(
           sizeof(struct mem_lzw_data) + data[1], MEMF_PUBLIC)))
    {
      /* 
       * Setup all the mandatory variables.
      */
      icnt = 0;

      ibits = 0;

      init = 1;

      pcode = 0;

      tcode = 0;

      ncode = 256;

      ptrreg = (UBYTE *)&data[3];

      pendreg = (UBYTE *)((LONG)ptrreg +
                          (LONG)(size - QDEV_MEM_PRV_HEADSIZE));

      dstreg = &ld->ld_data[0];

      dendreg = (UBYTE *)((LONG)dstreg + (LONG)data[1]);

      /*
       * Read portion of data from source buffer.
      */
      ___loop:

      scode = 0;

      while (icnt <= 24)
      {
        if (ptrreg < pendreg)
        {
          scode = *ptrreg++;
        }

        ibits |= (scode << (24 - icnt));

        icnt += 8;
      }

      scode = (ibits >> (32 - QDEV_MEM_PRV_COMPBITS));

      icnt -= QDEV_MEM_PRV_COMPBITS;

      ibits <<= QDEV_MEM_PRV_COMPBITS;

      /*
       * Output first character immediately.
      */
      if (init)
      {
        *dstreg++ = scode;

        pcode = scode;

        tcode = scode;

        init--;

        goto ___loop;
      }
      else
      {
        /*
         * Proceed if that is not the terminator.
        */
        if (scode != QDEV_MEM_PRV_MAXVALUE)
        {
          /*
           * Attach the decompression stack and prepare the
           * codes.
          */
          stkreg = &ld->ld_td.td_codech[0];

          if (scode >= ncode)
          {
            *stkreg++ = tcode;

            tcode = pcode;
          }
          else
          {
            tcode = scode;
          }

          /*
           * Decompress some amount of data if yet possible.
          */
          sendreg = &ld->ld_td.td_codech[256];

          while ((tcode > 255) && (stkreg < sendreg))
          {
            *stkreg++ = ld->ld_td.td_appchar[tcode];

            tcode = ld->ld_td.td_codepre[tcode];
          }

          *stkreg = tcode;

          /*
           * Dump decompressed data to destination buffer.
          */
          sendreg = &ld->ld_td.td_codech[0];

          while (stkreg >= sendreg)
          {
            if (dstreg < dendreg)
            {
              *dstreg++ = *stkreg--;
            }
            else
            {
              /*
               * No more buffer space available, so quit. This
               * can only happen if data was not compressed or
               * is corrupt. The 'pd_size' will be 0!
              */
              dstreg = &ld->ld_data[0];

              goto ___quit;
            }
          }

          /*
           * Add new entry to lookup tables if possible.
          */
          if (ncode <= QDEV_MEM_PRV_MAXCODECH)
          {
            ld->ld_td.td_codepre[ncode] = pcode;

            ld->ld_td.td_appchar[ncode] = tcode;

            ncode++;
          }

          pcode = scode;

          /*
           * Repeat the process.
          */
          goto ___loop;
        }
      }

      /*
       * Compute the size of the uncompressed data.
      */
      ___quit:

      ld->ld_pd.pd_data = &ld->ld_data[0];

      ld->ld_pd.pd_size =
                         (LONG)dstreg - (LONG)ld->ld_pd.pd_data;

      return (struct mem_pak_data *)ld;
    }
  }

  return NULL;

  QDEVDEBUGIO();
}
