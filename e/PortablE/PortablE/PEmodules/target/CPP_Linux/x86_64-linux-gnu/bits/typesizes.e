OPT NATIVE
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/types_shared'	->manually added
->{#include <x86_64-linux-gnu/bits/typesizes.h>}
/* bits/typesizes.h -- underlying types for *_t.  Linux/x86-64 version.
   Copyright (C) 2012-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_TYPESIZES_H}	CONST ->_BITS_TYPESIZES_H	= 1

/* See <bits/types.h> for the meaning of these macros.  This file exists so
   that <bits/types.h> need not vary across different GNU platforms.  */

/* X32 kernel interface is 64-bit.  */
 NATIVE {__SYSCALL_SLONG_TYPE}	CONST ; TYPE SYSCALL_SLONG_TYPE__	IS SLONGWORD_TYPE__
 NATIVE {__SYSCALL_ULONG_TYPE}	CONST ; TYPE SYSCALL_ULONG_TYPE__	IS ULONGWORD_TYPE__

NATIVE {__DEV_T_TYPE}		CONST ; TYPE DEV_T_TYPE__		IS UQUAD_TYPE__
NATIVE {__UID_T_TYPE}		CONST ; TYPE UID_T_TYPE__		IS U32_TYPE__
NATIVE {__GID_T_TYPE}		CONST ; TYPE GID_T_TYPE__		IS U32_TYPE__
NATIVE {__INO_T_TYPE}		CONST ; TYPE INO_T_TYPE__		IS SYSCALL_ULONG_TYPE__
NATIVE {__INO64_T_TYPE}		CONST ; TYPE INO64_T_TYPE__		IS UQUAD_TYPE__
NATIVE {__MODE_T_TYPE}		CONST ; TYPE MODE_T_TYPE__		IS U32_TYPE__
 NATIVE {__NLINK_T_TYPE}		CONST ; TYPE NLINK_T_TYPE__		IS SYSCALL_ULONG_TYPE__
 ->NATIVE {__FSWORD_T_TYPE}	CONST __FSWORD_T_TYPE	= SYSCALL_SLONG_TYPE__
NATIVE {__OFF_T_TYPE}		CONST ; TYPE OFF_T_TYPE__		IS SYSCALL_SLONG_TYPE__
NATIVE {__OFF64_T_TYPE}		CONST ; TYPE OFF64_T_TYPE__		IS SQUAD_TYPE__
NATIVE {__PID_T_TYPE}		CONST ; TYPE PID_T_TYPE__		IS S32_TYPE__
->NATIVE {__RLIM_T_TYPE}		CONST ; TYPE __RLIM_T_TYPE		IS SYSCALL_ULONG_TYPE__
->NATIVE {__RLIM64_T_TYPE}		CONST ; TYPE __RLIM64_T_TYPE		IS UQUAD_TYPE__
NATIVE {__BLKCNT_T_TYPE}		CONST ; TYPE BLKCNT_T_TYPE__		IS SYSCALL_SLONG_TYPE__
NATIVE {__BLKCNT64_T_TYPE}	CONST ; TYPE BLKCNT64_T_TYPE__	IS SQUAD_TYPE__
->NATIVE {__FSBLKCNT_T_TYPE}	CONST ; TYPE __FSBLKCNT_T_TYPE	IS SYSCALL_ULONG_TYPE__
->NATIVE {__FSBLKCNT64_T_TYPE}	CONST ; TYPE __FSBLKCNT64_T_TYPE	IS UQUAD_TYPE__
->NATIVE {__FSFILCNT_T_TYPE}	CONST ; TYPE __FSFILCNT_T_TYPE	IS SYSCALL_ULONG_TYPE__
->NATIVE {__FSFILCNT64_T_TYPE}	CONST ; TYPE __FSFILCNT64_T_TYPE	IS UQUAD_TYPE__
->NATIVE {__ID_T_TYPE}		CONST ; TYPE __ID_T_TYPE		IS U32_TYPE__
NATIVE {__CLOCK_T_TYPE}		CONST ; TYPE CLOCK_T_TYPE__		IS SYSCALL_SLONG_TYPE__
NATIVE {__TIME_T_TYPE}		CONST ; TYPE TIME_T_TYPE__		IS SYSCALL_SLONG_TYPE__
NATIVE {__USECONDS_T_TYPE}	CONST ; TYPE USECONDS_T_TYPE__	IS U32_TYPE__
NATIVE {__SUSECONDS_T_TYPE}	CONST ; TYPE SUSECONDS_T_TYPE__	IS SYSCALL_SLONG_TYPE__
->NATIVE {__DADDR_T_TYPE}		CONST ; TYPE __DADDR_T_TYPE		IS S32_TYPE__
->NATIVE {__KEY_T_TYPE}		CONST ; TYPE __KEY_T_TYPE		IS S32_TYPE__
NATIVE {__CLOCKID_T_TYPE}	CONST ; TYPE CLOCKID_T_TYPE__	IS S32_TYPE__
NATIVE {__TIMER_T_TYPE}		CONST ; TYPE TIMER_T_TYPE__		IS /*NATIVE {void *}*/ PTR
NATIVE {__BLKSIZE_T_TYPE}	CONST ; TYPE BLKSIZE_T_TYPE__	IS SYSCALL_SLONG_TYPE__
->NATIVE {__FSID_T_TYPE}		CONST ; TYPE __FSID_T_TYPE		IS struct { int __val[2]; }
NATIVE {__SSIZE_T_TYPE}		CONST ; TYPE SSIZE_T_TYPE__		IS SWORD_TYPE__
->NATIVE {__CPU_MASK_TYPE} 	CONST ; TYPE __CPU_MASK_TYPE 	IS SYSCALL_ULONG_TYPE__

/* Tell the libc code that OFF_T and OFF64_T are actually the same type
   for all ABI purposes, even if possibly expressed as different base types
   for C type-checking purposes.  */
 ->NATIVE {__OFF_T_MATCHES_OFF64_T}	CONST __OFF_T_MATCHES_OFF64_T	= 1

/* Same for ino_t and ino64_t.  */
 ->NATIVE {__INO_T_MATCHES_INO64_T}	CONST __INO_T_MATCHES_INO64_T	= 1

/* And for __rlim_t and __rlim64_t.  */
 ->NATIVE {__RLIM_T_MATCHES_RLIM64_T}	CONST __RLIM_T_MATCHES_RLIM64_T	= 1

/* And for fsblkcnt_t, fsblkcnt64_t, fsfilcnt_t and fsfilcnt64_t.  */
 ->NATIVE {__STATFS_MATCHES_STATFS64}  CONST __STATFS_MATCHES_STATFS64  = 1

/* Number of descriptors that can fit in an `fd_set'.  */
->NATIVE {__FD_SETSIZE}		CONST FD_SETSIZE__		= 1024
