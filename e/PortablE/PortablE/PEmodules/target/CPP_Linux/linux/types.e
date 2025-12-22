OPT NATIVE
PUBLIC MODULE 'target/x86_64-linux-gnu/asm/types'
PUBLIC MODULE 'target/linux/posix_types'
{#include <linux/types.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_LINUX_TYPES_H} DEF

/*
 * Below are truly Linux-specific types that should never collide with
 * any application/library that wants linux/types.h.
 */

->TYPE __le16 IS NATIVE {__le16} UINT
->TYPE __be16 IS NATIVE {__be16} UINT
->TYPE __le32 IS NATIVE {__le32} ULONG
->TYPE __be32 IS NATIVE {__be32} ULONG
->TYPE __le64 IS NATIVE {__le64} UBIGVALUE
->TYPE __be64 IS NATIVE {__be64} UBIGVALUE

->TYPE __sum16 IS NATIVE {__sum16} UINT
->TYPE __wsum IS NATIVE {__wsum} ULONG

/*
 * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
 * common 32/64-bit compat problems.
 * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
 * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
 * aligned_64 type enforces 8-byte alignment so that structs containing
 * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
 * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
 */
->#define __aligned_u64 !!UBIGVALUE	->__u64 __attribute__((aligned(8)))
->#define __aligned_be64 !!UBIGVALUE	->__be64 __attribute__((aligned(8)))
->#define __aligned_le64 !!UBIGVALUE	->__le64 __attribute__((aligned(8)))

->TYPE __poll_t IS NATIVE {__poll_t} UINT
