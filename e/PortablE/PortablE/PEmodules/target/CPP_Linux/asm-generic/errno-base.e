OPT NATIVE
{#include <asm-generic/errno-base.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_ASM_GENERIC_ERRNO_BASE_H} DEF

NATIVE {EPERM}		 CONST EPERM		 = 1	/* Operation not permitted */
NATIVE {ENOENT}		 CONST ENOENT		 = 2	/* No such file or directory */
NATIVE {ESRCH}		 CONST ESRCH		 = 3	/* No such process */
NATIVE {EINTR}		 CONST EINTR		 = 4	/* Interrupted system call */
NATIVE {EIO}		 CONST EIO		 = 5	/* I/O error */
NATIVE {ENXIO}		 CONST ENXIO		 = 6	/* No such device or address */
NATIVE {E2BIG}		 CONST E2BIG		 = 7	/* Argument list too long */
NATIVE {ENOEXEC}		 CONST ENOEXEC		 = 8	/* Exec format error */
NATIVE {EBADF}		 CONST EBADF		 = 9	/* Bad file number */
NATIVE {ECHILD}		CONST ECHILD		= 10	/* No child processes */
NATIVE {EAGAIN}		CONST EAGAIN		= 11	/* Try again */
NATIVE {ENOMEM}		CONST ENOMEM		= 12	/* Out of memory */
NATIVE {EACCES}		CONST EACCES		= 13	/* Permission denied */
NATIVE {EFAULT}		CONST EFAULT		= 14	/* Bad address */
NATIVE {ENOTBLK}		CONST ENOTBLK		= 15	/* Block device required */
NATIVE {EBUSY}		CONST EBUSY		= 16	/* Device or resource busy */
NATIVE {EEXIST}		CONST EEXIST		= 17	/* File exists */
NATIVE {EXDEV}		CONST EXDEV		= 18	/* Cross-device link */
NATIVE {ENODEV}		CONST ENODEV		= 19	/* No such device */
NATIVE {ENOTDIR}		CONST ENOTDIR		= 20	/* Not a directory */
NATIVE {EISDIR}		CONST EISDIR		= 21	/* Is a directory */
NATIVE {EINVAL}		CONST EINVAL		= 22	/* Invalid argument */
NATIVE {ENFILE}		CONST ENFILE		= 23	/* File table overflow */
NATIVE {EMFILE}		CONST EMFILE		= 24	/* Too many open files */
NATIVE {ENOTTY}		CONST ENOTTY		= 25	/* Not a typewriter */
NATIVE {ETXTBSY}		CONST ETXTBSY		= 26	/* Text file busy */
NATIVE {EFBIG}		CONST EFBIG		= 27	/* File too large */
NATIVE {ENOSPC}		CONST ENOSPC		= 28	/* No space left on device */
NATIVE {ESPIPE}		CONST ESPIPE		= 29	/* Illegal seek */
NATIVE {EROFS}		CONST EROFS		= 30	/* Read-only file system */
NATIVE {EMLINK}		CONST EMLINK		= 31	/* Too many links */
NATIVE {EPIPE}		CONST EPIPE		= 32	/* Broken pipe */
NATIVE {EDOM}		CONST EDOM		= 33	/* Math argument out of domain of func */
NATIVE {ERANGE}		CONST ERANGE		= 34	/* Math result not representable */
