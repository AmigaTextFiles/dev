OPT NATIVE
MODULE 'target/asm-generic/bitsperlong'
{#include <x86_64-linux-gnu/asm/bitsperlong.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
->NATIVE {__ASM_X86_BITSPERLONG_H} DEF

 ->NATIVE {__BITS_PER_LONG} CONST #__BITS_PER_LONG = 32
