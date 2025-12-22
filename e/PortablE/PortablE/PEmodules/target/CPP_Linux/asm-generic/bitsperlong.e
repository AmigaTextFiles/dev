OPT NATIVE
{#include <asm-generic/bitsperlong.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
->NATIVE {__ASM_GENERIC_BITS_PER_LONG} DEF

/*
 * There seems to be no way of detecting this automatically from user
 * space, so 64 bit architectures should override this in their
 * bitsperlong.h. In particular, an architecture that supports
 * both 32 and 64 bit user space must not rely on CONFIG_64BIT
 * to decide it, but rather check a compiler provided macro.
 */
->NATIVE {__BITS_PER_LONG} CONST __BITS_PER_LONG = 32
