OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
->{#include <x86_64-linux-gnu/bits/types/struct_statx_timestamp.h>}
/* Definition of the generic version of struct statx_timestamp.
   Copyright (C) 2018-2020 Free Software Foundation, Inc.
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

->NATIVE {__statx_timestamp_defined} CONST __STATX_TIMESTAMP_DEFINED = 1

NATIVE {statx_timestamp} OBJECT statx_timestamp
  {tv_sec}	sec	:INT64_T__
  {tv_nsec}	nsec	:UINT32_T__
->  {__statx_timestamp_pad1}	__statx_timestamp_pad1	:ARRAY OF __int32_t
ENDOBJECT
