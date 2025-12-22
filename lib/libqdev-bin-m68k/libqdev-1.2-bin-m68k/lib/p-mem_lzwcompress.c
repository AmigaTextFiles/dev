/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_lzwcompress()
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
 * $VER: p-mem_lzwcompress.c 1.03 (31/03/2011) LZW
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



struct mem_pak_data *mem_lzwcompress(UBYTE *ptr, ULONG size)
{
  struct mem_lzw_data *ld;
  REGISTER UBYTE *ptrreg;
  REGISTER UBYTE *pendreg;
  REGISTER UBYTE *dstreg;
  REGISTER UBYTE *dendreg;
  REGISTER ULONG ncode;
  REGISTER ULONG scode;
  REGISTER ULONG pcode;
  REGISTER ULONG obits;
  REGISTER LONG ocnt;
  REGISTER LONG index;
  REGISTER LONG offset;
  REGISTER LONG turns;


  QDEVDEBUG(QDEVDBFARGS "(ptr = 0x%08lx, size = %lu)\n",
                                                     ptr, size);

  if ((ld = AllocVec(sizeof(struct mem_lzw_data) + size +
                           QDEV_MEM_PRV_HEADSIZE, MEMF_PUBLIC)))
  {
    /* 
     * Setup all the mandatory variables.
    */
    ocnt = 0;

    obits = 0;

    turns = 3;

    pcode = 0;

    ncode = 256;

    QDEV_HLP_QUICKFILL(&ld->ld_td.td_codech[0],
                         LONG, -1, sizeof(ld->ld_td.td_codech));

    dstreg = (UBYTE *)((LONG)&ld->ld_data[0] +
                                   (LONG)QDEV_MEM_PRV_HEADSIZE);

    dendreg = (UBYTE *)((LONG)dstreg + (LONG)size);

    ptrreg = ptr;

    pendreg = (UBYTE *)((LONG)ptrreg + (LONG)size);

    /*
     * Read first character.
    */
    scode = *ptrreg++;

    /*
     * Proceed with the rest of chars if any.
    */
    while (ptrreg < pendreg)
    {
      /*
       * Compute initial index for the entry in the table.
      */
      pcode = *ptrreg++;

      index = (pcode << QDEV_MEM_PRV_COMPSHIFT) ^ scode;

      if (index)
      {
        offset = (QDEV_MEM_PRV_TABLESIZE - index);
      }
      else
      {
        offset = 1;
      }

      /*
       * Now lookup this index in the table.
      */
      while (1)
      {
        /*
         * No worries it wont loop forever! The table is 25%
         * larger than expected.
        */
        if ((ld->ld_td.td_codech[index] == -1)       ||
           ((ld->ld_td.td_codepre[index] == scode)   &&
            (ld->ld_td.td_appchar[index] == pcode)))
        {
          break;
        }

        /*
         * Fix index on entry miss.
        */
        index -= offset;

        if (index < 0)
        {
          index += QDEV_MEM_PRV_TABLESIZE;
        }
      }

      /*
       * Fill in entry in the table.
      */
      if (ld->ld_td.td_codech[index] != -1)
      {
        scode = ld->ld_td.td_codech[index];
      }
      else
      {
        /*
         * Only fill the table if not all possibilities have
         * been reached.
        */
        if (ncode <= QDEV_MEM_PRV_MAXCODECH)
        {
          ld->ld_td.td_codech[index] = ncode++;

          ld->ld_td.td_codepre[index] = scode;

          ld->ld_td.td_appchar[index] = pcode;
        }

        /*
         * Output compressed data, byte by byte.
        */
        ___loop:

        obits |= (scode << (32 - QDEV_MEM_PRV_COMPBITS - ocnt));

        ocnt += QDEV_MEM_PRV_COMPBITS;

        while (ocnt >= 8)
        {
          if (dstreg < dendreg)
          {
            *dstreg++ = (obits >> 24);
          }
          else
          {
            /*
             * Oh, oh! Compressed data takes more than source!
             * In such case there is no point increasing it, so
             * quit. The 'pd_size' will be 0!
            */
            dstreg = &ld->ld_data[0];

            goto ___quit;
          }

          obits <<= 8;

          ocnt -= 8;
        }

        /*
         * Swap input characters.
        */
        scode = pcode;
      }
    }

    /*
     * Do three additional output turns. 1) To store last or
     * the very first character. 2) To store terminator value.
     * 3) To flush the data.
    */
    if (turns)
    {
      if (turns == 2)
      {
        scode = QDEV_MEM_PRV_MAXVALUE;
      }
      else if (turns == 1)
      {
        scode = 0;
      }

      turns--;

      goto ___loop;
    }

    /*
     * Output header in the reserved area, plus the size of
     * actual data. Using 'ULONG *data', this is 'data[0]'
     * - magic header, 'data[1]' - size of uncompressed data,
     * 'data[2]' - space for the checksum, '&data[3] - ptr to
     * compressed data.
    */
    *((LONG *)&ld->ld_data[0]) =
              (QDEV_MEM_PRV_MAGICHEAD | QDEV_MEM_PRV_COMPBITS);

    *((LONG *)((LONG)&ld->ld_data[0] +
                          (LONG)QDEV_MEM_PRV_DATASIZE)) = size;

    /*
     * Compute the size of the whole compressed memory block.
    */
    ___quit:                                     

    ld->ld_pd.pd_data = &ld->ld_data[0];

    ld->ld_pd.pd_size = (LONG)dstreg - (LONG)ld->ld_pd.pd_data;

    return (struct mem_pak_data *)ld;
  }

  return NULL;

  QDEVDEBUGIO();
}
