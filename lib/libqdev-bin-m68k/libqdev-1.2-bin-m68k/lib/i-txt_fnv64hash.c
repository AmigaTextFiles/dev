/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_fnv64hash()
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'FNV64'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'FNV64'  is   distributed  in  the  hope  that  it  will  be useful,
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
 * $VER: i-txt_fnv64hash.c 1.00 (26/08/2011) FNV64
 * AUTH: FNV, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This   is   Fowler/Noll/Vo-0 FNV-1a   hash   routine   taken   from:
 *
 *    http://isthe.com/chongo/src/fnv/hash_64a.c
 *
 * Its  little  brother(32bit)  is quite  strong already, so this 64bit
 * monster should really be usable with lots of separate data.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#include "qdev.h"

#include "i-txt_fnv64hash.h"

#ifdef ___QDEV_FNV64MEMORY
#define QDEV_PRV_FNV64ARGS      void *str, LONG len
#define QDEV_PRV_FNV64DEBG                    \
"(vuq = 0x%08lx, ptr = 0x%08lx, len = %ld)\n",\
                                 vuq, str, len
#define QDEV_PRV_FNV64TYPE      UBYTE *
#define QDEV_PRV_FNV64STOR      endreg
#define QDEV_PRV_FNV64PASS      *strreg
#define QDEV_PRV_FNV64INIT                    \
  (UBYTE *)((LONG)str + len)
#define QDEV_PRV_FNV64ENT1                    \
  if ((vuq) && (*(UQUAD *)vuq))               \
  {                                           \
    value = *(UQUAD *)vuq;                    \
  }
#define QDEV_PRV_FNV64ENT2                    \
  if ((vuq) && (vuq->vuq_lo | vuq->vuq_hi))   \
  {                                           \
    val[0] = vuq->vuq_lo;                     \
    val[2] = vuq->vuq_hi;                     \
  }
#define QDEV_PRV_FNV64COND(arg)               \
  ((++arg < QDEV_PRV_FNV64STOR))
#define QDEV_PRV_FNV64HASH      mem_fnv64hash
#else
#define QDEV_PRV_FNV64ARGS      UBYTE *str
#define QDEV_PRV_FNV64DEBG                    \
"(vuq = 0x%08lx, str = 0x%08lx: !)\n", vuq, str
#define QDEV_PRV_FNV64TYPE      ULONG
#define QDEV_PRV_FNV64STOR      byte
#define QDEV_PRV_FNV64PASS      QDEV_PRV_FNV64STOR
#define QDEV_PRV_FNV64INIT      0
#define QDEV_PRV_FNV64ENT1
#define QDEV_PRV_FNV64ENT2
#ifdef ___QDEV_FNV64IHASH
#define QDEV_PRV_FNV64COND(arg)               \
  ((QDEV_PRV_FNV64STOR =                      \
    QDEV_HLP_EQUALIZELC(*++arg)))
#define QDEV_PRV_FNV64HASH      txt_fnv64ihash
#else
#define QDEV_PRV_FNV64COND(arg)               \
  ((QDEV_PRV_FNV64STOR = *++arg))
#define QDEV_PRV_FNV64HASH      txt_fnv64hash
#endif
#endif



ULONG QDEV_PRV_FNV64HASH(
                   VUQUAD *vuq, QDEV_PRV_FNV64ARGS)
{
  REGISTER QDEV_PRV_FNV64TYPE QDEV_PRV_FNV64STOR =
                                QDEV_PRV_FNV64INIT;
  REGISTER UBYTE *strreg = str;
#ifdef ___QDEV_FORCEQUAD
  UQUAD value = QDEV_TXT_PRV_FNV64HBASE;


  QDEVDEBUG(QDEVDBFARGS QDEV_PRV_FNV64DEBG);

  QDEV_PRV_FNV64ENT1

  if (strreg--)
  {
    while (QDEV_PRV_FNV64COND(strreg))
    {
      value ^= (UQUAD)QDEV_PRV_FNV64PASS;

#ifdef QDEV_TXT_PRV_FNV64GCCOPT
      QDEV_TXT_PRV_FNV64GCCOPT(value);
#else
      value *= QDEV_TXT_PRV_FNV64PRIME;
#endif
    }
  }

  if (vuq)
  {
    vuq->vuq_hi = (ULONG)(value >> 32);

    vuq->vuq_lo = (ULONG)(value & 0xFFFFFFFF);
  }

  return (ULONG)(value & 0xFFFFFFFF);

#else
  ULONG val[4];
  ULONG tmp[4];


  QDEVDEBUG(QDEVDBFARGS QDEV_PRV_FNV64DEBG);

  val[0] = QDEV_TXT_PRV_FNV64HBASEL;

  val[2] = QDEV_TXT_PRV_FNV64HBASEH;

  QDEV_PRV_FNV64ENT2

  val[1] = (val[0] >> 16);

  val[0] &= 0xFFFF;

  val[3] = (val[2] >> 16);

  val[2] &= 0xFFFF;

  if (strreg--)
  {
    while (QDEV_PRV_FNV64COND(strreg))
    {
      val[0] ^= QDEV_PRV_FNV64PASS;

      tmp[0] = val[0] * QDEV_TXT_PRV_FNV64PRLOW;

      tmp[1] = val[1] * QDEV_TXT_PRV_FNV64PRLOW;

      tmp[2] = val[2] * QDEV_TXT_PRV_FNV64PRLOW;

      tmp[3] = val[3] * QDEV_TXT_PRV_FNV64PRLOW;

      tmp[2] += val[0] << QDEV_TXT_PRV_FNV64PRSHFT;

      tmp[3] += val[1] << QDEV_TXT_PRV_FNV64PRSHFT;

      tmp[1] += (tmp[0] >> 16);

      val[0] = (tmp[0] & 0xFFFF);

      tmp[2] += (tmp[1] >> 16);

      val[1] = (tmp[1] & 0xFFFF);

      val[3] = (tmp[3] + (tmp[2] >> 16));

      val[2] = (tmp[2] & 0xFFFF);
    }
  }

  if (vuq)
  {
    vuq->vuq_hi = ((val[3] << 16) | val[2]);

    vuq->vuq_lo = ((val[1] << 16) | val[0]);
  }

  return ((val[1] << 16) | val[0]);

#endif

  QDEVDEBUGIO();
}
