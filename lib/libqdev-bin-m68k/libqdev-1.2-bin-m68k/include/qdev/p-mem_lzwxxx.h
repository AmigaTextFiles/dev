/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_lzwxxx.h
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
 * $VER: p-mem_lzwxxx.h 1.03 (31/03/2011) LZW
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * The  default  setup  needs  45189  bytes  for  the  tables  both for
 * compression  and  decompression.  If  you  need  to  make it smaller
 * then   reduce  number  of  'QDEV_MEM_PRV_COMPBITS'(min  9,  max  14)
 * and  recompute  'QDEV_MEM_PRV_TABLESIZE'(add  25%  of  the result to
 * itself and then round that to the nearest prime!).
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___LZWXXX_H_INCLUDED___
#define ___LZWXXX_H_INCLUDED___

#define QDEV_MEM_PRV_DATASIZE      4
#define QDEV_MEM_PRV_HEADSIZE   (QDEV_MEM_PRV_DATASIZE * 3)
#define QDEV_MEM_PRV_COMPBITS     12
#define QDEV_MEM_PRV_TABLESIZE  5021         /* (2 ** 12) + 25% = <prime!>  */
#define QDEV_MEM_PRV_COMPSHIFT  (QDEV_MEM_PRV_COMPBITS - 8)
#define QDEV_MEM_PRV_MAXVALUE   ((1L << QDEV_MEM_PRV_COMPBITS) - 1)
#define QDEV_MEM_PRV_MAXCODECH  (QDEV_MEM_PRV_MAXVALUE - 1)
#define QDEV_MEM_PRV_MAGICHEAD  0x4C5A5700   /* 'L' 'Z' 'W' '\0' - <bits!>  */



struct mem_tab_data
{
  LONG    td_codech[QDEV_MEM_PRV_TABLESIZE];
                                /* Code table                               */
  ULONG   td_codepre[QDEV_MEM_PRV_TABLESIZE];
                                /* Prefix table                             */
  UBYTE   td_appchar[QDEV_MEM_PRV_TABLESIZE];
                                /* Character table                          */
};

struct mem_lzw_data
{
  struct mem_pak_data ld_pd;    /* Output data                              */
  struct mem_tab_data ld_td;    /* Table data                               */
  UBYTE               ld_data[QDEV_MEM_PRV_DATASIZE];
                                /* Buffer storage                           */

  /*
   * No new members beyond 'ld_data' allowed due to varying size!
  */
};

#endif /* ___LZWXXX_H_INCLUDED___ */
