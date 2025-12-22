OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/types/struct_statx_timestamp'
MODULE 'target/x86_64-linux-gnu/bits/types/struct_statx'
->{#include <x86_64-linux-gnu/bits/statx-generic.h>}
/* Generic statx-related definitions and declarations.
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

 NATIVE {STATX_TYPE} CONST STATX_TYPE = $0001
 NATIVE {STATX_MODE} CONST STATX_MODE = $0002
 NATIVE {STATX_NLINK} CONST STATX_NLINK = $0004
 NATIVE {STATX_UID} CONST STATX_UID = $0008
 NATIVE {STATX_GID} CONST STATX_GID = $0010
 NATIVE {STATX_ATIME} CONST STATX_ATIME = $0020
 NATIVE {STATX_MTIME} CONST STATX_MTIME = $0040
 NATIVE {STATX_CTIME} CONST STATX_CTIME = $0080
 NATIVE {STATX_INO} CONST STATX_INO = $0100
 NATIVE {STATX_SIZE} CONST STATX_SIZE = $0200
 NATIVE {STATX_BLOCKS} CONST STATX_BLOCKS = $0400
 NATIVE {STATX_BASIC_STATS} CONST STATX_BASIC_STATS = $07ff
 NATIVE {STATX_ALL} CONST STATX_ALL = $0fff
 NATIVE {STATX_BTIME} CONST STATX_BTIME = $0800
 NATIVE {STATX__RESERVED} CONST STATX__RESERVED = $80000000

 NATIVE {STATX_ATTR_COMPRESSED} CONST STATX_ATTR_COMPRESSED = $0004
 NATIVE {STATX_ATTR_IMMUTABLE} CONST STATX_ATTR_IMMUTABLE = $0010
 NATIVE {STATX_ATTR_APPEND} CONST STATX_ATTR_APPEND = $0020
 NATIVE {STATX_ATTR_NODUMP} CONST STATX_ATTR_NODUMP = $0040
 NATIVE {STATX_ATTR_ENCRYPTED} CONST STATX_ATTR_ENCRYPTED = $0800
 NATIVE {STATX_ATTR_AUTOMOUNT} CONST STATX_ATTR_AUTOMOUNT = $1000

/* Fill *BUF with information about PATH in DIRFD.  */
->NATIVE {statx} PROC
PROC statx(__dirfd:LONG, __path:ARRAY OF CHAR, __flags:LONG,
           __mask:ULONG, __buf:PTR TO statx) IS NATIVE {statx(} __dirfd {,} __path {,} __flags {,} __mask {,} __buf {)} ENDNATIVE !!LONG
