OPT NATIVE
MODULE 'std/pUnsigned'
{#include <asm-generic/int-ll64.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
/*
 * asm-generic/int-ll64.h
 *
 * Integer declarations for architectures which use "long long"
 * for 64-bit types.
 */

NATIVE {_ASM_GENERIC_INT_LL64_H} DEF

/*
 * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
 * header files exported to user space
 */

TYPE S8__ IS NATIVE {__s8} CHAR
->TYPE U8__ IS NATIVE {__u8} UCHAR	->this really requires using CharToUnsigned() & UnsignedToChar() for conversion (rather than just casting)

TYPE S16__ IS NATIVE {__s16} INT
TYPE U16__ IS NATIVE {__u16} UINT

TYPE S32__ IS NATIVE {__s32} LONG	->or VALUE?
TYPE U32__ IS NATIVE {__u32} ULONG

TYPE S64__ IS NATIVE {__s64} BIGVALUE
TYPE U64__ IS NATIVE {__u64} UBIGVALUE
