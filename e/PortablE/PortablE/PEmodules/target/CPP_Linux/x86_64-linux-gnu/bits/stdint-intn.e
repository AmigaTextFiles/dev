OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/stdint-intn.h>}
/* Define intN_t types.
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

NATIVE {_BITS_STDINT_INTN_H}	CONST ->_BITS_STDINT_INTN_H	= 1

NATIVE {int8_t} OBJECT
->TYPE int8_t IS NATIVE {int8_t} __int8_t
NATIVE {int16_t} OBJECT
->TYPE int16_t IS NATIVE {int16_t} __int16_t
NATIVE {int32_t} OBJECT
->TYPE int32_t IS NATIVE {int32_t} __int32_t
NATIVE {int64_t} OBJECT
->TYPE int64_t IS NATIVE {int64_t} INT64_T__
