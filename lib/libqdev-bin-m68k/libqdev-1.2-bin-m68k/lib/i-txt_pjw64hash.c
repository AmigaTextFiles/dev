/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_pjw64hash()
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
 * $VER: i-txt_pjw64hash.c 1.01 (25/07/2011) PJW64
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Don't forget to read the autodocs!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"

#include "i-txt_pjw64hash.h"

#ifdef ___QDEV_PJW64IHASH
#define QDEV_PRV_PJW64HASH      txt_pjw64ihash
#define QDEV_PRV_EQROUTINE      QDEV_HLP_EQUALIZELC
#else
#define QDEV_PRV_PJW64HASH      txt_pjw64hash
#define QDEV_PRV_EQROUTINE(chr) (chr)
#endif



ULONG QDEV_PRV_PJW64HASH(VUQUAD *vuq, UBYTE *string)
{
  REGISTER ULONG hash_hi = 0;
  REGISTER ULONG hash_lo = 0;
  REGISTER ULONG byte;
  REGISTER UBYTE *ptrreg = string;


  QDEVDEBUG(QDEVDBFARGS "(vuq = 0x%08lx, string = 0x%08lx: !)\n",
                                                         vuq, string);

  if (ptrreg--)
  {
    while ((byte = QDEV_PRV_EQROUTINE(*++ptrreg)))
    {
      hash_lo = byte + ((hash_lo << QDEV_TXT_PRV_PJW64_LO_LEFT) |
                            (hash_lo >> QDEV_TXT_PRV_PJW64_LO_RIGHT));

      hash_hi = hash_lo + ((hash_hi << QDEV_TXT_PRV_PJW64_HI_LEFT) |
                            (hash_hi >> QDEV_TXT_PRV_PJW64_HI_RIGHT));
    }
  }

  if (vuq)
  {
    vuq->vuq_lo = hash_lo;

    vuq->vuq_hi = hash_hi;
  }

  return hash_lo;

  QDEVDEBUGIO();
}
