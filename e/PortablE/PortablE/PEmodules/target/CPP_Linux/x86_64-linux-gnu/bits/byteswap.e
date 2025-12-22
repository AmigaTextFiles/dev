OPT NATIVE
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
->{#include <x86_64-linux-gnu/bits/byteswap.h>}
/* Macros and inline functions to swap the order of bytes in integer values.
   Copyright (C) 1997-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

NATIVE {_BITS_BYTESWAP_H} CONST ->_BITS_BYTESWAP_H = 1

/* Swap bytes in 16-bit value.  */
->NATIVE {__bswap_constant_16} PROC	->define __bswap_constant_16(x)	((UINT16_T__) ((((x) >> 8) & 0xff) | (((x) & 0xff) << 8)))

->NATIVE {__bswap_16} PROC ->static __inline UINT16_T__ __bswap_16(UINT16_T__ __bsx) {

/* Swap bytes in 32-bit value.  */
->NATIVE {__bswap_constant_32} PROC	->define __bswap_constant_32(x)	((((x) & 0xff000000u) >> 24) | (((x) & 0x00ff0000u) >> 8)	| (((x) & 0x0000ff00u) << 8) | (((x) & 0x000000ffu) << 24))

->NATIVE {__bswap_32} PROC static __inline UINT32_T__ __bswap_32(UINT32_T__ __bsx) {

/* Swap bytes in 64-bit value.  */
->NATIVE {__bswap_constant_64} PROC	->define __bswap_constant_64(x)

->NATIVE {__bswap_64} PROC ->static __inline UINT64_T__ __bswap_64(UINT64_T__ __bsx) {
