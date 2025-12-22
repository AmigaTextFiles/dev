OPT NATIVE
->{#include <x86_64-linux-gnu/bits/signum-generic.h>}
/* Signal number constants.  Generic template.
   Copyright (C) 1991-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_SIGNUM_GENERIC_H} CONST ->_BITS_SIGNUM_GENERIC_H = 1

/* Fake signal functions.  */

NATIVE {SIG_ERR}	 CONST SIG_ERR	 = -1/*!!SIGHANDLER_T__*/	/* Error return.  */
NATIVE {SIG_DFL}	 CONST SIG_DFL	 =  0/*!!SIGHANDLER_T__*/	/* Default action.  */
NATIVE {SIG_IGN}	 CONST SIG_IGN	 =  1/*!!SIGHANDLER_T__*/	/* Ignore signal.  */

 NATIVE {SIG_HOLD} CONST SIG_HOLD = 2/*!!SIGHANDLER_T__*/	/* Add signal to hold mask.  */

/* We define here all the signal names listed in POSIX (1003.1-2008);
   as of 1003.1-2013, no additional signals have been added by POSIX.
   We also define here signal names that historically exist in every
   real-world POSIX variant (e.g. SIGWINCH).

   Signals in the 1-15 range are defined with their historical numbers.
   For other signals, we use the BSD numbers.
   There are two unallocated signal numbers in the 1-31 range: 7 and 29.
   Signal number 0 is reserved for use as kill(pid, 0), to test whether
   a process exists without sending it a signal.  */

/* ISO C99 signals.  */
NATIVE {SIGINT}		CONST SIGINT		= 2	/* Interactive attention signal.  */
NATIVE {SIGILL}		CONST SIGILL		= 4	/* Illegal instruction.  */
NATIVE {SIGABRT}		CONST SIGABRT		= 6	/* Abnormal termination.  */
NATIVE {SIGFPE}		CONST SIGFPE		= 8	/* Erroneous arithmetic operation.  */
NATIVE {SIGSEGV}		CONST SIGSEGV		= 11	/* Invalid access to storage.  */
NATIVE {SIGTERM}		CONST SIGTERM		= 15	/* Termination request.  */

/* Historical signals specified by POSIX. */
NATIVE {SIGHUP}		CONST SIGHUP		= 1	/* Hangup.  */
NATIVE {SIGQUIT}		CONST SIGQUIT		= 3	/* Quit.  */
NATIVE {SIGTRAP}		CONST SIGTRAP		= 5	/* Trace/breakpoint trap.  */
NATIVE {SIGKILL}		CONST SIGKILL		= 9	/* Killed.  */
NATIVE {SIGBUS}		CONST SIGBUS		= 10	/* Bus error.  */
NATIVE {SIGSYS}		CONST SIGSYS		= 12	/* Bad system call.  */
NATIVE {SIGPIPE}		CONST SIGPIPE		= 13	/* Broken pipe.  */
NATIVE {SIGALRM}		CONST SIGALRM		= 14	/* Alarm clock.  */

/* New(er) POSIX signals (1003.1-2008, 1003.1-2013).  */
NATIVE {SIGURG}		CONST SIGURG		= 16	/* Urgent data is available at a socket.  */
NATIVE {SIGSTOP}		CONST SIGSTOP		= 17	/* Stop, unblockable.  */
NATIVE {SIGTSTP}		CONST SIGTSTP		= 18	/* Keyboard stop.  */
NATIVE {SIGCONT}		CONST SIGCONT		= 19	/* Continue.  */
NATIVE {SIGCHLD}		CONST SIGCHLD		= 20	/* Child terminated or stopped.  */
NATIVE {SIGTTIN}		CONST SIGTTIN		= 21	/* Background read from control terminal.  */
NATIVE {SIGTTOU}		CONST SIGTTOU		= 22	/* Background write to control terminal.  */
NATIVE {SIGPOLL}		CONST SIGPOLL		= 23	/* Pollable event occurred (System V).  */
NATIVE {SIGXCPU}		CONST SIGXCPU		= 24	/* CPU time limit exceeded.  */
NATIVE {SIGXFSZ}		CONST SIGXFSZ		= 25	/* File size limit exceeded.  */
NATIVE {SIGVTALRM}	CONST SIGVTALRM	= 26	/* Virtual timer expired.  */
NATIVE {SIGPROF}		CONST SIGPROF		= 27	/* Profiling timer expired.  */
NATIVE {SIGUSR1}		CONST SIGUSR1		= 30	/* User-defined signal 1.  */
NATIVE {SIGUSR2}		CONST SIGUSR2		= 31	/* User-defined signal 2.  */

/* Nonstandard signals found in all modern POSIX systems
   (including both BSD and Linux).  */
NATIVE {SIGWINCH}	CONST SIGWINCH	= 28	/* Window size change (4.3 BSD, Sun).  */

/* Archaic names for compatibility.  */
NATIVE {SIGIO}		CONST SIGIO		= SIGPOLL	/* I/O now possible (4.2 BSD).  */
NATIVE {SIGIOT}		CONST SIGIOT		= SIGABRT	/* IOT instruction, abort() on a PDP-11.  */
NATIVE {SIGCLD}		CONST SIGCLD		= 20	->SIGCHLD	/* Old System V name */

/* Not all systems support real-time signals.  bits/signum.h indicates
   that they are supported by overriding __SIGRTMAX to a value greater
   than __SIGRTMIN.  These constants give the kernel-level hard limits,
   but some real-time signals may be used internally by glibc.  Do not
   use these constants in application code; use SIGRTMIN and SIGRTMAX
   (defined in signal.h) instead.  */

NATIVE {__SIGRTMIN}	CONST SIGRTMIN__	= 32
NATIVE {__SIGRTMAX}	CONST SIGRTMAX__	= SIGRTMIN__

/* Biggest signal number + 1 (including real-time signals).  */
NATIVE {_NSIG}		CONST NSIG_		= (SIGRTMAX__ + 1)
