/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_csumchs32()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'CHS32'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'CHS32'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: i-mem_csumchs32.c 1.00 (30/10/2010) CHS32
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Don't forget to read the autodocs!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"



ULONG mem_csumchs32(void *memptr, LONG memlen)
{
  REGISTER ULONG sum = 0;
  REGISTER LONG lenreg;
  REGISTER ULONG *ptrreg;


  QDEVDEBUG(
       QDEVDBFARGS "(memptr = 0x%08lx, memlen = %ld)\n",
                                        memptr, memlen);

  if (memptr)
  {
    ptrreg = memptr;

    lenreg = memlen;

    lenreg >>= 2;

    while(lenreg--)
    {
      sum += *ptrreg++;
    }

    sum--;
  }

  return ~sum;

  QDEVDEBUGIO();
}
