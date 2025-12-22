OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/asm/bitsperlong'
->{#include <asm-generic/posix_types.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
->NATIVE {__ASM_GENERIC_POSIX_TYPES_H} DEF

/*
 * This file is generally used by user-level software, so you need to
 * be a little careful about namespace pollution etc.
 *
 * First the types that are often defined in different ways across
 * architectures, so that you can override them.
 */

TYPE KERNEL_LONG_T__ IS NATIVE {__kernel_long_t} CLONG
TYPE KERNEL_ULONG_T__ IS NATIVE {__kernel_ulong_t} UCLONG

->TYPE __kernel_ino_t IS NATIVE {__kernel_ino_t} KERNEL_ULONG_T__

->TYPE __kernel_mode_t IS NATIVE {__kernel_mode_t} ULONG

TYPE KERNEL_PID_T__ IS NATIVE {__kernel_pid_t} VALUE

->TYPE __kernel_ipc_pid_t IS NATIVE {__kernel_ipc_pid_t} VALUE

->TYPE __kernel_uid_t IS NATIVE {__kernel_uid_t} ULONG
->TYPE __kernel_gid_t IS NATIVE {__kernel_gid_t} ULONG

TYPE KERNEL_SUSECONDS_T__ IS NATIVE {__kernel_suseconds_t} KERNEL_LONG_T__

->TYPE __kernel_daddr_t IS NATIVE {__kernel_daddr_t} VALUE

TYPE KERNEL_UID32_T__ IS NATIVE {__kernel_uid32_t} ULONG
->TYPE __kernel_gid32_t IS NATIVE {__kernel_gid32_t} ULONG

->TYPE __kernel_old_uid_t IS NATIVE {__kernel_old_uid_t} __kernel_uid_t
->TYPE __kernel_old_gid_t IS NATIVE {__kernel_old_gid_t} __kernel_gid_t

->TYPE __kernel_old_dev_t IS NATIVE {__kernel_old_dev_t} ULONG

/*
 * Most 32 bit architectures use "unsigned int" size_t,
 * and all 64 bit architectures use "unsigned long" size_t.
 */
->TYPE __kernel_size_t IS NATIVE {__kernel_size_t} KERNEL_ULONG_T__
->TYPE __kernel_ssize_t IS NATIVE {__kernel_ssize_t} KERNEL_LONG_T__
->TYPE __kernel_ptrdiff_t IS NATIVE {__kernel_ptrdiff_t} KERNEL_LONG_T__

/*
NATIVE {__kernel_fsid_t} OBJECT __kernel_fsid_t
	{val} val[2]:ARRAY OF INT
ENDOBJECT
*/

/*
 * anything below here should be completely generic
 */

->TYPE __kernel_off_t IS NATIVE {__kernel_off_t} KERNEL_LONG_T__

->TYPE __kernel_loff_t IS NATIVE {__kernel_loff_t} BIGVALUE

->TYPE __kernel_time_t IS NATIVE {__kernel_time_t} KERNEL_LONG_T__

->TYPE __kernel_time64_t IS NATIVE {__kernel_time64_t} BIGVALUE

TYPE KERNEL_CLOCK_T__ IS NATIVE {__kernel_clock_t} KERNEL_LONG_T__

TYPE KERNEL_TIMER_T__ IS NATIVE {__kernel_timer_t} VALUE

->TYPE __kernel_clockid_t IS NATIVE {__kernel_clockid_t} VALUE

->TYPE __kernel_caddr_t IS NATIVE {__kernel_caddr_t} ARRAY OF CHAR

->TYPE __kernel_uid16_t IS NATIVE {__kernel_uid16_t} UINT

->TYPE __kernel_gid16_t IS NATIVE {__kernel_gid16_t} UINT
