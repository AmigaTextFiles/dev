OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/endianness'	->guessed, so we have BYTE_ORDER__ despite change to 'target/x86_64-linux-gnu/bits/endian'
MODULE 'target/features'
/* Get the definitions of *_ENDIAN__, BYTE_ORDER__, and __FLOAT_WORD_ORDER.  */
MODULE 'target/x86_64-linux-gnu/bits/endian'
/* Conversion interfaces.  */
 MODULE 'target/x86_64-linux-gnu/bits/byteswap'
 MODULE 'target/x86_64-linux-gnu/bits/uintn-identity'
{#include <endian.h>}
/* Copyright (C) 1992-2020 Free Software Foundation, Inc.
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

NATIVE {_ENDIAN_H}	CONST ->_ENDIAN_H	= 1


 NATIVE {LITTLE_ENDIAN}	CONST LITTLE_ENDIAN	= LITTLE_ENDIAN__
 NATIVE {BIG_ENDIAN}	CONST BIG_ENDIAN	= BIG_ENDIAN__
 NATIVE {PDP_ENDIAN}	CONST PDP_ENDIAN	= PDP_ENDIAN__
 NATIVE {BYTE_ORDER}	CONST BYTE_ORDER	= BYTE_ORDER__


  NATIVE {htobe16} PROC	->define htobe16(x) __bswap_16 (x)
  NATIVE {htole16} PROC	->define htole16(x) __uint16_identity (x)
  NATIVE {be16toh} PROC	->define be16toh(x) __bswap_16 (x)
  NATIVE {le16toh} PROC	->define le16toh(x) __uint16_identity (x)

  NATIVE {htobe32} PROC	->define htobe32(x) __bswap_32 (x)
  NATIVE {htole32} PROC	->define htole32(x) __uint32_identity (x)
  NATIVE {be32toh} PROC	->define be32toh(x) __bswap_32 (x)
  NATIVE {le32toh} PROC	->define le32toh(x) __uint32_identity (x)

  NATIVE {htobe64} PROC	->define htobe64(x) __bswap_64 (x)
  NATIVE {htole64} PROC	->define htole64(x) __uint64_identity (x)
  NATIVE {be64toh} PROC	->define be64toh(x) __bswap_64 (x)
  NATIVE {le64toh} PROC	->define le64toh(x) __uint64_identity (x)
