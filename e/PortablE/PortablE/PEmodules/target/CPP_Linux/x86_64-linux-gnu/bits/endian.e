OPT NATIVE
/* This file defines `__BYTE_ORDER' for the particular machine.  */
->MODULE 'target/x86_64-linux-gnu/bits/endianness'		->disabled so that 'target/x86_64-linux-gnu/bits/endianness' can include us, so that it can use LITTLE_ENDIAN__
{#include <x86_64-linux-gnu/bits/endian.h>}
/* Endian macros for string.h functions
   Copyright (C) 1992-2020 Free Software Foundation, Inc.
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
   <http://www.gnu.org/licenses/>.  */

NATIVE {_BITS_ENDIAN_H} CONST ->_BITS_ENDIAN_H = 1

/* Definitions for byte order, according to significance of bytes,
   from low addresses to high addresses.  The value is what you get by
   putting '4' in the most significant byte, '3' in the second most
   significant byte, '2' in the second least significant byte, and '1'
   in the least significant byte, and then writing down one digit for
   each byte, starting with the byte at the lowest address at the left,
   and proceeding to the byte with the highest address at the right.  */

NATIVE {__LITTLE_ENDIAN}	CONST LITTLE_ENDIAN__	= 1234
NATIVE {__BIG_ENDIAN}	CONST BIG_ENDIAN__	= 4321
NATIVE {__PDP_ENDIAN}	CONST PDP_ENDIAN__	= 3412

/* Some machines may need to use a different endianness for floating point
   values.  */
 ->NATIVE {__FLOAT_WORD_ORDER} CONST __FLOAT_WORD_ORDER = BYTE_ORDER__

 ->NATIVE {__LONG_LONG_PAIR} PROC	->define __LONG_LONG_PAIR(HI, LO) LO, HI
