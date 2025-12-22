OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/statx-generic'
MODULE 'target/linux/stat'
->{#include <x86_64-linux-gnu/bits/statx.h>}
/* statx-related definitions and declarations.  Linux version.
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

/* This interface is based on <linux/stat.h> in Linux.  */

/* Use the Linux kernel header if available.  */

/* Use "" to work around incorrect macro expansion of the
   __has_include argument (GCC PR 80005).  */
   ->NATIVE {__statx_timestamp_defined} CONST __STATX_TIMESTAMP_DEFINED = 1
   ->NATIVE {__statx_defined} CONST __STATX_DEFINED = 1
