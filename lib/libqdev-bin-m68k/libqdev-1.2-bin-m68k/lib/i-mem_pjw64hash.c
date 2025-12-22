/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_pjw64hash()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'PJW64'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'PJW64'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: i-mem_pjw64hash.c 1.01 (25/07/2011) PJW64
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Please  note!  I  did  not  convert  it to long word hashing to stay
 * compatible with 'txt_pjw64hash()'!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"

#include "i-txt_pjw64hash.h"



ULONG mem_pjw64hash(VUQUAD *vuq, void *memptr, LONG memlen)
{
  REGISTER ULONG hash_hi = 0;
  REGISTER ULONG hash_lo = 0;
  REGISTER UBYTE *endreg = (UBYTE *)((LONG)memptr + (LONG)memlen);
  REGISTER UBYTE *ptrreg = memptr;


  QDEVDEBUG(QDEVDBFARGS
                  "(vuq = 0x%08lx, memptr = 0x%08lx, memlen = %ld)\n",
                                                 vuq, memptr, memlen);

  if (vuq)
  {
    hash_lo = vuq->vuq_lo;

    hash_hi = vuq->vuq_hi;
  }

  while (ptrreg < endreg)
  {
    hash_lo = *ptrreg++ + ((hash_lo << QDEV_TXT_PRV_PJW64_LO_LEFT) |
                            (hash_lo >> QDEV_TXT_PRV_PJW64_LO_RIGHT));

    hash_hi = hash_lo + ((hash_hi << QDEV_TXT_PRV_PJW64_HI_LEFT) |
                            (hash_hi >> QDEV_TXT_PRV_PJW64_HI_RIGHT));
  }

  if (vuq)
  {
    vuq->vuq_lo = hash_lo;

    vuq->vuq_hi = hash_hi;
  }

  return hash_lo;

  QDEVDEBUGIO();
}
