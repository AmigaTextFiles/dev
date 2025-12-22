OPT NATIVE, FORCENATIVE
{#include <sys/errno.h>}
/*
 * $Id: errno.h,v 1.6 2007-08-26 12:30:26 obarthel Exp $
 *
 * :ts=8
 *
 * 'Roadshow' -- Amiga TCP/IP stack
 * Copyright © 2001-2007 by Olaf Barthel.
 * All Rights Reserved.
 *
 * Amiga specific TCP/IP 'C' header files;
 * Freely Distributable
 */

/*
 * Copyright (c) 1982, 1986, 1989, 1993
 *	The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)errno.h	8.5 (Berkeley) 1/21/94
 */

->{int errno=0;}
{#define __NO_NETINCLUDE_ERRNO}
NATIVE {_SYS_ERRNO_H} DEF


NATIVE {errno} DEF ->errno:VALUE /* global error number */

/****************************************************************************/

NATIVE {EPERM}		CONST EPERM		= 1		/* Operation not permitted */
NATIVE {ENOENT}		CONST ENOENT		= 2		/* No such file or directory */
NATIVE {ESRCH}		CONST ESRCH		= 3		/* No such process */
NATIVE {EINTR}		CONST EINTR		= 4		/* Interrupted system call */
NATIVE {EIO}		CONST EIO		= 5		/* Input/output error */
NATIVE {ENXIO}		CONST ENXIO		= 6		/* Device not configured */
NATIVE {E2BIG}		CONST E2BIG		= 7		/* Argument list too long */
NATIVE {ENOEXEC}		CONST ENOEXEC		= 8		/* Exec format error */
NATIVE {EBADF}		CONST EBADF		= 9		/* Bad file descriptor */
NATIVE {ECHILD}		CONST ECHILD		= 10		/* No child processes */
NATIVE {EDEADLK}		CONST EDEADLK		= 11		/* Resource deadlock avoided */
					/* 11 was EAGAIN */
NATIVE {ENOMEM}		CONST ENOMEM		= 12		/* Cannot allocate memory */
NATIVE {EACCES}		CONST EACCES		= 13		/* Permission denied */
NATIVE {EFAULT}		CONST EFAULT		= 14		/* Bad address */
->#ifndef _POSIX_SOURCE
NATIVE {ENOTBLK}		CONST ENOTBLK		= 15		/* Block device required */
->#endif
NATIVE {EBUSY}		CONST EBUSY		= 16		/* Device busy */
NATIVE {EEXIST}		CONST EEXIST		= 17		/* File exists */
NATIVE {EXDEV}		CONST EXDEV		= 18		/* Cross-device link */
NATIVE {ENODEV}		CONST ENODEV		= 19		/* Operation not supported by device */
NATIVE {ENOTDIR}		CONST ENOTDIR		= 20		/* Not a directory */
NATIVE {EISDIR}		CONST EISDIR		= 21		/* Is a directory */
NATIVE {EINVAL}		CONST EINVAL		= 22		/* Invalid argument */
NATIVE {ENFILE}		CONST ENFILE		= 23		/* Too many open files in system */
NATIVE {EMFILE}		CONST EMFILE		= 24		/* Too many open files */
NATIVE {ENOTTY}		CONST ENOTTY		= 25		/* Inappropriate ioctl for device */
->#ifndef _POSIX_SOURCE
NATIVE {ETXTBSY}		CONST ETXTBSY		= 26		/* Text file busy */
->#endif
NATIVE {EFBIG}		CONST EFBIG		= 27		/* File too large */
NATIVE {ENOSPC}		CONST ENOSPC		= 28		/* No space left on device */
NATIVE {ESPIPE}		CONST ESPIPE		= 29		/* Illegal seek */
NATIVE {EROFS}		CONST EROFS		= 30		/* Read-only file system */
NATIVE {EMLINK}		CONST EMLINK		= 31		/* Too many links */
NATIVE {EPIPE}		CONST EPIPE		= 32		/* Broken pipe */

/* math software */
NATIVE {EDOM}		CONST EDOM		= 33		/* Numerical argument out of domain */
NATIVE {ERANGE}		CONST ERANGE		= 34		/* Result too large */

/* non-blocking and interrupt i/o */
NATIVE {EAGAIN}		CONST EAGAIN		= 35		/* Resource temporarily unavailable */
->#ifndef _POSIX_SOURCE
NATIVE {EWOULDBLOCK}	CONST EWOULDBLOCK	= EAGAIN		/* Operation would block */
NATIVE {EINPROGRESS}	CONST EINPROGRESS	= 36		/* Operation now in progress */
NATIVE {EALREADY}	CONST EALREADY	= 37		/* Operation already in progress */

/* ipc/network software -- argument errors */
NATIVE {ENOTSOCK}	CONST ENOTSOCK	= 38		/* Socket operation on non-socket */
NATIVE {EDESTADDRREQ}	CONST EDESTADDRREQ	= 39		/* Destination address required */
NATIVE {EMSGSIZE}	CONST EMSGSIZE	= 40		/* Message too long */
NATIVE {EPROTOTYPE}	CONST EPROTOTYPE	= 41		/* Protocol wrong type for socket */
NATIVE {ENOPROTOOPT}	CONST ENOPROTOOPT	= 42		/* Protocol not available */
NATIVE {EPROTONOSUPPORT}	CONST ENOPROTONOSUPPORT	= 43		/* Protocol not supported */
NATIVE {ESOCKTNOSUPPORT}	CONST ESOCKTNOSUPPORT	= 44		/* Socket type not supported */
NATIVE {EOPNOTSUPP}	CONST EOPNOTSUPP	= 45		/* Operation not supported */
NATIVE {EPFNOSUPPORT}	CONST EPFNOSUPPORT	= 46		/* Protocol family not supported */
NATIVE {EAFNOSUPPORT}	CONST EAFNOSUPPORT	= 47		/* Address family not supported by protocol family */
NATIVE {EADDRINUSE}	CONST EADDRINUSE	= 48		/* Address already in use */
NATIVE {EADDRNOTAVAIL}	CONST EADDRNOTAVAIL	= 49		/* Can't assign requested address */

/* ipc/network software -- operational errors */
NATIVE {ENETDOWN}	CONST ENETDOWN	= 50		/* Network is down */
NATIVE {ENETUNREACH}	CONST ENETUNREACH	= 51		/* Network is unreachable */
NATIVE {ENETRESET}	CONST ENETRESET	= 52		/* Network dropped connection on reset */
NATIVE {ECONNABORTED}	CONST ECONNABORTED	= 53		/* Software caused connection abort */
NATIVE {ECONNRESET}	CONST ECONNRESET	= 54		/* Connection reset by peer */
NATIVE {ENOBUFS}		CONST ENOBUFS		= 55		/* No buffer space available */
NATIVE {EISCONN}		CONST EISCONN		= 56		/* Socket is already connected */
NATIVE {ENOTCONN}	CONST ENOTCONN	= 57		/* Socket is not connected */
NATIVE {ESHUTDOWN}	CONST ESHUTDOWN	= 58		/* Can't send after socket shutdown */
NATIVE {ETOOMANYREFS}	CONST ETOOMANYREFS	= 59		/* Too many references: can't splice */
NATIVE {ETIMEDOUT}	CONST ETIMEDOUT	= 60		/* Operation timed out */
NATIVE {ECONNREFUSED}	CONST ECONNREFUSED	= 61		/* Connection refused */

NATIVE {ELOOP}		CONST ELOOP		= 62		/* Too many levels of symbolic links */
->#endif /* _POSIX_SOURCE */
NATIVE {ENAMETOOLONG}	CONST ENAMETOOLONG	= 63		/* File name too long */

/* should be rearranged */
->#ifndef _POSIX_SOURCE
NATIVE {EHOSTDOWN}	CONST EHOSTDOWN	= 64		/* Host is down */
NATIVE {EHOSTUNREACH}	CONST EHOSTUNREACH	= 65		/* No route to host */
->#endif /* _POSIX_SOURCE */
NATIVE {ENOTEMPTY}	CONST ENOTEMPTY	= 66		/* Directory not empty */

/* quotas & mush */
->#ifndef _POSIX_SOURCE
NATIVE {EPROCLIM}	CONST EPROCLAIM	= 67		/* Too many processes */
NATIVE {EUSERS}		CONST EUSERS		= 68		/* Too many users */
NATIVE {EDQUOT}		CONST EDQUOT		= 69		/* Disc quota exceeded */

/* Network File System */
NATIVE {ESTALE}		CONST ESTALE		= 70		/* Stale NFS file handle */
NATIVE {EREMOTE}		CONST EREMOTE		= 71		/* Too many levels of remote in path */
NATIVE {EBADRPC}		CONST EBADRPC		= 72		/* RPC struct is bad */
NATIVE {ERPCMISMATCH}	CONST ERPCMISMATCH	= 73		/* RPC version wrong */
NATIVE {EPROGUNAVAIL}	CONST EPROGUNAVAIL	= 74		/* RPC prog. not avail */
NATIVE {EPROGMISMATCH}	CONST EPROGMISMATCH	= 75		/* Program version wrong */
NATIVE {EPROCUNAVAIL}	CONST EPROCUNAVAIL	= 76		/* Bad procedure for program */
->#endif /* _POSIX_SOURCE */

NATIVE {ENOLCK}		CONST ENOLCK		= 77		/* No locks available */
NATIVE {ENOSYS}		CONST ENOSYS		= 78		/* Function not implemented */

->#ifndef _POSIX_SOURCE
NATIVE {EFTYPE}		CONST EFTYPE		= 79		/* Inappropriate file type or format */
NATIVE {EAUTH}		CONST EAUTH		= 80		/* Authentication error */
NATIVE {ENEEDAUTH}	CONST ENEEDAUTH	= 81		/* Need authenticator */
NATIVE {ELAST}		CONST ELAST		= 81		/* Must be equal largest errno */
->#endif /* _POSIX_SOURCE */
