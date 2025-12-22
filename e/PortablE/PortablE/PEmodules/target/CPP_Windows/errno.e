OPT NATIVE, FORCENATIVE
MODULE 'target/_mingw'
{#include <errno.h>}
/* 
 * errno.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Error numbers and access to error reporting.
 *
 */

NATIVE {_ERRNO_H_} DEF

/* All the headers include this file. */

/*
 * Error numbers.
 * TODO: Can't be sure of some of these assignments, I guessed from the
 * names given by strerror and the defines in the Cygnus errno.h. A lot
 * of the names from the Cygnus errno.h are not represented, and a few
 * of the descriptions returned by strerror do not obviously match
 * their error naming.
 */
NATIVE {EPERM}		CONST EPERM		= 1	/* Operation not permitted */
NATIVE {ENOFILE}		CONST ENOFILE		= 2	/* No such file or directory */
NATIVE {ENOENT}		CONST ENOENT		= 2
NATIVE {ESRCH}		CONST ESRCH		= 3	/* No such process */
NATIVE {EINTR}		CONST EINTR		= 4	/* Interrupted function call */
NATIVE {EIO}		CONST EIO		= 5	/* Input/output error */
NATIVE {ENXIO}		CONST ENXIO		= 6	/* No such device or address */
NATIVE {E2BIG}		CONST E2BIG		= 7	/* Arg list too long */
NATIVE {ENOEXEC}		CONST ENOEXEC		= 8	/* Exec format error */
NATIVE {EBADF}		CONST EBADF		= 9	/* Bad file descriptor */
NATIVE {ECHILD}		CONST ECHILD		= 10	/* No child processes */
NATIVE {EAGAIN}		CONST EAGAIN		= 11	/* Resource temporarily unavailable */
NATIVE {ENOMEM}		CONST ENOMEM		= 12	/* Not enough space */
NATIVE {EACCES}		CONST EACCES		= 13	/* Permission denied */
NATIVE {EFAULT}		CONST EFAULT		= 14	/* Bad address */
/* 15 - Unknown Error */
NATIVE {EBUSY}		CONST EBUSY		= 16	/* strerror reports "Resource device" */
NATIVE {EEXIST}		CONST EEXIST		= 17	/* File exists */
NATIVE {EXDEV}		CONST EXDEV		= 18	/* Improper link (cross-device link?) */
NATIVE {ENODEV}		CONST ENODEV		= 19	/* No such device */
NATIVE {ENOTDIR}		CONST ENOTDIR		= 20	/* Not a directory */
NATIVE {EISDIR}		CONST EISDIR		= 21	/* Is a directory */
NATIVE {EINVAL}		CONST EINVAL		= 22	/* Invalid argument */
NATIVE {ENFILE}		CONST ENFILE		= 23	/* Too many open files in system */
NATIVE {EMFILE}		CONST EMFILE		= 24	/* Too many open files */
NATIVE {ENOTTY}		CONST ENOTTY		= 25	/* Inappropriate I/O control operation */
/* 26 - Unknown Error */
NATIVE {EFBIG}		CONST EFBIG		= 27	/* File too large */
NATIVE {ENOSPC}		CONST ENOSPC		= 28	/* No space left on device */
NATIVE {ESPIPE}		CONST ESPIPE		= 29	/* Invalid seek (seek on a pipe?) */
NATIVE {EROFS}		CONST EROFS		= 30	/* Read-only file system */
NATIVE {EMLINK}		CONST EMLINK		= 31	/* Too many links */
NATIVE {EPIPE}		CONST EPIPE		= 32	/* Broken pipe */
NATIVE {EDOM}		CONST EDOM		= 33	/* Domain error (math functions) */
NATIVE {ERANGE}		CONST ERANGE		= 34	/* Result too large (possibly too small) */
/* 35 - Unknown Error */
NATIVE {EDEADLOCK}	CONST EDEADLOCK	= 36	/* Resource deadlock avoided (non-Cyg) */
NATIVE {EDEADLK}		CONST EDEADLK		= 36
/* 37 - Unknown Error */
NATIVE {ENAMETOOLONG}	CONST ENAMETOOLONG	= 38	/* Filename too long (91 in Cyg?) */
NATIVE {ENOLCK}		CONST ENOLCK		= 39	/* No locks available (46 in Cyg?) */
NATIVE {ENOSYS}		CONST ENOSYS		= 40	/* Function not implemented (88 in Cyg?) */
NATIVE {ENOTEMPTY}	CONST ENOTEMPTY	= 41	/* Directory not empty (90 in Cyg?) */
NATIVE {EILSEQ}		CONST EILSEQ		= 42	/* Illegal byte sequence */

/*
 * NOTE: ENAMETOOLONG and ENOTEMPTY conflict with definitions in the
 *       sockets.h header provided with windows32api-0.1.2.
 *       You should go and put an #if 0 ... #endif around the whole block
 *       of errors (look at the comment above them).
 */


/*
 * Definitions of errno. For _doserrno, sys_nerr and * sys_errlist, see
 * stdlib.h.
 */
NATIVE {errno} DEF errno
