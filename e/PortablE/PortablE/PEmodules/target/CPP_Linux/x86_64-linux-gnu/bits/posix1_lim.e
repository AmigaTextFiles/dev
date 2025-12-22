OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
/* Get the implementation-specific values for the above.  */
MODULE 'target/x86_64-linux-gnu/bits/local_lim'
{#include <x86_64-linux-gnu/bits/posix1_lim.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

/*
 *	POSIX Standard: 2.9.2 Minimum Values	Added to <limits.h>
 *
 *	Never include this file directly; use <limits.h> instead.
 */

NATIVE {_BITS_POSIX1_LIM_H}	CONST ->_BITS_POSIX1_LIM_H	= 1

/* These are the standard-mandated minimum values.  */

/* Minimum number of operations in one list I/O call.  */
NATIVE {_POSIX_AIO_LISTIO_MAX}	CONST ->_POSIX_AIO_LISTIO_MAX	= 2

/* Minimal number of outstanding asynchronous I/O operations.  */
NATIVE {_POSIX_AIO_MAX}		CONST ->_POSIX_AIO_MAX		= 1

/* Maximum length of arguments to `execve', including environment.  */
NATIVE {_POSIX_ARG_MAX}		CONST ->_POSIX_ARG_MAX		= 4096

/* Maximum simultaneous processes per real user ID.  */
 NATIVE {_POSIX_CHILD_MAX}	CONST ->_POSIX_CHILD_MAX	= 25

/* Minimal number of timer expiration overruns.  */
NATIVE {_POSIX_DELAYTIMER_MAX}	CONST ->_POSIX_DELAYTIMER_MAX	= 32

/* Maximum length of a host name (not including the terminating null)
   as returned from the GETHOSTNAME function.  */
NATIVE {_POSIX_HOST_NAME_MAX}	CONST ->_POSIX_HOST_NAME_MAX	= 255

/* Maximum link count of a file.  */
NATIVE {_POSIX_LINK_MAX}		CONST ->_POSIX_LINK_MAX		= 8

/* Maximum length of login name.  */
NATIVE {_POSIX_LOGIN_NAME_MAX}	CONST ->_POSIX_LOGIN_NAME_MAX	= 9

/* Number of bytes in a terminal canonical input queue.  */
NATIVE {_POSIX_MAX_CANON}	CONST ->_POSIX_MAX_CANON	= 255

/* Number of bytes for which space will be
   available in a terminal input queue.  */
NATIVE {_POSIX_MAX_INPUT}	CONST ->_POSIX_MAX_INPUT	= 255

/* Maximum number of message queues open for a process.  */
NATIVE {_POSIX_MQ_OPEN_MAX}	CONST ->_POSIX_MQ_OPEN_MAX	= 8

/* Maximum number of supported message priorities.  */
NATIVE {_POSIX_MQ_PRIO_MAX}	CONST ->_POSIX_MQ_PRIO_MAX	= 32

/* Number of bytes in a filename.  */
NATIVE {_POSIX_NAME_MAX}		CONST ->_POSIX_NAME_MAX		= 14

/* Number of simultaneous supplementary group IDs per process.  */
 NATIVE {_POSIX_NGROUPS_MAX}	CONST ->_POSIX_NGROUPS_MAX	= 8

/* Number of files one process can have open at once.  */
 NATIVE {_POSIX_OPEN_MAX}	CONST ->_POSIX_OPEN_MAX	= 20

/* Number of descriptors that a process may examine with `pselect' or
   `select'.  */
 NATIVE {_POSIX_FD_SETSIZE}	CONST ->_POSIX_FD_SETSIZE	= _POSIX_OPEN_MAX

/* Number of bytes in a pathname.  */
NATIVE {_POSIX_PATH_MAX}		CONST ->_POSIX_PATH_MAX		= 256

/* Number of bytes than can be written atomically to a pipe.  */
NATIVE {_POSIX_PIPE_BUF}		CONST ->_POSIX_PIPE_BUF		= 512

/* The number of repeated occurrences of a BRE permitted by the
   REGEXEC and REGCOMP functions when using the interval notation.  */
NATIVE {_POSIX_RE_DUP_MAX}	CONST ->_POSIX_RE_DUP_MAX	= 255

/* Minimal number of realtime signals reserved for the application.  */
NATIVE {_POSIX_RTSIG_MAX}	CONST ->_POSIX_RTSIG_MAX	= 8

/* Number of semaphores a process can have.  */
NATIVE {_POSIX_SEM_NSEMS_MAX}	CONST ->_POSIX_SEM_NSEMS_MAX	= 256

/* Maximal value of a semaphore.  */
NATIVE {_POSIX_SEM_VALUE_MAX}	CONST ->_POSIX_SEM_VALUE_MAX	= 32767

/* Number of pending realtime signals.  */
NATIVE {_POSIX_SIGQUEUE_MAX}	CONST ->_POSIX_SIGQUEUE_MAX	= 32

/* Largest value of a `SSIZE_T'.  */
NATIVE {_POSIX_SSIZE_MAX}	CONST ->_POSIX_SSIZE_MAX	= 32767

/* Number of streams a process can have open at once.  */
NATIVE {_POSIX_STREAM_MAX}	CONST ->_POSIX_STREAM_MAX	= 8

/* The number of bytes in a symbolic link.  */
NATIVE {_POSIX_SYMLINK_MAX}	CONST ->_POSIX_SYMLINK_MAX	= 255

/* The number of symbolic links that can be traversed in the
   resolution of a pathname in the absence of a loop.  */
NATIVE {_POSIX_SYMLOOP_MAX}	CONST ->_POSIX_SYMLOOP_MAX	= 8

/* Number of timer for a process.  */
NATIVE {_POSIX_TIMER_MAX}	CONST ->_POSIX_TIMER_MAX	= 32

/* Maximum number of characters in a tty name.  */
NATIVE {_POSIX_TTY_NAME_MAX}	CONST ->_POSIX_TTY_NAME_MAX	= 9

/* Maximum length of a timezone name (element of `tzname').  */
 NATIVE {_POSIX_TZNAME_MAX}	CONST ->_POSIX_TZNAME_MAX	= 6

/* Maximum number of connections that can be queued on a socket.  */
 NATIVE {_POSIX_QLIMIT}		CONST ->_POSIX_QLIMIT		= 1

/* Maximum number of bytes that can be buffered on a socket for send
   or receive.  */
 NATIVE {_POSIX_HIWAT}		CONST ->_POSIX_HIWAT		= _POSIX_PIPE_BUF

/* Maximum number of elements in an `iovec' array.  */
 NATIVE {_POSIX_UIO_MAXIOV}	CONST ->_POSIX_UIO_MAXIOV	= 16

/* Maximum clock resolution in nanoseconds.  */
NATIVE {_POSIX_CLOCKRES_MIN}	CONST ->_POSIX_CLOCKRES_MIN	= 20000000


/* SSIZE_T is not formally required to be the signed type
   corresponding to size_t, but it is for all configurations supported
   by glibc.  */
  NATIVE {SSIZE_MAX}	CONST ->SSIZE_MAX	= LONG_MAX


/* This value is a guaranteed minimum maximum.
   The current maximum can be got from `sysconf'.  */

/*
#ifndef	NGROUPS_MAX
 NATIVE {NGROUPS_MAX}	CONST NGROUPS_MAX	= 8
#endif
*/
