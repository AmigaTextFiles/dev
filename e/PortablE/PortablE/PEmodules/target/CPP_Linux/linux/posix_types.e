OPT NATIVE
MODULE 'std/pUnsigned'
PUBLIC MODULE 'target/x86_64-linux-gnu/asm/posix_types'
{#include <linux/posix_types.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_LINUX_POSIX_TYPES_H} DEF

/*
 * This macro may have been defined in <gnu/types.h>. But we always
 * use the one here.
 */
NATIVE {__FD_SETSIZE} CONST FD_SETSIZE__ = 1024

NATIVE {__kernel_fd_set} OBJECT __kernel_fd_set
	{fds_bits} fds_bits[FD_SETSIZE__ / (8 * SIZEOF LONG)]:ARRAY OF UCLONG
ENDOBJECT

/* Type of a signal handler.  */
->typedef void (*__kernel_sighandler_t)(int);

/* Type of a SYSV IPC key.  */
->TYPE __kernel_key_t IS NATIVE {__kernel_key_t} INT
->TYPE __kernel_mqd_t IS NATIVE {__kernel_mqd_t} INT
