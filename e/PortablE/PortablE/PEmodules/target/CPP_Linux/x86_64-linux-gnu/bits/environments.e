OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
->{#include <x86_64-linux-gnu/bits/environments.h>}
/* Copyright (C) 1999-2020 Free Software Foundation, Inc.
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

/* This header should define the following symbols under the described
   situations.  A value `1' means that the model is always supported,
   `-1' means it is never supported.  Undefined means it cannot be
   statically decided.

   _POSIX_V7_ILP32_OFF32   32bit int, long, pointers, and OFF_T type
   _POSIX_V7_ILP32_OFFBIG  32bit int, long, and pointers and larger OFF_T type

   _POSIX_V7_LP64_OFF32	   64bit long and pointers and 32bit OFF_T type
   _POSIX_V7_LPBIG_OFFBIG  64bit long and pointers and large OFF_T type

   The macros _POSIX_V6_ILP32_OFF32, _POSIX_V6_ILP32_OFFBIG,
   _POSIX_V6_LP64_OFF32, _POSIX_V6_LPBIG_OFFBIG, _XBS5_ILP32_OFF32,
   _XBS5_ILP32_OFFBIG, _XBS5_LP64_OFF32, and _XBS5_LPBIG_OFFBIG were
   used in previous versions of the Unix standard and are available
   only for compatibility.
*/

/* Environments with 32-bit wide pointers are optionally provided.
   Therefore following macros aren't defined:
   # undef _POSIX_V7_ILP32_OFF32
   # undef _POSIX_V7_ILP32_OFFBIG
   # undef _POSIX_V6_ILP32_OFF32
   # undef _POSIX_V6_ILP32_OFFBIG
   # undef _XBS5_ILP32_OFF32
   # undef _XBS5_ILP32_OFFBIG
   and users need to check at runtime.  */

/* We also have no use (for now) for an environment with bigger pointers
   and offsets.  */
 NATIVE {_POSIX_V7_LPBIG_OFFBIG}	CONST ->_POSIX_V7_LPBIG_OFFBIG	= -1
 NATIVE {_POSIX_V6_LPBIG_OFFBIG}	CONST ->_POSIX_V6_LPBIG_OFFBIG	= -1
 NATIVE {_XBS5_LPBIG_OFFBIG}	CONST ->_XBS5_LPBIG_OFFBIG	= -1

/* By default we have 64-bit wide `long int', pointers and `OFF_T'.  */
 NATIVE {_POSIX_V7_LP64_OFF64}	CONST ->_POSIX_V7_LP64_OFF64	= 1
 NATIVE {_POSIX_V6_LP64_OFF64}	CONST ->_POSIX_V6_LP64_OFF64	= 1
 NATIVE {_XBS5_LP64_OFF64}	CONST ->_XBS5_LP64_OFF64	= 1


->NATIVE {__ILP32_OFF32_CFLAGS}	STATIC __ILP32_OFF32_CFLAGS	= '-m32'
->NATIVE {__ILP32_OFF32_LDFLAGS}	STATIC __ILP32_OFF32_LDFLAGS	= '-m32'
 ->NATIVE {__ILP32_OFFBIG_CFLAGS}	STATIC __ILP32_OFFBIG_CFLAGS	= '-m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64'
 ->NATIVE {__ILP32_OFFBIG_LDFLAGS}	STATIC __ILP32_OFFBIG_LDFLAGS	= '-m32'
->NATIVE {__LP64_OFF64_CFLAGS}	STATIC __LP64_OFF64_CFLAGS	= '-m64'
->NATIVE {__LP64_OFF64_LDFLAGS}	STATIC __LP64_OFF64_LDFLAGS	= '-m64'
