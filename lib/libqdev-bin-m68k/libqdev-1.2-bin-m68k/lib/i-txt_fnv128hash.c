/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_fnv128hash()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'FNV128' is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'FNV128' is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: i-txt_fnv128hash.c 1.00 (19/08/2014) FNV128
 * AUTH: FNV, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is Fowler/Noll/Vo-0 FNV-1a hash routine in 128bit mode as taken
 * from:
 *
 *    http://isthe.com/chongo/src/fnv/hash_64a.c
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"

#include "i-txt_fnv128hash.h"

#ifdef ___QDEV_FNV128MEMORY
#define QDEV_PRV_FNV128ARGS      void *str, LONG len
#define QDEV_PRV_FNV128DEBG                   \
"(vuq128 = 0x%08lx, ptr = 0x%08lx"            \
            ", len = %ld)\n", vuq128, str, len
#define QDEV_PRV_FNV128TYPE      UBYTE *
#define QDEV_PRV_FNV128STOR      endreg
#define QDEV_PRV_FNV128PASS      *strreg
#define QDEV_PRV_FNV128INIT                   \
  (UBYTE *)((LONG)str + len)
#define QDEV_PRV_FNV128ENT2                   \
  if ((vuq) && (vuq->vuq_lo | vuq->vuq_hi))   \
  {                                           \
    val[0] = vuq->vuq_lo;                     \
    val[2] = vuq->vuq_hi;                     \
  }
#define QDEV_PRV_FNV128COND(arg)              \
  ((++arg < QDEV_PRV_FNV128STOR))
#define QDEV_PRV_FNV128HASH     mem_fnv128hash
#else
#define QDEV_PRV_FNV128ARGS     UBYTE *str
#define QDEV_PRV_FNV128DEBG                   \
"(vuq128 = 0x%08lx, str = 0x%08lx: !)\n",     \
                                   vuq128, str
#define QDEV_PRV_FNV128TYPE     ULONG
#define QDEV_PRV_FNV128STOR     byte
#define QDEV_PRV_FNV128PASS     QDEV_PRV_FNV128STOR
#define QDEV_PRV_FNV128INIT     0
#define QDEV_PRV_FNV128ENT2
#ifdef ___QDEV_FNV128IHASH
#define QDEV_PRV_FNV128COND(arg)              \
  ((QDEV_PRV_FNV128STOR =                     \
    QDEV_HLP_EQUALIZELC(*++arg)))
#define QDEV_PRV_FNV128HASH     txt_fnv128ihash
#else
#define QDEV_PRV_FNV128COND(arg)              \
  ((QDEV_PRV_FNV128STOR = *++arg))
#define QDEV_PRV_FNV128HASH     txt_fnv128hash
#endif
#endif



/*
 * Warning! Do not __inline under gcc-2.95 or else code
 * will be broken!
*/
static UQUAD ___txt_muluquad(UQUAD a, UQUAD b)
{
  VUQUAD *_a = (VUQUAD *)&a;
  VUQUAD *_b = (VUQUAD *)&b;
  VUQUAD r;


  QDEVDEBUG(QDEVDBFARGS "(a = %qu, b = %qu)\n", a, b);

  QDEV_HLP_MULU32X32(_a->vuq_lo, _b->vuq_lo, r);

  r.vuq_hi += (_a->vuq_lo * _b->vuq_hi) +
                              (_a->vuq_hi * _b->vuq_lo);

  return *(UQUAD *)&r;

  QDEVDEBUGIO();
}

ULONG QDEV_PRV_FNV128HASH(
                    VUQ128 *vuq128, QDEV_PRV_FNV128ARGS)
{
  REGISTER QDEV_PRV_FNV128TYPE QDEV_PRV_FNV128STOR =
                                    QDEV_PRV_FNV128INIT;
  REGISTER UBYTE *strreg = str;
  VUQ128P *vuq = (VUQ128P *)vuq128;
  UQUAD val[4];
  UQUAD tmp[4];


  QDEVDEBUG(QDEVDBFARGS QDEV_PRV_FNV128DEBG);

  val[0] = QDEV_TXT_PRV_FNV128HBASEL;

  val[2] = QDEV_TXT_PRV_FNV128HBASEH;

  QDEV_PRV_FNV128ENT2

  val[1] = (val[0] >> 32);

  val[0] &= 0xFFFFFFFF;

  val[3] = (val[2] >> 32);

  val[2] &= 0xFFFFFFFF;

  if (strreg--)
  {
    while (QDEV_PRV_FNV128COND(strreg))
    {
      val[0] ^= QDEV_PRV_FNV128PASS;

      tmp[0] =
      ___txt_muluquad(val[0], QDEV_TXT_PRV_FNV128PRLOW);

      tmp[1] =
      ___txt_muluquad(val[1], QDEV_TXT_PRV_FNV128PRLOW);

      tmp[2] =
      ___txt_muluquad(val[2], QDEV_TXT_PRV_FNV128PRLOW);

      tmp[3] =
      ___txt_muluquad(val[3], QDEV_TXT_PRV_FNV128PRLOW);

      tmp[2] += val[0] << QDEV_TXT_PRV_FNV128PRSHFT;

      tmp[3] += val[1] << QDEV_TXT_PRV_FNV128PRSHFT;

      tmp[1] += (tmp[0] >> 32);

      val[0] = (tmp[0] & 0xFFFFFFFF);

      tmp[2] += (tmp[1] >> 32);

      val[1] = (tmp[1] & 0xFFFFFFFF);

      val[3] = (tmp[3] + (tmp[2] >> 32));

      val[2] = (tmp[2] & 0xFFFFFFFF);
    }
  }

  if (vuq)
  {
    vuq->vuq_hi = ((val[3] << 32) | val[2]);

    vuq->vuq_lo = ((val[1] << 32) | val[0]);
  }

  return (ULONG)val[0];

  QDEVDEBUGIO();
}
