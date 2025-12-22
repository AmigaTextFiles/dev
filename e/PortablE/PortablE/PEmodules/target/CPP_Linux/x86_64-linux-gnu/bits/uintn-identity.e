OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
->{#include <x86_64-linux-gnu/bits/uintn-identity.h>}
/* Inline functions to return unsigned integer values unchanged.
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

NATIVE {_BITS_UINTN_IDENTITY_H} CONST ->_BITS_UINTN_IDENTITY_H = 1


/* These inline functions are to ensure the appropriate type
   conversions and associated diagnostics from macros that convert to
   a given endianness.  */

->NATIVE {__uint16_identity} PROC ->static __inline __uint16_t __uint16_identity(__uint16_t __x) {return __x;}

->NATIVE {__uint32_identity} PROC ->static __inline __uint32_t __uint32_identity(__uint32_t __x) {return __x;}

->NATIVE {__uint64_identity} PROC ->static __inline __uint64_t __uint64_identity(__uint64_t __x) {return __x;}
