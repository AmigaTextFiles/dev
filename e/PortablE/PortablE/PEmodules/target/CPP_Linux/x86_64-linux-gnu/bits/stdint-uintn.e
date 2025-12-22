OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/stdint-uintn.h>}
/* Define uintN_t types.
   Copyright (C) 2017-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_STDINT_UINTN_H}	CONST ->_BITS_STDINT_UINTN_H	= 1

NATIVE {uint8_t} OBJECT
->TYPE uint8_t IS NATIVE {uint8_t} __uint8_t
NATIVE {uint16_t} OBJECT
->TYPE uint16_t IS NATIVE {uint16_t} UINT16_T__
NATIVE {uint32_t} OBJECT
->TYPE uint32_t IS NATIVE {uint32_t} UINT32_T__
NATIVE {uint64_t} OBJECT
->TYPE uint64_t IS NATIVE {uint64_t} UINT64_T__
