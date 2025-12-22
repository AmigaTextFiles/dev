/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_quickhash()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QHASH'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QHASH'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: i-txt_quickhash.c 1.00 (25/12/2010) QHASH
 * AUTH: TPoP, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This routine was stolen from:
 *
 *    "The Practice of Programming" (HASH TABLES, page 57)
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"

#include "i-txt_quickhash.h"

#ifdef ___QDEV_QUICKIHASH
#define QDEV_PRV_QUICKHASH      txt_quickihash
#define QDEV_PRV_EQROUTINE      QDEV_HLP_EQUALIZELC
#else
#define QDEV_PRV_QUICKHASH      txt_quickhash
#define QDEV_PRV_EQROUTINE(chr) (chr)
#endif



ULONG QDEV_PRV_QUICKHASH(UBYTE *string)
{
  REGISTER UBYTE *strreg = string;
  REGISTER ULONG hash = 0;
  REGISTER ULONG value;


  QDEVDEBUG(QDEVDBFARGS "(string = 0x%08lx: !)\n",
                                            string);

  if (strreg--)
  {
    while((value = QDEV_PRV_EQROUTINE(*++strreg)))
    {
      hash = (QDEV_TXT_PRV_HASHBASE * hash) + value;
    }

    return hash;
  }

  return 0;

  QDEVDEBUGIO();
}
