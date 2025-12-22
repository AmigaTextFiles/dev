/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_fnv64hash.h
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
 * $VER: i-txt_fnv64hash.h 1.00 (26/08/2011) FNV64
 * AUTH: FNV, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___FNV64HASH_H_INCLUDED___
#define ___FNV64HASH_H_INCLUDED___

#define QDEV_TXT_PRV_FNV64HBASE   0xCBF29CE484222325
#define QDEV_TXT_PRV_FNV64HBASEH  0xCBF29CE4
#define QDEV_TXT_PRV_FNV64HBASEL  0x84222325
#define QDEV_TXT_PRV_FNV64PRIME   0x00000100000001B3
#define QDEV_TXT_PRV_FNV64PRLOW   0x000001B3
#define QDEV_TXT_PRV_FNV64PRSHFT  8

#define QDEV_TXT_PRV_FNV64GCCOPT(ival)        \
({                                            \
  ival += (ival << 1) + (ival << 4) +         \
          (ival << 5) + (ival << 7) +         \
          (ival << 8) + (ival << 40);         \
})

#endif /* ___FNV64HASH_H_INCLUDED___ */
