/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_fnv128hash.h
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
 * $VER: i-txt_fnv128hash.h 1.00 (19/08/2014) FNV128
 * AUTH: FNV, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___FNV128HASH_H_INCLUDED___
#define ___FNV128HASH_H_INCLUDED___

#define QDEV_TXT_PRV_FNV128HBASEH  0x6C62272E07BB0142
#define QDEV_TXT_PRV_FNV128HBASEL  0x62B821756295C58D
#define QDEV_TXT_PRV_FNV128PRLOW   0x000000000000013B
#define QDEV_TXT_PRV_FNV128PRSHFT  8

struct ___VUQ128P
{
  UQUAD vuq_hi;
  UQUAD vuq_lo;
};

typedef struct ___VUQ128P VUQ128P;

#endif /* ___FNV64HASH_H_INCLUDED___ */
