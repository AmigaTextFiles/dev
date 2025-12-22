OPT NATIVE
/* The kernel sources contain a file with all the needed information.  */
MODULE 'target/linux/limits'
{#include <x86_64-linux-gnu/bits/local_lim.h>}
/* Minimum guaranteed maximum values for system limits.  Linux version.
   Copyright (C) 1993-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If
   not, see <https://www.gnu.org/licenses/>.  */

/* The kernel header pollutes the namespace with the NR_OPEN symbol
   and defines LINK_MAX although filesystems have different maxima.  A
   similar thing is true for OPEN_MAX: the limit can be changed at
   runtime and therefore the macro must not be defined.  Remove this
   after including the header if necessary.  */
 ->NATIVE {__undef_NR_OPEN} DEF
 ->NATIVE {__undef_LINK_MAX} DEF
 ->NATIVE {__undef_OPEN_MAX} DEF
 ->NATIVE {__undef_ARG_MAX} DEF

/* The number of data keys per process.  */
NATIVE {_POSIX_THREAD_KEYS_MAX}	CONST ->_POSIX_THREAD_KEYS_MAX	= 128
/* This is the value this implementation supports.  */
NATIVE {PTHREAD_KEYS_MAX}	CONST PTHREAD_KEYS_MAX	= 1024

/* Controlling the iterations of destructors for thread-specific data.  */
NATIVE {_POSIX_THREAD_DESTRUCTOR_ITERATIONS}	CONST ->_POSIX_THREAD_DESTRUCTOR_ITERATIONS	= 4
/* Number of iterations this implementation does.  */
NATIVE {PTHREAD_DESTRUCTOR_ITERATIONS}	CONST ->PTHREAD_DESTRUCTOR_ITERATIONS	= _POSIX_THREAD_DESTRUCTOR_ITERATIONS

/* The number of threads per process.  */
NATIVE {_POSIX_THREAD_THREADS_MAX}	CONST ->_POSIX_THREAD_THREADS_MAX	= 64
/* We have no predefined limit on the number of threads.  */

/* Maximum amount by which a process can descrease its asynchronous I/O
   priority level.  */
NATIVE {AIO_PRIO_DELTA_MAX}	CONST AIO_PRIO_DELTA_MAX	= 20

/* Minimum size for a thread.  We are free to choose a reasonable value.  */
NATIVE {PTHREAD_STACK_MIN}	CONST PTHREAD_STACK_MIN	= 16384

/* Maximum number of timer expiration overruns.  */
NATIVE {DELAYTIMER_MAX}	CONST DELAYTIMER_MAX	= 2147483647

/* Maximum tty name length.  */
NATIVE {TTY_NAME_MAX}		CONST TTY_NAME_MAX		= 32

/* Maximum login name length.  This is arbitrary.  */
NATIVE {LOGIN_NAME_MAX}		CONST LOGIN_NAME_MAX		= 256

/* Maximum host name length.  */
NATIVE {HOST_NAME_MAX}		CONST HOST_NAME_MAX		= 64

/* Maximum message queue priority level.  */
NATIVE {MQ_PRIO_MAX}		CONST MQ_PRIO_MAX		= 32768

/* Maximum value the semaphore can have.  */
NATIVE {SEM_VALUE_MAX}   CONST SEM_VALUE_MAX   = 2147483647
