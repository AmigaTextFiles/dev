OPT NATIVE
PUBLIC MODULE 'target/asm-generic/posix_types'
{#include <x86_64-linux-gnu/asm/posix_types_64.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_ASM_X86_POSIX_TYPES_64_H} DEF

/*
 * This file is generally used by user-level software, so you need to
 * be a little careful about namespace pollution etc.  Also, we cannot
 * assume GCC is being used.
 */


->TYPE __kernel_old_uid_t IS NATIVE {__kernel_old_uid_t} UINT

->TYPE __kernel_old_gid_t IS NATIVE {__kernel_old_gid_t} UINT
->NATIVE {__kernel_old_uid_t} CONST __KERNEL_OLD_UID_T = __kernel_old_uid_t


->TYPE __kernel_old_dev_t IS NATIVE {__kernel_old_dev_t} UCLONG
->NATIVE {__kernel_old_dev_t} CONST __KERNEL_OLD_DEV_T = __kernel_old_dev_t
