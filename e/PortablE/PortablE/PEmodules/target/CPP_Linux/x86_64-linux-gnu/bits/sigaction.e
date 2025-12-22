OPT NATIVE
MODULE 'target/signal_shared'	->manually added
MODULE 'target/x86_64-linux-gnu/bits/types/__sigset_t'	->guessed
->{#include <x86_64-linux-gnu/bits/sigaction.h>}
/* The proper definitions for Linux's sigaction.
   Copyright (C) 1993-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_SIGACTION_H} CONST ->_BITS_SIGACTION_H = 1

/* Structure describing the action to be taken when a signal arrives.  */
NATIVE {sigaction} OBJECT sigaction
    /* Signal handler.  */
	
	/* Used if SA_SIGINFO is not set.  */
	{__sigaction_handler.sa_handler}	handler	:SIGHANDLER_T__
	/* Used if SA_SIGINFO is set.  */
	{__sigaction_handler.sa_sigaction}	sigaction	:PTR /*void (*sa_sigaction) (int, siginfo_t *, void *)*/

    /* Additional set of signals to be blocked.  */
    {sa_mask}	mask	:__sigset_t

    /* Special flags.  */
    {sa_flags}	flags	:VALUE

    /* Restore handler.  */
    {sa_restorer}	restorer	:PTR /*void (*sa_restorer) (void)*/
  ENDOBJECT
 NATIVE {sa_handler}	CONST ->SA_HANDLER	= __sigaction_handler.sa_handler
 NATIVE {sa_sigaction}	CONST ->SA_SIGACTION	= __sigaction_handler.sa_sigaction

/* Bits in `sa_flags'.  */
NATIVE {SA_NOCLDSTOP}  CONST SA_NOCLDSTOP  = 1		 /* Don't send SIGCHLD when children stop.  */
NATIVE {SA_NOCLDWAIT}  CONST SA_NOCLDWAIT  = 2		 /* Don't create zombie on child death.  */
NATIVE {SA_SIGINFO}    CONST SA_SIGINFO    = 4		 /* Invoke signal-catching function with
				    three arguments instead of one.  */
 NATIVE {SA_ONSTACK}   CONST SA_ONSTACK   = $08000000 /* Use signal stack by using `sa_restorer'. */
 NATIVE {SA_RESTART}   CONST SA_RESTART   = $10000000 /* Restart syscall on signal return.  */
 NATIVE {SA_NODEFER}   CONST SA_NODEFER   = $40000000 /* Don't automatically block the signal when
				    its handler is being executed.  */
 NATIVE {SA_RESETHAND} CONST SA_RESETHAND = $80000000 /* Reset to SIG_DFL on entry to handler.  */
 NATIVE {SA_INTERRUPT} CONST SA_INTERRUPT = $20000000 /* Historical no-op.  */

/* Some aliases for the SA_ constants.  */
 NATIVE {SA_NOMASK}    CONST SA_NOMASK    = SA_NODEFER
 NATIVE {SA_ONESHOT}   CONST SA_ONESHOT   = SA_RESETHAND
 NATIVE {SA_STACK}     CONST SA_STACK     = SA_ONSTACK

/* Values for the HOW argument to `sigprocmask'.  */
NATIVE {SIG_BLOCK}     CONST SIG_BLOCK     = 0		 /* Block signals.  */
NATIVE {SIG_UNBLOCK}   CONST SIG_UNBLOCK   = 1		 /* Unblock signals.  */
NATIVE {SIG_SETMASK}   CONST SIG_SETMASK   = 2		 /* Set the set of blocked signals.  */