/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_fnv64hash()
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
 * $VER: i-mem_fnv64hash.c 1.00 (26/08/2011) FNV64
 * AUTH: FNV, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This   is   Fowler/Noll/Vo-0 FNV-1a   hash   routine   taken   from:
 *
 *    http://isthe.com/chongo/src/fnv/hash_64a.c
 *
 * Its  little  brother(32bit)  is quite  strong already, so this 64bit
 * monster should be really usable with lots of separate data.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#define ___QDEV_FNV64MEMORY

#include "i-txt_fnv64hash.c"
