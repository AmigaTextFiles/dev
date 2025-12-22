OPT NATIVE
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
 MODULE 'target/x86_64-linux-gnu/bits/types/clock_t'
MODULE 'target/x86_64-linux-gnu/bits/types/clockid_t'
MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
MODULE 'target/x86_64-linux-gnu/bits/types/timer_t'
PUBLIC MODULE 'target/stddef'
/* These size-specific names are used by some of the inet code.  */
MODULE 'target/x86_64-linux-gnu/bits/stdint-intn'
/* In BSD <sys/types.h> is expected to define BYTE_ORDER.  */
 MODULE 'target/endian'
/* It also defines `fd_set' and the FD_* macros for `select'.  */
 MODULE 'target/x86_64-linux-gnu/sys/select'
/* Now add the thread types.  */
 MODULE 'target/x86_64-linux-gnu/bits/pthreadtypes'
{#include <x86_64-linux-gnu/sys/types.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
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

/*
 *	POSIX Standard: 2.6 Primitive System Data Types	<sys/types.h>
 */

NATIVE {_SYS_TYPES_H}	CONST ->_SYS_TYPES_H	= 1

NATIVE {u_char} OBJECT
->TYPE u_char IS NATIVE {u_char} __u_char
NATIVE {u_short} OBJECT
->TYPE u_short IS NATIVE {u_short} __u_short
NATIVE {u_int} OBJECT
->TYPE u_int IS NATIVE {u_int} __u_int
NATIVE {u_long} OBJECT
->TYPE u_long IS NATIVE {u_long} __u_long
NATIVE {quad_t} OBJECT
->TYPE quad_t IS NATIVE {quad_t} __quad_t
NATIVE {u_quad_t} OBJECT
->TYPE u_quad_t IS NATIVE {u_quad_t} __u_quad_t
NATIVE {fsid_t} OBJECT
->TYPE fsid_t IS NATIVE {fsid_t} __fsid_t
  ->NATIVE {__u_char_defined} DEF
NATIVE {loff_t} OBJECT
->TYPE loff_t IS NATIVE {loff_t} __loff_t

NATIVE {ino_t} OBJECT
->TYPE ino_t IS NATIVE {ino_t} INO_T__
 ->NATIVE {__ino_t_defined} DEF
NATIVE {ino64_t} OBJECT
->TYPE ino64_t IS NATIVE {ino64_t} INO64_T__
 ->NATIVE {__ino64_t_defined} DEF

NATIVE {dev_t} OBJECT
->TYPE dev_t IS NATIVE {dev_t} DEV_T__
 ->NATIVE {__dev_t_defined} DEF

NATIVE {gid_t} OBJECT
->TYPE gid_t IS NATIVE {gid_t} GID_T__
 ->NATIVE {__gid_t_defined} DEF

NATIVE {mode_t} OBJECT
TYPE MODE_T IS NATIVE {mode_t} MODE_T__
 ->NATIVE {__mode_t_defined} DEF

NATIVE {nlink_t} OBJECT
->TYPE nlink_t IS NATIVE {nlink_t} NLINK_T__
 ->NATIVE {__nlink_t_defined} DEF

NATIVE {uid_t} OBJECT
->TYPE uid_t IS NATIVE {uid_t} UID_T__
 ->NATIVE {__uid_t_defined} DEF

/*
#ifndef __off_t_defined
*/
->NATIVE {off_t} OBJECT
TYPE OFF_T IS NATIVE {off_t} OFF_T__
 ->NATIVE {__off_t_defined} DEF
/*
#endif
#if defined __USE_LARGEFILE64 && !defined __off64_t_defined
*/
NATIVE {off64_t} OBJECT
TYPE OFF64_T IS NATIVE {off64_t} OFF64_T__
 ->NATIVE {__off64_t_defined} DEF
/*
#endif
*/

NATIVE {pid_t} OBJECT
TYPE PID_T IS NATIVE {pid_t} PID_T__
 ->NATIVE {__pid_t_defined} DEF

NATIVE {id_t} OBJECT
->TYPE id_t IS NATIVE {id_t} __id_t
 ->NATIVE {__id_t_defined} DEF

NATIVE {ssize_t} OBJECT
TYPE SSIZE_T IS NATIVE {ssize_t} SSIZE_T__
 ->NATIVE {__ssize_t_defined} DEF

NATIVE {daddr_t} OBJECT
->TYPE daddr_t IS NATIVE {daddr_t} __daddr_t
NATIVE {caddr_t} OBJECT
->TYPE caddr_t IS NATIVE {caddr_t} __caddr_t
  ->NATIVE {__daddr_t_defined} DEF

NATIVE {key_t} OBJECT
->TYPE key_t IS NATIVE {key_t} __key_t
 ->NATIVE {__key_t_defined} DEF


NATIVE {useconds_t} OBJECT
->TYPE useconds_t IS NATIVE {useconds_t} USECONDS_T__
  ->NATIVE {__useconds_t_defined} DEF
NATIVE {suseconds_t} OBJECT
->TYPE suseconds_t IS NATIVE {suseconds_t} SUSECONDS_T__
  ->NATIVE {__suseconds_t_defined} DEF

->NATIVE {__need_size_t} DEF

/* Old compatibility names for C types.  */
NATIVE {ulong} OBJECT
->TYPE ulong IS NATIVE {ulong} UCLONG
NATIVE {ushort} OBJECT
->TYPE ushort IS NATIVE {ushort} UINT
NATIVE {uint} OBJECT
->TYPE uint IS NATIVE {uint} ULONG


/* These were defined by ISO C without the first `_'.  */
NATIVE {u_int8_t} OBJECT
->TYPE u_int8_t IS NATIVE {u_int8_t} __uint8_t
NATIVE {u_int16_t} OBJECT
->TYPE u_int16_t IS NATIVE {u_int16_t} UINT16_T__
NATIVE {u_int32_t} OBJECT
->TYPE u_int32_t IS NATIVE {u_int32_t} UINT32_T__
NATIVE {u_int64_t} OBJECT
->TYPE u_int64_t IS NATIVE {u_int64_t} UINT64_T__

NATIVE {register_t} OBJECT
->TYPE register_t IS NATIVE {register_t} VALUE

/* Some code from BIND tests this macro to see if the types above are
   defined.  */
->NATIVE {__BIT_TYPES_DEFINED__}	CONST ->__BIT_TYPES_DEFINED__	= 1


NATIVE {blksize_t} OBJECT
->TYPE blksize_t IS NATIVE {blksize_t} BLKSIZE_T__
 ->NATIVE {__blksize_t_defined} DEF

/* Types from the Large File Support interface.  */
NATIVE {blkcnt_t} OBJECT
->TYPE blkcnt_t IS NATIVE {blkcnt_t} BLKCNT_T__	 /* Type to count number of disk blocks.  */
  ->NATIVE {__blkcnt_t_defined} DEF
NATIVE {fsblkcnt_t} OBJECT
->TYPE fsblkcnt_t IS NATIVE {fsblkcnt_t} __fsblkcnt_t /* Type to count file system blocks.  */
  ->NATIVE {__fsblkcnt_t_defined} DEF
NATIVE {fsfilcnt_t} OBJECT
->TYPE fsfilcnt_t IS NATIVE {fsfilcnt_t} __fsfilcnt_t /* Type to count file system inodes.  */
  ->NATIVE {__fsfilcnt_t_defined} DEF

NATIVE {blkcnt64_t} OBJECT
->TYPE blkcnt64_t IS NATIVE {blkcnt64_t} BLKCNT64_T__     /* Type to count number of disk blocks. */
NATIVE {fsblkcnt64_t} OBJECT
->TYPE fsblkcnt64_t IS NATIVE {fsblkcnt64_t} __fsblkcnt64_t /* Type to count file system blocks.  */
NATIVE {fsfilcnt64_t} OBJECT
->TYPE fsfilcnt64_t IS NATIVE {fsfilcnt64_t} __fsfilcnt64_t /* Type to count file system inodes.  */
