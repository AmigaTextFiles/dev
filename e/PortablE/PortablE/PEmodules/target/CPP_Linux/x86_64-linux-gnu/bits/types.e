OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
MODULE 'target/x86_64-linux-gnu/bits/timesize'
MODULE 'target/x86_64-linux-gnu/bits/typesizes'		->this publically contains 'target/x86_64-linux-gnu/bits/types_shared'
MODULE 'target/x86_64-linux-gnu/bits/time64'
{#include <x86_64-linux-gnu/bits/types.h>}
/* bits/types.h -- definitions of __*_t types underlying *_t types.
   Copyright (C) 2002-2020 Free Software Foundation, Inc.
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
 * Never include this file directly; use <sys/types.h> instead.
 */

NATIVE {_BITS_TYPES_H}	CONST ->_BITS_TYPES_H	= 1


/* Convenience types.  */

->TYPE __u_char IS NATIVE {__u_char} UBYTE

->TYPE __u_short IS NATIVE {__u_short} UINT

->TYPE __u_int IS NATIVE {__u_int} ULONG

->TYPE __u_long IS NATIVE {__u_long} UCLONG

/* Fixed-size types, underlying types depend on word size and compiler.  */

->TYPE __int8_t IS NATIVE {__int8_t} BYTE

->TYPE __uint8_t IS NATIVE {__uint8_t} UBYTE

->TYPE __int16_t IS NATIVE {__int16_t} INT

TYPE UINT16_T__ IS NATIVE {__uint16_t} UINT

->TYPE __int32_t IS NATIVE {__int32_t} VALUE

TYPE UINT32_T__ IS NATIVE {__uint32_t} ULONG

TYPE INT64_T__ IS NATIVE {__int64_t} CLONG

TYPE UINT64_T__ IS NATIVE {__uint64_t} UCLONG

/* Smallest types with at least a given width.  */

->TYPE __int_least8_t IS NATIVE {__int_least8_t} __int8_t

->TYPE __uint_least8_t IS NATIVE {__uint_least8_t} __uint8_t

->TYPE __int_least16_t IS NATIVE {__int_least16_t} __int16_t

->TYPE __uint_least16_t IS NATIVE {__uint_least16_t} UINT16_T__

->TYPE __int_least32_t IS NATIVE {__int_least32_t} __int32_t

->TYPE __uint_least32_t IS NATIVE {__uint_least32_t} UINT32_T__

->TYPE __int_least64_t IS NATIVE {__int_least64_t} INT64_T__

->TYPE __uint_least64_t IS NATIVE {__uint_least64_t} UINT64_T__

/* quad_t is also 64 bits.  */

->TYPE __quad_t IS NATIVE {__quad_t} CLONG

->TYPE __u_quad_t IS NATIVE {__u_quad_t} UCLONG

/* Largest integral types.  */

->TYPE __intmax_t IS NATIVE {__intmax_t} CLONG

->TYPE __uintmax_t IS NATIVE {__uintmax_t} UCLONG


/* The machine-dependent file <bits/typesizes.h> defines __*_T_TYPE
   macros for each of the OS types we define below.  The definitions
   of those macros must use the following macros for underlying types.
   We define __S<SIZE>_TYPE and __U<SIZE>_TYPE for the signed and unsigned
   variants of each of the following integer types on this machine.

	16		-- "natural" 16-bit type (always short)
	32		-- "natural" 32-bit type (always int)
	64		-- "natural" 64-bit type (long or long long)
	LONG32		-- 32-bit type, traditionally long
	QUAD		-- 64-bit type, traditionally long long
	WORD		-- natural type of WORDSIZE__ bits (int or long)
	LONGWORD	-- type of WORDSIZE__ bits, traditionally long

   We distinguish WORD/LONGWORD, 32/LONG32, and 64/QUAD so that the
   conventional uses of `long' or `long long' type modifiers match the
   types we define, even when a less-adorned type would be the same size.
   This matters for (somewhat) portably writing printf/scanf formats for
   these types, where using the appropriate l or ll format modifiers can
   make the typedefs and the formats match up across all GNU platforms.  If
   we used `long' when it's 64 bits where `long long' is expected, then the
   compiler would warn about the formats not matching the argument types,
   and the programmer changing them to shut up the compiler would break the
   program's portability.

   Here we assume what is presently the case in all the GCC configurations
   we support: long long is always 64 bits, long is always word/address size,
   and int is always 32 bits.  */

/*
WARNING: These have been moved to the module 'target/x86_64-linux-gnu/bits/types_shared':
->NATIVE {__S16_TYPE}		CONST __S16_TYPE		= NATIVE {short int} INT
->NATIVE {__U16_TYPE}		CONST __U16_TYPE		= NATIVE {unsigned short int} UINT
->NATIVE {__S32_TYPE}		CONST __S32_TYPE		= NATIVE {int} VALUE
->NATIVE {__U32_TYPE}		CONST __U32_TYPE		= NATIVE {unsigned int} ULONG
->NATIVE {__SLONGWORD_TYPE}	CONST __SLONGWORD_TYPE	= NATIVE {long int} LONG
->NATIVE {__ULONGWORD_TYPE}	CONST __ULONGWORD_TYPE	= NATIVE {unsigned long int} ULONG
 ->NATIVE {__SQUAD_TYPE}		CONST __SQUAD_TYPE		= NATIVE {long int} LONG
 ->NATIVE {__UQUAD_TYPE}		CONST __UQUAD_TYPE		= NATIVE {unsigned long int} ULONG
 NATIVE {__SWORD_TYPE}		CONST __SWORD_TYPE		= NATIVE {long int} LONG
 ->NATIVE {__UWORD_TYPE}		CONST __UWORD_TYPE		= NATIVE {unsigned long int} ULONG
 ->NATIVE {__SLONG32_TYPE}		CONST __SLONG32_TYPE		= NATIVE {int} VALUE
 ->NATIVE {__ULONG32_TYPE}		CONST __ULONG32_TYPE		= NATIVE {unsigned int} ULONG
 ->NATIVE {__S64_TYPE}		CONST __S64_TYPE		= NATIVE {long int} LONG
 ->NATIVE {__U64_TYPE}		CONST __U64_TYPE		= NATIVE {unsigned long int} ULONG
/* No need to mark the typedef with __extension__.   */
 ->NATIVE {__STD_TYPE}		CONST ->__STD_TYPE		= 
*/



TYPE DEV_T__ IS NATIVE {__dev_t} DEV_T_TYPE__	/* Type of device numbers.  */

TYPE UID_T__ IS NATIVE {__uid_t} UID_T_TYPE__	/* Type of user identifications.  */

TYPE GID_T__ IS NATIVE {__gid_t} GID_T_TYPE__	/* Type of group identifications.  */

TYPE INO_T__ IS NATIVE {__ino_t} INO_T_TYPE__	/* Type of file serial numbers.  */

TYPE INO64_T__ IS NATIVE {__ino64_t} INO64_T_TYPE__	/* Type of file serial numbers (LFS).*/

TYPE MODE_T__ IS NATIVE {__mode_t} MODE_T_TYPE__	/* Type of file attribute bitmasks.  */

TYPE NLINK_T__ IS NATIVE {__nlink_t} NLINK_T_TYPE__	/* Type of file link counts.  */

TYPE OFF_T__ IS NATIVE {__off_t} OFF_T_TYPE__	/* Type of file sizes and offsets.  */

TYPE OFF64_T__ IS NATIVE {__off64_t} OFF64_T_TYPE__	/* Type of file sizes and offsets (LFS).  */

TYPE PID_T__ IS NATIVE {__pid_t} PID_T_TYPE__	/* Type of process identifications.  */

->TYPE __fsid_t IS NATIVE {__fsid_t} __FSID_T_TYPE	/* Type of file system IDs.  */

TYPE CLOCK_T__ IS NATIVE {__clock_t} CLOCK_T_TYPE__	/* Type of CPU usage counts.  */

->TYPE __rlim_t IS NATIVE {__rlim_t} __RLIM_T_TYPE	/* Type for resource measurement.  */

->TYPE __rlim64_t IS NATIVE {__rlim64_t} __RLIM64_T_TYPE	/* Type for resource measurement (LFS).  */

->TYPE __id_t IS NATIVE {__id_t} __ID_T_TYPE		/* General type for IDs.  */

TYPE TIME_T__ IS NATIVE {__time_t} TIME_T_TYPE__	/* Seconds since the Epoch.  */

TYPE USECONDS_T__ IS NATIVE {__useconds_t} USECONDS_T_TYPE__ /* Count of microseconds.  */

TYPE SUSECONDS_T__ IS NATIVE {__suseconds_t} SUSECONDS_T_TYPE__ /* Signed count of microseconds.  */


->TYPE __daddr_t IS NATIVE {__daddr_t} __DADDR_T_TYPE	/* The type of a disk address.  */

->TYPE __key_t IS NATIVE {__key_t} __KEY_T_TYPE	/* Type of an IPC key.  */

/* Clock ID used in clock and timer functions.  */

TYPE CLOCKID_T__ IS NATIVE {__clockid_t} CLOCKID_T_TYPE__

/* Timer ID returned by `timer_create'.  */

TYPE TIMER_T__ IS NATIVE {__timer_t} TIMER_T_TYPE__

/* Type to represent block size.  */

TYPE BLKSIZE_T__ IS NATIVE {__blksize_t} BLKSIZE_T_TYPE__

/* Types from the Large File Support interface.  */

/* Type to count number of disk blocks.  */

TYPE BLKCNT_T__ IS NATIVE {__blkcnt_t} BLKCNT_T_TYPE__

TYPE BLKCNT64_T__ IS NATIVE {__blkcnt64_t} BLKCNT64_T_TYPE__

/* Type to count file system blocks.  */

->TYPE __fsblkcnt_t IS NATIVE {__fsblkcnt_t} __FSBLKCNT_T_TYPE

->TYPE __fsblkcnt64_t IS NATIVE {__fsblkcnt64_t} __FSBLKCNT64_T_TYPE

/* Type to count file system nodes.  */

->TYPE __fsfilcnt_t IS NATIVE {__fsfilcnt_t} __FSFILCNT_T_TYPE

->TYPE __fsfilcnt64_t IS NATIVE {__fsfilcnt64_t} __FSFILCNT64_T_TYPE

/* Type of miscellaneous file system fields.  */

->TYPE __fsword_t IS NATIVE {__fsword_t} __FSWORD_T_TYPE


TYPE SSIZE_T__ IS NATIVE {__ssize_t} SSIZE_T_TYPE__ /* Type of a byte count, or error.  */

/* Signed long type used in system calls.  */

TYPE SYSCALL_SLONG_T__ IS NATIVE {__syscall_slong_t} SYSCALL_SLONG_TYPE__
/* Unsigned long type used in system calls.  */

->TYPE SYSCALL_ULONG_T__ IS NATIVE {__syscall_ulong_t} SYSCALL_ULONG_TYPE__

/* These few don't really vary by system, they always correspond
   to one of the other defined types.  */

->TYPE __loff_t IS NATIVE {__loff_t} OFF64_T__	/* Type of file sizes and offsets (LFS).  */

->TYPE __caddr_t IS NATIVE {__caddr_t} ARRAY OF CHAR

/* Duplicates info from stdint.h but this is used in unistd.h.  */

->TYPE __intptr_t IS NATIVE {__intptr_t} SWORD_TYPE__

/* Duplicate info from sys/socket.h.  */

->TYPE __socklen_t IS NATIVE {__socklen_t} __U32_TYPE

/* C99: An integer type that can be accessed as an atomic entity,
   even in the presence of asynchronous interrupts.
   It is not currently necessary for this to be machine-specific.  */

->TYPE __sig_atomic_t IS NATIVE {__sig_atomic_t} VALUE

/* Seconds since the Epoch, visible to user code when time_t is too
   narrow only for consistency with the old way of widening too-narrow
   types.  User code should never use __time64_t.  */
/*
#if __TIMESIZE == 64 && defined __LIBC
 ->NATIVE {__time64_t} CONST __TIME64_T = TIME_T__
#elif __TIMESIZE != 64

->TYPE #__time64_t IS NATIVE {__time64_t} __TIME64_T_TYPE
#endif
*/
